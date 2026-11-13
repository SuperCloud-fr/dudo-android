import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'salon_models.dart';
import 'salon_system_strings.dart';

/// Raised when the edge refuses a salon creation (429 + retry-after).
class SalonRequestThrottled implements Exception {
  SalonRequestThrottled(this.retryAfter);

  final int retryAfter;

  @override
  String toString() => ' SalonRequestThrottled($retryAfter)';
}

/// Client mirror of the Worker's chat bucket: a burst of 3 then one
/// message per second. Chat and reactions share the same bucket there,
/// and 3 refusals evict the socket (1008), so the app must pace itself
/// and say so.
mixin _ChatBucket {
  static const _capacity = 3;
  static const _refillPerSecond = 1.0;

  double _tokens = _capacity.toDouble();
  DateTime _lastTick = DateTime.now();
  int _remainingWait = 1;

  bool _spendChat() {
    final now = DateTime.now();
    final elapsed = now.difference(_lastTick).inMilliseconds / 1000.0;
    final tokens = _tokens + elapsed * _refillPerSecond;
    _lastTick = now;
    if (tokens >= 1) {
      // Spend the token AFTER capping the free refill at capacity.
      _tokens = (tokens > _capacity ? _capacity.toDouble() : tokens) - 1;
      return true;
    }
    _tokens = tokens;
    final wait = (1 - tokens).ceil();
    _remainingWait = wait < 1 ? 1 : wait;
    return false;
  }

  int get _chatWait => _remainingWait;
}

/// A `game` or `snapshot` payload relayed by the Worker from the host
/// (host-authoritative play). Every client replays it locally.
@immutable
class RelayedTableMessage {
  const RelayedTableMessage({
    required this.kind,
    required this.fromSeat,
    required this.payload,
  });

  final String kind;
  final int fromSeat;
  final Object? payload;
}

/// The Worker renames a mid-game dropper to `Name (à l'eau)` and keeps the
/// seat reclaimable; the app reads this marker to know the engine's owner
/// is gone. Kept byte-identical to the Worker's string (U+00E0, U+2019).
const String _awayMarker = ' (\u00e0 l\u2019eau)';

/// Live multiplayer session against the Cloudflare Worker (dudo-worker repo).
///
/// The Worker lobby is authoritative: code generation, seats and crew are
/// broadcast by the Durable Object. The game itself stays host-authoritative:
/// the host's phone runs the engine and broadcasts payloads that are
/// re-emitted on [tableEvents] for the game screen wiring.
///
/// Candidate hosts ([baseUrls]) are tried in order; the first one whose
/// handshake completes wins and is remembered in [activeBaseUrl], so the
/// app keeps working while a candidate is offline. Since 2026-11 the
/// Worker serves the site and the API on dudo.supercloud.fr and the old
/// api.* host no longer resolves.
class NetworkSalonSession extends SalonSession
    with _ChatBucket, WidgetsBindingObserver
    implements SalonBackend {
  NetworkSalonSession({
    List<String>? baseUrls,
    this.createSalonCode,
    this.channelFactory,
    this.handshakeTimeout = const Duration(seconds: 8),
    this.reconnectDelay = const Duration(milliseconds: 1200),
    this.livenessStroke = const Duration(seconds: 75),
    this.livenessTick = const Duration(seconds: 5),
    this.outboundPingInterval = const Duration(seconds: 15),
  }) : baseUrls = List<String>.unmodifiable(baseUrls ?? defaultBaseUrls) {
    // Phone sleep cuts the WS; observe the lifecycle so a locked screen
    // suspends the recovery machinery and an unlock reconnects ONCE with
    // a plain sentence instead of a failure loop.
    WidgetsBinding.instance.addObserver(this);
    // The server pings every 20s; we answer pong (outbound keepalive) and
    // watch inbound silence: a dead flow gets closed and recovered instead
    // of letting bids travel into the void.
    _watchdog = Timer.periodic(livenessTick, (_) {
      _checkLiveness();
    });
    // Outbound pings: the server answers (auto-pong, hibernation-safe).
    // Answered pongs are just frames to _lastServerFrame, so the watchdog
    // reads them as proof of life — the client proves the flow each beat.
    _outboundPing = Timer.periodic(outboundPingInterval, (_) {
      if (_disposed || _appSuspended || _channel == null) return;
      _sendJson(const <String, dynamic>{'type': 'ping'});
    });
  }

  static const List<String> defaultBaseUrls = ['https://dudo.supercloud.fr'];

  final List<String> baseUrls;

  /// The server whose handshake worked; null until the first connection.
  String? activeBaseUrl;

  /// Injectable "open a salon" (POST {base}/salons) for tests.
  final Future<String?> Function(String base, String hostName)? createSalonCode;

  /// Injectable WebSocket factory for tests.
  final WebSocketChannel Function(Uri uri)? channelFactory;

  /// How long each handshake attempt waits before trying the next host.
  final Duration handshakeTimeout;

  /// Pause before trying to re-establish a dropped socket.
  final Duration reconnectDelay;

  /// Worker-side seat of this device, set when the salon state lands.
  int you = -1;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _frames;
  Completer<SalonJoinResult>? _joinCompleter;
  Completer<void>? _startCompleter;
  bool _closedByServer = false;

  /// Host-side intent "this round is over" that must survive a dead socket:
  /// replayed until the Worker echoes `started=false` (see sendGameOver).
  bool _gameOverPending = false;

  int _messageSequence = 0;
  final Set<String> _seenMessageIds = <String>{};
  final Queue<String> _messageIdOrder = Queue<String>();

  @override
  void resetThread() {
    _seenMessageIds.clear();
    _messageIdOrder.clear();
    super.resetThread();
  }

  /// True from the moment Android freezes the app (screen locked) to its
  /// resume, so socket losses during the doze stay silent here and the
  /// resume tells the story once, in one sentence.
  bool _appSuspended = false;

  /// Last frame the server sent us, any kind included. The watchdog reads
  /// it: a silent socket (no pong, no chat, no table) for a minute means
  /// the flow died without a close frame - close it and recover properly.
  DateTime _lastServerFrame = DateTime.now();

  /// Silence threshold and cadence of the watchdog; overridable so tests
  /// do not need 75 real seconds to prove a dead flow gets recovered.
  final Duration livenessStroke;
  final Duration livenessTick;

  /// Outbound keepalive cadence. The server also pings, but with the
  /// hibernation-safe auto-pong the INBOUND proof of life is our own
  /// outbound ping answered; this keeps both sides honest.
  final Duration outboundPingInterval;

  /// Periodic liveness check; also the client half of the keepalive: our
  /// pongs back to the server's pings keep the flow alive through NATs.
  Timer? _watchdog;

  /// Outbound keepalive pings (server answers with the auto-pong pair).
  Timer? _outboundPing;

  /// Grows between failed recovery attempts so an unreachable salon stops
  /// hammering the network; reset on each success.
  int _recoveryFailures = 0;

  /// One retry at a time: both the close event and the failed handshake
  /// can race to schedule the next one, the flag keeps exactly one.
  bool _recoveryScheduled = false;
  bool _disposed = false;
  bool _recovering = false;
  Timer? _recoveryTimer;

  final StreamController<RelayedTableMessage> _tableEvents =
      StreamController<RelayedTableMessage>.broadcast();

  /// Host-relayed game payloads, keyed by kind (`game` or `snapshot`).
  Stream<RelayedTableMessage> get tableEvents => _tableEvents.stream;

  bool get connected => _channel != null;

  /// Sends a host-authoritative payload (bid, dudo, calza, nextRound,
  /// rematch). Used by the guests; [HostGameRelay] broadcasts big snapshots
  /// with [sendSnapshot].
  void sendGame(Map<String, dynamic> payload) {
    _sendJson(<String, dynamic>{'type': 'game', 'payload': payload});
  }

  /// Sends a full table snapshot (host side only).
  void sendSnapshot(Map<String, dynamic> payload) {
    _sendJson(<String, dynamic>{'type': 'snapshot', 'payload': payload});
  }

  /// Host only: announces the game is over so the Worker reopens the salon
  /// (lobby) — otherwise its `started` flag stays true forever and any new
  /// phone gets refused with "La partie a d\u00e9j\u00e0 commenc\u00e9e".
  ///
  /// The socket may be dead when this fires (quit while the phone was
  /// dozing): the frame would vanish into the void. The intent is kept and
  /// replayed on every fresh salon state until the Worker answers with a
  /// `started=false` echo — see [_applySalonState].
  void sendGameOver() {
    if (role != SalonRole.host) return;
    _gameOverPending = true;
    _sendJson(const <String, dynamic>{'type': 'gameOver'});
  }

  @override
  Iterable<int> get awaySeats sync* {
    if (!isStarting) return;
    for (final player in players) {
      if (player.name.endsWith(_awayMarker)) yield player.seat;
    }
  }

  // -------------------------------------------------------------- creation

  @override
  Future<void> createSalon(String host, int bots) async {
    role = SalonRole.host;
    botCount = bots.clamp(0, 5);
    hostName = host;
    myName = host;
    code = '';
    players.clear();
    isStarting = false;
    hostGone = false;
    _gameOverPending = false;
    // A fresh table starts a clean thread, even when no server answers.
    resetThread();
    notifyListeners();

    String? lastFailure;
    final wanted = botCount;
    for (final base in baseUrls) {
      try {
        if (await _openSalon(base, host, wanted)) return;
      } catch (error) {
        if (error is SalonRequestThrottled) {
          pushSystemMessage(SalonSystem.throttledCreate(error.retryAfter));
          return;
        }
        lastFailure = error.toString();
      }
    }
    code = '';
    activeBaseUrl = null;
    pushSystemMessage(
      SalonSystem.createFailed(lastFailure == null ? '' : ' ($lastFailure)'),
    );
  }

  Future<bool> _openSalon(String base, String host, int botWanted) async {
    final hook = createSalonCode;
    final openedCode = hook != null
        ? await hook(base, host)
        : await _postSalonCode(base, host);
    if (openedCode == null) return false;
    code = openedCode.toUpperCase();
    final result = await _attemptHandshake(base, host);
    if (!result.ok) return false;
    activeBaseUrl = base;
    _sendBots(botWanted);
    pushSystemMessage(SalonSystem.created(code));
    return true;
  }

  Future<String?> _postSalonCode(String base, String host) async {
    final client = HttpClient()..connectionTimeout = handshakeTimeout;
    try {
      // API v1 (2026-11): the Worker keeps /salons as a legacy alias; the
      // app speaks the versioned surface. A 429 carries retry-after.
      final request = await client
          .postUrl(Uri.parse('$base/api/v1/salons'))
          .timeout(handshakeTimeout);
      request.headers
        ..set(HttpHeaders.contentTypeHeader, 'application/json')
        ..set(HttpHeaders.acceptHeader, 'application/json');
      request.write(jsonEncode({'name': host}));
      final response = await request.close().timeout(handshakeTimeout);
      if (response.statusCode == 429) {
        // The edge protects creation per IP; surface the wait instead of
        // blindly hammering the other hosts.
        final waitRaw = response.headers.value(HttpHeaders.retryAfterHeader);
        final wait = int.tryParse(waitRaw ?? '') ?? 1;
        throw SalonRequestThrottled(wait);
      }
      if (response.statusCode != 201) {
        return null;
      }
      final body = jsonDecode(
        await response.transform(utf8.decoder).join(),
      ) as Map<String, dynamic>;
      final codeValue = body['code'];
      return codeValue is String && codeValue.length == 6 ? codeValue : null;
    } finally {
      client.close();
    }
  }

  // --------------------------------------------------------------- joining

  @override
  Future<SalonJoinResult> joinSalon(String joinCode, String guest) async {
    final cleaned = joinCode.trim().toUpperCase();
    final allowed = RegExp('^[${SalonSession.alphabet}]{6}\$');
    if (!allowed.hasMatch(cleaned)) {
      return SalonJoinResult(ok: false, message: SalonSystem.sixChars);
    }

    role = SalonRole.guest;
    hostName = '';
    myName = guest;
    code = cleaned;
    players.clear();
    isStarting = false;
    hostGone = false;
    _gameOverPending = false;
    // A new table starts a clean thread (recovery never goes through here).
    resetThread();
    notifyListeners();

    String? refusal;
    for (final base in baseUrls) {
      try {
        final result = await _attemptHandshake(base, guest);
        if (result.ok) {
          activeBaseUrl = base;
          pushSystemMessage(SalonSystem.connectedTab(code));
          return result;
        }
        // A firm answer from a reachable server (salon complet, partie
        // en cours…) ends the search; only an empty failure means the
        // server never answered and we try the next one.
        if (result.message != null) return result;
      } catch (error) {
        refusal = error.toString();
      }
    }
    return SalonJoinResult(
      ok: false,
      message:
          'Salon injoignable pour l\u2019instant.'
          '${refusal == null ? '' : ' ($refusal)'}',
    );
  }

  /// Opens the WebSocket, sends the join frame and waits for the first
  /// server answer. Returns sans message when nothing came in time.
  Future<SalonJoinResult> _attemptHandshake(String base, String name) async {
    // No stale whispering: any previous listener is cut before the new
    // socket is wired, otherwise a single server frame can arrive twice
    // (old flow + new flow) — double bubbles, double system lines.
    await _shutSocket();
    final completer = Completer<SalonJoinResult>();
    _joinCompleter = completer;
    _closedByServer = false;
    WebSocketChannel? channel;
    try {
      channel = await _connect(base);
      if (_disposed) {
        await _closeChannel(channel);
        return const SalonJoinResult(ok: false);
      }
      _channel = channel;
      _frames = channel.stream.listen(
        _onServerFrame,
        onDone: _handleChannelClosed,
        onError: (Object error) {
          if (completer.isCompleted) return;
          completer.complete(const SalonJoinResult(ok: false));
        },
      );
      await channel.ready.timeout(handshakeTimeout);
      _sendJson({'type': 'join', 'name': name});
      final result = await completer.future.timeout(
        handshakeTimeout,
        onTimeout: () {
          _joinCompleter = null;
          return const SalonJoinResult(ok: false);
        },
      );
      _joinCompleter = null;
      if (!result.ok) {
        await _shutSocket();
      }
      return result;
    } catch (error) {
      _joinCompleter = null;
      await _shutSocket();
      rethrow;
    }
  }

  Future<WebSocketChannel> _connect(String base) async {
    // API v1 (2026-11): the versioned WS surface; the legacy /salons
    // path remains a Worker-side alias.
    final uri = Uri.parse('$base/api/v1/salons/$code/ws')
        .replace(scheme: base.startsWith('https://') ? 'wss' : 'ws');
    final factory = channelFactory;
    if (factory != null) {
      return factory(uri);
    }
    return WebSocketChannel.connect(uri);
  }

  // ------------------------------------------------------------- contracts

  @override
  void addBot() {
    if (role != SalonRole.host || isStarting) return;
    _sendJson(const <String, dynamic>{'type': 'addBot'});
  }

  @override
  void removeBot() {
    if (role != SalonRole.host || isStarting) return;
    _sendJson(const <String, dynamic>{'type': 'removeBot'});
  }

  @override
  void setBotName(int botSeat, String name) {
    // The Worker assigns bot names; individual renames come later.
  }

  @override
  Future<void> sendReaction(String emoji) async {
    if (isSpectator) return;
    if (_channel == null) {
      pushSystemMessage(SalonSystem.deadReaction);
      return;
    }
    if (!_spendChat()) {
      pushSystemMessage(SalonSystem.chatRate(_chatWait));
      return;
    }
    final clientId = _newMessageId();
    _sendJson(<String, dynamic>{
      'type': 'reaction',
      'emoji': emoji,
      'clientId': clientId,
    });
    _appendDialogue(
      {
        'seat': you >= 0 ? you : 0,
        'name': myName,
        'emoji': emoji,
        'clientId': clientId,
      },
      bodyOf: (_) => '',
      emojiOf: (raw) => '${raw['emoji'] ?? ''}',
    );
  }

  @override
  Future<void> sendChat(String body) async {
    final text = body.trim();
    if (text.isEmpty) return;
    if (_channel == null) {
      pushSystemMessage(SalonSystem.deadChat);
      return;
    }
    if (!_spendChat()) {
      pushSystemMessage(SalonSystem.chatRate(_chatWait));
      return;
    }
    final clientId = _newMessageId();
    _sendJson(<String, dynamic>{
      'type': 'chat',
      'text': text,
      'clientId': clientId,
    });
    _appendDialogue({
      'seat': you >= 0 ? you : 0,
      'name': myName,
      'text': text,
      'clientId': clientId,
    }, bodyOf: (raw) => '${raw['text'] ?? ''}');
  }

  @override
  Future<void> startGame() async {
    if (_disposed || role != SalonRole.host || isStarting) return;
    // Several taps while the Worker answers must not queue several rounds.
    final pending = _startCompleter;
    if (pending != null) return pending.future;
    final completer = Completer<void>();
    _startCompleter = completer;
    _sendJson(const <String, dynamic>{'type': 'start'});
    await completer.future.timeout(handshakeTimeout, onTimeout: () {});
    final confirmed = completer.isCompleted;
    if (identical(_startCompleter, completer)) {
      _startCompleter = null;
    }
    if (confirmed && !_disposed) {
      isStarting = true;
      notifyListeners();
    }
  }

  void _sendBots(int count) {
    for (var index = 0; index < count; index++) {
      _sendJson(const <String, dynamic>{'type': 'addBot'});
    }
  }

  void _sendJson(Object payload) {
    final channel = _channel;
    if (channel == null || _disposed) return;
    try {
      channel.sink.add(jsonEncode(payload));
    } catch (_) {
      // Socket dying; the close sweep handles the rest.
    }
  }

  Future<void> _shutSocket() async {
    final subscription = _frames;
    _frames = null;
    final channel = _channel;
    _channel = null;
    unawaited(subscription?.cancel());
    if (channel != null) {
      await _closeChannel(channel);
    }
  }

  Future<void> _closeChannel(WebSocketChannel channel) async {
    try {
      await channel.sink.close();
    } catch (_) {
      // déjà parti
    }
  }

  // -------------------------------------------------------------- intake

  void _onServerFrame(Object? raw) {
    if (_disposed || raw == null) return;
    final String text;
    try {
      text = raw is String ? raw : utf8.decode(raw as List<int>);
    } catch (_) {
      return;
    }
    Map<String, dynamic> frame;
    try {
      frame = jsonDecode(text) as Map<String, dynamic>;
    } on FormatException catch (_) {
      return;
    }
    _handleServerFrame(frame);
  }

  void _handleServerFrame(Map<String, dynamic> frame) {
    // Every frame, whatever its kind, proves the flow is alive.
    _lastServerFrame = DateTime.now();
    switch (frame['type'] as String? ?? '') {
      case 'ping':
        // Answer the server's liveness probe; this pong is also OUR
        // outbound keepalive keeping the NAT entry alive.
        _sendJson(const <String, dynamic>{'type': 'pong'});
      case 'pong':
        break;
      case 'salon':
        _applySalonState((frame['salon'] as Map<String, dynamic>?) ?? {});
      case 'started':
        final waiting = _startCompleter;
        if (waiting != null && !waiting.isCompleted) {
          waiting.complete();
        }
        isStarting = true;
        notifyListeners();
      case 'closed':
        pushSystemMessage(
          SalonSystem.closed('${frame['reason'] ?? 'taverne vide'}'),
        );
        _closedByServer = true;
        _shutSocket();
      case 'error':
        final message = '${frame['message'] ?? 'Erreur inconnue'}';
        final join = _joinCompleter;
        if (join != null && !join.isCompleted) {
          _joinCompleter = null;
          join.complete(SalonJoinResult(ok: false, message: message));
        } else {
          pushSystemMessage(message);
        }
      case 'chat':
        _appendDialogue(
          frame['chat'],
          bodyOf: (chat) => '${chat['text'] ?? ''}',
        );
      case 'reaction':
        _appendDialogue(
          frame['reaction'],
          bodyOf: (_) => '',
          emojiOf: (reaction) => '${reaction['emoji'] ?? ''}',
        );
      case 'game':
        _relayTable('game', frame);
      case 'snapshot':
        final payload = frame['payload'];
        if (payload is Map<String, dynamic>) {
          // Keep the last picture the engine owner broadcast: a mid-game
          // handover to this phone rebuilds the engine from it.
          lastSnapshot = payload;
        }
        _relayTable('snapshot', frame);
      default:
        break;
    }
  }

  void _applySalonState(Map<String, dynamic> state) {
    final salonCode = '${state['code'] ?? ''}';
    if (salonCode.isNotEmpty) code = salonCode.toUpperCase();
    you = (state['you'] as num?)?.toInt() ?? -1;
    isStarting = state['started'] as bool? ?? false;
    // Mid-game join without a seat: the Worker seats the socket at -1.
    // The flag clears as soon as a real seat shows up (gameOver auto-seat).
    isSpectator = you < 0 && isStarting;
    hostSeat = (state['hostSeat'] as num?)?.toInt() ?? 0;
    // The role follows the engine's owner seat, not the join handshake:
    // a mid-game handover flips a guest to host (and an old host who
    // comes back after losing the bar to a guest, to guest).
    final wasHost = role == SalonRole.host;
    role = you >= 0 && you == hostSeat ? SalonRole.host : SalonRole.guest;
    if (!isStarting) {
      // The Worker heard the gameOver: the intent is fulfilled.
      _gameOverPending = false;
      // The table is a lobby again: a previous game's snapshot must not
      // be mistaken for the state of the next one.
      lastSnapshot = null;
      hostTakeover = false;
    } else if (_gameOverPending) {
      // Still "started" while a quit is pending: our earlier gameOver was
      // lost to a dead socket (doze). Re-announce it; idempotent.
      _sendJson(const <String, dynamic>{'type': 'gameOver'});
    } else {
      // Mid-game handover to this phone (guest seat now owns the engine):
      // one-shot flag consumed by the lobby screen to restore the engine
      // from [lastSnapshot] instead of dealing a fresh round.
      hostTakeover = !wasHost && role == SalonRole.host;
    }
    final playerList = state['players'] as List<dynamic>? ?? const [];
    players
      ..clear()
      ..addAll([
        for (final raw in playerList)
          if (raw is Map<String, dynamic>)
            SalonPlayer(
              seat: (raw['seat'] as num?)?.toInt() ?? -1,
              name: '${raw['name'] ?? '?'}',
              isHost: ((raw['seat'] as num?)?.toInt() ?? -1) == hostSeat,
              isBot: raw['bot'] as bool? ?? false,
            ),
      ])
      ..sort((a, b) => a.seat.compareTo(b.seat));
    botCount = players.where((player) => player.isBot).length;
    // The engine lives on the host's phone: if the host seat carries the
    // Worker's "à l'eau" marker while the table is still started, every
    // guest is staring at a frozen mirror. Say it once, loudly.
    SalonPlayer? hostPlayer;
    for (final player in players) {
      if (player.seat == hostSeat) hostPlayer = player;
    }
    final hostAway =
        isStarting &&
        hostPlayer != null &&
        hostPlayer.name.endsWith(_awayMarker);
    final wasGone = hostGone;
    hostGone = hostAway;
    if (hostGone && !wasGone) {
      pushSystemMessage(SalonSystem.hostGone);
    }
    notifyListeners();

    // The join handshake completes as soon as our seat is in the table —
    // or the Worker seated us as a spectator (you=-1, game running).
    final join = _joinCompleter;
    if (join != null && !join.isCompleted && (you >= 0 || isSpectator)) {
      _joinCompleter = null;
      join.complete(SalonJoinResult(ok: true, spectator: isSpectator));
    }
  }

  void _appendDialogue(
    Object? raw, {
    required String Function(Map<String, dynamic>) bodyOf,
    String Function(Map<String, dynamic>)? emojiOf,
  }) {
    if (raw is! Map<String, dynamic>) {
      return;
    }
    final seat = (raw['seat'] as num?)?.toInt() ?? -1;
    final stringBody = bodyOf(raw).trim();
    final stringEmoji = emojiOf?.call(raw);
    final clientId = raw['clientId'] is String
        ? (raw['clientId'] as String)
        : null;
    if (stringBody.isEmpty && (stringEmoji ?? '').isEmpty) {
      return;
    }

    // Stable ids reconcile our optimistic echo with the Worker echo, even
    // if other chat frames arrived in between. They also suppress duplicate
    // delivery/retries on every seat, not only on the sender's phone.
    if (clientId != null) {
      if (_seenMessageIds.contains(clientId)) return;
      _rememberMessageId(clientId);
    } else {
      // Compatibility with an older Worker during rolling upgrades: match
      // only a recent optimistic bubble by the same seat and exact payload.
      final legacyEcho = messages.reversed
          .take(16)
          .any(
            (message) =>
                message.isMine &&
                message.clientId != null &&
                message.authorSeat == seat &&
                message.body == stringBody &&
                message.emoji == stringEmoji &&
                DateTime.now().difference(message.at) <
                    const Duration(seconds: 10),
          );
      if (legacyEcho) return;
    }

    messages.add(
      SalonMessage(
        authorSeat: seat,
        authorName: '${raw['name'] ?? '?'}',
        body: stringBody,
        emoji: stringEmoji,
        kind: stringEmoji == null
            ? SalonMessageKind.chat
            : SalonMessageKind.emoji,
        at: DateTime.now(),
        isMine: seat == you,
        clientId: clientId,
      ),
    );
    notifyListeners();
  }

  String _newMessageId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${_messageSequence++}';

  void _rememberMessageId(String id) {
    _seenMessageIds.add(id);
    _messageIdOrder.addLast(id);
    // Keep duplicate protection bounded for long-lived salon sessions.
    while (_messageIdOrder.length > 256) {
      _seenMessageIds.remove(_messageIdOrder.removeFirst());
    }
  }

  void _relayTable(String kind, Map<String, dynamic> frame) {
    _tableEvents.add(
      RelayedTableMessage(
        kind: kind,
        fromSeat: (frame['from'] as num?)?.toInt() ?? -1,
        payload: frame['payload'],
      ),
    );
  }

  void _handleChannelClosed() {
    final join = _joinCompleter;
    if (join != null && !join.isCompleted) {
      join.complete(const SalonJoinResult(ok: false));
    }
    if (_disposed || _closedByServer) {
      notifyListeners();
      return;
    }
    // The relay dropped us unexpectedly: try one automatic recovery. The
    // close code travels in the message so a phone-side mystery shows up
    // in the thread instead of staying silent (e.g. 1006 = transport lost
    // without a proper close frame).
    final closeCode = _channel?.closeCode;
    final closeReason = _channel?.closeReason;
    final detail = closeCode == null
        ? ''
        : ' (fermeture $closeCode${closeReason == null || closeReason.isEmpty ? '' : ' — $closeReason'})';
    // Drop the dead flow's fields RIGHT NOW, in every path: a stale
    // _channel reads like "the socket survived" to the resume handler,
    // the watchdog and the senders.
    unawaited(_shutSocket());
    // While the phone dozes, the socket dies quietly: no failure loop in
    // the thread, the resume handles the reconnect.
    if (_appSuspended) {
      return;
    }
    pushSystemMessage(SalonSystem.lost(detail));
    _scheduleRecovery(_nextRecoveryDelay());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _appSuspended = true;
        // Timers frozen by the OS fire back-to-back on resume and miss —
        // drop the queued retry, the resume handles one clean attempt.
        _recoveryTimer?.cancel();
        _recoveryTimer = null;
        // The queued retry no longer exists: leave the flag set and
        // _scheduleRecovery refuses everything after the unlock — the
        // session stayed dead on its "connexion perdue" line forever.
        _recoveryScheduled = false;
      case AppLifecycleState.inactive:
      case AppLifecycleState.resumed:
        final wasSuspended = _appSuspended;
        _appSuspended = false;
        if (!wasSuspended || _disposed || code.isEmpty) return;
        if (_channel != null) {
          final silence = DateTime.now().difference(_lastServerFrame);
          if (silence < livenessStroke) return; // socket survived the doze
          // No frame since before the sleep: a zombie flow. The close
          // event already ran (or never will) — drop it like the watchdog
          // would and take one clean reconnect.
          unawaited(_shutSocket());
        }
        pushSystemMessage(SalonSystem.phoneSlept);
        // One clean attempt on unlock — force through any stale flag.
        _recoveryScheduled = false;
        _scheduleRecovery();
    }
  }

  /// A silent socket (nothing inbound for 75s while the app is awake) is a
  /// dead flow: the server pings every 20s, so true silence means the
  /// transport dropped without a close frame. Close it ourselves and run
  /// the recovery - this is what kept mirrors frozen and made bets vanish.
  void _checkLiveness() {
    if (_disposed || _appSuspended || _channel == null) return;
    final silence = DateTime.now().difference(_lastServerFrame);
    if (silence < livenessStroke) return;
    debugPrint(
      'salon: silence de ${silence.inSeconds}s, je coupe et je reprends',
    );
    pushSystemMessage(SalonSystem.watchdogCut);
    // Cut the flow AND mute its listener. _shutSocket reads the fields, so
    // hand it nothing: close the captured channel and cancel the captured
    // subscription ourselves, then clear the fields.
    final frames = _frames;
    final socket = _channel;
    _frames = null;
    _channel = null;
    unawaited(frames?.cancel());
    if (socket != null) {
      unawaited(_closeChannel(socket));
    }
    _scheduleRecovery();
  }

  void _scheduleRecovery([Duration? when]) {
    if (_recoveryScheduled) return; // one retry at a time, by design
    _recoveryScheduled = true;
    _recoveryTimer?.cancel();
    _recoveryTimer = Timer(when ?? reconnectDelay, () {
      _recoveryScheduled = false;
      unawaited(_recover());
    });
  }

  /// Exploding backoff after repeated failures: 1.2s, 2.4s, 4.8s… capped
  /// at 15s so an unreachable salon breathes instead of hammering.
  Duration _nextRecoveryDelay() {
    final delayMs =
        (reconnectDelay.inMilliseconds * (1 << _recoveryFailures.clamp(0, 4)))
            .clamp(reconnectDelay.inMilliseconds, 15000);
    return Duration(milliseconds: delayMs);
  }

  Future<void> _recover() async {
    if (_disposed || _recovering) return;
    _recovering = true;
    final base = activeBaseUrl ?? baseUrls.first;
    try {
      final result = await _attemptHandshake(base, myName);
      if (result.ok) {
        _recoveryFailures = 0;
        pushSystemMessage(SalonSystem.recovered(code));
        // Ask the host for a fresh table snapshot (mid-game recovery).
        sendGame(const <String, dynamic>{'kind': 'resync'});
        return;
      }
      _recoveryFailures++;
      final reason = result.message ?? SalonSystem.noServerReply;
      if (result.message != null) {
        // The server ANSWERED with a refusal (salon unknown, table started
        // without a reclaimable seat, name refused). Retrying knocks on a
        // door that stays shut — the endless "connexion interrompue" loop.
        // Stop chasing it; the sailor leaves and joins/creates anew.
        _closedByServer = true;
        _threadOnce(SalonSystem.salonRefused(reason));
        return;
      }
      _threadOnce(SalonSystem.unreachableTrack(reason));
    } catch (error) {
      // On a phone, "why" is everything: DNS, proxy, captive portal. The
      // terse edition goes to the thread; the raw error stays in adb.
      final brief = switch (error) {
        SocketException(:final message, :final osError) when osError != null =>
          '$message (${osError.message})',
        _ => '$error',
      };
      debugPrint('salon: reconnexion a échoué : $brief');
      // WebSocketChannelException "not upgraded" = the server answered an
      // HTTP code instead of 101: ghosted sockets (429) on our side, or a
      // phone-side captor (captive portal, VPN). The /healthz probe tells
      // which one — the status lands in the thread.
      var probe = '';
      if ('$error'.contains('not upgraded')) {
        probe = await _healthProbe(base);
      }
      _recoveryFailures++;
      _threadOnce(SalonSystem.unreachableBackoff('$brief$probe'));
    } finally {
      _recovering = false;
      if (!_disposed) notifyListeners();
      if (!_disposed &&
          _channel == null &&
          !_closedByServer &&
          !_appSuspended) {
        // The socket is still down: chase it. One scheduler at a time.
        _scheduleRecovery(_nextRecoveryDelay());
      }
    }
  }

  /// A non-101 answer to a WS upgrade needs a witness. The site serves
  /// `/healthz` with `{"ok":true}`: if the probe reads it, the phone's
  /// network reaches the Worker fine and the refusal came FROM the server
  /// (ghosted sockets, 429) — otherwise the flow is hijacked phone-side.
  Future<String> _healthProbe(String base) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 6);
    try {
      final request = await client
          .getUrl(Uri.parse('$base/healthz'))
          .timeout(const Duration(seconds: 6));
      final response = await request.close().timeout(
        const Duration(seconds: 6),
      );
      final body = (await response.transform(utf8.decoder).join()).trim();
      final short = body.length > 22 ? '${body.substring(0, 22)}…' : body;
      return SalonSystem.networkResponse('${response.statusCode}', short);
    } catch (error) {
      return SalonSystem.networkProbeFailed('$error');
    } finally {
      client.close();
    }
  }

  /// Same sentence twice in a minute reads like spam in the thread; the
  /// recovery machinery says it once, the reader knows we're still trying.
  void _threadOnce(String body) {
    if (_disposed) return;
    final messages = this.messages;
    final lastSystem = messages.isEmpty ? null : messages.last;
    final repeated =
        lastSystem != null &&
        lastSystem.isMine == false &&
        lastSystem.body == body &&
        lastSystem.authorSeat == -1 &&
        DateTime.now().difference(lastSystem.at) < const Duration(seconds: 60);
    if (repeated) return;
    pushSystemMessage(body);
  }

  // -------------------------------------------------------------- cleanup

  /// Test hooks: drive the watchdog by hand instead of racing the event
  /// loop under a loaded suite.
  @visibleForTesting
  void debugAgeLastFrameForTest([Duration? age]) {
    _lastServerFrame = DateTime.now().subtract(
      age ?? const Duration(seconds: 600),
    );
  }

  @visibleForTesting
  void debugRunLivenessForTest() => _checkLiveness();

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _watchdog?.cancel();
    _watchdog = null;
    _outboundPing?.cancel();
    _outboundPing = null;
    _recoveryTimer?.cancel();
    _recoveryTimer = null;
    // Settle an in-flight handshake: its timeout would otherwise wake up
    // after dispose and talk to a dead ChangeNotifier.
    final join = _joinCompleter;
    if (join != null && !join.isCompleted) {
      _joinCompleter = null;
      join.complete(const SalonJoinResult(ok: false));
    }
    // Same for a start waiting on the Worker: its 8s timeout would
    // otherwise stay pending and wake up against a dead session.
    final start = _startCompleter;
    if (start != null && !start.isCompleted) {
      start.complete();
    }
    _frames?.cancel();
    final channel = _channel;
    _channel = null;
    if (channel != null) {
      unawaited(channel.sink.close());
    }
    unawaited(_tableEvents.close());
    super.dispose();
  }
}

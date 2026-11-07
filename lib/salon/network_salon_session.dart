import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'salon_models.dart';

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
  static const _window = Duration(seconds: 3);

  final List<DateTime> _chatStamps = <DateTime>[];

  bool _spendChat() {
    final now = DateTime.now();
    _chatStamps.removeWhere((stamp) => now.difference(stamp) > _window);
    if (_chatStamps.length >= _capacity) return false;
    _chatStamps.add(now);
    return true;
  }
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
    with _ChatBucket
    implements SalonBackend {
  NetworkSalonSession({
    List<String>? baseUrls,
    this.createSalonCode,
    this.channelFactory,
    this.handshakeTimeout = const Duration(seconds: 8),
    this.reconnectDelay = const Duration(milliseconds: 1200),
  }) : baseUrls = List<String>.unmodifiable(baseUrls ?? defaultBaseUrls);

  static const List<String> defaultBaseUrls = [
    'https://dudo.supercloud.fr',
  ];

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
          pushSystemMessage(
            'Trop de demandes de création — réessaie dans ~${error.retryAfter} s.',
          );
          return;
        }
        lastFailure = error.toString();
      }
    }
    code = '';
    activeBaseUrl = null;
    pushSystemMessage(
      'Impossible de créer un salon pour l\u2019instant.'
      '${lastFailure == null ? '' : ' ($lastFailure)'}',
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
    pushSystemMessage('Salon créé. Code : $code');
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
      return const SalonJoinResult(
        ok: false,
        message: 'Le code doit faire six caractères.',
      );
    }

    role = SalonRole.guest;
    hostName = '';
    myName = guest;
    code = cleaned;
    players.clear();
    isStarting = false;
    // A new table starts a clean thread (recovery never goes through here).
    resetThread();
    notifyListeners();

    String? refusal;
    for (final base in baseUrls) {
      try {
        final result = await _attemptHandshake(base, guest);
        if (result.ok) {
          activeBaseUrl = base;
          pushSystemMessage('Connecté au salon $code');
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
    if (_channel == null) return;
    if (!_spendChat()) {
      pushSystemMessage('Trop de messages, ralentis un peu.');
      return;
    }
    _sendJson(<String, dynamic>{'type': 'reaction', 'emoji': emoji});
  }

  @override
  Future<void> sendChat(String body) async {
    final text = body.trim();
    if (_channel == null || text.isEmpty) return;
    if (!_spendChat()) {
      pushSystemMessage('Trop de messages, ralentis un peu.');
      return;
    }
    _sendJson(<String, dynamic>{'type': 'chat', 'text': text});
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
    if (confirmed) {
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
    switch (frame['type'] as String? ?? '') {
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
        pushSystemMessage('Salon fermé : ${frame['reason'] ?? 'taverne vide'}');
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
          bodyOf: (reaction) => '${reaction['name'] ?? ''}',
          emojiOf: (reaction) => '${reaction['emoji'] ?? ''}',
        );
      case 'game':
        _relayTable('game', frame);
      case 'snapshot':
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
    final hostSeat = (state['hostSeat'] as num?)?.toInt() ?? 0;
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
    notifyListeners();

    // The join handshake completes as soon as our seat is in the table.
    final join = _joinCompleter;
    if (join != null && !join.isCompleted && you >= 0) {
      _joinCompleter = null;
      join.complete(const SalonJoinResult(ok: true));
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
    if (stringBody.isEmpty && (stringEmoji ?? '').isEmpty) {
      return;
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
      ),
    );
    notifyListeners();
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
    // The relay dropped us unexpectedly: try one automatic recovery.
    pushSystemMessage('Connexion perdue — tentative de reconnexion…');
    _scheduleRecovery();
  }

  void _scheduleRecovery() {
    _recoveryTimer?.cancel();
    _recoveryTimer = Timer(reconnectDelay, () {
      unawaited(_recover());
    });
  }

  Future<void> _recover() async {
    if (_disposed || _recovering) return;
    _recovering = true;
    final base = activeBaseUrl ?? baseUrls.first;
    try {
      final result = await _attemptHandshake(base, myName);
      if (result.ok) {
        pushSystemMessage('Reconnecté au salon $code.');
        // Ask the host for a fresh table snapshot (mid-game recovery).
        sendGame(const <String, dynamic>{'kind': 'resync'});
      } else {
        pushSystemMessage(
          result.message ?? 'Salon injoignable — vérifie le code et réessaie.',
        );
      }
    } catch (_) {
      pushSystemMessage('Salon injoignable — vérifie le code et réessaie.');
    } finally {
      _recovering = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------- cleanup

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _recoveryTimer?.cancel();
    _recoveryTimer = null;
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

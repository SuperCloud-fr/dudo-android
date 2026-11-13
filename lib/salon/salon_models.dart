import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'salon_system_strings.dart';

/// Multiplayer salon code for Dudo.
///
/// The salon flow is driven through [SalonBackend] implementations:
/// - [LocalSalonSession] runs the offline prototype (the UI flow works
///   without any backend),
/// - [NetworkSalonSession] (network_salon_session.dart) connects to the
///   Cloudflare Worker (dudo-worker repo) over WebSocket.
/// The salon screens only ever see a [SalonSession], never a concrete
/// implementation.
enum SalonRole { host, guest }

enum SalonMessageKind { chat, emoji, system }

@immutable
class SalonPlayer {
  const SalonPlayer({
    required this.seat,
    required this.name,
    required this.isHost,
    required this.isBot,
  });

  final int seat;
  final String name;
  final bool isHost;
  final bool isBot;

  SalonPlayer copyWith({String? name}) => SalonPlayer(
    seat: seat,
    name: name ?? this.name,
    isHost: isHost,
    isBot: isBot,
  );

  @override
  String toString() => 'SalonPlayer($seat, $name)';
}

@immutable
class SalonMessage {
  const SalonMessage({
    required this.authorSeat,
    required this.authorName,
    required this.body,
    this.emoji,
    required this.kind,
    required this.at,
    this.isMine = false,
    this.clientId,
  });

  final int? authorSeat;
  final String authorName;
  final String body;
  final String? emoji;
  final SalonMessageKind kind;
  final DateTime at;

  /// Whether the local device authored this message. Local sessions use
  /// seat 0; network sessions know the real "you" seat.
  final bool isMine;

  /// Stable id for a client send, echoed by the Worker. Allows the optimistic
  /// bubble and any server retries to be reconciled without comparing text.
  final String? clientId;
}

/// The session contract implemented by the local prototype and by the
/// network backend (Cloudflare Worker + WebSocket).
abstract class SalonBackend {
  Future<void> createSalon(String hostName, int botCount);
  Future<SalonJoinResult> joinSalon(String code, String guestName);
  void addBot();
  void removeBot();
  void setBotName(int botSeat, String name);
  Future<void> sendReaction(String emoji);
  Future<void> sendChat(String body);
  void dispose();
}

@immutable
class SalonJoinResult {
  const SalonJoinResult({this.ok = true, this.message, this.spectator = false});
  final bool ok;
  final String? message;

  /// True when the salon accepted the join mid-game without a seat to
  /// reclaim: the newcomer watches the current round and is seated at
  /// the next one.
  final bool spectator;
}

/// Shared state, share actions and session contract for both salon
/// implementations (local prototype and network backend).
abstract class SalonSession extends ChangeNotifier {
  SalonRole role = SalonRole.host;
  String hostName = 'Toi';
  String myName = 'Toi';
  String code = '';
  int botCount = 3;
  final List<SalonPlayer> players = <SalonPlayer>[];
  final List<SalonMessage> messages = <SalonMessage>[];
  bool isStarting = false;

  /// Started table whose host seat is away (« à l'eau »): the game engine
  /// lives on the host's phone, so guests wait for its return instead of
  /// freezing on a dead mirror. Network sessions only; local stays false.
  bool hostGone = false;

  /// Salon seats currently carrying the Worker's "(à l'eau)" marker while
  /// a game runs: their socket is gone, so the host engine must cover
  /// their turns until they reclaim the seat. Empty offline.
  Iterable<int> get awaySeats => const <int>{};

  /// Salon seat of the engine's owner. 0 while the host holds the bar;
  /// after a mid-game handover the Worker publishes the takeover seat
  /// here and every phone re-derives its role from it.
  int hostSeat = 0;

  /// True for exactly one salon frame when this phone inherited the
  /// engine mid-game (host seat moved to us while the table runs): the
  /// lobby screen consumes it to rebuild the engine from
  /// [lastSnapshot] instead of dealing a fresh round.
  bool hostTakeover = false;

  /// Last full table snapshot the host broadcast while we watched the
  /// table. Non-null only for guests (the host phone never receives its
  /// own broadcasts); cleared whenever the salon reopens as a lobby.
  Map<String, dynamic>? lastSnapshot;

  /// True when this phone joined mid-game with no seat to reclaim: the
  /// table renders read-only until the next gameOver seats this sailor.
  /// Network sessions only; local stays false.
  bool isSpectator = false;

  static const List<String> botNames = [
    'Barbe-Noire',
    'Anne Bonny',
    'Rackham',
    'Barbe-Rousse',
    'Mérou',
  ];

  static const String alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// A new table starts a clean thread: the previous salon's chat must not
  /// haunt the next one (create/join entry points call this). Auto
  /// recovery deliberately bypasses it — that thread is still alive.
  void resetThread() {
    messages.clear();
    notifyListeners();
  }

  List<SalonPlayer> get bots =>
      players.where((player) => player.isBot).toList(growable: false);

  Future<void> createSalon(String hostName, int botCount);

  Future<SalonJoinResult> joinSalon(String code, String guestName);

  void addBot();

  void removeBot();

  void setBotName(int botSeat, String name);

  Future<void> sendReaction(String emoji);

  Future<void> sendChat(String body);

  Future<void> startGame();

  /// Server-driven system line shared by both implementations.
  void pushSystemMessage(String body, {bool mine = false}) {
    messages.add(
      SalonMessage(
        authorSeat: null,
        authorName: 'Table',
        body: body,
        kind: SalonMessageKind.system,
        at: DateTime.now(),
        isMine: mine,
      ),
    );
    notifyListeners();
  }

  Future<void> shareCode() async {
    final body = 'Rejoins le salon Dudo : $code';
    try {
      await SharePlus.instance.share(ShareParams(text: body));
    } on MissingPluginException {
      Clipboard.setData(ClipboardData(text: body));
    }
  }

  Future<void> shareOnWhatsapp() async => _open(
    Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent('Rejoins le salon Dudo : $code')}',
    ),
    clipboard: true,
  );

  Future<void> writeOnSms() async => _open(
    Uri.parse(
      'sms:?body=${Uri.encodeComponent('Rejoins le salon Dudo : $code')}',
    ),
    clipboard: true,
  );

  Future<void> writeOnMail() async => _open(
    Uri.parse(
      'mailto:?subject=${Uri.encodeComponent('Salon Dudo $code')}&body=${Uri.encodeComponent('Rejoins le salon Dudo : $code')}',
    ),
  );

  Future<void> copyCode() async {
    await Clipboard.setData(ClipboardData(text: code));
  }

  Future<void> _open(Uri uri, {bool clipboard = false}) async {
    final ok = await canLaunchUrl(uri);
    if (!ok && clipboard) {
      await Clipboard.setData(ClipboardData(text: code));
    } else if (!ok) {
      await Clipboard.setData(ClipboardData(text: code));
    } else {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Offline reference implementation: players join locally, reactions and
/// chat are echoed by bots after a short delay. Keeps the UI flow testable
/// without any network.
class LocalSalonSession extends SalonSession implements SalonBackend {
  LocalSalonSession();

  String _newCode() {
    final random = DateTime.now().microsecondsSinceEpoch;
    final texts = List<String>.generate(
      6,
      (i) => SalonSession.alphabet[(random >> (i * 5)) & 31],
    );
    return texts.join();
  }

  @override
  Future<void> createSalon(String host, int bots) async {
    role = SalonRole.host;
    botCount = bots.clamp(0, 5);
    hostName = host;
    myName = host;
    code = _newCode();
    resetThread();
    _repopulate();
    pushSystemMessage(SalonSystem.created(code));
    notifyListeners();
  }

  @override
  Future<SalonJoinResult> joinSalon(String joinCode, String guest) async {
    role = SalonRole.guest;
    code = joinCode.toUpperCase();
    myName = guest;
    resetThread();
    _repopulate();
    pushSystemMessage(SalonSystem.connectedTab(code));
    notifyListeners();
    return const SalonJoinResult(ok: true);
  }

  void _repopulate() {
    players
      ..clear()
      ..add(
        SalonPlayer(
          seat: 0,
          name: myName,
          isHost: role == SalonRole.host,
          isBot: false,
        ),
      );
    for (var index = 0; index < botCount; index++) {
      players.add(
        SalonPlayer(
          seat: index + 1,
          name: SalonSession.botNames[index % SalonSession.botNames.length],
          isHost: false,
          isBot: true,
        ),
      );
    }
  }

  @override
  void addBot() {
    if (botCount >= 5) return;
    botCount++;
    _repopulate();
    notifyListeners();
  }

  @override
  void removeBot() {
    if (botCount <= 0) return;
    botCount--;
    _repopulate();
    notifyListeners();
  }

  @override
  void setBotName(int botSeat, String name) {
    final index = players.indexWhere((player) => player.seat == botSeat);
    if (index == -1) return;
    players[index] = players[index].copyWith(name: name);
    notifyListeners();
  }

  @override
  Future<void> sendReaction(String emoji) async {
    _push(0, emoji, kind: SalonMessageKind.emoji, emoji: emoji);
    // The network backend will relay other players' reactions here.
    Future<void>.delayed(const Duration(milliseconds: 400)).then((_) {
      if (bots.isNotEmpty) {
        final bot = bots.first;
        _push(
          bot.seat,
          bot.name,
          emoji: _botEmoji(),
          kind: SalonMessageKind.emoji,
        );
        notifyListeners();
      }
    });
    notifyListeners();
  }

  String _botEmoji() {
    const sample = ['🍺', '🤯', '😈'];
    return sample[DateTime.now().microsecondsSinceEpoch % sample.length];
  }

  @override
  Future<void> sendChat(String body) async {
    if (body.trim().isEmpty) return;
    _push(0, body.trim(), kind: SalonMessageKind.chat);
    notifyListeners();
    Future<void>.delayed(const Duration(milliseconds: 600)).then((_) {
      if (bots.isNotEmpty) {
        final bot = bots.first;
        _push(bot.seat, 'Entendu, $myName !', kind: SalonMessageKind.chat);
        notifyListeners();
      }
    });
  }

  void _push(
    int? seat,
    String body, {
    required SalonMessageKind kind,
    String? emoji,
  }) {
    messages.add(
      SalonMessage(
        authorSeat: seat,
        authorName: seat == null
            ? 'Table'
            : players.firstWhere((p) => p.seat == seat).name,
        body: body,
        emoji: emoji,
        kind: kind,
        at: DateTime.now(),
        isMine: seat == 0,
      ),
    );
  }

  @override
  Future<void> startGame() async {
    isStarting = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}

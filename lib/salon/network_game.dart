import 'dart:async';
import 'dart:math';

import '../game/models/bid.dart';
import '../game/models/game_config.dart';
import '../game/models/player.dart';
import '../game/models/table_event.dart';
import '../game/state/game_controller.dart';
import 'network_salon_session.dart';

/// Host-authoritative multiplayer round on top of the salon session.
///
/// - The host's phone runs the real [GameController]; every engine mutation
///   is broadcast as a compact snapshot (bid history, phases, one dice
///   seed per round).
/// - Guests send commands (`bid`, `dudo`, `calza`, `nextRound`, `rematch`);
///   the host validates them against its engine and broadcasts the result.
/// - Dice are derived locally from the per-round seed (host rolls with
///   `Random(seed)` in ascending salon-seat order, guests replay exactly
///   that order). Hidden knowledge never travels the wire: the payload
///   carries no dice values at all.
/// - On each guest, seats are re-based ("me" = local seat 0) so the
///   existing [GameScreen] UI works unchanged.

const String networkSnapshotVersion = '1';

// --------------------------------------------------------------- snapshots

/// Compact serialisation of the table. Seats stay in salon order
/// (0 = host); the guest re-bases them after deserialisation.
Map<String, dynamic> snapshotOf(GameController controller) {
  return <String, dynamic>{
    'v': networkSnapshotVersion,
    'difficulty': controller.config.difficulty.name,
    'round': controller.round,
    'phase': controller.phase.name,
    'palifico': controller.palifico,
    'starter': controller.starter,
    'currentPlayer': controller.currentPlayer,
    'seed': controller.lastRoundSeed,
    'players': [
      for (final player in controller.players)
        <String, dynamic>{
          'seat': player.seat,
          'name': player.name,
          'diceCount': player.diceCount,
        },
    ],
    'bid': controller.currentBid == null
        ? null
        : <String, dynamic>{
            'q': controller.currentBid!.quantity,
            'f': controller.currentBid!.face,
            's': controller.currentBid!.playerSeat,
          },
    'journal': [
      for (final event in controller.journal)
        <String, dynamic>{
          'r': event.round,
          's': event.playerSeat,
          'k': event.kind.name,
          'b': event.bid == null
              ? null
              : <String, dynamic>{
                  'q': event.bid!.quantity,
                  'f': event.bid!.face,
                },
        },
    ],
    'outcome': controller.outcome == null
        ? null
        : <String, dynamic>{
            'bid': <String, dynamic>{
              'q': controller.outcome!.bid.quantity,
              'f': controller.outcome!.bid.face,
              's': controller.outcome!.bid.playerSeat,
            },
            'caller': controller.outcome!.callerSeat,
            'kind': controller.outcome!.kind.name,
            'actual': controller.outcome!.actualCount,
            'exact': controller.outcome!.exact,
            'callerWon': controller.outcome!.callerWon,
            'loser': controller.outcome!.loserSeat,
            'gain': controller.outcome!.gainSeat,
            'gained': controller.outcome!.gainedDie,
            'gainCapped': controller.outcome!.gainCapped,
          },
    'result': controller.result == null
        ? null
        : <String, dynamic>{
            'winnerSeat': controller.result!.winnerSeat,
            'rounds': controller.result!.rounds,
            'standings': controller.result!.standings,
          },
  };
}

// -------------------------------------------------------------- host side

/// Runs the engine on the host phone and broadcasts the snapshots.
/// Guest commands are validated through the seat entry points.
class HostGameRelay {
  HostGameRelay({
    required this.session,
    required List<String> names,
    GameConfig? config,
    bool calzaEnabled = true,
    int Function()? seedFactory,
    Set<int> botSeats = const <int>{},
    this.turnTimeout = const Duration(seconds: 60),
  }) {
    controller = GameController(
      config:
          config ??
          GameConfig(
            opponentCount: names.length - 1,
            calzaEnabled: calzaEnabled,
          ),
      tableNames: names,
      botSeats: botSeats,
      // Salon bots play on the host phone and their bids flow through the
      // usual snapshot broadcast; guests stay pure mirrors.
      autoPlayBots: botSeats.isNotEmpty,
      roundSeeds: seedFactory ?? _defaultRollSeed,
      turnTimeout: turnTimeout,
    );
    controller.addListener(_broadcasting);
    _tableSubscription = session.tableEvents.listen(handleTable);
  }

  bool _gameOverSent = false;

  /// Tells the relay the salon is open again the moment the final standings
  /// exist — and unconditionally at dispose (quit mid-round never produces
  /// standings, but the Worker must reopen the salon all the same).
  void _announceGameOverIfNeeded({bool force = false}) {
    if (_gameOverSent) return;
    if (!force && controller.result == null) return;
    _gameOverSent = true;
    session.sendGameOver();
  }

  final NetworkSalonSession session;
  late final GameController controller;
  StreamSubscription<RelayedTableMessage>? _tableSubscription;

  /// The AFK guard for a human seat: configurable so faster rehearsals
  /// can script tight va-et-vient sessions.
  final Duration turnTimeout;

  int _seedCounter = 0;
  int _seedBase = 0;
  String _lastPayload = '';

  int _defaultRollSeed() {
    if (_seedCounter == 0) {
      _seedBase = DateTime.now().millisecondsSinceEpoch & 0x3fffffff;
    }
    return _seedBase + _seedCounter++ * 7919;
  }

  void start() {
    _broadcasting();
  }

  void dispose() {
    _tableSubscription?.cancel();
    _tableSubscription = null;
    controller.removeListener(_broadcasting);
    // Abandon: forcing the gameOver here is what revives the lobby —
    // without it `started` stays true on the Worker, `isStarting` stays
    // true on this phone ("la manche se prépare" forever, bot +/- blocked)
    // and every rejoin gets "La partie a déjà commencé".
    _announceGameOverIfNeeded(force: true);
  }

  void _broadcasting() {
    final payload = snapshotOf(controller);
    final text = '$payload';
    if (text == _lastPayload) return;
    _lastPayload = text;
    session.sendSnapshot(payload);
    _announceGameOverIfNeeded();
  }

  /// Feeds every guest command into the engine; mutations re-broadcast.
  void handleTable(RelayedTableMessage message) {
    if (message.kind != 'game') return;
    final payload = message.payload;
    if (payload is! Map<String, dynamic>) return;
    final seat = message.fromSeat;
    switch (payload['kind']) {
      case 'bid':
        controller.seatBid(
          seat,
          Bid(
            quantity: (payload['quantity'] as num?)?.toInt() ?? 0,
            face: (payload['face'] as num?)?.toInt() ?? 1,
            playerSeat: seat,
          ),
        );
      case 'dudo':
        controller.seatDudo(seat);
      case 'calza':
        controller.seatCalza(seat, controller.config.calzaEnabled);
      case 'nextRound':
        controller.seatNextRound(seat);
      case 'rematch':
        controller.seatRematch();
      case 'apply':
        // A guest waved the reveal forward: apply (phase-guarded inside)
        // and the mutation re-broadcasts.
        controller.applyOutcome();
      case 'resync':
        // A player reconnected: hand them the full table immediately.
        _lastPayload = '';
        _broadcasting();
      default:
        break;
    }
  }
}

// ------------------------------------------------------------- guest side

/// View-only engine mirror for a guest. It never mutates the rules; the
/// snapshots from the host are the only source of truth. Inputs become
/// WS commands and are validated by the host's engine.
class GuestGameController extends GameController {
  GuestGameController({
    required super.config,
    required NetworkSalonSession session,
    required List<String> names,
  }) : _session = session,
       super(
         tableNames: List<String>.from(names),
         autoPlayBots: false,
         autoStartRound: false,
         enforceTurnTimeout: false,
       ) {
    _subscription = session.tableEvents.listen(handleTable);
    // A table that was mid-round when we arrived (rejoin, reconnect):
    // ask the host for the full picture right away instead of waiting
    // for the next engine mutation to re-broadcast.
    _session.sendGame(const <String, dynamic>{'kind': 'resync'});
  }

  final NetworkSalonSession _session;
  StreamSubscription<RelayedTableMessage>? _subscription;
  BotDifficulty? _hostDifficulty;

  @override
  BotDifficulty get displayedDifficulty =>
      _hostDifficulty ?? super.displayedDifficulty;

  @override
  bool get canBeginBiddingFromPeek => false;

  /// Diagnostics for the field investigations during live rehearsals:
  /// the seed the mirror last applied, and how many snapshots arrived
  /// with no seed at all.
  int? debugLastSeed;
  int debugSeedNullCount = 0;
  int debugSnapshotCount = 0;
  List<int>? debugDerivedLens;
  List<int>? debugAppliedCounts;

  int get mySalonSeat => _session.you;

  /// Salon seat ↔ local seat: "me" is always local seat 0.
  int rebase(int salonSeat, {required int tableSize}) {
    if (tableSize == 0) return salonSeat;
    final my = mySalonSeat;
    return ((salonSeat - my) % tableSize + tableSize) % tableSize;
  }

  void handleTable(RelayedTableMessage message) {
    if (message.kind == 'snapshot') {
      final payload = message.payload;
      if (payload is Map<String, dynamic>) {
        applySnapshot(payload);
      }
    }
  }

  /// Rebuilds the local view from a broadcast snapshot. Sal seats of the
  /// payload are re-based so "me" is seat 0 on the local mirror.
  void applySnapshot(Map<String, dynamic> snapshot) {
    final salonPlayers = snapshot['players'] as List<dynamic>? ?? const [];
    final size = salonPlayers.length;
    if (size == 0) return;
    debugSnapshotCount++;
    final mySeat = mySalonSeat;
    int reb(int salonSeat) => ((salonSeat - mySeat) % size + size) % size;

    // --- players, salon names preserved, ordering "me first".
    final diceCounts = List<int>.filled(size, 0);
    final playerNames = List<String>.filled(size, '');
    for (final raw in salonPlayers) {
      if (raw is! Map<String, dynamic>) continue;
      final salonSeat = (raw['seat'] as num?)?.toInt() ?? -1;
      if (salonSeat < 0 || salonSeat >= size) continue;
      diceCounts[salonSeat] = (raw['diceCount'] as num?)?.toInt() ?? 0;
      playerNames[salonSeat] = '${raw['name'] ?? '?'}';
    }
    players
      ..clear()
      ..addAll([
        for (var local = 0; local < size; local++)
          Player(
            seat: local,
            name: playerNames[(local + mySeat) % size],
            // Only "me" is the human at this table. Every other row shows a
            // real name — marking everyone human made the reveal, the
            // standings and the journal read "Toi" on every line.
            isHuman: local == 0,
            sigil: crew[local % crew.length].sigil,
            accent: crew[local % crew.length].accent,
            nerve: crew[local % crew.length].nerve,
          ),
      ]);
    for (var local = 0; local < size; local++) {
      players[local].diceCount = diceCounts[(local + mySeat) % size];
    }

    // --- phases and table numbers.
    final phaseName = '${snapshot['phase'] ?? 'peek'}';
    phase = GamePhase.values.firstWhere(
      (phase) => phase.name == phaseName,
      orElse: () => GamePhase.peek,
    );
    round = (snapshot['round'] as num?)?.toInt() ?? round;
    palifico = snapshot['palifico'] as bool? ?? false;
    starter = reb((snapshot['starter'] as num?)?.toInt() ?? 0);
    currentPlayer = reb((snapshot['currentPlayer'] as num?)?.toInt() ?? 0);

    // --- deterministic dice for every snapshot that carries a seed. The
    // derivation is idempotent: the same seed plus the same counts always
    // yields the same rolls, so we re-derive on EVERY snapshot instead of
    // only on change — the players list is rebuilt here too, and without
    // the re-roll the second snapshot would wipe the first one's dice and
    // leave the guest staring at the empty-tray placeholder (five pacos),
    // which is exactly what happened on the phones.
    final seedRaw = snapshot['seed'];
    final roundSeed = seedRaw is num ? seedRaw.toInt() : null;
    if (roundSeed != null) {
      _deriveDice(roundSeed, salonDiceCounts: diceCounts, salonStart: mySeat);
      debugLastSeed = roundSeed;
      debugDerivedLens = [for (final p in players) p.dice.length];
      debugAppliedCounts = List<int>.of(diceCounts);
    } else {
      debugSeedNullCount++;
    }

    // --- bid, journal, outcome, result.
    final bidRaw = snapshot['bid'];
    currentBid = bidRaw is Map<String, dynamic> ? _localBid(bidRaw, reb) : null;
    journal
      ..clear()
      ..addAll([
        for (final raw in snapshot['journal'] as List<dynamic>? ?? [])
          if (raw is Map<String, dynamic>) _journalEvent(raw, reb),
      ]);

    final outcomeRaw = snapshot['outcome'];
    outcome = outcomeRaw is Map<String, dynamic>
        ? _outcome(outcomeRaw, reb)
        : null;
    outcomeApplied =
        phase == GamePhase.roundOver || phase == GamePhase.gameOver;

    final resultRaw = snapshot['result'];
    final difficultyName = snapshot['difficulty'];
    if (difficultyName is String) {
      _hostDifficulty = BotDifficulty.values.firstWhere(
        (difficulty) => difficulty.name == difficultyName,
        orElse: () => config.difficulty,
      );
    }
    if (resultRaw is Map<String, dynamic>) {
      final winnerLocal = reb((resultRaw['winnerSeat'] as num?)?.toInt() ?? 0);
      result = GameResult(
        humanWon: winnerLocal == 0 && players.first.isAlive,
        winnerSeat: winnerLocal,
        rounds: (resultRaw['rounds'] as num?)?.toInt() ?? round,
        humanDiceLeft: players.first.diceCount,
        standings: [
          for (final salonSeat
              in resultRaw['standings'] as List<dynamic>? ?? [])
            reb((salonSeat as num).toInt()),
        ],
      );
    } else {
      result = null;
    }

    notifyListeners();
  }

  /// Rolls every seat's dice in SALON-seat order (the host's order), then
  /// assigns the list to the re-based local seats. Values are kept for the
  /// reveal overlays; the UI only ever shows "my" dice.
  void _deriveDice(
    int seed, {
    required List<int> salonDiceCounts,
    required int salonStart,
  }) {
    final rolling = Random(seed);
    final salonOrderDice = List<List<int>?>.filled(
      salonDiceCounts.length,
      null,
      growable: false,
    );
    for (var salonSeat = 0; salonSeat < salonDiceCounts.length; salonSeat++) {
      final count = salonDiceCounts[salonSeat];
      if (count <= 0) continue;
      salonOrderDice[salonSeat] = List<int>.generate(
        count,
        (_) => 1 + rolling.nextInt(6),
      );
    }
    for (var local = 0; local < players.length; local++) {
      final salonSeat = (local + salonStart) % players.length;
      players[local].dice = List<int>.of(
        salonOrderDice[salonSeat] ?? const <int>[],
      );
    }
  }

  Bid _localBid(Map<String, dynamic> raw, int Function(int salon) rebase) {
    return Bid(
      quantity: (raw['q'] as num?)?.toInt() ?? 0,
      face: (raw['f'] as num?)?.toInt() ?? 1,
      playerSeat: rebase((raw['s'] as num?)?.toInt() ?? 0),
    );
  }

  TableEvent _journalEvent(Map<String, dynamic> raw, int Function(int) reb) {
    final bidRaw = raw['b'];
    final callerSeat = reb((raw['s'] as num?)?.toInt() ?? 0);
    return TableEvent(
      round: (raw['r'] as num?)?.toInt() ?? 0,
      playerSeat: callerSeat,
      kind: raw['k'] == 'dudo'
          ? TableEventKind.dudo
          : raw['k'] == 'calza'
          ? TableEventKind.calza
          : TableEventKind.bid,
      bid: bidRaw is Map<String, dynamic>
          ? Bid(
              quantity: (bidRaw['q'] as num?)?.toInt() ?? 0,
              face: (bidRaw['f'] as num?)?.toInt() ?? 1,
              playerSeat: callerSeat,
            )
          : null,
    );
  }

  ChallengeOutcome _outcome(Map<String, dynamic> raw, int Function(int) reb) {
    final bidRaw = (raw['bid'] as Map<String, dynamic>?) ?? const {};
    return ChallengeOutcome(
      bid: _localBid(bidRaw, reb),
      callerSeat: reb((raw['caller'] as num?)?.toInt() ?? 0),
      kind: raw['kind'] == 'calza' ? ChallengeKind.calza : ChallengeKind.dudo,
      actualCount: (raw['actual'] as num?)?.toInt() ?? 0,
      exact: raw['exact'] as bool? ?? false,
      callerWon: raw['callerWon'] as bool? ?? false,
      loserSeat: raw['loser'] == null
          ? null
          : reb((raw['loser'] as num).toInt()),
      gainSeat: raw['gain'] == null ? null : reb((raw['gain'] as num).toInt()),
      gainedDie: raw['gained'] as bool? ?? false,
      gainCapped: raw['gainCapped'] as bool? ?? false,
    );
  }

  // ------------------------------------------------- outgoing commands

  @override
  bool submitHumanBid(Bid bid) {
    if (!isHumanTurn) return false;
    _session.sendGame(<String, dynamic>{
      'kind': 'bid',
      'quantity': bid.quantity,
      'face': bid.face,
    });
    return true;
  }

  @override
  bool callHumanDudo() {
    if (!canHumanChallenge) return false;
    _session.sendGame(const <String, dynamic>{'kind': 'dudo'});
    return true;
  }

  @override
  bool callHumanCalza() {
    if (!canHumanCalza) return false;
    _session.sendGame(const <String, dynamic>{'kind': 'calza'});
    return true;
  }

  @override
  void nextRound() {
    _session.sendGame(const <String, dynamic>{'kind': 'nextRound'});
  }

  @override
  void rematch() {
    _session.sendGame(const <String, dynamic>{'kind': 'rematch'});
  }

  @override
  void applyOutcome() {
    // The reveal is host-authoritative: the guest's tap waves the host's
    // engine forward and the applied outcome comes back in a snapshot.
    _session.sendGame(const <String, dynamic>{'kind': 'apply'});
  }

  @override
  void beginBidding() {
    // The host's snapshot flips the phase; nothing to do locally.
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}

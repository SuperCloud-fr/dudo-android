import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../logic/bot_brain.dart';
import '../logic/perudo_rules.dart';
import '../models/bid.dart';
import '../models/game_config.dart';
import '../models/player.dart';
import '../models/table_event.dart';

/// Owns one game from the first peek to the final handshake. The UI listens
/// and animates; it never decides what is legal.
class GameController extends ChangeNotifier {
  GameController({
    required this.config,
    Random? random,
    this.botDelay = const Duration(milliseconds: 820),
    this.autoPlayBots = true,
    this.tableNames,
    this.roundSeeds,
    this.autoStartRound = true,
    this.botSeats = const <int>{},
    this.turnTimeout = const Duration(seconds: 60),
    this.enforceTurnTimeout = true,
    int? humanSeat,
    this.shuffleSeats = false,
  }) : random = random ?? Random(),
       humanSeat =
           humanSeat ??
           _defaultHumanSeat(
             shuffleSeats: shuffleSeats,
             tableNames: tableNames,
             opponents: config.opponentCount,
             random: random,
           ) {
    _buildPlayers();
    if (autoStartRound) {
      _startRound(starterSeat: this.humanSeat);
    }
  }

  final GameConfig config;
  final Random random;
  final Duration botDelay;
  final bool autoPlayBots;

  /// Seat names in seat order (seat 0 included). When provided, the table
  /// is built from these names with no bots — network games drive every
  /// seat from outside (WS commands / snapshots).
  final List<String>? tableNames;

  /// Optional per-round seed source. When provided, every round's dice are
  /// rolled with `Random(seed)` so remote players replaying the same seed
  /// get the exact same dice; solo games keep their inner `random`.
  final int Function()? roundSeeds;

  /// False for network guests: the first snapshot builds the round.
  final bool autoStartRound;

  /// Network tables only: salon seats that sit as bots. Empty for solo
  /// (the config adds bots) and for guest mirrors (nothing plays locally).
  /// A listed seat is driven by this controller's bot loop.
  final Set<int> botSeats;

  /// How long a human turn may sit untouched before the table moves
  /// without its player (issue #7: an AFK pirate must not stall the sea,
  /// solo table or online salon). Zero disables it entirely.
  final Duration turnTimeout;

  /// False for guest mirrors: the host engine is the one guarding time;
  /// a mirror would fight it with its own fallback.
  final bool enforceTurnTimeout;

  /// Engine seat of the local player. Solo tables keep the human at seat
  /// 0 unless shuffled; on a network table the relay deals the seats, so
  /// the host phone may own any engine seat. Guest mirrors stay at 0 —
  /// their local view is re-based ("me" = seat 0) before it ever lands.
  final int humanSeat;

  /// Solo tables only: deal the human a random seat and shuffle the bot
  /// crew around them, so the seating (and with it the turn order)
  /// changes from one game to the next. Network tables shuffle at the
  /// relay instead, where the salon-seat mapping lives.
  final bool shuffleSeats;

  /// Seat the solo human gets when shuffled; zero otherwise.
  static int _defaultHumanSeat({
    required bool shuffleSeats,
    required List<String>? tableNames,
    required int opponents,
    required Random? random,
  }) {
    if (!shuffleSeats || tableNames != null) return 0;
    return (random ?? Random()).nextInt(opponents + 1);
  }

  final List<Player> players = <Player>[];
  final List<TableEvent> journal = <TableEvent>[];

  GamePhase phase = GamePhase.peek;
  int round = 0;
  bool palifico = false;

  /// Set when a live seat reaches one die this round; the next round is
  /// palifico, and only that one (a seat sitting at one die after its
  /// palifico round plays with normal rules again).
  bool _palificoPending = false;
  int starter = 0;
  int currentPlayer = 0;
  Bid? currentBid;
  ChallengeOutcome? outcome;
  bool outcomeApplied = false;
  GameResult? result;

  /// Seed of the dice currently on the table (network games only).
  int? lastRoundSeed;

  Timer? _botTimer;
  Timer? _turnTimer;
  Timer? _spectatorTimer;
  bool _disposed = false;
  bool _paused = false;
  int _nextStarter = 0;

  Player get human => players[humanSeat];

  /// Players in display order: "me" first, then clockwise (seat order).
  /// Solo tables and host engines may have the human away from seat 0;
  /// guest mirrors are already re-based, so this is the identity there.
  List<Player> get tableOrder => [
    for (var index = 0; index < players.length; index++)
      players[(humanSeat + index) % players.length],
  ];
  BotDifficulty get displayedDifficulty => config.difficulty;
  bool get isHumanTurn =>
      phase == GamePhase.bidding && currentPlayer == humanSeat;

  /// Whether this device may advance the private-peek screen into bidding.
  /// In solo play and on the authoritative host this is true; salon guests
  /// wait for the host to start the shared bidding phase.
  bool get canBeginBiddingFromPeek => true;
  bool get canHumanChallenge =>
      isHumanTurn && currentBid != null && currentBid!.playerSeat != humanSeat;
  bool get canHumanCalza => canHumanChallenge && config.calzaEnabled;
  bool get hasBid => currentBid != null;

  int get totalDice {
    var total = 0;
    for (final player in players) {
      if (player.isAlive) total += player.diceCount;
    }
    return total;
  }

  List<Bid> get humanLegalBids => PerudoRules.legalBids(
    previous: currentBid,
    totalDice: totalDice,
    playerSeat: humanSeat,
    palifico: palifico,
  );

  Bid? get defaultHumanBid => PerudoRules.suggestedRaise(
    previous: currentBid,
    totalDice: totalDice,
    playerSeat: humanSeat,
    palifico: palifico,
  );

  List<TableEvent> get roundEvents =>
      journal.where((event) => event.round == round).toList(growable: false);

  void _buildPlayers() {
    if (tableNames != null) {
      // Network table: one seat per salon player, all driven externally.
      // Only the relay-dealt [humanSeat] reads as "Toi" — the other humans
      // are guests on their own phones and must keep their names (two
      // "Toi" bug). Bots stay identified by [botSeats], not this flag.
      for (var seat = 0; seat < tableNames!.length; seat++) {
        final profile = crew[seat % crew.length];
        players.add(
          Player(
            seat: seat,
            name: tableNames![seat],
            isHuman: seat == humanSeat,
            sigil: profile.sigil,
            accent: profile.accent,
            nerve: profile.nerve,
          ),
        );
      }
      return;
    }
    // Solo table: the human sits at [humanSeat] (seat 0 unless shuffled)
    // and the bot crew fills the remaining seats, crew order shuffled too
    // so the whole seating changes from one game to the next.
    final crewOrder = List.of(crew);
    if (shuffleSeats) crewOrder.shuffle(random);
    var botIndex = 0;
    for (var seat = 0; seat <= config.opponentCount; seat++) {
      if (seat == humanSeat) {
        players.add(
          Player(
            seat: seat,
            name: 'Toi',
            isHuman: true,
            sigil: 5,
            accent: 3,
            nerve: 0,
          ),
        );
        continue;
      }
      final profile = crewOrder[botIndex % crewOrder.length];
      botIndex++;
      players.add(
        Player(
          seat: seat,
          name: profile.name,
          isHuman: false,
          sigil: profile.sigil,
          accent: profile.accent,
          nerve: profile.nerve,
        ),
      );
    }
  }

  void _startRound({required int starterSeat}) {
    final seed = roundSeeds?.call();
    lastRoundSeed = seed;
    final roundRandom = seed == null ? null : Random(seed);
    int Function() nextDie;
    if (roundRandom == null) {
      nextDie = () => 1 + random.nextInt(6);
    } else {
      nextDie = () => 1 + roundRandom.nextInt(6);
    }
    round++;
    currentBid = null;
    outcome = null;
    outcomeApplied = false;
    phase = GamePhase.peek;
    palifico = _palificoPending;
    _palificoPending = false;
    for (final player in players) {
      if (player.isAlive) {
        player.roll(nextDie);
      } else {
        // No stale cup from a previous round behind the spectator screen.
        player.dice = const <int>[];
      }
    }
    currentPlayer = _firstAliveFrom(starterSeat);
    starter = currentPlayer;
    _nextStarter = currentPlayer;
    _cancelBot();
    _notify();
  }

  /// Called when the human has looked at their cup and is ready to play.
  void beginBidding() {
    if (phase != GamePhase.peek) return;
    phase = GamePhase.bidding;
    currentPlayer = starter;
    _notify();
  }

  bool submitHumanBid(Bid bid) {
    if (!isHumanTurn) return false;
    return _placeBid(bid.copyWith(playerSeat: humanSeat));
  }

  bool callHumanDudo() {
    if (!canHumanChallenge) return false;
    _resolveChallenge(ChallengeKind.dudo, currentPlayer);
    return true;
  }

  bool callHumanCalza() {
    if (!canHumanCalza) return false;
    _resolveChallenge(ChallengeKind.calza, currentPlayer);
    return true;
  }

  // ------------------------------------------------------- seat commands
  // Network games drive every seat from the outside: the guest's WS
  // commands land here (validated against the current turn), and the
  // saloon-shaped outcome is broadcast back as a snapshot.

  bool seatBid(int seat, Bid bid) {
    if (seat != currentPlayer || phase != GamePhase.bidding) return false;
    return _placeBid(bid.copyWith(playerSeat: seat));
  }

  bool seatDudo(int seat) {
    if (seat != currentPlayer) return false;
    if (currentBid == null || currentBid!.playerSeat == seat) return false;
    _resolveChallenge(ChallengeKind.dudo, seat);
    return true;
  }

  bool seatCalza(int seat, bool calzaEnabled) {
    if (seat != currentPlayer || !calzaEnabled) return false;
    if (currentBid == null || currentBid!.playerSeat == seat) return false;
    _resolveChallenge(ChallengeKind.calza, seat);
    return true;
  }

  bool seatNextRound(int seat) {
    if (phase != GamePhase.roundOver) return false;
    // Any live seat may wave the round forward; the host triggers it.
    nextRound();
    return true;
  }

  bool seatRematch() {
    if (phase != GamePhase.gameOver) return false;
    rematch();
    return true;
  }

  bool _placeBid(Bid bid) {
    if (phase != GamePhase.bidding) return false;
    final normalized = bid.copyWith(playerSeat: currentPlayer);
    final legal = PerudoRules.isLegalRaise(
      previous: currentBid,
      next: normalized,
      totalDice: totalDice,
      palifico: palifico,
    );
    if (!legal) return false;

    currentBid = normalized;
    journal.add(
      TableEvent(
        round: round,
        playerSeat: currentPlayer,
        kind: TableEventKind.bid,
        bid: normalized,
      ),
    );
    _advanceTurn();
    return true;
  }

  void _advanceTurn() {
    if (phase != GamePhase.bidding) return;
    currentPlayer = _nextAliveFrom(currentPlayer);
    _notify();
  }

  /// Executes one bot decision. The screen calls this through a timer, while
  /// tests can drive it directly with [autoPlayBots] disabled.
  void performBotMove() {
    _botTimer?.cancel();
    _botTimer = null;
    if (_disposed || phase != GamePhase.bidding) return;
    if (!_seatIsBot(currentPlayer)) return;
    final player = players[currentPlayer];

    final brain = BotBrain(difficulty: config.difficulty, random: random);
    final action = brain.decide(
      ownDice: player.dice,
      totalDice: totalDice,
      selfSeat: player.seat,
      currentBid: currentBid,
      calzaEnabled: config.calzaEnabled,
      nerve: player.nerve,
      palifico: palifico,
    );

    switch (action) {
      case BidAction(:final bid):
        if (!_placeBid(bid)) {
          _fallbackBotMove(player.seat);
        }
      case DudoAction():
        if (currentBid != null && currentBid!.playerSeat != player.seat) {
          _resolveChallenge(ChallengeKind.dudo, player.seat);
        } else {
          _fallbackBotMove(player.seat);
        }
      case CalzaAction():
        if (config.calzaEnabled &&
            currentBid != null &&
            currentBid!.playerSeat != player.seat) {
          _resolveChallenge(ChallengeKind.calza, player.seat);
        } else {
          _fallbackBotMove(player.seat);
        }
    }
  }

  void _fallbackBotMove(int seat) {
    final fallback = PerudoRules.defaultRaise(
      previous: currentBid,
      totalDice: totalDice,
      playerSeat: seat,
      palifico: palifico,
    );
    if (fallback != null && _placeBid(fallback)) return;
    if (currentBid != null && currentBid!.playerSeat != seat) {
      _resolveChallenge(ChallengeKind.dudo, seat);
    } else {
      _advanceTurn();
    }
  }

  void _resolveChallenge(ChallengeKind kind, int callerSeat) {
    final bid = currentBid;
    if (bid == null) return;

    final allDice = <int>[];
    for (final player in players) {
      if (player.isAlive) allDice.addAll(player.dice);
    }
    final actual = PerudoRules.countForFace(
      allDice,
      bid.face,
      palifico: palifico,
    );
    final exact = actual == bid.quantity;
    final callerWon = kind == ChallengeKind.dudo
        ? actual < bid.quantity
        : exact;

    final int? loserSeat;
    if (kind == ChallengeKind.dudo) {
      loserSeat = callerWon ? bid.playerSeat : callerSeat;
    } else {
      loserSeat = callerWon ? null : callerSeat;
    }
    final gainSeat = kind == ChallengeKind.calza && callerWon
        ? callerSeat
        : null;
    final gainCapped =
        gainSeat != null &&
        players[gainSeat].diceCount >= PerudoRules.maxDicePerPlayer;

    outcome = ChallengeOutcome(
      bid: bid,
      callerSeat: callerSeat,
      kind: kind,
      actualCount: actual,
      exact: exact,
      callerWon: callerWon,
      loserSeat: loserSeat,
      gainSeat: gainSeat,
      gainedDie: gainSeat != null && !gainCapped,
      gainCapped: gainCapped,
    );
    journal.add(
      TableEvent(
        round: round,
        playerSeat: callerSeat,
        kind: kind == ChallengeKind.dudo
            ? TableEventKind.dudo
            : TableEventKind.calza,
      ),
    );
    phase = GamePhase.reveal;
    _cancelBot();
    _notify();
  }

  /// Applies the consequence of the reveal and either opens the next round or
  /// ends the game when only one pirate still has dice.
  void applyOutcome() {
    final current = outcome;
    if (phase != GamePhase.reveal || current == null) return;

    // A live seat that ends this challenge on exactly one die — and was not
    // already palifico — locks the next round into palifico.
    final alreadyAtOne = players
        .where((player) => player.isAlive && player.diceCount == 1)
        .map((player) => player.seat)
        .toSet();

    if (current.loserSeat != null) {
      players[current.loserSeat!].loseDie();
    }
    if (current.gainSeat != null && current.gainedDie) {
      players[current.gainSeat!].gainDie();
    }
    outcomeApplied = true;
    _palificoPending = players.any(
      (player) =>
          player.isAlive &&
          player.diceCount == 1 &&
          !alreadyAtOne.contains(player.seat),
    );

    if (current.kind == ChallengeKind.calza && current.callerWon) {
      _nextStarter = current.callerSeat;
    } else if (current.loserSeat != null &&
        players[current.loserSeat!].isAlive) {
      _nextStarter = current.loserSeat!;
    } else if (current.loserSeat != null) {
      _nextStarter = _nextAliveFrom(current.loserSeat!);
    } else {
      _nextStarter = _nextAliveFrom(current.callerSeat);
    }

    final alive = players.where((player) => player.isAlive).toList();
    // The table plays on until a single pirate still has dice — an
    // eliminated player watches the rest of the round (multiplayer: the
    // host's own elimination must NOT end the game for everyone).
    if (alive.length <= 1) {
      _finishGame();
    } else {
      phase = GamePhase.roundOver;
    }
    _notify();
  }

  void nextRound() {
    if (phase != GamePhase.roundOver) return;
    _startRound(starterSeat: _nextStarter);
  }

  void rematch() {
    _cancelBot();
    for (final player in players) {
      player.diceCount = PerudoRules.maxDicePerPlayer;
      player.dice = const <int>[];
    }
    round = 0;
    journal.clear();
    currentBid = null;
    outcome = null;
    outcomeApplied = false;
    result = null;
    _nextStarter = humanSeat;
    _startRound(starterSeat: humanSeat);
  }

  void _finishGame() {
    final alive = players.where((player) => player.isAlive).toList();
    final winner = alive.isEmpty
        ? players.first
        : alive.reduce((a, b) => a.diceCount >= b.diceCount ? a : b);
    final humanWon = human.isAlive && alive.length == 1;
    final standings = List<Player>.from(players)
      ..sort((a, b) {
        final byDice = b.diceCount.compareTo(a.diceCount);
        if (byDice != 0) return byDice;
        return a.seat.compareTo(b.seat);
      });
    result = GameResult(
      humanWon: humanWon,
      winnerSeat: winner.seat,
      rounds: round,
      humanDiceLeft: human.diceCount,
      standings: standings.map((player) => player.seat).toList(),
    );
    phase = GamePhase.gameOver;
    _cancelBot();
  }

  int _nextAliveFrom(int seat) {
    for (var offset = 1; offset <= players.length; offset++) {
      final candidate = (seat + offset) % players.length;
      if (players[candidate].isAlive) return candidate;
    }
    return seat;
  }

  int _firstAliveFrom(int seat) {
    if (players[seat].isAlive) return seat;
    return _nextAliveFrom(seat);
  }

  /// Stops the bots while a modal is open, so the table does not move behind
  /// the player's back. The current turn is preserved.
  void pauseBots() {
    _paused = true;
    _cancelBot();
  }

  void resumeBots() {
    _paused = false;
    _scheduleBot();
    _scheduleTurnTimeout();
    _scheduleSpectatorAdvance();
  }

  /// Seats this engine plays by itself: explicit salon bots, or (offline
  /// table) every non-human seat. Guests are NOT bots — they play on their
  /// own phones and must never be puppeted here.
  bool _seatIsBot(int seat) =>
      botSeats.contains(seat) || (tableNames == null && !players[seat].isHuman);

  void _scheduleBot() {
    if (!autoPlayBots || _disposed || _paused) return;
    _botTimer?.cancel();
    _botTimer = null;
    if (phase != GamePhase.bidding) return;
    if (!_seatIsBot(currentPlayer)) return;
    final delay = botDelay + Duration(milliseconds: random.nextInt(360));
    _botTimer = Timer(delay, () {
      _botTimer = null;
      if (_disposed) return;
      performBotMove();
    });
  }

  /// Arms the AFK guard when a human seat owns the turn (issue #7). Every
  /// table change re-arms it, so the clock really measures "nothing moved
  /// for [turnTimeout]", not "your turn lasted [turnTimeout]". Paused while
  /// a modal keeps the table open (rules, journal, leave-game check).
  void _scheduleTurnTimeout() {
    _turnTimer?.cancel();
    _turnTimer = null;
    if (!enforceTurnTimeout || _disposed || _paused) return;
    if (turnTimeout <= Duration.zero) return;
    if (phase != GamePhase.bidding) return;
    // The guard covers every human seat — the host's own seat AND the
    // guests (issue #7): only the bots are excluded, they act themselves.
    if (_seatIsBot(currentPlayer)) return;
    _turnTimer = Timer(turnTimeout, _enforceTurnTimeout);
  }

  /// The turn's owner stayed silent for [turnTimeout]: the table moves on
  /// with the cheapest legal raise, exactly like a bot's safety net. If no
  /// raise fits, dudo; if even that is impossible, the turn simply passes.
  void _enforceTurnTimeout() {
    _turnTimer = null;
    if (_disposed || _paused) return;
    if (phase != GamePhase.bidding || _seatIsBot(currentPlayer)) return;
    _fallbackBotMove(currentPlayer);
  }

  /// Test hook: fires the AFK guard now instead of after [turnTimeout].
  @visibleForTesting
  void enforceTurnTimeoutNow() => _enforceTurnTimeout();

  void _notify() {
    if (_disposed) return;
    notifyListeners();
    _scheduleBot();
    _scheduleTurnTimeout();
    _scheduleSpectatorAdvance();
  }

  /// A table with no human seat left plays itself: the eliminated local
  /// player only watches, and the engine waves each phase along after a
  /// short read — no tapping through the last rounds between bots.
  void _scheduleSpectatorAdvance() {
    _spectatorTimer?.cancel();
    _spectatorTimer = null;
    if (!autoPlayBots || _disposed || _paused) return;
    if (human.isAlive) return;
    if (players.where((player) => player.isAlive).length <= 1) return;
    final Duration wait;
    switch (phase) {
      case GamePhase.peek:
        wait = const Duration(milliseconds: 1200);
      case GamePhase.reveal:
        wait = const Duration(milliseconds: 1800);
      case GamePhase.roundOver:
        wait = const Duration(milliseconds: 900);
      default:
        return;
    }
    _spectatorTimer = Timer(wait, () {
      _spectatorTimer = null;
      switch (phase) {
        case GamePhase.peek:
          beginBidding();
        case GamePhase.reveal:
          applyOutcome();
        case GamePhase.roundOver:
          nextRound();
        default:
          break;
      }
    });
  }

  void _cancelBot() {
    _botTimer?.cancel();
    _botTimer = null;
    _turnTimer?.cancel();
    _turnTimer = null;
    _spectatorTimer?.cancel();
    _spectatorTimer = null;
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelBot();
    super.dispose();
  }
}

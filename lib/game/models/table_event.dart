import 'bid.dart';

enum GamePhase { peek, bidding, reveal, roundOver, gameOver }

enum TableEventKind { bid, dudo, calza }

class TableEvent {
  const TableEvent({
    required this.round,
    required this.playerSeat,
    required this.kind,
    this.bid,
  });

  final int round;
  final int playerSeat;
  final TableEventKind kind;
  final Bid? bid;
}

enum ChallengeKind { dudo, calza }

/// Everything the reveal screen needs to explain what just happened.
class ChallengeOutcome {
  const ChallengeOutcome({
    required this.bid,
    required this.callerSeat,
    required this.kind,
    required this.actualCount,
    required this.exact,
    required this.callerWon,
    required this.loserSeat,
    required this.gainSeat,
    required this.gainedDie,
    required this.gainCapped,
  });

  final Bid bid;
  final int callerSeat;
  final ChallengeKind kind;
  final int actualCount;
  final bool exact;

  /// True when the caller was right (dudo on a false bid, or exact calza).
  final bool callerWon;

  /// The seat that will lose a die when the outcome is applied. Null on a
  /// successful calza.
  final int? loserSeat;

  /// The seat that gains a die on a successful calza.
  final int? gainSeat;

  /// False when the calza was right but the player already had five dice.
  final bool gainedDie;
  final bool gainCapped;

  int get bidderSeat => bid.playerSeat;

  /// The bid held (was at least true), independent of who called.
  bool get bidHeld => actualCount >= bid.quantity;
}

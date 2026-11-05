import 'package:flutter/foundation.dart';

/// Mutable state for one seat at the table.
class Player {
  Player({
    required this.seat,
    required this.name,
    required this.isHuman,
    required this.sigil,
    required this.accent,
    required this.nerve,
    this.diceCount = 5,
    List<int>? dice,
  }) : dice = dice ?? const <int>[];

  final int seat;
  final String name;
  final bool isHuman;
  final int sigil;
  final int accent;
  final double nerve;

  int diceCount;
  List<int> dice;

  bool get isAlive => diceCount > 0;
  bool get isOut => diceCount <= 0;

  int get aces => dice.where((die) => die == 1).length;

  Set<int> get faces => dice.toSet();

  void roll(int Function() nextDie) {
    dice = List<int>.generate(diceCount, (_) => nextDie());
  }

  void loseDie() {
    if (diceCount > 0) diceCount--;
  }

  bool gainDie() {
    if (diceCount >= 5) return false;
    diceCount++;
    return true;
  }

  @override
  String toString() => 'Player($seat, $name, $diceCount dice)';
}

@immutable
class GameResult {
  const GameResult({
    required this.humanWon,
    required this.winnerSeat,
    required this.rounds,
    required this.humanDiceLeft,
    required this.standings,
  });

  final bool humanWon;
  final int winnerSeat;
  final int rounds;
  final int humanDiceLeft;

  /// Seats ordered from best to worst at the moment the game ended.
  final List<int> standings;
}

import 'package:flutter/foundation.dart';

enum BotDifficulty {
  mousse(
    label: 'P\'tit mousse',
    description: 'Un matelot craintif, qui mord facilement à l\'hameçon.',
    challengeThreshold: 0.20,
    raiseConfidence: 0.70,
    bluffChance: 0.20,
    calzaThreshold: 0.46,
  ),
  flibustier(
    label: 'Corsaire',
    description: 'Un adversaire équilibré, qui repère les bluffs.',
    challengeThreshold: 0.27,
    raiseConfidence: 0.58,
    bluffChance: 0.13,
    calzaThreshold: 0.40,
  ),
  capitaine(
    label: 'Capitaine',
    description: 'Il calcule les probabilités et déteste perdre.',
    challengeThreshold: 0.33,
    raiseConfidence: 0.53,
    bluffChance: 0.08,
    calzaThreshold: 0.35,
  );

  const BotDifficulty({
    required this.label,
    required this.description,
    required this.challengeThreshold,
    required this.raiseConfidence,
    required this.bluffChance,
    required this.calzaThreshold,
  });

  final String label;
  final String description;

  /// Challenge when the estimated probability of the current bid falls below.
  final double challengeThreshold;

  /// Minimum estimated probability when choosing a new bid.
  final double raiseConfidence;

  /// Chance of raising beyond the safe range to apply pressure.
  final double bluffChance;

  /// Minimum exact-match probability before a bot considers calza.
  final double calzaThreshold;
}

/// Static identity of one pirate. The visual sigil is chosen by its index.
@immutable
class BotProfile {
  const BotProfile({
    required this.name,
    required this.sigil,
    required this.accent,
    required this.nerve,
  });

  final String name;
  final int sigil;
  final int accent;

  /// -1 is cautious, +1 is a reckless bluffer.
  final double nerve;
}

const List<BotProfile> crew = <BotProfile>[
  BotProfile(name: 'Barbe-Noire', sigil: 0, accent: 4, nerve: 0.20),
  BotProfile(name: 'Anne Bonny', sigil: 1, accent: 1, nerve: -0.12),
  BotProfile(name: 'Rackham', sigil: 2, accent: 2, nerve: 0.04),
  BotProfile(name: 'Barbe-Rousse', sigil: 3, accent: 0, nerve: 0.24),
  BotProfile(name: 'Mérou', sigil: 4, accent: 4, nerve: -0.18),
];

@immutable
class GameConfig {
  const GameConfig({
    this.opponentCount = 3,
    this.difficulty = BotDifficulty.flibustier,
    this.calzaEnabled = true,
  }) : assert(opponentCount >= 1 && opponentCount <= 5);

  final int opponentCount;
  final BotDifficulty difficulty;
  final bool calzaEnabled;

  int get playerCount => opponentCount + 1;
}

import 'dart:math';

import '../models/bid.dart';
import '../models/game_config.dart';
import 'perudo_rules.dart';

sealed class BotAction {
  const BotAction();
}

class BidAction extends BotAction {
  const BidAction(this.bid);
  final Bid bid;
}

class DudoAction extends BotAction {
  const DudoAction();
}

class CalzaAction extends BotAction {
  const CalzaAction();
}

/// Probability helpers used by the bots. Exposed so the reasoning can be
/// tested independently from the UI.
abstract final class DiceProbability {
  static double atLeast({
    required int needed,
    required int unknownDice,
    required double chance,
  }) {
    if (needed <= 0) return 1;
    if (needed > unknownDice) return 0;
    var total = 0.0;
    for (var k = needed; k <= unknownDice; k++) {
      total += _pmf(k, unknownDice, chance);
    }
    return total.clamp(0.0, 1.0);
  }

  static double exactly({
    required int needed,
    required int unknownDice,
    required double chance,
  }) {
    if (needed < 0 || needed > unknownDice) return 0;
    return _pmf(needed, unknownDice, chance);
  }

  static double chanceForFace(int face) => face == 1 ? 1 / 6 : 2 / 6;
}

double _pmf(int successes, int trials, double chance) {
  if (successes < 0 || successes > trials) return 0;
  return (_combinations(trials, successes) *
          pow(chance, successes) *
          pow(1 - chance, trials - successes))
      .toDouble();
}

int _combinations(int n, int k) {
  if (k < 0 || k > n) return 0;
  final m = min(k, n - k);
  var result = 1;
  for (var i = 1; i <= m; i++) {
    result = result * (n - m + i) ~/ i;
  }
  return result;
}

/// A pirate who reasons from their own dice, the number of dice still on the
/// table, and the bid in front of them. It never peeks at another cup.
class BotBrain {
  BotBrain({required this.difficulty, required this.random});

  final BotDifficulty difficulty;
  final Random random;

  BotAction decide({
    required List<int> ownDice,
    required int totalDice,
    required int selfSeat,
    required Bid? currentBid,
    required bool calzaEnabled,
    required double nerve,
  }) {
    if (totalDice <= 0) {
      return const DudoAction();
    }

    if (currentBid != null) {
      return _answerBid(
        ownDice: ownDice,
        totalDice: totalDice,
        selfSeat: selfSeat,
        currentBid: currentBid,
        calzaEnabled: calzaEnabled,
        nerve: nerve,
      );
    }
    return _openBid(
      ownDice: ownDice,
      totalDice: totalDice,
      selfSeat: selfSeat,
      nerve: nerve,
    );
  }

  BotAction _answerBid({
    required List<int> ownDice,
    required int totalDice,
    required int selfSeat,
    required Bid currentBid,
    required bool calzaEnabled,
    required double nerve,
  }) {
    final unknown = max(0, totalDice - ownDice.length);
    final ownMatches = PerudoRules.countForFace(ownDice, currentBid.face);
    final chance = DiceProbability.chanceForFace(currentBid.face);
    final needed = max(0, currentBid.quantity - ownMatches);
    final pCurrent = DiceProbability.atLeast(
      needed: needed,
      unknownDice: unknown,
      chance: chance,
    );
    final pExact = DiceProbability.exactly(
      needed: needed,
      unknownDice: unknown,
      chance: chance,
    );

    final threshold =
        (difficulty.challengeThreshold + nerve * 0.04 + _jitter(0.012)).clamp(
          0.08,
          0.48,
        );

    final candidates = PerudoRules.legalBids(
      previous: currentBid,
      totalDice: totalDice,
      playerSeat: selfSeat,
    );
    final safe = <Bid>[];
    final probabilities = <Bid, double>{};
    for (final bid in candidates) {
      final own = PerudoRules.countForFace(ownDice, bid.face);
      final p = DiceProbability.atLeast(
        needed: max(0, bid.quantity - own),
        unknownDice: unknown,
        chance: DiceProbability.chanceForFace(bid.face),
      );
      probabilities[bid] = p;
      final bar = (difficulty.raiseConfidence - nerve * 0.05).clamp(0.40, 0.82);
      if (p >= bar) safe.add(bid);
    }

    if (calzaEnabled &&
        pExact >= difficulty.calzaThreshold &&
        pCurrent > 0.62 &&
        random.nextDouble() < 0.42 + nerve * 0.08) {
      return const CalzaAction();
    }

    if (pCurrent < threshold) {
      // Even a liar can double down. Mostly, take the challenge.
      if (safe.isNotEmpty &&
          random.nextDouble() < difficulty.bluffChance * 0.5) {
        return BidAction(_pickSafe(safe, probabilities, ownDice));
      }
      return const DudoAction();
    }

    if (safe.isNotEmpty) {
      return BidAction(_pickSafe(safe, probabilities, ownDice));
    }

    // No comfortable raise exists. If the current bid still looks plausible,
    // sometimes apply pressure with a bluff; otherwise challenge.
    if (pCurrent > 0.68 &&
        candidates.isNotEmpty &&
        random.nextDouble() < difficulty.bluffChance + max(0.0, nerve) * 0.06) {
      return BidAction(candidates.first);
    }
    return const DudoAction();
  }

  BotAction _openBid({
    required List<int> ownDice,
    required int totalDice,
    required int selfSeat,
    required double nerve,
  }) {
    final candidates = PerudoRules.legalBids(
      previous: null,
      totalDice: totalDice,
      playerSeat: selfSeat,
    );
    if (candidates.isEmpty) return const DudoAction();

    final minimumQuantity = totalDice >= 5 ? 2 : 1;
    final unknown = max(0, totalDice - ownDice.length);
    Bid? best;
    var bestScore = double.negativeInfinity;

    for (final bid in candidates) {
      if (bid.quantity < minimumQuantity) continue;
      final own = PerudoRules.countForFace(ownDice, bid.face);
      final p = DiceProbability.atLeast(
        needed: max(0, bid.quantity - own),
        unknownDice: unknown,
        chance: DiceProbability.chanceForFace(bid.face),
      );
      final affinity = own / max(1, ownDice.length);
      final target = 0.70 - nerve * 0.05;
      final closeness = 1 - (p - target).abs();
      final facePenalty = bid.face == 1 ? 0.10 : 0.0;
      final score = closeness + affinity * 0.20 - facePenalty;
      if (score > bestScore) {
        bestScore = score;
        best = bid;
      }
    }

    best ??= candidates.first;
    if (random.nextDouble() < difficulty.bluffChance * 0.5) {
      final index = candidates.indexOf(best);
      if (index + 1 < candidates.length) best = candidates[index + 1];
    }
    return BidAction(best);
  }

  Bid _pickSafe(
    List<Bid> safe,
    Map<Bid, double> probabilities,
    List<int> ownDice,
  ) {
    // Prefer the most comfortable bids, but not always the very same one:
    // pirates have habits, and predictability is death at this table.
    safe.sort((a, b) {
      final p = (probabilities[b] ?? 0).compareTo(probabilities[a] ?? 0);
      if (p != 0) return p;
      return a.quantity.compareTo(b.quantity);
    });
    final pool = safe.take(min(3, safe.length)).toList();
    return pool[random.nextInt(pool.length)];
  }

  double _jitter(double amount) {
    return (random.nextDouble() * 2 - 1) * amount;
  }
}

import '../models/bid.dart';

/// Pure Perudo rules. No UI, no randomness, no hidden knowledge.
abstract final class PerudoRules {
  static const int faces = 6;
  static const int maxDicePerPlayer = 5;

  /// In a palifico round (a player is down to one die), the opening bid must
  /// be worth at least this many dice, and every later bid is locked on the
  /// opening face.
  static const int palificoOpeningMinimum = 2;

  /// A bid is legal when it strictly raises the previous one.
  ///
  /// Standard conversions:
  /// - normal → aces: at least half the quantity, rounded up;
  /// - aces → normal: double the aces plus one;
  /// - normal → normal: more dice, or the same dice with a higher face.
  ///
  /// The opening bid cannot be aces: aces are wild, so opening on them
  /// would hand the opener an unfair edge.
  ///
  /// Palifico (a live player sits at exactly one die):
  /// - the opening bid fixes the face of the whole round;
  /// - later bids must keep that face and may only raise the quantity;
  /// - aces are not wild (they only count as aces);
  /// - the opening bid must be worth at least [palificoOpeningMinimum].
  static bool isLegalRaise({
    required Bid? previous,
    required Bid next,
    required int totalDice,
    bool palifico = false,
  }) {
    if (next.quantity < 1 || next.quantity > totalDice) return false;
    if (next.face < 1 || next.face > faces) return false;
    if (previous == null) {
      if (palifico) {
        return totalDice >= palificoOpeningMinimum &&
            next.quantity >= palificoOpeningMinimum;
      }
      return next.face != 1;
    }
    if (palifico) {
      return next.face == previous.face && next.quantity > previous.quantity;
    }

    if (previous.face == 1) {
      if (next.face == 1) {
        return next.quantity > previous.quantity;
      }
      return next.quantity >= previous.quantity * 2 + 1;
    }

    if (next.face == 1) {
      final minimum = (previous.quantity / 2).ceil();
      return next.quantity >= minimum;
    }

    if (next.quantity > previous.quantity) return true;
    if (next.quantity == previous.quantity) return next.face > previous.face;
    return false;
  }

  /// Smallest quantity that can be announced for [face], or null when that
  /// face cannot be bid at all (palifico rounds lock the face to the one
  /// already announced). Aces are not wild during a palifico round.
  static int? minQuantityForFace({
    required Bid? previous,
    required int face,
    bool palifico = false,
  }) {
    if (face < 1 || face > faces) return null;
    if (previous == null) {
      if (palifico) return palificoOpeningMinimum;
      // Aces are wild: opening on them is not allowed.
      return face == 1 ? null : 1;
    }
    if (palifico) {
      if (face != previous.face) return null;
      return previous.quantity + 1;
    }
    if (previous.face == 1) {
      if (face == 1) return previous.quantity + 1;
      return previous.quantity * 2 + 1;
    }
    if (face == 1) return (previous.quantity / 2).ceil();
    if (face > previous.face) return previous.quantity;
    return previous.quantity + 1;
  }

  static bool canBidFace({
    required Bid? previous,
    required int face,
    required int totalDice,
    bool palifico = false,
  }) {
    if (face < 1 || face > faces) return false;
    final min = minQuantityForFace(
      previous: previous,
      face: face,
      palifico: palifico,
    );
    if (min == null) return false;
    return min <= totalDice;
  }

  /// All legal bids for the player to move, ordered from the cheapest raise
  /// to the most expensive one.
  static List<Bid> legalBids({
    required Bid? previous,
    required int totalDice,
    required int playerSeat,
    bool palifico = false,
  }) {
    final bids = <Bid>[];
    for (final face in _faceOrder(previous)) {
      final min = minQuantityForFace(
        previous: previous,
        face: face,
        palifico: palifico,
      );
      if (min == null) continue;
      for (var quantity = min; quantity <= totalDice; quantity++) {
        bids.add(Bid(quantity: quantity, face: face, playerSeat: playerSeat));
      }
    }
    bids.sort(_compareStrength);
    return bids;
  }

  /// The first legal raise, used as a safety net for bots.
  static Bid? defaultRaise({
    required Bid? previous,
    required int totalDice,
    required int playerSeat,
    bool palifico = false,
  }) {
    final all = legalBids(
      previous: previous,
      totalDice: totalDice,
      playerSeat: playerSeat,
      palifico: palifico,
    );
    return all.isEmpty ? null : all.first;
  }

  /// A human-friendly first raise: keep the same face and add a die whenever
  /// possible, instead of jumping straight to aces.
  static Bid? suggestedRaise({
    required Bid? previous,
    required int totalDice,
    required int playerSeat,
    bool palifico = false,
  }) {
    if (totalDice <= 0) return null;
    if (previous == null) {
      if (palifico) {
        if (totalDice < palificoOpeningMinimum) return null;
        return Bid(
          quantity: palificoOpeningMinimum,
          face: 2,
          playerSeat: playerSeat,
        );
      }
      final quantity = totalDice >= 10 ? 3 : 2;
      if (quantity <= totalDice) {
        return Bid(quantity: quantity, face: 2, playerSeat: playerSeat);
      }
      return Bid(quantity: 1, face: 2, playerSeat: playerSeat);
    }

    if (palifico) {
      final raise = previous.quantity + 1;
      if (raise <= totalDice) {
        return Bid(
          quantity: raise,
          face: previous.face,
          playerSeat: playerSeat,
        );
      }
      return null;
    }

    if (previous.face != 1) {
      final sameFace = previous.quantity + 1;
      if (sameFace <= totalDice) {
        return Bid(
          quantity: sameFace,
          face: previous.face,
          playerSeat: playerSeat,
        );
      }
      for (var face = previous.face + 1; face <= faces; face++) {
        if (previous.quantity <= totalDice) {
          return Bid(
            quantity: previous.quantity,
            face: face,
            playerSeat: playerSeat,
          );
        }
      }
      final aceMin = (previous.quantity / 2).ceil();
      if (aceMin <= totalDice) {
        return Bid(quantity: aceMin, face: 1, playerSeat: playerSeat);
      }
    } else {
      final aceRaise = previous.quantity + 1;
      if (aceRaise <= totalDice) {
        return Bid(quantity: aceRaise, face: 1, playerSeat: playerSeat);
      }
      final normalMin = previous.quantity * 2 + 1;
      if (normalMin <= totalDice) {
        return Bid(quantity: normalMin, face: 2, playerSeat: playerSeat);
      }
    }
    return defaultRaise(
      previous: previous,
      totalDice: totalDice,
      playerSeat: playerSeat,
    );
  }

  static List<int> _faceOrder(Bid? previous) {
    if (previous == null || previous.face == 1) {
      return const [2, 3, 4, 5, 6, 1];
    }
    final rest = <int>[2, 3, 4, 5, 6, 1]..remove(previous.face);
    return <int>[previous.face, ...rest];
  }

  /// Rough bid strength: quantity dominates, face breaks ties. Aces sit
  /// between the equivalent normal quantity and the next one.
  static double _strength(Bid bid) {
    if (bid.face == 1) return bid.quantity * 2 - 0.5;
    return bid.quantity * 2 + (bid.face - 2) * 0.1;
  }

  static int _compareStrength(Bid a, Bid b) {
    final byStrength = _strength(a).compareTo(_strength(b));
    if (byStrength != 0) return byStrength;
    return a.face.compareTo(b.face);
  }

  /// How many dice in [dice] satisfy [face]. Aces are wild for every other
  /// face — except during a palifico round, where they only count as aces.
  static int countForFace(
    Iterable<int> dice,
    int face, {
    bool palifico = false,
  }) {
    if (face == 1) return dice.where((die) => die == 1).length;
    if (palifico) return dice.where((die) => die == face).length;
    return dice.where((die) => die == face || die == 1).length;
  }

  static bool bidHolds(Bid bid, Iterable<int> dice, {bool palifico = false}) {
    return countForFace(dice, bid.face, palifico: palifico) >= bid.quantity;
  }

  static bool bidExact(Bid bid, Iterable<int> dice, {bool palifico = false}) {
    return countForFace(dice, bid.face, palifico: palifico) == bid.quantity;
  }

  /// True when a die matches [face] for the reveal highlight.
  static bool dieMatches(int die, int face, {bool palifico = false}) {
    if (face == 1) return die == 1;
    if (palifico) return die == face;
    return die == face || die == 1;
  }

  static String faceName(int face) => face == 1 ? 'paco' : '$face';
}

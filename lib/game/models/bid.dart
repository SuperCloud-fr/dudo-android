import 'package:flutter/foundation.dart';

/// A bid on the table: at least [quantity] dice showing [face].
///
/// Ones are aces and count as wild for every other face. A bid on aces is
/// therefore worth roughly twice a bid on any other face.
@immutable
class Bid {
  const Bid({
    required this.quantity,
    required this.face,
    required this.playerSeat,
  });

  final int quantity;
  final int face;
  final int playerSeat;

  bool get isAces => face == 1;

  String get faceLabel => isAces ? 'as' : '$face';

  /// "3 as" or "4 dés de 5".
  String get label {
    if (isAces) return '$quantity as';
    return '$quantity ${quantity == 1 ? 'dé' : 'dés'} de $face';
  }

  /// Compact form used in the bid history.
  String get shortLabel => '$quantity×${isAces ? 'A' : face}';

  String get spokenLabel {
    if (isAces) {
      return 'au moins $quantity as';
    }
    return 'au moins $quantity ${quantity == 1 ? 'dé' : 'dés'} de valeur $face';
  }

  Bid copyWith({int? quantity, int? face, int? playerSeat}) {
    return Bid(
      quantity: quantity ?? this.quantity,
      face: face ?? this.face,
      playerSeat: playerSeat ?? this.playerSeat,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Bid &&
        other.quantity == quantity &&
        other.face == face &&
        other.playerSeat == playerSeat;
  }

  @override
  int get hashCode => Object.hash(quantity, face, playerSeat);

  @override
  String toString() => 'Bid($quantity×$face by seat $playerSeat)';
}

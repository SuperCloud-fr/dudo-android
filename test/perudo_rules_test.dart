import 'package:dudo/game/logic/perudo_rules.dart';
import 'package:dudo/game/models/bid.dart';
import 'package:flutter_test/flutter_test.dart';

Bid bid(int quantity, int face, {int seat = 0}) {
  return Bid(quantity: quantity, face: face, playerSeat: seat);
}

void main() {
  group('surenchères', () {
    test('une ouverture est libre dans la limite des dés en jeu', () {
      expect(
        PerudoRules.isLegalRaise(previous: null, next: bid(1, 2), totalDice: 5),
        isTrue,
      );
      expect(
        PerudoRules.isLegalRaise(previous: null, next: bid(6, 2), totalDice: 5),
        isFalse,
      );
    });

    test('même face : il faut ajouter un dé', () {
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(4, 5),
          next: bid(5, 5),
          totalDice: 20,
        ),
        isTrue,
      );
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(4, 5),
          next: bid(4, 5),
          totalDice: 20,
        ),
        isFalse,
      );
    });

    test('même quantité : seule une face plus haute monte', () {
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(4, 5),
          next: bid(4, 6),
          totalDice: 20,
        ),
        isTrue,
      );
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(4, 5),
          next: bid(4, 4),
          totalDice: 20,
        ),
        isFalse,
      );
    });

    test('passage aux as : moitié arrondie au-dessus', () {
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(4, 5),
          next: bid(2, 1),
          totalDice: 20,
        ),
        isTrue,
      );
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(4, 5),
          next: bid(1, 1),
          totalDice: 20,
        ),
        isFalse,
      );
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(3, 5),
          next: bid(2, 1),
          totalDice: 20,
        ),
        isTrue,
      );
    });

    test('retour des as : double plus un', () {
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(2, 1),
          next: bid(5, 2),
          totalDice: 20,
        ),
        isTrue,
      );
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(2, 1),
          next: bid(4, 2),
          totalDice: 20,
        ),
        isFalse,
      );
    });

    test('les as se surenchérissent comme une face normale', () {
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(2, 1),
          next: bid(3, 1),
          totalDice: 20,
        ),
        isTrue,
      );
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(3, 1),
          next: bid(3, 1),
          totalDice: 20,
        ),
        isFalse,
      );
    });

    test('on ne dépasse jamais le nombre de dés en jeu', () {
      expect(
        PerudoRules.isLegalRaise(
          previous: bid(9, 5),
          next: bid(11, 2),
          totalDice: 10,
        ),
        isFalse,
      );
    });
  });

  group('minimums et suggestions', () {
    test('calcule le minimum par face', () {
      expect(PerudoRules.minQuantityForFace(previous: null, face: 4), 1);
      expect(PerudoRules.minQuantityForFace(previous: bid(4, 5), face: 5), 5);
      expect(PerudoRules.minQuantityForFace(previous: bid(4, 5), face: 6), 4);
      expect(PerudoRules.minQuantityForFace(previous: bid(4, 5), face: 1), 2);
      expect(PerudoRules.minQuantityForFace(previous: bid(2, 1), face: 3), 5);
    });

    test('suggère une surenchère naturelle', () {
      expect(
        PerudoRules.suggestedRaise(
          previous: bid(3, 5),
          totalDice: 10,
          playerSeat: 0,
        ),
        bid(4, 5),
      );
      expect(
        PerudoRules.suggestedRaise(
          previous: bid(6, 5),
          totalDice: 10,
          playerSeat: 0,
        ),
        bid(7, 5),
      );
      expect(
        PerudoRules.suggestedRaise(
          previous: bid(10, 5),
          totalDice: 10,
          playerSeat: 0,
        ),
        bid(10, 6),
      );
      expect(
        PerudoRules.suggestedRaise(
          previous: bid(2, 1),
          totalDice: 20,
          playerSeat: 0,
        ),
        bid(3, 1),
      );
    });

    test('toutes les enchères légales sont réellement légales', () {
      for (final total in [3, 10, 20]) {
        final previous = bid(4, 3);
        final legal = PerudoRules.legalBids(
          previous: previous,
          totalDice: total,
          playerSeat: 0,
        );
        for (final candidate in legal) {
          expect(
            PerudoRules.isLegalRaise(
              previous: previous,
              next: candidate,
              totalDice: total,
            ),
            isTrue,
            reason: '$candidate devrait être légale (total=$total)',
          );
        }
      }
    });
  });

  group('comptage', () {
    test('les as comptent pour toutes les faces', () {
      const dice = [1, 5, 5, 3, 6];
      expect(PerudoRules.countForFace(dice, 5), 3);
      expect(PerudoRules.countForFace(dice, 6), 2);
      expect(PerudoRules.countForFace(dice, 4), 1);
    });

    test('un pari sur les as ne compte que les as', () {
      const dice = [1, 1, 5, 5, 5];
      expect(PerudoRules.countForFace(dice, 1), 2);
    });

    test('pari tenu et pari exact', () {
      const dice = [1, 5, 5, 3];
      expect(PerudoRules.bidHolds(bid(3, 5), dice), isTrue);
      expect(PerudoRules.bidHolds(bid(4, 5), dice), isFalse);
      expect(PerudoRules.bidExact(bid(3, 5), dice), isTrue);
      expect(PerudoRules.bidExact(bid(2, 5), dice), isFalse);
    });

    test('les as sont jokers sauf pour un pari sur les as', () {
      expect(PerudoRules.dieMatches(1, 4), isTrue);
      expect(PerudoRules.dieMatches(4, 4), isTrue);
      expect(PerudoRules.dieMatches(5, 4), isFalse);
      expect(PerudoRules.dieMatches(1, 1), isTrue);
      expect(PerudoRules.dieMatches(2, 1), isFalse);
    });
  });
}

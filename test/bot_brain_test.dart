import 'dart:math';

import 'package:dudo/game/logic/bot_brain.dart';
import 'package:dudo/game/logic/perudo_rules.dart';
import 'package:dudo/game/models/bid.dart';
import 'package:dudo/game/models/game_config.dart';
import 'package:flutter_test/flutter_test.dart';

Bid randomBid(Random random, int total, {int seat = 1}) {
  return Bid(
    quantity: 1 + random.nextInt(total),
    face: 1 + random.nextInt(6),
    playerSeat: seat,
  );
}

void main() {
  group('probabilités', () {
    test('bornes évidentes', () {
      expect(
        DiceProbability.atLeast(needed: 0, unknownDice: 5, chance: 0.3),
        1,
      );
      expect(
        DiceProbability.atLeast(needed: 6, unknownDice: 5, chance: 0.3),
        0,
      );
      expect(
        DiceProbability.exactly(needed: 6, unknownDice: 5, chance: 0.3),
        0,
      );
    });

    test('la loi binomiale somme à un', () {
      var total = 0.0;
      for (var k = 0; k <= 8; k++) {
        total += DiceProbability.exactly(
          needed: k,
          unknownDice: 8,
          chance: 1 / 3,
        );
      }
      expect(total, closeTo(1, 1e-9));
    });

    test('un as est plus dur à sortir qu\'une face normale', () {
      final ace = DiceProbability.atLeast(
        needed: 2,
        unknownDice: 6,
        chance: DiceProbability.chanceForFace(1),
      );
      final normal = DiceProbability.atLeast(
        needed: 2,
        unknownDice: 6,
        chance: DiceProbability.chanceForFace(4),
      );
      expect(ace, lessThan(normal));
    });
  });

  group('décisions des bots', () {
    test('un pari impossible est contesté', () {
      final brain = BotBrain(
        difficulty: BotDifficulty.flibustier,
        random: Random(4),
      );
      final action = brain.decide(
        ownDice: const [2, 3, 4, 5, 6],
        totalDice: 5,
        selfSeat: 0,
        currentBid: const Bid(quantity: 5, face: 5, playerSeat: 1),
        calzaEnabled: true,
        nerve: 0,
      );
      expect(action, isA<DudoAction>());
    });

    test('un bot ouvre toujours par une enchère légale', () {
      for (var seed = 0; seed < 100; seed++) {
        final random = Random(seed);
        final total = 4 + random.nextInt(26);
        final ownCount = 1 + random.nextInt(5);
        final own = List<int>.generate(ownCount, (_) => 1 + random.nextInt(6));
        final action =
            BotBrain(
              difficulty: BotDifficulty.values[seed % 3],
              random: random,
            ).decide(
              ownDice: own,
              totalDice: max(total, ownCount),
              selfSeat: 0,
              currentBid: null,
              calzaEnabled: true,
              nerve: 0,
            );
        expect(action, isA<BidAction>());
        final bid = (action as BidAction).bid;
        expect(
          PerudoRules.isLegalRaise(
            previous: null,
            next: bid,
            totalDice: max(total, ownCount),
          ),
          isTrue,
        );
      }
    });

    test('toutes les actions restent légales sur des états aléatoires', () {
      for (var seed = 0; seed < 600; seed++) {
        final random = Random(seed);
        final ownCount = 1 + random.nextInt(5);
        final total = max(ownCount, 1 + random.nextInt(30));
        final own = List<int>.generate(ownCount, (_) => 1 + random.nextInt(6));
        final current = randomBid(random, total);
        final action =
            BotBrain(
              difficulty: BotDifficulty.values[seed % 3],
              random: random,
            ).decide(
              ownDice: own,
              totalDice: total,
              selfSeat: 0,
              currentBid: current,
              calzaEnabled: true,
              nerve: (seed % 5 - 2) * 0.05,
            );

        switch (action) {
          case BidAction(:final bid):
            expect(
              PerudoRules.isLegalRaise(
                previous: current,
                next: bid,
                totalDice: total,
              ),
              isTrue,
              reason: 'seed $seed : $bid après $current (total $total)',
            );
            expect(bid.quantity, inInclusiveRange(1, total));
          case DudoAction():
          case CalzaAction():
            break;
        }
      }
    });

    test('le bot ne consulte que ses propres dés', () {
      final first =
          BotBrain(
            difficulty: BotDifficulty.capitaine,
            random: Random(11),
          ).decide(
            ownDice: const [2, 2, 4, 6, 6],
            totalDice: 20,
            selfSeat: 0,
            currentBid: const Bid(quantity: 4, face: 2, playerSeat: 1),
            calzaEnabled: true,
            nerve: 0.1,
          );
      final second =
          BotBrain(
            difficulty: BotDifficulty.capitaine,
            random: Random(11),
          ).decide(
            ownDice: const [2, 2, 4, 6, 6],
            totalDice: 20,
            selfSeat: 0,
            currentBid: const Bid(quantity: 4, face: 2, playerSeat: 1),
            calzaEnabled: true,
            nerve: 0.1,
          );
      expect(first.runtimeType, second.runtimeType);
      if (first is BidAction && second is BidAction) {
        expect(first.bid, second.bid);
      }
    });
  });

  group('palifico', () {
    test('un bot respecte la face verrouillee', () {
      for (var seed = 0; seed < 200; seed++) {
        final random = Random(seed);
        final qty = 2 + random.nextInt(4);
        final own = List<int>.generate(
          1 + random.nextInt(5),
          (_) => 1 + random.nextInt(6),
        );
        final total = max(qty + 1, 8 + random.nextInt(22));
        final action =
            BotBrain(
              difficulty: BotDifficulty.values[seed % 3],
              random: random,
            ).decide(
              ownDice: own,
              totalDice: total,
              selfSeat: 0,
              currentBid: Bid(quantity: qty, face: 4, playerSeat: 1),
              calzaEnabled: true,
              nerve: (seed % 5 - 2) * 0.05,
              palifico: true,
            );
        if (action is BidAction) {
          expect(action.bid.face, 4);
          expect(action.bid.quantity, greaterThan(qty));
        }
      }
    });

    test('un bot ouvre au moins 2 de en palifico', () {
      for (var seed = 0; seed < 100; seed++) {
        final random = Random(seed);
        final own = List<int>.generate(5, (_) => 1 + random.nextInt(6));
        final action =
            BotBrain(
              difficulty: BotDifficulty.values[seed % 3],
              random: random,
            ).decide(
              ownDice: own,
              totalDice: 15 + random.nextInt(10),
              selfSeat: 0,
              currentBid: null,
              calzaEnabled: true,
              nerve: 0,
              palifico: true,
            );
        if (action is BidAction) {
          expect(action.bid.quantity, greaterThanOrEqualTo(2));
        }
      }
    });
  });
}

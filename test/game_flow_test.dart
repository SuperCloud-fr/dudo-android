import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:dudo/game/logic/bot_brain.dart';
import 'package:dudo/game/models/bid.dart';
import 'package:dudo/game/models/game_config.dart';
import 'package:dudo/game/models/table_event.dart';
import 'package:dudo/game/state/game_controller.dart';
import 'package:flutter_test/flutter_test.dart';

GameController createGame({required int seed, required GameConfig config}) {
  return GameController(
    config: config,
    random: Random(seed),
    autoPlayBots: false,
  );
}

/// Drives a complete game. The human seat is played by a sharp bot so that
/// every branch of the engine is reachable without a screen.
GameController playToEnd({required int seed, required GameConfig config}) {
  final controller = createGame(seed: seed, config: config);
  var steps = 0;
  var trackedRound = -1;
  int? faceLocked;

  while (controller.phase != GamePhase.gameOver && steps < 20000) {
    steps++;
    for (final player in controller.players) {
      expect(player.diceCount, inInclusiveRange(0, 5));
    }

    if (controller.round != trackedRound) {
      trackedRound = controller.round;
      faceLocked = null;
    }
    if (controller.palifico) {
      final pending = controller.currentBid;
      if (pending != null) {
        faceLocked ??= pending.face;
        expect(
          pending.face,
          faceLocked,
          reason: 'seed $seed, step $steps: palifico broken',
        );
      }
    }

    switch (controller.phase) {
      case GamePhase.peek:
        controller.beginBidding();
      case GamePhase.bidding:
        final player = controller.players[controller.currentPlayer];
        if (player.isHuman) {
          final action =
              BotBrain(
                difficulty: BotDifficulty.capitaine,
                random: Random(seed * 7919 + steps),
              ).decide(
                ownDice: player.dice,
                totalDice: controller.totalDice,
                selfSeat: player.seat,
                currentBid: controller.currentBid,
                calzaEnabled: config.calzaEnabled,
                nerve: 0,
                palifico: controller.palifico,
              );
          final accepted = switch (action) {
            BidAction(:final bid) => controller.submitHumanBid(bid),
            DudoAction() => controller.callHumanDudo(),
            CalzaAction() => controller.callHumanCalza(),
          };
          if (!accepted) {
            debugPrint(
              'REFUSED seed=$seed step=$steps act=${action.runtimeType}'
              ' curBid=${controller.currentBid?.label}'
              ' palifico=${controller.palifico}'
              ' dice=${player.dice}',
            );
          }
          expect(
            accepted,
            isTrue,
            reason: 'seed $seed, étape $steps : action humaine refusée',
          );
        } else {
          controller.performBotMove();
        }
      case GamePhase.reveal:
        controller.applyOutcome();
      case GamePhase.roundOver:
        controller.nextRound();
      case GamePhase.gameOver:
        break;
    }
  }

  expect(
    controller.phase,
    GamePhase.gameOver,
    reason: 'la partie aurait dû se terminer (seed $seed)',
  );
  expect(controller.result, isNotNull);
  return controller;
}

void main() {
  group('parties complètes', () {
    for (final opponents in [1, 3, 5]) {
      for (final difficulty in BotDifficulty.values) {
        test('$opponents adversaires, ${difficulty.label}', () {
          for (var seed = 1; seed <= 4; seed++) {
            final controller = playToEnd(
              seed: seed * 31 + opponents,
              config: GameConfig(
                opponentCount: opponents,
                difficulty: difficulty,
                calzaEnabled: true,
              ),
            );
            final result = controller.result!;
            final alive = controller.players
                .where((player) => player.isAlive)
                .toList();
            if (result.humanWon) {
              expect(alive.length, 1);
              expect(alive.single.isHuman, isTrue);
            } else {
              expect(
                controller.human.isAlive,
                isFalse,
                reason:
                    'une défaite doit correspondre à un humain éliminé ou '
                    'à une table sans humain',
              );
            }
            expect(result.rounds, greaterThan(0));
            expect(result.standings.toSet().length, controller.players.length);
            controller.dispose();
          }
        });
      }
    }

    test('les dés ne dépassent jamais cinq par joueur avec calza', () {
      for (var seed = 1; seed <= 5; seed++) {
        final controller = playToEnd(
          seed: seed,
          config: const GameConfig(
            opponentCount: 5,
            difficulty: BotDifficulty.capitaine,
            calzaEnabled: true,
          ),
        );
        for (final player in controller.players) {
          expect(player.diceCount, inInclusiveRange(0, 5));
        }
        controller.dispose();
      }
    });
  });

  test('rematch remet la table à neuf', () {
    final controller = playToEnd(
      seed: 3,
      config: const GameConfig(opponentCount: 3),
    );
    final previousRounds = controller.round;
    controller.rematch();
    expect(controller.round, 1);
    expect(controller.phase, GamePhase.peek);
    expect(controller.result, isNull);
    expect(controller.journal, isEmpty);
    expect(controller.players.every((player) => player.diceCount == 5), isTrue);
    expect(previousRounds, greaterThan(0));
    controller.dispose();
  });

  group('palifico (issue #2)', () {
    /// Simulates a dudo challenge whose loser loses one die, without playing
    /// a full round: the phase bookkeeping is set by hand.
    void winChallengeAgainst(GameController controller, int loserSeat) {
      final target = controller.players[loserSeat];
      expect(target.diceCount, inInclusiveRange(1, 5));
      controller
        ..phase = GamePhase.reveal
        ..outcome = ChallengeOutcome(
          bid: Bid(
            quantity: target.diceCount,
            face: 5,
            playerSeat: loserSeat,
          ),
          callerSeat: 0,
          kind: ChallengeKind.dudo,
          actualCount: 0,
          exact: false,
          callerWon: true,
          loserSeat: loserSeat,
          gainSeat: null,
          gainedDie: false,
          gainCapped: false,
        )
        ..applyOutcome();
    }

    test('la manche qui suit la chute à un dé est palifico, puis plus', () {
      final controller = createGame(
        seed: 7,
        config: const GameConfig(opponentCount: 3),
      );
      expect(controller.palifico, isFalse);

      controller.players[1].diceCount = 2;
      winChallengeAgainst(controller, 1);
      expect(controller.players[1].diceCount, 1);
      controller.nextRound();
      expect(
        controller.palifico,
        isTrue,
        reason: 'le tour qui suit la chute à un dé est palifico',
      );

      // The palifico seat survives its round on one die; another seat loses
      // a die without reaching one. Nobody *new* sits at one die, so the
      // next round plays with normal rules.
      winChallengeAgainst(controller, 2);
      controller.nextRound();
      expect(
        controller.palifico,
        isFalse,
        reason: 'le palifico ne dure qu\'une manche',
      );
      controller.dispose();
    });

    test('remonter à deux dés puis rechuter redéclenche le palifico', () {
      final controller = createGame(
        seed: 7,
        config: const GameConfig(opponentCount: 3),
      );
      controller.players[1].diceCount = 2;
      winChallengeAgainst(controller, 1);
      controller.nextRound();
      expect(controller.palifico, isTrue);

      controller.players[1].diceCount = 2;
      winChallengeAgainst(controller, 1);
      controller.nextRound();
      expect(
        controller.palifico,
        isTrue,
        reason: 'une rechute à un dé re-déclenche le palifico',
      );
      controller.dispose();
    });
  });
}

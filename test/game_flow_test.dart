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

  test('la table continue quand le siège local est à l\'eau', () {
    final controller = createGame(
      seed: 5,
      config: const GameConfig(opponentCount: 2),
    );

    // A challenge the local seat loses with its last die, while the two
    // other pirates still hold dice: the game must NOT end (multiplayer —
    // an eliminated host keeps the table alive for its guests).
    controller.players[0].diceCount = 1;
    controller.players[1].diceCount = 2;
    controller.players[2].diceCount = 2;
    controller
      ..phase = GamePhase.reveal
      ..outcome = ChallengeOutcome(
        bid: const Bid(quantity: 1, face: 2, playerSeat: 0),
        callerSeat: 1,
        kind: ChallengeKind.dudo,
        actualCount: 0,
        exact: false,
        callerWon: true,
        loserSeat: 0,
        gainSeat: null,
        gainedDie: false,
        gainCapped: false,
      )
      ..applyOutcome();
    expect(controller.players[0].isAlive, isFalse);
    expect(controller.phase, GamePhase.roundOver);
    controller.nextRound();
    expect(controller.phase, GamePhase.peek);

    // It only ends when a single pirate still has dice.
    controller.players[1].diceCount = 1;
    controller
      ..phase = GamePhase.reveal
      ..outcome = ChallengeOutcome(
        bid: const Bid(quantity: 1, face: 3, playerSeat: 1),
        callerSeat: 2,
        kind: ChallengeKind.dudo,
        actualCount: 0,
        exact: false,
        callerWon: true,
        loserSeat: 1,
        gainSeat: null,
        gainedDie: false,
        gainCapped: false,
      )
      ..applyOutcome();
    expect(controller.phase, GamePhase.gameOver);
    expect(controller.result, isNotNull);
    controller.dispose();
  });

  testWidgets('une table sans humain avance toute seule', (tester) async {
    final controller = GameController(
      config: const GameConfig(opponentCount: 2),
      random: Random(11),
      autoPlayBots: true,
    );

    // The local seat is already out: bots-only tables must play through
    // without a spectator tapping "Voir la manche" on every round.
    controller.players[0]
      ..diceCount = 0
      ..dice = const <int>[];
    controller
      ..phase = GamePhase.reveal
      ..outcome = ChallengeOutcome(
        bid: const Bid(quantity: 1, face: 2, playerSeat: 0),
        callerSeat: 1,
        kind: ChallengeKind.dudo,
        actualCount: 0,
        exact: false,
        callerWon: true,
        loserSeat: 0,
        gainSeat: null,
        gainedDie: false,
        gainCapped: false,
      )
      ..applyOutcome();
    expect(controller.phase, GamePhase.roundOver);

    // roundOver → next round opens by itself…
    await tester.pump(const Duration(seconds: 2));
    expect(controller.phase, GamePhase.peek);
    // …and peek → bidding too: the bots carry the game to the end.
    await tester.pump(const Duration(seconds: 2));
    expect(controller.phase, GamePhase.bidding);

    controller.dispose();
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
          bid: Bid(quantity: target.diceCount, face: 5, playerSeat: loserSeat),
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

  group('timeout de tour humain (issue #7)', () {
    test('un pirate AFK annonce l\u2019enchère minimale', () {
      final controller = createGame(
        seed: 7,
        config: const GameConfig(opponentCount: 3),
      );
      controller.beginBidding();
      expect(controller.currentBid, isNull);

      // 60 s plus tard (hook de test) : l'enchère par défaut tombe.
      controller.enforceTurnTimeoutNow();
      expect(controller.currentBid, isNotNull);
      expect(controller.currentBid!.playerSeat, 0);
      expect(controller.currentPlayer, 1, reason: 'au PNJ suivant');
      controller.dispose();
    });

    test('aucun timeout pendant une modale (pause bots)', () {
      final controller = createGame(
        seed: 7,
        config: const GameConfig(opponentCount: 3),
      );
      controller.beginBidding();
      controller.pauseBots();

      controller.enforceTurnTimeoutNow();
      expect(controller.currentBid, isNull, reason: 'table en pause');

      controller.resumeBots();
      controller.enforceTurnTimeoutNow();
      expect(controller.currentBid, isNotNull);
      controller.dispose();
    });

    test('les PNJ ne sont pas actés par le garde-fou humain', () {
      final controller = createGame(
        seed: 7,
        config: const GameConfig(opponentCount: 3),
      );
      controller.beginBidding();
      controller.enforceTurnTimeoutNow(); // siège 0 (humain) parle.
      // Le siège 1 est un PNJ : son timer de réflexion reste maître.
      expect(controller.players[1].isHuman, isFalse);
      controller.enforceTurnTimeoutNow();
      expect(controller.currentBid!.playerSeat, isNot(1));
      controller.dispose();
    });

    test('le mélange sied le capitaine au hasard, sans casser la table', () {
      // Several seeds: the human seat must vary, and the engine must hold
      // its invariants wherever the deal puts the human.
      final dealtSeats = <int>{};
      for (var seed = 0; seed < 60; seed++) {
        final controller = GameController(
          config: const GameConfig(opponentCount: 3),
          random: Random(seed),
          shuffleSeats: true,
          autoPlayBots: false,
        );
        final humanSeat = controller.humanSeat;
        dealtSeats.add(humanSeat);
        expect(humanSeat, inInclusiveRange(0, 3), reason: 'graine $seed');
        expect(controller.human.isHuman, isTrue);
        expect(controller.human.name, 'Toi');
        expect(
          controller.players.where((player) => player.isHuman),
          hasLength(1),
        );
        // Round 1 opens at the human's seat; the seat circle is intact.
        expect(controller.starter, humanSeat, reason: 'graine $seed');
        expect(controller.currentPlayer, humanSeat, reason: 'graine $seed');
        expect(
          [for (final player in controller.tableOrder) player.seat],
          [for (var index = 0; index < 4; index++) (humanSeat + index) % 4],
          reason:
              'affichage : moi d\u2019abord, puis sens horaire (graine $seed)',
        );
        // Three distinct crew names fill the bot seats.
        expect(
          controller.players
              .where((player) => !player.isHuman)
              .map((player) => player.name)
              .toSet()
              .length,
          3,
        );
        controller.dispose();
      }
      expect(
        dealtSeats.length,
        greaterThan(1),
        reason:
            'le tirage doit changer de siège d\u2019une partie à l\u2019autre',
      );
    });
  });
}

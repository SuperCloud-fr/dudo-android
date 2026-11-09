// Répétition générale : deux "téléphones" simulés contre le vrai Worker.
// C'est le code réseau de l'APK lui-même (sessions, relais hôte, miroir
// invité) piloté par des stratégies scriptées plutôt que par des doigts :
//
//   $env:LIVE='1' ; flutter test test\two_phones_rehearsal_test.dart
//
// Sans LIVE=1, le test s'annule (jamais de réseau dans la suite normale).
import 'dart:io';

import 'package:dudo/game/models/game_config.dart';
import 'package:dudo/game/models/table_event.dart';
import 'package:dudo/salon/network_game.dart';
import 'package:dudo/salon/network_salon_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'répétition générale : deux téléphones + 3 bots contre le vrai serveur',
    timeout: Timeout(Duration(minutes: 12)),
    () async {
      final live = Platform.environment['LIVE'] ?? '';
      if (live != '1') {
        // Jamais de réseau dans la suite ordinaire ; sous LIVE=1 seulement.
        return;
      }
      // Le binding de flutter_test piège HttpClient (réponses 400 du
      // forgeron-furtif) : une zone avec un override neutre — un vrai
      // HttpClient, aucune réponse jouée — remet le réseau VRAI aux
      // sessions, POST comme WebSocket.
      await HttpOverrides.runWithHttpOverrides(_rehearsal, _RealHttp());
    },
  );
}

/// Un override neutre : la base dart:io rend un vrai HttpClient, sans
/// réserve ni jouet.
class _RealHttp extends HttpOverrides {}

Future<void> _rehearsal() async {
  final log = <String>[];
  void say(String line) {
    final stamp = DateTime.now().toIso8601String().substring(11, 19);
    final entry = '$stamp $line';
    log.add(entry);
    // ignore: avoid_print
    print(entry);
  }

  // Téléphone A : l'hôte avec 3 bots. Téléphone B : l'invité.
  final host = NetworkSalonSession();
  final guest = NetworkSalonSession();
  try {
    await host.createSalon('Simul Hote', 3);
    expect(host.code, hasLength(6), reason: 'code à six caractères');
    final code = host.code;
    say('salon créé : $code');

    await guest.joinSalon(code, 'Simul Anne');
    expect(guest.code, code, reason: 'les deux côtés voient le même code');
    // La présence de l'invité voyage sur un petit broadcast : on laisse
    // les deux côtés rattraper la fenêtre.
    for (var tick = 0; tick < 40; tick++) {
      if (host.players.length == 5 && guest.players.length == 5) break;
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
    expect(host.players, hasLength(5), reason: 'hôte + invité + 3 bots');
    expect(guest.players, hasLength(5), reason: 'invité voit la table entière');
    await host.startGame();
    await _awaitTableOpen(host, say);
    await _awaitTableOpen(guest, say);
    say('table ouverte : hôte siège ${host.you}, invité siège ${guest.you}');

    final relay = HostGameRelay(
      session: host,
      names: [for (final player in host.players) player.name],
      botSeats: {
        for (final player in host.players)
          if (player.isBot) player.seat,
      },
    );
    relay.start();

    final mirror = GuestGameController(
      config: GameConfig(opponentCount: host.players.length - 1),
      session: guest,
      names: [for (final player in host.players) player.name],
    );

    var keepalivePauseDone = false;
    var parityChecks = 0;
    var ended = false;
    final deadline = DateTime.now().add(const Duration(minutes: 7));

    while (DateTime.now().isBefore(deadline)) {
      final engine = relay.controller;

      // Pause muette de 28 s au coup d'œil de la manche 2 : ces silences
      // tuaient les sockets avant le ping/pong toutes les 20 s.
      if (!keepalivePauseDone &&
          engine.phase == GamePhase.peek &&
          engine.round == 2) {
        keepalivePauseDone = true;
        say('pause muette de 28 s (battement de cœur en vrai)…');
        await Future<void>.delayed(const Duration(seconds: 28));
      }

      // Parité des tables au coup d'œil : les dés de chaque fauteuil
      // doivent être IDENTIQUES des deux côtés (même graine). Mesurée
      // AVANT de piloter l'un ou l'autre téléphone : un résultat du
      // fichier de manche peut passer en enchère en 400 ms.
      if (engine.phase == GamePhase.peek &&
          mirror.phase == GamePhase.peek &&
          mirror.round == engine.round) {
        parityChecks++;
        for (var local = 0; local < mirror.players.length; local++) {
          final salonSeat = (local + guest.you) % mirror.players.length;
          // Les sièges éliminés ne sont pas comparables : le moteur garde
          // les dés de sa dernière manche, le miroir les vide. Seuls les
          // joueurs vivants doivent être égaux au battement de cœur près.
          if (engine.players[salonSeat].diceCount <= 0) continue;
          expect(
            mirror.players[local].dice,
            engine.players[salonSeat].dice,
            reason: 'manche ${engine.round} : dés du fauteuil '
                '$salonSeat identiques des deux côtés',
          );
        }
      }

      _driveHost(engine);
      _driveGuest(mirror);

      expect(_threadFailures(host.messages), isEmpty,
          reason: 'fil hôte propre (manche ${engine.round})');
      expect(_threadFailures(guest.messages), isEmpty,
          reason: 'fil invité propre (manche ${engine.round})');

      if (engine.result != null || mirror.result != null) {
        ended = true;
        say('partie terminée à la manche ${engine.round}');
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }

    expect(parityChecks, greaterThan(0), reason: 'la parité a été mesurée');
    expect(
      relay.controller.round,
      greaterThan(1),
      reason: 'la partie a réellement avancé',
    );
    if (!ended) {
      say('temps écoulé avant le verdict final : arrêt propre');
    }

    // Le troisième téléphone : un salon FINI doit être rejoint — le refus
    // « La partie a déjà commencée » appelait le gameOver.
    if (ended) {
      final third = NetworkSalonSession();
      try {
        await third.joinSalon(code, 'Simul Bob');
        expect(
          third.players,
          isNotEmpty,
          reason: 'salon rejoint après la fin de partie',
        );
        say('téléphone C : rejoint le salon fini ✓');
      } finally {
        third.dispose();
      }
    }
    mirror.dispose();
    relay.dispose();
    say('répétition terminée : ${log.length} lignes de journal');
  } catch (error) {
    say('échec : $error');
    rethrow;
  } finally {
    guest.dispose();
    host.dispose();
  }
}

/// Le salon devient jouable quand le Worker confirme la mise en marche.
Future<void> _awaitTableOpen(
  NetworkSalonSession session,
  void Function(String) say,
) async {
  for (var tick = 0; tick < 120; tick++) {
    if (session.isStarting && session.players.isNotEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }
  say('table toujours fermée pour ${session.role.name}');
  expect(session.isStarting, isTrue, reason: 'la table a ouvert');
}

/// Stratégie hôte : regarder ses dés, enchérir sobrement, déduo sur les
/// grosses mises, appliquer le sort, refermer chaque manche.
void _driveHost(dynamic engine) {
  switch (engine.phase as GamePhase) {
    case GamePhase.peek:
      engine.beginBidding();
    case GamePhase.reveal:
      if (!engine.outcomeApplied) engine.applyOutcome();
    case GamePhase.bidding:
      if (!engine.isHumanTurn) return;
      if ((engine.currentBid?.quantity ?? 0) >= 4 &&
          engine.canHumanChallenge) {
        engine.callHumanDudo();
        return;
      }
      final bid = engine.defaultHumanBid;
      if (bid != null) {
        engine.submitHumanBid(bid);
      }
    case GamePhase.roundOver:
      engine.seatNextRound(0);
    case GamePhase.gameOver:
      break;
  }
}

/// Stratégie invité : déduo dès que possible (roule les manches), sinon
/// enchérir sobrement ; referme la manche comme tout le monde.
void _driveGuest(dynamic mirror) {
  switch (mirror.phase as GamePhase) {
    case GamePhase.bidding:
      if (!mirror.isHumanTurn) return;
      if (mirror.canHumanChallenge) {
        mirror.callHumanDudo();
        return;
      }
      final bid = mirror.defaultHumanBid;
      if (bid != null) {
        mirror.submitHumanBid(bid);
      }
    case GamePhase.roundOver:
      mirror.nextRound();
    case GamePhase.peek:
    case GamePhase.reveal:
    case GamePhase.gameOver:
      break;
  }
}

/// Les messages système qui décrivent une panne au lieu d'une info.
List<String> _threadFailures(dynamic messages) {
  const patterns = ['injoignable', 'Connexion perdue', 'Salon fermé', 'lâchée'];
  return [
    for (final message in messages.where(
      (m) => patterns.any((pattern) => (m as dynamic).body.contains(pattern)),
    ))
      '${(message as dynamic).body}',
  ];
}

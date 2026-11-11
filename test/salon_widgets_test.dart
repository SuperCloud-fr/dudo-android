import 'package:dudo/l10n/generated/app_localizations.dart';
import 'package:dudo/game/models/game_config.dart';
import 'package:dudo/game/widgets/bot_difficulty_option.dart';
import 'package:dudo/salon/network_salon_session.dart';
import 'package:dudo/salon/salon_models.dart';
import 'package:dudo/salon/screens/salon_screens.dart';
import 'package:dudo/salon/widgets/reaction_bar.dart';
import 'package:dudo/screens/game/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'salon_test_helpers.dart'
    show FakeWebSocketChannel, framesOf, salonFrame;

void main() {
  testWidgets('la barre de réactions supporte un salon vide', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ReactionBar(
            players: const <SalonPlayer>[],
            onSendReaction: (_) {},
            onSendChat: (_) {},
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('RÉAGIR'), findsOneWidget);
  });

  testWidgets('le lobby tient debout avec un salon encore vide', (
    tester,
  ) async {
    final session = LocalSalonSession();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SalonLobbyScreen(session: session),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('l’hôte peut choisir la difficulté des bots dans le lobby', (
    tester,
  ) async {
    final session = LocalSalonSession();
    await session.createSalon('Cap Hôte', 3);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SalonLobbyScreen(session: session),
      ),
    );

    Finder selected(BotDifficulty difficulty) => find.byWidgetPredicate(
      (widget) =>
          widget is BotDifficultyOption &&
          widget.difficulty == difficulty &&
          widget.selected,
    );

    expect(selected(BotDifficulty.flibustier), findsOneWidget);
    final captain = find.text('Capitaine');
    await tester.ensureVisible(captain);
    await tester.tap(captain);
    await tester.pump(const Duration(milliseconds: 250));
    expect(selected(BotDifficulty.capitaine), findsOneWidget);
    expect(selected(BotDifficulty.flibustier), findsNothing);
  });

  testWidgets('après une partie terminée, l\'hôte relance la manche', (
    tester,
  ) async {
    final channels = <FakeWebSocketChannel>[];
    final session = NetworkSalonSession(
      createSalonCode: (_, _) async => 'S99FTH',
      channelFactory: (uri) {
        final channel = FakeWebSocketChannel.confirmed(uri);
        channels.add(channel);
        return channel;
      },
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SalonLobbyScreen(session: session),
      ),
    );

    final creating = session.createSalon('Cap Hôte', 0);
    await tester.pump(); // the handshake dials and whispers 'join'
    final channel = channels.single;
    expect(framesOf(channel.sent, 'join'), hasLength(1));
    final crew = <Map<String, dynamic>>[
      {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
      {'seat': 1, 'name': 'Pilote PNJ', 'bot': true},
    ];
    channel.serverSends(salonFrame(you: 0, players: crew));
    await tester.pump();
    await creating;

    // First start: the frame goes out, the Worker confirms, the table opens.
    await tester.ensureVisible(find.text('LANCER LA MANCHE'));
    await tester.pump();
    await tester.tap(find.text('LANCER LA MANCHE'));
    await tester.pump();
    expect(framesOf(channel.sent, 'start'), hasLength(1));
    channel.serverSends(const <String, dynamic>{'type': 'started'});
    await tester.pump(); // isStarting: the table route is pushed
    await tester.pump(const Duration(milliseconds: 400)); // push transition

    // The Worker reopens the salon once the standings show up: the lobby
    // folds back and the button must not stay "la manche se prépare" —
    // before the fix it stayed greyed forever.
    channel.serverSends(salonFrame(you: 0, players: crew, started: false));
    await tester.pump(); // fold: the table route pops
    await tester.pump(const Duration(milliseconds: 500)); // pop transition
    expect(find.text('LANCER LA MANCHE'), findsOneWidget);

    // Second start must go through: the local `_starting` flag was reset.
    await tester.tap(find.text('LANCER LA MANCHE'));
    await tester.pump();
    expect(framesOf(channel.sent, 'start'), hasLength(2));
    session.dispose();
  });

  testWidgets('les invités quittent une table figée puis la retrouvent', (
    tester,
  ) async {
    final session =
        NetworkSalonSession(
            channelFactory: (uri) => FakeWebSocketChannel.confirmed(uri),
          )
          ..role = SalonRole.guest
          ..code = 'S99FTH'
          ..myName = 'Anne'
          ..isStarting = true
          ..players.addAll(const <SalonPlayer>[
            SalonPlayer(seat: 0, name: 'Cap Hôte', isHost: true, isBot: false),
            SalonPlayer(seat: 1, name: 'Anne', isHost: false, isBot: false),
          ]);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SalonLobbyScreen(session: session),
      ),
    );
    session.notifyListeners(); // the started table opens
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Host's dead socket is represented by the Worker's « à l'eau » marker.
    session
      ..hostGone = true
      ..notifyListeners();
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    // Host reclaims the seat before the notice delay: both timers cancel,
    // and the live table stays open.
    session
      ..hostGone = false
      ..notifyListeners();
    await tester.pump();
    await tester.pump(const Duration(seconds: 15));
    expect(find.byType(GameScreen), findsOneWidget);

    // A later disappearance gets the full notice + grace flow.
    session
      ..hostGone = true
      ..notifyListeners();
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    expect(
      find.text('L’hôte a quitté la manche — la table attend son retour…'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 12));
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      find.text('L\'hôte est à l\'eau — la manche reprend dès son retour.'),
      findsOneWidget,
    );

    // A reclaim inside or after the grace window reopens the mirror.
    session
      ..hostGone = false
      ..notifyListeners();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      find.text('L\'hôte est à l\'eau — la manche reprend dès son retour.'),
      findsNothing,
    );
    session.dispose();
  });
}

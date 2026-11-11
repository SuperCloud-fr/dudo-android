import 'package:dudo/core/theme/app_colors.dart';
import 'package:dudo/core/theme/app_theme.dart';
import 'package:dudo/game/models/bid.dart';
import 'package:dudo/game/models/player.dart';
import 'package:dudo/l10n/generated/app_localizations.dart';
import 'package:dudo/screens/game/widgets/bid_sheet.dart';
import 'package:dudo/screens/game/widgets/game_over_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpAtLargeType(WidgetTester tester, Widget child) async {
  tester.view.devicePixelRatio = 3;
  tester.view.physicalSize = const Size(1170, 2532);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark(),
      builder: (context, appChild) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.3)),
          child: appChild!,
        );
      },
      home: Scaffold(
        backgroundColor: AppColors.ink,
        body: Stack(fit: StackFit.expand, children: [child]),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 900));
}

void main() {
  testWidgets('l\'écran de fin tient à grande police et propose de rejouer', (
    tester,
  ) async {
    final players = [
      Player(
        seat: 0,
        name: 'Toi',
        isHuman: true,
        sigil: 5,
        accent: 3,
        nerve: 0,
        diceCount: 3,
      ),
      Player(
        seat: 1,
        name: 'Barbe-Noire',
        isHuman: false,
        sigil: 0,
        accent: 4,
        nerve: 0.2,
        diceCount: 0,
      ),
      Player(
        seat: 2,
        name: 'Anne Bonny',
        isHuman: false,
        sigil: 1,
        accent: 1,
        nerve: -0.1,
        diceCount: 0,
      ),
    ];
    var rematched = false;

    await pumpAtLargeType(
      tester,
      GameOverOverlay(
        result: const GameResult(
          humanWon: true,
          winnerSeat: 0,
          rounds: 7,
          humanDiceLeft: 3,
          standings: [0, 1, 2],
        ),
        players: players,
        difficultyLabel: 'Capitaine',
        onRematch: () => rematched = true,
        onMenu: () {},
      ),
    );

    expect(find.text('TU RÈGNES'), findsOneWidget);
    expect(find.text('REJOUER'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.text('REJOUER'));
    await tester.pump();
    await tester.tap(find.text('REJOUER'));
    expect(rematched, isTrue);
  });

  testWidgets('la feuille de pari tient à grande police', (tester) async {
    await pumpAtLargeType(
      tester,
      Align(
        alignment: Alignment.bottomCenter,
        child: BidSheet(
          palifico: false,
          previous: const Bid(quantity: 4, face: 5, playerSeat: 1),
          previousBidderName: 'Barbe-Noire',
          totalDice: 20,
          initial: const Bid(quantity: 5, face: 5, playerSeat: 0),
          calzaEnabled: true,
        ),
      ),
    );

    expect(find.text('ANNONCER'), findsOneWidget);
    expect(find.text('ANNULER'), findsOneWidget);
    expect(find.text('FACE'), findsOneWidget);
    expect(tester.takeException(), isNull);

    expect(tester.takeException(), isNull);
  });

  testWidgets('l\'ouverture palifico sur les pacos est annonçable', (
    tester,
  ) async {
    Bid? announced;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        locale: const Locale('fr'),
        supportedLocales: const [Locale('fr')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () async {
                  announced = await showModalBottomSheet<Bid>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => BidSheet(
                      palifico: true,
                      previous: null,
                      previousBidderName: '',
                      totalDice: 10,
                      initial: null,
                      calzaEnabled: false,
                    ),
                  );
                },
                child: const Text('ouvrir'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('ouvrir'));
    await tester.pumpAndSettle();

    // Pick the pacos face (allowed in palifico, illegal as a normal opener)
    // and announce with the default minimum quantity.
    await tester.ensureVisible(find.text('PACO'));
    await tester.tap(find.text('PACO'));
    await tester.pumpAndSettle();

    // The sheet must not read the bid as illegal (was: red "surenchère
    // valable" message and a dead announce button).
    expect(find.textContaining('surenchère'), findsNothing);
    await tester.ensureVisible(find.text('ANNONCER'));
    await tester.tap(find.text('ANNONCER'));
    await tester.pumpAndSettle();

    expect(announced, isNotNull);
    expect(announced!.quantity, 2);
    expect(announced!.face, 1);
  });
}

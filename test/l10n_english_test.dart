// La zone bilingue : ce que le téléphone EN doit lire à l'écran.
import 'package:dudo/core/widgets/dice_face.dart';
import 'package:dudo/l10n/generated/app_localizations.dart';
import 'package:dudo/salon/salon_models.dart';
import 'package:dudo/salon/screens/salon_screens.dart';
import 'package:dudo/screens/rules/rules_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _english(Widget home) => MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('le salon multijoueur parle anglais', (tester) async {
    final session = LocalSalonSession();
    await tester.pumpWidget(_english(SalonHomeScreen(session: session)));
    expect(find.text('MULTIPLAYER'), findsOneWidget);
    expect(find.text('CREATE A CODE'), findsOneWidget);
    expect(find.text('JOIN WITH A CODE'), findsOneWidget);
  });

  testWidgets('les règles affichent les huit sections en anglais', (
    tester,
  ) async {
    await tester.pumpWidget(_english(const RulesScreen()));
    await tester.pump();
    expect(find.text('The game of lies'), findsOneWidget);
    expect(find.text('Pacos are jokers'), findsOneWidget);
    expect(find.text('One round only'), findsOneWidget);
    expect(find.text('GOT IT'), findsOneWidget);
  });

  testWidgets('un dé caché se lit « Hidden die » auprès du lecteur', (
    tester,
  ) async {
    await tester.pumpWidget(
      _english(
        Scaffold(
          body: Center(child: DiceFace(value: 3, hidden: true)),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Hidden die'), findsOneWidget);
  });

  testWidgets('un dé de valeur porte sa face dans le lecteur', (tester) async {
    await tester.pumpWidget(
      _english(
        Scaffold(
          body: Center(child: DiceFace(value: 5)),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Die of value 5'), findsOneWidget);
  });
}

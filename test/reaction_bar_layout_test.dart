import 'package:dudo/l10n/generated/app_localizations.dart';
import 'package:dudo/salon/salon_models.dart';
import 'package:dudo/salon/screens/salon_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('les emojis du salon tiennent sur une seule ligne', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.6;
    addTearDown(tester.view.reset);

    final session = LocalSalonSession();
    await session.createSalon('Cap Hôte', 2);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SalonLobbyScreen(session: session),
      ),
    );
    await tester.pump();

    final laugh = tester.getCenter(find.text('😂'));
    final mind = tester.getCenter(find.text('🤯'));
    final devil = tester.getCenter(find.text('😈'));
    final parrot = tester.getCenter(find.text('🦜'));
    // Same dy → same row (the container used to stretch each emoji tile
    // to the full Wrap width, stacking them like a column).
    expect(mind.dy, laugh.dy);
    expect(devil.dy, laugh.dy);
    expect(parrot.dy, laugh.dy);
    expect(mind.dx, greaterThan(laugh.dx));
  });
}

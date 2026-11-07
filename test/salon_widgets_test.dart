import 'package:dudo/salon/salon_models.dart';
import 'package:dudo/salon/screens/salon_screens.dart';
import 'package:dudo/salon/widgets/reaction_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('la barre de réactions supporte un salon vide', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
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
      MaterialApp(home: SalonLobbyScreen(session: session)),
    );
    expect(tester.takeException(), isNull);
  });
}

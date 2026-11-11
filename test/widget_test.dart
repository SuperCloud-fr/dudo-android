import 'package:dudo/app.dart';
import 'package:dudo/core/widgets/leather_cup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpApp(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.devicePixelRatio = 3;
  tester.view.physicalSize = Size(size.width * 3, size.height * 3);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails d) {
    debugPrint('OVF-DATA:');
    if (d.informationCollector != null) {
      for (final info in d.informationCollector!.call()) {
        debugPrint('OVF-INFO: $info');
      }
    }
    previousOnError?.call(d);
  };
  tester.platformDispatcher.textScaleFactorTestValue = 1.15;
  await tester.pumpWidget(const DudoApp(locale: Locale('fr')));
  await tester.pump(const Duration(milliseconds: 350));
}

Future<void> settleRoute(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 700));
}

void main() {
  testWidgets('la taverne mène à une partie complète', (tester) async {
    await pumpApp(tester);

    expect(find.text('DUDO'), findsOneWidget);
    expect(find.text('JOUER EN SOLO'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('JOUER EN SOLO'));
    await settleRoute(tester);
    expect(find.text('Qui monte à bord ?'), findsOneWidget);
    expect(find.text('COMMENCER LA PARTIE'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.text('COMMENCER LA PARTIE'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('COMMENCER LA PARTIE'));
    await settleRoute(tester);
    expect(find.text('Tes dés'), findsOneWidget);
    expect(find.byType(LeatherCup), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.byType(LeatherCup));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.byType(LeatherCup));
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.ensureVisible(find.text('LE PREMIER COUP DE CANON'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('LE PREMIER COUP DE CANON'), findsOneWidget);

    await tester.tap(find.text('LE PREMIER COUP DE CANON'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(LeatherCup), findsNothing);
    expect(find.text('OUVRIR LES HOSTILITÉS'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('OUVRIR LES HOSTILITÉS'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('ANNONCER'), findsOneWidget);
    expect(find.text('À toi de jouer.'), findsOneWidget);

    await tester.ensureVisible(find.text('ANNONCER'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.tap(find.text('ANNONCER'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Barbe-Noire prépare son coup…'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Dispose the route before the scheduled bot timer fires.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('la taverne tient sur un petit téléphone', (tester) async {
    await pumpApp(tester, size: const Size(360, 640));
    final exc = tester.takeException();
    if (exc != null) {
      debugPrint('SMALL-EXC: $exc');
      FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(
          exception: exc,
          context: ErrorDescription('petit téléphone'),
          library: 'test',
        ),
      );
    }
    expect(exc, isNull);

    await tester.tap(find.text('JOUER EN SOLO'));
    await settleRoute(tester);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.text('COMMENCER LA PARTIE'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('COMMENCER LA PARTIE'));
    await settleRoute(tester);
    expect(find.text('Tes dés'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('les règles s\'ouvrent depuis la taverne', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Comment jouer ?'));
    await settleRoute(tester);

    expect(find.text('Les règles du Perudo'), findsOneWidget);
    expect(find.text('RÈGLES DU JEU'), findsOneWidget);
    expect(find.text('COMPRIS'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_palette.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'salon/salon_system_strings.dart';
import 'screens/home/home_screen.dart';

class DudoApp extends StatelessWidget {
  const DudoApp({super.key, this.locale});

  /// Tests pin the languages; production follows the device.
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    // The look is hot-swappable (settings page): the whole MaterialApp
    // rebuilds whenever the palette changes. Language follows the device;
    // French is the source of truth, English tags along.
    return PaletteView(
      builder: (context, palette) {
        return MaterialApp(
          key: ValueKey('dudo-${palette.id}'),
          title: 'Dudo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.dark,
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('fr')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const HomeScreen(),
          builder: (context, child) {
            // The salon session (no BuildContext) speaks the phone's
            // language through this once-per-frame snapshot.
            SalonSystem.bind(AppLocalizations.of(context));
            return child ??
                const Text('Dudo', textDirection: TextDirection.ltr);
          },
        );
      },
    );
  }
}

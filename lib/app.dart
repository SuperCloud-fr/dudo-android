import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_palette.dart';
import 'core/theme/app_theme.dart';
import 'screens/home/home_screen.dart';

class DudoApp extends StatelessWidget {
  const DudoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The look is hot-swappable (settings page): the whole MaterialApp
    // rebuilds whenever the palette changes.
    return PaletteView(
      builder: (context, palette) {
        return MaterialApp(
          key: ValueKey('dudo-${palette.id}'),
          title: 'Dudo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.dark,
          locale: const Locale('fr'),
          supportedLocales: const [Locale('fr'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const HomeScreen(),
        );
      },
    );
  }
}

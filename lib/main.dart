import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_palette.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PaletteStore.restore();
  void applySystemChrome() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.ink,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  }

  applySystemChrome();
  // A palette swap must re-ink the system chrome as well.
  PaletteStore.notifier.addListener(applySystemChrome);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const DudoApp());
}

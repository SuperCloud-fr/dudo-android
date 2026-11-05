import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.brass,
      onPrimary: AppColors.ink,
      primaryContainer: AppColors.brassDim,
      onPrimaryContainer: AppColors.ink,
      secondary: AppColors.blood,
      onSecondary: AppColors.ivory,
      secondaryContainer: AppColors.leatherLight,
      onSecondaryContainer: AppColors.parchment,
      tertiary: AppColors.feltLight,
      onTertiary: AppColors.parchment,
      tertiaryContainer: AppColors.feltDeep,
      onTertiaryContainer: AppColors.parchment,
      error: AppColors.bloodBright,
      onError: AppColors.ivory,
      surface: AppColors.wood,
      onSurface: AppColors.parchment,
      surfaceContainerLowest: AppColors.ink,
      surfaceContainerLow: AppColors.woodDeep,
      surfaceContainer: AppColors.wood,
      surfaceContainerHigh: AppColors.leatherDeep,
      surfaceContainerHighest: AppColors.leather,
      onSurfaceVariant: AppColors.parchmentDim,
      outline: AppColors.brassDim,
      outlineVariant: AppColors.grain,
      shadow: AppColors.ink,
      scrim: AppColors.ink,
      inverseSurface: AppColors.parchment,
      onInverseSurface: AppColors.ink,
      inversePrimary: AppColors.leatherLight,
    );

    final textTheme = AppTypography.textTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.woodDeep,
      canvasColor: AppColors.wood,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.parchment,
        titleTextStyle: textTheme.labelLarge?.copyWith(
          color: AppColors.parchment,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: AppColors.parchment, size: 22),
      ),
      iconTheme: const IconThemeData(color: AppColors.parchmentDim, size: 22),
      dividerTheme: const DividerThemeData(
        color: AppColors.grain,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.leatherDeep,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpace.radiusLg),
          side: const BorderSide(color: AppColors.brassDim, width: 1),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.parchmentDim,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        modalBackgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.leatherLight,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.parchment,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpace.radiusMd),
          side: const BorderSide(color: AppColors.brassDim),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.brassBright;
          }
          return AppColors.parchmentMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.brassDim;
          }
          return AppColors.leather;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.brass;
          }
          return AppColors.grain;
        }),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brassBright,
          minimumSize: const Size(AppSpace.minTouch, AppSpace.minTouch),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.parchment,
          minimumSize: const Size(AppSpace.minTouch, AppSpace.minTouch),
          side: const BorderSide(color: AppColors.brassDim),
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brass,
          foregroundColor: AppColors.ink,
          minimumSize: const Size(AppSpace.minTouch, AppSpace.minTouch),
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

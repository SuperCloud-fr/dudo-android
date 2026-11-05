import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Type roles. Cinema-style inscription for the sign, a warm humanist sans
/// for everything that has to be read while a pirate is lying to you.
abstract final class AppTypography {
  static const display = 'Cinzel';
  static const body = 'AlegreyaSans';

  static const List<FontVariation> _inscription400 = [
    FontVariation('wght', 400),
  ];
  static const List<FontVariation> _inscription700 = [
    FontVariation('wght', 700),
  ];

  static TextStyle inscription({
    double size = 32,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.parchment,
    double letterSpacing = 2,
    double height = 1.05,
  }) {
    return TextStyle(
      fontFamily: display,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      fontVariations: weight.value >= FontWeight.w600.value
          ? _inscription700
          : _inscription400,
    );
  }

  static TextTheme textTheme() {
    return TextTheme(
      displayLarge: inscription(size: 54, letterSpacing: 8),
      displayMedium: inscription(size: 38, letterSpacing: 5),
      displaySmall: inscription(size: 28, letterSpacing: 3),
      headlineLarge: inscription(size: 25, letterSpacing: 2),
      headlineMedium: inscription(size: 21, letterSpacing: 1.6),
      headlineSmall: inscription(size: 18, letterSpacing: 1.2),
      titleLarge: const TextStyle(
        fontFamily: body,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.parchment,
        height: 1.2,
      ),
      titleMedium: const TextStyle(
        fontFamily: body,
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.parchment,
        height: 1.25,
      ),
      titleSmall: const TextStyle(
        fontFamily: body,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.parchment,
        letterSpacing: 0.3,
      ),
      bodyLarge: const TextStyle(
        fontFamily: body,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: AppColors.parchment,
        height: 1.45,
      ),
      bodyMedium: const TextStyle(
        fontFamily: body,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.parchmentDim,
        height: 1.45,
      ),
      bodySmall: const TextStyle(
        fontFamily: body,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.parchmentMuted,
        height: 1.4,
      ),
      labelLarge: const TextStyle(
        fontFamily: body,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.parchment,
        letterSpacing: 1.5,
      ),
      labelMedium: const TextStyle(
        fontFamily: body,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.parchmentDim,
        letterSpacing: 1.2,
      ),
      labelSmall: const TextStyle(
        fontFamily: body,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.parchmentMuted,
        letterSpacing: 0.8,
      ),
    );
  }
}

/// Layout rhythm. Four pixels is the smallest step we allow ourselves.
abstract final class AppSpace {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;

  static const radiusSm = 10.0;
  static const radiusMd = 16.0;
  static const radiusLg = 24.0;
  static const radiusPill = 999.0;

  static const maxContentWidth = 560.0;
  static const minTouch = 48.0;
}

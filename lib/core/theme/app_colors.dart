import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Every colour in the app comes from this file. The named constants
/// forward to the palette the [PaletteStore] currently holds, so a look
/// swap repaints the whole tavern while call sites keep their API
/// (issues #5/#6). Never use these names inside `const` expressions
/// freely: the values are live, not compile-time.
abstract final class AppColors {
  static AppPalette get palette => PaletteStore.current;

  // Ground & wood
  static Color get ink => palette.ink;
  static Color get wood => palette.wood;
  static Color get woodDeep => palette.woodDeep;
  static Color get woodLight => palette.woodLight;
  static Color get grain => palette.grain;

  // Leather
  static Color get leather => palette.leather;
  static Color get leatherLight => palette.leatherLight;
  static Color get leatherDeep => palette.leatherDeep;

  // Brass & candle
  static Color get brass => palette.brass;
  static Color get brassBright => palette.brassBright;
  static Color get brassDim => palette.brassDim;
  static Color get candle => palette.candle;

  // Felt
  static Color get felt => palette.felt;
  static Color get feltLight => palette.feltLight;
  static Color get feltDeep => palette.feltDeep;

  // Parchment
  static Color get parchment => palette.parchment;
  static Color get parchmentDim => palette.parchmentDim;
  static Color get parchmentMuted => palette.parchmentMuted;

  // Blood & wax
  static Color get blood => palette.blood;
  static Color get bloodBright => palette.bloodBright;
  static Color get bloodDeep => palette.bloodDeep;

  // Dice
  static Color get ivory => palette.ivory;
  static Color get ivoryShade => palette.ivoryShade;
  static Color get dieEdge => palette.dieEdge;
  static Color get pip => palette.pip;
  static Color get ace => palette.ace;

  // Crew accents (rings & sigils)
  static List<Color> get accents => palette.accents;
}

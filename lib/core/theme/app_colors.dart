import 'package:flutter/material.dart';

/// The tavern at night. Every colour in the app comes from this file.
abstract final class AppColors {
  // Ground & wood
  static const ink = Color(0xFF0B0806);
  static const wood = Color(0xFF1A120C);
  static const woodDeep = Color(0xFF120C08);
  static const woodLight = Color(0xFF2A1B11);
  static const grain = Color(0xFF3B2718);

  // Leather
  static const leather = Color(0xFF38241A);
  static const leatherLight = Color(0xFF4E3324);
  static const leatherDeep = Color(0xFF241610);

  // Brass & candle
  static const brass = Color(0xFFD2A254);
  static const brassBright = Color(0xFFF2CE86);
  static const brassDim = Color(0xFF8A6934);
  static const candle = Color(0xFFFFD98A);

  // Felt
  static const felt = Color(0xFF143A2D);
  static const feltLight = Color(0xFF1D4E3B);
  static const feltDeep = Color(0xFF0D2A20);

  // Parchment
  static const parchment = Color(0xFFEADABA);
  static const parchmentDim = Color(0xFFC6B08A);
  static const parchmentMuted = Color(0xFF9A8667);

  // Blood & wax
  static const blood = Color(0xFF9C3A31);
  static const bloodBright = Color(0xFFC9584B);
  static const bloodDeep = Color(0xFF5E211D);

  // Dice
  static const ivory = Color(0xFFF4E8CF);
  static const ivoryShade = Color(0xFFD8C4A1);
  static const dieEdge = Color(0xFF7A6345);
  static const pip = Color(0xFF241A12);
  static const ace = Color(0xFFA3342C);

  // Crew accents (rings & sigils)
  static const accents = <Color>[
    Color(0xFFC9584B), // rust
    Color(0xFF5E9C8A), // sea
    Color(0xFFA577B8), // plum
    Color(0xFFC99A4B), // ochre
    Color(0xFF6E8FB8), // slate
  ];
}

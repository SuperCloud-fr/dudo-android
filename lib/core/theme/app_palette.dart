import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// One complete look for the app. Every colour a widget or painter may
/// reach comes from here; [AppColors] forwards its named constants to the
/// palette the [PaletteStore] currently holds, so switching a look
/// repaints the whole tavern (issues #5/#6).
class AppPalette {
  const AppPalette({
    required this.id,
    required this.name,
    required this.ink,
    required this.wood,
    required this.woodDeep,
    required this.woodLight,
    required this.grain,
    required this.leather,
    required this.leatherLight,
    required this.leatherDeep,
    required this.brass,
    required this.brassBright,
    required this.brassDim,
    required this.candle,
    required this.felt,
    required this.feltLight,
    required this.feltDeep,
    required this.parchment,
    required this.parchmentDim,
    required this.parchmentMuted,
    required this.blood,
    required this.bloodBright,
    required this.bloodDeep,
    required this.ivory,
    required this.ivoryShade,
    required this.dieEdge,
    required this.pip,
    required this.ace,
    required this.accents,
  });

  /// Display name of the look (settings screen).
  final String name;

  /// Stable identifier persisted in preferences ('tavern', 'pavillon').
  final String id;

  // Ground & wood
  final Color ink;
  final Color wood;
  final Color woodDeep;
  final Color woodLight;
  final Color grain;

  // Leather
  final Color leather;
  final Color leatherLight;
  final Color leatherDeep;

  // Brass & candle
  final Color brass;
  final Color brassBright;
  final Color brassDim;
  final Color candle;

  // Felt
  final Color felt;
  final Color feltLight;
  final Color feltDeep;

  // Parchment
  final Color parchment;
  final Color parchmentDim;
  final Color parchmentMuted;

  // Blood & wax
  final Color blood;
  final Color bloodBright;
  final Color bloodDeep;

  // Dice
  final Color ivory;
  final Color ivoryShade;
  final Color dieEdge;
  final Color pip;
  final Color ace;

  // Crew accents (rings & sigils)
  final List<Color> accents;

  /// The shipped look: the tavern as it has always been on screen.
  static const AppPalette tavern = AppPalette(
    id: 'tavern',
    name: 'Taverne au clair de lune',
    ink: Color(0xFF0B0806),
    wood: Color(0xFF1A120C),
    woodDeep: Color(0xFF120C08),
    woodLight: Color(0xFF2A1B11),
    grain: Color(0xFF3B2718),
    leather: Color(0xFF38241A),
    leatherLight: Color(0xFF4E3324),
    leatherDeep: Color(0xFF241610),
    brass: Color(0xFFD2A254),
    brassBright: Color(0xFFF2CE86),
    brassDim: Color(0xFF8A6934),
    candle: Color(0xFFFFD98A),
    felt: Color(0xFF143A2D),
    feltLight: Color(0xFF1D4E3B),
    feltDeep: Color(0xFF0D2A20),
    parchment: Color(0xFFEADABA),
    parchmentDim: Color(0xFFC6B08A),
    parchmentMuted: Color(0xFF9A8667),
    blood: Color(0xFF9C3A31),
    bloodBright: Color(0xFFC9584B),
    bloodDeep: Color(0xFF5E211D),
    ivory: Color(0xFFF4E8CF),
    ivoryShade: Color(0xFFD8C4A1),
    dieEdge: Color(0xFF7A6345),
    pip: Color(0xFF241A12),
    ace: Color(0xFFA3342C),
    accents: [
      Color(0xFFC9584B), // rust
      Color(0xFF5E9C8A), // sea
      Color(0xFFA577B8), // plum
      Color(0xFFC99A4B), // ochre
      Color(0xFF6E8FB8), // slate
    ],
  );

  /// The cold navy-and-gold look straight from the brand brief: Pavillon
  /// Debout `#1F4C5C` carries the grounds, Or d'Étambot `#E8A33B` the
  /// accents, and the mutineer's red keeps the risk. Same ivory text so
  /// the reading stays exactly as tested.
  static const AppPalette pavillon = AppPalette(
    id: 'pavillon',
    name: 'Pavillon Debout',
    ink: Color(0xFF0A141B),
    wood: Color(0xFF173341),
    woodDeep: Color(0xFF0F2430),
    woodLight: Color(0xFF1E4254),
    grain: Color(0xFF2A566B),
    leather: Color(0xFF20465A),
    leatherLight: Color(0xFF2C5A72),
    leatherDeep: Color(0xFF143135),
    brass: Color(0xFFE8A33B),
    brassBright: Color(0xFFF4C470),
    brassDim: Color(0xFF9A7231),
    candle: Color(0xFFFFD98A),
    felt: Color(0xFF1F4C5C),
    feltLight: Color(0xFF2A6679),
    feltDeep: Color(0xFF123B46),
    parchment: Color(0xFFEDE6D4),
    parchmentDim: Color(0xFFBFB9A5),
    parchmentMuted: Color(0xFF938D7A),
    blood: Color(0xFFB23A2E),
    bloodBright: Color(0xFFC9524A),
    bloodDeep: Color(0xFF6E231B),
    ivory: Color(0xFFF2EBD8),
    ivoryShade: Color(0xFFD6CBAD),
    dieEdge: Color(0xFF6E624A),
    pip: Color(0xFF1C1813),
    ace: Color(0xFFB23A2E),
    accents: [
      Color(0xFFC9524A), // mutin
      Color(0xFF4E9C9F), // parfait
      Color(0xFFA57FB8), // plum
      Color(0xFFC9A24B), // ochre
      Color(0xFF6E8FB8), // slate
    ],
  );

  /// Switchable looks, in settings-page order.
  static const List<AppPalette> all = [tavern, pavillon];
}

/// Holds the active look. AppColors reads here; [PaletteView] rebuilds the
/// app when an announce lands. The store keeps pure state (no I/O), so
/// tests can swap looks freely. Persistence rides on shared_preferences
/// through [restore] and [select].
final class PaletteStore {
  PaletteStore._();

  static const _preferenceKey = 'palette';

  static final ValueNotifier<AppPalette> notifier = ValueNotifier<AppPalette>(
    AppPalette.tavern,
  );

  static AppPalette get current => notifier.value;

  /// Loads the saved look once at startup; silently keeps the tavern when
  /// nothing was stored or the id no longer exists.
  static Future<void> restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(_preferenceKey);
      if (id == null) return;
      final match = AppPalette.all.where((look) => look.id == id).firstOrNull;
      if (match != null) notifier.value = match;
    } catch (_) {
      // Missing platform plugin (tests): the tavern stays uplit.
    }
  }

  /// Swaps the active look, notifies every listener and remembers the
  /// choice. Returns true when the state changed.
  static bool select(AppPalette palette) {
    if (identical(palette, current)) return false;
    notifier.value = palette;
    unawaited(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_preferenceKey, palette.id);
      } catch (_) {
        // Same deal: an unavailable store simply forgets the choice.
      }
    }());
    return true;
  }
}

/// Watch the active look; rebuilt whenever it changes.
class PaletteView extends StatelessWidget {
  const PaletteView({super.key, required this.builder});

  final Widget Function(BuildContext context, AppPalette palette) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppPalette>(
      valueListenable: PaletteStore.notifier,
      builder: (context, palette, _) => builder(context, palette),
    );
  }
}

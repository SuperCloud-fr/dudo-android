// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Dudo';

  @override
  String get homeWordmark => 'DUDO';

  @override
  String get homeTavernSection => 'Taverne du dernier dé';

  @override
  String get homeSoloBadge => 'SOLO · HORS LIGNE';

  @override
  String get homeTagline => 'Cinq dés. Un gobelet.\nTout le monde ment.';

  @override
  String get homeSubtitle =>
      'Le Perudo des pirates, contre un équipage qui sait bluffer.';

  @override
  String get ctaPlay => 'Jouer';

  @override
  String get ctaSalons => 'Salons multijoueurs';

  @override
  String get ctaHowTo => 'Comment jouer ?';

  @override
  String get ctaSettings => 'Réglages';

  @override
  String get homeVersionBadge => 'v0.1 · 2 à 6 joueurs';

  @override
  String get settingsTitle => 'RÉGLAGES';

  @override
  String get settingsAmbienceTitle => 'L\'ambiance';

  @override
  String get settingsAmbienceHint =>
      'La table ne change pas. La lumière, si — choisis l\'endroit où tu couches tes dés.';

  @override
  String get lookChosen => 'Choisi';

  @override
  String get lookPick => 'Toucher pour choisir';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dudo';

  @override
  String get homeWordmark => 'DUDO';

  @override
  String get homeTavernSection => 'Tavern of the Last Die';

  @override
  String get homeSoloBadge => 'SOLO · OFFLINE';

  @override
  String get homeTagline => 'Five dice. One cup.\nEveryone lies.';

  @override
  String get homeSubtitle =>
      'Pirates\' Perudo, against a crew that knows how to bluff.';

  @override
  String get ctaPlay => 'Play';

  @override
  String get ctaSalons => 'Multiplayer salons';

  @override
  String get ctaHowTo => 'How to play?';

  @override
  String get ctaSettings => 'Settings';

  @override
  String get homeVersionBadge => 'v0.1 · 2 to 6 players';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get settingsAmbienceTitle => 'The atmosphere';

  @override
  String get settingsAmbienceHint =>
      'The table never changes. The light does — pick where you lay your dice.';

  @override
  String get lookChosen => 'Chosen';

  @override
  String get lookPick => 'Tap to choose';
}

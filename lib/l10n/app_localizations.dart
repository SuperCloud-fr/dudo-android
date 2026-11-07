import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dudo'**
  String get appTitle;

  /// No description provided for @homeWordmark.
  ///
  /// In fr, this message translates to:
  /// **'DUDO'**
  String get homeWordmark;

  /// No description provided for @homeTavernSection.
  ///
  /// In fr, this message translates to:
  /// **'Taverne du dernier dé'**
  String get homeTavernSection;

  /// No description provided for @homeSoloBadge.
  ///
  /// In fr, this message translates to:
  /// **'SOLO · HORS LIGNE'**
  String get homeSoloBadge;

  /// No description provided for @homeTagline.
  ///
  /// In fr, this message translates to:
  /// **'Cinq dés. Un gobelet.\nTout le monde ment.'**
  String get homeTagline;

  /// No description provided for @homeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Le Perudo des pirates, contre un équipage qui sait bluffer.'**
  String get homeSubtitle;

  /// No description provided for @ctaPlay.
  ///
  /// In fr, this message translates to:
  /// **'Jouer'**
  String get ctaPlay;

  /// No description provided for @ctaSalons.
  ///
  /// In fr, this message translates to:
  /// **'Salons multijoueurs'**
  String get ctaSalons;

  /// No description provided for @ctaHowTo.
  ///
  /// In fr, this message translates to:
  /// **'Comment jouer ?'**
  String get ctaHowTo;

  /// No description provided for @ctaSettings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get ctaSettings;

  /// No description provided for @homeVersionBadge.
  ///
  /// In fr, this message translates to:
  /// **'v0.1 · 2 à 6 joueurs'**
  String get homeVersionBadge;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'RÉGLAGES'**
  String get settingsTitle;

  /// No description provided for @settingsAmbienceTitle.
  ///
  /// In fr, this message translates to:
  /// **'L\'ambiance'**
  String get settingsAmbienceTitle;

  /// No description provided for @settingsAmbienceHint.
  ///
  /// In fr, this message translates to:
  /// **'La table ne change pas. La lumière, si — choisis l\'endroit où tu couches tes dés.'**
  String get settingsAmbienceHint;

  /// No description provided for @lookChosen.
  ///
  /// In fr, this message translates to:
  /// **'Choisi'**
  String get lookChosen;

  /// No description provided for @lookPick.
  ///
  /// In fr, this message translates to:
  /// **'Toucher pour choisir'**
  String get lookPick;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

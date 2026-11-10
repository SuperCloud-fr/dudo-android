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
/// import 'generated/app_localizations.dart';
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

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get settingsPrivacyPolicy;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// No description provided for @setupBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get setupBack;

  /// No description provided for @setupTitle.
  ///
  /// In fr, this message translates to:
  /// **'NOUVELLE PARTIE'**
  String get setupTitle;

  /// No description provided for @setupCrewTitle.
  ///
  /// In fr, this message translates to:
  /// **'L\'équipage'**
  String get setupCrewTitle;

  /// No description provided for @setupCrewHint.
  ///
  /// In fr, this message translates to:
  /// **'Choisis combien de pirates vont te mentir ce soir.'**
  String get setupCrewHint;

  /// No description provided for @setupBotTemperTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le tempérament des bots'**
  String get setupBotTemperTitle;

  /// No description provided for @setupStart.
  ///
  /// In fr, this message translates to:
  /// **'Larguer les amarres'**
  String get setupStart;

  /// No description provided for @setupRulesLink.
  ///
  /// In fr, this message translates to:
  /// **'Relire les règles'**
  String get setupRulesLink;

  /// No description provided for @setupTableLabel.
  ///
  /// In fr, this message translates to:
  /// **'PIRATES À TA TABLE'**
  String get setupTableLabel;

  /// No description provided for @setupPlayersCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} joueurs'**
  String setupPlayersCount(int count);

  /// No description provided for @setupRemovePirate.
  ///
  /// In fr, this message translates to:
  /// **'Retirer un pirate'**
  String get setupRemovePirate;

  /// No description provided for @setupAddPirate.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un pirate'**
  String get setupAddPirate;

  /// No description provided for @setupSeatAtTable.
  ///
  /// In fr, this message translates to:
  /// **'à table'**
  String get setupSeatAtTable;

  /// No description provided for @setupSeatAbsent.
  ///
  /// In fr, this message translates to:
  /// **'absent'**
  String get setupSeatAbsent;

  /// No description provided for @setupCrewSummary.
  ///
  /// In fr, this message translates to:
  /// **'Toi + {count, plural, =1{1 pirate} other{{count} pirates}} : {names}'**
  String setupCrewSummary(int count, String names);

  /// No description provided for @setupCalzaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Calza autorisée'**
  String get setupCalzaTitle;

  /// No description provided for @setupCalzaHint.
  ///
  /// In fr, this message translates to:
  /// **'Annoncer le compte exact rapporte un dé. Optionnel, mais féroce.'**
  String get setupCalzaHint;

  /// No description provided for @gameQuitTable.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la partie'**
  String get gameQuitTable;

  /// No description provided for @gameRound.
  ///
  /// In fr, this message translates to:
  /// **'MANCHE {round}'**
  String gameRound(int round);

  /// No description provided for @gameDiceInPlay.
  ///
  /// In fr, this message translates to:
  /// **'{count} dés en jeu'**
  String gameDiceInPlay(int count);

  /// No description provided for @gameOpenJournal.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le journal de la table'**
  String get gameOpenJournal;

  /// No description provided for @gameOpenPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Ouvre les hostilités.'**
  String get gameOpenPrompt;

  /// No description provided for @gameYourTurnPrompt.
  ///
  /// In fr, this message translates to:
  /// **'À toi de parler.'**
  String get gameYourTurnPrompt;

  /// No description provided for @gameCalzaAsk.
  ///
  /// In fr, this message translates to:
  /// **'CALZA ?'**
  String get gameCalzaAsk;

  /// No description provided for @gameDudoCall.
  ///
  /// In fr, this message translates to:
  /// **'Dudo !'**
  String get gameDudoCall;

  /// No description provided for @gameRaise.
  ///
  /// In fr, this message translates to:
  /// **'Surenchérir'**
  String get gameRaise;

  /// No description provided for @gameOpenBid.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir'**
  String get gameOpenBid;

  /// No description provided for @gameBotThinking.
  ///
  /// In fr, this message translates to:
  /// **'{name} réfléchit'**
  String gameBotThinking(String name);

  /// No description provided for @gameTableListens.
  ///
  /// In fr, this message translates to:
  /// **'la table écoute'**
  String get gameTableListens;

  /// No description provided for @gameLiftCupPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Soulève ton gobelet.'**
  String get gameLiftCupPrompt;

  /// No description provided for @gameTableHoldsBreath.
  ///
  /// In fr, this message translates to:
  /// **'La table retient son souffle.'**
  String get gameTableHoldsBreath;

  /// No description provided for @gameBidInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Ce pari n\'est plus valable.'**
  String get gameBidInvalid;

  /// No description provided for @gameDudoConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dudo ?'**
  String get gameDudoConfirmTitle;

  /// No description provided for @gameAccusedYou.
  ///
  /// In fr, this message translates to:
  /// **'tu as menti'**
  String get gameAccusedYou;

  /// No description provided for @gameAccusedPlayer.
  ///
  /// In fr, this message translates to:
  /// **'{name} ment'**
  String gameAccusedPlayer(String name);

  /// No description provided for @gameDudoConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu penses que {accused} sur « {bid} ». Si le pari tient, tu perds un dé.'**
  String gameDudoConfirmBody(String accused, String bid);

  /// No description provided for @gameDudoConfirm.
  ///
  /// In fr, this message translates to:
  /// **'DUDO !'**
  String get gameDudoConfirm;

  /// No description provided for @gameCalzaConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Calza ?'**
  String get gameCalzaConfirmTitle;

  /// No description provided for @gameFacePaco.
  ///
  /// In fr, this message translates to:
  /// **'paco'**
  String get gameFacePaco;

  /// No description provided for @gameWordDiceOfFace.
  ///
  /// In fr, this message translates to:
  /// **'dés de {face}'**
  String gameWordDiceOfFace(int face);

  /// No description provided for @gameCalzaConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu penses qu\'il y a exactement {count} {faceWord} sur la table. Compte exact : tu gagnes un dé. Sinon, tu en perds un.'**
  String gameCalzaConfirmBody(int count, String faceWord);

  /// No description provided for @gameCalzaConfirm.
  ///
  /// In fr, this message translates to:
  /// **'CALZA'**
  String get gameCalzaConfirm;

  /// No description provided for @gameQuitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la table ?'**
  String get gameQuitTitle;

  /// No description provided for @gameQuitBody.
  ///
  /// In fr, this message translates to:
  /// **'La partie en cours sera perdue. Les pirates ne se souviendront pas de toi.'**
  String get gameQuitBody;

  /// No description provided for @gameQuitStay.
  ///
  /// In fr, this message translates to:
  /// **'Rester'**
  String get gameQuitStay;

  /// No description provided for @gameQuitLeave.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get gameQuitLeave;

  /// No description provided for @bidOpenHostilities.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir les hostilités'**
  String get bidOpenHostilities;

  /// No description provided for @bidRaiseSection.
  ///
  /// In fr, this message translates to:
  /// **'Ta surenchère'**
  String get bidRaiseSection;

  /// No description provided for @bidRaisePrompt.
  ///
  /// In fr, this message translates to:
  /// **'À toi de surenchérir.'**
  String get bidRaisePrompt;

  /// No description provided for @bidLastBid.
  ///
  /// In fr, this message translates to:
  /// **'Dernier pari : '**
  String get bidLastBid;

  /// No description provided for @bidPalificoFaceLabel.
  ///
  /// In fr, this message translates to:
  /// **'FACE IMPOSÉE'**
  String get bidPalificoFaceLabel;

  /// No description provided for @bidFaceLabel.
  ///
  /// In fr, this message translates to:
  /// **'FACE'**
  String get bidFaceLabel;

  /// No description provided for @bidSummaryAces.
  ///
  /// In fr, this message translates to:
  /// **'Je parie qu\'il y a au moins {count} as sur la table.'**
  String bidSummaryAces(int count);

  /// No description provided for @bidSummary.
  ///
  /// In fr, this message translates to:
  /// **'Je parie qu\'il y a au moins {count} {faceWord} sur la table.'**
  String bidSummary(int count, String faceWord);

  /// No description provided for @bidFaceWord.
  ///
  /// In fr, this message translates to:
  /// **'{quantity, plural, =1{dé} other{dés}} de {face}'**
  String bidFaceWord(int quantity, int face);

  /// No description provided for @bidPalificoFaceHint.
  ///
  /// In fr, this message translates to:
  /// **'Face imposée : manche palifico.'**
  String get bidPalificoFaceHint;

  /// No description provided for @bidPalificoOpenHint.
  ///
  /// In fr, this message translates to:
  /// **'Palifico : la face ouverte vaut pour toute la manche.'**
  String get bidPalificoOpenHint;

  /// No description provided for @bidAcesOnlyHint.
  ///
  /// In fr, this message translates to:
  /// **'Seuls les paco comptent.'**
  String get bidAcesOnlyHint;

  /// No description provided for @bidPacoWildHint.
  ///
  /// In fr, this message translates to:
  /// **'Les paco comptent pour cette face.'**
  String get bidPacoWildHint;

  /// No description provided for @bidAnnounce.
  ///
  /// In fr, this message translates to:
  /// **'Annoncer'**
  String get bidAnnounce;

  /// No description provided for @bidIllegalRaise.
  ///
  /// In fr, this message translates to:
  /// **'Ce montant n\'est pas une surenchère valable.'**
  String get bidIllegalRaise;

  /// No description provided for @bidDecreaseQty.
  ///
  /// In fr, this message translates to:
  /// **'Diminuer la quantité'**
  String get bidDecreaseQty;

  /// No description provided for @bidIncreaseQty.
  ///
  /// In fr, this message translates to:
  /// **'Augmenter la quantité'**
  String get bidIncreaseQty;

  /// No description provided for @bidUnitPaco.
  ///
  /// In fr, this message translates to:
  /// **'paco'**
  String get bidUnitPaco;

  /// No description provided for @bidUnit.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{dé} other{dés}}'**
  String bidUnit(int count);

  /// No description provided for @bidRange.
  ///
  /// In fr, this message translates to:
  /// **'{min} à {max}'**
  String bidRange(int min, int max);

  /// No description provided for @bidAceSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Paco, joker'**
  String get bidAceSemantics;

  /// No description provided for @bidFaceSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Valeur {face}'**
  String bidFaceSemantics(int face);

  /// No description provided for @cardEmptySemantics.
  ///
  /// In fr, this message translates to:
  /// **'Aucun pari. {name} ouvre les hostilités.'**
  String cardEmptySemantics(String name);

  /// No description provided for @cardFilledSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Pari en cours : {spoken}, annoncé par {bidder}. {total} dés en jeu.'**
  String cardFilledSemantics(String spoken, String bidder, int total);

  /// No description provided for @cardFilledTitle.
  ///
  /// In fr, this message translates to:
  /// **'PARI EN COURS'**
  String get cardFilledTitle;

  /// No description provided for @cardDiceUnit.
  ///
  /// In fr, this message translates to:
  /// **'DÉS'**
  String get cardDiceUnit;

  /// No description provided for @cardPalificoHint.
  ///
  /// In fr, this message translates to:
  /// **'Manche palifico : les paco ne comptent pas'**
  String get cardPalificoHint;

  /// No description provided for @cardAcesOnlyHint.
  ///
  /// In fr, this message translates to:
  /// **'Seuls les paco comptent'**
  String get cardAcesOnlyHint;

  /// No description provided for @cardPacoWildHint.
  ///
  /// In fr, this message translates to:
  /// **'Les paco comptent pour cette face'**
  String get cardPacoWildHint;

  /// No description provided for @cardDiceCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} dés'**
  String cardDiceCount(int count);

  /// No description provided for @cardTableWaits.
  ///
  /// In fr, this message translates to:
  /// **'LA TABLE ATTEND'**
  String get cardTableWaits;

  /// No description provided for @cardYouOpen.
  ///
  /// In fr, this message translates to:
  /// **'À toi d\'ouvrir'**
  String get cardYouOpen;

  /// No description provided for @cardPlayerOpens.
  ///
  /// In fr, this message translates to:
  /// **'{name} ouvre'**
  String cardPlayerOpens(String name);

  /// No description provided for @cardDiceOnTable.
  ///
  /// In fr, this message translates to:
  /// **'{count} dés sur la table'**
  String cardDiceOnTable(int count);

  /// No description provided for @peekRound.
  ///
  /// In fr, this message translates to:
  /// **'Manche {round}'**
  String peekRound(int round);

  /// No description provided for @peekCupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton gobelet'**
  String get peekCupTitle;

  /// No description provided for @peekSecretHint.
  ///
  /// In fr, this message translates to:
  /// **'Garde ce secret. Le reste de la table ne voit rien.'**
  String get peekSecretHint;

  /// No description provided for @peekShakeHint.
  ///
  /// In fr, this message translates to:
  /// **'Secoue le téléphone comme au vrai comptoir : le cuir se soulève, et toi seul vois tes dés.'**
  String get peekShakeHint;

  /// No description provided for @peekPalificoHint.
  ///
  /// In fr, this message translates to:
  /// **'Manche palifico : une seule face pour tous les paris.'**
  String get peekPalificoHint;

  /// No description provided for @peekDiceInHand.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{{count} dé en main} other{{count} dés en main}}'**
  String peekDiceInHand(int count);

  /// No description provided for @peekPacoNone.
  ///
  /// In fr, this message translates to:
  /// **'pas de paco'**
  String get peekPacoNone;

  /// No description provided for @peekPacoCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 paco} other{{count} paco}}'**
  String peekPacoCount(int count);

  /// No description provided for @peekPalificoWildHint.
  ///
  /// In fr, this message translates to:
  /// **'Manche palifico : les paco ne comptent que comme paco.'**
  String get peekPalificoWildHint;

  /// No description provided for @peekWildHint.
  ///
  /// In fr, this message translates to:
  /// **'Les paco comptent pour toutes les faces.'**
  String get peekWildHint;

  /// No description provided for @peekPlayerOpens.
  ///
  /// In fr, this message translates to:
  /// **'C’est à {name} d’ouvrir'**
  String peekPlayerOpens(String name);

  /// No description provided for @peekLiftCupSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Soulever le gobelet pour voir tes dés'**
  String get peekLiftCupSemantics;

  /// No description provided for @peekShakeButton.
  ///
  /// In fr, this message translates to:
  /// **'Secoue le téléphone pour brasser tes dés'**
  String get peekShakeButton;

  /// No description provided for @peekTapCupHint.
  ///
  /// In fr, this message translates to:
  /// **'… ou touche le gobelet pour le soulever'**
  String get peekTapCupHint;

  /// No description provided for @peekTakeTimeHint.
  ///
  /// In fr, this message translates to:
  /// **'Prends ton temps. Les autres pirates attendent.'**
  String get peekTakeTimeHint;

  /// No description provided for @revealDudoLine.
  ///
  /// In fr, this message translates to:
  /// **'{caller} a douté de {bidder}.'**
  String revealDudoLine(String caller, String bidder);

  /// No description provided for @revealCalzaLine.
  ///
  /// In fr, this message translates to:
  /// **'{caller} a annoncé le compte exact.'**
  String revealCalzaLine(String caller);

  /// No description provided for @revealBidHeld.
  ///
  /// In fr, this message translates to:
  /// **'Le pari tenait.'**
  String get revealBidHeld;

  /// No description provided for @revealLiar.
  ///
  /// In fr, this message translates to:
  /// **'Mensonge !'**
  String get revealLiar;

  /// No description provided for @revealExactCount.
  ///
  /// In fr, this message translates to:
  /// **'Compte exact.'**
  String get revealExactCount;

  /// No description provided for @revealMissed.
  ///
  /// In fr, this message translates to:
  /// **'Raté.'**
  String get revealMissed;

  /// No description provided for @revealAnnouncedBy.
  ///
  /// In fr, this message translates to:
  /// **'Annoncé par {name}'**
  String revealAnnouncedBy(String name);

  /// No description provided for @revealFacePaco.
  ///
  /// In fr, this message translates to:
  /// **'paco'**
  String get revealFacePaco;

  /// No description provided for @revealWordDiceOfFace.
  ///
  /// In fr, this message translates to:
  /// **'dés de {face}'**
  String revealWordDiceOfFace(int face);

  /// No description provided for @revealOnTable.
  ///
  /// In fr, this message translates to:
  /// **'sur la table · {count} annoncés'**
  String revealOnTable(int count);

  /// No description provided for @revealTableHoldsBreath.
  ///
  /// In fr, this message translates to:
  /// **'La table retient son souffle…'**
  String get revealTableHoldsBreath;

  /// No description provided for @revealCountInOpen.
  ///
  /// In fr, this message translates to:
  /// **'Le compte est sous les yeux de tous…'**
  String get revealCountInOpen;

  /// No description provided for @revealCapYou.
  ///
  /// In fr, this message translates to:
  /// **'Tu avais déjà cinq dés. Le compte exact est noté, mais rien à reprendre.'**
  String get revealCapYou;

  /// No description provided for @revealCapPlayer.
  ///
  /// In fr, this message translates to:
  /// **'{name} avait déjà cinq dés. Le compte exact est noté, mais rien à reprendre.'**
  String revealCapPlayer(String name);

  /// No description provided for @revealWinYou.
  ///
  /// In fr, this message translates to:
  /// **'Compte exact : tu reprends un dé.'**
  String get revealWinYou;

  /// No description provided for @revealWinPlayer.
  ///
  /// In fr, this message translates to:
  /// **'{name} reprend un dé.'**
  String revealWinPlayer(String name);

  /// No description provided for @revealYouLoseDie.
  ///
  /// In fr, this message translates to:
  /// **'Tu perds un dé.'**
  String get revealYouLoseDie;

  /// No description provided for @revealPlayerLoseDie.
  ///
  /// In fr, this message translates to:
  /// **'{name} perd un dé.'**
  String revealPlayerLoseDie(String name);

  /// No description provided for @revealYouRemaining.
  ///
  /// In fr, this message translates to:
  /// **' Il te reste {count, plural, =1{{count} dé} other{{count} dés}}.'**
  String revealYouRemaining(int count);

  /// No description provided for @revealPlayerRemaining.
  ///
  /// In fr, this message translates to:
  /// **' Il lui reste {count, plural, =1{{count} dé} other{{count} dés}}.'**
  String revealPlayerRemaining(int count);

  /// No description provided for @revealYouSunk.
  ///
  /// In fr, this message translates to:
  /// **' Tu es à l\'eau.'**
  String get revealYouSunk;

  /// No description provided for @revealPlayerSunk.
  ///
  /// In fr, this message translates to:
  /// **' Il est à l\'eau.'**
  String get revealPlayerSunk;

  /// No description provided for @revealNoLoser.
  ///
  /// In fr, this message translates to:
  /// **'La manche se termine sans perdant.'**
  String get revealNoLoser;

  /// No description provided for @revealNextRound.
  ///
  /// In fr, this message translates to:
  /// **'Manche suivante'**
  String get revealNextRound;

  /// No description provided for @revealSeeMore.
  ///
  /// In fr, this message translates to:
  /// **'Voir la suite'**
  String get revealSeeMore;

  /// No description provided for @revealRoleBidder.
  ///
  /// In fr, this message translates to:
  /// **'a parié'**
  String get revealRoleBidder;

  /// No description provided for @revealRoleCaller.
  ///
  /// In fr, this message translates to:
  /// **'a douté'**
  String get revealRoleCaller;

  /// No description provided for @revealRoleWaiter.
  ///
  /// In fr, this message translates to:
  /// **'a attendu'**
  String get revealRoleWaiter;

  /// No description provided for @overWonSection.
  ///
  /// In fr, this message translates to:
  /// **'La taverne est à toi'**
  String get overWonSection;

  /// No description provided for @overLostSection.
  ///
  /// In fr, this message translates to:
  /// **'Fin de l\'aventure'**
  String get overLostSection;

  /// No description provided for @overWonTitle.
  ///
  /// In fr, this message translates to:
  /// **'TU RÈGNES'**
  String get overWonTitle;

  /// No description provided for @overLostTitle.
  ///
  /// In fr, this message translates to:
  /// **'PAR-DESSUS BORD'**
  String get overLostTitle;

  /// No description provided for @overWonBody.
  ///
  /// In fr, this message translates to:
  /// **'L\'équipage a rendu les armes. La dernière chope est pour toi.'**
  String get overWonBody;

  /// No description provided for @overLostBody.
  ///
  /// In fr, this message translates to:
  /// **'Les pirates t\'ont eu. {name} garde la main sur le tonneau.'**
  String overLostBody(String name);

  /// No description provided for @overStatRounds.
  ///
  /// In fr, this message translates to:
  /// **'manches'**
  String get overStatRounds;

  /// No description provided for @overStatDiceLeft.
  ///
  /// In fr, this message translates to:
  /// **'dés restants'**
  String get overStatDiceLeft;

  /// No description provided for @overLastWord.
  ///
  /// In fr, this message translates to:
  /// **'LE DERNIER MOT'**
  String get overLastWord;

  /// No description provided for @overRematch.
  ///
  /// In fr, this message translates to:
  /// **'Rejouer'**
  String get overRematch;

  /// No description provided for @overStandingOut.
  ///
  /// In fr, this message translates to:
  /// **'à l\'eau'**
  String get overStandingOut;

  /// No description provided for @overBackToTavern.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la taverne'**
  String get overBackToTavern;

  /// No description provided for @overStandingDice.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{{count} dé} other{{count} dés}}'**
  String overStandingDice(int count);

  /// No description provided for @journalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Journal de la table'**
  String get journalTitle;

  /// No description provided for @journalSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Tout ce qui s\'est dit.'**
  String get journalSubtitle;

  /// No description provided for @journalRoundBadge.
  ///
  /// In fr, this message translates to:
  /// **'Manche {round}'**
  String journalRoundBadge(int round);

  /// No description provided for @journalEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Le journal est encore vierge. Les paris vont pleuvoir.'**
  String get journalEmpty;

  /// No description provided for @journalRoundWords.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{{count} parole} other{{count} paroles}}'**
  String journalRoundWords(int count);

  /// No description provided for @journalClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer le journal'**
  String get journalClose;

  /// No description provided for @journalSaidBid.
  ///
  /// In fr, this message translates to:
  /// **'{name} a annoncé {bid}.'**
  String journalSaidBid(String name, String bid);

  /// No description provided for @journalSaidDudo.
  ///
  /// In fr, this message translates to:
  /// **'{name} a dit dudo.'**
  String journalSaidDudo(String name);

  /// No description provided for @journalSaidCalza.
  ///
  /// In fr, this message translates to:
  /// **'{name} a demandé calza.'**
  String journalSaidCalza(String name);

  /// No description provided for @seatOutStatus.
  ///
  /// In fr, this message translates to:
  /// **'À l\'eau'**
  String get seatOutStatus;

  /// No description provided for @seatYourTurn.
  ///
  /// In fr, this message translates to:
  /// **'à toi'**
  String get seatYourTurn;

  /// No description provided for @seatThinking.
  ///
  /// In fr, this message translates to:
  /// **'réfléchit'**
  String get seatThinking;

  /// No description provided for @seatPlaying.
  ///
  /// In fr, this message translates to:
  /// **'en jeu'**
  String get seatPlaying;

  /// No description provided for @seatSemantics.
  ///
  /// In fr, this message translates to:
  /// **'{name}, {count, plural, =1{{count} dé restant} other{{count} dés restants}}, {status}'**
  String seatSemantics(String name, int count, String status);

  /// No description provided for @trayTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ta main'**
  String get trayTitle;

  /// No description provided for @trayDiceCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{{count} dé} other{{count} dés}}'**
  String trayDiceCount(int count);

  /// No description provided for @trayAcesPlain.
  ///
  /// In fr, this message translates to:
  /// **'paco simples'**
  String get trayAcesPlain;

  /// No description provided for @trayAcesWild.
  ///
  /// In fr, this message translates to:
  /// **'paco joker'**
  String get trayAcesWild;

  /// No description provided for @traySemantics.
  ///
  /// In fr, this message translates to:
  /// **'Ta main : {hand}'**
  String traySemantics(String hand);

  /// No description provided for @palificoSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Manche palifico : une seule face imposée, paco non jokers'**
  String get palificoSemantics;

  /// No description provided for @salonBackToTavern.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la taverne'**
  String get salonBackToTavern;

  /// No description provided for @salonHeader.
  ///
  /// In fr, this message translates to:
  /// **'MULTIJOUEUR'**
  String get salonHeader;

  /// No description provided for @salonHomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Un salon, cinq gobelets'**
  String get salonHomeTitle;

  /// No description provided for @salonHomeHint.
  ///
  /// In fr, this message translates to:
  /// **'Les amis entrent avec un code à six caractères. L\'hôte distribue les pirates IA, le salon communique en direct.'**
  String get salonHomeHint;

  /// No description provided for @salonCreateCta.
  ///
  /// In fr, this message translates to:
  /// **'Créer un salon'**
  String get salonCreateCta;

  /// No description provided for @salonJoinCta.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre un salon'**
  String get salonJoinCta;

  /// No description provided for @salonBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get salonBack;

  /// No description provided for @salonCreateHeader.
  ///
  /// In fr, this message translates to:
  /// **'CRÉER UN SALON'**
  String get salonCreateHeader;

  /// No description provided for @salonCreateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tu arrives premier'**
  String get salonCreateTitle;

  /// No description provided for @salonCreateHint.
  ///
  /// In fr, this message translates to:
  /// **'Choisis ton matelot et combien de pirates IA viendront mentir avec toi.'**
  String get salonCreateHint;

  /// No description provided for @salonNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ton nom de pirate'**
  String get salonNameLabel;

  /// No description provided for @salonBotsSection.
  ///
  /// In fr, this message translates to:
  /// **'Pirates IA'**
  String get salonBotsSection;

  /// No description provided for @salonCreateSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Créer le salon'**
  String get salonCreateSubmit;

  /// No description provided for @salonDefaultName.
  ///
  /// In fr, this message translates to:
  /// **'Barman'**
  String get salonDefaultName;

  /// No description provided for @salonCreateFailed.
  ///
  /// In fr, this message translates to:
  /// **'La création du salon a échoué.'**
  String get salonCreateFailed;

  /// No description provided for @salonJoinHeader.
  ///
  /// In fr, this message translates to:
  /// **'REJOINDRE UN SALON'**
  String get salonJoinHeader;

  /// No description provided for @salonJoinTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le code fait foi'**
  String get salonJoinTitle;

  /// No description provided for @salonJoinHint.
  ///
  /// In fr, this message translates to:
  /// **'Entre les six caractères que l\'hôte t\'a envoyés. Sur le salon, ton nom est tout ce que tu peux changer.'**
  String get salonJoinHint;

  /// No description provided for @salonCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code du salon'**
  String get salonCodeLabel;

  /// No description provided for @salonPasteHint.
  ///
  /// In fr, this message translates to:
  /// **'Rentrer en frais — via SMS, mail, WhatsApp, Signal ou n\'importe où ailleurs, c\'est juste mieux.'**
  String get salonPasteHint;

  /// No description provided for @salonJoinNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ton nom (tu peux encore le changer)'**
  String get salonJoinNameLabel;

  /// No description provided for @salonJoinSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre'**
  String get salonJoinSubmit;

  /// No description provided for @salonJoinFailed.
  ///
  /// In fr, this message translates to:
  /// **'Salon injoignable pour l\'instant.'**
  String get salonJoinFailed;

  /// No description provided for @salonLeaveSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Quitter le salon'**
  String get salonLeaveSemantic;

  /// No description provided for @salonCodeHeader.
  ///
  /// In fr, this message translates to:
  /// **'SALON {code}'**
  String salonCodeHeader(String code);

  /// No description provided for @salonHostRole.
  ///
  /// In fr, this message translates to:
  /// **'Tu reines sur ce salon'**
  String get salonHostRole;

  /// No description provided for @salonGuestRole.
  ///
  /// In fr, this message translates to:
  /// **'Invité de l\'hôte'**
  String get salonGuestRole;

  /// No description provided for @salonCopySemantic.
  ///
  /// In fr, this message translates to:
  /// **'Copier le code'**
  String get salonCopySemantic;

  /// No description provided for @salonCopied.
  ///
  /// In fr, this message translates to:
  /// **'Code copié dans le presse-papier.'**
  String get salonCopied;

  /// No description provided for @salonStartRound.
  ///
  /// In fr, this message translates to:
  /// **'Lancer la manche'**
  String get salonStartRound;

  /// No description provided for @salonRoundPreparing.
  ///
  /// In fr, this message translates to:
  /// **'La manche se prépare…'**
  String get salonRoundPreparing;

  /// No description provided for @salonWaitingHost.
  ///
  /// In fr, this message translates to:
  /// **'En attente que l\'hôte lance la manche…'**
  String get salonWaitingHost;

  /// No description provided for @salonFeedSection.
  ///
  /// In fr, this message translates to:
  /// **'Le fil du salon'**
  String get salonFeedSection;

  /// No description provided for @salonStartFailed.
  ///
  /// In fr, this message translates to:
  /// **'La manche n\'a pas pu démarrer. Réessaie.'**
  String get salonStartFailed;

  /// No description provided for @salonShareSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Partager le code'**
  String get salonShareSemantic;

  /// No description provided for @salonShareSmsSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer par SMS'**
  String get salonShareSmsSemantic;

  /// No description provided for @salonShareMailSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer par mail'**
  String get salonShareMailSemantic;

  /// No description provided for @salonShareWhatsappSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer sur WhatsApp'**
  String get salonShareWhatsappSemantic;

  /// No description provided for @salonShareHint.
  ///
  /// In fr, this message translates to:
  /// **'WhatsApp, Signal, SMS, mail : chaque app ouvre les bons liens, sinon copie.'**
  String get salonShareHint;

  /// No description provided for @salonPlayersCount.
  ///
  /// In fr, this message translates to:
  /// **'À table ({count})'**
  String salonPlayersCount(int count);

  /// No description provided for @salonBotBadge.
  ///
  /// In fr, this message translates to:
  /// **'IA'**
  String get salonBotBadge;

  /// No description provided for @salonRemoveBotSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Retirer un pirate IA'**
  String get salonRemoveBotSemantic;

  /// No description provided for @salonAddBotSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un pirate IA'**
  String get salonAddBotSemantic;

  /// No description provided for @salonYouSuffix.
  ///
  /// In fr, this message translates to:
  /// **'(toi)'**
  String get salonYouSuffix;

  /// No description provided for @salonHostBadge.
  ///
  /// In fr, this message translates to:
  /// **'HÔTE'**
  String get salonHostBadge;

  /// No description provided for @salonLeaveTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quitter le salon ?'**
  String get salonLeaveTitle;

  /// No description provided for @salonLeaveBody.
  ///
  /// In fr, this message translates to:
  /// **'Le code deviendra inutilisable pour cette partie.'**
  String get salonLeaveBody;

  /// No description provided for @salonLeaveStay.
  ///
  /// In fr, this message translates to:
  /// **'Rester'**
  String get salonLeaveStay;

  /// No description provided for @salonLeaveQuit.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get salonLeaveQuit;

  /// No description provided for @reactionHeader.
  ///
  /// In fr, this message translates to:
  /// **'RÉAGIR'**
  String get reactionHeader;

  /// No description provided for @speakHeader.
  ///
  /// In fr, this message translates to:
  /// **'PARLE'**
  String get speakHeader;

  /// No description provided for @reactionTargetSummary.
  ///
  /// In fr, this message translates to:
  /// **'{player} · mes dés : {n}'**
  String reactionTargetSummary(String player, int n);

  /// No description provided for @reactionLine1.
  ///
  /// In fr, this message translates to:
  /// **'Tu n\'es pas obligé de me croire, mais j\'ai {n} dés.'**
  String reactionLine1(int n);

  /// No description provided for @reactionLine2.
  ///
  /// In fr, this message translates to:
  /// **'Alors non, {player}, c\'est pas possible.'**
  String reactionLine2(String player);

  /// No description provided for @reactionLine3.
  ///
  /// In fr, this message translates to:
  /// **'Le paco, c\'est ta fin, {player}.'**
  String reactionLine3(String player);

  /// No description provided for @reactionLine4.
  ///
  /// In fr, this message translates to:
  /// **'Je te promets : au plus {n} dés sur la table, ils mentent.'**
  String reactionLine4(int n);

  /// No description provided for @reactionLine5.
  ///
  /// In fr, this message translates to:
  /// **'Regarde mes {n} dés, {player}, tu es à l\'eau d\'ici ce soir.'**
  String reactionLine5(int n, String player);

  /// No description provided for @reactionLine6.
  ///
  /// In fr, this message translates to:
  /// **'Paco sur paco paco paco.'**
  String get reactionLine6;

  /// No description provided for @reactionLine7.
  ///
  /// In fr, this message translates to:
  /// **'Je te crois, {player}, te voilà bien détrompé.'**
  String reactionLine7(String player);

  /// No description provided for @reactionFreeHint.
  ///
  /// In fr, this message translates to:
  /// **'Écrire un message libre…'**
  String get reactionFreeHint;

  /// No description provided for @rulesHeader.
  ///
  /// In fr, this message translates to:
  /// **'LES RÈGLES'**
  String get rulesHeader;

  /// No description provided for @rulesBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get rulesBack;

  /// No description provided for @rulesHeroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le jeu du mensonge'**
  String get rulesHeroTitle;

  /// No description provided for @rulesHeroIntro.
  ///
  /// In fr, this message translates to:
  /// **'Perudo, Dudo, Cacho… peu importe le nom. Les dés ne mentent pas. Les pirates, si.'**
  String get rulesHeroIntro;

  /// No description provided for @rulesShowcaseCaption.
  ///
  /// In fr, this message translates to:
  /// **'Cinq dés, un paco joker, et aucune raison de dire la vérité.'**
  String get rulesShowcaseCaption;

  /// No description provided for @rulesGoalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le but'**
  String get rulesGoalTitle;

  /// No description provided for @rulesGoalBody.
  ///
  /// In fr, this message translates to:
  /// **'Rester le dernier pirate avec au moins un dé. Chaque manche, on parie sur ce que cachent les gobelets. Celui qui se trompe perd un dé.'**
  String get rulesGoalBody;

  /// No description provided for @rulesCupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton gobelet'**
  String get rulesCupTitle;

  /// No description provided for @rulesCupBody.
  ///
  /// In fr, this message translates to:
  /// **'Chacun reçoit cinq dés et les cache sous son gobelet. Tu regardes les tiens en secret.'**
  String get rulesCupBody;

  /// No description provided for @rulesPacoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Les paco sont jokers'**
  String get rulesPacoTitle;

  /// No description provided for @rulesPacoBody.
  ///
  /// In fr, this message translates to:
  /// **'Un paco (1) compte pour n\'importe quelle face. Il ne compte que comme un paco quand le pari porte sur les paco. Un paco vaut donc deux dés normaux au moment de surenchérir.'**
  String get rulesPacoBody;

  /// No description provided for @rulesBidTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le pari'**
  String get rulesBidTitle;

  /// No description provided for @rulesBidBody.
  ///
  /// In fr, this message translates to:
  /// **'Un pari a deux nombres : une quantité et une face.'**
  String get rulesBidBody;

  /// No description provided for @rulesBidQuote.
  ///
  /// In fr, this message translates to:
  /// **'« Il y a au moins 4 dés de 5 sur la table. »'**
  String get rulesBidQuote;

  /// No description provided for @rulesBidExplain.
  ///
  /// In fr, this message translates to:
  /// **'Ici, le pirate affirme qu\'il y a au moins quatre dés de valeur 5 sur toute la table. Les paco comptent aussi.'**
  String get rulesBidExplain;

  /// No description provided for @rulesRaiseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Surenchérir'**
  String get rulesRaiseTitle;

  /// No description provided for @rulesRaiseIntro.
  ///
  /// In fr, this message translates to:
  /// **'Le pari suivant doit toujours être plus fort :'**
  String get rulesRaiseIntro;

  /// No description provided for @rulesRaiseSameFace.
  ///
  /// In fr, this message translates to:
  /// **'Plus de dés sur la même face : 4 dés de 5 → 5 dés de 5.'**
  String get rulesRaiseSameFace;

  /// No description provided for @rulesRaiseHigherFace.
  ///
  /// In fr, this message translates to:
  /// **'Même nombre, face plus haute : 4 dés de 5 → 4 dés de 6.'**
  String get rulesRaiseHigherFace;

  /// No description provided for @rulesRaiseTowardPaco.
  ///
  /// In fr, this message translates to:
  /// **'Vers les paco : au moins la moitié, arrondie au-dessus : 4 dés de 5 → 2 paco.'**
  String get rulesRaiseTowardPaco;

  /// No description provided for @rulesRaiseFromPaco.
  ///
  /// In fr, this message translates to:
  /// **'Depuis les paco : le double plus un : 2 paco → 5 dés de n\'importe quelle face.'**
  String get rulesRaiseFromPaco;

  /// No description provided for @rulesConvert45.
  ///
  /// In fr, this message translates to:
  /// **'4 dés de 5'**
  String get rulesConvert45;

  /// No description provided for @rulesConvert2Paco.
  ///
  /// In fr, this message translates to:
  /// **'2 paco'**
  String get rulesConvert2Paco;

  /// No description provided for @rulesConvert5F2.
  ///
  /// In fr, this message translates to:
  /// **'5 dés de 2'**
  String get rulesConvert5F2;

  /// No description provided for @rulesConvert5F6.
  ///
  /// In fr, this message translates to:
  /// **'5 dés de 6'**
  String get rulesConvert5F6;

  /// No description provided for @rulesConvert3Paco.
  ///
  /// In fr, this message translates to:
  /// **'3 paco'**
  String get rulesConvert3Paco;

  /// No description provided for @rulesDudoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dudo !'**
  String get rulesDudoTitle;

  /// No description provided for @rulesDudoBody.
  ///
  /// In fr, this message translates to:
  /// **'Au lieu de surenchérir, tu peux douter du dernier pari. Tout le monde soulève son gobelet et on compte.'**
  String get rulesDudoBody;

  /// No description provided for @rulesDudoHoldsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le pari tient'**
  String get rulesDudoHoldsTitle;

  /// No description provided for @rulesDudoHoldsBody.
  ///
  /// In fr, this message translates to:
  /// **'Le douteur perd un dé.'**
  String get rulesDudoHoldsBody;

  /// No description provided for @rulesDudoWrongTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le pari est faux'**
  String get rulesDudoWrongTitle;

  /// No description provided for @rulesDudoWrongBody.
  ///
  /// In fr, this message translates to:
  /// **'Le parieur perd un dé.'**
  String get rulesDudoWrongBody;

  /// No description provided for @rulesCalzaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Calza — optionnel'**
  String get rulesCalzaTitle;

  /// No description provided for @rulesCalzaBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu peux aussi annoncer que le compte est exactement bon. C\'est la calza.'**
  String get rulesCalzaBody;

  /// No description provided for @rulesCalzaAllOrNothing.
  ///
  /// In fr, this message translates to:
  /// **'Tout ou rien'**
  String get rulesCalzaAllOrNothing;

  /// No description provided for @rulesCalzaAllOrNothingBody.
  ///
  /// In fr, this message translates to:
  /// **'Compte exact : tu gagnes un dé (cinq maximum). Compte faux : tu en perds un. La calza peut être désactivée avant la partie.'**
  String get rulesCalzaAllOrNothingBody;

  /// No description provided for @rulesEndTitle.
  ///
  /// In fr, this message translates to:
  /// **'La fin'**
  String get rulesEndTitle;

  /// No description provided for @rulesEndBody.
  ///
  /// In fr, this message translates to:
  /// **'Un pirate qui perd son dernier dé est à l\'eau. Le dernier survivant gagne la taverne. Le perdant de la manche ouvre la suivante.'**
  String get rulesEndBody;

  /// No description provided for @rulesPalificoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Palifico'**
  String get rulesPalificoTitle;

  /// No description provided for @rulesPalificoBody.
  ///
  /// In fr, this message translates to:
  /// **'Le pirate qui perd son avant-dernier dé déclenche le palifico : la manche suivante se joue entièrement sur une seule face, imposée par l\'ouverture.'**
  String get rulesPalificoBody;

  /// No description provided for @rulesPalificoFaceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Face imposée'**
  String get rulesPalificoFaceTitle;

  /// No description provided for @rulesPalificoFaceBody.
  ///
  /// In fr, this message translates to:
  /// **'Le premier pari choisit la face et ouvre à deux dés minimum. Tous les suivants montent la quantité de cette même face ; impossible de changer de valeur.'**
  String get rulesPalificoFaceBody;

  /// No description provided for @rulesPalificoPacoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paco sans joker'**
  String get rulesPalificoPacoTitle;

  /// No description provided for @rulesPalificoPacoBody.
  ///
  /// In fr, this message translates to:
  /// **'Pendant le palifico, les paco ne comptent que comme paco : plus de joker.'**
  String get rulesPalificoPacoBody;

  /// No description provided for @rulesPalificoOnceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Une seule manche'**
  String get rulesPalificoOnceTitle;

  /// No description provided for @rulesPalificoOnceBody.
  ///
  /// In fr, this message translates to:
  /// **'À la manche d\'après, les enchères reprennent la forme normale, même si le pirate reste à un dé. Et si quelqu\'un rechute à un dé plus tard, le palifico se déclenche à nouveau.'**
  String get rulesPalificoOnceBody;

  /// No description provided for @rulesTipQuote.
  ///
  /// In fr, this message translates to:
  /// **'Le meilleur bluff est celui que personne n\'a envie de payer.'**
  String get rulesTipQuote;

  /// No description provided for @rulesUnderstood.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai compris'**
  String get rulesUnderstood;

  /// No description provided for @diceHiddenText.
  ///
  /// In fr, this message translates to:
  /// **'Dé caché'**
  String get diceHiddenText;

  /// No description provided for @diceAceText.
  ///
  /// In fr, this message translates to:
  /// **'As, joker'**
  String get diceAceText;

  /// No description provided for @diceValueText.
  ///
  /// In fr, this message translates to:
  /// **'Dé de valeur {value}'**
  String diceValueText(int value);

  /// No description provided for @bidAcesLabel.
  ///
  /// In fr, this message translates to:
  /// **'{count} paco'**
  String bidAcesLabel(int count);

  /// No description provided for @bidPlainLabel.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{{count} dé de {face}} other{{count} dés de {face}}}'**
  String bidPlainLabel(int count, int face);

  /// No description provided for @bidSpokenAces.
  ///
  /// In fr, this message translates to:
  /// **'au moins {count} paco'**
  String bidSpokenAces(int count);

  /// No description provided for @bidSpokenPlain.
  ///
  /// In fr, this message translates to:
  /// **'au moins {count, plural, =1{{count} dé} other{{count} dés}} de valeur {face}'**
  String bidSpokenPlain(int count, int face);

  /// No description provided for @bidShortLabel.
  ///
  /// In fr, this message translates to:
  /// **'{quantity}×{mark}'**
  String bidShortLabel(int quantity, String mark);

  /// No description provided for @temperMousseLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mousse'**
  String get temperMousseLabel;

  /// No description provided for @temperMousseBody.
  ///
  /// In fr, this message translates to:
  /// **'Timide, prudent, facile à bluffer.'**
  String get temperMousseBody;

  /// No description provided for @temperFlibustierLabel.
  ///
  /// In fr, this message translates to:
  /// **'Flibustier'**
  String get temperFlibustierLabel;

  /// No description provided for @temperFlibustierBody.
  ///
  /// In fr, this message translates to:
  /// **'Un adversaire honnête, qui sait sentir le mensonge.'**
  String get temperFlibustierBody;

  /// No description provided for @temperCapitaineLabel.
  ///
  /// In fr, this message translates to:
  /// **'Capitaine'**
  String get temperCapitaineLabel;

  /// No description provided for @temperCapitaineBody.
  ///
  /// In fr, this message translates to:
  /// **'Calcule les probabilités et n\'aime pas perdre.'**
  String get temperCapitaineBody;

  /// No description provided for @systemPhoneSlept.
  ///
  /// In fr, this message translates to:
  /// **'Le téléphone a mis le salon en sommeil — reconnexion…'**
  String get systemPhoneSlept;

  /// No description provided for @systemQuietCut.
  ///
  /// In fr, this message translates to:
  /// **'Le salon ne répond plus — je coupe la connexion desséchée et je reprends…'**
  String get systemQuietCut;

  /// No description provided for @systemCreated.
  ///
  /// In fr, this message translates to:
  /// **'Salon créé. Code : {code}'**
  String systemCreated(String code);

  /// No description provided for @systemConnected.
  ///
  /// In fr, this message translates to:
  /// **'Connecté au salon {code}'**
  String systemConnected(String code);

  /// No description provided for @systemRecovered.
  ///
  /// In fr, this message translates to:
  /// **'Reconnecté au salon {code}.'**
  String systemRecovered(String code);

  /// No description provided for @systemClosed.
  ///
  /// In fr, this message translates to:
  /// **'Salon fermé : {reason}'**
  String systemClosed(String reason);

  /// No description provided for @systemLost.
  ///
  /// In fr, this message translates to:
  /// **'Connexion perdue{detail} — tentative de reconnexion…'**
  String systemLost(String detail);

  /// No description provided for @systemUnreachableTrack.
  ///
  /// In fr, this message translates to:
  /// **'Salon injoignable — {reason} Je continue d\'essayer.'**
  String systemUnreachableTrack(String reason);

  /// No description provided for @systemUnreachableBackoff.
  ///
  /// In fr, this message translates to:
  /// **'Salon injoignable — {brief}. Je continue d\'essayer en doublant le délai.'**
  String systemUnreachableBackoff(String brief);

  /// No description provided for @systemThrottledCreate.
  ///
  /// In fr, this message translates to:
  /// **'Trop de demandes de création — réessaie dans ~{seconds} s.'**
  String systemThrottledCreate(int seconds);

  /// No description provided for @systemCreateFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de créer un salon pour l\'instant.{detail}'**
  String systemCreateFailed(String detail);

  /// No description provided for @systemChatRate.
  ///
  /// In fr, this message translates to:
  /// **'Débit du salon atteint — attends {seconds}s.'**
  String systemChatRate(int seconds);

  /// No description provided for @systemDeadReaction.
  ///
  /// In fr, this message translates to:
  /// **'La connexion au salon est lâchée — la réaction ne peut pas partir.'**
  String get systemDeadReaction;

  /// No description provided for @systemDeadChat.
  ///
  /// In fr, this message translates to:
  /// **'La connexion au salon est lâchée — le message ne peut pas partir.'**
  String get systemDeadChat;

  /// No description provided for @systemSixChars.
  ///
  /// In fr, this message translates to:
  /// **'Le code doit faire six caractères.'**
  String get systemSixChars;
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

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

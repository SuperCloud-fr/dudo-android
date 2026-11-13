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
  /// **'La taverne du dernier pirate'**
  String get homeTavernSection;

  /// No description provided for @homeTagline.
  ///
  /// In fr, this message translates to:
  /// **'Cinq dés. Un gobelet. À toi de bluffer.'**
  String get homeTagline;

  /// No description provided for @homeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Le Perudo en version pirate : affronte un équipage rusé.'**
  String get homeSubtitle;

  /// No description provided for @ctaPlay.
  ///
  /// In fr, this message translates to:
  /// **'Jouer en solo'**
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
  /// **'Paramètres'**
  String get ctaSettings;

  /// No description provided for @homeVersionBadge.
  ///
  /// In fr, this message translates to:
  /// **'2 à 6 joueurs'**
  String get homeVersionBadge;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'PARAMÈTRES'**
  String get settingsTitle;

  /// No description provided for @settingsAmbienceTitle.
  ///
  /// In fr, this message translates to:
  /// **'L\'ambiance'**
  String get settingsAmbienceTitle;

  /// No description provided for @settingsAmbienceHint.
  ///
  /// In fr, this message translates to:
  /// **'Choisis une ambiance : les règles restent les mêmes, seule la lumière change.'**
  String get settingsAmbienceHint;

  /// No description provided for @lookChosen.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnée'**
  String get lookChosen;

  /// No description provided for @lookPick.
  ///
  /// In fr, this message translates to:
  /// **'Choisir cette ambiance'**
  String get lookPick;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Lire la politique de confidentialité'**
  String get settingsPrivacyPolicy;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler l\'action'**
  String get commonCancel;

  /// No description provided for @setupBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get setupBack;

  /// No description provided for @setupTitle.
  ///
  /// In fr, this message translates to:
  /// **'NOUVELLE PARTIE'**
  String get setupTitle;

  /// No description provided for @setupCrewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Qui monte à bord ?'**
  String get setupCrewTitle;

  /// No description provided for @setupCrewHint.
  ///
  /// In fr, this message translates to:
  /// **'Choisis combien de pirates IA t\'affronteront.'**
  String get setupCrewHint;

  /// No description provided for @setupBotTemperTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le caractère de l\'équipage'**
  String get setupBotTemperTitle;

  /// No description provided for @setupStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer la partie'**
  String get setupStart;

  /// No description provided for @setupRulesLink.
  ///
  /// In fr, this message translates to:
  /// **'Relire les règles'**
  String get setupRulesLink;

  /// No description provided for @setupTableLabel.
  ///
  /// In fr, this message translates to:
  /// **'QUI EMBARQUE ?'**
  String get setupTableLabel;

  /// No description provided for @setupPlayersCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 pirate à bord} other{{count} pirates à bord}}'**
  String setupPlayersCount(int count);

  /// No description provided for @setupRemovePirate.
  ///
  /// In fr, this message translates to:
  /// **'Retirer ce pirate'**
  String get setupRemovePirate;

  /// No description provided for @setupAddPirate.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un pirate'**
  String get setupAddPirate;

  /// No description provided for @setupSeatAtTable.
  ///
  /// In fr, this message translates to:
  /// **'présent'**
  String get setupSeatAtTable;

  /// No description provided for @setupSeatAbsent.
  ///
  /// In fr, this message translates to:
  /// **'au repos'**
  String get setupSeatAbsent;

  /// No description provided for @setupCrewSummary.
  ///
  /// In fr, this message translates to:
  /// **'À bord : toi et {count, plural, =1{1 pirate} other{{count} pirates}} — {names}'**
  String setupCrewSummary(int count, String names);

  /// No description provided for @setupCalzaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Calza autorisée'**
  String get setupCalzaTitle;

  /// No description provided for @setupCalzaHint.
  ///
  /// In fr, this message translates to:
  /// **'Annonce le compte exact pour gagner un dé (cinq maximum). Cette règle est facultative.'**
  String get setupCalzaHint;

  /// No description provided for @gameQuitTable.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la table'**
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
  /// **'Consulter le journal de bord'**
  String get gameOpenJournal;

  /// No description provided for @gameOpenSalonChat.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le chat du salon'**
  String get gameOpenSalonChat;

  /// No description provided for @gameOpenPrompt.
  ///
  /// In fr, this message translates to:
  /// **'À toi de faire le premier pari.'**
  String get gameOpenPrompt;

  /// No description provided for @gameYourTurnPrompt.
  ///
  /// In fr, this message translates to:
  /// **'À toi de jouer.'**
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
  /// **'Ouvrir les hostilités'**
  String get gameOpenBid;

  /// No description provided for @gameBotThinking.
  ///
  /// In fr, this message translates to:
  /// **'{name} prépare son coup…'**
  String gameBotThinking(String name);

  /// No description provided for @gameTableListens.
  ///
  /// In fr, this message translates to:
  /// **'Tout le bord retient son souffle.'**
  String get gameTableListens;

  /// No description provided for @gameLiftCupPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Soulève ton gobelet pour révéler les dés.'**
  String get gameLiftCupPrompt;

  /// No description provided for @gameTableHoldsBreath.
  ///
  /// In fr, this message translates to:
  /// **'La table retient son souffle.'**
  String get gameTableHoldsBreath;

  /// No description provided for @gameBidInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Ce pari n\'est plus valable. Choisis-en un autre.'**
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
  /// **'Tu contestes l\'affirmation suivante : {accused} sur « {bid} ». Si le compte atteint le pari, tu perds un dé.'**
  String gameDudoConfirmBody(String accused, String bid);

  /// No description provided for @gameDudoConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le Dudo'**
  String get gameDudoConfirm;

  /// No description provided for @gameCalzaConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte exact ?'**
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
  /// **'Tu annonces {bid}. Si le compte est exact, tu gagnes un dé (cinq maximum). Sinon, tu en perds un.'**
  String gameCalzaConfirmBody(String bid);

  /// No description provided for @gameCalzaConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la calza'**
  String get gameCalzaConfirm;

  /// No description provided for @gameQuitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Abandonner la partie ?'**
  String get gameQuitTitle;

  /// No description provided for @gameQuitBody.
  ///
  /// In fr, this message translates to:
  /// **'La partie s\'arrêtera et ne pourra pas être reprise.'**
  String get gameQuitBody;

  /// No description provided for @gameQuitHostBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu quittes définitivement le salon : le premier joueur connecté prend la barre et la partie continue sans toi.'**
  String get gameQuitHostBody;

  /// No description provided for @gameQuitGuestBody.
  ///
  /// In fr, this message translates to:
  /// **'Un pirate jouera ta place jusqu\'à la fin de la manche. Tu pourras reprendre ton siège depuis le salon.'**
  String get gameQuitGuestBody;

  /// No description provided for @gameQuitStay.
  ///
  /// In fr, this message translates to:
  /// **'Continuer la partie'**
  String get gameQuitStay;

  /// No description provided for @gameQuitLeave.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la partie'**
  String get gameQuitLeave;

  /// No description provided for @bidOpenHostilities.
  ///
  /// In fr, this message translates to:
  /// **'Le premier coup de canon'**
  String get bidOpenHostilities;

  /// No description provided for @bidRaiseSection.
  ///
  /// In fr, this message translates to:
  /// **'À toi de faire monter le pari'**
  String get bidRaiseSection;

  /// No description provided for @bidRaisePrompt.
  ///
  /// In fr, this message translates to:
  /// **'À toi de surenchérir.'**
  String get bidRaisePrompt;

  /// No description provided for @bidLastBid.
  ///
  /// In fr, this message translates to:
  /// **'Pari précédent : '**
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
  /// **'Il y a au moins {count, plural, =1{un paco} other{{count} pacos}} sur la table.'**
  String bidSummaryAces(int count);

  /// No description provided for @bidSummary.
  ///
  /// In fr, this message translates to:
  /// **'Il y a au moins {count} {faceWord} sur la table.'**
  String bidSummary(int count, String faceWord);

  /// No description provided for @bidFaceWord.
  ///
  /// In fr, this message translates to:
  /// **'{quantity, plural, =1{dé} other{dés}} de {face}'**
  String bidFaceWord(int quantity, int face);

  /// No description provided for @bidPalificoFaceHint.
  ///
  /// In fr, this message translates to:
  /// **'En palifico, la face est imposée.'**
  String get bidPalificoFaceHint;

  /// No description provided for @bidPalificoOpenHint.
  ///
  /// In fr, this message translates to:
  /// **'En palifico, la face du premier pari s\'applique toute la manche.'**
  String get bidPalificoOpenHint;

  /// No description provided for @bidAcesOnlyHint.
  ///
  /// In fr, this message translates to:
  /// **'Seuls les pacos comptent.'**
  String get bidAcesOnlyHint;

  /// No description provided for @bidPacoWildHint.
  ///
  /// In fr, this message translates to:
  /// **'Les pacos comptent pour cette face.'**
  String get bidPacoWildHint;

  /// No description provided for @bidAnnounce.
  ///
  /// In fr, this message translates to:
  /// **'Annoncer'**
  String get bidAnnounce;

  /// No description provided for @bidIllegalRaise.
  ///
  /// In fr, this message translates to:
  /// **'Ce pari ne respecte pas les règles de surenchère. Essaie une autre combinaison.'**
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
  /// **'Paco, face 1 et joker'**
  String get bidAceSemantics;

  /// No description provided for @bidFaceSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Le dé montre {face}'**
  String bidFaceSemantics(int face);

  /// No description provided for @cardEmptySemantics.
  ///
  /// In fr, this message translates to:
  /// **'La table est vierge. {name} lance le premier pari.'**
  String cardEmptySemantics(String name);

  /// No description provided for @cardFilledSemantics.
  ///
  /// In fr, this message translates to:
  /// **'{bidder} a annoncé {spoken}. Il y a {total} dés en jeu.'**
  String cardFilledSemantics(String spoken, String bidder, int total);

  /// No description provided for @cardFilledTitle.
  ///
  /// In fr, this message translates to:
  /// **'PARI EN COURS'**
  String get cardFilledTitle;

  /// No description provided for @cardDiceUnit.
  ///
  /// In fr, this message translates to:
  /// **'DÉS EN JEU'**
  String get cardDiceUnit;

  /// No description provided for @cardPalificoHint.
  ///
  /// In fr, this message translates to:
  /// **'En palifico, les pacos ne sont pas jokers.'**
  String get cardPalificoHint;

  /// No description provided for @cardAcesOnlyHint.
  ///
  /// In fr, this message translates to:
  /// **'Seuls les pacos comptent.'**
  String get cardAcesOnlyHint;

  /// No description provided for @cardPacoWildHint.
  ///
  /// In fr, this message translates to:
  /// **'Les pacos comptent comme cette face.'**
  String get cardPacoWildHint;

  /// No description provided for @cardDiceCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} dés en jeu'**
  String cardDiceCount(int count);

  /// No description provided for @cardTableWaits.
  ///
  /// In fr, this message translates to:
  /// **'TOUT LE BORD RETIENT SON SOUFFLE'**
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
  /// **'Tes dés'**
  String get peekCupTitle;

  /// No description provided for @peekSecretHint.
  ///
  /// In fr, this message translates to:
  /// **'Garde ce secret. Le reste de la table ne voit rien.'**
  String get peekSecretHint;

  /// No description provided for @peekShakeHint.
  ///
  /// In fr, this message translates to:
  /// **'Secoue le téléphone pour lancer tes dés. Toi seul peux les voir.'**
  String get peekShakeHint;

  /// No description provided for @peekPalificoHint.
  ///
  /// In fr, this message translates to:
  /// **'En palifico, tous les paris portent sur la même face.'**
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
  /// **'{count, plural, =1{1 paco} other{{count} pacos}}'**
  String peekPacoCount(int count);

  /// No description provided for @peekPalificoWildHint.
  ///
  /// In fr, this message translates to:
  /// **'En palifico, les pacos ne valent que comme pacos.'**
  String get peekPalificoWildHint;

  /// No description provided for @peekWildHint.
  ///
  /// In fr, this message translates to:
  /// **'Les pacos comptent pour toutes les faces.'**
  String get peekWildHint;

  /// No description provided for @peekPlayerOpens.
  ///
  /// In fr, this message translates to:
  /// **'C’est à {name} d’ouvrir'**
  String peekPlayerOpens(String name);

  /// No description provided for @peekOnlyHostStarts.
  ///
  /// In fr, this message translates to:
  /// **'Le capitaine lance la manche ; en attendant, jette un œil à tes dés.'**
  String get peekOnlyHostStarts;

  /// No description provided for @peekLiftCupSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Soulever le gobelet pour voir tes dés'**
  String get peekLiftCupSemantics;

  /// No description provided for @peekShakeButton.
  ///
  /// In fr, this message translates to:
  /// **'Secouer pour lancer les dés'**
  String get peekShakeButton;

  /// No description provided for @peekTapCupHint.
  ///
  /// In fr, this message translates to:
  /// **'… ou touche le gobelet pour le soulever'**
  String get peekTapCupHint;

  /// No description provided for @peekTakeTimeHint.
  ///
  /// In fr, this message translates to:
  /// **'Prends ton temps : les autres attendent.'**
  String get peekTakeTimeHint;

  /// No description provided for @peekSpectatorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Par-dessus bord'**
  String get peekSpectatorTitle;

  /// No description provided for @peekSpectatorBody.
  ///
  /// In fr, this message translates to:
  /// **'Plus de dés pour toi : regarde l\'équipage poursuivre la manche et prépare ta revanche.'**
  String get peekSpectatorBody;

  /// No description provided for @peekSpectatorCta.
  ///
  /// In fr, this message translates to:
  /// **'Regarder la manche'**
  String get peekSpectatorCta;

  /// No description provided for @peekSpectatorWait.
  ///
  /// In fr, this message translates to:
  /// **'En attente du signal du capitaine…'**
  String get peekSpectatorWait;

  /// No description provided for @revealDudoLine.
  ///
  /// In fr, this message translates to:
  /// **'{caller} a contesté le pari de {bidder}.'**
  String revealDudoLine(String caller, String bidder);

  /// No description provided for @revealCalzaLine.
  ///
  /// In fr, this message translates to:
  /// **'{caller} a tenté une calza.'**
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
  /// **'Compte exact, matelot !'**
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
  /// **'Sur la table : {count} dés annoncés.'**
  String revealOnTable(int count);

  /// No description provided for @revealTableHoldsBreath.
  ///
  /// In fr, this message translates to:
  /// **'Tout le monde retient son souffle…'**
  String get revealTableHoldsBreath;

  /// No description provided for @revealCountInOpen.
  ///
  /// In fr, this message translates to:
  /// **'Révélons les dés…'**
  String get revealCountInOpen;

  /// No description provided for @revealCapYou.
  ///
  /// In fr, this message translates to:
  /// **'Tu as déjà cinq dés, le maximum. Tu ne peux pas en gagner un de plus.'**
  String get revealCapYou;

  /// No description provided for @revealCapPlayer.
  ///
  /// In fr, this message translates to:
  /// **'{name} a déjà cinq dés, le maximum. Impossible d\'en gagner un de plus.'**
  String revealCapPlayer(String name);

  /// No description provided for @revealWinYou.
  ///
  /// In fr, this message translates to:
  /// **'Tu gagnes un dé.'**
  String get revealWinYou;

  /// No description provided for @revealWinPlayer.
  ///
  /// In fr, this message translates to:
  /// **'{name} gagne un dé.'**
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
  /// **' Tu as encore {count, plural, =1{{count} dé} other{{count} dés}}.'**
  String revealYouRemaining(int count);

  /// No description provided for @revealPlayerRemaining.
  ///
  /// In fr, this message translates to:
  /// **' {name} a encore {count, plural, =1{{count} dé} other{{count} dés}}.'**
  String revealPlayerRemaining(String name, int count);

  /// No description provided for @revealYouSunk.
  ///
  /// In fr, this message translates to:
  /// **' Par-dessus bord !'**
  String get revealYouSunk;

  /// No description provided for @revealPlayerSunk.
  ///
  /// In fr, this message translates to:
  /// **' Plus de dés : hors jeu.'**
  String get revealPlayerSunk;

  /// No description provided for @revealNoLoser.
  ///
  /// In fr, this message translates to:
  /// **'Personne ne perd de dé cette manche.'**
  String get revealNoLoser;

  /// No description provided for @revealNextRound.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get revealNextRound;

  /// No description provided for @revealSeeMore.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir le verdict'**
  String get revealSeeMore;

  /// No description provided for @revealRoleBidder.
  ///
  /// In fr, this message translates to:
  /// **'a annoncé le pari'**
  String get revealRoleBidder;

  /// No description provided for @revealRoleCaller.
  ///
  /// In fr, this message translates to:
  /// **'a contesté le pari'**
  String get revealRoleCaller;

  /// No description provided for @revealRoleWaiter.
  ///
  /// In fr, this message translates to:
  /// **'a attendu'**
  String get revealRoleWaiter;

  /// No description provided for @overWonSection.
  ///
  /// In fr, this message translates to:
  /// **'Tu as gagné'**
  String get overWonSection;

  /// No description provided for @overLostSection.
  ///
  /// In fr, this message translates to:
  /// **'Partie perdue'**
  String get overLostSection;

  /// No description provided for @overWonTitle.
  ///
  /// In fr, this message translates to:
  /// **'VICTOIRE'**
  String get overWonTitle;

  /// No description provided for @overLostTitle.
  ///
  /// In fr, this message translates to:
  /// **'TU ES ÉLIMINÉ'**
  String get overLostTitle;

  /// No description provided for @overWonBody.
  ///
  /// In fr, this message translates to:
  /// **'L\'équipage a baissé pavillon. La dernière chope est pour toi.'**
  String get overWonBody;

  /// No description provided for @overLostBody.
  ///
  /// In fr, this message translates to:
  /// **'Les pirates t\'ont éliminé. {name} remporte la taverne.'**
  String overLostBody(String name);

  /// No description provided for @overStatRounds.
  ///
  /// In fr, this message translates to:
  /// **'manches jouées'**
  String get overStatRounds;

  /// No description provided for @overStatDiceLeft.
  ///
  /// In fr, this message translates to:
  /// **'dés encore en jeu'**
  String get overStatDiceLeft;

  /// No description provided for @overLastWord.
  ///
  /// In fr, this message translates to:
  /// **'LE DERNIER MOT'**
  String get overLastWord;

  /// No description provided for @overRematch.
  ///
  /// In fr, this message translates to:
  /// **'Remettre ça'**
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
  /// **'{count, plural, =1{{count} dé restant} other{{count} dés restants}}'**
  String overStandingDice(int count);

  /// No description provided for @journalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique de la partie'**
  String get journalTitle;

  /// No description provided for @journalSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Les paris, les dudos et les calzas de chaque manche.'**
  String get journalSubtitle;

  /// No description provided for @journalRoundBadge.
  ///
  /// In fr, this message translates to:
  /// **'Manche {round}'**
  String journalRoundBadge(int round);

  /// No description provided for @journalEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune action pour l\'instant. Les paris apparaîtront ici.'**
  String get journalEmpty;

  /// No description provided for @journalRoundWords.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{{count} parole} other{{count} paroles}}'**
  String journalRoundWords(int count);

  /// No description provided for @journalClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
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
  /// **'{name} a crié Calza.'**
  String journalSaidCalza(String name);

  /// No description provided for @seatOutStatus.
  ///
  /// In fr, this message translates to:
  /// **'Éliminé'**
  String get seatOutStatus;

  /// No description provided for @seatYourTurn.
  ///
  /// In fr, this message translates to:
  /// **'à toi'**
  String get seatYourTurn;

  /// No description provided for @seatThinking.
  ///
  /// In fr, this message translates to:
  /// **'prépare son coup'**
  String get seatThinking;

  /// No description provided for @seatPlaying.
  ///
  /// In fr, this message translates to:
  /// **'en lice'**
  String get seatPlaying;

  /// No description provided for @seatSemantics.
  ///
  /// In fr, this message translates to:
  /// **'{name}, encore {count, plural, =1{{count} dé} other{{count} dés}}, {status}'**
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
  /// **'pacos sans pouvoir'**
  String get trayAcesPlain;

  /// No description provided for @trayAcesWild.
  ///
  /// In fr, this message translates to:
  /// **'pacos maîtres des faces'**
  String get trayAcesWild;

  /// No description provided for @traySemantics.
  ///
  /// In fr, this message translates to:
  /// **'Tes dés : {hand}'**
  String traySemantics(String hand);

  /// No description provided for @palificoSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Manche palifico : une seule face imposée, les pacos ne sont pas jokers.'**
  String get palificoSemantics;

  /// No description provided for @salonBackToTavern.
  ///
  /// In fr, this message translates to:
  /// **'Rentrer au port'**
  String get salonBackToTavern;

  /// No description provided for @salonHeader.
  ///
  /// In fr, this message translates to:
  /// **'MULTIJOUEUR'**
  String get salonHeader;

  /// No description provided for @salonHomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Joue avec tes amis'**
  String get salonHomeTitle;

  /// No description provided for @salonHomeHint.
  ///
  /// In fr, this message translates to:
  /// **'Un code, six caractères, et vous voilà à la même table. L\'hôte complète l\'équipage avec des pirates IA.'**
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
  /// **'Retour au port'**
  String get salonBack;

  /// No description provided for @salonCreateHeader.
  ///
  /// In fr, this message translates to:
  /// **'CRÉER UN SALON'**
  String get salonCreateHeader;

  /// No description provided for @salonCreateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tu hisses le pavillon'**
  String get salonCreateTitle;

  /// No description provided for @salonCreateHint.
  ///
  /// In fr, this message translates to:
  /// **'Choisis ton nom de flibustier et combien de forbans IA rejoindront ton équipage.'**
  String get salonCreateHint;

  /// No description provided for @salonNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ton nom de flibustier'**
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
  /// **'La Vigie'**
  String get salonDefaultName;

  /// No description provided for @salonCreateFailed.
  ///
  /// In fr, this message translates to:
  /// **'La taverne n\'a pas ouvert ses portes. Réessaie dans un moment.'**
  String get salonCreateFailed;

  /// No description provided for @salonJoinHeader.
  ///
  /// In fr, this message translates to:
  /// **'REJOINDRE UN SALON'**
  String get salonJoinHeader;

  /// No description provided for @salonJoinTitle.
  ///
  /// In fr, this message translates to:
  /// **'Entre le code du salon'**
  String get salonJoinTitle;

  /// No description provided for @salonJoinHint.
  ///
  /// In fr, this message translates to:
  /// **'Entre le code du capitaine, puis choisis le nom sous lequel tu embarques.'**
  String get salonJoinHint;

  /// No description provided for @salonCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code du salon'**
  String get salonCodeLabel;

  /// No description provided for @salonPasteHint.
  ///
  /// In fr, this message translates to:
  /// **'Tu as trouvé une bouteille à la mer. Elle contient un code : entre-le pour rejoindre le navire.'**
  String get salonPasteHint;

  /// No description provided for @salonJoinNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ton nom de pirate'**
  String get salonJoinNameLabel;

  /// No description provided for @salonJoinSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre le salon'**
  String get salonJoinSubmit;

  /// No description provided for @salonJoinFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de rejoindre ce salon. Vérifie le code et réessaie.'**
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
  /// **'Tu tiens la barre de ce salon'**
  String get salonHostRole;

  /// No description provided for @salonGuestRole.
  ///
  /// In fr, this message translates to:
  /// **'Matelot à bord'**
  String get salonGuestRole;

  /// No description provided for @salonCopySemantic.
  ///
  /// In fr, this message translates to:
  /// **'Mettre le code en bouteille'**
  String get salonCopySemantic;

  /// No description provided for @salonCopied.
  ///
  /// In fr, this message translates to:
  /// **'Le code est dans ta bouteille.'**
  String get salonCopied;

  /// No description provided for @salonStartRound.
  ///
  /// In fr, this message translates to:
  /// **'Démarrer la partie'**
  String get salonStartRound;

  /// No description provided for @salonRoundPreparing.
  ///
  /// In fr, this message translates to:
  /// **'L\'équipage prend place…'**
  String get salonRoundPreparing;

  /// No description provided for @salonWaitingHost.
  ///
  /// In fr, this message translates to:
  /// **'L\'équipage attend le signal du capitaine…'**
  String get salonWaitingHost;

  /// No description provided for @salonRejoinTable.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre ta place à la table'**
  String get salonRejoinTable;

  /// No description provided for @salonSpectatorHint.
  ///
  /// In fr, this message translates to:
  /// **'Tu regardes la partie — tu joueras la prochaine.'**
  String get salonSpectatorHint;

  /// No description provided for @salonHostGoneHint.
  ///
  /// In fr, this message translates to:
  /// **'L\'hôte a quitté la manche. La partie reprendra à son retour.'**
  String get salonHostGoneHint;

  /// No description provided for @salonFeedSection.
  ///
  /// In fr, this message translates to:
  /// **'Le journal de bord'**
  String get salonFeedSection;

  /// No description provided for @salonStartFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de lancer la manche. Vérifie ta connexion et réessaie.'**
  String get salonStartFailed;

  /// No description provided for @salonShareSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Partager le code'**
  String get salonShareSemantic;

  /// No description provided for @salonShareSmsSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le code par SMS'**
  String get salonShareSmsSemantic;

  /// No description provided for @salonShareMailSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le code par mail'**
  String get salonShareMailSemantic;

  /// No description provided for @salonShareWhatsappSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le code sur WhatsApp'**
  String get salonShareWhatsappSemantic;

  /// No description provided for @salonShareHint.
  ///
  /// In fr, this message translates to:
  /// **'Fais passer le code à l\'équipage, ou copie-le pour le glisser où tu veux.'**
  String get salonShareHint;

  /// No description provided for @salonPlayersCount.
  ///
  /// In fr, this message translates to:
  /// **'Joueurs ({count})'**
  String salonPlayersCount(int count);

  /// No description provided for @salonBotBadge.
  ///
  /// In fr, this message translates to:
  /// **'PIRATE IA'**
  String get salonBotBadge;

  /// No description provided for @salonRemoveBotSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Retirer ce pirate IA'**
  String get salonRemoveBotSemantic;

  /// No description provided for @salonAddBotSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un pirate IA'**
  String get salonAddBotSemantic;

  /// No description provided for @salonBotDifficultyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Niveau des pirates IA'**
  String get salonBotDifficultyTitle;

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
  /// **'Tu largues les amarres et retournes à l\'accueil.'**
  String get salonLeaveBody;

  /// No description provided for @salonLeaveStay.
  ///
  /// In fr, this message translates to:
  /// **'Rester'**
  String get salonLeaveStay;

  /// No description provided for @salonLeaveQuit.
  ///
  /// In fr, this message translates to:
  /// **'Quitter le salon'**
  String get salonLeaveQuit;

  /// No description provided for @reactionHeader.
  ///
  /// In fr, this message translates to:
  /// **'RÉACTIONS'**
  String get reactionHeader;

  /// No description provided for @speakHeader.
  ///
  /// In fr, this message translates to:
  /// **'FAIS PORTER TA VOIX'**
  String get speakHeader;

  /// No description provided for @reactionTargetSummary.
  ///
  /// In fr, this message translates to:
  /// **'Je vise {player} — {n} dés en cale.'**
  String reactionTargetSummary(String player, int n);

  /// No description provided for @reactionLine1.
  ///
  /// In fr, this message translates to:
  /// **'Tu n\'es pas obligé de me croire, mais j\'ai {count, plural, =1{un dé} other{{count} dés}} de {face}.'**
  String reactionLine1(int count, String face);

  /// No description provided for @reactionLine1Paco.
  ///
  /// In fr, this message translates to:
  /// **'Tu n\'es pas obligé de me croire, mais j\'ai {count, plural, =1{un paco} other{{count} pacos}}.'**
  String reactionLine1Paco(int count);

  /// No description provided for @reactionLine2.
  ///
  /// In fr, this message translates to:
  /// **'Alors non, {player}, c\'est pas possible.'**
  String reactionLine2(String player);

  /// No description provided for @reactionLine3.
  ///
  /// In fr, this message translates to:
  /// **'Ce paco va t\'envoyer par-dessus bord, {player}.'**
  String reactionLine3(String player);

  /// No description provided for @reactionLine4.
  ///
  /// In fr, this message translates to:
  /// **'Parole de flibustier : pas plus de {n} dés. Ce pari est du vent.'**
  String reactionLine4(int n);

  /// No description provided for @reactionLine5.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai {n} dés, {player}. Ton pari ne tiendra pas.'**
  String reactionLine5(int n, String player);

  /// No description provided for @reactionLine6.
  ///
  /// In fr, this message translates to:
  /// **'Paco à bâbord, paco à tribord !'**
  String get reactionLine6;

  /// No description provided for @reactionLine7.
  ///
  /// In fr, this message translates to:
  /// **'Je t\'ai cru, {player}. Bien joué, tu m\'as eu.'**
  String reactionLine7(String player);

  /// No description provided for @reactionDicePrompt.
  ///
  /// In fr, this message translates to:
  /// **'Choisis ta fable'**
  String get reactionDicePrompt;

  /// No description provided for @reactionDiceCountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Combien de dés ?'**
  String get reactionDiceCountLabel;

  /// No description provided for @reactionDiceFaceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Quel symbole ?'**
  String get reactionDiceFaceLabel;

  /// No description provided for @reactionDiceSend.
  ///
  /// In fr, this message translates to:
  /// **'Larguer la phrase'**
  String get reactionDiceSend;

  /// No description provided for @reactionFreeHint.
  ///
  /// In fr, this message translates to:
  /// **'Faire passer un mot à l\'équipage…'**
  String get reactionFreeHint;

  /// No description provided for @rulesHeader.
  ///
  /// In fr, this message translates to:
  /// **'RÈGLES DU JEU'**
  String get rulesHeader;

  /// No description provided for @rulesBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get rulesBack;

  /// No description provided for @rulesHeroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Les règles du Perudo'**
  String get rulesHeroTitle;

  /// No description provided for @rulesHeroIntro.
  ///
  /// In fr, this message translates to:
  /// **'Peu importe le nom : les dés restent muets et les pirates racontent des histoires.'**
  String get rulesHeroIntro;

  /// No description provided for @rulesShowcaseCaption.
  ///
  /// In fr, this message translates to:
  /// **'Cinq dés, un paco joker, et le bluff au cœur de la partie.'**
  String get rulesShowcaseCaption;

  /// No description provided for @rulesGoalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ta mission'**
  String get rulesGoalTitle;

  /// No description provided for @rulesGoalBody.
  ///
  /// In fr, this message translates to:
  /// **'Garde au moins un dé jusqu\'à la fin. À chaque manche, pariez sur les dés cachés. Qui se trompe en perd un.'**
  String get rulesGoalBody;

  /// No description provided for @rulesCupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton gobelet'**
  String get rulesCupTitle;

  /// No description provided for @rulesCupBody.
  ///
  /// In fr, this message translates to:
  /// **'Chaque pirate reçoit cinq dés et les cache sous son gobelet. Tu ne vois que les tiens.'**
  String get rulesCupBody;

  /// No description provided for @rulesPacoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Les pacos sont des jokers'**
  String get rulesPacoTitle;

  /// No description provided for @rulesPacoBody.
  ///
  /// In fr, this message translates to:
  /// **'Un paco (1) compte comme n\'importe quelle face, sauf quand le pari porte sur les pacos : il ne compte alors que comme un paco. Pour passer d\'une face normale aux pacos, il faut au moins la moitié des dés annoncés, arrondie au supérieur. Pour quitter les pacos, il faut doubler la quantité et ajouter un dé.'**
  String get rulesPacoBody;

  /// No description provided for @rulesBidTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annoncer un pari'**
  String get rulesBidTitle;

  /// No description provided for @rulesBidBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu annonces combien de dés montrent quelle face.'**
  String get rulesBidBody;

  /// No description provided for @rulesBidQuote.
  ///
  /// In fr, this message translates to:
  /// **'« Quatre cinq, ou plus, se cachent sous les gobelets. »'**
  String get rulesBidQuote;

  /// No description provided for @rulesBidExplain.
  ///
  /// In fr, this message translates to:
  /// **'Le pirate mise sa parole sur quatre dés de 5 ou plus. Les pacos peuvent compléter le compte.'**
  String get rulesBidExplain;

  /// No description provided for @rulesBidOpeningNote.
  ///
  /// In fr, this message translates to:
  /// **'Hors palifico, on ne peut pas ouvrir une manche avec des pacos.'**
  String get rulesBidOpeningNote;

  /// No description provided for @rulesRaiseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Faire monter le pari'**
  String get rulesRaiseTitle;

  /// No description provided for @rulesRaiseIntro.
  ///
  /// In fr, this message translates to:
  /// **'Chaque nouveau pari doit dépasser le précédent :'**
  String get rulesRaiseIntro;

  /// No description provided for @rulesRaiseSameFace.
  ///
  /// In fr, this message translates to:
  /// **'Garde la face, fais monter le nombre : 4 dés de 5 → 5 dés de 5.'**
  String get rulesRaiseSameFace;

  /// No description provided for @rulesRaiseHigherFace.
  ///
  /// In fr, this message translates to:
  /// **'Garder la quantité et choisir une face plus haute : 4 dés de 5 → 4 dés de 6.'**
  String get rulesRaiseHigherFace;

  /// No description provided for @rulesRaiseTowardPaco.
  ///
  /// In fr, this message translates to:
  /// **'Cap sur les pacos : annonce au moins la moitié des dés, arrondie au supérieur : 4 dés de 5 → 2 pacos.'**
  String get rulesRaiseTowardPaco;

  /// No description provided for @rulesRaiseFromPaco.
  ///
  /// In fr, this message translates to:
  /// **'Depuis les pacos, double et ajoute un dé : 2 pacos → 5 dés, face au choix.'**
  String get rulesRaiseFromPaco;

  /// No description provided for @rulesConvert45.
  ///
  /// In fr, this message translates to:
  /// **'4 dés de 5'**
  String get rulesConvert45;

  /// No description provided for @rulesConvert2Paco.
  ///
  /// In fr, this message translates to:
  /// **'2 pacos'**
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
  /// **'3 pacos'**
  String get rulesConvert3Paco;

  /// No description provided for @rulesDudoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dudo !'**
  String get rulesDudoTitle;

  /// No description provided for @rulesDudoBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu cries Dudo et mets le dernier pari à l\'épreuve : tous les gobelets se lèvent, puis on compte.'**
  String get rulesDudoBody;

  /// No description provided for @rulesDudoHoldsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le pari tient'**
  String get rulesDudoHoldsTitle;

  /// No description provided for @rulesDudoHoldsBody.
  ///
  /// In fr, this message translates to:
  /// **'Celui qui a contesté le pari perd un dé.'**
  String get rulesDudoHoldsBody;

  /// No description provided for @rulesDudoWrongTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le pari ne tient pas'**
  String get rulesDudoWrongTitle;

  /// No description provided for @rulesDudoWrongBody.
  ///
  /// In fr, this message translates to:
  /// **'Le joueur qui a lancé le pari perd un dé.'**
  String get rulesDudoWrongBody;

  /// No description provided for @rulesCalzaTitle.
  ///
  /// In fr, this message translates to:
  /// **'La calza, à toi de choisir'**
  String get rulesCalzaTitle;

  /// No description provided for @rulesCalzaBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu peux annoncer que le nombre de dés correspond exactement au pari : c\'est une calza.'**
  String get rulesCalzaBody;

  /// No description provided for @rulesCalzaAllOrNothing.
  ///
  /// In fr, this message translates to:
  /// **'Un dé gagné ou perdu'**
  String get rulesCalzaAllOrNothing;

  /// No description provided for @rulesCalzaAllOrNothingBody.
  ///
  /// In fr, this message translates to:
  /// **'Si le compte est exact, tu gagnes un dé, jusqu\'à cinq. Sinon, tu en perds un. La calza peut être désactivée avant la partie.'**
  String get rulesCalzaAllOrNothingBody;

  /// No description provided for @rulesEndTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dernier pirate debout'**
  String get rulesEndTitle;

  /// No description provided for @rulesEndBody.
  ///
  /// In fr, this message translates to:
  /// **'Plus de dés ? Par-dessus bord ! Le dernier pirate à flot gagne la taverne ; le perdant de la manche ouvre la suivante.'**
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
  /// **'Face choisie au premier pari'**
  String get rulesPalificoFaceTitle;

  /// No description provided for @rulesPalificoFaceBody.
  ///
  /// In fr, this message translates to:
  /// **'Le premier pari fixe la face et annonce deux dés ou plus. Ensuite, impossible de changer de cap : seule la quantité monte.'**
  String get rulesPalificoFaceBody;

  /// No description provided for @rulesPalificoPacoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Les pacos ne sont pas jokers'**
  String get rulesPalificoPacoTitle;

  /// No description provided for @rulesPalificoPacoBody.
  ///
  /// In fr, this message translates to:
  /// **'En palifico, le paco perd son pouvoir de joker : il ne vaut que pour lui-même.'**
  String get rulesPalificoPacoBody;

  /// No description provided for @rulesPalificoOnceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le palifico dure une manche'**
  String get rulesPalificoOnceTitle;

  /// No description provided for @rulesPalificoOnceBody.
  ///
  /// In fr, this message translates to:
  /// **'Le palifico ne dure qu\'une manche. Ensuite, les règles normales reprennent, même si un pirate n\'a qu\'un dé. Si un pirate tombe à un dé plus tard, un nouveau palifico commence.'**
  String get rulesPalificoOnceBody;

  /// No description provided for @rulesTipQuote.
  ///
  /// In fr, this message translates to:
  /// **'Le meilleur bluff est celui que personne n\'ose contester.'**
  String get rulesTipQuote;

  /// No description provided for @rulesUnderstood.
  ///
  /// In fr, this message translates to:
  /// **'Compris'**
  String get rulesUnderstood;

  /// No description provided for @diceHiddenText.
  ///
  /// In fr, this message translates to:
  /// **'Dé sous le gobelet'**
  String get diceHiddenText;

  /// No description provided for @diceAceText.
  ///
  /// In fr, this message translates to:
  /// **'Le paco, maître des faces'**
  String get diceAceText;

  /// No description provided for @diceValueText.
  ///
  /// In fr, this message translates to:
  /// **'Le dé affiche {value}'**
  String diceValueText(int value);

  /// No description provided for @bidAcesLabel.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 paco} other{{count} pacos}}'**
  String bidAcesLabel(int count);

  /// No description provided for @bidPlainLabel.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{{count} dé de {face}} other{{count} dés de {face}}}'**
  String bidPlainLabel(int count, int face);

  /// No description provided for @bidSpokenAces.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{au moins un paco} other{au moins {count} pacos}}'**
  String bidSpokenAces(int count);

  /// No description provided for @bidSpokenPlain.
  ///
  /// In fr, this message translates to:
  /// **'au moins {count, plural, =1{{count} dé} other{{count} dés}} montrant {face}'**
  String bidSpokenPlain(int count, int face);

  /// No description provided for @bidShortLabel.
  ///
  /// In fr, this message translates to:
  /// **'{quantity} × {mark}'**
  String bidShortLabel(int quantity, String mark);

  /// No description provided for @temperMousseLabel.
  ///
  /// In fr, this message translates to:
  /// **'P\'tit mousse'**
  String get temperMousseLabel;

  /// No description provided for @temperMousseBody.
  ///
  /// In fr, this message translates to:
  /// **'Un matelot craintif, qui mord facilement à l\'hameçon.'**
  String get temperMousseBody;

  /// No description provided for @temperFlibustierLabel.
  ///
  /// In fr, this message translates to:
  /// **'Corsaire'**
  String get temperFlibustierLabel;

  /// No description provided for @temperFlibustierBody.
  ///
  /// In fr, this message translates to:
  /// **'Un adversaire équilibré, qui repère les bluffs.'**
  String get temperFlibustierBody;

  /// No description provided for @temperCapitaineLabel.
  ///
  /// In fr, this message translates to:
  /// **'Capitaine'**
  String get temperCapitaineLabel;

  /// No description provided for @temperCapitaineBody.
  ///
  /// In fr, this message translates to:
  /// **'Il calcule les probabilités et déteste perdre.'**
  String get temperCapitaineBody;

  /// No description provided for @systemPhoneSlept.
  ///
  /// In fr, this message translates to:
  /// **'Le téléphone sort de veille. Reconnexion au salon…'**
  String get systemPhoneSlept;

  /// No description provided for @systemQuietCut.
  ///
  /// In fr, this message translates to:
  /// **'Le salon ne répond plus. Je rétablis la connexion…'**
  String get systemQuietCut;

  /// No description provided for @systemCreated.
  ///
  /// In fr, this message translates to:
  /// **'Ton salon est prêt : {code}.'**
  String systemCreated(String code);

  /// No description provided for @systemConnected.
  ///
  /// In fr, this message translates to:
  /// **'À bord du salon {code} !'**
  String systemConnected(String code);

  /// No description provided for @systemRecovered.
  ///
  /// In fr, this message translates to:
  /// **'Tu es de retour dans le salon {code}.'**
  String systemRecovered(String code);

  /// No description provided for @systemClosed.
  ///
  /// In fr, this message translates to:
  /// **'La taverne ferme ses portes : {reason}.'**
  String systemClosed(String reason);

  /// No description provided for @systemLost.
  ///
  /// In fr, this message translates to:
  /// **'Connexion interrompue{detail}. Nouvelle tentative…'**
  String systemLost(String detail);

  /// No description provided for @systemUnreachableTrack.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de joindre le salon : {reason}. Je réessaie.'**
  String systemUnreachableTrack(String reason);

  /// No description provided for @systemUnreachableBackoff.
  ///
  /// In fr, this message translates to:
  /// **'Le salon reste inaccessible : {brief}. Je réessaierai après un délai plus long.'**
  String systemUnreachableBackoff(String brief);

  /// No description provided for @systemSalonRefused.
  ///
  /// In fr, this message translates to:
  /// **'Le salon refuse ton retour : {reason}. Il a peut-être fermé — quitte le salon puis réessaie ou crée-en un autre.'**
  String systemSalonRefused(String reason);

  /// No description provided for @systemThrottledCreate.
  ///
  /// In fr, this message translates to:
  /// **'Trop de demandes de création. Réessaie dans {seconds} s.'**
  String systemThrottledCreate(int seconds);

  /// No description provided for @systemCreateFailed.
  ///
  /// In fr, this message translates to:
  /// **'Le salon n\'a pas pu être créé.{detail}'**
  String systemCreateFailed(String detail);

  /// No description provided for @systemChatRate.
  ///
  /// In fr, this message translates to:
  /// **'Doucement sur les messages, matelot. Attends {seconds} s.'**
  String systemChatRate(int seconds);

  /// No description provided for @systemDeadReaction.
  ///
  /// In fr, this message translates to:
  /// **'Tu es déconnecté du salon. Ta réaction n\'a pas été envoyée.'**
  String get systemDeadReaction;

  /// No description provided for @systemDeadChat.
  ///
  /// In fr, this message translates to:
  /// **'Tu es déconnecté du salon. Ton message n\'a pas été envoyé.'**
  String get systemDeadChat;

  /// No description provided for @systemHostGone.
  ///
  /// In fr, this message translates to:
  /// **'L\'hôte est déconnecté. La table attend son retour…'**
  String get systemHostGone;

  /// No description provided for @systemNoServerReply.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur n\'a pas répondu après 8 s. Je réessaie.'**
  String get systemNoServerReply;

  /// No description provided for @systemNetworkResponse.
  ///
  /// In fr, this message translates to:
  /// **'Le réseau répond {status} : {body}.'**
  String systemNetworkResponse(String status, String body);

  /// No description provided for @systemNetworkProbeFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de vérifier la connexion ({error}). Je réessaie.'**
  String systemNetworkProbeFailed(String error);

  /// No description provided for @systemSixChars.
  ///
  /// In fr, this message translates to:
  /// **'Il faut un code de six caractères pour monter à bord.'**
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

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

  @override
  String get commonCancel => 'Annuler';

  @override
  String get setupBack => 'Retour';

  @override
  String get setupTitle => 'NOUVELLE PARTIE';

  @override
  String get setupCrewTitle => 'L\'équipage';

  @override
  String get setupCrewHint =>
      'Choisis combien de pirates vont te mentir ce soir.';

  @override
  String get setupBotTemperTitle => 'Le tempérament des bots';

  @override
  String get setupStart => 'Larguer les amarres';

  @override
  String get setupRulesLink => 'Relire les règles';

  @override
  String get setupTableLabel => 'PIRATES À TA TABLE';

  @override
  String setupPlayersCount(int count) {
    return '$count joueurs';
  }

  @override
  String get setupRemovePirate => 'Retirer un pirate';

  @override
  String get setupAddPirate => 'Ajouter un pirate';

  @override
  String get setupSeatAtTable => 'à table';

  @override
  String get setupSeatAbsent => 'absent';

  @override
  String setupCrewSummary(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pirates',
      one: '1 pirate',
    );
    return 'Toi + $_temp0 : $names';
  }

  @override
  String get setupCalzaTitle => 'Calza autorisée';

  @override
  String get setupCalzaHint =>
      'Annoncer le compte exact rapporte un dé. Optionnel, mais féroce.';

  @override
  String get gameQuitTable => 'Quitter la partie';

  @override
  String gameRound(int round) {
    return 'MANCHE $round';
  }

  @override
  String gameDiceInPlay(int count) {
    return '$count dés en jeu';
  }

  @override
  String get gameOpenJournal => 'Ouvrir le journal de la table';

  @override
  String get gameOpenPrompt => 'Ouvre les hostilités.';

  @override
  String get gameYourTurnPrompt => 'À toi de parler.';

  @override
  String get gameCalzaAsk => 'CALZA ?';

  @override
  String get gameDudoCall => 'Dudo !';

  @override
  String get gameRaise => 'Surenchérir';

  @override
  String get gameOpenBid => 'Ouvrir';

  @override
  String gameBotThinking(String name) {
    return '$name réfléchit';
  }

  @override
  String get gameTableListens => 'la table écoute';

  @override
  String get gameLiftCupPrompt => 'Soulève ton gobelet.';

  @override
  String get gameTableHoldsBreath => 'La table retient son souffle.';

  @override
  String get gameBidInvalid => 'Ce pari n\'est plus valable.';

  @override
  String get gameDudoConfirmTitle => 'Dudo ?';

  @override
  String get gameAccusedYou => 'tu as menti';

  @override
  String gameAccusedPlayer(String name) {
    return '$name ment';
  }

  @override
  String gameDudoConfirmBody(String accused, String bid) {
    return 'Tu penses que $accused sur « $bid ». Si le pari tient, tu perds un dé.';
  }

  @override
  String get gameDudoConfirm => 'DUDO !';

  @override
  String get gameCalzaConfirmTitle => 'Calza ?';

  @override
  String get gameFacePaco => 'paco';

  @override
  String gameWordDiceOfFace(int face) {
    return 'dés de $face';
  }

  @override
  String gameCalzaConfirmBody(int count, String faceWord) {
    return 'Tu penses qu\'il y a exactement $count $faceWord sur la table. Compte exact : tu gagnes un dé. Sinon, tu en perds un.';
  }

  @override
  String get gameCalzaConfirm => 'CALZA';

  @override
  String get gameQuitTitle => 'Quitter la table ?';

  @override
  String get gameQuitBody =>
      'La partie en cours sera perdue. Les pirates ne se souviendront pas de toi.';

  @override
  String get gameQuitStay => 'Rester';

  @override
  String get gameQuitLeave => 'Quitter';

  @override
  String get bidOpenHostilities => 'Ouvrir les hostilités';

  @override
  String get bidRaiseSection => 'Ta surenchère';

  @override
  String get bidRaisePrompt => 'À toi de surenchérir.';

  @override
  String get bidLastBid => 'Dernier pari : ';

  @override
  String get bidPalificoFaceLabel => 'FACE IMPOSÉE';

  @override
  String get bidFaceLabel => 'FACE';

  @override
  String bidSummaryAces(int count) {
    return 'Je parie qu\'il y a au moins $count as sur la table.';
  }

  @override
  String bidSummary(int count, String faceWord) {
    return 'Je parie qu\'il y a au moins $count $faceWord sur la table.';
  }

  @override
  String bidFaceWord(int quantity, int face) {
    String _temp0 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 'dés',
      one: 'dé',
    );
    return '$_temp0 de $face';
  }

  @override
  String get bidPalificoFaceHint => 'Face imposée : manche palifico.';

  @override
  String get bidPalificoOpenHint =>
      'Palifico : la face ouverte vaut pour toute la manche.';

  @override
  String get bidAcesOnlyHint => 'Seuls les paco comptent.';

  @override
  String get bidPacoWildHint => 'Les paco comptent pour cette face.';

  @override
  String get bidAnnounce => 'Annoncer';

  @override
  String get bidIllegalRaise => 'Ce montant n\'est pas une surenchère valable.';

  @override
  String get bidDecreaseQty => 'Diminuer la quantité';

  @override
  String get bidIncreaseQty => 'Augmenter la quantité';

  @override
  String get bidUnitPaco => 'paco';

  @override
  String bidUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dés',
      one: 'dé',
    );
    return '$_temp0';
  }

  @override
  String bidRange(int min, int max) {
    return '$min à $max';
  }

  @override
  String get bidAceSemantics => 'Paco, joker';

  @override
  String bidFaceSemantics(int face) {
    return 'Valeur $face';
  }

  @override
  String cardEmptySemantics(String name) {
    return 'Aucun pari. $name ouvre les hostilités.';
  }

  @override
  String cardFilledSemantics(String spoken, String bidder, int total) {
    return 'Pari en cours : $spoken, annoncé par $bidder. $total dés en jeu.';
  }

  @override
  String get cardFilledTitle => 'PARI EN COURS';

  @override
  String get cardDiceUnit => 'DÉS';

  @override
  String get cardPalificoHint => 'Manche palifico : les paco ne comptent pas';

  @override
  String get cardAcesOnlyHint => 'Seuls les paco comptent';

  @override
  String get cardPacoWildHint => 'Les paco comptent pour cette face';

  @override
  String cardDiceCount(int count) {
    return '$count dés';
  }

  @override
  String get cardTableWaits => 'LA TABLE ATTEND';

  @override
  String get cardYouOpen => 'À toi d\'ouvrir';

  @override
  String cardPlayerOpens(String name) {
    return '$name ouvre';
  }

  @override
  String cardDiceOnTable(int count) {
    return '$count dés sur la table';
  }

  @override
  String peekRound(int round) {
    return 'Manche $round';
  }

  @override
  String get peekCupTitle => 'Ton gobelet';

  @override
  String get peekSecretHint =>
      'Garde ce secret. Le reste de la table ne voit rien.';

  @override
  String get peekShakeHint =>
      'Secoue le téléphone comme au vrai comptoir : le cuir se soulève, et toi seul vois tes dés.';

  @override
  String get peekPalificoHint =>
      'Manche palifico : une seule face pour tous les paris.';

  @override
  String peekDiceInHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés en main',
      one: '$count dé en main',
    );
    return '$_temp0';
  }

  @override
  String get peekPacoNone => 'pas de paco';

  @override
  String peekPacoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paco',
      one: '1 paco',
    );
    return '$_temp0';
  }

  @override
  String get peekPalificoWildHint =>
      'Manche palifico : les paco ne comptent que comme paco.';

  @override
  String get peekWildHint => 'Les paco comptent pour toutes les faces.';

  @override
  String peekPlayerOpens(String name) {
    return 'C’est à $name d’ouvrir';
  }

  @override
  String get peekLiftCupSemantics => 'Soulever le gobelet pour voir tes dés';

  @override
  String get peekShakeButton => 'Secoue le téléphone pour brasser tes dés';

  @override
  String get peekTapCupHint => '… ou touche le gobelet pour le soulever';

  @override
  String get peekTakeTimeHint =>
      'Prends ton temps. Les autres pirates attendent.';

  @override
  String revealDudoLine(String caller, String bidder) {
    return '$caller a douté de $bidder.';
  }

  @override
  String revealCalzaLine(String caller) {
    return '$caller a annoncé le compte exact.';
  }

  @override
  String get revealBidHeld => 'Le pari tenait.';

  @override
  String get revealLiar => 'Mensonge !';

  @override
  String get revealExactCount => 'Compte exact.';

  @override
  String get revealMissed => 'Raté.';

  @override
  String revealAnnouncedBy(String name) {
    return 'Annoncé par $name';
  }

  @override
  String get revealFacePaco => 'paco';

  @override
  String revealWordDiceOfFace(int face) {
    return 'dés de $face';
  }

  @override
  String revealOnTable(int count) {
    return 'sur la table · $count annoncés';
  }

  @override
  String get revealTableHoldsBreath => 'La table retient son souffle…';

  @override
  String get revealCountInOpen => 'Le compte est sous les yeux de tous…';

  @override
  String get revealCapYou =>
      'Tu avais déjà cinq dés. Le compte exact est noté, mais rien à reprendre.';

  @override
  String revealCapPlayer(String name) {
    return '$name avait déjà cinq dés. Le compte exact est noté, mais rien à reprendre.';
  }

  @override
  String get revealWinYou => 'Compte exact : tu reprends un dé.';

  @override
  String revealWinPlayer(String name) {
    return '$name reprend un dé.';
  }

  @override
  String get revealYouLoseDie => 'Tu perds un dé.';

  @override
  String revealPlayerLoseDie(String name) {
    return '$name perd un dé.';
  }

  @override
  String revealYouRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés',
      one: '$count dé',
    );
    return ' Il te reste $_temp0.';
  }

  @override
  String revealPlayerRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés',
      one: '$count dé',
    );
    return ' Il lui reste $_temp0.';
  }

  @override
  String get revealYouSunk => ' Tu es à l\'eau.';

  @override
  String get revealPlayerSunk => ' Il est à l\'eau.';

  @override
  String get revealNoLoser => 'La manche se termine sans perdant.';

  @override
  String get revealNextRound => 'Manche suivante';

  @override
  String get revealSeeMore => 'Voir la suite';

  @override
  String get revealRoleBidder => 'a parié';

  @override
  String get revealRoleCaller => 'a douté';

  @override
  String get revealRoleWaiter => 'a attendu';

  @override
  String get overWonSection => 'La taverne est à toi';

  @override
  String get overLostSection => 'Fin de l\'aventure';

  @override
  String get overWonTitle => 'TU RÈGNES';

  @override
  String get overLostTitle => 'PAR-DESSUS BORD';

  @override
  String get overWonBody =>
      'L\'équipage a rendu les armes. La dernière chope est pour toi.';

  @override
  String overLostBody(String name) {
    return 'Les pirates t\'ont eu. $name garde la main sur le tonneau.';
  }

  @override
  String get overStatRounds => 'manches';

  @override
  String get overStatDiceLeft => 'dés restants';

  @override
  String get overLastWord => 'LE DERNIER MOT';

  @override
  String get overRematch => 'Rejouer';

  @override
  String get overStandingOut => 'à l\'eau';

  @override
  String get overBackToTavern => 'Retour à la taverne';

  @override
  String overStandingDice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés',
      one: '$count dé',
    );
    return '$_temp0';
  }

  @override
  String get journalTitle => 'Journal de la table';

  @override
  String get journalSubtitle => 'Tout ce qui s\'est dit.';

  @override
  String journalRoundBadge(int round) {
    return 'Manche $round';
  }

  @override
  String get journalEmpty =>
      'Le journal est encore vierge. Les paris vont pleuvoir.';

  @override
  String journalRoundWords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paroles',
      one: '$count parole',
    );
    return '$_temp0';
  }

  @override
  String get journalClose => 'Fermer le journal';

  @override
  String journalSaidBid(String name, String bid) {
    return '$name a annoncé $bid.';
  }

  @override
  String journalSaidDudo(String name) {
    return '$name a dit dudo.';
  }

  @override
  String journalSaidCalza(String name) {
    return '$name a demandé calza.';
  }

  @override
  String get seatOutStatus => 'À l\'eau';

  @override
  String get seatYourTurn => 'à toi';

  @override
  String get seatThinking => 'réfléchit';

  @override
  String get seatPlaying => 'en jeu';

  @override
  String seatSemantics(String name, int count, String status) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés restants',
      one: '$count dé restant',
    );
    return '$name, $_temp0, $status';
  }

  @override
  String get trayTitle => 'Ta main';

  @override
  String trayDiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés',
      one: '$count dé',
    );
    return '$_temp0';
  }

  @override
  String get trayAcesPlain => 'paco simples';

  @override
  String get trayAcesWild => 'paco joker';

  @override
  String traySemantics(String hand) {
    return 'Ta main : $hand';
  }

  @override
  String get palificoSemantics =>
      'Manche palifico : une seule face imposée, paco non jokers';
}

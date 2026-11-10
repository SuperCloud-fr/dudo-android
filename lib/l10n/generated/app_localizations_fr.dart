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
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

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

  @override
  String get salonBackToTavern => 'Retour à la taverne';

  @override
  String get salonHeader => 'MULTIJOUEUR';

  @override
  String get salonHomeTitle => 'Un salon, cinq gobelets';

  @override
  String get salonHomeHint =>
      'Les amis entrent avec un code à six caractères. L\'hôte distribue les pirates IA, le salon communique en direct.';

  @override
  String get salonCreateCta => 'Créer un salon';

  @override
  String get salonJoinCta => 'Rejoindre un salon';

  @override
  String get salonBack => 'Retour';

  @override
  String get salonCreateHeader => 'CRÉER UN SALON';

  @override
  String get salonCreateTitle => 'Tu arrives premier';

  @override
  String get salonCreateHint =>
      'Choisis ton matelot et combien de pirates IA viendront mentir avec toi.';

  @override
  String get salonNameLabel => 'Ton nom de pirate';

  @override
  String get salonBotsSection => 'Pirates IA';

  @override
  String get salonCreateSubmit => 'Créer le salon';

  @override
  String get salonDefaultName => 'Barman';

  @override
  String get salonCreateFailed => 'La création du salon a échoué.';

  @override
  String get salonJoinHeader => 'REJOINDRE UN SALON';

  @override
  String get salonJoinTitle => 'Le code fait foi';

  @override
  String get salonJoinHint =>
      'Entre les six caractères que l\'hôte t\'a envoyés. Sur le salon, ton nom est tout ce que tu peux changer.';

  @override
  String get salonCodeLabel => 'Code du salon';

  @override
  String get salonPasteHint =>
      'Rentrer en frais — via SMS, mail, WhatsApp, Signal ou n\'importe où ailleurs, c\'est juste mieux.';

  @override
  String get salonJoinNameLabel => 'Ton nom (tu peux encore le changer)';

  @override
  String get salonJoinSubmit => 'Rejoindre';

  @override
  String get salonJoinFailed => 'Salon injoignable pour l\'instant.';

  @override
  String get salonLeaveSemantic => 'Quitter le salon';

  @override
  String salonCodeHeader(String code) {
    return 'SALON $code';
  }

  @override
  String get salonHostRole => 'Tu reines sur ce salon';

  @override
  String get salonGuestRole => 'Invité de l\'hôte';

  @override
  String get salonCopySemantic => 'Copier le code';

  @override
  String get salonCopied => 'Code copié dans le presse-papier.';

  @override
  String get salonStartRound => 'Lancer la manche';

  @override
  String get salonRoundPreparing => 'La manche se prépare…';

  @override
  String get salonWaitingHost => 'En attente que l\'hôte lance la manche…';

  @override
  String get salonFeedSection => 'Le fil du salon';

  @override
  String get salonStartFailed => 'La manche n\'a pas pu démarrer. Réessaie.';

  @override
  String get salonShareSemantic => 'Partager le code';

  @override
  String get salonShareSmsSemantic => 'Envoyer par SMS';

  @override
  String get salonShareMailSemantic => 'Envoyer par mail';

  @override
  String get salonShareWhatsappSemantic => 'Envoyer sur WhatsApp';

  @override
  String get salonShareHint =>
      'WhatsApp, Signal, SMS, mail : chaque app ouvre les bons liens, sinon copie.';

  @override
  String salonPlayersCount(int count) {
    return 'À table ($count)';
  }

  @override
  String get salonBotBadge => 'IA';

  @override
  String get salonRemoveBotSemantic => 'Retirer un pirate IA';

  @override
  String get salonAddBotSemantic => 'Ajouter un pirate IA';

  @override
  String get salonYouSuffix => '(toi)';

  @override
  String get salonHostBadge => 'HÔTE';

  @override
  String get salonLeaveTitle => 'Quitter le salon ?';

  @override
  String get salonLeaveBody =>
      'Le code deviendra inutilisable pour cette partie.';

  @override
  String get salonLeaveStay => 'Rester';

  @override
  String get salonLeaveQuit => 'Quitter';

  @override
  String get reactionHeader => 'RÉAGIR';

  @override
  String get speakHeader => 'PARLE';

  @override
  String reactionTargetSummary(String player, int n) {
    return '$player · mes dés : $n';
  }

  @override
  String reactionLine1(int n) {
    return 'Tu n\'es pas obligé de me croire, mais j\'ai $n dés.';
  }

  @override
  String reactionLine2(String player) {
    return 'Alors non, $player, c\'est pas possible.';
  }

  @override
  String reactionLine3(String player) {
    return 'Le paco, c\'est ta fin, $player.';
  }

  @override
  String reactionLine4(int n) {
    return 'Je te promets : au plus $n dés sur la table, ils mentent.';
  }

  @override
  String reactionLine5(int n, String player) {
    return 'Regarde mes $n dés, $player, tu es à l\'eau d\'ici ce soir.';
  }

  @override
  String get reactionLine6 => 'Paco sur paco paco paco.';

  @override
  String reactionLine7(String player) {
    return 'Je te crois, $player, te voilà bien détrompé.';
  }

  @override
  String get reactionFreeHint => 'Écrire un message libre…';

  @override
  String get rulesHeader => 'LES RÈGLES';

  @override
  String get rulesBack => 'Retour';

  @override
  String get rulesHeroTitle => 'Le jeu du mensonge';

  @override
  String get rulesHeroIntro =>
      'Perudo, Dudo, Cacho… peu importe le nom. Les dés ne mentent pas. Les pirates, si.';

  @override
  String get rulesShowcaseCaption =>
      'Cinq dés, un paco joker, et aucune raison de dire la vérité.';

  @override
  String get rulesGoalTitle => 'Le but';

  @override
  String get rulesGoalBody =>
      'Rester le dernier pirate avec au moins un dé. Chaque manche, on parie sur ce que cachent les gobelets. Celui qui se trompe perd un dé.';

  @override
  String get rulesCupTitle => 'Ton gobelet';

  @override
  String get rulesCupBody =>
      'Chacun reçoit cinq dés et les cache sous son gobelet. Tu regardes les tiens en secret.';

  @override
  String get rulesPacoTitle => 'Les paco sont jokers';

  @override
  String get rulesPacoBody =>
      'Un paco (1) compte pour n\'importe quelle face. Il ne compte que comme un paco quand le pari porte sur les paco. Un paco vaut donc deux dés normaux au moment de surenchérir.';

  @override
  String get rulesBidTitle => 'Le pari';

  @override
  String get rulesBidBody =>
      'Un pari a deux nombres : une quantité et une face.';

  @override
  String get rulesBidQuote => '« Il y a au moins 4 dés de 5 sur la table. »';

  @override
  String get rulesBidExplain =>
      'Ici, le pirate affirme qu\'il y a au moins quatre dés de valeur 5 sur toute la table. Les paco comptent aussi.';

  @override
  String get rulesRaiseTitle => 'Surenchérir';

  @override
  String get rulesRaiseIntro =>
      'Le pari suivant doit toujours être plus fort :';

  @override
  String get rulesRaiseSameFace =>
      'Plus de dés sur la même face : 4 dés de 5 → 5 dés de 5.';

  @override
  String get rulesRaiseHigherFace =>
      'Même nombre, face plus haute : 4 dés de 5 → 4 dés de 6.';

  @override
  String get rulesRaiseTowardPaco =>
      'Vers les paco : au moins la moitié, arrondie au-dessus : 4 dés de 5 → 2 paco.';

  @override
  String get rulesRaiseFromPaco =>
      'Depuis les paco : le double plus un : 2 paco → 5 dés de n\'importe quelle face.';

  @override
  String get rulesConvert45 => '4 dés de 5';

  @override
  String get rulesConvert2Paco => '2 paco';

  @override
  String get rulesConvert5F2 => '5 dés de 2';

  @override
  String get rulesConvert5F6 => '5 dés de 6';

  @override
  String get rulesConvert3Paco => '3 paco';

  @override
  String get rulesDudoTitle => 'Dudo !';

  @override
  String get rulesDudoBody =>
      'Au lieu de surenchérir, tu peux douter du dernier pari. Tout le monde soulève son gobelet et on compte.';

  @override
  String get rulesDudoHoldsTitle => 'Le pari tient';

  @override
  String get rulesDudoHoldsBody => 'Le douteur perd un dé.';

  @override
  String get rulesDudoWrongTitle => 'Le pari est faux';

  @override
  String get rulesDudoWrongBody => 'Le parieur perd un dé.';

  @override
  String get rulesCalzaTitle => 'Calza — optionnel';

  @override
  String get rulesCalzaBody =>
      'Tu peux aussi annoncer que le compte est exactement bon. C\'est la calza.';

  @override
  String get rulesCalzaAllOrNothing => 'Tout ou rien';

  @override
  String get rulesCalzaAllOrNothingBody =>
      'Compte exact : tu gagnes un dé (cinq maximum). Compte faux : tu en perds un. La calza peut être désactivée avant la partie.';

  @override
  String get rulesEndTitle => 'La fin';

  @override
  String get rulesEndBody =>
      'Un pirate qui perd son dernier dé est à l\'eau. Le dernier survivant gagne la taverne. Le perdant de la manche ouvre la suivante.';

  @override
  String get rulesPalificoTitle => 'Palifico';

  @override
  String get rulesPalificoBody =>
      'Le pirate qui perd son avant-dernier dé déclenche le palifico : la manche suivante se joue entièrement sur une seule face, imposée par l\'ouverture.';

  @override
  String get rulesPalificoFaceTitle => 'Face imposée';

  @override
  String get rulesPalificoFaceBody =>
      'Le premier pari choisit la face et ouvre à deux dés minimum. Tous les suivants montent la quantité de cette même face ; impossible de changer de valeur.';

  @override
  String get rulesPalificoPacoTitle => 'Paco sans joker';

  @override
  String get rulesPalificoPacoBody =>
      'Pendant le palifico, les paco ne comptent que comme paco : plus de joker.';

  @override
  String get rulesPalificoOnceTitle => 'Une seule manche';

  @override
  String get rulesPalificoOnceBody =>
      'À la manche d\'après, les enchères reprennent la forme normale, même si le pirate reste à un dé. Et si quelqu\'un rechute à un dé plus tard, le palifico se déclenche à nouveau.';

  @override
  String get rulesTipQuote =>
      'Le meilleur bluff est celui que personne n\'a envie de payer.';

  @override
  String get rulesUnderstood => 'J\'ai compris';

  @override
  String get diceHiddenText => 'Dé caché';

  @override
  String get diceAceText => 'As, joker';

  @override
  String diceValueText(int value) {
    return 'Dé de valeur $value';
  }

  @override
  String bidAcesLabel(int count) {
    return '$count paco';
  }

  @override
  String bidPlainLabel(int count, int face) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés de $face',
      one: '$count dé de $face',
    );
    return '$_temp0';
  }

  @override
  String bidSpokenAces(int count) {
    return 'au moins $count paco';
  }

  @override
  String bidSpokenPlain(int count, int face) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés',
      one: '$count dé',
    );
    return 'au moins $_temp0 de valeur $face';
  }

  @override
  String bidShortLabel(int quantity, String mark) {
    return '$quantity×$mark';
  }

  @override
  String get temperMousseLabel => 'Mousse';

  @override
  String get temperMousseBody => 'Timide, prudent, facile à bluffer.';

  @override
  String get temperFlibustierLabel => 'Flibustier';

  @override
  String get temperFlibustierBody =>
      'Un adversaire honnête, qui sait sentir le mensonge.';

  @override
  String get temperCapitaineLabel => 'Capitaine';

  @override
  String get temperCapitaineBody =>
      'Calcule les probabilités et n\'aime pas perdre.';

  @override
  String get systemPhoneSlept =>
      'Le téléphone a mis le salon en sommeil — reconnexion…';

  @override
  String get systemQuietCut =>
      'Le salon ne répond plus — je coupe la connexion desséchée et je reprends…';

  @override
  String systemCreated(String code) {
    return 'Salon créé. Code : $code';
  }

  @override
  String systemConnected(String code) {
    return 'Connecté au salon $code';
  }

  @override
  String systemRecovered(String code) {
    return 'Reconnecté au salon $code.';
  }

  @override
  String systemClosed(String reason) {
    return 'Salon fermé : $reason';
  }

  @override
  String systemLost(String detail) {
    return 'Connexion perdue$detail — tentative de reconnexion…';
  }

  @override
  String systemUnreachableTrack(String reason) {
    return 'Salon injoignable — $reason Je continue d\'essayer.';
  }

  @override
  String systemUnreachableBackoff(String brief) {
    return 'Salon injoignable — $brief. Je continue d\'essayer en doublant le délai.';
  }

  @override
  String systemThrottledCreate(int seconds) {
    return 'Trop de demandes de création — réessaie dans ~$seconds s.';
  }

  @override
  String systemCreateFailed(String detail) {
    return 'Impossible de créer un salon pour l\'instant.$detail';
  }

  @override
  String systemChatRate(int seconds) {
    return 'Débit du salon atteint — attends ${seconds}s.';
  }

  @override
  String get systemDeadReaction =>
      'La connexion au salon est lâchée — la réaction ne peut pas partir.';

  @override
  String get systemDeadChat =>
      'La connexion au salon est lâchée — le message ne peut pas partir.';

  @override
  String get systemSixChars => 'Le code doit faire six caractères.';
}

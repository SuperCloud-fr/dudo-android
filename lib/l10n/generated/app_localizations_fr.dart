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
  String get homeTavernSection => 'La taverne du dernier pirate';

  @override
  String get homeTagline => 'Cinq dés. Un gobelet. À toi de bluffer.';

  @override
  String get homeSubtitle =>
      'Le Perudo en version pirate : affronte un équipage rusé.';

  @override
  String get ctaPlay => 'Jouer en solo';

  @override
  String get ctaSalons => 'Salons multijoueurs';

  @override
  String get ctaHowTo => 'Comment jouer ?';

  @override
  String get ctaSettings => 'Paramètres';

  @override
  String get homeVersionBadge => '2 à 6 joueurs';

  @override
  String get settingsTitle => 'PARAMÈTRES';

  @override
  String get settingsAmbienceTitle => 'L\'ambiance';

  @override
  String get settingsAmbienceHint =>
      'Choisis une ambiance : les règles restent les mêmes, seule la lumière change.';

  @override
  String get lookChosen => 'Sélectionnée';

  @override
  String get lookPick => 'Choisir cette ambiance';

  @override
  String get settingsPrivacyPolicy => 'Lire la politique de confidentialité';

  @override
  String get commonCancel => 'Annuler l\'action';

  @override
  String get setupBack => 'Retour à l\'accueil';

  @override
  String get setupTitle => 'NOUVELLE PARTIE';

  @override
  String get setupCrewTitle => 'Qui monte à bord ?';

  @override
  String get setupCrewHint => 'Choisis combien de pirates IA t\'affronteront.';

  @override
  String get setupBotTemperTitle => 'Le caractère de l\'équipage';

  @override
  String get setupStart => 'Commencer la partie';

  @override
  String get setupRulesLink => 'Relire les règles';

  @override
  String get setupTableLabel => 'QUI EMBARQUE ?';

  @override
  String setupPlayersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pirates à bord',
      one: '1 pirate à bord',
    );
    return '$_temp0';
  }

  @override
  String get setupRemovePirate => 'Retirer ce pirate';

  @override
  String get setupAddPirate => 'Ajouter un pirate';

  @override
  String get setupSeatAtTable => 'présent';

  @override
  String get setupSeatAbsent => 'au repos';

  @override
  String setupCrewSummary(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pirates',
      one: '1 pirate',
    );
    return 'À bord : toi et $_temp0 — $names';
  }

  @override
  String get setupCalzaTitle => 'Calza autorisée';

  @override
  String get setupCalzaHint =>
      'Annonce le compte exact pour gagner un dé (cinq maximum). Cette règle est facultative.';

  @override
  String get gameQuitTable => 'Quitter la table';

  @override
  String gameRound(int round) {
    return 'MANCHE $round';
  }

  @override
  String gameDiceInPlay(int count) {
    return '$count dés en jeu';
  }

  @override
  String get gameOpenJournal => 'Consulter le journal de bord';

  @override
  String get gameOpenSalonChat => 'Ouvrir le chat du salon';

  @override
  String get gameOpenPrompt => 'À toi de faire le premier pari.';

  @override
  String get gameYourTurnPrompt => 'À toi de jouer.';

  @override
  String get gameCalzaAsk => 'CALZA ?';

  @override
  String get gameDudoCall => 'Dudo !';

  @override
  String get gameRaise => 'Surenchérir';

  @override
  String get gameOpenBid => 'Ouvrir les hostilités';

  @override
  String gameBotThinking(String name) {
    return '$name prépare son coup…';
  }

  @override
  String get gameTableListens => 'Tout le bord retient son souffle.';

  @override
  String get gameLiftCupPrompt => 'Soulève ton gobelet pour révéler les dés.';

  @override
  String get gameTableHoldsBreath => 'La table retient son souffle.';

  @override
  String get gameBidInvalid =>
      'Ce pari n\'est plus valable. Choisis-en un autre.';

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
    return 'Tu contestes l\'affirmation suivante : $accused sur « $bid ». Si le compte atteint le pari, tu perds un dé.';
  }

  @override
  String get gameDudoConfirm => 'Confirmer le Dudo';

  @override
  String get gameCalzaConfirmTitle => 'Compte exact ?';

  @override
  String get gameFacePaco => 'paco';

  @override
  String gameWordDiceOfFace(int face) {
    return 'dés de $face';
  }

  @override
  String gameCalzaConfirmBody(String bid) {
    return 'Tu annonces $bid. Si le compte est exact, tu gagnes un dé (cinq maximum). Sinon, tu en perds un.';
  }

  @override
  String get gameCalzaConfirm => 'Confirmer la calza';

  @override
  String get gameQuitTitle => 'Abandonner la partie ?';

  @override
  String get gameQuitBody =>
      'La partie s\'arrêtera et ne pourra pas être reprise.';

  @override
  String get gameQuitStay => 'Continuer la partie';

  @override
  String get gameQuitLeave => 'Quitter la partie';

  @override
  String get bidOpenHostilities => 'Le premier coup de canon';

  @override
  String get bidRaiseSection => 'À toi de faire monter le pari';

  @override
  String get bidRaisePrompt => 'À toi de surenchérir.';

  @override
  String get bidLastBid => 'Pari précédent : ';

  @override
  String get bidPalificoFaceLabel => 'FACE IMPOSÉE';

  @override
  String get bidFaceLabel => 'FACE';

  @override
  String bidSummaryAces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pacos',
      one: 'un paco',
    );
    return 'Il y a au moins $_temp0 sur la table.';
  }

  @override
  String bidSummary(int count, String faceWord) {
    return 'Il y a au moins $count $faceWord sur la table.';
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
  String get bidPalificoFaceHint => 'En palifico, la face est imposée.';

  @override
  String get bidPalificoOpenHint =>
      'En palifico, la face du premier pari s\'applique toute la manche.';

  @override
  String get bidAcesOnlyHint => 'Seuls les pacos comptent.';

  @override
  String get bidPacoWildHint => 'Les pacos comptent pour cette face.';

  @override
  String get bidAnnounce => 'Annoncer';

  @override
  String get bidIllegalRaise =>
      'Ce pari ne respecte pas les règles de surenchère. Essaie une autre combinaison.';

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
  String get bidAceSemantics => 'Paco, face 1 et joker';

  @override
  String bidFaceSemantics(int face) {
    return 'Le dé montre $face';
  }

  @override
  String cardEmptySemantics(String name) {
    return 'La table est vierge. $name lance le premier pari.';
  }

  @override
  String cardFilledSemantics(String spoken, String bidder, int total) {
    return '$bidder a annoncé $spoken. Il y a $total dés en jeu.';
  }

  @override
  String get cardFilledTitle => 'PARI EN COURS';

  @override
  String get cardDiceUnit => 'DÉS EN JEU';

  @override
  String get cardPalificoHint => 'En palifico, les pacos ne sont pas jokers.';

  @override
  String get cardAcesOnlyHint => 'Seuls les pacos comptent.';

  @override
  String get cardPacoWildHint => 'Les pacos comptent comme cette face.';

  @override
  String cardDiceCount(int count) {
    return '$count dés en jeu';
  }

  @override
  String get cardTableWaits => 'TOUT LE BORD RETIENT SON SOUFFLE';

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
  String get peekCupTitle => 'Tes dés';

  @override
  String get peekSecretHint =>
      'Garde ce secret. Le reste de la table ne voit rien.';

  @override
  String get peekShakeHint =>
      'Secoue le téléphone pour lancer tes dés. Toi seul peux les voir.';

  @override
  String get peekPalificoHint =>
      'En palifico, tous les paris portent sur la même face.';

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
      other: '$count pacos',
      one: '1 paco',
    );
    return '$_temp0';
  }

  @override
  String get peekPalificoWildHint =>
      'En palifico, les pacos ne valent que comme pacos.';

  @override
  String get peekWildHint => 'Les pacos comptent pour toutes les faces.';

  @override
  String peekPlayerOpens(String name) {
    return 'C’est à $name d’ouvrir';
  }

  @override
  String get peekOnlyHostStarts =>
      'Le capitaine lance la manche ; en attendant, jette un œil à tes dés.';

  @override
  String get peekLiftCupSemantics => 'Soulever le gobelet pour voir tes dés';

  @override
  String get peekShakeButton => 'Secouer pour lancer les dés';

  @override
  String get peekTapCupHint => '… ou touche le gobelet pour le soulever';

  @override
  String get peekTakeTimeHint => 'Prends ton temps : les autres attendent.';

  @override
  String get peekSpectatorTitle => 'Par-dessus bord';

  @override
  String get peekSpectatorBody =>
      'Plus de dés pour toi : regarde l\'équipage poursuivre la manche et prépare ta revanche.';

  @override
  String get peekSpectatorCta => 'Regarder la manche';

  @override
  String get peekSpectatorWait => 'En attente du signal du capitaine…';

  @override
  String revealDudoLine(String caller, String bidder) {
    return '$caller a contesté le pari de $bidder.';
  }

  @override
  String revealCalzaLine(String caller) {
    return '$caller a tenté une calza.';
  }

  @override
  String get revealBidHeld => 'Le pari tenait.';

  @override
  String get revealLiar => 'Mensonge !';

  @override
  String get revealExactCount => 'Compte exact, matelot !';

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
    return 'Sur la table : $count dés annoncés.';
  }

  @override
  String get revealTableHoldsBreath => 'Tout le monde retient son souffle…';

  @override
  String get revealCountInOpen => 'Révélons les dés…';

  @override
  String get revealCapYou =>
      'Tu as déjà cinq dés, le maximum. Tu ne peux pas en gagner un de plus.';

  @override
  String revealCapPlayer(String name) {
    return '$name a déjà cinq dés, le maximum. Impossible d\'en gagner un de plus.';
  }

  @override
  String get revealWinYou => 'Tu gagnes un dé.';

  @override
  String revealWinPlayer(String name) {
    return '$name gagne un dé.';
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
    return ' Tu as encore $_temp0.';
  }

  @override
  String revealPlayerRemaining(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés',
      one: '$count dé',
    );
    return ' $name a encore $_temp0.';
  }

  @override
  String get revealYouSunk => ' Par-dessus bord !';

  @override
  String get revealPlayerSunk => ' Plus de dés : hors jeu.';

  @override
  String get revealNoLoser => 'Personne ne perd de dé cette manche.';

  @override
  String get revealNextRound => 'Continuer';

  @override
  String get revealSeeMore => 'Découvrir le verdict';

  @override
  String get revealRoleBidder => 'a annoncé le pari';

  @override
  String get revealRoleCaller => 'a contesté le pari';

  @override
  String get revealRoleWaiter => 'a attendu';

  @override
  String get overWonSection => 'Tu as gagné';

  @override
  String get overLostSection => 'Partie perdue';

  @override
  String get overWonTitle => 'VICTOIRE';

  @override
  String get overLostTitle => 'TU ES ÉLIMINÉ';

  @override
  String get overWonBody =>
      'L\'équipage a baissé pavillon. La dernière chope est pour toi.';

  @override
  String overLostBody(String name) {
    return 'Les pirates t\'ont éliminé. $name remporte la taverne.';
  }

  @override
  String get overStatRounds => 'manches jouées';

  @override
  String get overStatDiceLeft => 'dés encore en jeu';

  @override
  String get overLastWord => 'LE DERNIER MOT';

  @override
  String get overRematch => 'Remettre ça';

  @override
  String get overStandingOut => 'à l\'eau';

  @override
  String get overBackToTavern => 'Retour à la taverne';

  @override
  String overStandingDice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés restants',
      one: '$count dé restant',
    );
    return '$_temp0';
  }

  @override
  String get journalTitle => 'Historique de la partie';

  @override
  String get journalSubtitle =>
      'Les paris, les dudos et les calzas de chaque manche.';

  @override
  String journalRoundBadge(int round) {
    return 'Manche $round';
  }

  @override
  String get journalEmpty =>
      'Aucune action pour l\'instant. Les paris apparaîtront ici.';

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
  String get journalClose => 'Fermer';

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
    return '$name a crié Calza.';
  }

  @override
  String get seatOutStatus => 'Éliminé';

  @override
  String get seatYourTurn => 'à toi';

  @override
  String get seatThinking => 'prépare son coup';

  @override
  String get seatPlaying => 'en lice';

  @override
  String seatSemantics(String name, int count, String status) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés',
      one: '$count dé',
    );
    return '$name, encore $_temp0, $status';
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
  String get trayAcesPlain => 'pacos sans pouvoir';

  @override
  String get trayAcesWild => 'pacos maîtres des faces';

  @override
  String traySemantics(String hand) {
    return 'Tes dés : $hand';
  }

  @override
  String get palificoSemantics =>
      'Manche palifico : une seule face imposée, les pacos ne sont pas jokers.';

  @override
  String get salonBackToTavern => 'Rentrer au port';

  @override
  String get salonHeader => 'MULTIJOUEUR';

  @override
  String get salonHomeTitle => 'Joue avec tes amis';

  @override
  String get salonHomeHint =>
      'Un code, six caractères, et vous voilà à la même table. L\'hôte complète l\'équipage avec des pirates IA.';

  @override
  String get salonCreateCta => 'Créer un salon';

  @override
  String get salonJoinCta => 'Rejoindre un salon';

  @override
  String get salonBack => 'Retour au port';

  @override
  String get salonCreateHeader => 'CRÉER UN SALON';

  @override
  String get salonCreateTitle => 'Tu hisses le pavillon';

  @override
  String get salonCreateHint =>
      'Choisis ton nom de flibustier et combien de forbans IA rejoindront ton équipage.';

  @override
  String get salonNameLabel => 'Ton nom de flibustier';

  @override
  String get salonBotsSection => 'Pirates IA';

  @override
  String get salonCreateSubmit => 'Créer le salon';

  @override
  String get salonDefaultName => 'La Vigie';

  @override
  String get salonCreateFailed =>
      'La taverne n\'a pas ouvert ses portes. Réessaie dans un moment.';

  @override
  String get salonJoinHeader => 'REJOINDRE UN SALON';

  @override
  String get salonJoinTitle => 'Entre le code du salon';

  @override
  String get salonJoinHint =>
      'Entre le code du capitaine, puis choisis le nom sous lequel tu embarques.';

  @override
  String get salonCodeLabel => 'Code du salon';

  @override
  String get salonPasteHint =>
      'Tu as trouvé une bouteille à la mer. Elle contient un code : entre-le pour rejoindre le navire.';

  @override
  String get salonJoinNameLabel => 'Ton nom de pirate';

  @override
  String get salonJoinSubmit => 'Rejoindre le salon';

  @override
  String get salonJoinFailed =>
      'Impossible de rejoindre ce salon. Vérifie le code et réessaie.';

  @override
  String get salonLeaveSemantic => 'Quitter le salon';

  @override
  String salonCodeHeader(String code) {
    return 'SALON $code';
  }

  @override
  String get salonHostRole => 'Tu tiens la barre de ce salon';

  @override
  String get salonGuestRole => 'Matelot à bord';

  @override
  String get salonCopySemantic => 'Mettre le code en bouteille';

  @override
  String get salonCopied => 'Le code est dans ta bouteille.';

  @override
  String get salonStartRound => 'Démarrer la partie';

  @override
  String get salonRoundPreparing => 'L\'équipage prend place…';

  @override
  String get salonWaitingHost => 'L\'équipage attend le signal du capitaine…';

  @override
  String get salonHostGoneHint =>
      'L\'hôte a quitté la manche. La partie reprendra à son retour.';

  @override
  String get salonFeedSection => 'Le journal de bord';

  @override
  String get salonStartFailed =>
      'Impossible de lancer la manche. Vérifie ta connexion et réessaie.';

  @override
  String get salonShareSemantic => 'Partager le code';

  @override
  String get salonShareSmsSemantic => 'Envoyer le code par SMS';

  @override
  String get salonShareMailSemantic => 'Envoyer le code par mail';

  @override
  String get salonShareWhatsappSemantic => 'Envoyer le code sur WhatsApp';

  @override
  String get salonShareHint =>
      'Fais passer le code à l\'équipage, ou copie-le pour le glisser où tu veux.';

  @override
  String salonPlayersCount(int count) {
    return 'Joueurs ($count)';
  }

  @override
  String get salonBotBadge => 'PIRATE IA';

  @override
  String get salonRemoveBotSemantic => 'Retirer ce pirate IA';

  @override
  String get salonAddBotSemantic => 'Ajouter un pirate IA';

  @override
  String get salonBotDifficultyTitle => 'Niveau des pirates IA';

  @override
  String get salonYouSuffix => '(toi)';

  @override
  String get salonHostBadge => 'HÔTE';

  @override
  String get salonLeaveTitle => 'Quitter le salon ?';

  @override
  String get salonLeaveBody =>
      'Tu largues les amarres et retournes à l\'accueil.';

  @override
  String get salonLeaveStay => 'Rester';

  @override
  String get salonLeaveQuit => 'Quitter le salon';

  @override
  String get reactionHeader => 'RÉACTIONS';

  @override
  String get speakHeader => 'FAIS PORTER TA VOIX';

  @override
  String reactionTargetSummary(String player, int n) {
    return 'Je vise $player — $n dés en cale.';
  }

  @override
  String reactionLine1(int count, String face) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés',
      one: 'un dé',
    );
    return 'Tu n\'es pas obligé de me croire, mais j\'ai $_temp0 de $face.';
  }

  @override
  String reactionLine2(String player) {
    return 'Alors non, $player, c\'est pas possible.';
  }

  @override
  String reactionLine3(String player) {
    return 'Ce paco va t\'envoyer par-dessus bord, $player.';
  }

  @override
  String reactionLine4(int n) {
    return 'Parole de flibustier : pas plus de $n dés. Ce pari est du vent.';
  }

  @override
  String reactionLine5(int n, String player) {
    return 'J\'ai $n dés, $player. Ton pari ne tiendra pas.';
  }

  @override
  String get reactionLine6 => 'Paco à bâbord, paco à tribord !';

  @override
  String reactionLine7(String player) {
    return 'Je t\'ai cru, $player. Bien joué, tu m\'as eu.';
  }

  @override
  String get reactionDicePrompt => 'Choisis ta fable';

  @override
  String get reactionDiceCountLabel => 'Combien de dés ?';

  @override
  String get reactionDiceFaceLabel => 'Quel symbole ?';

  @override
  String get reactionDiceSend => 'Larguer la phrase';

  @override
  String get reactionFreeHint => 'Faire passer un mot à l\'équipage…';

  @override
  String get rulesHeader => 'RÈGLES DU JEU';

  @override
  String get rulesBack => 'Retour à l\'accueil';

  @override
  String get rulesHeroTitle => 'Les règles du Perudo';

  @override
  String get rulesHeroIntro =>
      'Peu importe le nom : les dés restent muets et les pirates racontent des histoires.';

  @override
  String get rulesShowcaseCaption =>
      'Cinq dés, un paco joker, et le bluff au cœur de la partie.';

  @override
  String get rulesGoalTitle => 'Ta mission';

  @override
  String get rulesGoalBody =>
      'Garde au moins un dé jusqu\'à la fin. À chaque manche, pariez sur les dés cachés. Qui se trompe en perd un.';

  @override
  String get rulesCupTitle => 'Ton gobelet';

  @override
  String get rulesCupBody =>
      'Chaque pirate reçoit cinq dés et les cache sous son gobelet. Tu ne vois que les tiens.';

  @override
  String get rulesPacoTitle => 'Les pacos sont des jokers';

  @override
  String get rulesPacoBody =>
      'Un paco (1) compte comme n\'importe quelle face, sauf quand le pari porte sur les pacos : il ne compte alors que comme un paco. Pour passer d\'une face normale aux pacos, il faut au moins la moitié des dés annoncés, arrondie au supérieur. Pour quitter les pacos, il faut doubler la quantité et ajouter un dé.';

  @override
  String get rulesBidTitle => 'Annoncer un pari';

  @override
  String get rulesBidBody => 'Tu annonces combien de dés montrent quelle face.';

  @override
  String get rulesBidQuote =>
      '« Quatre cinq, ou plus, se cachent sous les gobelets. »';

  @override
  String get rulesBidExplain =>
      'Le pirate mise sa parole sur quatre dés de 5 ou plus. Les pacos peuvent compléter le compte.';

  @override
  String get rulesBidOpeningNote =>
      'Hors palifico, on ne peut pas ouvrir une manche avec des pacos.';

  @override
  String get rulesRaiseTitle => 'Faire monter le pari';

  @override
  String get rulesRaiseIntro =>
      'Chaque nouveau pari doit dépasser le précédent :';

  @override
  String get rulesRaiseSameFace =>
      'Garde la face, fais monter le nombre : 4 dés de 5 → 5 dés de 5.';

  @override
  String get rulesRaiseHigherFace =>
      'Garder la quantité et choisir une face plus haute : 4 dés de 5 → 4 dés de 6.';

  @override
  String get rulesRaiseTowardPaco =>
      'Cap sur les pacos : annonce au moins la moitié des dés, arrondie au supérieur : 4 dés de 5 → 2 pacos.';

  @override
  String get rulesRaiseFromPaco =>
      'Depuis les pacos, double et ajoute un dé : 2 pacos → 5 dés, face au choix.';

  @override
  String get rulesConvert45 => '4 dés de 5';

  @override
  String get rulesConvert2Paco => '2 pacos';

  @override
  String get rulesConvert5F2 => '5 dés de 2';

  @override
  String get rulesConvert5F6 => '5 dés de 6';

  @override
  String get rulesConvert3Paco => '3 pacos';

  @override
  String get rulesDudoTitle => 'Dudo !';

  @override
  String get rulesDudoBody =>
      'Tu cries Dudo et mets le dernier pari à l\'épreuve : tous les gobelets se lèvent, puis on compte.';

  @override
  String get rulesDudoHoldsTitle => 'Le pari tient';

  @override
  String get rulesDudoHoldsBody => 'Celui qui a contesté le pari perd un dé.';

  @override
  String get rulesDudoWrongTitle => 'Le pari ne tient pas';

  @override
  String get rulesDudoWrongBody => 'Le joueur qui a lancé le pari perd un dé.';

  @override
  String get rulesCalzaTitle => 'La calza, à toi de choisir';

  @override
  String get rulesCalzaBody =>
      'Tu peux annoncer que le nombre de dés correspond exactement au pari : c\'est une calza.';

  @override
  String get rulesCalzaAllOrNothing => 'Un dé gagné ou perdu';

  @override
  String get rulesCalzaAllOrNothingBody =>
      'Si le compte est exact, tu gagnes un dé, jusqu\'à cinq. Sinon, tu en perds un. La calza peut être désactivée avant la partie.';

  @override
  String get rulesEndTitle => 'Dernier pirate debout';

  @override
  String get rulesEndBody =>
      'Plus de dés ? Par-dessus bord ! Le dernier pirate à flot gagne la taverne ; le perdant de la manche ouvre la suivante.';

  @override
  String get rulesPalificoTitle => 'Palifico';

  @override
  String get rulesPalificoBody =>
      'Le pirate qui perd son avant-dernier dé déclenche le palifico : la manche suivante se joue entièrement sur une seule face, imposée par l\'ouverture.';

  @override
  String get rulesPalificoFaceTitle => 'Face choisie au premier pari';

  @override
  String get rulesPalificoFaceBody =>
      'Le premier pari fixe la face et annonce deux dés ou plus. Ensuite, impossible de changer de cap : seule la quantité monte.';

  @override
  String get rulesPalificoPacoTitle => 'Les pacos ne sont pas jokers';

  @override
  String get rulesPalificoPacoBody =>
      'En palifico, le paco perd son pouvoir de joker : il ne vaut que pour lui-même.';

  @override
  String get rulesPalificoOnceTitle => 'Le palifico dure une manche';

  @override
  String get rulesPalificoOnceBody =>
      'Le palifico ne dure qu\'une manche. Ensuite, les règles normales reprennent, même si un pirate n\'a qu\'un dé. Si un pirate tombe à un dé plus tard, un nouveau palifico commence.';

  @override
  String get rulesTipQuote =>
      'Le meilleur bluff est celui que personne n\'ose contester.';

  @override
  String get rulesUnderstood => 'Compris';

  @override
  String get diceHiddenText => 'Dé sous le gobelet';

  @override
  String get diceAceText => 'Le paco, maître des faces';

  @override
  String diceValueText(int value) {
    return 'Le dé affiche $value';
  }

  @override
  String bidAcesLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pacos',
      one: '1 paco',
    );
    return '$_temp0';
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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'au moins $count pacos',
      one: 'au moins un paco',
    );
    return '$_temp0';
  }

  @override
  String bidSpokenPlain(int count, int face) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dés',
      one: '$count dé',
    );
    return 'au moins $_temp0 montrant $face';
  }

  @override
  String bidShortLabel(int quantity, String mark) {
    return '$quantity × $mark';
  }

  @override
  String get temperMousseLabel => 'P\'tit mousse';

  @override
  String get temperMousseBody =>
      'Un matelot craintif, qui mord facilement à l\'hameçon.';

  @override
  String get temperFlibustierLabel => 'Corsaire';

  @override
  String get temperFlibustierBody =>
      'Un adversaire équilibré, qui repère les bluffs.';

  @override
  String get temperCapitaineLabel => 'Capitaine';

  @override
  String get temperCapitaineBody =>
      'Il calcule les probabilités et déteste perdre.';

  @override
  String get systemPhoneSlept =>
      'Le téléphone sort de veille. Reconnexion au salon…';

  @override
  String get systemQuietCut =>
      'Le salon ne répond plus. Je rétablis la connexion…';

  @override
  String systemCreated(String code) {
    return 'Ton salon est prêt : $code.';
  }

  @override
  String systemConnected(String code) {
    return 'À bord du salon $code !';
  }

  @override
  String systemRecovered(String code) {
    return 'Tu es de retour dans le salon $code.';
  }

  @override
  String systemClosed(String reason) {
    return 'La taverne ferme ses portes : $reason.';
  }

  @override
  String systemLost(String detail) {
    return 'Connexion interrompue$detail. Nouvelle tentative…';
  }

  @override
  String systemUnreachableTrack(String reason) {
    return 'Impossible de joindre le salon : $reason. Je réessaie.';
  }

  @override
  String systemUnreachableBackoff(String brief) {
    return 'Le salon reste inaccessible : $brief. Je réessaierai après un délai plus long.';
  }

  @override
  String systemThrottledCreate(int seconds) {
    return 'Trop de demandes de création. Réessaie dans $seconds s.';
  }

  @override
  String systemCreateFailed(String detail) {
    return 'Le salon n\'a pas pu être créé.$detail';
  }

  @override
  String systemChatRate(int seconds) {
    return 'Doucement sur les messages, matelot. Attends $seconds s.';
  }

  @override
  String get systemDeadReaction =>
      'Tu es déconnecté du salon. Ta réaction n\'a pas été envoyée.';

  @override
  String get systemDeadChat =>
      'Tu es déconnecté du salon. Ton message n\'a pas été envoyé.';

  @override
  String get systemHostGone =>
      'L\'hôte est déconnecté. La table attend son retour…';

  @override
  String get systemNoServerReply =>
      'Le serveur n\'a pas répondu après 8 s. Je réessaie.';

  @override
  String systemNetworkResponse(String status, String body) {
    return 'Le réseau répond $status : $body.';
  }

  @override
  String systemNetworkProbeFailed(String error) {
    return 'Impossible de vérifier la connexion ($error). Je réessaie.';
  }

  @override
  String get systemSixChars =>
      'Il faut un code de six caractères pour monter à bord.';
}

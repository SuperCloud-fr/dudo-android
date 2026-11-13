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
  String get homeTavernSection => 'Tavern of the Last Pirate';

  @override
  String get homeTagline => 'Five dice. One cup. Your turn to bluff.';

  @override
  String get homeSubtitle => 'Pirate Perudo: face a cunning crew.';

  @override
  String get ctaPlay => 'Play solo';

  @override
  String get ctaSalons => 'Multiplayer salons';

  @override
  String get ctaHowTo => 'How to play?';

  @override
  String get ctaSettings => 'Settings';

  @override
  String get homeVersionBadge => '2 to 6 players';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get settingsAmbienceTitle => 'The atmosphere';

  @override
  String get settingsAmbienceHint =>
      'Choose an ambience: the rules stay the same, only the lighting changes.';

  @override
  String get lookChosen => 'Selected';

  @override
  String get lookPick => 'Choose this ambience';

  @override
  String get settingsPrivacyPolicy => 'Read the privacy policy';

  @override
  String get commonCancel => 'Cancel action';

  @override
  String get setupBack => 'Back to home';

  @override
  String get setupTitle => 'NEW GAME';

  @override
  String get setupCrewTitle => 'Who comes aboard?';

  @override
  String get setupCrewHint => 'Choose how many AI pirates you\'ll face.';

  @override
  String get setupBotTemperTitle => 'The crew\'s character';

  @override
  String get setupStart => 'Start the game';

  @override
  String get setupRulesLink => 'Re-read the rules';

  @override
  String get setupTableLabel => 'WHO COMES ABOARD?';

  @override
  String setupPlayersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pirates aboard',
      one: '1 pirate aboard',
    );
    return '$_temp0';
  }

  @override
  String get setupRemovePirate => 'Remove this pirate';

  @override
  String get setupAddPirate => 'Add a pirate';

  @override
  String get setupSeatAtTable => 'at the table';

  @override
  String get setupSeatAbsent => 'resting';

  @override
  String setupCrewSummary(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pirates',
      one: '1 pirate',
    );
    return 'Aboard: you and $_temp0 — $names';
  }

  @override
  String get setupCalzaTitle => 'Calza allowed';

  @override
  String get setupCalzaHint =>
      'Call the exact count to gain a die (up to five). This rule is optional.';

  @override
  String get gameQuitTable => 'Leave the table';

  @override
  String gameRound(int round) {
    return 'ROUND $round';
  }

  @override
  String gameDiceInPlay(int count) {
    return '$count dice in play';
  }

  @override
  String get gameOpenJournal => 'Open the ship\'s log';

  @override
  String get gameOpenSalonChat => 'Open salon chat';

  @override
  String get gameOpenPrompt => 'You\'re up to make the first bid.';

  @override
  String get gameYourTurnPrompt => 'Your turn to play.';

  @override
  String get gameCalzaAsk => 'CALZA?';

  @override
  String get gameDudoCall => 'Dudo!';

  @override
  String get gameRaise => 'Raise the bid';

  @override
  String get gameOpenBid => 'Open hostilities';

  @override
  String gameBotThinking(String name) {
    return '$name is plotting…';
  }

  @override
  String get gameTableListens => 'The whole crew holds its breath.';

  @override
  String get gameLiftCupPrompt => 'Lift your cup to reveal the dice.';

  @override
  String get gameTableHoldsBreath => 'The table holds its breath.';

  @override
  String get gameBidInvalid => 'That bid is no longer valid. Choose another.';

  @override
  String get gameDudoConfirmTitle => 'Dudo?';

  @override
  String get gameAccusedYou => 'you lied';

  @override
  String gameAccusedPlayer(String name) {
    return '$name lies';
  }

  @override
  String gameDudoConfirmBody(String accused, String bid) {
    return 'You\'re challenging this claim: $accused about “$bid”. If the count meets the bid, you lose a die.';
  }

  @override
  String get gameDudoConfirm => 'Confirm Dudo';

  @override
  String get gameCalzaConfirmTitle => 'Exact count?';

  @override
  String get gameFacePaco => 'paco';

  @override
  String gameWordDiceOfFace(int face) {
    return 'dice of $face';
  }

  @override
  String gameCalzaConfirmBody(String bid) {
    return 'You announce $bid. If the count is exact, you gain a die (up to five). Otherwise, you lose one.';
  }

  @override
  String get gameCalzaConfirm => 'Confirm Calza';

  @override
  String get gameQuitTitle => 'Abandon the game?';

  @override
  String get gameQuitBody => 'The game will end and can\'t be resumed.';

  @override
  String get gameQuitGuestBody =>
      'A pirate will play your hand until the round ends. You can take your seat back from the tavern.';

  @override
  String get gameQuitStay => 'Continue the game';

  @override
  String get gameQuitLeave => 'Leave the game';

  @override
  String get bidOpenHostilities => 'The first cannon shot';

  @override
  String get bidRaiseSection => 'Your turn to raise the bid';

  @override
  String get bidRaisePrompt => 'Your turn to raise.';

  @override
  String get bidLastBid => 'Previous bid: ';

  @override
  String get bidPalificoFaceLabel => 'LOCKED FACE';

  @override
  String get bidFaceLabel => 'FACE';

  @override
  String bidSummaryAces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pacos',
      one: 'one paco',
    );
    return 'There are at least $_temp0 on the table.';
  }

  @override
  String bidSummary(int count, String faceWord) {
    return 'There are at least $count $faceWord on the table.';
  }

  @override
  String bidFaceWord(int quantity, int face) {
    String _temp0 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 'dice',
      one: 'die',
    );
    return '$_temp0 of $face';
  }

  @override
  String get bidPalificoFaceHint => 'In palifico, the face is locked.';

  @override
  String get bidPalificoOpenHint =>
      'In palifico, the first bid\'s face applies for the whole round.';

  @override
  String get bidAcesOnlyHint => 'Only pacos count.';

  @override
  String get bidPacoWildHint => 'Pacos count as wild for this face.';

  @override
  String get bidAnnounce => 'Call it';

  @override
  String get bidIllegalRaise =>
      'That bid doesn\'t follow the raising rules. Try another combination.';

  @override
  String get bidDecreaseQty => 'Decrease the quantity';

  @override
  String get bidIncreaseQty => 'Increase the quantity';

  @override
  String get bidUnitPaco => 'paco';

  @override
  String bidUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dice',
      one: 'die',
    );
    return '$_temp0';
  }

  @override
  String bidRange(int min, int max) {
    return '$min to $max';
  }

  @override
  String get bidAceSemantics => 'Paco, face 1 and wild';

  @override
  String bidFaceSemantics(int face) {
    return 'The die shows $face';
  }

  @override
  String cardEmptySemantics(String name) {
    return 'The table is clear. $name makes the first bid.';
  }

  @override
  String cardFilledSemantics(String spoken, String bidder, int total) {
    return '$bidder bid $spoken. $total dice in play.';
  }

  @override
  String get cardFilledTitle => 'BID ON THE TABLE';

  @override
  String get cardDiceUnit => 'DICE IN PLAY';

  @override
  String get cardPalificoHint => 'In palifico, pacos aren\'t wild.';

  @override
  String get cardAcesOnlyHint => 'Only pacos count.';

  @override
  String get cardPacoWildHint => 'Pacos count as this face.';

  @override
  String cardDiceCount(int count) {
    return '$count dice in play';
  }

  @override
  String get cardTableWaits => 'THE WHOLE CREW HOLDS ITS BREATH';

  @override
  String get cardYouOpen => 'Your opening';

  @override
  String cardPlayerOpens(String name) {
    return '$name opens';
  }

  @override
  String cardDiceOnTable(int count) {
    return '$count dice on the table';
  }

  @override
  String peekRound(int round) {
    return 'Round $round';
  }

  @override
  String get peekCupTitle => 'Your dice';

  @override
  String get peekSecretHint =>
      'Keep that secret. The rest of the table sees nothing.';

  @override
  String get peekShakeHint =>
      'Shake your phone to roll your dice. Only you can see them.';

  @override
  String get peekPalificoHint => 'In palifico, every bid uses the same face.';

  @override
  String peekDiceInHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dice in hand',
      one: '$count die in hand',
    );
    return '$_temp0';
  }

  @override
  String get peekPacoNone => 'no paco';

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
  String get peekPalificoWildHint => 'In palifico, pacos count only as pacos.';

  @override
  String get peekWildHint => 'Pacos count as wild for every face.';

  @override
  String peekPlayerOpens(String name) {
    return 'It’s $name’s turn to open';
  }

  @override
  String get peekOnlyHostStarts =>
      'The captain starts the round; while you wait, take a look at your dice.';

  @override
  String get peekLiftCupSemantics => 'Lift the cup to see your dice';

  @override
  String get peekShakeButton => 'Shake to roll the dice';

  @override
  String get peekTapCupHint => '… or tap the cup to lift it';

  @override
  String get peekTakeTimeHint => 'Take your time; the others are waiting.';

  @override
  String get peekSpectatorTitle => 'Overboard';

  @override
  String get peekSpectatorBody =>
      'Out of dice? Watch the crew play on and plot your comeback.';

  @override
  String get peekSpectatorCta => 'Watch the round';

  @override
  String get peekSpectatorWait => 'Waiting for the captain\'s signal…';

  @override
  String revealDudoLine(String caller, String bidder) {
    return '$caller challenged $bidder\'s bid.';
  }

  @override
  String revealCalzaLine(String caller) {
    return '$caller went for a calza.';
  }

  @override
  String get revealBidHeld => 'The bid held.';

  @override
  String get revealLiar => 'Lies!';

  @override
  String get revealExactCount => 'Exact count, matey!';

  @override
  String get revealMissed => 'Missed.';

  @override
  String revealAnnouncedBy(String name) {
    return 'Announced by $name';
  }

  @override
  String get revealFacePaco => 'paco';

  @override
  String revealWordDiceOfFace(int face) {
    return 'dice of $face';
  }

  @override
  String revealOnTable(int count) {
    return 'On the table: $count dice called.';
  }

  @override
  String get revealTableHoldsBreath => 'Everyone holds their breath…';

  @override
  String get revealCountInOpen => 'Let\'s reveal the dice…';

  @override
  String get revealCapYou =>
      'You already have five dice, the maximum. You can\'t gain another.';

  @override
  String revealCapPlayer(String name) {
    return '$name already has five dice, the maximum. They can\'t gain another.';
  }

  @override
  String get revealWinYou => 'You gain a die.';

  @override
  String revealWinPlayer(String name) {
    return '$name gains a die.';
  }

  @override
  String get revealYouLoseDie => 'You lose a die.';

  @override
  String revealPlayerLoseDie(String name) {
    return '$name loses a die.';
  }

  @override
  String revealYouRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dice',
      one: '$count die',
    );
    return ' You still have $_temp0.';
  }

  @override
  String revealPlayerRemaining(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dice',
      one: '$count die',
    );
    return ' $name still has $_temp0.';
  }

  @override
  String get revealYouSunk => ' Overboard!';

  @override
  String get revealPlayerSunk => ' Out of dice: out of play.';

  @override
  String get revealNoLoser => 'No one loses a die this round.';

  @override
  String get revealNextRound => 'Continue';

  @override
  String get revealSeeMore => 'Uncover the verdict';

  @override
  String get revealRoleBidder => 'made the bid';

  @override
  String get revealRoleCaller => 'challenged the bid';

  @override
  String get revealRoleWaiter => 'watched';

  @override
  String get overWonSection => 'You won';

  @override
  String get overLostSection => 'Game lost';

  @override
  String get overWonTitle => 'VICTORY';

  @override
  String get overLostTitle => 'YOU\'RE ELIMINATED';

  @override
  String get overWonBody =>
      'The crew has struck their colors. The last tankard is yours.';

  @override
  String overLostBody(String name) {
    return 'The pirates knocked you out. $name wins the tavern.';
  }

  @override
  String get overStatRounds => 'rounds played';

  @override
  String get overStatDiceLeft => 'dice in play';

  @override
  String get overLastWord => 'THE LAST WORD';

  @override
  String get overRematch => 'Run it back';

  @override
  String get overStandingOut => 'overboard';

  @override
  String get overBackToTavern => 'Back to the tavern';

  @override
  String overStandingDice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dice left',
      one: '$count die left',
    );
    return '$_temp0';
  }

  @override
  String get journalTitle => 'Game history';

  @override
  String get journalSubtitle => 'Bids, Dudos, and Calzas from every round.';

  @override
  String journalRoundBadge(int round) {
    return 'Round $round';
  }

  @override
  String get journalEmpty =>
      'Nothing here yet. Bids will appear as they\'re made.';

  @override
  String journalRoundWords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '$count word',
    );
    return '$_temp0';
  }

  @override
  String get journalClose => 'Close';

  @override
  String journalSaidBid(String name, String bid) {
    return '$name bid $bid.';
  }

  @override
  String journalSaidDudo(String name) {
    return '$name said dudo.';
  }

  @override
  String journalSaidCalza(String name) {
    return '$name called Calza.';
  }

  @override
  String get seatOutStatus => 'eliminated';

  @override
  String get seatYourTurn => 'yours';

  @override
  String get seatThinking => 'plotting';

  @override
  String get seatPlaying => 'in the running';

  @override
  String seatSemantics(String name, int count, String status) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dice left',
      one: '$count die left',
    );
    return '$name, $_temp0, $status';
  }

  @override
  String get trayTitle => 'Your hand';

  @override
  String trayDiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dice',
      one: '$count die',
    );
    return '$_temp0';
  }

  @override
  String get trayAcesPlain => 'pacos without power';

  @override
  String get trayAcesWild => 'pacos, masters of all faces';

  @override
  String traySemantics(String hand) {
    return 'Your dice: $hand';
  }

  @override
  String get palificoSemantics =>
      'Palifico: one forced face; pacos aren\'t wild.';

  @override
  String get salonBackToTavern => 'Return to port';

  @override
  String get salonHeader => 'MULTIPLAYER';

  @override
  String get salonHomeTitle => 'Play with your friends';

  @override
  String get salonHomeHint =>
      'One code, six characters, and you\'re at the same table. The host fills out the crew with AI pirates.';

  @override
  String get salonCreateCta => 'Create a code';

  @override
  String get salonJoinCta => 'Join with a code';

  @override
  String get salonBack => 'Back to port';

  @override
  String get salonCreateHeader => 'CREATE A SALON';

  @override
  String get salonCreateTitle => 'Raise the flag';

  @override
  String get salonCreateHint =>
      'Choose your pirate name and how many AI rogues will join your crew.';

  @override
  String get salonNameLabel => 'Your buccaneer name';

  @override
  String get salonBotsSection => 'AI pirates';

  @override
  String get salonCreateSubmit => 'Open the salon';

  @override
  String get salonDefaultName => 'The Lookout';

  @override
  String get salonCreateFailed =>
      'The tavern wouldn\'t open. Try again in a moment.';

  @override
  String get salonJoinHeader => 'JOIN A SALON';

  @override
  String get salonJoinTitle => 'Enter the salon code';

  @override
  String get salonJoinHint =>
      'Enter the captain\'s code, then choose the name you\'ll sail under.';

  @override
  String get salonCodeLabel => 'Salon code';

  @override
  String get salonPasteHint =>
      'You found a message in a bottle. It holds a code: enter it to join the ship.';

  @override
  String get salonJoinNameLabel => 'Your pirate name';

  @override
  String get salonJoinSubmit => 'Join the salon';

  @override
  String get salonJoinFailed =>
      'Can\'t join the salon. Check the code and try again.';

  @override
  String get salonLeaveSemantic => 'Leave the salon';

  @override
  String salonCodeHeader(String code) {
    return 'SALON $code';
  }

  @override
  String get salonHostRole => 'You\'re at the helm of this salon';

  @override
  String get salonGuestRole => 'Crewmate aboard';

  @override
  String get salonCopySemantic => 'Bottle the code';

  @override
  String get salonCopied => 'The code is in your bottle.';

  @override
  String get salonStartRound => 'Start the game';

  @override
  String get salonRoundPreparing => 'The crew is coming aboard…';

  @override
  String get salonWaitingHost =>
      'The crew is waiting for the captain\'s signal…';

  @override
  String get salonRejoinTable => 'Take your seat back at the table';

  @override
  String get salonSpectatorHint =>
      'You\'re watching this round — you\'ll play the next one.';

  @override
  String get salonHostGoneHint =>
      'The host left the round. The game will resume when they\'re back.';

  @override
  String get salonFeedSection => 'Ship\'s log';

  @override
  String get salonStartFailed =>
      'Couldn\'t start the round. Check your connection and try again.';

  @override
  String get salonShareSemantic => 'Share the code';

  @override
  String get salonShareSmsSemantic => 'Send the code by text';

  @override
  String get salonShareMailSemantic => 'Email the code';

  @override
  String get salonShareWhatsappSemantic => 'Send the code on WhatsApp';

  @override
  String get salonShareHint =>
      'Pass the code to your crew, or copy it to send wherever you like.';

  @override
  String salonPlayersCount(int count) {
    return 'Players ($count)';
  }

  @override
  String get salonBotBadge => 'AI PIRATE';

  @override
  String get salonRemoveBotSemantic => 'Remove this AI pirate';

  @override
  String get salonAddBotSemantic => 'Add an AI pirate';

  @override
  String get salonBotDifficultyTitle => 'AI pirate difficulty';

  @override
  String get salonYouSuffix => '(you)';

  @override
  String get salonHostBadge => 'HOST';

  @override
  String get salonLeaveTitle => 'Leave the salon?';

  @override
  String get salonLeaveBody =>
      'You\'re casting off and heading back to the tavern.';

  @override
  String get salonLeaveStay => 'Stay';

  @override
  String get salonLeaveQuit => 'Leave the salon';

  @override
  String get reactionHeader => 'REACTIONS';

  @override
  String get speakHeader => 'MAKE YOUR VOICE HEARD';

  @override
  String reactionTargetSummary(String player, int n) {
    return 'I\'m after $player — $n dice below deck.';
  }

  @override
  String reactionLine1(int count, String face) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dice',
      one: 'one die',
    );
    return 'You don\'t have to believe me, but I\'ve got $_temp0 showing $face.';
  }

  @override
  String reactionLine2(String player) {
    return 'No, $player, that can\'t be.';
  }

  @override
  String reactionLine3(String player) {
    return 'This paco will send you overboard, $player.';
  }

  @override
  String reactionLine4(int n) {
    return 'On a buccaneer\'s word: no more than $n dice. That bid\'s a bluff.';
  }

  @override
  String reactionLine5(int n, String player) {
    return 'I\'ve got $n dice, $player. Your bid won\'t hold.';
  }

  @override
  String get reactionLine6 => 'Paco to port, paco to starboard!';

  @override
  String reactionLine7(String player) {
    return 'I believed you, $player. Nicely played, you fooled me.';
  }

  @override
  String get reactionDicePrompt => 'Choose your tall tale';

  @override
  String get reactionDiceCountLabel => 'How many dice?';

  @override
  String get reactionDiceFaceLabel => 'Which symbol?';

  @override
  String get reactionDiceSend => 'Send it sailing';

  @override
  String get reactionFreeHint => 'Pass a note to the crew…';

  @override
  String get rulesHeader => 'RULES OF THE GAME';

  @override
  String get rulesBack => 'Back to home';

  @override
  String get rulesHeroTitle => 'Perudo rules';

  @override
  String get rulesHeroIntro =>
      'Whatever you call it, the dice stay quiet and the pirates tell tales.';

  @override
  String get rulesShowcaseCaption =>
      'Five dice, one wild paco, and bluffing at the heart of it.';

  @override
  String get rulesGoalTitle => 'Your mission';

  @override
  String get rulesGoalBody =>
      'Keep at least one die until the end. Each round, bid on the hidden dice. Whoever is wrong loses one.';

  @override
  String get rulesCupTitle => 'Your cup';

  @override
  String get rulesCupBody =>
      'Each pirate gets five dice and hides them under their cup. You only see your own.';

  @override
  String get rulesPacoTitle => 'Pacos are wild';

  @override
  String get rulesPacoBody =>
      'A paco (1) counts as any face unless the bid is on pacos, when it only counts as a paco. To raise from a regular face to pacos, bid at least half the quantity, rounded up. To raise from pacos, double the quantity and add one die.';

  @override
  String get rulesBidTitle => 'Make a bid';

  @override
  String get rulesBidBody => 'You announce how many dice show which face.';

  @override
  String get rulesBidQuote =>
      '\"Four fives or more are hiding under the cups.\"';

  @override
  String get rulesBidExplain =>
      'The pirate stakes their word on at least four fives. Pacos can help make up the count.';

  @override
  String get rulesBidOpeningNote =>
      'Outside palifico, you can\'t open a round with pacos.';

  @override
  String get rulesRaiseTitle => 'Raise the bid';

  @override
  String get rulesRaiseIntro => 'Each new bid must beat the previous one:';

  @override
  String get rulesRaiseSameFace =>
      'Keep the face, raise the count: 4 fives → 5 fives.';

  @override
  String get rulesRaiseHigherFace =>
      'Keep the quantity and choose a higher face: 4 fives → 4 sixes.';

  @override
  String get rulesRaiseTowardPaco =>
      'Head for pacos: bid at least half the dice, rounded up: 4 fives → 2 pacos.';

  @override
  String get rulesRaiseFromPaco =>
      'From pacos, double the quantity and add one die: 2 pacos → 5 dice, any face.';

  @override
  String get rulesConvert45 => '4 fives';

  @override
  String get rulesConvert2Paco => '2 pacos';

  @override
  String get rulesConvert5F2 => '5 twos';

  @override
  String get rulesConvert5F6 => '5 sixes';

  @override
  String get rulesConvert3Paco => '3 pacos';

  @override
  String get rulesDudoTitle => 'Dudo!';

  @override
  String get rulesDudoBody =>
      'Call Dudo to challenge the last bid: everyone lifts their cup, then you count.';

  @override
  String get rulesDudoHoldsTitle => 'The bid stands';

  @override
  String get rulesDudoHoldsBody =>
      'The player who challenged the bid loses a die.';

  @override
  String get rulesDudoWrongTitle => 'The bid doesn\'t hold';

  @override
  String get rulesDudoWrongBody => 'The player who made the bid loses a die.';

  @override
  String get rulesCalzaTitle => 'Calza: your choice';

  @override
  String get rulesCalzaBody =>
      'You can call the count exactly right: that\'s a calza.';

  @override
  String get rulesCalzaAllOrNothing => 'A die gained or lost';

  @override
  String get rulesCalzaAllOrNothingBody =>
      'If the count is exact, you gain a die, up to five. Otherwise, you lose one. Calza can be switched off before the game.';

  @override
  String get rulesEndTitle => 'Last pirate standing';

  @override
  String get rulesEndBody =>
      'Out of dice? Overboard! The last pirate afloat wins the tavern; the round\'s loser opens the next one.';

  @override
  String get rulesPalificoTitle => 'Palifico';

  @override
  String get rulesPalificoBody =>
      'A pirate who loses their second-to-last die triggers palifico: the next round plays on a single face, forced by the opening bid.';

  @override
  String get rulesPalificoFaceTitle => 'Face picked by the opening bid';

  @override
  String get rulesPalificoFaceBody =>
      'The first bid sets the face and must be at least two dice. After that, you can\'t change course: only the quantity can go up.';

  @override
  String get rulesPalificoPacoTitle => 'Pacos aren\'t wild';

  @override
  String get rulesPalificoPacoBody =>
      'In palifico, pacos lose their wild power and count only as pacos.';

  @override
  String get rulesPalificoOnceTitle => 'Palifico lasts one round';

  @override
  String get rulesPalificoOnceBody =>
      'Palifico lasts one round. Then the normal rules return, even if a pirate has only one die. If someone drops to one die later, a new palifico begins.';

  @override
  String get rulesTipQuote =>
      'The best bluff is the one no one dares to challenge.';

  @override
  String get rulesUnderstood => 'Got it';

  @override
  String get diceHiddenText => 'Die under the cup';

  @override
  String get diceAceText => 'The paco, master of faces';

  @override
  String diceValueText(int value) {
    return 'The die shows $value';
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
      other: '$count dice of $face',
      one: '$count die of $face',
    );
    return '$_temp0';
  }

  @override
  String bidSpokenAces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'at least $count pacos',
      one: 'at least one paco',
    );
    return '$_temp0';
  }

  @override
  String bidSpokenPlain(int count, int face) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dice',
      one: '$count die',
    );
    return 'at least $_temp0 showing $face';
  }

  @override
  String bidShortLabel(int quantity, String mark) {
    return '$quantity × $mark';
  }

  @override
  String get temperMousseLabel => 'Young deckhand';

  @override
  String get temperMousseBody => 'A timid deckhand who takes the bait easily.';

  @override
  String get temperFlibustierLabel => 'Corsair';

  @override
  String get temperFlibustierBody => 'A balanced opponent who spots bluffs.';

  @override
  String get temperCapitaineLabel => 'Captain';

  @override
  String get temperCapitaineBody => 'Calculates the odds and hates losing.';

  @override
  String get systemPhoneSlept =>
      'Your phone is back from sleep. Reconnecting to the salon…';

  @override
  String get systemQuietCut => 'The salon stopped responding. Reconnecting…';

  @override
  String systemCreated(String code) {
    return 'Your salon is ready: $code.';
  }

  @override
  String systemConnected(String code) {
    return 'Aboard salon $code!';
  }

  @override
  String systemRecovered(String code) {
    return 'You\'re back in the salon $code.';
  }

  @override
  String systemClosed(String reason) {
    return 'The tavern closes its doors: $reason.';
  }

  @override
  String systemLost(String detail) {
    return 'Connection interrupted$detail. Trying again…';
  }

  @override
  String systemUnreachableTrack(String reason) {
    return 'Can\'t reach the salon: $reason. Trying again.';
  }

  @override
  String systemUnreachableBackoff(String brief) {
    return 'The salon is still unreachable: $brief. I\'ll try again after a longer wait.';
  }

  @override
  String systemSalonRefused(String reason) {
    return 'The salon refused your return: $reason. It may have closed — leave the salon, then try again or start a new one.';
  }

  @override
  String systemThrottledCreate(int seconds) {
    return 'Too many salon requests. Try again in $seconds s.';
  }

  @override
  String systemCreateFailed(String detail) {
    return 'The salon couldn\'t be created.$detail';
  }

  @override
  String systemChatRate(int seconds) {
    return 'Easy on the messages, matey. Wait $seconds s.';
  }

  @override
  String get systemDeadReaction =>
      'You\'re disconnected from the salon. Your reaction wasn\'t sent.';

  @override
  String get systemDeadChat =>
      'You\'re disconnected from the salon. Your message wasn\'t sent.';

  @override
  String get systemHostGone =>
      'The host is disconnected. The table is waiting for them…';

  @override
  String get systemNoServerReply =>
      'The server didn\'t respond after 8 s. Trying again.';

  @override
  String systemNetworkResponse(String status, String body) {
    return 'The network replied $status: $body.';
  }

  @override
  String systemNetworkProbeFailed(String error) {
    return 'Couldn\'t check the connection ($error). Trying again.';
  }

  @override
  String get systemSixChars => 'You need a six-character code to come aboard.';
}

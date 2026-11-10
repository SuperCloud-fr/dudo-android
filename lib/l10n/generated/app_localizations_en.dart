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

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get setupBack => 'Back';

  @override
  String get setupTitle => 'NEW GAME';

  @override
  String get setupCrewTitle => 'The crew';

  @override
  String get setupCrewHint => 'Pick how many pirates will lie to you tonight.';

  @override
  String get setupBotTemperTitle => 'The temper of the bots';

  @override
  String get setupStart => 'Cast off the lines';

  @override
  String get setupRulesLink => 'Re-read the rules';

  @override
  String get setupTableLabel => 'PIRATES AT YOUR TABLE';

  @override
  String setupPlayersCount(int count) {
    return '$count players';
  }

  @override
  String get setupRemovePirate => 'Remove a pirate';

  @override
  String get setupAddPirate => 'Add a pirate';

  @override
  String get setupSeatAtTable => 'at the table';

  @override
  String get setupSeatAbsent => 'sitting out';

  @override
  String setupCrewSummary(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pirates',
      one: '1 pirate',
    );
    return 'You + $_temp0 : $names';
  }

  @override
  String get setupCalzaTitle => 'Calza allowed';

  @override
  String get setupCalzaHint =>
      'Calling the exact count wins you a die. Optional, but ferocious.';

  @override
  String get gameQuitTable => 'Leave the game';

  @override
  String gameRound(int round) {
    return 'ROUND $round';
  }

  @override
  String gameDiceInPlay(int count) {
    return '$count dice in play';
  }

  @override
  String get gameOpenJournal => 'Open the table log';

  @override
  String get gameOpenPrompt => 'Open the hostilities.';

  @override
  String get gameYourTurnPrompt => 'Your turn to talk.';

  @override
  String get gameCalzaAsk => 'CALZA?';

  @override
  String get gameDudoCall => 'Dudo!';

  @override
  String get gameRaise => 'Raise the bid';

  @override
  String get gameOpenBid => 'Open';

  @override
  String gameBotThinking(String name) {
    return '$name is thinking';
  }

  @override
  String get gameTableListens => 'the table listens';

  @override
  String get gameLiftCupPrompt => 'Lift your cup.';

  @override
  String get gameTableHoldsBreath => 'The table holds its breath.';

  @override
  String get gameBidInvalid => 'That bid no longer stands.';

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
    return 'You think $accused about “$bid”. If the bid holds, you lose a die.';
  }

  @override
  String get gameDudoConfirm => 'DUDO!';

  @override
  String get gameCalzaConfirmTitle => 'Calza?';

  @override
  String get gameFacePaco => 'paco';

  @override
  String gameWordDiceOfFace(int face) {
    return 'dice of $face';
  }

  @override
  String gameCalzaConfirmBody(int count, String faceWord) {
    return 'You think there are exactly $count $faceWord on the table. Exact count: you win a die. Otherwise you lose one.';
  }

  @override
  String get gameCalzaConfirm => 'CALZA';

  @override
  String get gameQuitTitle => 'Leave the table?';

  @override
  String get gameQuitBody =>
      'The game in play will be lost. The pirates will not remember you.';

  @override
  String get gameQuitStay => 'Stay';

  @override
  String get gameQuitLeave => 'Leave';

  @override
  String get bidOpenHostilities => 'Open the hostilities';

  @override
  String get bidRaiseSection => 'Your raise';

  @override
  String get bidRaisePrompt => 'Your turn to raise.';

  @override
  String get bidLastBid => 'Last bid: ';

  @override
  String get bidPalificoFaceLabel => 'LOCKED FACE';

  @override
  String get bidFaceLabel => 'FACE';

  @override
  String bidSummaryAces(int count) {
    return 'I wager there are at least $count paco on the table.';
  }

  @override
  String bidSummary(int count, String faceWord) {
    return 'I wager there are at least $count $faceWord on the table.';
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
  String get bidPalificoFaceHint => 'Locked face: palifico round.';

  @override
  String get bidPalificoOpenHint =>
      'Palifico: the opening face stands for the whole round.';

  @override
  String get bidAcesOnlyHint => 'Only paco count.';

  @override
  String get bidPacoWildHint => 'Paco count as wild for this face.';

  @override
  String get bidAnnounce => 'Call it';

  @override
  String get bidIllegalRaise => 'That amount is not a legal raise.';

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
  String get bidAceSemantics => 'Paco, the joker';

  @override
  String bidFaceSemantics(int face) {
    return 'Value $face';
  }

  @override
  String cardEmptySemantics(String name) {
    return 'No bid yet. $name opens the hostilities.';
  }

  @override
  String cardFilledSemantics(String spoken, String bidder, int total) {
    return 'Bid on the table: $spoken, called by $bidder. $total dice in play.';
  }

  @override
  String get cardFilledTitle => 'BID ON THE TABLE';

  @override
  String get cardDiceUnit => 'DICE';

  @override
  String get cardPalificoHint => 'Palifico round: paco do not count';

  @override
  String get cardAcesOnlyHint => 'Only paco count';

  @override
  String get cardPacoWildHint => 'Paco count as wild for this face';

  @override
  String cardDiceCount(int count) {
    return '$count dice';
  }

  @override
  String get cardTableWaits => 'THE TABLE WAITS';

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
  String get peekCupTitle => 'Your cup';

  @override
  String get peekSecretHint =>
      'Keep that secret. The rest of the table sees nothing.';

  @override
  String get peekShakeHint =>
      'Shake the phone like on a real bar top: the leather lifts, and only you see your dice.';

  @override
  String get peekPalificoHint => 'Palifico round: a single face for every bid.';

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
      other: '$count paco',
      one: '1 paco',
    );
    return '$_temp0';
  }

  @override
  String get peekPalificoWildHint => 'Palifico round: paco count only as paco.';

  @override
  String get peekWildHint => 'Paco count as wild for every face.';

  @override
  String peekPlayerOpens(String name) {
    return 'It’s $name’s turn to open';
  }

  @override
  String get peekOnlyHostStarts =>
      'Only the host can start bidding. You can look at your dice while you wait.';

  @override
  String get peekLiftCupSemantics => 'Lift the cup to see your dice';

  @override
  String get peekShakeButton => 'Shake the phone to stir your dice';

  @override
  String get peekTapCupHint => '… or tap the cup to lift it';

  @override
  String get peekTakeTimeHint =>
      'Take your time. The other pirates are waiting.';

  @override
  String revealDudoLine(String caller, String bidder) {
    return '$caller doubted $bidder.';
  }

  @override
  String revealCalzaLine(String caller) {
    return '$caller called the exact count.';
  }

  @override
  String get revealBidHeld => 'The bid held.';

  @override
  String get revealLiar => 'Lies!';

  @override
  String get revealExactCount => 'Exact count.';

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
    return 'on the table · $count announced';
  }

  @override
  String get revealTableHoldsBreath => 'The table holds its breath…';

  @override
  String get revealCountInOpen => 'The count lies under every eye…';

  @override
  String get revealCapYou =>
      'You already had five dice. The exact count is noted, but nothing to take back.';

  @override
  String revealCapPlayer(String name) {
    return '$name already had five dice. The exact count is noted, but nothing to take back.';
  }

  @override
  String get revealWinYou => 'Exact count: you take a die back.';

  @override
  String revealWinPlayer(String name) {
    return '$name takes a die back.';
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
  String revealPlayerRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dice',
      one: '$count die',
    );
    return ' They still have $_temp0.';
  }

  @override
  String get revealYouSunk => ' You’re overboard.';

  @override
  String get revealPlayerSunk => ' They’re overboard.';

  @override
  String get revealNoLoser => 'The round ends with no loser.';

  @override
  String get revealNextRound => 'Next round';

  @override
  String get revealSeeMore => 'See the outcome';

  @override
  String get revealRoleBidder => 'bid it';

  @override
  String get revealRoleCaller => 'doubted';

  @override
  String get revealRoleWaiter => 'watched';

  @override
  String get overWonSection => 'The tavern is yours';

  @override
  String get overLostSection => 'The end of the voyage';

  @override
  String get overWonTitle => 'YOU RULE';

  @override
  String get overLostTitle => 'OVERBOARD';

  @override
  String get overWonBody =>
      'The crew has laid down its arms. The last tankard is yours.';

  @override
  String overLostBody(String name) {
    return 'The pirates had you. $name keeps a hand on the barrel.';
  }

  @override
  String get overStatRounds => 'rounds';

  @override
  String get overStatDiceLeft => 'dice left';

  @override
  String get overLastWord => 'THE LAST WORD';

  @override
  String get overRematch => 'Play again';

  @override
  String get overStandingOut => 'overboard';

  @override
  String get overBackToTavern => 'Back to the tavern';

  @override
  String overStandingDice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dice',
      one: '$count die',
    );
    return '$_temp0';
  }

  @override
  String get journalTitle => 'The table log';

  @override
  String get journalSubtitle => 'Everything that was said.';

  @override
  String journalRoundBadge(int round) {
    return 'Round $round';
  }

  @override
  String get journalEmpty => 'The log is still blank. The bids will rain down.';

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
  String get journalClose => 'Close the log';

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
    return '$name called for calza.';
  }

  @override
  String get seatOutStatus => 'overboard';

  @override
  String get seatYourTurn => 'yours';

  @override
  String get seatThinking => 'thinking';

  @override
  String get seatPlaying => 'in the game';

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
  String get trayAcesPlain => 'plain paco';

  @override
  String get trayAcesWild => 'paco, wild';

  @override
  String traySemantics(String hand) {
    return 'Your hand: $hand';
  }

  @override
  String get palificoSemantics =>
      'Palifico round: one forced face, paco no longer wild';

  @override
  String get salonBackToTavern => 'Back to the tavern';

  @override
  String get salonHeader => 'MULTIPLAYER';

  @override
  String get salonHomeTitle => 'One code, five cups';

  @override
  String get salonHomeHint =>
      'Friends walk in with a six-character code. The host pours the AI pirates, the table talks live.';

  @override
  String get salonCreateCta => 'Create a code';

  @override
  String get salonJoinCta => 'Join with a code';

  @override
  String get salonBack => 'Back';

  @override
  String get salonCreateHeader => 'CREATE A SALON';

  @override
  String get salonCreateTitle => 'You\'re the first';

  @override
  String get salonCreateHint =>
      'Pick your cabin name and how many AI pirates will lie with you.';

  @override
  String get salonNameLabel => 'Your pirate name';

  @override
  String get salonBotsSection => 'AI pirates';

  @override
  String get salonCreateSubmit => 'Open the salon';

  @override
  String get salonDefaultName => 'Tavern Keeper';

  @override
  String get salonCreateFailed => 'The salon could not be created.';

  @override
  String get salonJoinHeader => 'JOIN A SALON';

  @override
  String get salonJoinTitle => 'The code is the bond';

  @override
  String get salonJoinHint =>
      'Type the six characters the host sent you. On the table, your name is the only thing you can change.';

  @override
  String get salonCodeLabel => 'Salon code';

  @override
  String get salonPasteHint =>
      'Sharing fresh — SMS, mail, WhatsApp, Signal or anywhere else — just works better.';

  @override
  String get salonJoinNameLabel => 'Your name (still editable here)';

  @override
  String get salonJoinSubmit => 'Join';

  @override
  String get salonJoinFailed => 'Salon unreachable right now.';

  @override
  String get salonLeaveSemantic => 'Leave the salon';

  @override
  String salonCodeHeader(String code) {
    return 'SALON $code';
  }

  @override
  String get salonHostRole => 'You reign over this table';

  @override
  String get salonGuestRole => 'Host\'s guest';

  @override
  String get salonCopySemantic => 'Copy the code';

  @override
  String get salonCopied => 'Code copied to the clipboard.';

  @override
  String get salonStartRound => 'Start the round';

  @override
  String get salonRoundPreparing => 'The round is being poured…';

  @override
  String get salonWaitingHost => 'Waiting for the host to start the round…';

  @override
  String get salonFeedSection => 'The salon thread';

  @override
  String get salonStartFailed => 'The round could not start. Try again.';

  @override
  String get salonShareSemantic => 'Share the code';

  @override
  String get salonShareSmsSemantic => 'Send by text';

  @override
  String get salonShareMailSemantic => 'Send by email';

  @override
  String get salonShareWhatsappSemantic => 'Send on WhatsApp';

  @override
  String get salonShareHint =>
      'WhatsApp, Signal, SMS, mail: each app opens the right links, otherwise copy.';

  @override
  String salonPlayersCount(int count) {
    return 'At the table ($count)';
  }

  @override
  String get salonBotBadge => 'AI';

  @override
  String get salonRemoveBotSemantic => 'Remove an AI pirate';

  @override
  String get salonAddBotSemantic => 'Add an AI pirate';

  @override
  String get salonBotDifficultyTitle => 'AI bot difficulty';

  @override
  String get salonYouSuffix => '(you)';

  @override
  String get salonHostBadge => 'HOST';

  @override
  String get salonLeaveTitle => 'Leave the salon?';

  @override
  String get salonLeaveBody => 'The code becomes unusable for this game.';

  @override
  String get salonLeaveStay => 'Stay';

  @override
  String get salonLeaveQuit => 'Leave';

  @override
  String get reactionHeader => 'REACT';

  @override
  String get speakHeader => 'SPEAK';

  @override
  String reactionTargetSummary(String player, int n) {
    return '$player · my dice: $n';
  }

  @override
  String reactionLine1(int n) {
    return 'You don\'t have to believe me, but I\'ve got $n dice.';
  }

  @override
  String reactionLine2(String player) {
    return 'No, $player, that can\'t be.';
  }

  @override
  String reactionLine3(String player) {
    return 'The paco will be your end, $player.';
  }

  @override
  String reactionLine4(int n) {
    return 'I swear: at most $n dice on that table, they lie.';
  }

  @override
  String reactionLine5(int n, String player) {
    return 'Look at my $n dice, $player — you\'ll sleep with the fishes.';
  }

  @override
  String get reactionLine6 => 'Paco on paco, paco, paco...';

  @override
  String reactionLine7(String player) {
    return 'I believed you, $player — freshly fooled, aren\'t you.';
  }

  @override
  String get reactionFreeHint => 'Type a free message…';

  @override
  String get rulesHeader => 'THE RULES';

  @override
  String get rulesBack => 'Back';

  @override
  String get rulesHeroTitle => 'The game of lies';

  @override
  String get rulesHeroIntro =>
      'Perudo, Dudo, Cacho… call it what you like. The dice don\'t lie. The pirates do.';

  @override
  String get rulesShowcaseCaption =>
      'Five dice, one wild paco, and no reason to tell the truth.';

  @override
  String get rulesGoalTitle => 'The goal';

  @override
  String get rulesGoalBody =>
      'Be the last pirate standing with at least one die. Each round you bet on what the cups hide. Whoever gets it wrong loses a die.';

  @override
  String get rulesCupTitle => 'Your cup';

  @override
  String get rulesCupBody =>
      'Everyone gets five dice and hides them under the cup. You may only look at your own.';

  @override
  String get rulesPacoTitle => 'Pacos are jokers';

  @override
  String get rulesPacoBody =>
      'A paco (1) counts as any face. It only counts as a paco when the bid is about pacos. So a paco is worth two plain dice when raising.';

  @override
  String get rulesBidTitle => 'The bid';

  @override
  String get rulesBidBody => 'A bid is two numbers: a quantity and a face.';

  @override
  String get rulesBidQuote => '\"There are at least 4 fives on the table.\"';

  @override
  String get rulesBidExplain =>
      'Here the pirate claims at least four dice of value 5 across the whole table. The pacos count too.';

  @override
  String get rulesBidOpeningNote =>
      'A round never opens on pacos: they are wild, so the opening bid can\'t use them. Palifico rounds are the exception.';

  @override
  String get rulesRaiseTitle => 'Raising';

  @override
  String get rulesRaiseIntro => 'The next bid must always be stronger:';

  @override
  String get rulesRaiseSameFace =>
      'More dice on the same face: 4 fives → 5 fives.';

  @override
  String get rulesRaiseHigherFace =>
      'Same count, higher face: 4 fives → 4 sixes.';

  @override
  String get rulesRaiseTowardPaco =>
      'Toward the pacos: at least half, rounded up: 4 fives → 2 pacos.';

  @override
  String get rulesRaiseFromPaco =>
      'From the pacos: double plus one: 2 pacos → 5 dice of any face.';

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
      'Instead of raising, you may call the last bid a lie. Everyone lifts the cup and you count.';

  @override
  String get rulesDudoHoldsTitle => 'The bid stands';

  @override
  String get rulesDudoHoldsBody => 'The doubter loses a die.';

  @override
  String get rulesDudoWrongTitle => 'The bid is wrong';

  @override
  String get rulesDudoWrongBody => 'The bidder loses a die.';

  @override
  String get rulesCalzaTitle => 'Calza — optional';

  @override
  String get rulesCalzaBody =>
      'You may also announce the count is exactly right. That\'s the calza.';

  @override
  String get rulesCalzaAllOrNothing => 'All or nothing';

  @override
  String get rulesCalzaAllOrNothingBody =>
      'Exact count: you win a die (up to five). Wrong count: you lose one. Calza can be turned off before the game.';

  @override
  String get rulesEndTitle => 'The end';

  @override
  String get rulesEndBody =>
      'A pirate who loses the last die is overboard. The last survivor wins the tavern. The round\'s loser opens the next round.';

  @override
  String get rulesPalificoTitle => 'Palifico';

  @override
  String get rulesPalificoBody =>
      'A pirate who loses their second-to-last die triggers palifico: the next round plays on a single face, forced by the opening bid.';

  @override
  String get rulesPalificoFaceTitle => 'Forced face';

  @override
  String get rulesPalificoFaceBody =>
      'The first bid picks the face and opens with at least two dice. Every later bid raises the count on that same face; the face can\'t change.';

  @override
  String get rulesPalificoPacoTitle => 'Paco, no jokers';

  @override
  String get rulesPalificoPacoBody =>
      'During palifico, pacos count only as pacos: no wild value.';

  @override
  String get rulesPalificoOnceTitle => 'One round only';

  @override
  String get rulesPalificoOnceBody =>
      'Next round, bidding returns to normal even if the pirate still holds one die. And if anyone drops to one die later, palifico triggers again.';

  @override
  String get rulesTipQuote =>
      'The best bluff is the one nobody wants to pay for.';

  @override
  String get rulesUnderstood => 'Got it';

  @override
  String get diceHiddenText => 'Hidden die';

  @override
  String get diceAceText => 'Ace, wild';

  @override
  String diceValueText(int value) {
    return 'Die of value $value';
  }

  @override
  String bidAcesLabel(int count) {
    return '$count pacos';
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
    return 'at least $count pacos';
  }

  @override
  String bidSpokenPlain(int count, int face) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dice',
      one: '$count die',
    );
    return 'at least $_temp0 of value $face';
  }

  @override
  String bidShortLabel(int quantity, String mark) {
    return '$quantity×$mark';
  }

  @override
  String get temperMousseLabel => 'Cabin Hand';

  @override
  String get temperMousseBody => 'Shy, cautious, easy to bluff.';

  @override
  String get temperFlibustierLabel => 'Freebooter';

  @override
  String get temperFlibustierBody => 'An honest opponent who can smell a lie.';

  @override
  String get temperCapitaineLabel => 'Captain';

  @override
  String get temperCapitaineBody => 'Counts probabilities and hates losing.';

  @override
  String get systemPhoneSlept =>
      'The phone put the salon to sleep — reconnecting…';

  @override
  String get systemQuietCut =>
      'The salon has gone quiet — I cut the dessicated flow and reconnect…';

  @override
  String systemCreated(String code) {
    return 'Salon created. Code: $code';
  }

  @override
  String systemConnected(String code) {
    return 'In the salon $code';
  }

  @override
  String systemRecovered(String code) {
    return 'Back in the salon $code.';
  }

  @override
  String systemClosed(String reason) {
    return 'Salon closed: $reason';
  }

  @override
  String systemLost(String detail) {
    return 'Connection lost$detail — trying to reconnect…';
  }

  @override
  String systemUnreachableTrack(String reason) {
    return 'Salon unreachable — $reason I keep trying.';
  }

  @override
  String systemUnreachableBackoff(String brief) {
    return 'Salon unreachable — $brief. I keep trying, backing off each time.';
  }

  @override
  String systemThrottledCreate(int seconds) {
    return 'Too many creation requests — try again in ~$seconds s.';
  }

  @override
  String systemCreateFailed(String detail) {
    return 'No salon could be created right now.$detail';
  }

  @override
  String systemChatRate(int seconds) {
    return 'The salon is rate-limited — wait ${seconds}s.';
  }

  @override
  String get systemDeadReaction =>
      'The salon connection dropped — the reaction can\'t travel.';

  @override
  String get systemDeadChat =>
      'The salon connection dropped — the message can\'t travel.';

  @override
  String get systemSixChars => 'The code must be six characters.';
}

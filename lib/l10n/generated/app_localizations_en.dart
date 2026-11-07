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
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/leather_cup.dart';
import '../../core/widgets/tavern_background.dart';
import '../../core/widgets/tavern_button.dart';
import '../../game/models/bid.dart';
import '../../game/models/game_config.dart';
import '../../game/models/table_event.dart';
import '../../game/state/game_controller.dart';
import 'widgets/bid_card.dart';
import 'widgets/bid_sheet.dart';
import 'widgets/game_over_overlay.dart';
import 'widgets/journal_sheet.dart';
import 'widgets/peek_overlay.dart';
import 'widgets/palifico_chip.dart';
import 'widgets/player_seat.dart';
import 'widgets/reveal_overlay.dart';
import 'widgets/table_pieces.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    this.config = const GameConfig(),
    this.controller,
  });

  final GameConfig config;
  final GameController? controller;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;
  late GamePhase _lastPhase;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? GameController(config: widget.config);
    _lastPhase = _controller.phase;
    _controller.addListener(_onGameChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onGameChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onGameChanged() {
    final phase = _controller.phase;
    if (phase != _lastPhase) {
      _lastPhase = phase;
      if (phase == GamePhase.reveal) HapticFeedback.heavyImpact();
      if (phase == GamePhase.roundOver) HapticFeedback.mediumImpact();
      if (phase == GamePhase.gameOver) HapticFeedback.heavyImpact();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 720;

    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
      },
      child: Scaffold(
        backgroundColor: AppColors.ink,
        body: TavernBackground(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Center(
                      child: SizedBox(
                        width: math.min(760, constraints.maxWidth),
                        height: constraints.maxHeight,
                        child: Column(
                          children: [
                            _buildTopBar(context),
                            _buildOpponents(context, compact),
                            _buildTable(context, compact),
                            _buildPlayerTray(context),
                            _buildActionBar(context, compact),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _buildOverlay(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 2),
      child: Row(
        children: [
          RoundIconButton(
            icon: Icons.close,
            semanticLabel: 'Quitter la partie',
            onPressed: _confirmQuit,
            size: 48,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'MANCHE ${_controller.round}',
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: AppColors.brass, letterSpacing: 2.4),
                ),
                if (_controller.palifico) ...[
                  const SizedBox(height: 4),
                  const Center(child: PalificoChip(size: 10)),
                ],
                const SizedBox(height: 2),
                Text(
                  '${_controller.totalDice} dés en jeu',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.parchmentMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          RoundIconButton(
            icon: Icons.history,
            semanticLabel: 'Ouvrir le journal de la table',
            onPressed: _openJournal,
            size: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildOpponents(BuildContext context, bool compact) {
    final bots = _controller.players.skip(1).toList(growable: false);
    final count = bots.length;
    final avatarSize =
        switch (count) {
          1 => 54.0,
          2 => 48.0,
          3 => 42.0,
          4 => 38.0,
          _ => 34.0,
        } -
        (compact ? 3 : 0);
    final seatCompact = compact || count >= 4;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
      child: Row(
        children: [
          for (final bot in bots)
            Expanded(
              child: PlayerSeat(
                player: bot,
                active:
                    _controller.phase == GamePhase.bidding &&
                    _controller.currentPlayer == bot.seat,
                isBidder: _controller.currentBid?.playerSeat == bot.seat,
                avatarSize: avatarSize,
                compact: seatCompact,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, bool compact) {
    final bid = _controller.currentBid;
    final history = _historyView();
    final names = <int, String>{
      for (final player in _controller.players)
        player.seat: player.isHuman ? 'Toi' : player.name,
    };
    final starter = _controller.players[_controller.starter];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const TableSurface(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BidCard(
                      bid: bid,
                      palifico: _controller.palifico,
                      bidderName: bid == null
                          ? ''
                          : names[bid.playerSeat] ?? '',
                      totalDice: _controller.totalDice,
                      starterName: starter.isHuman ? 'Toi' : starter.name,
                      humanOpens: starter.isHuman,
                    ),
                    SizedBox(height: compact ? 6 : 9),
                    HistoryStrip(events: history, names: names),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerTray(BuildContext context) {
    final human = _controller.human;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: DiceTray(
        dice: human.dice,
        diceCount: human.diceCount,
        palifico: _controller.palifico,
        active: _controller.isHumanTurn,
      ),
    );
  }

  Widget _buildActionBar(BuildContext context, bool compact) {
    final phase = _controller.phase;
    final humanTurn = _controller.isHumanTurn;

    Widget content;
    if (phase == GamePhase.bidding && humanTurn) {
      final canChallenge = _controller.canHumanChallenge;
      final bidPossible = _controller.defaultHumanBid != null;
      final prompt = !canChallenge
          ? 'Ouvre les hostilités.'
          : 'À toi de parler.';
      content = Column(
        key: const ValueKey('human-actions'),
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    prompt,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.parchmentMuted,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (canChallenge && widget.config.calzaEnabled)
                  TextButton(
                    onPressed: _controller.canHumanCalza ? _confirmCalza : null,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(72, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      textStyle: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(
                            color: AppColors.brassBright,
                            letterSpacing: 1.2,
                          ),
                    ),
                    child: const Text('CALZA ?'),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: TavernButton(
                  label: 'Dudo !',
                  icon: Icons.front_hand_outlined,
                  tone: TavernButtonTone.blood,
                  compact: true,
                  onPressed: canChallenge ? _confirmDudo : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 7,
                child: TavernButton(
                  label: canChallenge ? 'Surenchérir' : 'Ouvrir',
                  icon: Icons.trending_up,
                  compact: true,
                  onPressed: bidPossible ? _showBidSheet : null,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (phase == GamePhase.bidding) {
      final player = _controller.players[_controller.currentPlayer];
      content = Container(
        key: ValueKey('bot-${player.seat}'),
        height: compact ? 48 : 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.leatherDeep.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.brassDim.withValues(alpha: 0.45)),
        ),
        child: Row(
          children: [
            Flexible(
              child: Text(
                '${player.name} réfléchit',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(color: AppColors.parchmentDim, fontSize: 13),
              ),
            ),
            const SizedBox(width: 10),
            const ThinkingDots(),
            const Spacer(),
            Text(
              'la table écoute',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.parchmentMuted,
                fontStyle: FontStyle.italic,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    } else {
      content = Container(
        key: ValueKey('phase-${phase.name}'),
        height: 48,
        alignment: Alignment.center,
        child: Text(
          phase == GamePhase.peek
              ? 'Soulève ton gobelet.'
              : 'La table retient son souffle.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.parchmentMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: content,
      ),
    );
  }

  List<TableEventView> _historyView() {
    return _controller.roundEvents.reversed
        .take(3)
        .map((event) {
          final kind = switch (event.kind) {
            TableEventKind.bid => TableEventViewKind.bid,
            TableEventKind.dudo => TableEventViewKind.dudo,
            TableEventKind.calza => TableEventViewKind.calza,
          };
          final label = switch (event.kind) {
            TableEventKind.bid => event.bid?.shortLabel ?? '',
            TableEventKind.dudo => 'DUDO',
            TableEventKind.calza => 'CALZA',
          };
          return TableEventView(
            playerSeat: event.playerSeat,
            kind: kind,
            label: label,
          );
        })
        .toList(growable: false);
  }

  Widget _buildOverlay(BuildContext context) {
    switch (_controller.phase) {
      case GamePhase.peek:
        return PeekOverlay(
          key: ValueKey('peek-${_controller.round}'),
          round: _controller.round,
          palifico: _controller.palifico,
          dice: _controller.human.dice,
          humanStarts: _controller.starter == 0,
          starterName: _controller.players[_controller.starter].name,
          onReady: _controller.beginBidding,
        );
      case GamePhase.reveal:
      case GamePhase.roundOver:
        final outcome = _controller.outcome;
        if (outcome == null) return const SizedBox.shrink();
        final applied = _controller.phase == GamePhase.roundOver;
        return RevealOverlay(
          key: ValueKey('reveal-${_controller.round}'),
          outcome: outcome,
          palifico: _controller.palifico,
          players: _controller.players,
          applied: applied,
          onContinue: applied
              ? _controller.nextRound
              : _controller.applyOutcome,
        );
      case GamePhase.gameOver:
        final result = _controller.result;
        if (result == null) return const SizedBox.shrink();
        return GameOverOverlay(
          key: ValueKey('over-${result.rounds}-${result.humanWon}'),
          result: result,
          players: _controller.players,
          difficultyLabel: widget.config.difficulty.label,
          onRematch: _controller.rematch,
          onMenu: _leaveGame,
        );
      case GamePhase.bidding:
        return const SizedBox.shrink();
    }
  }

  Future<void> _showBidSheet() async {
    final initial = _controller.defaultHumanBid;
    if (initial == null) return;
    final previous = _controller.currentBid;
    final result = await showModalBottomSheet<Bid>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.ink.withValues(alpha: 0.72),
      builder: (context) {
        return BidSheet(
          previous: previous,
          palifico: _controller.palifico,
          previousBidderName: previous == null
              ? ''
              : _controller.players[previous.playerSeat].name,
          totalDice: _controller.totalDice,
          initial: initial,
          calzaEnabled: widget.config.calzaEnabled,
        );
      },
    );
    if (result == null || !mounted) return;
    final accepted = _controller.submitHumanBid(result);
    if (!accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ce pari n\'est plus valable.')),
      );
    }
  }

  Future<void> _confirmDudo() async {
    final bid = _controller.currentBid;
    if (bid == null || !_controller.canHumanChallenge) return;
    final bidder = _controller.players[bid.playerSeat];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Dudo ?',
            style: AppTypography.inscription(
              size: 24,
              color: AppColors.parchment,
            ),
          ),
          content: Text(
            'Tu penses que ${bidder.isHuman ? 'tu as menti' : '${bidder.name} ment'} '
            'sur « ${bid.label} ». '
            'Si le pari tient, tu perds un dé.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.bloodBright,
              ),
              child: const Text('DUDO !'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    HapticFeedback.heavyImpact();
    _controller.callHumanDudo();
  }

  Future<void> _confirmCalza() async {
    final bid = _controller.currentBid;
    if (bid == null || !_controller.canHumanCalza) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Calza ?',
            style: AppTypography.inscription(
              size: 24,
              color: AppColors.parchment,
            ),
          ),
          content: Text(
            'Tu penses qu\'il y a exactement ${bid.quantity} '
            '${bid.face == 1 ? 'paco' : 'dés de ${bid.face}'} sur la table. '
            'Compte exact : tu gagnes un dé. Sinon, tu en perds un.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.brassBright,
              ),
              child: const Text('CALZA'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    HapticFeedback.heavyImpact();
    _controller.callHumanCalza();
  }

  Future<void> _openJournal() async {
    _controller.pauseBots();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.ink.withValues(alpha: 0.72),
      builder: (context) {
        return JournalSheet(
          events: _controller.journal,
          players: _controller.players,
          currentRound: _controller.round,
        );
      },
    );
    if (mounted) _controller.resumeBots();
  }

  Future<void> _confirmQuit() async {
    _controller.pauseBots();
    final quit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Quitter la table ?',
            style: AppTypography.inscription(
              size: 22,
              color: AppColors.parchment,
            ),
          ),
          content: const Text(
            'La partie en cours sera perdue. Les pirates ne se souviendront pas de toi.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Rester'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.bloodBright,
              ),
              child: const Text('Quitter'),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    if (quit == true) {
      _leaveGame();
    } else {
      _controller.resumeBots();
    }
  }

  void _leaveGame() {
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }
}

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'palifico_chip.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/dice_face.dart';
import '../../../core/widgets/tavern_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../game/logic/perudo_rules.dart';
import '../../../game/models/player.dart';
import '../../../game/models/table_event.dart';

/// Shows every cup at once, marks the dice that answer the bid, and explains
/// the sentence before the next round.
class RevealOverlay extends StatefulWidget {
  const RevealOverlay({
    super.key,
    required this.outcome,
    required this.palifico,
    required this.players,
    required this.applied,
    required this.onContinue,
    this.chatAction,
  });

  final ChallengeOutcome outcome;
  final bool palifico;
  final List<Player> players;
  final bool applied;
  final VoidCallback onContinue;
  final Widget? chatAction;

  @override
  State<RevealOverlay> createState() => _RevealOverlayState();
}

class _RevealOverlayState extends State<RevealOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final outcome = widget.outcome;
    final isDudo = outcome.kind == ChallengeKind.dudo;
    final bidder = widget.players[outcome.bidderSeat];
    final caller = widget.players[outcome.callerSeat];
    final face = outcome.bid.face;
    final verdict = _verdict(l10n);
    final accent = isDudo ? AppColors.bloodBright : AppColors.brassBright;

    return SizedBox.expand(
      child: Material(
        color: Colors.transparent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.ink, AppColors.woodDeep, AppColors.ink],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 36,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: AnimatedBuilder(
                          animation: _entrance,
                          builder: (context, _) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _stamp(isDudo, accent),
                                const SizedBox(height: 14),
                                Text(
                                  verdict,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.inscription(
                                    size: 29,
                                    color: AppColors.parchment,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  isDudo
                                      ? l10n.revealDudoLine(
                                          caller.name,
                                          bidder.name,
                                        )
                                      : l10n.revealCalzaLine(caller.name),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.parchmentMuted,
                                      ),
                                ),
                                if (widget.palifico) ...[
                                  const SizedBox(height: 8),
                                  const Center(child: PalificoChip(size: 10)),
                                ],
                                const SizedBox(height: 16),
                                _bidRecap(context, outcome, accent),
                                const SizedBox(height: 14),
                                _actualCount(context, outcome, accent),
                                const SizedBox(height: 18),
                                ..._rows(context, outcome, face),
                                const SizedBox(height: 16),
                                _consequence(context, outcome),
                                const SizedBox(height: 18),
                                TavernButton(
                                  label: widget.applied
                                      ? l10n.revealNextRound
                                      : l10n.revealSeeMore,
                                  icon: widget.applied
                                      ? Icons.arrow_forward
                                      : Icons.remove_red_eye_outlined,
                                  expand: true,
                                  onPressed: widget.onContinue,
                                ),
                                if (widget.chatAction != null) ...[
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: widget.chatAction,
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _stamp(bool isDudo, Color accent) {
    final progress = MediaQuery.disableAnimationsOf(context)
        ? 1.0
        : Curves.elasticOut.transform((_entrance.value / 0.55).clamp(0.0, 1.0));
    return Center(
      child: Transform.rotate(
        angle: -0.07,
        child: Transform.scale(
          scale: 0.6 + progress * 0.4,
          child: Container(
            width: 82,
            height: 82,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDudo
                    ? [AppColors.blood, AppColors.bloodDeep]
                    : [AppColors.brass, AppColors.brassDim],
              ),
              border: Border.all(
                color: isDudo ? AppColors.bloodBright : AppColors.brassBright,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.28),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: (isDudo ? AppColors.ivory : AppColors.ink).withValues(
                    alpha: 0.35,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                isDudo ? 'DUDO' : 'CALZA',
                style: AppTypography.inscription(
                  size: 16,
                  color: isDudo ? AppColors.ivory : AppColors.ink,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bidRecap(
    BuildContext context,
    ChallengeOutcome outcome,
    Color accent,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.leatherDeep.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.brassDim.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Text(
            '${outcome.bid.quantity}',
            style: AppTypography.inscription(
              size: 30,
              color: accent,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(width: 8),
          DiceFace(value: outcome.bid.face, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.revealAnnouncedBy(widget.players[outcome.bidderSeat].name),
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.parchmentDim),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actualCount(
    BuildContext context,
    ChallengeOutcome outcome,
    Color accent,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final faceLabel = outcome.bid.face == 1
        ? l10n.revealFacePaco
        : l10n.revealWordDiceOfFace(outcome.bid.face);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${outcome.actualCount}',
          style: AppTypography.inscription(
            size: 64,
            color: accent,
            letterSpacing: 0,
            height: 0.9,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  faceLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(color: AppColors.parchment),
                ),
                Text(
                  l10n.revealOnTable(outcome.bid.quantity),
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.parchmentMuted),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _rows(BuildContext context, ChallengeOutcome outcome, int face) {
    final alive = widget.players
        .where((player) => player.dice.isNotEmpty)
        .toList(growable: false);
    return [
      for (var index = 0; index < alive.length; index++)
        _DiceRow(
          player: alive[index],
          face: face,
          palifico: widget.palifico,
          matches: PerudoRules.countForFace(
            alive[index].dice,
            face,
            palifico: widget.palifico,
          ),
          isBidder: alive[index].seat == outcome.bidderSeat,
          isCaller: alive[index].seat == outcome.callerSeat,
          animation: _rowAnimation(index),
        ),
    ];
  }

  Animation<double> _rowAnimation(int index) {
    final start = (0.18 + index * 0.055).clamp(0.0, 0.7);
    final end = (start + 0.28).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  Widget _consequence(BuildContext context, ChallengeOutcome outcome) {
    final l10n = AppLocalizations.of(context)!;
    if (!widget.applied) {
      return Text(
        outcome.kind == ChallengeKind.dudo
            ? l10n.revealTableHoldsBreath
            : l10n.revealCountInOpen,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.parchmentMuted,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    final loser = outcome.loserSeat == null
        ? null
        : widget.players[outcome.loserSeat!];
    final gainer = outcome.gainSeat == null
        ? null
        : widget.players[outcome.gainSeat!];
    final isHumanLoser = loser?.isHuman ?? false;
    final color = isHumanLoser ? AppColors.bloodBright : AppColors.brassBright;

    final String text;
    if (gainer != null) {
      if (outcome.gainCapped) {
        text = gainer.isHuman
            ? l10n.revealCapYou
            : l10n.revealCapPlayer(gainer.name);
      } else {
        text = gainer.isHuman
            ? l10n.revealWinYou
            : l10n.revealWinPlayer(gainer.name);
      }
    } else if (loser != null) {
      final rest = loser.isAlive
          ? (loser.isHuman
                ? l10n.revealYouRemaining(loser.diceCount)
                : l10n.revealPlayerRemaining(loser.name, loser.diceCount))
          : (loser.isHuman ? l10n.revealYouSunk : l10n.revealPlayerSunk);
      text =
          (loser.isHuman
              ? l10n.revealYouLoseDie
              : l10n.revealPlayerLoseDie(loser.name)) +
          rest;
    } else {
      text = l10n.revealNoLoser;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: color,
          fontFamily: AppTypography.body,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          height: 1.35,
        ),
      ),
    );
  }

  String _verdict(AppLocalizations l10n) {
    final outcome = widget.outcome;
    if (outcome.kind == ChallengeKind.dudo) {
      return outcome.bidHeld ? l10n.revealBidHeld : l10n.revealLiar;
    }
    return outcome.callerWon ? l10n.revealExactCount : l10n.revealMissed;
  }
}

class _DiceRow extends StatelessWidget {
  const _DiceRow({
    required this.player,
    required this.face,
    required this.palifico,
    required this.matches,
    required this.isBidder,
    required this.isCaller,
    required this.animation,
  });

  final Player player;
  final int face;
  final bool palifico;
  final int matches;
  final bool isBidder;
  final bool isCaller;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final role = isBidder
        ? l10n.revealRoleBidder
        : isCaller
        ? l10n.revealRoleCaller
        : l10n.revealRoleWaiter;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(
          children: [
            SizedBox(
              width: 84,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.isHuman ? 'Toi' : player.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: player.isHuman
                          ? AppColors.brassBright
                          : AppColors.parchment,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    role,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.parchmentMuted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final die in player.dice)
                    DiceFace(
                      value: die,
                      size: 25,
                      highlight: PerudoRules.dieMatches(
                        die,
                        face,
                        palifico: palifico,
                      ),
                      dimmed: !PerudoRules.dieMatches(
                        die,
                        face,
                        palifico: palifico,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 32,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: matches > 0
                    ? AppColors.brass.withValues(alpha: 0.14)
                    : AppColors.leatherDeep,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: matches > 0
                      ? AppColors.brassDim
                      : AppColors.grain.withValues(alpha: 0.7),
                ),
              ),
              child: Text(
                '$matches',
                style: AppTypography.inscription(
                  size: 15,
                  color: matches > 0
                      ? AppColors.brassBright
                      : AppColors.parchmentMuted,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

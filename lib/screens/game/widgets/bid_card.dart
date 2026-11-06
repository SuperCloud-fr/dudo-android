import 'package:flutter/material.dart';

import 'palifico_chip.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/dice_face.dart';
import '../../../game/models/bid.dart';

class BidCard extends StatelessWidget {
  const BidCard({
    super.key,
    required this.bid,
    required this.palifico,
    required this.bidderName,
    required this.totalDice,
    required this.starterName,
    required this.humanOpens,
  });

  final Bid? bid;
  final bool palifico;
  final String bidderName;
  final int totalDice;
  final String starterName;
  final bool humanOpens;

  @override
  Widget build(BuildContext context) {
    final current = bid;
    return Semantics(
      liveRegion: true,
      label: current == null
          ? 'Aucun pari. $starterName ouvre les hostilités.'
          : 'Pari en cours : ${current.spokenLabel}, annoncé par $bidderName. $totalDice dés en jeu.',
      excludeSemantics: true,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.12),
                end: Offset.zero,
              ).animate(animation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1).animate(animation),
                child: palifico
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PalificoChip(),
                          const SizedBox(height: 10),
                          child,
                        ],
                      )
                    : child,
              ),
            ),
          );
        },
        child: current == null
            ? _EmptyBid(
                key: const ValueKey('empty'),
                starterName: starterName,
                humanOpens: humanOpens,
                totalDice: totalDice,
                palifico: palifico,
              )
            : _FilledBid(
                key: ValueKey(
                  '${current.quantity}-${current.face}-${current.playerSeat}',
                ),
                bid: current,
                palifico: palifico,
                bidderName: bidderName,
                totalDice: totalDice,
              ),
      ),
    );
  }
}

class _FilledBid extends StatelessWidget {
  const _FilledBid({
    super.key,
    required this.bid,
    required this.palifico,
    required this.bidderName,
    required this.totalDice,
  });

  final Bid bid;
  final bool palifico;
  final String bidderName;
  final int totalDice;

  @override
  Widget build(BuildContext context) {
    return _BidShell(
      palifico: palifico,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'PARI EN COURS',
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: AppColors.brass, letterSpacing: 2.6),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${bid.quantity}',
                style: AppTypography.inscription(
                  size: 58,
                  color: AppColors.parchment,
                  letterSpacing: 0,
                  height: 0.95,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DiceFace(value: bid.face, size: 38),
                  const SizedBox(height: 4),
                  Text(
                    bid.isAces ? 'PACO' : 'DÉS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.brassBright,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            palifico && !bid.isAces
                ? 'Manche palifico : les paco ne comptent pas'
                : bid.isAces
                ? 'Seuls les paco comptent'
                : 'Les paco comptent pour cette face',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 11.5, color: AppColors.parchmentMuted),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person_outline,
                size: 13,
                color: AppColors.parchmentMuted,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  bidderName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.parchmentDim,
                    letterSpacing: 0.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: AppColors.brassDim,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$totalDice dés',
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: AppColors.parchmentMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyBid extends StatelessWidget {
  const _EmptyBid({
    super.key,
    required this.palifico,
    required this.starterName,
    required this.humanOpens,
    required this.totalDice,
  });

  final bool palifico;
  final String starterName;
  final bool humanOpens;
  final int totalDice;

  @override
  Widget build(BuildContext context) {
    return _BidShell(
      palifico: palifico,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DiceFace(value: 1, size: 34, dimmed: true),
          const SizedBox(height: 10),
          Text(
            'LA TABLE ATTEND',
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: AppColors.brass, letterSpacing: 2.6),
          ),
          const SizedBox(height: 6),
          Text(
            humanOpens ? 'À toi d\'ouvrir' : '$starterName ouvre',
            textAlign: TextAlign.center,
            style: AppTypography.inscription(
              size: 19,
              weight: FontWeight.w400,
              color: AppColors.parchment,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalDice dés sur la table',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _BidShell extends StatelessWidget {
  const _BidShell({required this.child, required this.palifico});

  final Widget child;
  final bool palifico;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 214, maxWidth: 260),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xF2271A12), Color(0xF5150E0A)],
        ),
        border: Border.all(color: AppColors.brassDim.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.brass.withValues(alpha: 0.06),
            blurRadius: 24,
          ),
        ],
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/ornaments.dart';
import '../../../core/widgets/tavern_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'palifico_chip.dart';

/// The round opener for a player with no dice left: nothing to shake, no
/// cup to lift — the table plays on without them.
class SpectatorPeekOverlay extends StatelessWidget {
  const SpectatorPeekOverlay({
    super.key,
    required this.round,
    required this.palifico,
    required this.canBeginBidding,
    required this.onReady,
  });

  final int round;
  final bool palifico;

  /// Host (or solo seat): the tap waves the round in. On a guest mirror the
  /// host's snapshot flips the phase instead, so a note replaces the button.
  final bool canBeginBidding;
  final VoidCallback onReady;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox.expand(
      child: Material(
        color: Colors.transparent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.1),
              radius: 1.1,
              colors: [AppColors.wood, AppColors.ink],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionLabel(l10n.peekRound(round)),
                      const SizedBox(height: 14),
                      Text(
                        l10n.peekSpectatorTitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.inscription(
                          size: 32,
                          color: AppColors.parchment,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.peekSpectatorBody,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: AppColors.parchmentMuted),
                      ),
                      if (palifico) ...[
                        const SizedBox(height: 14),
                        const Center(child: PalificoChip(size: 11)),
                      ],
                      const SizedBox(height: 24),
                      if (canBeginBidding)
                        TavernButton(
                          label: l10n.peekSpectatorCta,
                          icon: Icons.visibility_outlined,
                          expand: true,
                          onPressed: onReady,
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.leatherDeep.withValues(
                              alpha: 0.72,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.brassDim.withValues(alpha: 0.55),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.hourglass_bottom_outlined,
                                size: 18,
                                color: AppColors.brass,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  l10n.peekSpectatorWait,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.parchmentMuted,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

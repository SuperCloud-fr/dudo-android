import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// The red wax stamp shown whenever the table plays a palifico round.
class PalificoChip extends StatelessWidget {
  const PalificoChip({super.key, this.size = 11});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Manche palifico : une seule face imposée, paco non jokers',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.bloodDeep.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.bloodBright.withValues(alpha: 0.55),
          ),
        ),
        child: Text(
          'PALIFICO',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: AppColors.bloodBright,
            letterSpacing: 1.6,
          ),
        ),
      ),
    );
  }
}

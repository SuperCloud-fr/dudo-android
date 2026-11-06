import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// IA count controls inside the salon lobby (host only).
class SalonCrewCard extends StatelessWidget {
  const SalonCrewCard({
    super.key,
    required this.bots,
    required this.onMinus,
    required this.onPlus,
  });

  final int bots;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  static const Map<int, IconData> _sigils = {
    0: Icons.anchor,
    1: Icons.sailing,
    2: Icons.explore,
    3: Icons.local_fire_department,
    4: Icons.waves,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.leatherDeep.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grain),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'PIRATES IA',
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: AppColors.brassDim, letterSpacing: 1.6),
              ),
              const Spacer(),
              _CountButton(
                icon: Icons.remove,
                label: 'Retirer un pirate IA',
                onPressed: bots > 0 ? onMinus : null,
              ),
              const SizedBox(width: 10),
              Text(
                '$bots',
                style: AppTypography.inscription(
                  size: 24,
                  color: AppColors.brassBright,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(width: 10),
              _CountButton(
                icon: Icons.add,
                label: 'Ajouter un pirate IA',
                onPressed: bots < 5 ? onPlus : null,
              ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                for (var index = 0; index < bots && index < 5; index++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.leather,
                        border: Border.all(color: AppColors.brassDim),
                      ),
                      child: Icon(
                        _sigils[index] ?? Icons.person,
                        size: 15,
                        color:
                            AppColors.accents[index % AppColors.accents.length],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountButton extends StatelessWidget {
  const _CountButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.leather.withValues(alpha: 0.7),
            border: Border.all(
              color: enabled ? AppColors.brassDim : AppColors.grain,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Icon(
              icon,
              size: 22,
              color: enabled ? AppColors.parchment : AppColors.parchmentMuted,
            ),
          ),
        ),
      ),
    );
  }
}

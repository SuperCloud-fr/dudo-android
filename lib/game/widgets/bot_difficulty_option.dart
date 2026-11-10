import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../models/bot_difficulty_localized.dart';
import '../models/game_config.dart';

/// A selectable bot temperament, shared by solo setup and salon lobby.
class BotDifficultyOption extends StatelessWidget {
  const BotDifficultyOption({
    super.key,
    required this.difficulty,
    required this.selected,
    required this.onTap,
  });

  final BotDifficulty difficulty;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final level = difficulty.index + 1;
    return Semantics(
      button: true,
      selected: selected,
      label:
          '${difficulty.labelLocalized(l10n)}. ${difficulty.descriptionLocalized(l10n)}',
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            color: selected
                ? AppColors.brass.withValues(alpha: 0.10)
                : AppColors.leatherDeep.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.brass : AppColors.grain,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? AppColors.brass : AppColors.brassDim,
                        width: 1.4,
                      ),
                    ),
                    child: selected
                        ? Icon(
                            Icons.circle,
                            size: 10,
                            color: AppColors.brassBright,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          difficulty.labelLocalized(l10n),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: selected
                                    ? AppColors.brassBright
                                    : AppColors.parchment,
                                fontSize: 14,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          difficulty.descriptionLocalized(l10n),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.parchmentMuted,
                                fontSize: 11.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < 3; i++)
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i < level
                                  ? (selected
                                        ? AppColors.brassBright
                                        : AppColors.brassDim)
                                  : AppColors.grain,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

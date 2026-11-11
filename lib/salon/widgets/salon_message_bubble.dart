import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../salon_models.dart';

/// A salon chat entry shared by the lobby and the in-game chat sheet.
class SalonMessageBubble extends StatelessWidget {
  const SalonMessageBubble({super.key, required this.message});

  final SalonMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: message.isMine
              ? AppColors.brass.withValues(alpha: 0.16)
              : message.kind == SalonMessageKind.system
              ? AppColors.feltDeep.withValues(alpha: 0.6)
              : AppColors.leather,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: message.kind == SalonMessageKind.system
                ? AppColors.brassDim.withValues(alpha: 0.4)
                : message.isMine
                ? AppColors.brass.withValues(alpha: 0.4)
                : AppColors.grain,
          ),
        ),
        child: message.kind == SalonMessageKind.emoji
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.emoji ?? '',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    message.authorName,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: AppColors.parchmentMuted),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.authorName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: message.isMine
                          ? AppColors.brassBright
                          : AppColors.parchmentMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message.body,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: AppColors.parchment),
                  ),
                ],
              ),
      ),
    );
  }
}

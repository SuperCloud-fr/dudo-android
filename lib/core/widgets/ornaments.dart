import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class OrnamentDivider extends StatelessWidget {
  const OrnamentDivider({super.key, this.color});

  /// Falls back to the live brass-dim when unset, so the divider swaps
  /// palette with the app.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effective = color ?? AppColors.brassDim;
    return ExcludeSemantics(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    effective.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Transform.rotate(
              angle: 0.785,
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: effective.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effective.withValues(alpha: 0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium
        ?.copyWith(color: AppColors.brass, letterSpacing: 2.2);
    return Row(
      children: [
        Container(width: 14, height: 1, color: AppColors.brassDim),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}

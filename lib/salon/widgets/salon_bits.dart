import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Inline helpers used only by salon widgets to avoid pulling a package.
abstract final class HapticFeedbackFromPack {
  static void vibrate() {
    // Lightweight haptic util lives in core; kept local to scaffold the UI.
    // The real one belongs in core/widgets/tavern_haptics.dart later.
  }
}

abstract class SalonMessageLikeData {
  String get authorName;
  String get body;
  bool get isMine;
}

/// The lobby render for a piece of a message, adapted for demo data in
/// tests until the real backend writes typed messages into the stream.
class ProjectionMessage implements SalonMessageLikeData {
  const ProjectionMessage({
    required this.authorName,
    required this.body,
    required this.isMine,
  });

  @override
  final String authorName;
  @override
  final String body;
  @override
  final bool isMine;
}

/// SectionLabel clone for salon screens (keeps them DRY until extraction).
class SalonSectionLabel extends StatelessWidget {
  const SalonSectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 1, color: AppColors.brassDim),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: AppColors.brass, letterSpacing: 2.2),
        ),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}

/// Small centered gold title for salon screens.
class SalonTitle extends StatelessWidget {
  const SalonTitle(this.text, {super.key, this.size = 28});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTypography.inscription(
        size: size,
        color: AppColors.parchment,
        letterSpacing: 2,
      ),
    );
  }
}

/// Subtle hint line shared between salon screens.
class SalonHint extends StatelessWidget {
  const SalonHint(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium
          ?.copyWith(color: AppColors.parchmentMuted),
    );
  }
}

/// Tavern-styled text input wrapper used by create/join salon forms.
class SalonTextField extends StatelessWidget {
  const SalonTextField({
    super.key,
    required this.label,
    this.controller,
    this.inputFormatters,
    this.maxLength,
    this.textCapitalization = TextCapitalization.characters,
    this.autofocus = false,
  });

  final String label;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        label: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: AppColors.parchmentDim),
        ),
        filled: true,
        fillColor: AppColors.leatherDeep.withValues(alpha: 0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.brassDim),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.grain),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.brass, width: 1.4),
        ),
        counter: const SizedBox.shrink(),
      ),
      cursorColor: AppColors.brassBright,
    );
  }
}

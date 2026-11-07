import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum TavernButtonTone { gold, blood, ghost }

class TavernButton extends StatefulWidget {
  const TavernButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.tone = TavernButtonTone.gold,
    this.expand = false,
    this.compact = false,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final TavernButtonTone tone;
  final bool expand;
  final bool compact;
  final String? semanticLabel;

  @override
  State<TavernButton> createState() => _TavernButtonState();
}

class _TavernButtonState extends State<TavernButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (!_enabled || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final tone = widget.tone;
    final (foreground, gradient, border, glow) = switch (tone) {
      TavernButtonTone.gold => (
        AppColors.ink,
        LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.brassBright, AppColors.brass],
        ),
        AppColors.brassBright,
        AppColors.brass.withValues(alpha: 0.24),
      ),
      TavernButtonTone.blood => (
        AppColors.ivory,
        LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bloodBright, AppColors.blood],
        ),
        AppColors.bloodBright,
        AppColors.blood.withValues(alpha: 0.28),
      ),
      TavernButtonTone.ghost => (
        AppColors.parchment,
        const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C1D14), Color(0xFF1C120C)],
        ),
        AppColors.brassDim,
        Colors.transparent,
      ),
    };

    final radius = BorderRadius.circular(AppSpace.radiusPill);
    final height = widget.compact ? 48.0 : 54.0;

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel ?? widget.label,
      excludeSemantics: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        opacity: _enabled ? 1 : 0.38,
        child: AnimatedScale(
          scale: _pressed ? 0.975 : 1,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: Container(
            height: height,
            width: widget.expand ? double.infinity : null,
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                if (_enabled) BoxShadow(color: glow, blurRadius: 18),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: radius,
              clipBehavior: Clip.antiAlias,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: radius,
                  border: Border.all(color: border.withValues(alpha: 0.8)),
                ),
                child: InkWell(
                  onTap: _enabled
                      ? () {
                          HapticFeedback.lightImpact();
                          widget.onPressed!();
                        }
                      : null,
                  onTapDown: (_) => _setPressed(true),
                  onTapUp: (_) => _setPressed(false),
                  onTapCancel: () => _setPressed(false),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.compact ? 14 : 20,
                    ),
                    child: Row(
                      mainAxisSize: widget.expand
                          ? MainAxisSize.max
                          : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 19, color: foreground),
                          const SizedBox(width: 10),
                        ],
                        Flexible(
                          child: Text(
                            widget.label.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppTypography.inscription(
                              size: widget.compact ? 12 : 13,
                              color: foreground,
                              letterSpacing: 1.6,
                            ),
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
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.size = 48,
    this.highlighted = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final double size;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.leatherLight, AppColors.leatherDeep],
            ),
            border: Border.all(
              color: highlighted ? AppColors.brass : AppColors.brassDim,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onPressed!();
                  },
            child: Icon(
              icon,
              size: size * 0.48,
              color: highlighted
                  ? AppColors.brassBright
                  : AppColors.parchmentDim,
            ),
          ),
        ),
      ),
    );
  }
}

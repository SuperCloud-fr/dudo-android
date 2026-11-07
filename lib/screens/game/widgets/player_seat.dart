import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../game/models/player.dart';

class PlayerSeat extends StatelessWidget {
  const PlayerSeat({
    super.key,
    required this.player,
    required this.active,
    this.isBidder = false,
    this.avatarSize = 44,
    this.compact = false,
  });

  final Player player;
  final bool active;
  final bool isBidder;
  final double avatarSize;
  final bool compact;

  static const Map<int, IconData> _sigils = {
    0: Icons.anchor,
    1: Icons.sailing,
    2: Icons.explore,
    3: Icons.local_fire_department,
    4: Icons.waves,
    5: Icons.person,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = AppColors.accents[player.accent % AppColors.accents.length];
    final status = player.isOut
        ? l10n.seatOutStatus
        : active
        ? (player.isHuman ? l10n.seatYourTurn : l10n.seatThinking)
        : l10n.seatPlaying;
    final statusColor = player.isOut
        ? AppColors.parchmentMuted.withValues(alpha: 0.7)
        : active
        ? AppColors.brassBright
        : AppColors.parchmentMuted;

    return Semantics(
      label: l10n.seatSemantics(
        player.name,
        player.diceCount,
        status,
      ),
      excludeSemantics: true,
      child: Opacity(
        opacity: player.isOut ? 0.62 : 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (active) _ActiveHalo(size: avatarSize + 16),
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.3, -0.4),
                      colors: [
                        Color.lerp(AppColors.leatherLight, accent, 0.22)!,
                        AppColors.leatherDeep,
                      ],
                    ),
                    border: Border.all(
                      color: active
                          ? AppColors.brassBright
                          : accent.withValues(alpha: 0.6),
                      width: active ? 2 : 1.3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                      if (active)
                        BoxShadow(
                          color: AppColors.brass.withValues(alpha: 0.22),
                          blurRadius: 18,
                        ),
                    ],
                  ),
                  child: Icon(
                    _sigils[player.sigil] ?? Icons.person,
                    size: avatarSize * 0.46,
                    color: active ? AppColors.brassBright : accent,
                  ),
                ),
                if (isBidder)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.brass,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.circle,
                        size: 5,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: compact ? 4 : 6),
            Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style:
                  (compact
                          ? Theme.of(context).textTheme.labelSmall
                          : Theme.of(context).textTheme.titleSmall)
                      ?.copyWith(
                        color: active
                            ? AppColors.parchment
                            : AppColors.parchmentDim,
                        fontSize: compact ? 10 : 12,
                        fontWeight: FontWeight.w700,
                      ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 5; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Container(
                      width: 4.5,
                      height: 4.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < player.diceCount
                            ? accent
                            : AppColors.grain.withValues(alpha: 0.55),
                        border: Border.all(
                          color: i < player.diceCount
                              ? Colors.transparent
                              : AppColors.parchmentMuted.withValues(alpha: 0.2),
                          width: 0.6,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: compact ? 9 : 10,
                color: statusColor,
                letterSpacing: 0.3,
                fontStyle: active && active
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
              child: Text(status),
            ),
          ],
        ),
      ),
    );
  }
}

/// A soft gold halo that breathes around the seat whose turn it is.
class _ActiveHalo extends StatefulWidget {
  const _ActiveHalo({required this.size});

  final double size;

  @override
  State<_ActiveHalo> createState() => _ActiveHaloState();
}

class _ActiveHaloState extends State<_ActiveHalo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size.square(widget.size),
            painter: _HaloPainter(progress: _controller.value),
          );
        },
      ),
    );
  }
}

class _HaloPainter extends CustomPainter {
  _HaloPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.width / 2;
    for (var ring = 0; ring < 2; ring++) {
      final t = (progress + ring * 0.5) % 1;
      final radius = maxRadius * (0.62 + t * 0.38);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = AppColors.brass.withValues(alpha: 0.22 * (1 - t)),
      );
    }
    canvas.drawCircle(
      center,
      maxRadius * 0.62,
      Paint()..color = AppColors.brass.withValues(alpha: 0.04),
    );
  }

  @override
  bool shouldRepaint(covariant _HaloPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/dice_face.dart';
import '../../../core/widgets/ornaments.dart';

class DiceTray extends StatelessWidget {
  const DiceTray({
    super.key,
    required this.dice,
    required this.diceCount,
    this.active = false,
  });

  final List<int> dice;
  final int diceCount;
  final bool active;

  static const _angles = [-0.045, 0.035, -0.02, 0.05, -0.03];

  @override
  Widget build(BuildContext context) {
    final values = dice.isEmpty ? List<int>.filled(diceCount, 1) : dice;
    return Semantics(
      label:
          'Ta main : ${values.map((die) => die == 1 ? 'as' : '$die').join(', ')}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B3E31), Color(0xFF0E2A20)],
          ),
          border: Border.all(
            color: active
                ? AppColors.brassBright
                : AppColors.brassDim.withValues(alpha: 0.65),
            width: active ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
            if (active)
              BoxShadow(
                color: AppColors.brass.withValues(alpha: 0.18),
                blurRadius: 22,
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionLabel(
              'Ta main',
              trailing: Text(
                '${values.length} ${values.length == 1 ? 'dé' : 'dés'} · as joker',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.parchmentMuted,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final size = ((constraints.maxWidth - 4 * 10) / 5).clamp(
                  38.0,
                  54.0,
                );
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var index = 0; index < values.length; index++)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: index == values.length - 1 ? 0 : 5,
                        ),
                        child: DiceFace(
                          value: values[index],
                          size: size,
                          rotation: _angles[index % _angles.length],
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryStrip extends StatelessWidget {
  const HistoryStrip({super.key, required this.events, required this.names});

  final List<TableEventView> events;
  final Map<int, String> names;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox(height: 28);
    }
    return SizedBox(
      height: 28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: events.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final event = events[index];
          final color = switch (event.kind) {
            TableEventViewKind.bid => AppColors.parchmentDim,
            TableEventViewKind.dudo => AppColors.bloodBright,
            TableEventViewKind.calza => AppColors.brassBright,
          };
          final background = switch (event.kind) {
            TableEventViewKind.bid => AppColors.leatherDeep,
            TableEventViewKind.dudo => AppColors.bloodDeep,
            TableEventViewKind.calza => const Color(0xFF3A2C14),
          };
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: background.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.label,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 2.5,
                  height: 2.5,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  names[event.playerSeat] ?? '',
                  style: Theme.of(context).textTheme.bodySmall!
                      .copyWith(fontSize: 11, color: AppColors.parchmentMuted),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

enum TableEventViewKind { bid, dudo, calza }

class TableEventView {
  const TableEventView({
    required this.playerSeat,
    required this.kind,
    required this.label,
  });

  final int playerSeat;
  final TableEventViewKind kind;
  final String label;
}

class ThinkingDots extends StatefulWidget {
  const ThinkingDots({super.key, this.color = AppColors.brassBright});

  final Color color;

  @override
  State<ThinkingDots> createState() => _ThinkingDotsState();
}

class _ThinkingDotsState extends State<ThinkingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0.5;
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
    return Semantics(
      label: 'réfléchit',
      excludeSemantics: true,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < 3; index++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5),
                  child: Opacity(
                    opacity:
                        0.25 +
                        0.75 *
                            (0.5 +
                                0.5 *
                                    _wave(
                                      (_controller.value + index * 0.22) % 1,
                                    )),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: widget.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  double _wave(double t) {
    return (t < 0.5 ? t * 2 : (1 - t) * 2) * 2 - 1;
  }
}

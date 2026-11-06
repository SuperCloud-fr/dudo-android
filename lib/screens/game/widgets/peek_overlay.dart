import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import 'palifico_chip.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/dice_face.dart';
import '../../../core/widgets/leather_cup.dart';
import '../../../core/widgets/ornaments.dart';
import '../../../core/widgets/tavern_button.dart';

/// The ritual that opens every round: the cup, the dice, the private look.
class PeekOverlay extends StatefulWidget {
  const PeekOverlay({
    super.key,
    required this.round,
    required this.dice,
    required this.palifico,
    required this.humanStarts,
    required this.starterName,
    required this.onReady,
  });

  final int round;
  final List<int> dice;
  final bool palifico;
  final bool humanStarts;
  final String starterName;
  final VoidCallback onReady;

  @override
  State<PeekOverlay> createState() => _PeekOverlayState();
}

class _PeekOverlayState extends State<PeekOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reveal;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _reveal = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) && _revealed) {
      _reveal.value = 1;
    }
  }

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  void _liftCup() {
    if (_revealed) return;
    HapticFeedback.mediumImpact();
    setState(() => _revealed = true);
    if (MediaQuery.disableAnimationsOf(context)) {
      _reveal.value = 1;
    } else {
      _reveal.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final aces = widget.dice.where((die) => die == 1).length;
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 42,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SectionLabel('Manche ${widget.round}'),
                            const SizedBox(height: 14),
                            Text(
                              'Ton gobelet',
                              textAlign: TextAlign.center,
                              style: AppTypography.inscription(
                                size: 32,
                                color: AppColors.parchment,
                                letterSpacing: 2.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _revealed
                                  ? 'Garde ce secret. Le reste de la table ne voit rien.'
                                  : 'Soulève le cuir. Personne d\'autre ne verra tes dés.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.parchmentMuted),
                            ),
                            if (widget.palifico) ...[
                              const SizedBox(height: 14),
                              const Center(child: PalificoChip(size: 11)),
                              const SizedBox(height: 8),
                              Text(
                                'Manche palifico : une seule face pour tous les paris.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(height: 8),
                            ],
                            const SizedBox(height: 20),
                            _buildCupAndDice(context),
                            const SizedBox(height: 18),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 280),
                              child: _revealed
                                  ? Column(
                                      key: const ValueKey('revealed'),
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Center(
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxWidth: 320,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 7,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.leatherDeep
                                                    .withValues(alpha: 0.8),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                                border: Border.all(
                                                  color: AppColors.brassDim
                                                      .withValues(alpha: 0.5),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.casino_outlined,
                                                    size: 15,
                                                    color:
                                                        AppColors.brassBright,
                                                  ),
                                                  const SizedBox(width: 7),
                                                  Flexible(
                                                    child: Text(
                                                      '${widget.dice.length} '
                                                      '${widget.dice.length == 1 ? 'dé' : 'dés'} en main',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium
                                                          ?.copyWith(
                                                            color: AppColors
                                                                .parchment,
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 9),
                                                  Container(
                                                    width: 3,
                                                    height: 3,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: AppColors
                                                              .brassDim,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 9),
                                                  Flexible(
                                                    child: Text(
                                                      aces == 0
                                                          ? 'pas de paco'
                                                          : aces == 1
                                                          ? '1 paco'
                                                          : '$aces paco',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium
                                                          ?.copyWith(
                                                            color: aces == 0
                                                                ? AppColors
                                                                      .parchmentMuted
                                                                : AppColors
                                                                      .bloodBright,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          widget.palifico
                                              ? 'Manche palifico : les paco ne comptent que comme paco.'
                                              : 'Les paco comptent pour toutes les faces.',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.parchmentMuted,
                                              ),
                                        ),
                                        const SizedBox(height: 20),
                                        TavernButton(
                                          label: widget.humanStarts
                                              ? 'Ouvrir les hostilités'
                                              : 'C’est à ${widget.starterName} d’ouvrir',
                                          icon: Icons.visibility_outlined,
                                          expand: true,
                                          onPressed: widget.onReady,
                                        ),
                                      ],
                                    )
                                  : _CupHint(
                                      key: const ValueKey('hint'),
                                      onTap: _liftCup,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCupAndDice(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Center(
      child: SizedBox(
        height: 236,
        child: AnimatedBuilder(
          animation: _reveal,
          builder: (context, _) {
            final lift = reduced
                ? (_revealed ? 1.0 : 0.0)
                : Curves.easeInOutCubic.transform(
                    (_reveal.value / 0.55).clamp(0.0, 1.0),
                  );
            final diceProgress = reduced
                ? (_revealed ? 1.0 : 0.0)
                : Curves.easeOutCubic.transform(
                    ((_reveal.value - 0.2) / 0.8).clamp(0.0, 1.0),
                  );
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0, 0.62),
                          radius: 0.9,
                          colors: [
                            AppColors.candle.withValues(alpha: 0.07),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Felt tray.
                Container(
                  margin: const EdgeInsets.fromLTRB(6, 128, 6, 0),
                  height: 86,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1C4939), Color(0xFF0C291F)],
                    ),
                    border: Border.all(
                      color: AppColors.brassDim.withValues(alpha: 0.6),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 24,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (var index = 0; index < widget.dice.length; index++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Opacity(
                            opacity: _revealed
                                ? (0.35 + 0.65 * diceProgress).clamp(0.0, 1.0)
                                : 0.0,
                            child: Transform.rotate(
                              angle:
                                  (index.isEven ? -1 : 1) *
                                  0.05 *
                                  (1 - diceProgress),
                              child: DiceFace(
                                value: widget.dice[index],
                                size: 48,
                                highlight: widget.dice[index] == 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Transform.translate(
                    offset: Offset(math.sin(lift * math.pi) * 22, -118 * lift),
                    child: Transform.rotate(
                      angle: -0.16 * lift,
                      child: Opacity(
                        opacity: (1 - lift).clamp(0.0, 1.0),
                        child: GestureDetector(
                          onTap: _liftCup,
                          behavior: HitTestBehavior.opaque,
                          child: Semantics(
                            button: true,
                            label: 'Soulever le gobelet pour voir tes dés',
                            child: const LeatherCup(size: 176),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CupHint extends StatelessWidget {
  const _CupHint({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.touch_app_outlined, size: 18),
          label: const Text('Touche le gobelet pour révéler tes dés'),
        ),
        const SizedBox(height: 4),
        Text(
          'Prends ton temps. Les autres pirates attendent.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

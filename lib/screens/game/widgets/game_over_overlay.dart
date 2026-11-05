import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/ornaments.dart';
import '../../../core/widgets/tavern_button.dart';
import '../../../game/models/player.dart';

class GameOverOverlay extends StatefulWidget {
  const GameOverOverlay({
    super.key,
    required this.result,
    required this.players,
    required this.difficultyLabel,
    required this.onRematch,
    required this.onMenu,
  });

  final GameResult result;
  final List<Player> players;
  final String difficultyLabel;
  final VoidCallback onRematch;
  final VoidCallback onMenu;

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  static const Map<int, IconData> _sigils = {
    0: Icons.anchor,
    1: Icons.sailing,
    2: Icons.explore,
    3: Icons.local_fire_department,
    4: Icons.waves,
    5: Icons.person,
  };

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _entrance.value = 1;
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final won = widget.result.humanWon;
    final winner = widget.players[widget.result.winnerSeat];
    final accent = won ? AppColors.brassBright : AppColors.bloodBright;
    final scale = MediaQuery.disableAnimationsOf(context)
        ? 1.0
        : Curves.easeOutBack.transform((_entrance.value / 0.7).clamp(0.0, 1.0));

    return SizedBox.expand(
      child: Material(
        color: Colors.transparent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.25),
              radius: 1.2,
              colors: [
                won ? const Color(0xFF2C1D14) : const Color(0xFF2A100D),
                AppColors.ink,
              ],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 44,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Opacity(
                          opacity: _entrance.value.clamp(0.0, 1.0),
                          child: Transform.scale(
                            scale: 0.94 + scale * 0.06,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SectionLabel(
                                  won
                                      ? 'La taverne est à toi'
                                      : 'Fin de l\'aventure',
                                  trailing: Text(
                                    widget.difficultyLabel.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: AppColors.brassDim),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: Container(
                                    width: 104,
                                    height: 104,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          accent.withValues(alpha: 0.35),
                                          AppColors.leatherDeep,
                                        ],
                                      ),
                                      border: Border.all(
                                        color: accent,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: accent.withValues(alpha: 0.24),
                                          blurRadius: 32,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      won
                                          ? Icons.emoji_events_outlined
                                          : Icons.waves,
                                      size: 50,
                                      color: accent,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  won ? 'TU RÈGNES' : 'PAR-DESSUS BORD',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: AppTypography.inscription(
                                    size: won ? 40 : 30,
                                    color: won
                                        ? AppColors.brassBright
                                        : AppColors.parchment,
                                    letterSpacing: won ? 4 : 2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  won
                                      ? 'L\'équipage a rendu les armes. La dernière chope est pour toi.'
                                      : 'Les pirates t\'ont eu. ${winner.name} garde la main sur le tonneau.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.parchmentMuted,
                                      ),
                                ),
                                const SizedBox(height: 18),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 8,
                                  children: [
                                    _Stat(
                                      value: '${widget.result.rounds}',
                                      label: 'manches',
                                    ),
                                    _Stat(
                                      value: '${widget.result.humanDiceLeft}',
                                      label: 'dés restants',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'LE DERNIER MOT',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: AppColors.brassDim,
                                        letterSpacing: 2,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                ..._standings(context, accent),
                                const SizedBox(height: 22),
                                TavernButton(
                                  label: 'Rejouer',
                                  icon: Icons.replay,
                                  expand: true,
                                  onPressed: widget.onRematch,
                                ),
                                const SizedBox(height: 10),
                                TavernButton(
                                  label: 'Retour à la taverne',
                                  icon: Icons.home_outlined,
                                  tone: TavernButtonTone.ghost,
                                  expand: true,
                                  onPressed: widget.onMenu,
                                ),
                              ],
                            ),
                          ),
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

  List<Widget> _standings(BuildContext context, Color accent) {
    return [
      for (var index = 0; index < widget.result.standings.length; index++)
        Builder(
          builder: (context) {
            final seat = widget.result.standings[index];
            final player = widget.players[seat];
            final isWinner = seat == widget.result.winnerSeat;
            final color = player.isHuman
                ? AppColors.brassBright
                : AppColors.parchment;
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: player.isHuman
                    ? AppColors.brass.withValues(alpha: 0.08)
                    : AppColors.leatherDeep.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: player.isHuman
                      ? AppColors.brassDim.withValues(alpha: 0.7)
                      : AppColors.grain.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    child: Text(
                      '${index + 1}',
                      style: AppTypography.inscription(
                        size: 14,
                        color: isWinner ? accent : AppColors.parchmentMuted,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.leather,
                      border: Border.all(
                        color: isWinner
                            ? accent
                            : AppColors.brassDim.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Icon(
                      _sigils[player.sigil] ?? Icons.person,
                      size: 14,
                      color: isWinner ? accent : AppColors.parchmentMuted,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      player.isHuman ? 'Toi' : player.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(color: color, fontSize: 13),
                    ),
                  ),
                  if (isWinner)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.workspace_premium_outlined,
                        size: 15,
                        color: AppColors.brassBright,
                      ),
                    ),
                  Text(
                    player.diceCount == 0
                        ? 'à l\'eau'
                        : '${player.diceCount} ${player.diceCount == 1 ? 'dé' : 'dés'}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: player.isHuman
                          ? AppColors.brass
                          : AppColors.parchmentMuted,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
    ];
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.leatherDeep.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grain.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            value,
            style: AppTypography.inscription(
              size: 22,
              color: AppColors.brassBright,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: AppColors.parchmentMuted),
          ),
        ],
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ornaments.dart';
import '../../core/widgets/tavern_background.dart';
import '../../core/widgets/tavern_button.dart';
import '../../game/models/game_config.dart';
import '../game/game_screen.dart';
import '../rules/rules_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _opponents = 3;
  BotDifficulty _difficulty = BotDifficulty.flibustier;
  bool _calza = true;

  void _setOpponents(int value) {
    final next = value.clamp(1, 5);
    if (next == _opponents) return;
    setState(() => _opponents = next);
  }

  void _start() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => GameScreen(
          config: GameConfig(
            opponentCount: _opponents,
            difficulty: _difficulty,
            calzaEnabled: _calza,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crewNames = crew
        .take(_opponents)
        .map((profile) => profile.name)
        .join(', ');
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: TavernBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SizedBox(
                  width: math.min(560, constraints.maxWidth),
                  height: constraints.maxHeight,
                  child: Column(
                    children: [
                      _buildTopBar(context),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 26),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'L\'équipage',
                                style: AppTypography.inscription(
                                  size: 30,
                                  color: AppColors.parchment,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Choisis combien de pirates vont te mentir ce soir.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.parchmentMuted),
                              ),
                              const SizedBox(height: 22),
                              _CrewSizeCard(
                                opponents: _opponents,
                                onMinus: () => _setOpponents(_opponents - 1),
                                onPlus: () => _setOpponents(_opponents + 1),
                                crewNames: crewNames,
                              ),
                              const SizedBox(height: 22),
                              const SectionLabel('Le tempérament des bots'),
                              const SizedBox(height: 10),
                              for (final difficulty in BotDifficulty.values)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _DifficultyOption(
                                    difficulty: difficulty,
                                    selected: _difficulty == difficulty,
                                    onTap: () {
                                      setState(() => _difficulty = difficulty);
                                    },
                                  ),
                                ),
                              const SizedBox(height: 12),
                              _CalzaCard(
                                value: _calza,
                                onChanged: (value) {
                                  setState(() => _calza = value);
                                },
                              ),
                              const SizedBox(height: 24),
                              TavernButton(
                                label: 'Larguer les amarres',
                                icon: Icons.anchor,
                                expand: true,
                                onPressed: _start,
                              ),
                              const SizedBox(height: 4),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => const RulesScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.menu_book_outlined,
                                  size: 17,
                                ),
                                label: const Text('Relire les règles'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Row(
        children: [
          RoundIconButton(
            icon: Icons.arrow_back,
            semanticLabel: 'Retour',
            onPressed: () => Navigator.of(context).pop(),
            size: 48,
          ),
          Expanded(
            child: Text(
              'NOUVELLE PARTIE',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: AppColors.brass, letterSpacing: 2.2),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _CrewSizeCard extends StatelessWidget {
  const _CrewSizeCard({
    required this.opponents,
    required this.onMinus,
    required this.onPlus,
    required this.crewNames,
  });

  final int opponents;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final String crewNames;

  @override
  Widget build(BuildContext context) {
    final players = opponents + 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1B12), Color(0xFF150E09)],
        ),
        border: Border.all(color: AppColors.brassDim.withValues(alpha: 0.55)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PIRATES À TA TABLE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.brassDim,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$players joueurs',
                      style: AppTypography.inscription(
                        size: 20,
                        color: AppColors.parchment,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              _CountButton(
                icon: Icons.remove,
                label: 'Retirer un pirate',
                onPressed: opponents > 1 ? onMinus : null,
              ),
              const SizedBox(width: 8),
              _CountButton(
                icon: Icons.add,
                label: 'Ajouter un pirate',
                onPressed: opponents < 5 ? onPlus : null,
              ),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _CrewAvatar(
                  sigil: 5,
                  accent: 3,
                  name: 'Toi',
                  selected: true,
                ),
                for (var index = 0; index < crew.length; index++)
                  _CrewAvatar(
                    sigil: crew[index].sigil,
                    accent: crew[index].accent,
                    name: crew[index].name,
                    selected: index < opponents,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Toi + $opponents ${opponents == 1 ? 'pirate' : 'pirates'} : $crewNames',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppColors.parchmentMuted, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

class _CrewAvatar extends StatelessWidget {
  const _CrewAvatar({
    required this.sigil,
    required this.accent,
    required this.name,
    required this.selected,
  });

  final int sigil;
  final int accent;
  final String name;
  final bool selected;

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
    final color = AppColors.accents[accent % AppColors.accents.length];
    return Semantics(
      label: '$name, ${selected ? 'à table' : 'absent'}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: selected ? 1 : 0.28,
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color.lerp(AppColors.leatherLight, color, 0.2)!,
                      AppColors.leatherDeep,
                    ],
                  ),
                  border: Border.all(
                    color: selected
                        ? (sigil == 5 ? AppColors.brassBright : color)
                        : AppColors.grain,
                    width: selected ? 1.6 : 1,
                  ),
                ),
                child: Icon(
                  _sigils[sigil] ?? Icons.person,
                  size: 19,
                  color: selected ? color : AppColors.parchmentMuted,
                ),
              ),
            ],
          ),
        ),
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
          width: 48,
          height: 48,
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

class _DifficultyOption extends StatelessWidget {
  const _DifficultyOption({
    required this.difficulty,
    required this.selected,
    required this.onTap,
  });

  final BotDifficulty difficulty;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final level = difficulty.index + 1;
    return Semantics(
      button: true,
      selected: selected,
      label: '${difficulty.label}. ${difficulty.description}',
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
                          difficulty.label,
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
                          difficulty.description,
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

class _CalzaCard extends StatelessWidget {
  const _CalzaCard({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
      decoration: BoxDecoration(
        color: AppColors.leatherDeep.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grain),
      ),
      child: Row(
        children: [
          Icon(Icons.gps_fixed, size: 20, color: AppColors.brass),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calza autorisée',
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(color: AppColors.parchment, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  'Annoncer le compte exact rapporte un dé. Optionnel, mais féroce.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.parchmentMuted,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/dice_face.dart';
import '../../core/widgets/tavern_background.dart';
import '../../core/widgets/tavern_button.dart';
import '../../game/models/bid.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: TavernBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SizedBox(
                  width: constraints.maxWidth.clamp(0, 600),
                  height: constraints.maxHeight,
                  child: Column(
                    children: [
                      _buildTopBar(context),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Le jeu du mensonge',
                                maxLines: 2,
                                style: AppTypography.inscription(
                                  size: 30,
                                  color: AppColors.parchment,
                                  letterSpacing: 1.6,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Perudo, Dudo, Cacho… peu importe le nom. '
                                'Les dés ne mentent pas. Les pirates, si.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.parchmentMuted),
                              ),
                              const SizedBox(height: 18),
                              _DiceShowcase(),
                              const SizedBox(height: 26),
                              const _RuleSection(
                                number: 1,
                                title: 'Le but',
                                child: Text(
                                  'Rester le dernier pirate avec au moins un dé. '
                                  'Chaque manche, on parie sur ce que cachent les gobelets. '
                                  'Celui qui se trompe perd un dé.',
                                ),
                              ),
                              const _RuleSection(
                                number: 2,
                                title: 'Ton gobelet',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Chacun reçoit cinq dés et les cache sous son gobelet. '
                                      'Tu regardes les tiens en secret.',
                                    ),
                                    SizedBox(height: 10),
                                    _Callout(
                                      icon: Icons.auto_awesome,
                                      title: 'Les paco sont jokers',
                                      text:
                                          'Un paco (1) compte pour n\'importe quelle face. '
                                          'Il ne compte que comme un paco quand le pari porte sur les paco. '
                                          'Un paco vaut donc deux dés normaux au moment de surenchérir.',
                                    ),
                                  ],
                                ),
                              ),
                              _RuleSection(
                                number: 3,
                                title: 'Le pari',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Un pari a deux nombres : une quantité et une face.',
                                    ),
                                    const SizedBox(height: 10),
                                    _BidExample(),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Ici, le pirate affirme qu\'il y a au moins quatre dés '
                                      'de valeur 5 sur toute la table. Les as comptent aussi.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ),
                              _RuleSection(
                                number: 4,
                                title: 'Surenchérir',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Le pari suivant doit toujours être plus fort :',
                                    ),
                                    SizedBox(height: 8),
                                    _Bullet(
                                      'Plus de dés sur la même face : 4 dés de 5 → 5 dés de 5.',
                                    ),
                                    _Bullet(
                                      'Même nombre, face plus haute : 4 dés de 5 → 4 dés de 6.',
                                    ),
                                    _Bullet(
                                      'Vers les paco : au moins la moitié, arrondie au-dessus : '
                                      '4 dés de 5 → 2 paco.',
                                    ),
                                    _Bullet(
                                      'Depuis les paco : le double plus un : '
                                      '2 paco → 5 dés de n\'importe quelle face.',
                                    ),
                                    SizedBox(height: 10),
                                    _ConversionRow(),
                                  ],
                                ),
                              ),
                              const _RuleSection(
                                number: 5,
                                title: 'Dudo !',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Au lieu de surenchérir, tu peux douter du dernier pari. '
                                      'Tout le monde soulève son gobelet et on compte.',
                                    ),
                                    SizedBox(height: 10),
                                    _VerdictRow(
                                      leftTitle: 'Le pari tient',
                                      leftText: 'Le douteur perd un dé.',
                                      rightTitle: 'Le pari est faux',
                                      rightText: 'Le parieur perd un dé.',
                                      leftIcon: Icons.check_circle_outline,
                                      rightIcon: Icons.cancel_outlined,
                                    ),
                                  ],
                                ),
                              ),
                              const _RuleSection(
                                number: 6,
                                title: 'Calza — optionnel',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tu peux aussi annoncer que le compte est exactement bon. '
                                      'C\'est la calza.',
                                    ),
                                    SizedBox(height: 10),
                                    _Callout(
                                      icon: Icons.gps_fixed,
                                      title: 'Tout ou rien',
                                      text:
                                          'Compte exact : tu gagnes un dé (cinq maximum). '
                                          'Compte faux : tu en perds un. '
                                          'La calza peut être désactivée avant la partie.',
                                    ),
                                  ],
                                ),
                              ),
                              const _RuleSection(
                                number: 7,
                                title: 'La fin',
                                child: Text(
                                  'Un pirate qui perd son dernier dé est à l\'eau. '
                                  'Le dernier survivant gagne la taverne. '
                                  'Le perdant de la manche ouvre la suivante.',
                                ),
                              ),

                              _RuleSection(
                                number: 8,
                                title: 'Palifico',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quand un pirate tombe à un seul dé, la manche suivante devient palifico : le ton monte, et les paris se verrouillent.',
                                    ),
                                    const SizedBox(height: 10),
                                    _Callout(
                                      icon: Icons.lock_outline,
                                      title: 'Face imposée',
                                      text: 'Le premier pari choisit la face. Tous les suivants doivent monter la quantité de cette même face ; impossible de changer de valeur.',
                                    ),
                                    const SizedBox(height: 10),
                                    _Callout(
                                      icon: Icons.push_pin_outlined,
                                      title: 'Paco sans joker',
                                      text: 'Les paco ne comptent que comme paco. L\'ouverture se fait avec au moins deux dés.',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.brassDim.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  color: AppColors.brass.withValues(
                                    alpha: 0.06,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.lightbulb_outline,
                                      size: 20,
                                      color: AppColors.brassBright,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Le meilleur bluff est celui que personne n\'a envie de payer.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.brassBright,
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 22),
                              TavernButton(
                                label: 'J\'ai compris',
                                icon: Icons.check,
                                expand: true,
                                onPressed: () => Navigator.of(context).pop(),
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
              'LES RÈGLES',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: AppColors.brass, letterSpacing: 2.4),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _DiceShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B3E31), Color(0xFF0C291F)],
        ),
        border: Border.all(color: AppColors.brassDim.withValues(alpha: 0.55)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var value = 1; value <= 5; value++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DiceFace(
                    value: value,
                    size: 46,
                    rotation: (value - 3) * 0.035,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Cinq dés, un paco joker, et aucune raison de dire la vérité.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppColors.parchmentDim, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _RuleSection extends StatelessWidget {
  const _RuleSection({
    required this.number,
    required this.title,
    required this.child,
  });

  final int number;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brass.withValues(alpha: 0.12),
                  border: Border.all(color: AppColors.brassDim),
                ),
                child: Text(
                  '$number',
                  style: AppTypography.inscription(
                    size: 13,
                    color: AppColors.brassBright,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: AppTypography.inscription(
                      size: 20,
                      color: AppColors.parchment,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DefaultTextStyle.merge(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.parchmentDim,
              fontSize: 14.5,
              height: 1.5,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 38),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.brass,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.parchmentDim,
                fontSize: 13.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  const _Callout({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.leatherDeep.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grain),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: AppColors.brass),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.brassBright,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.parchmentMuted,
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BidExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const bid = Bid(quantity: 4, face: 5, playerSeat: 0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.leatherDeep.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.brassDim.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Text(
            '${bid.quantity}',
            style: AppTypography.inscription(
              size: 36,
              color: AppColors.parchment,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(width: 10),
          const DiceFace(value: 5, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '« Il y a au moins 4 dés de 5 sur la table. »',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.parchmentDim,
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        _Conversion(from: '4 dés de 5', to: '2 as'),
        _Conversion(from: '2 as', to: '5 dés de 2'),
        _Conversion(from: '5 dés de 6', to: '3 as'),
      ],
    );
  }
}

class _Conversion extends StatelessWidget {
  const _Conversion({required this.from, required this.to});

  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.leatherDeep.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.grain),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            from,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: AppColors.parchmentMuted),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.arrow_forward,
              size: 11,
              color: AppColors.brassDim,
            ),
          ),
          Text(
            to,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: AppColors.brassBright),
          ),
        ],
      ),
    );
  }
}

class _VerdictRow extends StatelessWidget {
  const _VerdictRow({
    required this.leftTitle,
    required this.leftText,
    required this.rightTitle,
    required this.rightText,
    required this.leftIcon,
    required this.rightIcon,
  });

  final String leftTitle;
  final String leftText;
  final String rightTitle;
  final String rightText;
  final IconData leftIcon;
  final IconData rightIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Verdict(
            title: leftTitle,
            text: leftText,
            icon: leftIcon,
            color: AppColors.parchmentDim,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Verdict(
            title: rightTitle,
            text: rightText,
            icon: rightIcon,
            color: AppColors.bloodBright,
          ),
        ),
      ],
    );
  }
}

class _Verdict extends StatelessWidget {
  const _Verdict({
    required this.title,
    required this.text,
    required this.icon,
    required this.color,
  });

  final String title;
  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(height: 5),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.parchmentMuted,
              fontSize: 11.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

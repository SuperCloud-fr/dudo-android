import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tavern_background.dart';
import '../../l10n/generated/app_localizations.dart';

/// Réglages : the look of the tavern lives here. Picking an atmosphere
/// repaints every screen through [PaletteStore]; the choice rides in
/// shared preferences and survives relaunches.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: TavernBackground(
        child: SafeArea(
          child: PaletteView(
            builder: (context, palette) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: SizedBox(
                      width: constraints.maxWidth.clamp(0, 600),
                      height: constraints.maxHeight,
                      child: Column(
                        children: [
                          _topBar(context, l10n.settingsTitle),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    l10n.settingsAmbienceTitle,
                                    style: AppTypography.inscription(
                                      size: 30,
                                      color: AppColors.parchment,
                                      letterSpacing: 1.6,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.settingsAmbienceHint,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.parchmentMuted,
                                        ),
                                  ),
                                  const SizedBox(height: 22),
                                  for (final look in AppPalette.all) ...[
                                    _LookCard(
                                      look: look,
                                      active: identical(look, palette),
                                    ),
                                    const SizedBox(height: 14),
                                  ],
                                  const SizedBox(height: 4),
                                  const _PrivacyPolicyLink(),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, size: 22),
            color: AppColors.parchment,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.brass,
                letterSpacing: 2.4,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// The Play-store-housekeeping row: the privacy policy page lives on our
/// own site and must be reachable from the app (Google Play data-safety
/// form requirement).
class _PrivacyPolicyLink extends StatelessWidget {
  const _PrivacyPolicyLink();

  static const policyUrl = 'https://dudo.supercloud.fr/politique-de-confidentialite';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: TextButton.icon(
        onPressed: () async {
          final uri = Uri.parse(policyUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        icon: const Icon(Icons.privacy_tip_outlined, size: 16),
        label: Text(
          l10n.settingsPrivacyPolicy,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.parchmentMuted,
          ),
        ),
      ),
    );
  }
}

class _LookCard extends StatelessWidget {  const _LookCard({required this.look, required this.active});

  final AppPalette look;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final border = active
        ? AppColors.brass
        : AppColors.brassDim.withValues(alpha: 0.6);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          if (active) return;
          HapticFeedback.selectionClick();
          PaletteStore.select(look);
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppColors.leatherDeep.withValues(alpha: 0.85),
            border: Border.all(color: border, width: active ? 1.4 : 1),
          ),
          child: Row(
            children: [
              const SizedBox(width: 1),
              _LookPreview(look: look),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      look.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.parchment,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      active ? l10n.lookChosen : l10n.lookPick,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: active
                            ? AppColors.brass
                            : AppColors.parchmentMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (active)
                Icon(
                  Icons.check_circle_outline,
                  size: 22,
                  color: AppColors.brass,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A miniature table painted with the candidate palette: wood ground,
/// felt stage, dice ivory and pips — exactly the roles in play.
class _LookPreview extends StatelessWidget {
  const _LookPreview({required this.look});

  final AppPalette look;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.brassDim.withValues(alpha: 0.55),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(color: look.wood),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: look.felt,
                alignment: Alignment.center,
                child: _MiniDie(palette: look),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(color: look.leather),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniDie extends StatelessWidget {
  const _MiniDie({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: palette.ivory,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: palette.dieEdge, width: 1),
      ),
      child: Icon(
        Icons.circle_outlined,
        size: 9,
        color: palette.ace,
      ),
    );
  }
}

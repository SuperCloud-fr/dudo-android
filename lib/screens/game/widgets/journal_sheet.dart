import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/ornaments.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../game/models/player.dart';
import '../../../game/models/table_event.dart';

class JournalSheet extends StatelessWidget {
  const JournalSheet({
    super.key,
    required this.events,
    required this.players,
    required this.currentRound,
  });

  final List<TableEvent> events;
  final List<Player> players;
  final int currentRound;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rounds = <int, List<TableEvent>>{};
    for (final event in events) {
      rounds.putIfAbsent(event.round, () => []).add(event);
    }
    final roundNumbers = rounds.keys.toList()..sort((a, b) => b.compareTo(a));

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.82,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C1D14), Color(0xFF130D08)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: AppColors.brassDim)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.brassDim.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionLabel(l10n.journalTitle),
                          const SizedBox(height: 6),
                          Text(
                            l10n.journalSubtitle,
                            style: AppTypography.inscription(
                              size: 22,
                              color: AppColors.parchment,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.leatherDeep,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.grain),
                      ),
                      child: Text(
                        l10n.journalRoundBadge(currentRound),
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: AppColors.brass),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Flexible(
                child: events.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          l10n.journalEmpty,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                        children: [
                          for (final round in roundNumbers) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, top: 4),
                              child: SectionLabel(
                                l10n.journalRoundBadge(round),
                                trailing: Text(
                                  l10n.journalRoundWords(rounds[round]!.length),
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: AppColors.parchmentMuted,
                                      ),
                                ),
                              ),
                            ),
                            for (final event in rounds[round]!)
                              _JournalRow(event: event, players: players),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.journalClose),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JournalRow extends StatelessWidget {
  const _JournalRow({required this.event, required this.players});

  final TableEvent event;
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final player = players[event.playerSeat];
    final name = player.isHuman ? 'Toi' : player.name;
    final (icon, color, text) = switch (event.kind) {
      TableEventKind.bid => (
        Icons.casino_outlined,
        AppColors.brass,
        l10n.journalSaidBid(name, event.bid?.label ?? ''),
      ),
      TableEventKind.dudo => (
        Icons.front_hand_outlined,
        AppColors.bloodBright,
        l10n.journalSaidDudo(name),
      ),
      TableEventKind.calza => (
        Icons.gps_fixed,
        AppColors.brassBright,
        l10n.journalSaidCalza(name),
      ),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.10),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, size: 13, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.parchmentDim, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

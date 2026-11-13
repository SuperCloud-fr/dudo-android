import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/tavern_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../salon/network_salon_session.dart';
import '../../../salon/salon_models.dart';
import '../../../salon/widgets/reaction_bar.dart';
import '../../../salon/widgets/salon_bits.dart';
import '../../../salon/widgets/salon_message_bubble.dart';

/// Live salon chat and quick reactions, shown above the active game table.
class InGameSalonChatSheet extends StatelessWidget {
  const InGameSalonChatSheet({super.key, required this.session});

  final NetworkSalonSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.76,
      minChildSize: 0.48,
      maxChildSize: 0.94,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C1D14), Color(0xFF130D08)],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppColors.brassDim),
        ),
        child: SafeArea(
          // The bottom belongs to the ReactionBar (raw view inset): no
          // double SafeArea padding over the 3-button nav bar.
          top: false,
          bottom: false,
          child: AnimatedBuilder(
            animation: session,
            builder: (context, _) {
              final messages = List<SalonMessage>.unmodifiable(
                session.messages,
              );
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                    child: SalonSectionLabel(
                      l10n.salonFeedSection,
                      trailing: RoundIconButton(
                        icon: Icons.close,
                        semanticLabel: l10n.journalClose,
                        onPressed: () => Navigator.of(context).pop(),
                        size: 40,
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.brassDim.withValues(alpha: 0.45),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) => SalonMessageBubble(
                        message: messages[messages.length - 1 - index],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                    child: ReactionBar(
                      players: session.players,
                      onSendReaction: session.sendReaction,
                      onSendChat: session.sendChat,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

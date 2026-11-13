import 'package:flutter/material.dart';

import '../../core/system_insets.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/salon_bits.dart';
import '../salon_models.dart';

/// Quick reactions at the bottom of a salon: live emojis, canned bold
/// sentences that mirror real Perudo table-talk (with {n} and {player}
/// placeholders filled in), and free text.
class ReactionBar extends StatefulWidget {
  const ReactionBar({
    super.key,
    required this.players,
    required this.onSendReaction,
    required this.onSendChat,
  });

  final List<SalonPlayer> players;
  final ValueChanged<String> onSendReaction;
  final ValueChanged<String> onSendChat;

  @override
  State<ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends State<ReactionBar> {
  static const emojis = ['😂', '🤯', '😈', '😤', '🍺', '🦜'];

  final int _diceCount = 2;
  static const int _defaultClaimFace = 5;
  SalonPlayer? _targetPlayer;
  final _textController = TextEditingController();

  SalonPlayer get _secondPlayer =>
      widget.players.length > 1 ? widget.players[1] : widget.players.first;

  @override
  void initState() {
    super.initState();
    _targetPlayer = widget.players.isEmpty ? null : _secondPlayer;
  }

  @override
  void didUpdateWidget(covariant ReactionBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_targetPlayer == null && widget.players.isNotEmpty) {
      _targetPlayer = _secondPlayer;
    } else if (_targetPlayer != null &&
        !widget.players.any((player) => player.seat == _targetPlayer!.seat)) {
      _targetPlayer = widget.players.isEmpty ? null : _secondPlayer;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String get _targetName => _targetPlayer?.name ?? 'Barbe-Noire';

  void _send(String body) {
    widget.onSendChat(body.trim());
    HapticFeedbackFromPack.vibrate();
  }

  String _faceName(AppLocalizations l10n, int face) =>
      face == 1 ? l10n.bidUnitPaco : '$face';

  /// The canned "I've got…" claim line: pacos get their own wording
  /// ("j'ai un paco", not "un dé de paco").
  String _claimLine(AppLocalizations l10n, int count, int face) => face == 1
      ? l10n.reactionLine1Paco(count)
      : l10n.reactionLine1(count, '$face');

  Future<void> _chooseDiceClaim(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    // Drop the keyboard first: a sheet opened while a text field holds
    // focus starts underneath it and only climbs out at the next rebuild.
    FocusManager.instance.primaryFocus?.unfocus();
    var count = _diceCount;
    var face = _defaultClaimFace;
    final message = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.leatherDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          // The "Larguer la phrase" button must clear the 3-button nav bar
          // even where the sheet's SafeArea drops the bottom inset.
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            20 + bottomSystemInsetOf(sheetContext),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.reactionDicePrompt,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(color: AppColors.parchment),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.reactionDiceCountLabel,
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: AppColors.brass),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var value = 1; value <= 5; value++)
                    ChoiceChip(
                      label: Text(l10n.trayDiceCount(value)),
                      selected: count == value,
                      onSelected: (_) => setSheetState(() => count = value),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.reactionDiceFaceLabel,
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: AppColors.brass),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var value = 1; value <= 6; value++)
                    ChoiceChip(
                      label: Text(_faceName(l10n, value)),
                      selected: face == value,
                      onSelected: (_) => setSheetState(() => face = value),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _claimLine(l10n, count, face),
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppColors.parchment),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    Navigator.of(sheetContext)
                        .pop(_claimLine(l10n, count, face)),
                child: Text(l10n.reactionDiceSend),
              ),
            ],
          ),
        ),
      ),
    );
    if (message != null) _send(message);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Canned table-talk, localized; {n}/{player} are filled by the
    // generated accessors.
    final recipes = <String>[
      _claimLine(l10n, _diceCount, _defaultClaimFace),
      l10n.reactionLine2(_targetName),
      l10n.reactionLine3(_targetName),
      l10n.reactionLine4(_diceCount),
      l10n.reactionLine5(_diceCount, _targetName),
      l10n.reactionLine6,
      l10n.reactionLine7(_targetName),
    ];
    return Container(
      // Bottom breathing room comes straight from the view's system inset:
      // on 3-button-nav phones the edge-to-edge nav bar floats OVER this
      // bar — the host SafeAreas don't always deliver the bottom padding.
      margin: EdgeInsets.only(bottom: bottomSystemInsetOf(context)),
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.leatherDeep.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brassDim.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                l10n.reactionHeader,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: AppColors.brass, letterSpacing: 1.4),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final emoji in emojis)
                      InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () {
                          HapticFeedbackFromPack.vibrate();
                          widget.onSendReaction(emoji);
                        },
                        child: Container(
                          width: 34,
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 19),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                l10n.speakHeader,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: AppColors.brass, letterSpacing: 1.4),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.reactionTargetSummary(
                    _targetPlayer?.name ?? '-',
                    _diceCount,
                  ),
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppColors.parchmentMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final label = recipes[index];
                return OutlinedButton(
                  onPressed: index == 0
                      ? () => _chooseDiceClaim(context, l10n)
                      : () => _send(label),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.parchment),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (text) {
                    _send(text);
                    _textController.clear();
                  },
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                      borderSide: BorderSide(color: AppColors.brassDim),
                    ),
                    filled: true,
                    fillColor: AppColors.leatherDeep,
                    prefixIcon: const Icon(
                      Icons.add_reaction_outlined,
                      size: 18,
                    ),
                    prefixIconColor: AppColors.brassDim,
                    hintText: l10n.reactionFreeHint,
                    hintStyle: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _send(_textController.text);
                  _textController.clear();
                },
                icon: const Icon(Icons.campaign_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

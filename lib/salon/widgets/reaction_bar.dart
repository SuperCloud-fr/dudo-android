import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
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

  static const recipes = [
    ('Tu n\u2019es pas obligé de me croire, mais j\u2019ai {n} dés.', 'dés'),
    ('Alors non, {player}, c\u2019est pas possible.', 'nonnull'),
    ('Le paco, c\u2019est ta fin, {player}.', 'paco'),
    ('Je te promets : au plus {n} dés sur la table, ils mentent.', 'table'),
    (
      'Regarde mes {n} dés, {player}, tu es à l\u2019eau d\u2019ici ce soir.',
      'next',
    ),
    ('Paco sur paco paco paco.', 'paco'),
    ('Je te crois, {player}, te voilà bien détrompé.', 'miss'),
  ];

  final int _diceCount = 2;
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

  String _interpolate(String template) {
    return template
        .replaceAll('{n}', '$_diceCount')
        .replaceAll('{player}', _targetPlayer?.name ?? 'Barbe-Noire');
  }

  void _send(String body) {
    widget.onSendChat(body.trim());
    HapticFeedbackFromPack.vibrate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                'RÉAGIR',
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
                'PARLE',
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: AppColors.brass, letterSpacing: 1.4),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${_targetPlayer?.name ?? '-'} · mes dés : $_diceCount',
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
                final (raw, _) = recipes[index];
                final label = _interpolate(raw);
                return OutlinedButton(
                  onPressed: () => _send(label),
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
                    hintText: 'Écrire un message libre…',
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

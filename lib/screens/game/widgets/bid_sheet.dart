import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/system_insets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/dice_face.dart';
import '../../../core/widgets/ornaments.dart';
import '../../../core/widgets/tavern_button.dart';
import '../../../game/logic/perudo_rules.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../l10n/generated/app_localizations_fr.dart';
import 'palifico_chip.dart';
import '../../../game/models/bid.dart';

/// Localization may be absent in bare test hosts that pump this widget
/// without the app's delegates; French is the source of truth
/// (see lib/app.dart), so fall back to the French book.
AppLocalizations _l10n(BuildContext context) =>
    AppLocalizations.of(context) ?? AppLocalizationsFr();

class BidSheet extends StatefulWidget {
  const BidSheet({
    super.key,
    required this.previous,
    required this.previousBidderName,
    required this.totalDice,
    required this.initial,
    required this.palifico,
    required this.calzaEnabled,
  });

  final Bid? previous;
  final String previousBidderName;
  final int totalDice;
  final Bid? initial;
  final bool palifico;
  final bool calzaEnabled;

  @override
  State<BidSheet> createState() => _BidSheetState();
}

class _BidSheetState extends State<BidSheet> {
  late int _face;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _face = initial?.face ?? 2;
    _quantity = initial?.quantity ?? 1;
    _ensureSelectableFace();
  }

  int? get _minQuantity => PerudoRules.minQuantityForFace(
    previous: widget.previous,
    face: _face,
    palifico: widget.palifico,
  );

  int get _displayMin =>
      _minQuantity != null && _minQuantity! >= 1 ? _minQuantity! : 1;

  bool get _facePossible => PerudoRules.canBidFace(
    previous: widget.previous,
    face: _face,
    totalDice: widget.totalDice,
    // Opening on pacos is illegal in a normal round but allowed in a
    // palifico one — without the flag here the summary stayed legal on
    // screen while the sheet kept refusing the announce button.
    palifico: widget.palifico,
  );

  bool get _isLegal =>
      _facePossible &&
      _minQuantity != null &&
      _quantity >= _minQuantity! &&
      _quantity <= widget.totalDice &&
      PerudoRules.isLegalRaise(
        previous: widget.previous,
        next: Bid(quantity: _quantity, face: _face, playerSeat: 0),
        totalDice: widget.totalDice,
        palifico: widget.palifico,
      );

  void _ensureSelectableFace() {
    if (widget.palifico && widget.previous != null) {
      _face = widget.previous!.face;
      _quantity = _displayMin.clamp(1, widget.totalDice);
      return;
    }
    if (_facePossible &&
        _minQuantity != null &&
        _minQuantity! <= widget.totalDice) {
      // Never park the picker below the legal minimum (palifico opening
      // starts at two dice): the announce button would read illegal while
      // the face itself is perfectly playable.
      _quantity = _quantity.clamp(_displayMin, widget.totalDice);
      return;
    }
    for (final face in const [2, 3, 4, 5, 6, 1]) {
      if (PerudoRules.canBidFace(
        previous: widget.previous,
        face: face,
        totalDice: widget.totalDice,
        palifico: widget.palifico,
      )) {
        _face = face;
        _quantity = _minQuantity ?? 1;
        return;
      }
    }
  }

  void _selectFace(int face) {
    final min = PerudoRules.minQuantityForFace(
      previous: widget.previous,
      face: face,
      palifico: widget.palifico,
    );
    if (min == null) return;
    HapticFeedback.selectionClick();
    setState(() {
      _face = face;
      _quantity = min;
    });
  }

  void _changeQuantity(int delta) {
    final next = (_quantity + delta).clamp(_displayMin, widget.totalDice);
    if (next == _quantity) return;
    HapticFeedback.selectionClick();
    setState(() => _quantity = next);
  }

  void _submit() {
    if (!_isLegal) return;
    HapticFeedback.mediumImpact();
    Navigator.of(context)
        .pop(Bid(quantity: _quantity, face: _face, playerSeat: 0));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n(context);
    final previous = widget.previous;
    final faceWord = _face == 1
        ? l10n.bidUnitPaco
        : l10n.bidFaceWord(_quantity, _face);
    final summary = _face == 1
        ? l10n.bidSummaryAces(_quantity)
        : l10n.bidSummary(_quantity, faceWord);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.92,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C1D14), Color(0xFF150E09)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: AppColors.brassDim, width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            // The confirm row must clear the 3-button nav bar even where
            // the sheet's SafeArea drops the bottom inset.
            padding: EdgeInsets.fromLTRB(
              20,
              10,
              20,
              18 + bottomSystemInsetOf(context),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.brassDim.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                if (widget.palifico) ...[
                  const Center(child: PalificoChip()),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 18),
                SectionLabel(
                  previous == null
                      ? l10n.bidOpenHostilities
                      : l10n.bidRaiseSection,
                  trailing: Text(
                    l10n.gameDiceInPlay(widget.totalDice),
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: AppColors.parchmentMuted),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  previous == null
                      ? l10n.gameYourTurnPrompt
                      : l10n.bidRaisePrompt,
                  style: AppTypography.inscription(
                    size: 26,
                    color: AppColors.parchment,
                    letterSpacing: 1.2,
                  ),
                ),
                if (previous != null) ...[
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: l10n.bidLastBid,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: '${previous.quantity} × ${previous.faceLabel}',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: AppColors.brassBright,
                                fontSize: 13,
                              ),
                        ),
                        TextSpan(
                          text: ' — ${widget.previousBidderName}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                _QuantityPicker(
                  quantity: _quantity,
                  min: _displayMin,
                  max: widget.totalDice,
                  isAces: _face == 1,
                  onMinus: _quantity > _displayMin
                      ? () => _changeQuantity(-1)
                      : null,
                  onPlus: _quantity < widget.totalDice
                      ? () => _changeQuantity(1)
                      : null,
                ),
                const SizedBox(height: 18),
                Text(
                  widget.palifico && widget.previous != null
                      ? l10n.bidPalificoFaceLabel
                      : l10n.bidFaceLabel,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppColors.brassDim, letterSpacing: 2),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (var face = 2; face <= 6; face++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: _FaceOption(
                            face: face,
                            selected: _face == face,
                            enabled: PerudoRules.canBidFace(
                              previous: previous,
                              face: face,
                              totalDice: widget.totalDice,
                              palifico: widget.palifico,
                            ),
                            onTap: () => _selectFace(face),
                          ),
                        ),
                      ),
                    Expanded(
                      child: _FaceOption(
                        face: 1,
                        selected: _face == 1,
                        enabled: PerudoRules.canBidFace(
                          previous: previous,
                          face: 1,
                          totalDice: widget.totalDice,
                          palifico: widget.palifico,
                        ),
                        onTap: () => _selectFace(1),
                        ace: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.feltDeep.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.brassDim.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.record_voice_over_outlined,
                        size: 18,
                        color: AppColors.brass,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              summary,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.parchment,
                                    fontSize: 14,
                                  ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.palifico
                                  ? widget.previous != null
                                        ? l10n.bidPalificoFaceHint
                                        : l10n.bidPalificoOpenHint
                                  : _face == 1
                                  ? l10n.bidAcesOnlyHint
                                  : l10n.bidPacoWildHint,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.parchmentMuted,
                                    fontSize: 11.5,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TavernButton(
                        label: l10n.commonCancel,
                        tone: TavernButtonTone.ghost,
                        compact: true,
                        onPressed: () => Navigator.of(context).pop(),
                        expand: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 10,
                      child: TavernButton(
                        label: l10n.bidAnnounce,
                        icon: Icons.campaign_outlined,
                        compact: true,
                        onPressed: _isLegal ? _submit : null,
                        expand: true,
                      ),
                    ),
                  ],
                ),
                if (!_isLegal) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.bidIllegalRaise,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.bloodBright, fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuantityPicker extends StatelessWidget {
  const _QuantityPicker({
    required this.quantity,
    required this.min,
    required this.max,
    required this.isAces,
    required this.onMinus,
    required this.onPlus,
  });

  final int quantity;
  final int min;
  final int max;
  final bool isAces;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B120C), Color(0xFF0E0906)],
        ),
        border: Border.all(color: AppColors.brassDim.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          _StepButton(
            icon: Icons.remove,
            label: l10n.bidDecreaseQty,
            onPressed: onMinus,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$quantity',
                  style: AppTypography.inscription(
                    size: 62,
                    color: AppColors.parchment,
                    letterSpacing: 0,
                    height: 0.95,
                  ),
                ),
                Text(
                  isAces ? l10n.bidUnitPaco : l10n.bidUnit(quantity),
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: AppColors.brass, letterSpacing: 2),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.bidRange(min, max),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.parchmentMuted,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          _StepButton(
            icon: Icons.add,
            label: l10n.bidIncreaseQty,
            onPressed: onPlus,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
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
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.leather.withValues(alpha: 0.75),
            border: Border.all(
              color: enabled ? AppColors.brassDim : AppColors.grain,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Icon(
              icon,
              size: 24,
              color: enabled ? AppColors.parchment : AppColors.parchmentMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _FaceOption extends StatelessWidget {
  const _FaceOption({
    required this.face,
    required this.selected,
    required this.enabled,
    required this.onTap,
    this.ace = false,
  });

  final int face;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;
  final bool ace;

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n(context);
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: ace ? l10n.bidAceSemantics : l10n.bidFaceSemantics(face),
      excludeSemantics: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        opacity: enabled ? 1 : 0.28,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.brass.withValues(alpha: 0.16)
                  : AppColors.leatherDeep.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColors.brass : AppColors.grain,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: InkWell(
              onTap: enabled ? onTap : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DiceFace(value: face, size: 27),
                    const SizedBox(height: 3),
                    Text(
                      ace ? 'PACO' : '$face',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: ace
                            ? AppColors.bloodBright
                            : selected
                            ? AppColors.brassBright
                            : AppColors.parchmentMuted,
                        fontSize: 9,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

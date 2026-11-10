import '../../l10n/generated/app_localizations.dart';
import 'bid.dart';

/// Display forms of a bid, read through the phone's language. The model
/// keeps its plain getters (network payloads never travel prose); only
/// the widgets host a [BuildContext] and may call these.
extension BidLocalLabel on Bid {
  /// "4 dés de 5" / "3 paco" — the long form used by the journal.
  String labelLocalized(AppLocalizations l10n) {
    if (isAces) return l10n.bidAcesLabel(quantity);
    return l10n.bidPlainLabel(quantity, face);
  }

  /// "au moins 4 dés de valeur 5" — spoken/read form.
  String spokenLabelLocalized(AppLocalizations l10n) {
    if (isAces) return l10n.bidSpokenAces(quantity);
    return l10n.bidSpokenPlain(quantity, face);
  }

  /// "4×5" / "3×P" — compact history chip.
  String shortLabelLocalized(AppLocalizations l10n) =>
      l10n.bidShortLabel(quantity, isAces ? 'P' : '$face');
}

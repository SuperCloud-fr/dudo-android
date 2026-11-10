import '../../l10n/generated/app_localizations.dart';
import 'game_config.dart';

/// Display forms of the bot difficulties, read through the phone's
/// language. The enum keeps its French fallbacks; only widgets, which
/// host a [BuildContext], call these.
extension BotDifficultyLabel on BotDifficulty {
  String labelLocalized(AppLocalizations l10n) {
    switch (this) {
      case BotDifficulty.mousse:
        return l10n.temperMousseLabel;
      case BotDifficulty.flibustier:
        return l10n.temperFlibustierLabel;
      case BotDifficulty.capitaine:
        return l10n.temperCapitaineLabel;
    }
  }

  String descriptionLocalized(AppLocalizations l10n) {
    switch (this) {
      case BotDifficulty.mousse:
        return l10n.temperMousseBody;
      case BotDifficulty.flibustier:
        return l10n.temperFlibustierBody;
      case BotDifficulty.capitaine:
        return l10n.temperCapitaineBody;
    }
  }
}

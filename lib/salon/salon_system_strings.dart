import '../../l10n/generated/app_localizations.dart';

/// The salon threads speak the phone's language: [DudoApp] binds a fresh
/// snapshot in its builder each frame, so the session layer — which never
/// sees a BuildContext — can compose system messages through here. Not
/// bound yet (widgets test, headless tool)? Every getter falls back to
/// the original French wording; nothing crashes, the thread stays alive.
abstract final class SalonSystem {
  static AppLocalizations? _words;

  static void bind(AppLocalizations? words) => _words = words;

  static String get phoneSlept =>
      _words?.systemPhoneSlept ??
      'Le téléphone a mis le salon en sommeil — reconnexion…';
  static String get watchdogCut =>
      _words?.systemQuietCut ??
      'Le salon ne répond plus — je coupe la connexion desséchée et je reprends…';
  static String created(String code) =>
      _words?.systemCreated(code) ?? 'Salon créé. Code : $code';
  static String connectedTab(String code) =>
      _words?.systemConnected(code) ?? 'Connecté au salon $code';
  static String recovered(String code) =>
      _words?.systemRecovered(code) ?? 'Reconnecté au salon $code.';
  static String closed(String reason) =>
      _words?.systemClosed(reason) ?? 'Salon fermé : $reason';
  static String lost([String detail = '']) =>
      _words?.systemLost(detail) ??
      'Connexion perdue$detail — tentative de reconnexion…';
  static String unreachableTrack(String reason) =>
      _words?.systemUnreachableTrack(reason) ??
      'Salon injoignable — $reason Je continue d\u2019essayer.';
  static String unreachableBackoff(String brief) =>
      _words?.systemUnreachableBackoff(brief) ??
      'Salon injoignable — $brief. Je continue d\u2019essayer en doublant le délai.';
  static String throttledCreate(int seconds) =>
      _words?.systemThrottledCreate(seconds) ??
      'Trop de demandes de création — réessaie dans ~$seconds s.';
  static String createFailed([String detail = '']) =>
      _words?.systemCreateFailed(detail) ??
      'Impossible de créer un salon pour l\u2019instant.$detail';
  static String chatRate(int seconds) =>
      _words?.systemChatRate(seconds) ??
      'Débit du salon atteint — attends ${seconds}s.';
  static String get deadReaction =>
      _words?.systemDeadReaction ??
      'La connexion au salon est lâchée — la réaction ne peut pas partir.';
  static String get deadChat =>
      _words?.systemDeadChat ??
      'La connexion au salon est lâchée — le message ne peut pas partir.';
  static String get hostGone =>
      _words?.systemHostGone ??
      'L\u2019hôte a quitté la manche — la table attend son retour…';
  static String get sixChars =>
      _words?.systemSixChars ?? 'Le code doit faire six caractères.';
}

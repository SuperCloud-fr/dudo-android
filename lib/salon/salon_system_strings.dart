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
      'Le téléphone sort de veille. Reconnexion au salon…';
  static String get watchdogCut =>
      _words?.systemQuietCut ??
      'Le salon ne répond plus. Je rétablis la connexion…';
  static String created(String code) =>
      _words?.systemCreated(code) ?? 'Ton salon est prêt : $code.';
  static String connectedTab(String code) =>
      _words?.systemConnected(code) ?? 'À bord du salon $code !';
  static String recovered(String code) =>
      _words?.systemRecovered(code) ?? 'Tu es de retour dans le salon $code.';
  static String closed(String reason) =>
      _words?.systemClosed(reason) ?? 'La taverne ferme ses portes : $reason.';
  static String lost([String detail = '']) =>
      _words?.systemLost(detail) ??
      'Connexion interrompue$detail. Nouvelle tentative…';
  static String unreachableTrack(String reason) =>
      _words?.systemUnreachableTrack(reason) ??
      'Impossible de joindre le salon : $reason. Je réessaie.';
  static String unreachableBackoff(String brief) =>
      _words?.systemUnreachableBackoff(brief) ??
      'Le salon reste inaccessible : $brief. Je réessaierai après un délai plus long.';
  static String salonRefused(String reason) =>
      _words?.systemSalonRefused(reason) ??
      'Le salon refuse ton retour : $reason. Il a peut-être fermé — quitte le salon puis réessaie ou crée-en un autre.';
  static String throttledCreate(int seconds) =>
      _words?.systemThrottledCreate(seconds) ??
      'Trop de demandes de création. Réessaie dans $seconds s.';
  static String createFailed([String detail = '']) =>
      _words?.systemCreateFailed(detail) ??
      'Le salon n\'a pas pu être créé.$detail';
  static String chatRate(int seconds) =>
      _words?.systemChatRate(seconds) ??
      'Doucement sur les messages, matelot. Attends $seconds s.';
  static String get deadReaction =>
      _words?.systemDeadReaction ??
      'Tu es déconnecté du salon. Ta réaction n\'a pas été envoyée.';
  static String get deadChat =>
      _words?.systemDeadChat ??
      'Tu es déconnecté du salon. Ton message n\'a pas été envoyé.';
  static String get hostGone =>
      _words?.systemHostGone ??
      'L\'hôte est déconnecté. La table attend son retour…';
  static String get noServerReply =>
      _words?.systemNoServerReply ??
      'Le serveur n\'a pas répondu après 8 s. Je réessaie.';
  static String networkResponse(String status, String body) =>
      _words?.systemNetworkResponse(status, body) ??
      'Le réseau répond $status : $body.';
  static String networkProbeFailed(String error) =>
      _words?.systemNetworkProbeFailed(error) ??
      'Impossible de vérifier la connexion ($error). Je réessaie.';
  static String get sixChars =>
      _words?.systemSixChars ??
      'Il faut un code de six caractères pour monter à bord.';
}

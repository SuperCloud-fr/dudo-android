# Dudo — le Perudo de taverne

Dudo est un jeu de dés de **Perudo pour Android**, écrit en Flutter : on y joue **solo contre une équipe de pirates IA**, ou **en salon multijoueur en ligne** (jusqu'à 6 téléphones). Cinq dés, un gobelet, une table de taverne, et un équipage qui ment très bien. Le code est gardé côté plateforme aussi neutre que possible : ce dépôt livre Android, et le même `lib/` pourra servir de base à un dépôt iOS séparé.

| Accueil | La table |
|---|---|
| <img src="docs/screenshots/home.png" width="260" alt="Écran d'accueil de Dudo" /> | <img src="docs/screenshots/table.png" width="260" alt="Table de jeu avec les paris" /> |
| **Ta main** | **La révélation** |
| <img src="docs/screenshots/peek-dice.png" width="260" alt="Révélation des dés du joueur" /> | <img src="docs/screenshots/reveal.png" width="260" alt="Révélation d'un dudo" /> |

## Ce qui est jouable

- **1 joueur + 1 à 5 pirates IA**, 5 dés par joueur, dernière personne avec un dé gagne.
- **Règles Perudo complètes** : as joker (paco), surenchères légales, dudo, calza optionnelle, palifico quand un pirate reste à un seul dé, perte de dé, élimination, manche suivante ouverte par le perdant.
- **Salons multijoueurs en ligne** : jusqu'à 6 pirates, chacun sur son téléphone, code à six caractères partagé par SMS/WhatsApp/mail. L'hôte choisit le nombre **et la difficulté** des bots, puis arbitre les règles (relais `HostGameRelay`) ; les invités rejouent ses décisions en miroir. Les dés ne transitent jamais sur le réseau (chaque table en tire les mêmes depuis une graine partagée). Serveur : `https://dudo.supercloud.fr` (Worker API v1, voir `../worker`).
- **Solidité du salon** : battement de cœur (ping/pong toutes les 20 s), reprise de siège à la reconnexion (rejoin en pleine partie), timeout de tour 60 s, fil de salon (chat libre, phrases prêtes à l'emploi, réactions), messages système qui expliquent les coupures.
- **Trois difficultés** : Mousse (prudent), Flibustier (équilibré), Capitaine (probabiliste et féroce).
- **IA sans triche** : chaque bot ne connaît que ses propres dés, le nombre de dés en jeu et le pari courant. Il estime les probabilités par loi binomiale, avec du bluff et du caractère.
- **Une vraie table** : gobelet privé, pari courant, historique des trois derniers coups, journal complet, confirmation avant un dudo ou une calza, résultats expliqués dé par dé.
- **Interface française et anglaise** (suit la langue du téléphone), portrait, une main : cibles de 48 dp, respect de la taille de police (testée à 1,3×), animations réduites si le système le demande, retour Android fonctionnel.
- **Pas de compte, pas de pub, pas d'analytics.** Seuls les messages du salon (pseudos, paris, chat) transitent par le Worker ; la [politique de confidentialité](https://dudo.supercloud.fr/politique-de-confidentialite) est liée depuis les Réglages.

## Lancer le projet

Prérequis utilisés pour cette version :

- Flutter **3.47.9** (Dart 3.13.7)
- Android SDK **36**, build-tools 36.0.0
- JDK **17**

```powershell
flutter pub get
flutter run
```

Builds :

```powershell
flutter build apk --debug

# Sur ce poste Windows au chemin accentué, le build release direct échoue
# (gen_snapshot ne lit pas app.dill sous un chemin utilisateur accentué). Le script mappe le
# dépôt sur un lecteur ASCII temporaire le temps du build :
powershell -ExecutionPolicy Bypass -File tool\build_release.ps1

# APK séparés par ABI (plus légers pour la distribution) :
powershell -ExecutionPolicy Bypass -File tool\build_release.ps1 --split-per-abi

# Si le cache a été créé sous un autre lecteur (le script utilise X:) :
powershell -ExecutionPolicy Bypass -File tool\build_release.ps1 -Clean
```

L'APK est écrit dans `build/app/outputs/flutter-apk/`. Le build universel
release fait environ 46 Mo ; les APK par ABI font 14–18 Mo. La configuration
`release` du template signe encore avec la clé debug : à remplacer par un
keystore avant une publication Play Store.

Tests et analyse :

```powershell
flutter test
dart analyze lib test
```

La suite couvre les règles, les probabilités et la légalité des décisions des bots, des parties complètes simulées (1 à 5 adversaires, toutes difficultés, calza), le parcours widget principal, et les overlays à 1,3× de taille de police.

### Note sur ce poste Windows

Le dépôt vit sous un chemin utilisateur contenant un caractère accentué, que Gradle refuse par défaut. `android/gradle.properties` contient donc :

```properties
android.overridePathCheck=true
```

La toolchain de développement a été installée hors du profil utilisateur pour éviter le même problème :

- Flutter : `C:\tools\flutter`
- Android SDK : `C:\Android\Sdk`
- JDK : `C:\Program Files\Java\jdk-17.0.1`
- Cache Pub : `C:\tools\pub-cache`

Ajoute `C:\tools\flutter\bin`, `C:\Android\Sdk\platform-tools` et `C:\Android\Sdk\emulator` au `PATH` pour retrouver `flutter` et `adb`.

### CI et releases

Le workflow [`.github/workflows/android.yml`](.github/workflows/android.yml) tourne sur GitHub Actions :

- **push sur `main` et pull requests** : `flutter pub get`, `dart analyze`, `flutter test`, puis build de l'APK release ;
- l'APK est publié comme artefact **`dudo-android-apk`** dans l'onglet Actions du run (conservation 14 jours) ;
- **tag `v*`** : le même build attache l'APK à la GitHub Release, avec les notes générées.

```powershell
git tag v0.1.0
git push origin v0.1.0
```

L'APK produit par la CI est signé avec la clé debug du template, comme le build local : parfait pour tester et partager, pas encore pour le Play Store.

**Cloudflare** : Workers Builds ne fournit ni Android SDK ni Gradle, donc il ne peut pas compiler l'APK. GitHub Actions s'en charge. Cloudflare pourra en revanche héberger le fichier (R2) ou servir la future API temps réel via un Worker.

### Checks cyber en CI

Un job **security** tourne avant le build et **bloque** la release en cas d'alerte :

| Vérification | Outil | Portée |
|---|---|---|
| Secrets et clés dans le code **et l'historique git** | gitleaks | bloquant |
| Dépendances Dart avec CVE connues (via `pubspec.lock`) | osv-scanner | bloquant |
| SAST statique : `p/security-audit`, `p/owasp-top-ten`, `p/secrets` | semgrep | bloquant sur sévérité ERROR ; WARNING/INFO signalés |
| Lint Android version release (permissions, trafic en clair…) | gradle `lintRelease` | non bloquant, rapport publié |

Rapports envoyés en artefacts **`dudo-security-reports`** et **`dudo-android-lint`**. Le gate SAST ne punit que la sévérité ERROR pour éviter les faux positifs qui casserait les releases bêta ; les WARNING sont visibles dans la synthèse du job. L'application étant 100 % hors ligne, la plupart des catégories OWASP ne s'y prêtent pas : ces checks servent de garde-fous défensifs. Suivis possibles : scan de l'APK avec MobSF (OWASP MASVS / Mobile Top 10) et keystore de release signé.

## Architecture

```
lib/
  app.dart, main.dart          MaterialApp + système de palettes ambiantes
  core/
    theme/        couleurs, palettes interchangeables, typographie, ThemeData
    widgets/      fond de taverne, dés, gobelet, boutons, ornements
  l10n/           sources ARB (fr = référence) ; généré dans l10n/generated/
  game/
    models/       Bid, Player, GameConfig, événements, résultat
    logic/        PerudoRules (pur), BotBrain + probabilités (pur)
    state/        GameController (ChangeNotifier, timers des bots)
  salon/          salon réseau : session WS, relais hôte, miroir invité,
                  battement de cœur, fil de chat, écrans de lobby
  screens/
    home/         signe suspendu, CTA, bord de table
    settings/     choix d'ambiance, politique de confidentialité
    setup/        équipage, difficulté, calza
    game/         table, sièges, feuille de pari, peek, révélation, fin, journal
    rules/        règles illustrées
test/
  perudo_rules_test.dart     règles (pur)
  bot_brain_test.dart        décisions et probabilités des bots
  game_flow_test.dart        parties complètes simulées
  network_salon_session_test.dart   session WS : join, reprise, seau de chat,
                             watchdog, ping/pong
  network_game_test.dart     relais/miroir des deux téléphones (fake Worker)
  salon_/widgets_/overlays/… tests widget des écrans
  two_phones_rehearsal_test.dart    répétition LIVE contre le vrai Worker
                             (aucun réseau en CI ; $env:LIVE='1' pour lancer)
```

Principes :

- `PerudoRules` et `BotBrain` ne dépendent pas de l'UI et sont testables en isolation.
- `GameController` est la seule source de vérité : phases `peek → bidding → reveal → roundOver → gameOver`, validation des coups, timers des bots, pause des bots quand un modal est ouvert.
- Les écrans écoutent le contrôleur et ne décident jamais de la légalité d'un coup.
- En salon, l'**hôte arbitre** : `HostGameRelay` diffuse des instantanés ; les invités (`GuestGameController`) sont des miroirs qui envoient des commandes — jamais la légalité.
- Interface entièrement instrumentée par `AppLocalizations` (fr référence, en idiome) ; les messages système du salon passent par un instantané ambient (`SalonSystem`).
- Les polices sont embarquées (OFL) : Alkatra (titres), Alegreya Sans (corps), Cinzel gardé pour l'inscription.

## Direction artistique

Taverne sombre et chaleureuse : bois, cuir, feutre vert, laiton, ivoire. **Alkatra** pour les titres (gravé à la main, brief d'identité), Alegreya Sans pour tout ce qui doit se lire pendant qu'un pirate vous ment ; Cinzel reste en réserve pour l'inscription. Le fait de main sur les palettes interchangeables (Taverne, Pavillon Debout — et demain corporate, voir #6) est dans [`lib/core/theme/app_palette.dart`](lib/core/theme/app_palette.dart). Le détail complet (palette, rôles, composants, motion, accessibilité) est dans [DESIGN.md](DESIGN.md) ; le cadre produit est dans [PRODUCT.md](PRODUCT.md), et les tokens sont aussi dans `.impeccable/design.json`.

## Suite possible

- **Dépôt iOS** : réutiliser `lib/`, ajouter la cible iOS, vérifier safe areas, back-swipe et Reduce Motion.
- **Troisième palette « corporate »** (#6) : la machine à ambiances est prête, la couleur cible est là.
- **Variante « Salsa »** (#12) : moteur de règles extensible, la variante est du travail de `PerudoRules`.
- **Pass-and-play** sur un seul téléphone.
- statistiques persistantes, sons de dés, keystore de release pour le Play Store, `privacyVersion` (#13, bonus).

## Crédits

- Code et direction visuelle : projet Dudo.
- Polices : [Cinzel](https://fonts.google.com/specimen/Cinzel) et [Alegreya Sans](https://fonts.google.com/specimen/Alegreya+Sans), SIL Open Font License (fichiers de licence dans `assets/fonts/`).
- Dés, gobelet, table, icône et splash sont dessinés dans le projet (aucune image tierce).
- Perudo / Dudo est un jeu traditionnel ; ce projet n'est affilié à aucun éditeur.

# Dudo 0.2.0 — bêta 5 : le salon parle de ses coupures

- Les messages système expliquent **pourquoi** la connexion a lâché (code de fermeture WebSocket, erreur réseau du téléphone) — utile pour croiser les blocages VPN/DNS opérateur/box.
- L'accueil garde son pied de page hors du bandeau feutre (le chevauchement « v0.1 · … » est corrigé).

Rappel bêta 4 : l'app parle au serveur **`https://dudo.supercloud.fr`** — la beta 3 ne voit pas les salons.

## bêta 3

- **Anglais** : l'app suit la langue du téléphone (français par défaut) — accueil, règles, partie et salon traduits avec l'esprit du jeu conservé ; c'est le début de la chaîne de traduction.
- **Icône de l'app redessinée** : le dé « paco » au perroquet, écran de démarrage aligné.
- **Typographie de marque** : les titres passent en **Alkatra** (gravé à la main, brief d'identité visuelle) ; le corps reste Alegreya Sans.
- **Salons plus solides** : l'app parle désormais l'**API v1** du serveur (`/api/v1/salons`), affiche clairement le délai si la création est bridée (429), et limite elle-même le débit du chat et des réactions (rafale de 3, puis 1 par seconde) pour ne jamais risquer l'expulsion.

Cette bêta couvre le **multijoueur en ligne** : jusqu'à 6 pirates, chacun sur son téléphone, avec un code de salon à six caractères.

## Nouveau dans cette bêta 2

- **Les IA jouent dans les salons en ligne** : plus de table gelée qui attend le premier bot — les IA du salon jouent sur le téléphone de l'hôte, leurs coups sont relayés à tous.
- **Timeout de tour à 60 secondes** : un pirate trop lent à parler (hôte, invité, ou solo) laisse la table avancer — plus de partie bloquée derrière un joueur silencieux.
- **Fil de salon propre** : quitter un salon puis en créer un autre ne réaffiche plus l'ancien fil de discussion.
- **Nouvelle ambiance « Pavillon Debout »** : marine & or, à choisir dans la page Réglages (le choix est conservé au redémarrage ; la taverne reste disponible).
- **Perroquet du dé « paco » redessiné** : tête ronde, bec crochu or, anneau d'œil — lisible même en tout petit.
- **Palifico recentré** : le tour verrouillé ne dure que la manche qui suit la chute à un dé ; le joueur qui remonte puis rechute le redéclenche.

## En plus depuis la bêta 1

- **Salons en ligne** : « Créer un salon » génère un code à partager par SMS, WhatsApp, Signal ou mail ; « Rejoindre un salon » demande seulement le code et le nom.
- **L'hôte mène la table** : il ajuste le nombre d'IA, lance la manche, et son téléphone arbitre les règles ; les autres téléphones rejouent ses décisions en direct.
- **Manche entièrement à plusieurs** : enchères, dudo, calza, palifico, éliminations — chaque joueur ne voit que ses propres dés, les dés ne transitent jamais sur le réseau (chaque table tire les mêmes dés à partir d'une graine partagée).
- **Fil du salon** : chat libre, phrases de pirate prêtes à l'emploi et réactions emoji, en direct.
- **Retour à la taverne** : reconnexion automatique si la connexion tombe, et reprise de son siège en cours de partie.
- **Solo inchangé** : 1 à 5 pirates IA, 3 difficultés (Mousse, Flibustier, Capitaine).

## Installation (Android 7.0+)

1. Télécharge **`dudo-v0.2.0-beta.1.apk`** ci-dessous (ou l'artefact du run CI).
2. Ouvre le fichier sur le téléphone.
3. Si Android le demande, autorise l'installation depuis cette source, puis installe.
4. Lance **Dudo**.

Désinstalle l'ancienne bêta si Android refuse l'installation (« signature différente »).

## Tester à plusieurs

1. L'hôte : **Salons multijoueurs → Créer un salon**, choisit son nom et le nombre d'IA, partage le code.
2. Les amis : **Rejoindre un salon**, entrent le code et leur nom.
3. Tout le monde apparaît à table ; l'hôte lance la manche.
4. En cas de coupure réseau, le jeu tente de reconnecter et de reprendre le siège.

## Ce qu'on aimerait savoir

- La connexion au salon est-elle simple et rapide ? Le code se partage-t-il bien ?
- Les tours sont-ils compréhensibles quand ce n'est pas le tien ? Sens-tu les hésitations des autres ?
- Le chat et les réactions tombent-ils au bon moment ?
- Une coupure réseau, un retour en arrière, un écran bloqué ? Envoie le modèle du téléphone, la version d'Android et une capture.

## Limites connues

- **APK signé avec la clé debug** : build de test, pas encore une build Play Store. Play Protect peut afficher un avertissement.
- Multijoueur en **ligne uniquement** via `api.dudo.supercloud.fr` ; pas de jeu en réseau local.
- **Français uniquement**, portrait uniquement.
- Pas encore de statistiques persistantes ni de sons.

## Confidentialité

Dudo ne demande aucun compte et ne collecte rien. En solo, le jeu fonctionne entièrement hors ligne. En salon, seuls les messages nécessaires à la partie (pseudos, paris, chat) transitent par le Worker ; aucune publicité, aucun analytics.

## Retours

Réponds dans le fil de test prévu, ou ouvre une issue sur le dépôt avec le label `beta`. Les retours les plus utiles : parties complètes à plusieurs, moments d'hésitation, et écrans qui ont semblé faux.

Bon jeu, et mentez bien.

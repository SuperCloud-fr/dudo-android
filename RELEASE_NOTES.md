# Dudo 0.2.0 — bêta 26 : le chat rejoint la table

- **Le chat et les réactions restent disponibles pendant une manche en réseau** : une icône ouvre le journal de bord en feuille redimensionnable, avec messages en direct, réactions rapides et saisie libre. Un badge signale les nouveaux messages ; les joueurs peuvent aussi choisir quantité et face dans une réaction pour bluffer.
- **Les textes de l'application ont été relus** : 325 chaînes françaises passées en QCM, traduction anglaise harmonisée, faute « tu reines » corrigée et règles/pacos clarifiés.
- Le Worker n'a pas changé : il relayait déjà chat et réactions pendant les parties.

## Bêta 25 : l'hôte revient, la table reprend

- **L'hôte disparaît en pleine manche ?** Les invités voient une alerte après 3 s ; 12 s plus tard, si l'hôte n'est toujours pas revenu, la table figée se replie vers le lobby. S'il récupère son siège avant, la partie reprend sans repli.
- **L'hôte peut relancer après une partie** : le retour au lobby dépile maintenant la table et réarme le bouton « Lancer la manche », au lieu de le laisser grisé sur « La manche se prépare ».
- **APK arm64 seul** : environ 19,5 Mo au lieu des ~50 Mo du paquet multi-architectures.

## Bêta 24 : spectateur tranquille

- **Éliminé, tu ne secoues plus un gobelet vide** : l'écran d'ouverture de manche devient un écran spectateur « Tu es à l'eau » — plus d'invite de secouage, plus de dé fantôme d'avant la défaite.
- **Quand il ne reste que des PNJ, la table se joue toute seule** : les manches s'enchaînent en automatique (révélation lisible, mais zéro clic) jusqu'au dernier survivant.
- **Verrouiller puis déverrouiller le téléphone retrouve le salon** : le verrouillage pouvait bloquer la reconnexion à jamais (« connexion perdue » sans fin) — réparé, avec un cas supplémentaire de socket mort silencieux pendant la veille.

## Bêta 23 : la table joue jusqu'au dernier pirate

- **La partie continue jusqu'au dernier survivant** : être à l'eau ne coupe plus la table. L'éliminé regarde la manche se jouer, et le vainqueur est le dernier debout.
- **Ouvrir sur les pacos en palifico fonctionne** : le message « ce montant n'est pas une surenchère valable » ne s'affiche plus ; la quantité se cale d'elle-même sur le minimum légal (2).
- **Un seul « Toi » sur la liste de l'hôte** : les invités retrouvent leur nom partout (liste, révélation, journal).
- **« Mousse réfléchit » n'est plus suivi de « à toi de jouer »** : les invités ne sont plus traités comme des sièges locaux par les minuteurs ; la garde anti-AFK couvre aussi les invités silencieux.
- **Le salon ne reste plus bloqué sur « la manche se prépare »** : si l'hôte quitte la table pendant que son téléphone dormait, l'annonce de fin est rejouée à la reconnexion et le salon rouvre.
- **L'hôte retrouve son rôle** s'il reprend le siège 0 après une coupure.

## Bêta 22 : la révélation parle aux invités

- **« Voir la suite » fonctionne enfin chez l'invité** : le tap d'un invité fait avancer la révélation côté hôte (commande `apply`), la conséquence revient en image partagée. Avant, le bouton ne faisait rien du tout.
- **Plus personne ne s'appelle « Toi » chez l'invité** : sur la révélation, le classement et le journal, les voisins retrouvent leurs vrais noms — seul ton siège reste « Toi ».

## Bêta 21 : le salon respire encore

- **Quitter une manche ouvre à nouveau le salon** : l'abandon dit « gameOver » au Worker — plus jamais l'« la manche se prépare » éternel, et les boutons +/− des bots revivent immédiatement.
- Sommeil de l'hôte en pleine manche : le Worker garde la table ouverte et l'hôte **reprend son siège** à la reconnexion (il était la seule personne refusée — « La partie a déjà commencé » en boucle, invités chassés).

## Bêta 20 : pas de paco en ouverture

- **La manche ne s'ouvre jamais sur les paco** : règle standard Perudo (les paco sont jokers, ouvrir dessus donnerait un avantage injuste). Appliquée au moteur, aux bots, à la feuille d'enchères et décrite dans l'écran Règles. Le palifico reste l'exception.

## Bêta 19 : les bots ont leur tempérament

- **L'hôte choisit la difficulté des pirates IA directement dans le lobby** : Mousse, Flibustier ou Capitaine. Le choix règle les bots côté hôte et est transmis aux miroirs pour l'écran de résultat.

## Bêta 18 : qui lance les enchères ?

- **Avant les enchères, un guest voit clairement que seul l’hôte peut les lancer.** Après avoir regardé ses dés, il voit « Seul le maître de la partie peut lancer les enchères. Tu peux déjà regarder tes dés. » au lieu du bouton identique à celui de l’hôte qui ne faisait rien.

## Bêta 17 : une bulle par message

- **Un message envoyé ne s'affiche plus deux fois** : chaque bulle porte maintenant un identifiant de client, repris dans l'écho du Worker. L'écho optimiste, la réponse serveur et toute retransmission du même message sont réconciliés sur cet identifiant (plutôt que seulement sur le texte et la bulle précédente).
- Vérifié par test de régression avec une autre bulle intercalée et un écho serveur retransmis, et par répétition live à deux téléphones sur le vrai Worker.

## Bêta 16 : la main fantôme des pacos

- **La vraie cause des « 5 pacos » du téléphone invité est morte** : chaque snapshot reconstruisait la liste des joueurs de son miroir — et **effaçait les dés dérivés** que la précédente had computed ; les images suivantes ne re-dérivaient que si la graine changeait, ce qui n'arrivait qu'éliminé Souris. Désormais la dérivation est **idempotente** (la même graine redonne exactement les mêmes dés à chaque image) ; les dés survivent à chaque mise à jour du miroir.
- Prouvé répétition-live contre le vrai serveur : la main du miroir est dérivée à chaque image (peek et enchères) sur 23 manches, y compris à la reprise de siège.

## Bêta 15 : les bulles une fois, point

- **Les messages de chat qui apparaissaient en double** (en reprise après un verrouillage) sont réparés : l'ancienne connexion gardait encore un auditeur actif ; désormais toute socket abandonnée est désabonnée puis fermée proprement — plus de doublon possible, et le garde-fou de silence ferme réellement son canal (c'est ce qui lui manquait).
- Test de couverture : le canal fantôme ne peut plus espionner le fil après le transfert.

## Bêta 14 : le sommeil ne verrouille plus personne dehors

- **La cause racine du « Salon injoignable — not upgraded » trouvée** : les sockets fantômes d'un téléphone en veille bloquaient le seuil de 12 connexions, le serveur refusait l'entrée par un 429, et le siège restait invaincu. Désormais le rejoin du même nom **envahit le siège à force** (la socket fantôme est balayée par le serveur), le seuil est porté à 24 et le ping du téléphone est répondu automatiquement même pendant le sommeil du serveur.
- **Diagnostic dans le fil** : si un upgrade est refusé, l'app sonde le serveur immédiatement — « réseau: 200 {"ok":true} » (= le réseau va, le refus vient du serveur) ou « la sonde a échoué » (= un portail/VPN capte le flux).
- **Le client se fait signe de lui-même** : ping sortant toutes les 15 s, répondu sans réveil côté serveur — les mains gelées « 5 pacos » ne devraient plus exister : le miroir reçoit une image fraîche en rejoin (resync).
- Lien « Politique de confidentialité » dans les Réglages (requis Play Store).

## Bêta 13 : toute la table parle sa langue

- **Les libellés de dés du journal et de l'historique** (`4 dés de 5`, `3×P`) sont traduits — plus un seul « dés » français sur un téléphone anglais.
- **Les tempéraments des bots** suivent la langue : Mousse/Flibustier/Capitaine deviennent Cabin Hand/Freebooter/Captain, descriptions comprises (les noms des pirates, eux, restent des noms propres).
- **Les messages système du salon** (reconnexion, débit atteint, création…) sont composés dans la langue du téléphone — la session réseau reçoit un instantané de traduction à chaque frame.
- Reste : rien. L'issue #8 passe la main.

## Bêta 12 : les règles parlent deux langues

- **L'écran Règles est bilingue** (FR/EN) : les huit sections, les conversions, le manuel palifico — tout suit la langue du téléphone.
- Les sémantiques du plateau, du dé caché et de la manche palifico sont traduites aussi (lecteurs d'écran).
- Reste au programme i18n : les libellés de dés du journal (brigade modèle), les portraits des bots, et les messages système du salon — suivi dans l'issue #8.

## Bêta 11 : le salon parle la langue du téléphone

- **Zone salon traduite en entier** : accueil multijoueur, création, rejointe, lobby (partage, fil, barre de réactions) suivent la langue du téléphone, FR/EN. L'esprit des réactions prêtes à l'emploi est conservé entre les deux langues.

## Bêta 10 : le va-et-vient des pirates

- **Reprendre son siège devient instantané** : un téléphone qui rejoint une table en marche (rejoin après avoir quitté, reconnexion) demande la table complète dès son écran de jeu — plus d'attente du prochain coup du voisin pour voir quelque chose.
- Partie testée en conditions réelles contre le serveur : hôte + invité + 3 bots, 23 manches, 28 s de silence radio absorbées, dés identiques des deux côtés à chaque coup d'œil, invité qui PART en pleine manche puis RÉCUPÈRE son siège (deux fois), salon fini rejoint par un troisième téléphone.

## Bêta 9 : les fantômes sont chassés

- **La main « 5 pacos » fantôme est morte** : un invité qui ratait la toute première image de la manche (frame perdue, reprise en cours, petit retard) gardait un plateau vide, et le plateau vide se dessine en pacos par défaut. Les dés se recalculent maintenant dès la première image reçue, quelle que soit la phase.
- **La fin de partie rouvre le salon** : quand le dernier pari est réglé et le podium affiché, la taverne redevient un lobby — un nouveau téléphone peut rejoindre (avant : « La partie a déjà commencée » à jamais). Et tout le monde est ramené du plateau au salon automatiquement.

## Bêta 8 : les boutons respirent

- **« Calza » et « Surenchérir » ne sont plus tronqués** : les libellés des boutons de taverne rétrécissent proprement quand la place manque, au lieu d'être coupés net. L'espacement des lettres se relâche aussi en mode compact.

## Bêta 7 : la table a un battement de cœur

- **Les parties ne meurent plus en silence** : le serveur et l'app se font signe toutes les 20 secondes. Laisser un téléphone réfléchir, lire ses dés ou prendre l'air n'assomme plus la connexion — donc plus de « paris parti dans le vide », de joueurs décrétés AFK alors qu'ils jouaient, de mains figées ou d'écrans qui se regardent mutuellement réfléchir.
- **Les « salons injoignables » ne bouclent plus** : la reconnexion respire (délai doublé à chaque échec, jusqu'à 15 s) et le fil ne répète plus la même phrase à chaque tentative. Un vrai refus du serveur (partie déjà commencée…) est maintenant affiché tel quel.
- Un écran qui ne reçoit plus RIEN pendant 75 s coupe lui-même sa connexion desséchée et revient proprement (au lieu de miroiter un état périmé).
- Règle palifico réécrite dans l'écran Règles (ouverture à 2 dés, une seule manche).
- Le bouton **Calza** est désormais un vrai bouton à côté de « Dudo ! » quand l'option est activée.

Rappel bêta 4 : l'app parle au serveur **`https://dudo.supercloud.fr`**.

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

1. Télécharge **`dudo-v0.2.0-beta.9.apk`** ci-dessous (ou l'artefact du run CI).
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

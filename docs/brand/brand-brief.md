# Dudo — Palette et identité (extraction du brief)

> Version courte, codifiée pour le développement. Le brief complet vit dans le dépôt
> parent (.agents/brand-identity.md) ; les vectoriels de référence sont dans docs/brand/
> (dudo-logo.svg, dudo-icone-app.svg, dudo-monogramme.svg, maquettes : logo-propositions.html).

## Couleurs approuvées

| Rôle | Nom | Hex | Usage |
|---|---|---|---|
| **Primaire froid** | Pavillon Debout | `#1F4C5C` | Nuit marine : fonds profonds, titres, couvertures |
| **Accent principal** | Or d'Étambot | `#E8A33B` | Dés, paris courants, CTA, lumière de bougie |
| **Accent danger** | Rouge Mutin | `#B23A2E` | Uniquement dudo/calza, pertes de dé, élimination — jamais texte courant ni déco |
| **Fond sombre chaud** | Table de Taverne | `#2A1D13` | Fond bois in-app (thème de jour) |
| **Fond clair** | Parchemin | `#F2E8D5` | Pages store, itch.io, documents |
| **Texte clair** | Ivoire | `#F5EFDF` | Texte sur fonds sombres |

## Règles d'usage (non négociables)

1. Le rouge ne touche jamais le texte courant : il signale le risque, pas la déco.
2. Sur fonds sombres : ~80 % bois/ivoire, l'or et le bleu portent le sens uniquement.
3. Palette analogique chaude (brun–or–rouge) + contrepoint froid (marine) : après
   contraste chaud/froid, pas de teal de substitution.
4. **Nuit marine** (thème sombre) : décliner **Pavillon Debout `#1F4C5C`** — assombrir
   vers le même ton cyané (ex. surface `#1F4C5C` → fond nuit ≈ `#14303B`, bordures
   `#0E222A`) plutôt qu'importer un bleu ardoise extérieur du système de marque.
   Structure : *marine = nuit ; or = objet au premier plan ; rouge = alerte ; ivoire = texte.*
5. Lisibilité à 1,3× de taille de police : le contraste prime sur le caractère.

## Typographie

- Titles/labels gravés : **Alkatra** (Google Fonts, gratuite) — wordmark, en-têtes, boutons.
- Corps : **Alegreya Sans** (Google Fonts, gratuite) — 1,5 de line-height, support 1,3×.
- Interdits : script « pirate », grotesque de HUD, toute Snyk famille non listée ici.

## Logo / figures

- Piste retenue : **le gobelet renversé** (bois, contour ivoire gravé) + cinq dés or ;
  la face **as** porte un **perroquet gravé** (bec crochu, queue bifide) — figure signature
  de la marque, réutilisable comme motif (boîte ≈ ±13 × ±17).
- Détails du perroquet selon l'échelle : sombres sur dé or, **ivoire en creux** sur dé
  ivoire, sans détails ≤ 32 px.
- Interdits : crâne, Jolly Roger, œil au bandeau, ancres génériques.

## Découpage en tokens Flutter suggéré

- `surface` (thème bois) = Table de Taverne ; `surface-dark` (thème nuit) = Pavillon Debout assombri.
- `primary` = Or d'Étambot (c'est la couleur action), `error` = Rouge Mutin.
- `onSurface` = Ivoire ; Parchemin reste réservé aux documents du store, pas à de l'UI in-app.

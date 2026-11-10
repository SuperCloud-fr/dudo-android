# Design — Dudo

## Direction

A candlelit pirate tavern seen from the table. Warm wood, worn leather, green felt, brass and ivory dice. The interface is quiet and legible; the dice, the bids and the reveals carry the drama. It is a game of nerve, not a casino: no gold coin counters, no gambling language, no neon.

The visual world is deliberately small and physical: one table, one cup, one private look, one public accusation.

## Tokens

### Colour

| Token | Hex | Role |
|---|---|---|
| `ink` | `#0B0806` | deepest ground, scaffold |
| `wood` | `#1A120C` | tavern walls, card ground |
| `woodDeep` | `#120C08` | room falloff |
| `woodLight` | `#2A1B11` | lit wood, sign edge |
| `grain` | `#3B2718` | hairlines on wood |
| `leather` | `#38241A` | cup, leather cards |
| `leatherLight` | `#4E3324` | lit leather |
| `leatherDeep` | `#241610` | shadowed leather |
| `brass` | `#D2A254` | primary accent, borders, CTA |
| `brassBright` | `#F2CE86` | lit brass, active state |
| `brassDim` | `#8A6934` | quiet borders, labels |
| `candle` | `#FFD98A` | candle glow only |
| `felt` | `#143A2D` | table field |
| `feltLight` | `#1D4E3B` | table highlight |
| `feltDeep` | `#0D2A20` | table edge, tray |
| `parchment` | `#EADABA` | primary text |
| `parchmentDim` | `#C6B08A` | secondary text |
| `parchmentMuted` | `#9A8667` | tertiary text |
| `blood` | `#9C3A31` | dudo, loss, dangerous action |
| `bloodBright` | `#C9584B` | dudo text, alert |
| `bloodDeep` | `#5E211D` | dudo ground |
| `ivory` | `#F4E8CF` | dice body |
| `ivoryShade` | `#D8C4A1` | dice shadow side |
| `dieEdge` | `#7A6345` | dice outline |
| `pip` | `#241A12` | normal pips |
| `ace` | `#A3342C` | ace pip |

These tokens describe the default **Taverne** look. The ambience system (`app_palette.dart`) swaps whole palettes from the settings page — Pavillon Debout (marine & or) is live today; a corporate skin (#6) is planned. Roles (ink/wood/brass/blood/…) stay constant across looks.

Crew accents (rings and sigils), in order: rust `#C9584B`, sea `#5E9C8A`, plum `#A577B8`, ochre `#C99A4B`, slate `#6E8FB8`.

Rules:

- Gold is the primary action and active-turn colour. It is never used for a destructive action.
- Blood red is reserved for dudo, die loss and quitting. It is never decorative.
- No colour alone communicates a state: active turns also get a halo and a text status; matches also get a highlighted die and a count; selected options also get a border and a label.
- The app is dark-only. This is a night scene, not an inverted light theme.

### Type

- **Alkatra** (variable, OFL) — display, signage, numbers, section titles. Hand-carved, carries the brief's rowdy voice. Uppercase for system labels; mixed case for headlines. Letter spacing is generous (1–8) and is part of the inscription voice.
- **Alegreya Sans** (OFL, regular/medium/bold/italic) — body, descriptions, status, buttons, journal. 15–17 for body; 11–13 for labels. Line height 1.4–1.5.
- **Cinzel** (variable, OFL) stays bundled in reserve for long inscriptions; never use either display face for a paragraph.
- Number sizes: quantity in a bid 58–64; section numbers 13; game-over title 40; screen title 30–32.
- Type roles come from `app_typography.dart`; the interface copy ships in French and English via ARB (fr is the source of truth).

### Spacing and shape

- Spacing scale: 4, 8, 12, 16, 24, 32, 48.
- Radii: 10 (small), 16 (cards), 24 (sheets/overlays), 999 (pills and buttons).
- Minimum touch target 48×48 dp. Icon buttons 42–46 visually, with a 48 hit area where possible.
- Content widths: game 760, setup/rules 560, home 430.
- The layout is portrait. Reference phone: 411×914 logical. Small phone: 360×640.

### Materials

- **Wood** is the room: vertical planks, grain, a top-right candle glow, dust, and a heavy vignette. It is painted once and repainted only for the candle flicker.
- **Leather** is the cup, seat medallions and cards. It has a warm gradient and a thin brass edge.
- **Felt** is the table and the dice tray. It is the only large saturated field; it is what the eye should find first.
- **Brass** is structure: borders, studs, stitching, rings, CTA. Thin lines, not thick gold blocks.
- **Ivory** is the dice. The ace pip is red; all other pips are near-black.

## Components

- **`TavernButton`** - gold primary (`gold`), blood destructive (`blood`), ghost secondary (`ghost`). 48-54 dp tall; uppercase display face 12-13 with 1.1-1.6 tracking (auto-shrinks to fit, never truncates); bevel highlight; soft shadow; press scale 0.975; haptic click. An icon is optional.
- **`RoundIconButton`** — 42–44 dp leather medallion with a brass border; used for close, back, journal. Semantic label is mandatory.
- **`DiceFace`** — custom-painted ivory die; 5-pip face with a red centre pip is the app mark. Hidden dice carry a brass compass rose. Highlighted dice get a gold glow; irrelevant dice dim to 34%. Rotation is small (±0.05 rad) and deterministic per position.
- **`LeatherCup`** — one cup, one handle, two brass bands, a stamped "D". It lifts straight up and fades to zero; it never lingers as a ghost.
- **`TableSurface`** — a green felt ellipse with a leather rim, dashed brass stitching and ten studs. It fills the play area but stays below the bid card.
- **`BidCard`** - the current bid, quantity in the display face, face die, note about pacos, bidder and total dice. It is the loudest card on the table, but still smaller than the felt.
- **`PlayerSeat`** — circular sigil, name, five remaining-dice pips, status ("en jeu", "réfléchit", "à toi", "À l'eau"). Active seats get a gold ring and a breathing halo. The current bidder gets a small brass dot.
- **`BidSheet`** — bottom sheet with a quantity stepper, six face choices, a plain-language summary, and a two-button footer. It is prefilled with the most natural raise. Illegal combinations are impossible to announce.
- **`PeekOverlay`** — the private ritual. The cup hides the dice; tapping lifts it. The revealed state summarises "N dés en main · X as". The CTA names who opens.
- **`RevealOverlay`** — opaque full-screen verdict. A wax stamp (DUDO or CALZA), the verdict headline, the bid recap, the actual count, every player's dice with matches highlighted, then the consequence card and the next action.
- **`GameOverOverlay`** — victory/defeat medallion, final standings, rounds, dice left, rematch and return.
- **`JournalSheet`** — every bid, dudo and calza, grouped by round, newest first.

## Layout

- **Home**: small tavern label row, hanging wooden sign, tagline, primary CTA, rules link, decorative felt table edge with dice at the bottom. The table edge is hidden below 740 dp height so the CTA never disappears.
- **Setup**: crew-size card with six medallions, three difficulty cards, calza switch, CTA. Scrollable; at 1.3× the CTA moves below the fold by design.
- **Game**: top bar (close, round and dice count, journal), opponent row, felt table with bid card and history strip, player dice tray, action bar. The table takes the remaining height and absorbs system insets.
- **Overlays**: full-screen, opaque, scrollable, with SafeArea. They never let the table text bleed through.
- System Back must always work: during a game it opens the quit confirmation; overlays are dismissed by their own action or Back. Bots pause while a modal is open.

## Motion

- Press feedback: 90 ms scale.
- Card/bid swaps: 180–320 ms fade + 8–12 px slide.
- Seat halo: 1.9 s breathing loop.
- Thinking dots: 1.1 s loop.
- Cup lift: 900 ms, ease-in-out, cup translates up and out; dice settle in a small stagger.
- Reveal: 850 ms entrance; the stamp uses a short elastic scale; dice rows fade/slide in with an 18 ms stagger.
- Candle flicker: 3.2 s slow glow; the only ambient motion.
- All loops stop and all durations collapse to an instant state when `MediaQuery.disableAnimations` is true.

## Voice

French, direct, second person, a little theatrical, never cute or moralising. Examples:

- "Soulève le cuir. Personne d'autre ne verra tes dés."
- "La table retient son souffle…"
- "Mentez, mais mentez bien."
- "Les pirates t'ont eu."

Avoid: English game jargon, casino words (mise, jackpot, croupier), exclamation marks stacked, and explanations longer than two lines in the heat of a turn.

## Accessibility

- Every icon button, die, seat and overlay state has a semantic label.
- Turn, selection, match and elimination are announced in text, not just colour.
- 48 dp targets; the bid sheet and overlays scroll rather than clip at 1.3× text scale.
- The reveal is a live region; the whole verdict can be read without seeing the highlight.
- Reduce Motion is honoured by every repeating animation.
- Contrast is checked against the dark ground; `parchmentMuted` is for tertiary copy only.

## Platform

Android-first, Material 3 structure. Edge-to-edge with SafeArea and window insets. Portrait is locked for the table. System Back is never trapped. Predictive Back is enabled. The iOS follow-up should reuse the tokens and widgets, add edge-swipe back and safe-area guarantees, and keep Reduce Motion behaviour.

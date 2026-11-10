# Product

<!-- impeccable:product-schema 1 -->

## Platform

android

## Stack

Flutter / Dart, shipping Android from this repository. The game code is kept platform-neutral so an iOS client can reuse it from a separate repository later. This repository does not contain iOS or backend code.

## Users

Solo: one player on an Android phone who knows Perudo (or is curious) and wants a complete, fair-feeling game against opponents without creating an account, waiting for a lobby, or reading a tutorial first.

In the salons: small groups of friends (2 to 6 phones), each pirate on their own device, sharing a six-character code instead of accounts.

Sessions are portrait, one-handed, and often played in low light.

## Product Purpose

Dudo is a Perudo game: the player can face a crew of AI pirates around a tavern table solo, or open a multiplayer salon and let friends lie across the table from their own phones. Success means a whole game fits in one sitting, every call is explainable, and the table wants another round. It is a game, not a gambling product: no money, no ads, no accounts.

## Positioning

A self-contained Perudo table with a readable, characterful crew of opponents — solo or live. The rules engine is exact (pacos wild, dudo, calza, die loss, elimination, palifico) and the bots reason from real probabilities; in a salon the host's phone arbitrates the rules and every guest mirrors the table live, so friends on different phones play the same rolls.

## Operating Context

Played on Android phones in portrait orientation, touch and haptics. Solo play is fully offline. Multiplayer salons run over the internet against a Worker relay (`dudo.supercloud.fr`, API v1) with a shared six-character code; the phones exchange bets and salon chat only, never the dice themselves — each table re-rolls deterministically from a shared seed. No ads, no analytics; the privacy policy is linked from the app.

## Capabilities and Constraints

- Solo game: one human plus 1–5 AI pirates; 5 dice per player; last player with dice wins.
- Standard Perudo bidding with pacos (1s) wild; legal raises enforced by the engine; no opening bid on pacos; dudo challenges, optional calza, and palifico rounds when a pirate is reduced to one die.
- Online salons: up to 6 seats (1 human host + guests + AI pirates), six-character codes, host chooses bot count and difficulty, host-authoritative relay with guest mirrors, seat reclaim on reconnect, 60 s turn timeout, live salon thread (chat, canned reactions).
- Three bot difficulties that differ in risk tolerance and bluffing, using only information a player would have.
- Interface in French and English, chosen by the device language; copy in both is first-class, ARB-driven.
- Android-first. An iOS repository can reuse the game code later.
- Open product decisions: persistent stats and a signed release keystore are not part of the MVP unless added later.

## Brand Commitments

The product name is **Dudo**. The visual world is a warm, dark pirate tavern: wood, leather, candlelight and brass, with a green felt table; a swappable ambience system offers alternatives (today: Pavillon Debout) from the settings page. The tone is playful and slightly theatrical, never grim or gambling-oriented. Interface copy ships in French and English.

## Evidence on Hand

No external assets, testimonials, or licensed artwork. The crew names, avatars, textures and dice are original and generated for this project. The game rules are the commonly played Perudo rules; no official affiliation is claimed.

## Product Principles

1. The table is legible at a glance: whose turn it is, what was bid, and what can be done next.
2. Every call is explainable after the reveal; the player should never feel cheated by hidden information.
3. Bots play like people with different nerves, not like an oracle.
4. The atmosphere earns its place by supporting the game, never by hiding it.
5. Respect the phone: portrait, one hand, 48 dp targets, reduced motion, and no dead ends.

## Accessibility & Inclusion

Touch targets at least 48×48 dp with spacing. Never rely on colour alone for turn, selection or match state. Honour the system font scale and the Remove animations setting. Provide semantic labels for dice, bids, avatars and result states. All text remains readable at 1.3× font scale.

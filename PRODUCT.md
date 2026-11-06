# Product

<!-- impeccable:product-schema 1 -->

## Platform

android

## Stack

Flutter / Dart, shipping Android from this repository. The game code is kept platform-neutral so an iOS client can reuse it from a separate repository later. This repository does not contain iOS or backend code.

## Users

One player on an Android phone, alone, with a few minutes to spare. They know Perudo (or are curious about it) and want a complete, fair-feeling game against opponents without creating an account, waiting for a lobby, or reading a tutorial first. Sessions are portrait, one-handed, and often played in low light.

## Product Purpose

Dudo is a solo Perudo game: the player faces a crew of AI pirates around a tavern table, bidding on dice they cannot see and calling lies. Success means the player can finish a whole game in one sitting, understand every call, and want to start another round. It is a game, not a gambling product: no money, no ads, no online accounts.

## Positioning

A self-contained Perudo table with a readable, characterful crew of opponents. The rules engine is exact (aces wild, dudo, calza, die loss, elimination) and the bots reason from real probabilities, so the game feels like a table of players rather than a random number generator.

## Operating Context

Played on a personal Android phone in portrait orientation, with touch and haptics, usually offline. The player peeks at their own five dice, makes or challenges bids, and watches each round resolve. There is no account, matchmaking, chat, or real-time network dependency.

## Capabilities and Constraints

- Solo game: one human plus 1–5 AI pirates; 5 dice per player; last player with dice wins.
- Standard Perudo bidding with aces (1s) wild; legal raises enforced by the engine; dudo challenges, optional calza, and palifico rounds when a pirate is reduced to one die.
- Three bot difficulties that differ in risk tolerance and bluffing, using only information a player would have.
- French-language interface. No online play, no monetisation, no analytics in this MVP.
- Android-first. An iOS repository and a Cloudflare Worker API are possible follow-ups, deliberately out of scope here.
- Open product decision: player display name and persistent stats are not part of the MVP unless added later.

## Brand Commitments

The product name is **Dudo**. The visual world is a warm, dark pirate tavern: wood, leather, candlelight and brass, with a green felt table. The tone is playful and slightly theatrical, never grim or gambling-oriented. Interface copy is French.

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

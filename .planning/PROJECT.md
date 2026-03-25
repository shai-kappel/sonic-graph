# SonicGraph

## What This Is

SonicGraph is a mobile-first, open-source application that visually maps the macro-evolution of music genres and interconnected relationships between artists. Users explore a 2D node-based infinite canvas — actively building, expanding, and visualizing "connect-the-dots" music history rather than scrolling through vertical lists. It transforms dense open music web data (MusicBrainz, Wikidata) into an intuitive, visual exploration tool.

## Core Value

Users can visually explore how artists and genres connect and evolve on an interactive infinite canvas — spatial discovery, not list-based browsing.

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

(None yet — ship to validate)

### Active

<!-- Current scope. Building toward these. -->

- [ ] Interactive infinite canvas (pan, zoom) with artist nodes and bezier curve edges
- [ ] Dynamic search for a seed artist with immediate network expansion
- [ ] Genre evolution mapping showing macro-level genre relationships
- [ ] Save & share serialized discovery path state (graph JSON via Firestore)
- [ ] Firebase Authentication (email/password + social login)
- [ ] Direct client-side API calls to MusicBrainz and Wikidata (no backend proxy)
- [ ] $0 operating cost architecture (Firebase Spark tier, no Cloud Functions)

### Out of Scope

<!-- Explicit boundaries. Includes reasoning to prevent re-adding. -->

- Offline/local caching (Hive, Isar) — Keep MVP lightweight, online-only
- Cloud Functions proxy — Explicit $0 backend cost constraint
- Web platform — Mobile-first (iOS/Android only) for MVP, web deferred to v2
- Audio integration (Spotify/Apple Music SDKs) — v2 feature
- Collaborative real-time graphs — v2 feature
- Static image sharing — Sharing is serialized graph state only
- Monetization features — Pure open-source community model
- Heavy third-party graph libraries — Using native InteractiveViewer + CustomPaint

## Context

- **Competitive landscape:** Spotify SongDNA and similar tools use vertical list-based UIs for micro-level track trivia. No existing tool provides a spatial 2D canvas for macro-evolution exploration.
- **Data sources:** MusicBrainz REST API (CC0 artist metadata/relationships) and Wikidata SPARQL (genre hierarchy/evolution trees). Both are free, open, and well-documented.
- **API etiquette:** MusicBrainz requires custom User-Agent headers and rate-limiting compliance. Wikidata has generous limits but SPARQL queries should be optimized.
- **Canvas architecture:** Flutter's built-in `InteractiveViewer` for pan/zoom mechanics, `CustomPaint` for drawing bezier edge curves between floating artist nodes. No heavy third-party graph rendering libraries.
- **State management:** Bloc pattern — essential for handling complex async fetching, caching, and state emissions from an expanding graph.
- **Firestore schema:** High-density array design — entire discovery_paths stored as single documents to minimize read operations within Spark tier limits (50K reads/day, 1 GiB storage).

## Constraints

- **Tech stack**: Flutter (Dart) — iOS and Android only for MVP
- **Backend**: Firebase Spark (free tier) — $0 operating cost is non-negotiable
- **Data**: No direct data storage of MusicBrainz content beyond caching — CC0 but must credit MetaBrainz Foundation
- **API**: Direct client-to-API calls only — no serverless proxy layer
- **License**: Apache 2.0 — avoid copyleft/App Store conflicts
- **State management**: Bloc — chosen for complex async graph state handling

## Key Decisions

<!-- Decisions that constrain future work. Add throughout project lifecycle. -->

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| InteractiveViewer + CustomPaint over graph lib | Keep native, avoid heavy dependencies, full control over UX | — Pending |
| Online-only MVP, no local caching | Lightweight initial build, defer complexity | — Pending |
| Serialized graph state sharing (not static images) | Enables collaborative exploration, aligns with sandbox vision | — Pending |
| Direct client API calls, no Cloud Functions | Enforces $0 backend cost for open-source sustainability | — Pending |
| Mobile only (iOS/Android) for MVP | Focus resources on core canvas experience, web deferred to v2 | — Pending |
| Apache 2.0 license | Maximum community adoption, no App Store conflicts | — Pending |
| Bloc for state management | Complex async graph operations require predictable state flow | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-03-25 after initialization*

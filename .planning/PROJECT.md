# SonicNomad

## What This Is

SonicNomad is a mobile-first, open-source application that visually maps the macro-evolution of music genres and interconnected relationships between artists. Users explore a 2D node-based infinite canvas — actively building, expanding, and visualizing "connect-the-dots" music history rather than scrolling through vertical lists. It transforms dense open music web data (MusicBrainz, Wikidata) into an intuitive, visual exploration tool.

## Core Value

Users can visually explore how artists and genres connect and evolve on an interactive infinite canvas — spatial discovery, not list-based browsing.

## Current State

**Shipped:** [Milestone 1: Foundation & Canvas](.planning/milestones/v1-ROADMAP.md) (v1.0)
- Interactive 100-node canvas (60fps)
- Nebula Ethereal design system
- Automated CI/CD & Security pipeline

**Next Milestone Goals:**
- [Milestone 2: Data Exploration](.planning/ROADMAP.md#milestone-2-data-exploration-phase-3-4)
- Live MusicBrainz integration
- Artist search & relationship expansion
- Genre cluster visualization via Wikidata

## Requirements

### Validated
- [x] Interactive infinite canvas (pan, zoom) with artist nodes and bezier curve edges (v1.0)
- [x] 60fps performance with 100+ nodes (v1.0)
- [x] Glassmorphic Nebula Ethereal aesthetic (v1.0)

### Active
- [ ] Dynamic search for a seed artist with immediate network expansion
- [ ] Genre evolution mapping showing macro-level genre relationships
- [ ] Save & share serialized discovery path state (graph JSON via Firestore)
- [ ] Firebase Authentication (email/password + social login)
- [ ] Direct client-side API calls to MusicBrainz and Wikidata (no backend proxy)
- [ ] $0 operating cost architecture (Firebase Spark tier, no Cloud Functions)

<details>
<summary>Archived Milestone 1 Requirements</summary>

See: [.planning/milestones/v1-REQUIREMENTS.md](.planning/milestones/v1-REQUIREMENTS.md)
</details>

## Out of Scope
- Offline/local caching (Hive, Isar) — Keep MVP lightweight, online-only
- Cloud Functions proxy — Explicit $0 backend cost constraint
- Web platform — Mobile-first (iOS/Android only) for MVP, web deferred to v2
- Audio integration (Spotify/Apple Music SDKs) — v2 feature
- Collaborative real-time graphs — v2 feature
- Static image sharing — Sharing is serialized graph state only
- Monetization features — Pure open-source community model
- Heavy third-party graph libraries — Using native InteractiveViewer + CustomPaint

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| InteractiveViewer + CustomPaint | Keep native, full control over UX, high performance | Validated (v1.0) |
| RepaintBoundary Isolation | Maintain 60fps by caching static background/edge layers | Validated (v1.0) |
| Map-based Painter Lookups | O(1) performance for edge drawing | Validated (v1.0) |
| Gitleaks & Trivy in CI | Early detection of secrets and vulnerabilities | Validated (v1.0) |
| Online-only MVP | Lightweight initial build, defer complexity | Pending |
| Direct client API calls | Enforces $0 backend cost for open-source sustainability | Pending |

---
*Last updated: 2026-03-30 after Milestone 1 completion*

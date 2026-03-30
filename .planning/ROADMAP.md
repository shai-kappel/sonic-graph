# Roadmap: SonicNomad

- **[Milestone 1: Foundation & Canvas (Phase 1-2)](milestones/v1-ROADMAP.md)** - Completed 2026-03-30. 100-node 60fps canvas + CI/CD.

## Milestone 2: Data Exploration (Phase 3-4)
**Goal:** Connect to live music metadata and implement dynamic discovery.

### Phase 3: MusicBrainz Integration
- [ ] Implement rate-limited API client for MusicBrainz. [MB-01]
- [ ] Search feature to find seed artists. [MB-02]
- [ ] "Expand Node" logic to fetch and display relationships. [MB-03]

**Plans:** 3 plans
- [ ] 03-01-PLAN.md — MusicBrainz Infrastructure (Wave 1)
- [ ] 03-02-PLAN.md — Artist Search & Seed Node (Wave 2)
- [ ] 03-03-PLAN.md — Node Expansion & Relationships (Wave 3)

### Phase 4: Wikidata & Macro-Evolution
- [ ] SPARQL client for fetching genre hierarchies.
- [ ] Map artist MBIDs to Wikidata QID mapping.
- [ ] Render genre clusters and parent/child evolution lines.

## Milestone 3: Persistence & Sharing (Phase 5-6)
**Goal:** User accounts and the ability to save/share discovery paths.

### Phase 5: Firebase Integration
- [ ] Set up Firebase project and auth (Google, Apple, GitHub).
- [ ] Save graph state as serialized JSON to Firestore.
- [ ] User dashboard for "Saved Paths."

### Phase 6: Deep Linking & Sharing
- [ ] Generate unique share links for discovery paths.
- [ ] Handle incoming links to load and visualize shared graphs.

## Milestone 4: Polish & Deployment (Phase 7)
**Goal:** High-fidelity visuals and App Store readiness.

### Phase 7: Final Polish
- [ ] Implement multi-layered shadows and glow effects.
- [ ] Add subtle noise texture to background.
- [ ] Performance audit for low-end devices.
- [ ] Prepare deployment metadata.

---
*Last updated: 2026-03-30*

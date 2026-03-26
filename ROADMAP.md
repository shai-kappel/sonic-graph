# Roadmap: SonicGraph

## Milestone 1: Foundation & Canvas (Phase 1-2)
**Goal:** Establish the interactive infinite canvas and basic node rendering.

### Phase 1: Project Scaffolding
- [ ] Initialize Flutter project (iOS/Android).
- [ ] Set up theme with Glassmorphic Deep Blue aesthetic.
- [ ] Integrate BLoC for state management.
- [ ] Configure `InteractiveViewer` for pan/zoom.

### Phase 2: Static Canvas & Node Rendering
- [ ] Implement custom painter for bezier curves.
- [ ] Create basic node widget (glassmorphic cards).
- [ ] Mock graph data to test rendering performance (50+ nodes).

## Milestone 2: Data Exploration (Phase 3-4)
**Goal:** Connect to live music metadata and implement dynamic discovery.

### Phase 3: MusicBrainz Integration
- [ ] Implement rate-limited API client for MusicBrainz.
- [ ] Search feature to find seed artists.
- [ ] "Expand Node" logic to fetch and display relationships.

### Phase 4: Wikidata & Macro-Evolution
- [ ] SPARQL client for fetching genre hierarchies.
- [ ] Map artist MBIDs to Wikidata QIDs.
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
*Last updated: 2026-03-25*

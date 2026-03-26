# Roadmap: SonicGraph

## Milestone 1: Foundation & Canvas (Phase 1-2)
**Goal:** Establish the interactive infinite canvas and basic node rendering.

### Phase 1: Project Scaffolding
- [x] Initialize Flutter project (iOS/Android).
- [x] Set up theme with Glassmorphic Deep Blue aesthetic.
- [x] Integrate BLoC for state management.
- [x] Configure `InteractiveViewer` for pan/zoom.

### Phase 01.1: CI/CD Pipeline & Security Scanning (INSERTED)
**Goal:** Establish GitHub Actions CI pipeline with static analysis, security scanning (Gitleaks, Trivy), Dependabot, architecture linting, dotenv secrets consolidation, and public repo readiness (OpenSSF Scorecard, SECURITY.md).
**Requirements**: Complete
**Depends on:** Phase 1
**Plans:** 3/3 plans executed
- [x] Plan A: GitHub Actions CI Pipeline (Wave 1)
- [x] Plan B: Security Scanning & Dependency Management (Wave 1)
- [x] Plan C: Secrets Consolidation, Architecture Check & Public Repo Readiness (Wave 2)

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
*Last updated: 2026-03-26*

# Requirements: SonicGraph

## Core Vision
A mobile-first, interactive infinite canvas for music history exploration.

## User Persona
- **The Music Historian:** Enthusiasts who want to visualize how their favorite artists and genres are interconnected.
- **The Casual Explorer:** Users looking for new music through spatial, discovery-based navigation.

## Functional Requirements

### 1. Interactive Infinite Canvas
- [ ] Pan & Zoom (using `InteractiveViewer`).
- [ ] Render artist nodes as floating cards with glassmorphic styling.
- [ ] Draw bezier curve edges representing relationships (influenced by, member of).
- [ ] Smooth animations when expanding nodes.

### 2. Semantic Search & Seed Discovery
- [ ] Search input for artists (MusicBrainz Search API).
- [ ] Select a seed artist to initialize the canvas.
- [ ] Tapping a node fetches and expands the local neighborhood.

### 3. Macro-Evolution Mapping
- [ ] Fetch genre hierarchies for selected artists (Wikidata SPARQL).
- [ ] Visualize genre clusters and evolution paths on the canvas.
- [ ] Ability to toggle between "Artist-level" and "Genre-level" views.

### 4. Authentication & Personalization
- [ ] Firebase Auth integration (Google, Apple, GitHub).
- [ ] Save individual "Discovery Paths" (graph state).
- [ ] User library of previously saved graphs.

### 5. Sharing & Export
- [ ] Generate unique "Share Links" for a discovery path.
- [ ] Shareable URLs that deep-link into the app to load the serialized JSON graph.

## Non-Functional Requirements

### 1. Performance
- [ ] Maintain 60fps during pan/zoom even with 50+ nodes.
- [ ] Lazy-load relationships to avoid blocking the UI.
- [ ] Efficient JSON serialization for graph state.

### 2. Cost & Constraints
- [ ] **0 Operating Cost:** Must remain within Firebase Spark tier limits.
- [ ] Direct client-to-API calls (no backend proxy).
- [ ] Strict rate-limit compliance for MusicBrainz (1 req/s).

### 3. Visual Aesthetic
- [ ] **Glassmorphic Deep Blue:** High-end tactile feel.
- [ ] Multi-layered drop shadows for depth.
- [ ] Glow effects on interactive elements.

## Future Scope (Out of Scope for MVP)
- Offline/local caching beyond simple session cache.
- Collaborative real-time graph editing.
- Audio playback/streaming SDK integration.
- Web platform support.

---
*Last updated: 2026-03-25*

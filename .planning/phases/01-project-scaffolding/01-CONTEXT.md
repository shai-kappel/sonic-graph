# Phase 1: Project Scaffolding - Context

**Gathered:** 2026-03-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Initialize the Flutter project with theme, BLoC state management, and InteractiveViewer canvas. This includes configuring dev/prod environment separation from day one to support app store publishing under the production account.

</domain>

<decisions>
## Implementation Decisions

### App Identity & Bundle Configuration
- **D-01:** Production bundle ID (Android): `com.indiedesert.sonicgraph`
- **D-02:** Dev flavor bundle ID (Android): `com.indiedesert.sonicgraph.dev` (`.dev` suffix enables side-by-side install)
- **D-03:** iOS bundle ID follows Apple convention: `com.indiedesert.SonicGraph` (capital S)
- **D-04:** iOS dev flavor: `com.indiedesert.SonicGraph.dev`
- **D-05:** App display name: "SonicGraph" for now — easy to change later (just a string in config). Name may change before store launch.
- **D-06:** Bundle IDs owned by the prod account (`admin@indiedesert.com`)

### Dev/Prod Environment Separation
- **D-07:** Two Flutter flavors: `dev` and `prod`
- **D-08:** Firebase dev project: `shai.kappel@gmail.com` account — set up first
- **D-09:** Firebase prod project: `admin@indiedesert.com` account — deferred, directory structure prepared only
- **D-10:** Per-flavor config files use Android standard flavor directories: `android/app/src/dev/` and `android/app/src/prod/`
- **D-11:** iOS equivalent: separate `GoogleService-Info.plist` per flavor scheme
- **D-12:** For Phase 1, only dev Firebase config is active — prod structure is placeholder

### Publishing Context
- **D-13:** End goal: publish to Google Play and App Store
- **D-14:** GitHub repo under `shai.kappel@gmail.com` (open source)
- **D-15:** CI/CD and app store signing setup deferred to later phase
- **D-16:** App store readiness defaults (min SDK, permissions, metadata) deferred

### Agent's Discretion
- Exact Dart flavor configuration approach (build flags vs flavor configs)
- Gradle productFlavors configuration details
- iOS scheme setup specifics
- Whether to use `--dart-define` or `--flavor` for env switching

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project configuration
- `.planning/PROJECT.md` — Core vision, constraints ($0 operating cost, Firebase Spark tier), tech stack decisions
- `.planning/REQUIREMENTS.md` — Functional and non-functional requirements, visual aesthetic spec
- `.planning/config.json` — Workflow and design token configuration

### API research
- `.planning/research/API_SPEC.md` — MusicBrainz and Wikidata API specifications, rate limiting rules

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- None — project is empty (only `.planning/` and `.git/` exist)

### Established Patterns
- None yet — this phase establishes all foundational patterns

### Integration Points
- Flutter project root is `/home/shai/Projects/sonic-graph`
- `.planning/` directory already contains roadmap, requirements, and research

</code_context>

<specifics>
## Specific Ideas

- Dev environment on personal account (`shai.kappel@gmail.com`) for rapid iteration
- Prod environment on business account (`admin@indiedesert.com`) for store publishing
- "SonicGraph" is a working title — architecture should not hardcode the display name in places that are hard to change

</specifics>

<deferred>
## Deferred Ideas

- CI/CD pipeline (GitHub Actions for lint, analyze, build) — separate phase
- App store signing configuration and metadata — separate phase
- Prod Firebase project setup — prep directory only in Phase 1
- Branch protection and contributor guidelines — separate phase

</deferred>

---

*Phase: 01-project-scaffolding*
*Context gathered: 2026-03-25*

# Phase 1: Project Scaffolding — Research

**Researched:** 2026-03-25
**Status:** Complete

## 1. Flutter Project Initialization (iOS/Android)

### Project Creation
- Use `flutter create` with org name: `flutter create --org com.sonicgraph --platforms android,ios sonic_graph`
- Or initialize in existing directory with `flutter create --org com.sonicgraph --platforms android,ios .`
- The project is currently empty (only `.planning/` and `.git/` exist)

### Recommended Folder Structure (Feature-First + Layered)
```
lib/
├── app/                    # App-level setup (MaterialApp, routing, DI)
│   ├── app.dart
│   ├── router.dart
│   └── di.dart
├── core/                   # Shared utilities, constants, extensions
│   ├── theme/              # Design system & theme data
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── constants/
│   └── utils/
├── features/               # Feature-first organization
│   └── canvas/             # The infinite canvas feature
│       ├── presentation/
│       │   ├── bloc/
│       │   ├── pages/
│       │   └── widgets/
│       ├── domain/
│       └── data/
└── main.dart
```

### Key Dependencies (Phase 1 only)
- `flutter_bloc` — BLoC state management
- `equatable` — Value equality for BLoC states/events
- `get_it` — Dependency injection

## 2. InteractiveViewer for Infinite Canvas

### Core Configuration
```dart
InteractiveViewer(
  boundaryMargin: EdgeInsets.all(double.infinity), // Infinite pan
  minScale: 0.1,
  maxScale: 4.0,
  constrained: false,       // Allow child larger than viewport
  clipBehavior: Clip.none,   // Don't clip content at boundaries
  transformationController: _transformController,
  onInteractionStart: _onPanStart,
  onInteractionUpdate: _onPanUpdate,
  onInteractionEnd: _onPanEnd,
  child: CustomPaint(/* ... */),
)
```

### Key Patterns
- **`boundaryMargin: EdgeInsets.all(double.infinity)`** — Critical for infinite pan behavior
- **`constrained: false`** — Allows the child to exceed viewport bounds
- **`TransformationController`** — Programmatic zoom/pan control, initial position setting
- **Performance:** Use `InteractiveViewer.builder` for large content, but for Phase 1 with `CustomPaint`, standard constructor is sufficient
- **Coordinate Systems:** Track world-space vs viewport-space transformations via the controller's `value` (Matrix4)

### Gotchas
- `InteractiveViewer` clips by default — must set `clipBehavior: Clip.none`
- Gesture conflicts with child widgets — wrap tappable children carefully
- Initial centering requires post-frame callback to set transformation

## 3. Glassmorphic Deep Blue Theme

### Implementation Approach (Native, No Third-Party)
Use `BackdropFilter` + `ClipRRect` for the frosted glass effect:

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
    ),
  ),
)
```

### Color Palette (Deep Blue Glassmorphic)
| Token | Value | Usage |
|-------|-------|-------|
| `canvasBackground` | `Color(0xFF0A0E27)` | Main background |
| `surfaceGlass` | `Colors.white.withOpacity(0.08)` | Card/node fill |
| `borderGlass` | `Colors.white.withOpacity(0.15)` | Subtle borders |
| `accentPrimary` | `Color(0xFF6C63FF)` | Interactive elements |
| `accentGlow` | `Color(0xFF00D4FF)` | Glow highlights |
| `textPrimary` | `Color(0xFFE8EAED)` | Primary text |
| `textSecondary` | `Color(0xFF9AA0A6)` | Secondary text |

### Multi-Layered Shadows
```dart
boxShadow: [
  BoxShadow(color: Color(0x40000000), blurRadius: 20, offset: Offset(0, 8)),
  BoxShadow(color: Color(0x200A0E27), blurRadius: 40, offset: Offset(0, 16)),
]
```

### Glow Effects
- Use `BoxShadow` with accent color and high spread for glow: `BoxShadow(color: accentPrimary.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)`
- Apply to interactive/focused elements only for performance

## 4. BLoC Integration

### Package Setup
- `flutter_bloc: ^9.x` — Core BLoC widgets (BlocProvider, BlocBuilder, BlocListener)
- `equatable: ^2.x` — Immutable state/event equality
- `get_it: ^8.x` — Service locator for DI

### Phase 1 BLoC: CanvasBloc
For Phase 1, a single BLoC manages canvas state (zoom level, pan offset, viewport):

```dart
// Events
abstract class CanvasEvent extends Equatable {}
class CanvasInitialized extends CanvasEvent {}
class CanvasTransformed extends CanvasEvent { final Matrix4 matrix; }

// States
class CanvasState extends Equatable {
  final double zoomLevel;
  final Offset panOffset;
  final bool isInitialized;
}
```

### Best Practices Applied
- **Single responsibility:** One BLoC per feature area (canvas)
- **Immutable states:** Use `copyWith()` pattern with Equatable
- **No logic in UI:** All transform calculations in BLoC
- **`buildWhen`:** Use on BlocBuilder to minimize widget rebuilds

## 5. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| InteractiveViewer gesture conflicts | Medium | Isolate tappable widgets, use HitTestBehavior.translucent |
| BackdropFilter performance on low-end | Medium | Limit blur to small areas, reduce sigma on older devices |
| Over-engineering for Phase 1 | Low | Keep minimal — only canvas + theme + bloc shell |

---
*Phase: 01-project-scaffolding*
*Research completed: 2026-03-25*

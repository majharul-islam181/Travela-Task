# Travela — Property Search (Take-Home Task)

A single-screen Flutter application implementing real-time travel property search over Server-Sent Events (SSE), location autocomplete, and filter controls.

##  Architecture & Design Decisions

The codebase follows Clean Architecture with a **feature-first** structure:

```text
lib/
├── app/
│   └── app_di/
│       └── app_di.dart       # Master Dependency Injection setup
├── core/
│   └── di/
│       └── core_di.dart      # Core-level registrations (Network, Storage)
└── features/
    ├── di/
    │   └── property_search_di.dart # Feature-specific DI wiring
    └── property_search/
        ├── data/             # Datasources, DTO models & repository implementations
        ├── domain/           # Entities, repository contracts & use cases
        └── presentation/     # BLoC, pages & UI components

```

* **State & Data Flow:** Uses `flutter_bloc` for state management and `dartz` (`Either<Failure, T>`) for  error handling across domain boundaries.
* **Network Layer:** Powered by `dio`. Requests use `CancelToken` to abort stale autocomplete queries and active SSE streams whenever user input changes or the widget disposes.
* **Sentinel CopyWith Pattern:** To handle setting nullable state properties back to `null` cleanly, a private sentinel object pattern is used across BLoC states.

##  SSE Stream Handling

The search endpoint returns a `text/event-stream`. Instead of waiting for the full HTTP payload to finish, the app parses the incoming byte stream frame-by-frame:

```dart
body.stream
  .cast<List<int>>()
  .transform(utf8.decoder)
  .transform(const LineSplitter());

```

Frames are transformed into domain events (`meta`, `item`, `done`, `error`). Property cards appear incrementally on the screen as `item` events land without blocking the UI thread.

---

## Flavors

The project supports two flavor entry points:

* **Dev:** `lib/main_development.dart` (Default via `lib/main.dart`)
* **Prod:** `lib/main_production.dart`

### Commands

```bash
# Run Development
flutter run -t lib/main_development.dart

# Run Production
flutter run -t lib/main_production.dart

```
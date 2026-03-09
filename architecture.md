# TKD Brackets: Core Architecture (Lean Reference)

Target Architecture for **TKD Brackets** MVP and future scalability. Focus on offline-first reliability and high-performance bracket generation.

## 1. Primary Tech Stack
- **Platform**: Flutter Web & Tablet (Landscape Only) - Cross-platform enabled.
- **Runtime**: Dart 3.9+.
- **Database**: `drift` (Primary Local) + `supabase_flutter` (Remote).
- **State Management**: `flutter_bloc`.
- **DI**: `injectable` + `get_it`.
- **Navigation**: `go_router` + `go_router_builder`.
- **Models**: `freezed` + `json_serializable`.
- **Logic**: `fpdart` (Functional error handling).

---

## 2. Core Architectural Decisions
- **Offline Strategy**: Local-First, Background Resync. `Drift` is the source of truth during matches.
- **Sync Pattern**: Automatic resync to Supabase on reconnection via `SyncManager` using a **Transaction Log Pattern** in Drift. Use a `syncAware` wrapper in repositories to ensure local safety.
- **Security (Scale Ready)**: Standard RLS (`tenant_id = auth.uid()`) for MVP; migrate to **Custom Claims in JWT** for v1.1.
- **Bracket Rendering**: **Viewport-Aware Pattern/LOD** in `BracketCanvas` to support 100+ athlete divisions.

---

## 3. Project Structure: Feature-First Clean Architecture

### **Layer Isolation Rules (MANDATORY)**
| Layer            | Can Depend On       | CANNOT Depend On                      |
| :--------------- | :------------------ | :------------------------------------ |
| **Presentation** | Domain              | Data, External SDKs (Supabase/Drift)  |
| **Domain**       | Nothing (Core only) | **Data, Presentation, External SDKs** |
| **Data**         | Domain (Interfaces) | Presentation                          |

**The Domain Rule**: The `Domain` layer must be pure Dart. No `import 'package:supabase_flutter/...'` or `drift` types in entities/interfaces.

```text
lib/
├── main.dart                      # Entry & BlocProvider setup
├── core/                          # Cross-cutting Infrastructure
│   ├── di/                        # Injectable & GetIt config
│   ├── error/                     # failures.dart & Either types
│   ├── network/                   # Supabase client wrapper
│   ├── persistence/               # Drift DB, Mappers, Transaction Log
│   ├── router/                    # GoRouter & @TypedGoRoutes
│   ├── theme/                     # Material 3 & ThemeCubit
│   └── utils/                     # PDF Generator, Seeding Services
└── features/                      # Domain Vertical Slices
    ├── auth/                      # Login & User Session
    ├── participant/               # Participant & Athlete Management (Dojang)
    ├── tournament/                # Tournament Metadata & settings & RINGS
    └── bracket/                   # SEEDING ENGINE & SCORING
        ├── domain/                # Entities, Repositories, Use Cases
        ├── data/                  # Repo Impl, DataSources
        └── presentation/          # BLoCs, BracketCanvas, ScoringUI
```

---

## 4. Implementation Patterns & Consistency Rules

### Naming & Coding
- **Drift Tables**: Plural (e.g., `Tournaments`).
- **JSON**: `snake_case`. **Dart Models**: `camelCase`.
- **Repos**: `get...` (fetch), `save...` (persist). Return `Either<Failure, T>`.
- **States**: Use `freezed` unions (`initial`, `loading`, `success`, `failure`).
- **Events**: Past-Tense Verbs (e.g., `ScoreUpdated`).

### Data Mapping & Error Handling
- **Pure Entities**: Domain entities must be pure Dart (no `json_serializable` in domain).
- **Mappers**: Mapping happens strictly in `DataLayer` via `toDomain()` and `fromDomain()`.
- **Error Mapping**: **Exception -> Failure mapping MUST happen in the DATA layer.** UseCases only handle `Failure` types, never raw `PostgrestException` or `IOException`.

### Environment Strategy
- **Flavors**: Use `main_development.dart` and `main_production.dart`. 
- **Demo Mode**: Local-only demo state uses `is_demo_data` flag in Drift; migrate to Supabase on signup.

### Rules for Agents
1. All page route registration MUST be centralized in `core/router/app_router.dart`.
2. Repositories MUST use `@LazySingleton(as: IFeatureRepository)`.
3. Use `fpdart` to handle all potential exceptions; never throw raw exceptions to the BLoC.

---

## 5. Development Principles (SOLID, DRY, KISS, DI)

### **SOLID (Clean Implementation)**
- **S (Single Resp)**: 1 Repository per Feature. 1 Mapper per Data Model.
- **O/L (Open/Liskov)**: Generators (`SingleElimination`, `RoundRobin`) must implement a common `IBracketGenerator`.
- **I (Interface Segregation)**: BLoCs only interact with Domain-layer `Interfaces`, never `@Data` layer implementation classes.
- **D (Dependency Inversion)**: All external side-effects (DB, API, Prefs) must be injected interfaces.

### **DRY (Anti-Duplication)**
- **Mappers Only Once**: Do not duplicate `toDomain/fromDomain` logic across repositories.
- **Shared UI**: Cross-feature widgets (Buttons, Inputs) must live in `core/theme/widgets`.
- **Logic Reuse**: Shared Seeding/Sorting algorithms live strictly in `core/utils`.

### **KISS (Keep It Scalable & Simple)**
- **No Global Singletons**: Avoid `MyService.instance`. Always use `GetIt` via constructor injection.
- **Cubit vs BLoC**: Use `Cubit` for simple read-only UI state; use `BLoC` for complex event-driven logic (Scoring/Generation).
- **No Over-Engineering**: Don't build multi-admin Realtime logic until MVP "SyncLog" is stable.

### **DI (Injectable Setup)**
- **Construction Injection**: Mandatory for all BLoCs and UseCases.
- **Environment Targeting**: Use `@dev`, `@prod` if mock data sources are required for CI.
- **Lazy Load**: Default to `@LazySingleton` for all Repositories/Services to optimize startup performance.

---

## 6. Integration Points
- **User Action** -> **BLoC** (State Change) -> **Repository** (Domain Interface).
- **Repository Impl** -> **Local Store** (Drift Transaction Log) -> **SyncManager** (Supabase Push).

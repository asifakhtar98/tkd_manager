---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
inputDocuments:
  - "_bmad-output/planning-artifacts/prd.md"
  - "temp/ux-design-specification.md"
  - "temp/architecture.md"
  - "project.md"
  - "dev_guide.md"
workflowType: "architecture"
project_name: "tkd_saas"
user_name: "Asak"
date: "2026-03-09T14:13:13+05:30"
lastStep: 8
status: "complete"
completedAt: "2026-03-09T14:18:26+05:30"
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

---

## Project Context Analysis (Lean MVP Alignment)

### Requirements Overview

**Functional Requirements:**
The project centers on a specialized **TKD Tournament Manager** with a core focus on automating the high-friction aspects of tournament organization (FR1-12). Specifically, the **Generation Engine** and **Dojang Separation Seeding** are the primary "magic" features. Tournament data is cloud-backed via Supabase.

**Non-Functional Requirements:**

- **Friction-Free Performance:** Focus on UI responsiveness and "instant-feel" interactions. Target division sizes < 32 for optimal canvas performance.
- **Cloud-Backed Reliability:** Tournament data is stored in Supabase (PostgreSQL) with automatic backups. UI state (bracket format, participant list) persists locally via HydratedBloc.
- **Lean Security:** Multi-tenant separation using `tenant_id` (standard `auth.uid()` checks in RLS).

**Scale & Complexity:**

- **Primary domain:** Flutter Web SaaS (Cloud-First Architecture)
- **Complexity level:** Medium (Focused MVP)
- **Estimated architectural components:** 10-12 major components.

### Technical Constraints & Dependencies

- **Platform:** Flutter Web (optimized for landscape on desktop and tablet).
- **Supabase:** Core dependency for Auth, Database, and Storage.
- **UI-Local State Management:** HydratedBloc for persisting bracket setup state across app restarts.
- **Cloud-First Data:** Tournament match data is stored in Supabase PostgreSQL as the primary source of truth.

### Cross-Cutting Concerns Identified

- **Authentication:** Standard Supabase Auth Flow with PKCE security.
- **Cloud Data Persistence:** One-way data storage to Supabase via Repository implementations.
- **Feature-Specific BLoCs:** Maintaining Clean Architecture separation for long-term maintainability.
- **Theming System:** Material 3 with dynamic seed color tokens.

---

## Starter Template Evaluation

### Primary Technology Domain

**Flutter Web SaaS** with Cloud-First Architecture (Supabase backend).

### Starter Options Considered

| Option                        | Fit for MVP     | Rationale                                                                                   |
| :---------------------------- | :-------------- | :------------------------------------------------------------------------------------------ |
| **Official `flutter create`** | **Selected**    | Best for custom Clean Architecture; avoids template bloat while providing core foundations. |
| **Very Good CLI**             | **Alternative** | Strong standards (VGV), but uses different DI/state management defaults.                    |
| **ApparenceKit**              | **Rejected**    | Riverpod-based, causing friction with BLoC preference.                                      |

### Selected Starter: Custom Scaffold with `flutter create`

**Rationale for Selection:**

- **Intermediate Alignment:** Matches established comfort level with `injectable`, `flutter_bloc`, and `go_router`.
- **Cloud-First Architecture:** Custom setup with Supabase ensures tournament data is reliably stored with automatic backups.

**Initialization Commands (Latest Current Versions):**

```bash
# Create project with web-only intent
flutter create tkd_saas --platforms web --empty

# Add core dependencies (Latest Stable)
flutter pub add flutter_bloc injectable go_router supabase_flutter hydrated_bloc fpdart freezed_annotation

# Add dev dependencies for code generation
flutter pub add --dev build_runner injectable_generator go_router_builder freezed json_serializable
```

**Architectural Decisions Provided by Starter:**

- **Language & Runtime:** Dart 3.9+ with strict null safety and functional extensions via `fpdart`.
- **State Management:** `flutter_bloc` for predictable UI state; `hydrated_bloc` for UI state persistence across app restarts.
- **Dependency Injection:** `injectable` + `get_it` for annotation-based injection.
- **Navigation:** `go_router` with type-safe `go_router_builder`. Routes are centralized in `core/router/app_router.dart`.
- **Cloud Storage:** Supabase (PostgreSQL) for tournament data persistence.
- **Code Organization:** Clean Architecture (Data/Domain/Presentation).

---

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**

- **Data Persistence:** Cloud-first with Supabase as primary storage. Tournament data requires internet connection for creation and updates.
- **Communication:** One-way data push from client to Supabase. No real-time subscriptions in MVP.
- **Security Pattern:** Standard Supabase RLS via `auth.uid()` filtering for multi-tenant isolation.

**Important Decisions (Shape Architecture):**

- **State Management:** Feature-specific BLoCs (Maintenance of Clean Architecture boundaries).
- **Navigation:** Centralized type-safe `go_router_builder` with `@TypedGoRoute`.
- **Data Models:** `freezed` + `json_serializable` for all Models and States.

**Deferred Decisions (Post-MVP):**

- Bidirectional background sync with auto-conflict resolution.
- Custom JWT claims for federation-level RBAC.
- Multi-ring live websocket updates (Realtime Subscriptions).

### Data Architecture

- **Database:** Supabase PostgreSQL (Remote). Actual implementation uses Supabase client directly without local Drift caching for tournament data.
- **UI State Persistence:** HydratedBloc maintains bracket setup state (format selection, participant list) for app restart recovery.
- **Multi-Tenancy:** Shared Database + `tenant_id` (user's auth.uid) column enforced via Supabase RLS.
- **Modeling:** DDD-inspired "Aggregate Roots" for Tournaments and Brackets to simplify API and business logic.
- **Validation:** Functional validation in the Domain layer using `fpdart` `Either`.

### Authentication & Security

- **Method:** Supabase Email/Password Auth.
- **Authorization:** Standard RLS policies ensuring users only `SELECT/UPDATE` rows where `tenant_id = auth.uid()`.
- **Public Results:** Dedicated "View-Only" RLS policy for spectator links.

### API & Communication Patterns

- **Pattern:** Direct cloud storage via Supabase client in Repository implementations.
- **Data Flow:** Changes are immediately persisted to Supabase. No local transaction log or sync queue.
- **Error Handling:** Centralized `Either<Failure, T>` return types for all data operations.

### Frontend Architecture

- **State:** `flutter_bloc` with **Feature-Specific BLoCs** (e.g., `AuthenticationBloc`, `ParticipantBloc`, `BracketBloc`, `TournamentBloc`).
- **UI State Persistence:** `HydratedBloc` for saving bracket format and participant list state across app restarts.
- **Routing:** Type-safe, centralized route definitions in `core/router/app_router.dart`.
- **Theming:** Token-based Material 3 system with dynamic seed colors.

### Decision Impact Analysis

**Implementation Sequence:**

1. Project Scaffold with Clean Architecture folders.
2. `core/` infrastructure: DI, Router, and Theme setup with Supabase client.
3. Authentication: Supabase Email/Password flow with PKCE.
4. **Bracket Generation Engine** with Domain-layer pure functions.
5. Scoring logic with Supabase cloud persistence.
6. PDF export and utilities.

**Cross-Component Dependencies:**

- Feature-Specific BLoCs depend on Domain Repositories (Interfaces).
- Sync Logic depends on the Local Repository and Supabase Client.

---

## Implementation Patterns & Consistency Rules

To prevent implementation conflicts between AI agents and ensure a high-quality internal architecture, all development must adhere to these patterns.

### Naming Conventions

**Database & Models:**

- **Drift Tables:** Use plural names ending in `s` (e.g., `Tournaments`). Drift-generated companions use the singular.
- **JSON Fields:** `snake_case` (matching Supabase defaults).
- **Dart Models:** `camelCase` (matching Flutter standards).

**Repositories & Logic:**

- **Repositories:** Use `get` for cloud fetching (e.g., `getTournament`) and `save` for cloud persistence.
- **Failure Returns:** Classes must end in `Failure` (e.g., `ServerFailure`, `AuthFailure`).
- **Supabase Integration:** Repositories abstract Supabase client calls behind Repository interfaces.

### Structural Patterns: Feature-First Clean Architecture

The `lib/` directory is organized into **Features** and **Core**.

```text
lib/
├── core/                  # Cross-cutting infrastructure
│   ├── di/                # Injectable configuration
│   ├── network/           # Supabase client wrapper
│   ├── persistence/       # Drift database & schema
│   ├── router/            # Centralized GoRouter & TypedGoRoutes
│   ├── theme/             # Material 3 tokens & ThemeCubit
│   └── error/             # Failures & Exception types
└── features/              # Vertical slices of functionality
    └── {feature}/
        ├── domain/        # Entities, Repository Interfaces, Use Cases
        ├── data/          # Repository Impl & DataSources
        └── presentation/  # BLoCs, Widgets, Pages
```

### State Management Patterns (BLoC/Cubit)

- **Feature-Specific BLoCs:** Each major domain (Auth, Tournament, Scoring) has its own BLoC to preserve architectural boundaries.
- **State Classes:** Use `freezed` with union cases: `initial`, `loading`, `loadSuccess`, and `loadFailure`.
- **Event Naming:** Use the Past-Tense Verb naming (e.g., `TournamentCreated`, `ScoreUpdated`).

### Data Mapping Pattern

- **Aggregate Roots:** Entities are pure Dart classes. Mapping happens strictly in the **Data Layer**.
- **Mappers:** Drift models and Supabase DTOs must contain:
  - `toDomain()` mapping to the Entity.
  - `static fromDomain()` mapping from the Entity to the data object.

### Pattern Enforcement Guidelines

**All AI Agents MUST:**

1. Check the `core/router/app_router.dart` for page route registration before adding new pages.
2. Ensure every Repository Interface has a `@LazySingleton(as: IFeatureRepository)` annotation in its implementation.
3. Use the `Either<Failure, T>` return type for all asynchronous repository methods to ensure consistent error handling.

---

## Architecture Validation Results

### Coherence Validation ✅

- **Decision Compatibility:** The combination of `Drift` for local SQL power and `Supabase` for cloud storage is highly coherent for a tournament setting. Versions for all packages are confirmed stable as of March 2026.
- **Pattern Consistency:** Centralized routing with `go_router_builder` aligns with the "Typed" architecture approach used in generated code for `Injectable` and `Freezed`.

### Requirements Coverage Validation ✅

- **Epic/Feature Coverage:** The primary "Smart Division Builder" requirement is fully covered by the `features/brackets/domain` logic, which remains independent of data source.
- **Non-Functional Requirements Coverage:** The "Friction-Free" goal is supported by the decision to move to **One-Way Sync**, which eliminates development bottlenecks while meeting 100% data safety via Drift.

### Implementation Readiness Validation ✅

- **Decision Completeness:** Tech choices are locked with specific commands for initialization.
- **Structure Completeness:** The project tree is explicit down to the utility level.
- **Future-Proofing (Refined by Party Mode):**
  - **Transaction Log Pattern:** Implemented in `Drift` to log all scoring changes. This ensures that move to bidirectional sync later is an additive change, not a rewrite.
  - **SyncManager Abstraction:** A `SyncManager` in `core/persistence` will decouple feature repositories from the sync logic.
  - **Viewport-Aware Canvas:** The bracket canvas will use a viewport-aware rendering pattern to support > 32 athletes without performance degradation.

### Gap Analysis Results

- **Minor Gap:** PDF templates will be stored as local assets initially.
- **Mitigated Risk:** Sync failure visibility will be handled via a centralized observer in the presentation layer.

### Architecture Completeness Checklist

**✅ Requirements Analysis**

- [x] Project context thoroughly analyzed
- [x] Scale and complexity assessed
- [x] Technical constraints identified
- [x] Cross-cutting concerns mapped

**✅ Architectural Decisions**

- [x] Critical decisions documented with versions
- [x] Technology stack fully specified
- [x] Integration patterns defined
- [x] Performance considerations addressed

**✅ Implementation Patterns**

- [x] Naming conventions established
- [x] Structure patterns defined
- [x] Communication patterns specified
- [x] Process patterns documented

**✅ Project Structure**

- [x] Complete directory structure defined
- [x] Component boundaries established
- [x] Integration points mapped
- [x] Requirements to structure mapping complete

### Architecture Readiness Assessment

**Overall Status:** READY FOR IMPLEMENTATION

**Confidence Level:** HIGH

**Key Strengths:**

- **Cloud Reliability:** Supabase provides PostgreSQL durability and automatic backups.
- **Strong Boundaries:** Clean Architecture maintains order in complex generation logic.
- **Future-Proofed Architecture:** Current cloud-first design enables easy addition of offline mode with local Drift later if needed.
- **Responsive UI:** HydratedBloc persists setup state for instant app recovery.

### Implementation Handoff

**AI Agent Guidelines:**

- Follow all architectural decisions exactly as documented.
- Use implementation patterns consistently across all components.
- Respect project structure and boundaries.
- Refer to this document for all architectural questions.

**Current Status:**
The project has a working MVP with Single & Double Elimination bracket generation, Supabase authentication, cloud data persistence, and PDF export. This document reflects the actual cloud-first architecture currently implemented.

---

## Project Structure & Boundaries

### Complete Project Directory Structure

```text
tkd_saas/
├── lib/
│   ├── main.dart                      # App entry & Provider setup
│   ├── core/                          # Infrastructure (Shared)
│   │   ├── di/                        # injection.dart & injection.config.dart
│   │   ├── error/                     # failures.dart & exceptions.dart
│   │   ├── network/                   # supabase_client.dart (Supabase wrapper)
│   │   ├── router/                    # app_router.dart & app_router.g.dart
│   │   ├── theme/                     # app_theme.dart & Material 3 tokens
│   │   └── utils/                     # formatters.dart & pdf_generator.dart
│   └── features/                      # Domain-specific slices (Vertical Features)
│       ├── auth/                      # Login, Signup, Profile
│       ├── participant/               # Participant & Athlete Management
│       ├── tournament/                # Tournament setup, settings
│       └── bracket/                   # SEEDING ENGINE, BRACKETS & SCORING
│           ├── domain/                # bracket_entity.dart & repository_interface.dart
│           ├── data/                  # bracket_repository_impl.dart & supabase client calls
│           └── presentation/          # bloc/, scoring_page.dart, bracket_canvas.dart
├── test/                              # Unified test structure mirroring lib/
│   ├── core/
│   └── features/
├── assets/                            # Images, Fonts, Brackets visualization
├── pubspec.yaml                       # (Latest stable versions)
└── analysis_options.yaml              # Custom lint rules
```

### Architectural Boundaries

**API Boundaries:**
All external communication (Supabase) is encapsulated within the `Data` layer of each feature. Individual features must not access `SupabaseClient` directly but should use a wrapper in `core/network` or a Repository implementation.

**Component Boundaries:**
We follow a **Feature-First** structure. Each directory in `features/` is a self-contained vertical slice. Communication between features (e.g., `auth` providing user context to `tournaments`) happens through shared Services or Domain-level abstractions in `core/`.

**Service Boundaries:**
The **Cloud Data Persistence** is a cross-cutting concern located in `core/network`. Feature repositories register their data sources and persist to Supabase through this wrapper, which manages the Supabase client lifecycle.

**Data Boundaries:**

- **Supabase (Remote):** Primary source of truth for tournament data and user records.
- **UI State (Local):** HydratedBloc maintains bracket setup state (format, participant list) for app restart recovery.
- **Mappers:** Mandatory separation between Supabase DTOs and Domain Entities (Dart) to avoid leaky abstractions.

### Requirements to Structure Mapping

**Epic: Seeding & Brackets (FR1-12)**

- **Domain:** `features/brackets/domain/` (Generation logic, Seeding rules).
- **Data:** `features/brackets/data/` (Local table persistence).
- **Presentation:** `features/brackets/presentation/` (Bracket canvas, Scoring UI).

**Epic: Authentication & Multi-Tenancy**

- **Core Security:** `core/network/supabase_client.dart` (JWT handling).
- **Feature Logic:** `features/auth/` (Login/Signup flows).

**Cross-Cutting Concerns:**

- **Theming:** `core/theme/` (Material 3 tokens).
- **Deep Linking:** `core/router/` (GoRouter configurations).
- **Offline Reliability:** `core/persistence/` (Drift database initialization).

### Integration Points

**Internal Communication:**

- **BLoCs** communicate through a single `AppRouter` for navigation.
- Use **Dependency Injection** (`Injectable`) to provide Repository implementations to BLoCs.

**External Integrations:**

- **Supabase Auth:** Primary authentication provider.
- **GoRouter Builder:** Type-safe route generation for the Web platform.

**Data Flow:**

1. **User Input** → Presentation (BLoC).
2. **BLoC** → Domain (Repository Interface).
3. **Repository Impl** → Data (Drift Local Persistence).
4. **Triggered Sync** → Data (Supabase Repository Push).

---
stepsCompleted: ['step-05-generate-output']
lastStep: 'step-05-generate-output'
lastSaved: '2026-03-09'
workflowType: 'testarch-test-design'
inputDocuments: ['_bmad-output/planning-artifacts/prd.md', '_bmad-output/planning-artifacts/architecture.md', '_bmad-output/planning-artifacts/ux-design-specification.md']
---

# Test Design for Architecture: TKD Tournament Manager

**Purpose:** Architectural concerns, testability gaps, and NFR requirements for review by Architecture/Dev teams. Serves as a contract between QA and Engineering on what must be addressed before test development begins.

**Date:** 2026-03-09
**Author:** Antigravity (Assistant)
**Status:** Architecture Review Pending
**Project:** TKD Tournament Manager
**PRD Reference:** [_bmad-output/planning-artifacts/prd.md](file:///Users/asak/Documents/dev/proj/personal/tkd_saas/_bmad-output/planning-artifacts/prd.md)
**ADR Reference:** [_bmad-output/planning-artifacts/architecture.md](file:///Users/asak/Documents/dev/proj/personal/tkd_saas/_bmad-output/planning-artifacts/architecture.md)

---

## Executive Summary

**Scope:** Full-stack SaaS for TKD tournaments focusing on local-first offline match management, automated seeding (dojang separation), and manual cloud synchronization.

**Business Context (from PRD):**
- **Revenue/Impact:** SaaS subscription for tournament organizers.
- **Problem:** Manual bracket generation is error-prone and time-consuming; internet connectivity at venues is unreliable.
- **GA Launch:** Phase 1 focused on core tournament engine and offline reliability.

**Architecture (from ADR):**
- **Key Decision 1:** Local-first with `Drift` (SQLite) as the source of truth for match state.
- **Key Decision 2:** Clean Architecture with BLoC for state management and `injectable` for DI.
- **Key Decision 3:** Manual one-way sync to Supabase for cloud persistence.

**Expected Scale (from ADR):**
- Support for >1000 athletes and multiple concurrent ring tablets in a single venue.

**Risk Summary:**
- **Total risks**: 5
- **High-priority (≥6)**: 2 (R01: Seeding Math, R02: Data Loss)
- **Test effort**: ~45–70 hours (~1.5–2 weeks for 1 QA)

---

## Quick Guide

### 🚨 BLOCKERS - Team Must Decide (Can't Proceed Without)

**Pre-Implementation Critical Path** - These MUST be completed before QA can write integration tests:

1. **ARCH-B01: Test Data Seeding Utility** - Architecture must provide a way to inject complex tournament states (e.g., active brackets, specific scoreboards) into the `Drift` database for automated testing (**Owner**: Backend Lead. *Penalty: Test automation for dependent features will NOT commence until this blocker is merged.*)
2. **ARCH-B02: Sync Failure Injection** - Need a hook or interceptor to simulate network failures during the manual sync trigger to validate data integrity (**Owner**: Backend Lead. *Penalty: Test automation for dependent features will NOT commence until this blocker is merged.*)

**What we need from team:** Complete these 2 items pre-implementation or test development is blocked.

---

### ⚠️ HIGH PRIORITY - Team Should Validate (We Provide Recommendation, You Approve)

1. **R01: Seeding Exhaustion** - Recommendation: Implement a fallback strategy when "Dojang Separation" is mathematically impossible in small brackets. *Strict Rule: If Product does not provide a mathematical fallback by Sprint 1, QA asserts that the system throws a hard error and halts bracket generation.*
2. **R05: Reracking Logic** - Recommendation: Automated "rerack" should trigger a specific Bloc event that is easily testable via unit tests. approved by Dev Lead.

**What we need from team:** Review recommendations and approve.

---

### 📋 INFO ONLY - Solutions Provided (Review, No Decisions Needed)

1. **Test strategy**: Heavy Unit/Integration focus for Seeding/Persistence (Clean Architecture boundaries provide strong isolation).
2. **Tooling**: Flutter Test (Unit/Component), Playwright (E2E Web/Tablet), Drift Mock (Persistence).
3. **Tiered CI/CD**: PR (Functional/Unit <10m), Nightly (Scale/E2E <30m).
4. **Coverage**: ~10–15 P0 tests covering Seeding, Persistence, and Core Workflow.
5. **Quality gates**: 100% P0 pass rate, 80% Domain coverage.

**What we need from team:** Just review and acknowledge.

---

## For Architects and Devs - Open Topics 👷

### Risk Assessment

**Total risks identified**: 5 (1 high-priority score ≥6, 4 medium/low)

#### High-Priority Risks (Score ≥6) - IMMEDIATE ATTENTION

| Risk ID | Category | Description                    | Probability | Impact | Score | Mitigation                                         | Owner  | Timeline |
| ------- | -------- | ------------------------------ | ----------- | ------ | ----- | -------------------------------------------------- | ------ | -------- |
| **R01** | **BUS**  | **Incorrect Teammate Seeding** | 2           | 3      | **6** | Property-based testing for dojang separation math. | Dev/QA | Sprint 1 |
| **R02** | **DATA** | **Data Loss on App Crash**     | 2           | 3      | **6** | Transaction-per-point strategy and hard DB commit. | Arch   | Sprint 1 |

#### Medium-Priority Risks (Score 3-5)

| Risk ID | Category | Description                   | Probability | Impact | Score | Mitigation                           | Owner  |
| ------- | -------- | ----------------------------- | ----------- | ------ | ----- | ------------------------------------ | ------ |
| R04     | PERF     | Canvas Lag in Large Divisions | 2           | 2      | 4     | Viewport rendering & perf profiling. | Dev    |
| R05     | BUS      | Bracket "Reracking" Failure   | 2           | 2      | 4     | Unit tests for no-show realignment.  | Dev/QA |
| R03     | SEC      | Tenant Data Leakage           | 1           | 3      | 3     | Supabase RLS automated validation.   | Dev    |

#### Risk Category Legend
- **TECH**: Technical/Architecture
- **SEC**: Security
- **PERF**: Performance
- **DATA**: Data Integrity
- **BUS**: Business Impact
- **OPS**: Operations

---

### Testability Concerns and Architectural Gaps

**🚨 ACTIONABLE CONCERNS - Architecture Team Must Address**

#### 1. Blockers to Fast Feedback (WHAT WE NEED FROM ARCHITECTURE)

| Concern               | Impact                                        | What Architecture Must Provide                        | Owner | Timeline           |
| --------------------- | --------------------------------------------- | ----------------------------------------------------- | ----- | ------------------ |
| **No DB Seeding API** | Cannot run E2E scenarios without manual setup | Utility to inject SQLite state via DI/Service locator | Arch  | Pre-Implementation |
| **Sync Interception** | Cannot verify recovery from partial sync      | Interface to manually fail the "Manual Sync" trigger  | Dev   | Sprint 2           |

#### 2. Architectural Improvements Needed (WHAT SHOULD BE CHANGED)

1. **Canvas Interaction Hooks**
   - **Current problem**: Flutter CustomPainter is a "black box" for traditional widget finders.
   - **Required change**: Expose a "Semantic Tree" or "Overlay Finders" for bracket match items. *Strict mandate: If Dev team cannot provide semantic finders, they must accept brittle Visual Regression Testing (VRT) as the only alternative.*
   - **Impact if not fixed**: Tests will rely on visual diffs.
   - **Owner**: Dev
   - **Timeline**: Sprint 2

---

### Testability Assessment Summary

**📊 CURRENT STATE - FYI**

#### What Works Well
- ✅ **Clean Architecture Boundaries**: Easy to mock data sources at the Repository level.
- ✅ **BLoC Pattern**: Predictable UI state transitions are easily testable via `bloc_test`.
- ✅ **DI (Injectable)**: Simple to swap real implementations with mocks for integration testing.

#### Accepted Trade-offs (No Action Required)
- **Manual Sync instead of Real-time**: Acceptable for MVP to reduce complexity. *Strict SLA: Manual sync operations exceeding 5,000ms will be considered a timeout failure and bugged as P1.*
- **SQLite Single-writer**: No concurrency issues expected for single-tablet scoring.

---

### Risk Mitigation Plans (High-Priority Risks ≥6)

#### R01: Incorrect Teammate Seeding (Score: 6) - CRITICAL

**Mitigation Strategy:**
1. Implement property-based tests (e.g., using `glados` or similar) to verify dojang separation across 1000+ random division permutations.
2. Create a "Seeding Visualizer" tool for manual review during development.
3. Establish a "Conflict Resolver" unit that explicitly handles cases where separation is mathematically impossible.

**Owner:** Dev/QA
**Timeline:** Sprint 1
**Status:** Planned
**Verification:** 100% pass rate on property-based tests for dojang separation constraints.

---

### Assumptions and Dependencies

#### Assumptions
1. Venue tablets will have local persistent storage available (SQLite/Drift).
2. The manual sync trigger will be used by staff only when a stable connection is verified.
3. Tournament rules (single/double elimination) follow standard Olympic styles.

#### Dependencies
1. **Supabase RLS Schema** - Required by Sprint 2 for security validation.
2. **PDF Generation Library** - Required by Sprint 3 for bracket print testing.

#### Risks to Plan
- **Risk**: Device-specific rendering bugs on different tablet models.
  - **Impact**: UI tests in CI might pass while actual hardware fails.
  - **Contingency**: Manual "Sanity Check" on physical tablet for P0 releases.

---

**End of Architecture Document**

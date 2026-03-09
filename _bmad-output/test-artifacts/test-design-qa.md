---
stepsCompleted: ['step-05-generate-output']
lastStep: 'step-05-generate-output'
lastSaved: '2026-03-09'
workflowType: 'testarch-test-design'
inputDocuments: ['_bmad-output/planning-artifacts/prd.md', '_bmad-output/planning-artifacts/architecture.md']
---

# Test Design for QA: TKD Tournament Manager

**Purpose:** Test execution recipe for QA team. Defines what to test, how to test it, and what QA needs from other teams.

**Date:** 2026-03-09
**Author:** Antigravity (Assistant)
**Status:** Draft
**Project:** TKD Tournament Manager

**Related:** See Architecture doc ([test-design-architecture.md](file:///Users/asak/Documents/dev/proj/personal/tkd_saas/_bmad-output/test-artifacts/test-design-architecture.md)) for testability concerns and architectural blockers.

---

## Executive Summary

**Scope:** Testing the core tournament engine (Single/Double Elimination), dojang-aware seeding, local persistence (Drift), and manual cloud synchronization.

**Risk Summary:**
- Total Risks: 5 (1 high-priority score 6, 4 medium/low)
- Critical Categories: Business (Seeding logic), Data (Persistence/Sync).

**Coverage Summary:**
- P0 tests: ~11 (Critical Seeding, Scoreboarding, Persistence, Sync Recovery)
- P1 tests: ~15 (Manual Sync, Bracket Reracking, UI Performance, Security)
- P2 tests: ~9 (Edge case brackets)
- P3 tests: ~5 (Benchmarks, Exploratory)
- **Total**: ~40 tests (~1.5–2 weeks with 1 QA)

---

## Not in Scope

**Components or systems explicitly excluded from this test plan:**

| Item                         | Reasoning                                       | Mitigation                                                      |
| ---------------------------- | ----------------------------------------------- | --------------------------------------------------------------- |
| **Supabase Hosting Infra**   | Out of scope for app team; platform dependency. | Rely on Supabase status page and SDK error handling.            |
| **Physical Tablet Hardware** | CI/CD runs in emulators/browsers.               | Manual sanity check on physical hardware before major releases. |
| **Payment Gateway**          | Phase 2 requirement.                            | Omitted from current design.                                    |

---

## Dependencies & Test Blockers

**CRITICAL:** QA cannot proceed without these items from other teams.

### Backend/Architecture Dependencies (Pre-Implementation)

**Source:** See Architecture doc "Quick Guide" for detailed mitigation plans.

1. **DB Seeding Utility** - Arch - Sprint 1
   - Need a way to programmatically inject `Drift` database state.
   - **Why it blocks testing:** Prevents automated testing of "In-progress" match states without manual entry.

2. **Sync Failure Simulator** - Dev - Sprint 2
   - Need a hook to toggle network mock responses for the manual sync button.
   - **Why it blocks testing:** Cannot verify data recovery logic during sync interruptions.

### QA Infrastructure Setup (Pre-Implementation)

1. **Tournament Data Factories** - QA
   - Athlete/Dojang factory with randomization to stress-test seeding engine.
   - Match/Score factory for bracket advancement testing.

2. **Test Environments** - QA
   - Local: Flutter desktop/web dev server.
   - CI/CD: GitHub Actions with Flutter test environment and Playwright shards.

**Example factory pattern (Mocking Drift):**

```dart
// Placeholder for Flutter/Drift mock seeding
Future<void> seedTournament(DriftDb db, List<Athlete> athletes) async {
  await db.batch((batch) {
    batch.insertAll(db.athletes, athletes);
  });
}
```

---

## Risk Assessment

**Note:** Full risk details in Architecture doc. This section summarizes risks relevant to QA test planning.

### High-Priority Risks (Score ≥6)

| Risk ID | Category | Description                | Score | QA Test Coverage                                                                |
| ------- | -------- | -------------------------- | ----- | ------------------------------------------------------------------------------- |
| **R01** | BUS      | Incorrect Teammate Seeding | **6** | Property-based unit tests for seeding constraints; visual bracket verification. |
| **R02** | DATA     | Data Loss on App Crash     | **6** | Process kill/restart tests during active scoring; Drift transaction validation. |

### Medium/Low-Priority Risks

| Risk ID | Category | Description                   | Score | QA Test Coverage                                                           |
| ------- | -------- | ----------------------------- | ----- | -------------------------------------------------------------------------- |
| R03     | SEC      | Tenant Data Leakage           | 3     | API/Integration tests with multiple `tenant_id` sessions.                  |
| R04     | PERF     | Canvas Lag in Large Divisions | 4     | Automated scroll performance benchmarks on large (>32) brackets.           |
| R05     | BUS      | Bracket "Reracking" Failure   | 4     | Mutation tests: delete athlete mid-tournament and verify path realignment. |

---

## Entry Criteria

**QA testing cannot begin until ALL of the following are met:**
- [x] PRD and Architecture documents finalized.
- [ ] Test data factories for Athletes/Dojangs implemented.
- [ ] DB Seeding utility provided by Architecture team.
- [ ] Local dev environment for Flutter Web/Tablet accessible.

## Exit Criteria

**Testing phase is complete when ALL of the following are met:**
- [ ] **100% pass rate required for P0 AND P1**. Any P1 failure aborts the release pipeline.
- [ ] No open "Critical" or "Major" bugs.
- [ ] Manual Sync recovery confirmed via failure injection.
- [ ] Scoring latency < 100ms on baseline minimum tablet spec (e.g., iPad Gen 9). Validated via Playwright trace analysis.

---

## Test Coverage Plan

**IMPORTANT:** P0/P1/P2/P3 = **priority and risk level**, NOT execution timing. See "Execution Strategy" for when tests run.

### P0 (Critical)

**Criteria:** Blocks core functionality + High risk (≥6) + No workaround + Affects majority of users.

| Test ID    | Requirement                                       | Test Level  | Risk Link | Notes                                              |
| ---------- | ------------------------------------------------- | ----------- | --------- | -------------------------------------------------- |
| **P0-001** | Dojang Separation logic (permutation math)        | Unit        | R01       | Verify teammates don't face each other in Round 1. |
| **P0-002** | Local Persistence (Transaction-per-point)         | Integration | R02       | Ensure scoring is saved to disk immediately.       |
| **P0-003** | Core Scoreboard Lifecycle (Start -> Score -> End) | E2E         | -         | Basic "Golden Path" for match staff.               |
| **P0-004** | Manual Cloud Sync (Recovery on Failure)           | Integration | -         | Verify no data corruption on network drop.         |

**Total P0:** ~11 tests

---

### P1 (High)

**Criteria:** Important features + Medium risk (3-4) + Common workflows.

| Test ID    | Requirement                         | Test Level  | Risk Link | Notes                                               |
| ---------- | ----------------------------------- | ----------- | --------- | --------------------------------------------------- |
| **P1-001** | Manual Cloud Sync (Success Pathway) | Integration | -         | Verify data reaches Supabase.                       |
| **P1-002** | Bracket "Reracking" on withdrawal   | Unit        | R05       | Verify bracket shifts block dead matches.           |
| **P1-003** | Scoring Feedback Latency            | Component   | R04       | Automated check for haptic/visual response < 100ms. |

**Total P1:** ~15 tests

---

### P2 (Medium)

**Criteria:** Secondary features + Low risk + Edge cases.

| Test ID    | Requirement                              | Test Level | Risk Link | Notes                  |
| ---------- | ---------------------------------------- | ---------- | --------- | ---------------------- |
| **P2-001** | Double Elimination "Losers Bracket" flow | Unit       | -         | Complex pathing logic. |

**Total P2:** ~9 tests

---

## Execution Strategy

**Philosophy:** Run everything in PRs unless expensive. Playwright/Flutter tests are fast.

### Every PR (CI): Flutter & Playwright (~10 min)
- **Unit Tests**: Seeding math, BLoC state transitions, Data models.
- **Integration Tests**: Drift persistence, SQLite transactions.
- **Smoke E2E**: Single match lifecycle (Web/Tablet).

### Nightly: Scale & Sync (~30 min)
- **Large Bracket Tests**: Brackets with 64+ athletes.
- **Sync Endurance**: Repeated sync/fail cycles.
- **PDF Generation**: Screenshot/Pixel verification of generated brackets.

---

## QA Effort Estimate

**QA test development effort only:**
*(Strict Caveat: Estimates assume API and Testability dependencies are delivered on time. There is a day-for-day slip in QA delivery for any pre-implementation blocker delay.)*

| Priority  | Count   | Effort Range     | Notes                                |
| --------- | ------- | ---------------- | ------------------------------------ |
| P0        | ~11     | ~15–25 hours     | High focus on seeding accuracy/math. |
| P1        | ~15     | ~20–30 hours     | Sync integration and UI feedback.    |
| P2/P3     | ~14     | ~10–15 hours     | Edge cases and benchmarks.           |
| **Total** | **~40** | **~45–70 hours** | **~1.5–2 weeks of effort.**          |

---

## Appendix A: Code Examples & Tagging

**Playwright Tags for selective execution:**

```typescript
// P0 critical E2E test
test('@P0 @Smoke match staff can award points', async ({ page }) => {
  // Test code here
});
```

---

## Appendix B: Knowledge Base References
- `risk-governance.md` - Risk methodology.
- `test-levels-framework.md` - Level selection.
- `test-quality.md` - DoD for tests.

---

**Generated by:** BMad TEA Agent
**Workflow:** `_bmad/tea/testarch/test-design`

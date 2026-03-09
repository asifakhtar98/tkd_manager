---
title: 'TEA Test Design → BMAD Handoff Document'
version: '1.0'
workflowType: 'testarch-test-design-handoff'
inputDocuments: ['_bmad-output/test-artifacts/test-design-architecture.md', '_bmad-output/test-artifacts/test-design-qa.md']
sourceWorkflow: 'testarch-test-design'
generatedBy: 'TEA Master Test Architect (Antigravity)'
generatedAt: '2026-03-09T16:11:00Z'
projectName: 'tkd_saas'
---

# TEA → BMAD Integration Handoff

## Purpose

This document bridges TEA's test design outputs with BMAD's epic/story decomposition workflow. It provides structured integration guidance for the **TKD Tournament Manager** (System-Level).

## TEA Artifacts Inventory

| Artifact           | Path                                                      | BMAD Integration Point              |
| ------------------ | --------------------------------------------------------- | ----------------------------------- |
| Test Design (Arch) | `_bmad-output/test-artifacts/test-design-architecture.md` | Epic quality requirements, Blockers |
| Test Design (QA)   | `_bmad-output/test-artifacts/test-design-qa.md`           | Story ACs, Coverage Strategy        |
| Progress Report    | `_bmad-output/test-artifacts/test-design-progress.md`     | Workflow status                     |

## Epic-Level Integration Guidance

### Risk References
- **R01: Incorrect Teammate Seeding (Score 6)**: Must be a primary quality gate for the "Tournament Engine" Epic. Seeding math must be verified before any UI work proceeds beyond prototypes.
- **R02: Data Loss on App Crash (Score 3)**: Must be a quality gate for the "Match Scoring" Epic. Persistence must be synchronous per point.

### Quality Gates
1. **Engine Verification Gate**: 100% pass on property-based tests for seeding constraints.
2. **Offline Resilience Gate**: No data loss during hard process kill during match orchestration.
3. **Sync Integrity Gate**: Verified recovery from partial sync using manual sync trigger.

## Story-Level Integration Guidance

### P0/P1 Test Scenarios → Story Acceptance Criteria

#### Story: Implement Bracket Seeding Engine
- **AC**: Teammates from the same Dojang MUST NOT face each other in the first round (Best Effort if divisions are small).
- **AC**: Seeding output must be deterministic for the same input set.

#### Story: Scoring Persistence
- **AC**: Every point award/removal must be committed to the `Drift` database before the UI updates or haptic feedback is triggered.
- **AC**: Match state must survive app force-close.

### Data-TestId Requirements
- Add `data-testid="athlete-card-{id}"` to bracket nodes.
- Add `data-testid="scoring-btn-{type}"` (red/blue/points) for staff interaction tests.

## Risk-to-Story Mapping

| Risk ID | Category | P×I | Recommended Story/Epic                         | Test Level  |
| ------- | -------- | --- | ---------------------------------------------- | ----------- |
| R01     | BUS      | 6   | Epic: Tournament Engine / Story: Seeding Logic | Unit        |
| R02     | DATA     | 3   | Epic: Match Scoring / Story: Persistence       | Integration |
| R04     | PERF     | 4   | Epic: Bracket UI / Story: Infinite Canvas      | Component   |
| R05     | BUS      | 4   | Epic: Tournament Change / Story: Reracking     | Unit        |

## Recommended BMAD → TEA Workflow Sequence

1. **TEA Test Design** (COMPLETE)
2. **BMAD Create Epics & Stories** (NEXT) → Consumes this document.
3. **TEA ATDD** → Generates acceptance tests for P0 scenarios.
4. **BMAD Implementation** → Devs implement with test-first guidance.

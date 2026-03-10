---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
inputDocuments: ["_bmad-output/planning-artifacts/prd.md", "_bmad-output/planning-artifacts/architecture.md", "temp/ux-design-specification.md"]
---

# UX Design Specification: TKD Brackets
**Date:** 2026-03-09

## 1. Executive Summary & Core Experience
**TKD Brackets** transforms tournament bracket creation into a professional, 5-minute process with specialized Taekwondo domain intelligence (Dojang separation, federation rules).

**The "Soul" of the App:** Smart Roster-to-Bracket Generation. Paste messy data, get perfectly ordered brackets instantly.

### Target Personas
1. **Master Kim (Organizer):** Needs density, speed, and relief from spreadsheet chaos. (Desktop)
2. **Volunteer Scorer:** Needs a "can't-fail," zero-training interface. (Tablet)
3. **David (Parent Spectator):** Needs instant, read-only live scores on weak Wi-Fi. (Mobile)

## 2. Key User Journeys & Mechanics
* **Smart Paste:** System auto-detects Dojang/Belt/Weight without strict CSV templates.
* **8:45 AM Crisis Recovery:** Undo/delete no-shows instantly re-racks brackets without breaking seeding.
* **Ring-Side Scoring:** Huge hit zones, 100ms haptic point logic, persistent local caching to prevent lost data.

## 3. Platform & Responsive Strategy
* **Desktop (1280px+):** Command Center. Dense, Dual-Pane (Sidebar + Bracket Canvas), keyboard shortcuts (Ctrl+K).
* **Tablet (768px-1024px):** Focus Mode. Single-ring view, giant scoring buttons (min 64x64px), persistent local-save indicators.
* **Mobile (320px-767px):** Read-Only. Bottom-nav, large live-score cards, strict optimization for poor internet.

## 4. Design System & Visuals
**Foundation:** Material Design 3 LIGHT (Material You).



### Typography & Spacing
* **Fonts:** Inter (data legibility) & Outfit (headers, ring numbers).
* **Base Unit:** 8px grid.

## 5. UX Non-Functional Requirements (NFRs) & Patterns
* **Latency:** < 100ms for scoring feedback.
* **Syncing:** Local-first save (`Drift`) before UI increment to prevent data loss.
* **Forgiveness:** Global `Undo` instead of destructive `Confirm` modals. 
* **Accessibility:** WCAG AA. Minimum 4.5:1 text contrast (8:1 for scoring UI).
* **Venue Display Mode:** Aggressive dark mode (White on Black) for gym projectors.

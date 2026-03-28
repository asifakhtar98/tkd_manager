---
title: 'Bracket Module Overhaul — Reference-Accurate TKD Tie Sheet'
slug: 'bracket-reference-accurate-tie-sheet'
created: '2026-03-09T22:20:47+05:30'
status: 'ready-for-dev'
stepsCompleted: [1, 2, 3, 4]
tech_stack: ['Flutter 3.x', 'Dart 3.10+', 'pdf ^3.11.3', 'printing ^5.14.2', 'uuid ^4.5.3']
files_to_modify:
  - 'lib/features/participant/domain/entities/participant_entity.dart'
  - 'lib/features/bracket/data/services/bracket_layout_engine_implementation.dart'
  - 'lib/features/bracket/domain/entities/bracket_layout.dart'
  - 'lib/main.dart'
  - 'test/bracket_flow_test.dart'
files_to_delete:
  - 'lib/features/bracket/data/services/round_robin_bracket_generator_service_implementation.dart'
  - 'lib/features/bracket/domain/services/round_robin_bracket_generator_service.dart'
  - 'lib/features/bracket/presentation/widgets/match_card_widget.dart'
  - 'lib/features/bracket/presentation/widgets/bracket_viewer_widget.dart'
  - 'lib/features/bracket/presentation/widgets/bracket_connection_lines_widget.dart'
  - 'lib/features/bracket/presentation/widgets/round_label_widget.dart'
files_to_create:
  - 'lib/features/bracket/domain/entities/tournament_info.dart'
  - 'lib/features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart'
code_patterns:
  - 'Single-file monolith: all screens in main.dart (~1093 lines)'
  - 'Domain entities: plain Dart classes with copyWith (no freezed generated yet)'
  - 'Canvas rendering: Stack + Positioned + CustomPainter for connector lines'
  - 'PDF: pdf + printing packages (current impl is list-based, NOT graphical)'
  - 'Generators: separate implementations for Single/Double elimination'
  - 'BYE handling: auto-completed matches with MatchResultType.bye'
  - 'Dojang separation: interleave-then-spread algorithm in _seedParticipants()'
test_patterns:
  - 'Integration tests only (flutter_test + integration_test SDK)'
  - 'Single test file: test/bracket_flow_test.dart (496 lines)'
  - 'Tests cover: Single/Double generation, scoring, dojang separation, participant management'
---

# Tech-Spec: Bracket Module Overhaul — Reference-Accurate TKD Tie Sheet

**Created:** 2026-03-09T22:20:47+05:30

---

## Overview

### Problem Statement

The current bracket module's UI renders matches as card-based widgets (`MatchCardWidget` inside a `Stack` of `Positioned` children), which does not match the official TKD federation tournament tie sheet format. The PDF export (`_buildBracketPdf()` at line 708 of `main.dart`) generates a list-style tabular view — not the graphical bracket tree. Round Robin code adds unnecessary complexity and confusion. The entire bracket rendering pipeline must be replaced to produce a 1:1 replica of the official federation tie sheet.

### Solution

Replace the entire presentation layer (widgets + PDF) with a single `CustomPainter`-based tie sheet canvas that exactly replicates the reference image. Add missing data fields (`registrationId`, `TournamentInfo`). Make PDF a pixel-perfect capture of the rendered canvas via `RepaintBoundary.toImage()`. Remove Round Robin code entirely.

### Scope

**In Scope:**
1. Tournament Metadata — input fields: tournament name, date range, venue, organizer, category/division label
2. Registration ID — add `registrationId` field to `ParticipantEntity` and entry form
3. Complete UI Redesign of Bracket Canvas to match official TKD tie sheet reference image
4. Double Elimination — two-sided layout (winners left, losers right, finals center)
5. Single Elimination — same design but only one side renders (left to right)
6. Remove Round Robin — delete all Round Robin code (generator, service, UI, PDF, layout)
7. PDF Export — capture rendered canvas as-is via `RepaintBoundary.toImage()`
8. Remove confusing existing UI elements — replace card-based `MatchCardWidget` entirely
9. All bracket logic must be factually correct — seeding, advancement, bye handling

**Out of Scope:**
- Scoring UI dialog functionality (keep existing `_scoreMatch()` dialog as-is)
- Cloud sync, authentication, multi-tenancy
- Organization logo upload
- Any SaaS/backend features
- Interactive drag-and-drop bracket editing

---

## Reference Image Analysis — EXACT Visual Specification

> **CRITICAL: Study the reference image before implementing. Every element below must be replicated.**

The reference image is a **2ND FEDERATION CUP – 2026** official tie sheet. Here is the exact breakdown of every visual element the dev agent MUST reproduce:

### Header Section (top of sheet)
- **Line 1**: Tournament name in large bold text, centered: `"2ND FEDERATION CUP – 2026 (Kyorugi & Poomsae)"`
- **Line 2**: Date + venue in smaller text: `"18 Jan. to 22 Jan, 2022, SMS Indoor Stadium, Jaipur, Rajasthan"`
- **Line 3**: Organizer in bold: `"Organised by : INDIA TAEKWONDO"`
- **Line 4**: A horizontal divider line spanning the full width. Below it on the far left: `"No."`. In the center: the category word (e.g., `"JUNIOR"`). On the right side: the gender/division word (e.g., `"BOYS"`).

### Left-Side Participant Entry List
- A vertical numbered list of ALL participants on the far left edge.
- Each row contains exactly 3 columns separated by vertical lines:
  1. **Serial number** (1, 2, 3, ... 14) — left-aligned
  2. **PARTICIPANT FULL NAME** in UPPERCASE bold text (e.g., `"SAIANSH MATHUR"`) — left-aligned
  3. **Registration ID** (e.g., `"DL012025-22514"`) — right-aligned
- Rows are separated by horizontal lines.
- Each row has a horizontal line extending to the RIGHT from the row's right edge — this is the participant's "line" that feeds into the bracket.

### Bracket Connector Lines (the core bracket drawing)
- **First round match junctions**: Every PAIR of adjacent participant lines (1+2, 3+4, 5+6, etc.) connects at a junction point.
  - The two horizontal lines extend right to the same X coordinate.
  - A **vertical line** joins the endpoints of the two horizontal lines.
  - A **horizontal line** extends RIGHT from the midpoint of that vertical line toward the next round.
- **At each junction:**
  - **"B"** label (in blue/dark text) is placed at the TOP participant line's connection point (the upper input line).
  - **"R"** label (in red text) is placed at the BOTTOM participant line's connection point (the lower input line).
  - **Match number** (1, 2, 3, 4, 5, 6...) is placed at the midpoint of the vertical connector, slightly to the right.
- **Subsequent rounds**: Same pattern — pairs of match output lines from previous round connect at new junctions, with B/R labels and match numbers.
- This cascading continues until the finals.

### Right-Side Layout (Double Elimination — visible in reference)
- The RIGHT side of the sheet has a **mirrored** bracket structure.
- Participant names appear on the far RIGHT edge (e.g., "Tej Pratap Shar", "APOORVA PAN", "SACHIN RAGHA"...) with match numbers (16, 7, 8, 9...).
- Connector lines flow from RIGHT to LEFT, mirroring the left side.
- The two sides converge at the **center** where the finals/grand finals are.

### Bottom Section
- **Round numbers** are written at the bottom center of the bracket area (e.g., `24`, `26`, `27`).
- **Medal Table**: A bordered table at the very bottom with 3 rows:
  - Row 1: Two empty cells + "Gold" label
  - Row 2: Two empty cells + "Silver" label
  - Row 3: Two empty cells + "Bronze" label
  - The left cells are for writing names (either auto-populated from results or blank for manual fill).

### Visual Style Constants
- **Background**: White/light (NOT dark theme — the tie sheet is a print document)
- **Lines**: Black, 1-2px weight
- **Text**: Black, except "R" (red) and "B" (blue/dark)
- **Font**: Sans-serif, clean, readable at print size
- **No shadows, no rounded corners, no material cards** — this is a flat, official-document style

---

## Context for Development — EXISTING CODE REFERENCE

### Architecture
- **Single-file monolith**: All screens (`ParticipantEntryScreen` lines 50-324, `BracketViewerScreen` lines 326-1092) live in `lib/main.dart` (~1093 lines)
- **Domain entities**: Plain Dart classes with manual `copyWith()` — NOT using freezed code-gen
- **Services**: Follow `Interface → Implementation` pattern with `@LazySingleton` annotations (but main.dart instantiates them directly: `SingleEliminationBracketGeneratorServiceImplementation(const Uuid())`)

### Current Rendering Pipeline (WILL BE REPLACED)
1. `_generateBracket()` (L413) → calls generator service → gets `BracketEntity` + `List<MatchEntity>`
2. `_layoutEngine.calculateLayout()` (L454) → produces `BracketLayout` → `BracketRound[]` → `MatchSlot[]`
3. `BracketViewerWidget` renders `MatchSlot`s as `Positioned` children in a `Stack`
4. `BracketConnectionLinesWidget` uses `CustomPainter` to draw connector lines
5. `MatchCardWidget` renders each match as a `Card` with header + two rows

### Current PDF Pipeline (WILL BE REPLACED)
- `_exportPdf()` at L688 — entry point, routes to RR or bracket PDF builder
- `_buildBracketPdf()` at L708 — builds list-style layout with `pw.Row/pw.Container`
- `_buildRoundRobinPdf()` at L867 — builds round-robin table layout
- Uses `Printing.layoutPdf(onLayout: ...)` from `printing` package

### Scoring Logic (KEEP UNCHANGED)
These methods in `_BracketViewerScreenState` must remain functionally identical:
- `_scoreMatch()` (L477) — shows the score dialog with Red/Blue WINS buttons + result type dropdown
- `_declareWinner()` (L570) — sets winnerId, propagates winner to next match via `winnerAdvancesToMatchId`, propagates loser via `loserAdvancesToMatchId`, recalculates layout
- `_resetMatch()` (L629) — resets winnerId/status, calls `_cascadeRemove()` for winner and loser paths
- `_cascadeRemove()` (L660) — walks the advancement chain removing the player from subsequent matches
- `_pName()` (L678) — converts participant ID → "FirstName LastName"
- `_getParticipant()` (L468) — finds `ParticipantEntity` by ID

### Seeding Logic (KEEP UNCHANGED)
- `_seedParticipants()` (L366) — dojang separation algorithm: group by dojang, flatten interleaved, spread to top/bottom halves

### Key Data Shapes (from entity files)

**`ParticipantEntity`** (`lib/features/participant/domain/entities/participant_entity.dart`, 44 lines):
```dart
class ParticipantEntity {
  final String id;
  final String divisionId;
  final String firstName;
  final String lastName;
  final String? schoolOrDojangName;
  final String? beltRank;
  final int seedNumber;
  final bool isBye;
  // MISSING: registrationId — needs to be added
}
```

**`MatchEntity`** (`lib/features/bracket/domain/entities/match_entity.dart`, 133 lines):
```dart
class MatchEntity {
  final String id;
  final String bracketId;
  final int roundNumber;
  final int matchNumberInRound;
  final String? participantRedId;
  final String? participantBlueId;
  final String? winnerId;
  final String? winnerAdvancesToMatchId;
  final String? loserAdvancesToMatchId;
  final MatchStatus status;
  final MatchResultType? resultType;
  // ... timestamps
}
```

**`BracketEntity`** (`lib/features/bracket/domain/entities/bracket_entity.dart`, 82 lines):
```dart
class BracketEntity {
  final String id;
  final String divisionId;
  final BracketType bracketType; // winners, losers, pool
  final int totalRounds;
  final Map<String, dynamic>? bracketDataJson;
  // ... timestamps, poolIdentifier
}
```

**`BracketLayout`** (`lib/features/bracket/domain/entities/bracket_layout.dart`, 156 lines):
```dart
enum BracketFormat { singleElimination, doubleElimination, roundRobin } // roundRobin to be REMOVED
class BracketLayout { BracketFormat format; List<BracketRound>; Size canvasSize; }
class BracketRound { int roundNumber; String roundLabel; List<MatchSlot>; double xPosition; }
class MatchSlot { String matchId; Offset position; Size size; MatchSlot? advancesToSlot; }
class BracketLayoutOptions { double matchCardWidth=200; matchCardHeight=100; horizontalSpacing=80; verticalSpacing=20; }
```

### Generators (NO CHANGES — keep as-is)
- `SingleEliminationBracketGeneratorServiceImplementation` (190 lines) — generates bracket with correct match linking, bye handling, optional 3rd place match
- `DoubleEliminationBracketGeneratorServiceImplementation` (298 lines) — generates winners + losers brackets with cross-bracket routing, grand finals, optional reset match

### Round Robin Code (ALL TO DELETE)
- `RoundRobinBracketGeneratorServiceImplementation` at `lib/features/bracket/data/services/round_robin_bracket_generator_service_implementation.dart` (131 lines)
- `RoundRobinBracketGeneratorService` interface at `lib/features/bracket/domain/services/round_robin_bracket_generator_service.dart`
- In `main.dart`: `_roundRobinGenerator` instance (L352), `widget.format.contains('Round')` branch (L432-439), `_buildRoundRobinPdf()` (L867-929), `_buildRoundRobin()` (L1010-1091), format ternary in `build()` (L981)
- In `bracket_layout_engine_implementation.dart`: `BracketFormat.roundRobin` case (L29), `BracketType.pool` check (L44), `_calculateRoundRobinLayout()` (L298-304)
- In `bracket_layout.dart`: `roundRobin` value in `BracketFormat` enum

### Existing Layout Engine (KEEP but STOP USING for rendering)
The `BracketLayoutEngineImplementation` (316 lines) stays in codebase but the tie sheet canvas widget does NOT call it. The new `TieSheetPainter` calculates its own layout internally because the tie sheet format (participant rows on left edge, connector junctions, R/B labels) is fundamentally different from the card-grid `MatchSlot` approach.

The `_declareWinner()` and `_resetMatch()` methods currently call `_layoutEngine.calculateLayout()` at L621-626 and L652-656. Since the new `TieSheetCanvasWidget` manages its own layout from the match list directly, these calls can be removed — `setState()` alone will trigger a repaint of the `CustomPainter`.

---

## Implementation Plan

### Task 1: Add `registrationId` to `ParticipantEntity`

**File:** `lib/features/participant/domain/entities/participant_entity.dart`

**Exact changes:**
1. Add field: `final String? registrationId;` — after `beltRank`, before `seedNumber`
2. Add to constructor: `this.registrationId,` — as an optional named parameter
3. Add to `copyWith`: `String? registrationId,` parameter + `registrationId: registrationId ?? this.registrationId,` in the return

**Why nullable:** BYE entries and existing participants won't have registration IDs. The entry form makes it optional.

---

### Task 2: Create `TournamentInfo` entity

**File:** `lib/features/bracket/domain/entities/tournament_info.dart` (**NEW FILE**)

**Create this exact class:**
```dart
class TournamentInfo {
  final String tournamentName;
  final String dateRange;
  final String venue;
  final String organizer;
  final String categoryLabel; // e.g., "JUNIOR"
  final String divisionLabel; // e.g., "BOYS"

  const TournamentInfo({
    this.tournamentName = '',
    this.dateRange = '',
    this.venue = '',
    this.organizer = '',
    this.categoryLabel = '',
    this.divisionLabel = '',
  });

  TournamentInfo copyWith({
    String? tournamentName,
    String? dateRange,
    String? venue,
    String? organizer,
    String? categoryLabel,
    String? divisionLabel,
  }) {
    return TournamentInfo(
      tournamentName: tournamentName ?? this.tournamentName,
      dateRange: dateRange ?? this.dateRange,
      venue: venue ?? this.venue,
      organizer: organizer ?? this.organizer,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      divisionLabel: divisionLabel ?? this.divisionLabel,
    );
  }
}
```

**Note:** The reference image shows `categoryLabel` ("JUNIOR") and `divisionLabel` ("BOYS") as separate words on the header line 4. These are TWO separate fields, not one combined string.

---

### Task 3: Remove Round Robin entirely

**Files and exact changes:**

1. **DELETE** `lib/features/bracket/data/services/round_robin_bracket_generator_service_implementation.dart`
2. **DELETE** `lib/features/bracket/domain/services/round_robin_bracket_generator_service.dart`

3. **EDIT** `lib/features/bracket/domain/entities/bracket_layout.dart`:
   - Remove `roundRobin` from `BracketFormat` enum. Result: `enum BracketFormat { singleElimination, doubleElimination }`

4. **EDIT** `lib/features/bracket/data/services/bracket_layout_engine_implementation.dart`:
   - Remove the `BracketFormat.roundRobin => _calculateRoundRobinLayout(),` case from the switch at L29
   - Remove the `if (bracket.bracketType == BracketType.pool) { return BracketFormat.roundRobin; }` block at L44-46
   - Delete the entire `_calculateRoundRobinLayout()` method at L298-304

5. **EDIT** `lib/main.dart` — remove ALL of these:
   - **Import**: `import 'features/bracket/data/services/round_robin_bracket_generator_service_implementation.dart';` (L14)
   - **Instance**: `final _roundRobinGenerator = RoundRobinBracketGeneratorServiceImplementation(const Uuid());` (L352)
   - **Generation branch**: The `else if (widget.format.contains('Round'))` block at L432-439
   - **PDF method**: The entire `_buildRoundRobinPdf()` method at L867-929
   - **Build method branch**: The `widget.format.contains('Round') ? _buildRoundRobin() :` ternary at L981
   - **Build method**: The entire `_buildRoundRobin()` method at L1010-1091
   - **PDF routing**: The `isRR` variable and `if (isRR)` branch at L693-696
   - **Format dropdown**: Remove `'Round Robin'` from the items list at L169

---

### Task 4: Delete old presentation widgets

**Files to DELETE:**
1. `lib/features/bracket/presentation/widgets/match_card_widget.dart` (165 lines)
2. `lib/features/bracket/presentation/widgets/bracket_viewer_widget.dart` (96 lines)
3. `lib/features/bracket/presentation/widgets/bracket_connection_lines_widget.dart` (84 lines)
4. `lib/features/bracket/presentation/widgets/round_label_widget.dart` (22 lines)

**EDIT** `lib/main.dart`:
- Remove import: `import 'features/bracket/presentation/widgets/bracket_viewer_widget.dart';` (L16)
- **DO NOT** remove the `import 'features/bracket/domain/entities/bracket_layout.dart';` — it's still used for `BracketLayoutOptions`
- **DO NOT** remove the `import 'features/bracket/data/services/bracket_layout_engine_implementation.dart';` — it's still imported (though usage is removed in Task 8)

---

### Task 5: Create `TieSheetCanvasWidget` (CORE — largest task)

**File:** `lib/features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart` (**NEW FILE**)

**Widget structure:**
```
TieSheetCanvasWidget (StatefulWidget)
  └─ RepaintBoundary (key: printKey)
      └─ GestureDetector (onTapDown: _handleTap)
          └─ CustomPaint (painter: TieSheetPainter, size: _calculatedCanvasSize)
```

**Constructor parameters:**
```dart
class TieSheetCanvasWidget extends StatefulWidget {
  final TournamentInfo tournamentInfo;
  final List<MatchEntity> matches;
  final List<ParticipantEntity> participants;
  final String bracketType; // 'Single Elimination' or 'Double Elimination'
  final void Function(String matchId) onMatchTap;
  final GlobalKey printKey;
  final bool includeThirdPlaceMatch;
}
```

**`TieSheetPainter` (CustomPainter) — EXACT drawing implementation:**

The painter must accept: `tournamentInfo`, `matches`, `participants`, `bracketType`, and expose `matchHitAreas` (a `List<MapEntry<String, Rect>>` of matchId → bounding rect for hit-testing).

**Layout constants (configurable):**
```dart
static const double rowHeight = 40.0;
static const double columnWidth = 120.0;
static const double headerHeight = 120.0;
static const double leftListWidth = 400.0; // No. + Name + RegID columns
static const double rightListWidth = 200.0; // Right-side names (double elim)
static const double medalTableHeight = 120.0;
static const double leftMargin = 20.0;
static const double topMargin = 20.0;
static const double matchNumberFontSize = 12.0;
static const double participantFontSize = 11.0;
static const double headerFontSize = 16.0;
```

**Canvas size calculation:**
```dart
// Single Elimination:
width = leftMargin + leftListWidth + (totalRounds * columnWidth) + rightMargin
height = topMargin + headerHeight + (firstRoundMatchCount * 2 * rowHeight) + medalTableHeight + bottomMargin

// Double Elimination:
width = leftMargin + leftListWidth + (winnersRounds * columnWidth) + centerGap + (losersRounds * columnWidth) + rightListWidth + rightMargin
height = max(winnersHeight, losersHeight) + headerHeight + medalTableHeight + margins
```

**Paint order (must follow this sequence):**
1. Fill canvas with white background: `canvas.drawRect(canvasRect, whitePaint)`
2. Draw tournament header text (4 lines, centered)
3. Draw horizontal divider line below header
4. Draw participant table on left (vertical lines separating No./Name/RegID columns, horizontal lines between rows, text in each cell)
5. Draw bracket connector lines from left to right:
   - For each pair of adjacent participants: extend their row lines to the right, connect with vertical line, extend horizontal line from midpoint to next round
   - Paint "B" (blue) at upper connection point, "R" (red) at lower connection point
   - Paint match number at vertical connector midpoint
6. Repeat cascading for each subsequent round
7. For double elimination: draw right-side participant list and mirrored bracket on right half
8. Draw round numbers at bottom of bracket area
9. Draw medal table at bottom

**R/B label placement (CRITICAL — match the reference):**
- At each match junction, TWO participant lines feed in:
  - The **upper/top** line = **B (Blue)** — paint "B" in blue color at the point where the line meets the vertical connector
  - The **lower/bottom** line = **R (Red)** — paint "R" in red color at the point where the line meets the vertical connector
- This matches the reference image exactly where "B" is above and "R" is below at every junction

**Winner name display:**
- When a match has a `winnerId`, display the winner's name (UPPERCASE) along the horizontal output line from that junction
- This shows progression through the bracket

**Hit-testing for tap-to-score:**
```dart
// During paint(), for each match junction:
final hitRect = Rect.fromCenter(
  center: junctionCenter,
  width: columnWidth * 0.8,
  height: rowHeight * 2.5, // generous hit area
);
matchHitAreas.add(MapEntry(matchId, hitRect));

// In the StatefulWidget's _handleTap:
void _handleTap(TapDownDetails details) {
  final localPosition = details.localPosition;
  for (final entry in _painter.matchHitAreas) {
    if (entry.value.contains(localPosition)) {
      widget.onMatchTap(entry.key);
      return;
    }
  }
}
```

**White background CRITICAL:** The current app uses dark theme (`Color(0xFF1E1E2C)`) for the scaffold. The tie sheet canvas MUST paint its own WHITE background so the PDF capture looks correct. The `RepaintBoundary` captures whatever is painted.

**InteractiveViewer wrapping:** The parent widget (`BracketViewerScreen.build()`) will wrap the `TieSheetCanvasWidget` in an `InteractiveViewer` for pan/zoom. The `TieSheetCanvasWidget` itself does NOT include `InteractiveViewer` — it's a pure paint canvas. Actually, looking at the current code (L982-1006), the `InteractiveViewer` + `RepaintBoundary` are in `BracketViewerScreen.build()`, not in the widget. So the `TieSheetCanvasWidget` should contain the `RepaintBoundary` + `CustomPaint` + `GestureDetector`, and be wrapped externally by `InteractiveViewer`.

**Match ordering for drawing:**
```dart
// Group matches by roundNumber
final matchesByRound = <int, List<MatchEntity>>{};
for (final m in matches) {
  matchesByRound.putIfAbsent(m.roundNumber, () => []).add(m);
}
// Sort each round by matchNumberInRound
for (final roundMatches in matchesByRound.values) {
  roundMatches.sort((a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound));
}
```

**BYE match visual:** BYE matches (where `resultType == MatchResultType.bye`) should still show the participant row on the left, but the second row shows blank/no name. The connector line simply passes through to the next round with the winner's name.

**Global match numbering:** The reference image uses a GLOBAL sequential match number across ALL rounds (1, 2, 3, 4, 5, 6, 12, 13, 14, 15, 20, 21, 24, 26, 27...). This is NOT `matchNumberInRound` — it's a sequential counter. Calculate this during layout:
```dart
int globalMatchNumber = 0;
for (var r = 1; r <= totalRounds; r++) {
  for (final match in matchesByRound[r]!) {
    globalMatchNumber++;
    matchGlobalNumbers[match.id] = globalMatchNumber;
  }
}
```
Wait — looking at the reference more carefully, the match numbers DON'T appear sequential across rounds. R1 has 1-6, then it jumps to 12-15, then 20-21, then 24, 26, 27. This suggests the numbering accounts for BOTH sides of the bracket (left + right). For single elimination, use sequential numbering starting from 1.

---

### Task 6: Update `ParticipantEntryScreen` in `main.dart`

**File:** `lib/main.dart` (class `_ParticipantEntryScreenState`, lines 57-324)

**Exact changes:**

1. **Add imports** at top of file:
   ```dart
   import 'features/bracket/domain/entities/tournament_info.dart';
   import 'features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart';
   import 'dart:ui' as ui;
   ```

2. **Add state variables** inside `_ParticipantEntryScreenState` (after L66):
   ```dart
   final _tournamentNameController = TextEditingController();
   final _dateRangeController = TextEditingController();
   final _venueController = TextEditingController();
   final _organizerController = TextEditingController();
   final _categoryController = TextEditingController();
   final _divisionLabelController = TextEditingController();
   final _registrationIdController = TextEditingController();
   ```

3. **Add dispose method** (or add to existing): Dispose all new controllers.

4. **Update `_addParticipant()`** (L68-87):
   - Pass `registrationId: _registrationIdController.text.trim().isNotEmpty ? _registrationIdController.text.trim() : null`
   - Add `_registrationIdController.clear();` after adding

5. **Update `_importCsv()`** (L91-111):
   - Parse 4th column: `registrationId: parts.length > 3 && parts[3].trim().isNotEmpty ? parts[3].trim() : null`

6. **Add "Tournament Info" card** in the `build()` method — insert BEFORE the "Configuration" card (before L158):
   ```dart
   const Text('Tournament Info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
   const SizedBox(height: 16),
   Card(
     child: Padding(
       padding: const EdgeInsets.all(16.0),
       child: Column(
         children: [
           TextField(controller: _tournamentNameController, decoration: const InputDecoration(labelText: 'Tournament Name')),
           const SizedBox(height: 8),
           TextField(controller: _dateRangeController, decoration: const InputDecoration(labelText: 'Date Range')),
           const SizedBox(height: 8),
           TextField(controller: _venueController, decoration: const InputDecoration(labelText: 'Venue')),
           const SizedBox(height: 8),
           TextField(controller: _organizerController, decoration: const InputDecoration(labelText: 'Organizer')),
           const SizedBox(height: 8),
           TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category (e.g., JUNIOR)')),
           const SizedBox(height: 8),
           TextField(controller: _divisionLabelController, decoration: const InputDecoration(labelText: 'Division (e.g., BOYS)')),
         ],
       ),
     ),
   ),
   const SizedBox(height: 16),
   ```

7. **Add "Registration ID" field** to the "Quick Add Player" card — after the Dojang field (after L214):
   ```dart
   const SizedBox(height: 8),
   TextField(
     controller: _registrationIdController,
     decoration: const InputDecoration(labelText: 'Registration ID (Optional)'),
     onSubmitted: (_) => _addParticipant(),
   ),
   ```

8. **Update participant roster ListTile subtitle** (L300):
   ```dart
   subtitle: Text([
     if (p.schoolOrDojangName != null) 'Dojang: ${p.schoolOrDojangName}',
     if (p.registrationId != null) 'Reg: ${p.registrationId}',
   ].join(' | ')),
   ```

9. **Update Navigator.push to pass TournamentInfo** (L133-143):
   ```dart
   builder: (_) => BracketViewerScreen(
     participants: _participants,
     dojangSeparation: _dojangSeparation,
     format: _format,
     includeThirdPlaceMatch: _includeThirdPlaceMatch,
     tournamentInfo: TournamentInfo(
       tournamentName: _tournamentNameController.text.trim(),
       dateRange: _dateRangeController.text.trim(),
       venue: _venueController.text.trim(),
       organizer: _organizerController.text.trim(),
       categoryLabel: _categoryController.text.trim(),
       divisionLabel: _divisionLabelController.text.trim(),
     ),
   ),
   ```

---

### Task 7: Rewrite `BracketViewerScreen` in `main.dart`

**File:** `lib/main.dart` (class `BracketViewerScreen` + `_BracketViewerScreenState`, lines 326-1092)

**Exact changes:**

1. **Add TournamentInfo parameter to BracketViewerScreen** (L327-338):
   ```dart
   class BracketViewerScreen extends StatefulWidget {
     final List<ParticipantEntity> participants;
     final bool dojangSeparation;
     final String format;
     final bool includeThirdPlaceMatch;
     final TournamentInfo tournamentInfo; // ADD
     // ... update constructor to add 'required this.tournamentInfo'
   }
   ```

2. **Remove state variables** that are no longer needed:
   - Remove `dynamic _layout;` (L347) — layout is now internal to TieSheetCanvasWidget
   - Remove `String? _selectedMatchId;` (L348) — selection state not needed
   - Remove `final _roundRobinGenerator = ...` (L352) — already done in Task 3
   - Remove `final _layoutEngine = BracketLayoutEngineImplementation();` (L353) — no longer used for rendering

3. **Simplify `_generateBracket()`** (L413-466):
   - Remove the RR branch (already done in Task 3)
   - Remove the `_layoutEngine.calculateLayout()` call at L454-458
   - Remove `_layout = layout;` from `setState`
   - Remove `_selectedMatchId = null;` from `setState`
   - The final `setState` should just set `_bracket` and `_matches`

4. **Remove `_layoutEngine.calculateLayout()` from `_declareWinner()`** (L621-626):
   - Delete these lines. `setState()` alone triggers repaint.

5. **Remove `_layoutEngine.calculateLayout()` from `_resetMatch()`** (L652-656):
   - Delete these lines.

6. **Rewrite `build()` method** (L942-1007):
   ```dart
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('Live Tournament (${widget.participants.length} Players)'),
         actions: [
           IconButton(
             icon: const Icon(Icons.picture_as_pdf),
             tooltip: 'Export PDF',
             onPressed: _exportPdf,
           ),
           IconButton(
             icon: const Icon(Icons.refresh),
             tooltip: 'Regenerate Bracket',
             onPressed: () {
               showDialog(
                 context: context,
                 builder: (ctx) => AlertDialog(
                   title: const Text('Regenerate Bracket?'),
                   content: const Text('This will reset ALL match results. Are you sure?'),
                   actions: [
                     TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                       onPressed: () { Navigator.pop(ctx); _generateBracket(); },
                       child: const Text('Regenerate'),
                     ),
                   ],
                 ),
               );
             },
           ),
         ],
       ),
       body: _matches == null
           ? const Center(child: CircularProgressIndicator())
           : InteractiveViewer(
               constrained: false,
               boundaryMargin: const EdgeInsets.all(100),
               minScale: 0.1,
               maxScale: 3.0,
               child: TieSheetCanvasWidget(
                 printKey: _printKey,
                 tournamentInfo: widget.tournamentInfo,
                 matches: _matches!,
                 participants: widget.participants,
                 bracketType: widget.format,
                 includeThirdPlaceMatch: widget.includeThirdPlaceMatch,
                 onMatchTap: (matchId) {
                   final match = _matches!.firstWhere((m) => m.id == matchId);
                   _scoreMatch(match);
                 },
               ),
             ),
     );
   }
   ```

7. **Delete methods:**
   - `_buildBracketPdf()` (L708-864) — entire method
   - `_buildRoundRobinPdf()` (L867-929) — already done in Task 3
   - `_buildRoundRobin()` (L1010-1091) — already done in Task 3
   - `_getRoundLabel()` (L932-940) — no longer used (labels are in painter now)

---

### Task 8: Implement PDF Export via Widget Capture

**File:** `lib/main.dart` (method `_exportPdf()`, currently at L688)

**Replace the entire method with:**
```dart
Future<void> _exportPdf() async {
  showDialog(context: context, builder: (ctx) => const Center(child: CircularProgressIndicator()));

  try {
    // 1. Find the RepaintBoundary
    final boundary = _printKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;

    // 2. Capture as high-resolution image
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    // 3. Build PDF with the captured image
    final doc = pw.Document();
    final pdfImage = pw.MemoryImage(pngBytes);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(16),
        build: (context) {
          return pw.Center(
            child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
          );
        },
      ),
    );

    // 4. Print/export
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
    if (mounted) Navigator.pop(context);
  } catch (e) {
    if (mounted) Navigator.pop(context);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF export failed: $e')),
      );
    }
  }
}
```

**Required import** (add at top of main.dart if not present):
```dart
import 'dart:ui' as ui;
```

**CRITICAL:** The `RenderRepaintBoundary` is obtained from `_printKey.currentContext`. The `_printKey` (`GlobalKey`) must be attached to the `RepaintBoundary` inside `TieSheetCanvasWidget`. The `TieSheetCanvasWidget` receives `printKey` as a parameter and wraps its content in `RepaintBoundary(key: printKey, ...)`.

---

### Task 9: Update Integration Tests

**File:** `test/bracket_flow_test.dart`

**Exact changes:**

1. **DELETE** group 3 ("Round Robin") entirely — lines 176-265. Remove the entire `group('3. Round Robin', () { ... });` block.

2. **UPDATE** group 7 ("Format Switching") test 7a (L460-493):
   - Remove the "Switch to Round Robin" section (L479-483)
   - Update to only test switching between Single and Double Elimination
   - Remove `expect(find.text('3rd Place Match'), findsOneWidget);` from end — just verify we can switch back to Single

3. **UPDATE** group 1 assertions:
   - The old tests look for `find.text('M1')` and `find.text('M2')` — these were card header labels from `MatchCardWidget`. The new `TieSheetCanvasWidget` uses `CustomPainter`, so `find.text()` won't find text drawn on canvas.
   - Replace with: verify participant UPPERCASE names are rendered by checking the `CustomPaint` widget exists, and verify no errors/exceptions.
   - Alternative: verify `find.byType(CustomPaint)` exists after generation.

4. **UPDATE** group 2 (Double Elimination) assertions:
   - Same approach as group 1 — verify `CustomPaint` renders without error

5. **UPDATE** group 5 (Match Scoring Logic):
   - Scoring is triggered by tapping on the `GestureDetector` area, which fires `onMatchTap`. Since `CustomPainter` doesn't create findable text widgets, the test needs to tap the `GestureDetector` directly or use the participant names from `_scoreMatch` dialog.
   - The score dialog itself (AlertDialog with "Score Match / Result") remains unchanged, so once the dialog is triggered, the same WIN button assertions work.

6. **ADD** new test group for tournament info and registration ID fields:
   ```dart
   group('8. Tournament Info & Registration', () {
     testWidgets('8a. Tournament info fields present on entry screen', (tester) async {
       app.main();
       await tester.pumpAndSettle();
       expect(find.text('Tournament Name'), findsOneWidget);
       expect(find.text('Date Range'), findsOneWidget);
       expect(find.text('Venue'), findsOneWidget);
       expect(find.text('Organizer'), findsOneWidget);
     });

     testWidgets('8b. Registration ID field present', (tester) async {
       app.main();
       await tester.pumpAndSettle();
       final regIdField = find.text('Registration ID (Optional)');
       expect(regIdField, findsOneWidget);
     });
   });
   ```

---

### Acceptance Criteria

- [ ] **AC 1**: Given I am on the entry screen, when I view the form, then I see input fields for Tournament Name, Date Range, Venue, Organizer, Category, and Division.
- [ ] **AC 2**: Given I am adding a participant, when I enter first name, last name, dojang, and registration ID, then all four fields are captured and visible in the participant roster.
- [ ] **AC 3**: Given I paste CSV data in `First,Last,Dojang,RegistrationID` format, when I import, then all four fields are populated for each participant.
- [ ] **AC 4**: Given I am on the entry screen, when I open the format dropdown, then only "Single Elimination" and "Double Elimination" are available — no "Round Robin" option.
- [ ] **AC 5**: Given I have 8 participants and select Single Elimination, when I generate the bracket, then the canvas renders a one-sided tie sheet with: white background, tournament header at top (4 lines), numbered participant list on left edge (No. | NAME in UPPERCASE | Registration ID), horizontal lines from each participant, match junction points with "B" (blue/top) and "R" (red/bottom) labels, L-shaped connector lines between rounds, match numbers at junction vertical connectors, and a medal table at the bottom.
- [ ] **AC 6**: Given I have 8 participants and select Double Elimination, when I generate the bracket, then the canvas renders a two-sided tie sheet: winners bracket flowing left-to-right on the left, losers bracket mirrored right-to-left on the right, grand finals junction in the center, participant names on both edges.
- [ ] **AC 7**: Given participants are entered with mixed-case names (e.g., "John Doe"), when the tie sheet renders, then all participant names appear in UPPERCASE (e.g., "JOHN DOE") via `toUpperCase()`.
- [ ] **AC 8**: Given I have 5 participants (non-power-of-2), when the bracket generates, then BYE matches are auto-completed and BYE winners' names appear in the advancing position on the tie sheet. The BYE participant's row shows the name but the paired row is blank.
- [ ] **AC 9**: Given the tie sheet is rendered, when I tap on a match junction area, then the existing score dialog appears (same AlertDialog with Red WINS / Blue WINS buttons).
- [ ] **AC 10**: Given I score a match and declare a winner, when `setState()` triggers a repaint, then the winner's name appears in UPPERCASE along the advancing horizontal line toward the next round.
- [ ] **AC 11**: Given the tie sheet is fully rendered on screen, when I tap Export PDF, then `RepaintBoundary.toImage(pixelRatio: 3.0)` captures the canvas, embeds it in a PDF page (A4 landscape), and `Printing.layoutPdf()` presents the print dialog.
- [ ] **AC 12**: Given the tie sheet is rendered, when I view the bottom, then a bordered table shows Gold, Silver, Bronze rows. If the finals match has a winner, Gold = winner name, Silver = loser name. If 3rd place match exists and is completed, Bronze = winner name.
- [ ] **AC 13**: Given dojang separation is enabled and 4 players include 2 from "Eagle TKD", when the bracket generates, then the two Eagle TKD players are placed in opposite halves of the bracket (not adjacent in round 1).
- [ ] **AC 14**: Given 3rd Place Match is enabled in Single Elimination with 4+ participants, when the bracket generates, then a bronze medal match junction appears on the tie sheet for semi-final losers. The medal table's Bronze row auto-populates when this match is scored.
- [ ] **AC 15**: Given only 2 participants, when the bracket generates, then a single finals junction is shown with both names, one labeled R and one labeled B.
- [ ] **AC 16**: Given 16 participants, when the bracket generates, then the tie sheet renders correctly with 4 rounds, proper vertical spacing (16 participant rows on the left), all connector lines properly aligned, and match numbers 1 through 15.

---

## Additional Context

### Dependencies

**No new external packages.** Uses:
- `pdf ^3.11.3` + `printing ^5.14.2` — PDF page creation + print dialog
- `uuid ^4.5.3` — ID generation
- `dart:ui` — `RepaintBoundary.toImage()`, `ImageByteFormat.png`
- Flutter built-in: `CustomPainter`, `Canvas`, `TextPainter`, `GestureDetector`, `InteractiveViewer`

### Testing Strategy

**Integration Tests:**
- Update `test/bracket_flow_test.dart` — remove RR tests, add tournament info tests
- Scoring tests still work via the unchanged score dialog

**Manual Testing Matrix (CRITICAL):**

| Scenario    | Participant Count | Format               | Verify                                 |
| ----------- | ----------------- | -------------------- | -------------------------------------- |
| Minimum     | 2                 | Single Elim          | Single final match renders             |
| Odd count   | 3                 | Single Elim          | 1 BYE, BYE winner advances             |
| Power of 2  | 4                 | Single Elim          | 2 semis + 1 final, no BYEs             |
| Non-power   | 5, 7              | Single Elim          | BYEs correctly placed, winners advance |
| Standard    | 8                 | Single Elim          | 3 rounds, clean bracket                |
| Large       | 14, 16            | Single Elim          | 4 rounds, proper spacing               |
| 3rd place   | 4+                | Single Elim + toggle | Bronze match for semi losers           |
| Double Elim | 4                 | Double Elim          | Winners + losers + grand finals        |
| Double Elim | 8                 | Double Elim          | Two-sided layout, center finals        |
| Dojang sep  | 4 (2 same)        | Single Elim          | Teammates separated                    |
| PDF export  | Any               | Any                  | PDF matches screen exactly             |

### High-Risk Items

1. **`TieSheetPainter` complexity** — high surface area with many drawing operations. **Mitigation:** Build incrementally — first draw participant rows + lines, then add junctions, then R/B labels, then header, then medal table. Test each layer visually before adding the next.
2. **PDF capture quality** — `pixelRatio: 3.0` might cause memory issues on low-end devices. **Mitigation:** Catch `OutOfMemoryError`, fall back to `pixelRatio: 2.0`.
3. **Hit-testing fragility** — `CustomPainter` text is not findable by `find.text()` in tests, and tap areas must be calculated manually. **Mitigation:** Use generous hit areas (at least 20px padding around junctions).
4. **Double elimination mirror layout** — geometrically complex. **Mitigation:** Implement single elimination first, verify it works, then extend to double elimination as a second pass.
5. **`_declareWinner()` layout update removal** — The current code recalculates layout after scoring. By removing this, we rely on `setState()` + `CustomPainter.shouldRepaint()` returning `true`. **Mitigation:** Ensure `TieSheetPainter` always returns `true` from `shouldRepaint()` (or compares match list references).

### Anti-Pattern Prevention

- **DO NOT** use `pw.Canvas` to redraw the bracket in PDF — use `RepaintBoundary.toImage()` for pixel-perfect capture
- **DO NOT** create separate widgets for each match slot — use ONE `CustomPainter` for the entire sheet
- **DO NOT** use the existing `BracketLayoutEngine` for positioning — the tie sheet format is fundamentally different
- **DO NOT** use dark background for the tie sheet canvas — it MUST be white for print
- **DO NOT** forget `toUpperCase()` on participant names — the reference shows ALL UPPERCASE
- **DO NOT** use `matchNumberInRound` for display — use a global sequential counter across all rounds
- **DO NOT** remove the import of `bracket_layout.dart` — `BracketLayoutOptions` may still be referenced

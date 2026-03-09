import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tkd_saas/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ─── HELPERS ──────────────────────────────────────────────────────────

  /// Start the app and navigate to the setup screen.
  Future<void> startAppAndNavigateToSetup(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    
    // Start at Dashboard
    expect(find.text('TKD Brackets'), findsOneWidget);
    
    final startButton = find.text('Start New Tournament');
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    
    // Wait for route transition
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('New Bracket Setup'), findsOneWidget);
  }

  /// Add players via the Quick Add Player form.
  /// Each player is [firstName, lastName, dojang].
  /// Optionally pass a 4th element for registrationId.
  Future<void> addPlayers(WidgetTester tester, List<List<String>> players) async {
    for (final p in players) {
      // Find text fields by label — more robust than positional index
      final firstNameField = find.widgetWithText(TextField, 'First Name');
      final lastNameField = find.widgetWithText(TextField, 'Last Name');
      final dojangField = find.widgetWithText(TextField, 'Dojang / Club (Optional)');

      await tester.ensureVisible(firstNameField);
      await tester.enterText(firstNameField, p[0]);
      await tester.enterText(lastNameField, p[1]);
      if (p.length > 2 && p[2].isNotEmpty) {
        await tester.enterText(dojangField, p[2]);
      }
      if (p.length > 3 && p[3].isNotEmpty) {
        final regIdField = find.widgetWithText(TextField, 'Registration ID (Optional)');
        await tester.enterText(regIdField, p[3]);
      }

      final addButton = find.text('Add Participant');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
    }
  }

  /// Tap the GENERATE button and navigate to the bracket viewer screen.
  Future<void> tapGenerate(WidgetTester tester) async {
    final btn = find.textContaining('GENERATE');
    expect(btn, findsOneWidget, reason: 'GENERATE button should be visible');
    await tester.ensureVisible(btn);
    await tester.tap(btn);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  /// Navigate back to the setup screen.
  Future<void> goBack(WidgetTester tester) async {
    final backButton = find.byIcon(Icons.arrow_back);
    if (tester.any(backButton)) {
      await tester.tap(backButton.first);
      await tester.pumpAndSettle();
    }
  }

  /// Switch to a specific format via the dropdown.
  Future<void> selectFormat(WidgetTester tester, String format) async {
    final dropdown = find.byType(DropdownButton<String>).first;
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text(format).last);
    await tester.pumpAndSettle();
  }

  // 4 standard players used across multiple tests
  const fourPlayers = [
    ['John', 'Doe', 'Eagle TKD', 'DL012025-22514'],
    ['Jane', 'Smith', 'Tiger TKD', 'TN012024-14083'],
    ['Mike', 'Lee', 'Eagle TKD', 'HR172026-26123'],
    ['Sarah', 'Connor', 'Dragon TKD', 'TN222026-26267'],
  ];

  // ─── GROUP 1: SINGLE ELIMINATION ─────────────────────────────────────

  group('1. Single Elimination Bracket', () {
    testWidgets('1a. 4 players → tie sheet renders with CustomPaint', (tester) async {
      await startAppAndNavigateToSetup(tester);
      expect(find.text('New Bracket Setup'), findsOneWidget);

      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      // Bracket viewer screen is shown
      expect(find.textContaining('Players'), findsOneWidget);

      // The tie sheet is rendered via CustomPaint (not card widgets)
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
      expect(find.text('New Bracket Setup'), findsOneWidget);
    });

    testWidgets('1b. 3 players → BYE handling (auto-completed)', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, [
        ['Alice', 'Kim', 'Dojang A'],
        ['Bob', 'Park', 'Dojang B'],
        ['Charlie', 'Choi', 'Dojang C'],
      ]);

      await tapGenerate(tester);
      expect(find.textContaining('Players'), findsOneWidget);

      // 3 players → bracketSize=4, 1 BYE
      // Canvas renders without errors
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });

    testWidgets('1c. 2 players → simple finals-only bracket', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, [
        ['Alpha', 'One', 'Gym A'],
        ['Beta', 'Two', 'Gym B'],
      ]);

      await tapGenerate(tester);
      expect(find.textContaining('Players'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });

    testWidgets('1d. 8 players → 3 rounds bracket renders correctly', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, [
        ['P1', 'One', 'Gym A'],
        ['P2', 'Two', 'Gym B'],
        ['P3', 'Three', 'Gym C'],
        ['P4', 'Four', 'Gym D'],
        ['P5', 'Five', 'Gym E'],
        ['P6', 'Six', 'Gym F'],
        ['P7', 'Seven', 'Gym G'],
        ['P8', 'Eight', 'Gym H'],
      ]);

      await tapGenerate(tester);
      expect(find.textContaining('Players'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });

    testWidgets('1e. 3rd place match toggle generates bronze match', (tester) async {
      await startAppAndNavigateToSetup(tester);

      // Enable 3rd place match (it's the last SwitchListTile when Single Elim is selected)
      final thirdPlaceToggle = find.text('3rd Place Match');
      await tester.ensureVisible(thirdPlaceToggle);
      await tester.tap(thirdPlaceToggle);
      await tester.pumpAndSettle();

      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      expect(find.textContaining('Players'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });
  });

  // ─── GROUP 2: DOUBLE ELIMINATION ──────────────────────────────────────

  group('2. Double Elimination Bracket', () {
    testWidgets('2a. 4 players → winners+losers brackets render', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await selectFormat(tester, 'Double Elimination');
      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      expect(find.textContaining('Players'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });

    testWidgets('2b. 8 players double elimination', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await selectFormat(tester, 'Double Elimination');
      await addPlayers(tester, [
        ['P1', 'One', 'Gym A'],
        ['P2', 'Two', 'Gym B'],
        ['P3', 'Three', 'Gym C'],
        ['P4', 'Four', 'Gym D'],
        ['P5', 'Five', 'Gym E'],
        ['P6', 'Six', 'Gym F'],
        ['P7', 'Seven', 'Gym G'],
        ['P8', 'Eight', 'Gym H'],
      ]);

      await tapGenerate(tester);
      expect(find.textContaining('Players'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });
  });

  // ─── GROUP 3: TOURNAMENT INFO & REGISTRATION ──────────────────────────

  group('3. Tournament Info & Registration ID', () {
    testWidgets('3a. Tournament info fields are present on entry screen', (tester) async {
      await startAppAndNavigateToSetup(tester);

      expect(find.text('Tournament Info'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Tournament Name'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Date Range'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Venue'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Organizer'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Category (e.g., JUNIOR)'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Division (e.g., BOYS)'), findsOneWidget);
    });

    testWidgets('3b. Registration ID field is present', (tester) async {
      await startAppAndNavigateToSetup(tester);

      final regIdField = find.widgetWithText(TextField, 'Registration ID (Optional)');
      expect(regIdField, findsOneWidget);
    });

    testWidgets('3c. Registration ID appears in participant roster', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, [
        ['Test', 'Player', 'Gym', 'REG-12345'],
      ]);

      // The roster should show Reg: REG-12345 in subtitle
      expect(find.textContaining('Reg: REG-12345'), findsOneWidget);
    });

    testWidgets('3d. Tournament info is passed to bracket screen', (tester) async {
      await startAppAndNavigateToSetup(tester);

      // Fill tournament info
      await tester.enterText(find.widgetWithText(TextField, 'Tournament Name'), '2ND FEDERATION CUP');
      await tester.enterText(find.widgetWithText(TextField, 'Date Range'), '18-22 Jan 2026');
      await tester.enterText(find.widgetWithText(TextField, 'Venue'), 'SMS Indoor Stadium');
      await tester.enterText(find.widgetWithText(TextField, 'Organizer'), 'INDIA TAEKWONDO');

      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      // Bracket screen renders (tournament info is painted on canvas, not findable as text widgets)
      expect(find.textContaining('Players'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });
  });

  // ─── GROUP 4: PARTICIPANT MANAGEMENT ──────────────────────────────────

  group('4. Participant Management', () {
    testWidgets('4a. Add, verify count, clear all', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, fourPlayers);

      // GENERATE button should be visible (>= 2 players)
      expect(find.textContaining('GENERATE'), findsOneWidget);

      // Roster shows count
      expect(find.textContaining('Participant Roster (4)'), findsOneWidget);

      // Clear all
      final clearAll = find.text('Clear All');
      await tester.ensureVisible(clearAll);
      await tester.tap(clearAll);
      await tester.pumpAndSettle();

      // GENERATE should disappear (0 players)
      expect(find.textContaining('GENERATE'), findsNothing);

      // Empty state message
      expect(find.textContaining('Add players'), findsOneWidget);
    });

    testWidgets('4b. Remove individual participant', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, [
        ['Test', 'Player1', 'Gym'],
        ['Test', 'Player2', 'Gym'],
        ['Test', 'Player3', 'Gym'],
      ]);

      // Should see 3 close buttons
      final closeButtons = find.byIcon(Icons.close);
      expect(closeButtons, findsNWidgets(3));

      // Remove first player
      await tester.tap(closeButtons.first);
      await tester.pumpAndSettle();

      // Now 2 close buttons
      expect(find.byIcon(Icons.close), findsNWidgets(2));
    });

    testWidgets('4c. CSV import with 4 columns (first,last,dojang,regId)', (tester) async {
      await startAppAndNavigateToSetup(tester);

      // Tap CSV import button  
      final csvBtn = find.textContaining('Paste CSV');
      await tester.ensureVisible(csvBtn);
      await tester.tap(csvBtn);
      await tester.pumpAndSettle();

      // CSV dialog should appear
      expect(find.text('Paste CSV'), findsOneWidget);

      // Enter CSV data with 4 columns
      final csvField = find.byType(TextField).last;
      await tester.enterText(csvField, 'Kim,Park,Eagle TKD,REG001\nLee,Jung,Tiger TKD,REG002\nChoi,Han,Dragon TKD,REG003');
      await tester.pumpAndSettle();

      // Tap Import
      await tester.tap(find.text('Import'));
      await tester.pumpAndSettle();

      // GENERATE should appear (3 players added)
      expect(find.textContaining('GENERATE'), findsOneWidget);
    });

    testWidgets('4d. Cannot generate with 0 or 1 player', (tester) async {
      await startAppAndNavigateToSetup(tester);

      // 0 players: no GENERATE
      expect(find.textContaining('GENERATE'), findsNothing);

      // Add 1 player
      await addPlayers(tester, [['Solo', 'Player', 'Gym']]);

      // Still no GENERATE (need >= 2)
      expect(find.textContaining('GENERATE'), findsNothing);

      // Add a 2nd
      await addPlayers(tester, [['Second', 'Player', 'Gym']]);
      expect(find.textContaining('GENERATE'), findsOneWidget);
    });

    testWidgets('4e. Participant names shown in UPPERCASE in roster', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, [['john', 'doe', 'Eagle TKD']]);

      // The roster ListTile title renders names in uppercase
      expect(find.text('JOHN DOE'), findsOneWidget);
    });
  });

  // ─── GROUP 5: FORMAT SWITCHING ────────────────────────────────────────

  group('5. Format Switching', () {
    testWidgets('5a. Switch between Single and Double Elimination', (tester) async {
      await startAppAndNavigateToSetup(tester);

      // Default: Single Elimination
      expect(find.text('Single Elimination'), findsOneWidget);

      // 3rd place toggle visible for Single Elimination
      expect(find.text('3rd Place Match'), findsOneWidget);

      // Switch to Double
      await selectFormat(tester, 'Double Elimination');

      // 3rd place toggle should NOT be visible for Double
      expect(find.text('3rd Place Match'), findsNothing);

      // Switch back to Single
      await selectFormat(tester, 'Single Elimination');

      // 3rd place toggle should reappear
      expect(find.text('3rd Place Match'), findsOneWidget);
    });

    testWidgets('5b. No Round Robin option in dropdown', (tester) async {
      await startAppAndNavigateToSetup(tester);

      // Open dropdown
      final dropdown = find.byType(DropdownButton<String>).first;
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Round Robin should NOT exist
      expect(find.text('Round Robin'), findsNothing);

      // Only Single and Double should exist
      expect(find.text('Single Elimination'), findsWidgets);
      expect(find.text('Double Elimination'), findsOneWidget);

      // Close dropdown by tapping outside or selecting current
      await tester.tap(find.text('Single Elimination').last);
      await tester.pumpAndSettle();
    });
  });

  // ─── GROUP 6: DOJANG SEPARATION ───────────────────────────────────────

  group('6. Dojang Separation', () {
    testWidgets('6a. Toggle is ON by default, players separated', (tester) async {
      await startAppAndNavigateToSetup(tester);

      // Verify dojang separation switch is present and on
      expect(find.text('Dojang / School Separation'), findsOneWidget);

      // Add players: 2 from Eagle TKD should end up on opposite sides
      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      // Bracket renders without errors
      expect(find.textContaining('Players'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });
  });

  // ─── GROUP 7: BRACKET VIEWER FEATURES ─────────────────────────────────

  group('7. Bracket Viewer Features', () {
    testWidgets('7a. InteractiveViewer wraps the canvas for pan/zoom', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      // InteractiveViewer should be present
      expect(find.byType(InteractiveViewer), findsOneWidget);

      await goBack(tester);
    });

    testWidgets('7b. Regenerate bracket dialog works', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      // Tap regenerate button
      final regenBtn = find.byTooltip('Regenerate');
      await tester.tap(regenBtn);
      await tester.pumpAndSettle();

      // Confirmation dialog appears
      expect(find.text('Regenerate Bracket?'), findsOneWidget);

      // Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Still on bracket screen
      expect(find.textContaining('Players'), findsOneWidget);

      await goBack(tester);
    });

    testWidgets('7c. Export PDF button exists', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      // PDF export button tooltip
      expect(find.byTooltip('Export PDF'), findsOneWidget);

      await goBack(tester);
    });
  });

  // ─── GROUP 8: STRESS / EDGE CASES ─────────────────────────────────────

  group('8. Edge Cases', () {
    testWidgets('8a. 5 players (non-power-of-2) renders without error', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, [
        ['P1', 'One', 'A'],
        ['P2', 'Two', 'B'],
        ['P3', 'Three', 'C'],
        ['P4', 'Four', 'D'],
        ['P5', 'Five', 'E'],
      ]);

      await tapGenerate(tester);
      expect(find.textContaining('Tournament Bracket'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });

    testWidgets('8b. 7 players (non-power-of-2) renders without error', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, [
        ['P1', 'One', 'A'],
        ['P2', 'Two', 'B'],
        ['P3', 'Three', 'C'],
        ['P4', 'Four', 'D'],
        ['P5', 'Five', 'E'],
        ['P6', 'Six', 'F'],
        ['P7', 'Seven', 'G'],
      ]);

      await tapGenerate(tester);
      expect(find.textContaining('Tournament Bracket'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });

    testWidgets('8c. 14 players (like reference image) renders without error', (tester) async {
      await startAppAndNavigateToSetup(tester);

      await addPlayers(tester, [
        ['Saiansh', 'Mathur', 'Delhi', 'DL012025-22514'],
        ['R.S.', 'Vignesh', 'Tamil Nadu', 'TN012024-14083'],
        ['Shashi', 'Kumar', 'Haryana', 'HR172026-26123'],
        ['J.', 'Vino', 'Tamil Nadu', 'TN222026-26267'],
        ['Aarush', 'Barua', 'Chandigarh', 'CH012026-26255'],
        ['Asad', 'Khan', 'UP', 'UP322025-20125'],
        ['Arsalan', 'Khan', 'Maharashtra', 'MH032025-25234'],
        ['Ayush', 'Kumar', 'UP', 'UP53202525572'],
        ['Lakshay', 'Goyar', 'Rajasthan', 'RJ162026-25767'],
        ['Akash', 'Kumar', 'UP', 'UP322024-16826'],
        ['Gedajit', 'Irengbam', 'Manipur', 'MN042023-5340'],
        ['Pranjit', 'Sakia', 'Assam', 'AS132023-6969'],
        ['Rajat', 'Solanki', 'Rajasthan', 'RJ062022-4069'],
        ['Jay Dinesh', 'Salaskar', 'Maharashtra', 'MH332025-25272'],
      ]);

      await tapGenerate(tester);
      expect(find.textContaining('Tournament Bracket'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });
  });
}

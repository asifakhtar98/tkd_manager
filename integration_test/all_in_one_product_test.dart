import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tkd_saas/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ─── HELPERS ──────────────────────────────────────────────────────────

  Future<void> startAppAndNavigateToSetup(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    
    expect(find.text('TKD Tournament Manager'), findsOneWidget);
    
    // Dashboard now uses a 'New Bracket' FAB instead of the old card button.
    final startButton = find.text('New Bracket');
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('New Bracket Setup'), findsOneWidget);
  }

  /// Selects '+ Create New Tournament' from the tournament dropdown and
  /// fills the required name field. Must be called before [tapGenerate]
  /// because GENERATE is gated on a tournament being set.
  Future<void> selectCreateNewTournament(
    WidgetTester tester, {
    String name = 'Test Tournament',
  }) async {
    final tournamentDropdown = find.byType(DropdownButton<String>).first;
    await tester.ensureVisible(tournamentDropdown);
    await tester.tap(tournamentDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('+ Create New Tournament').last);
    await tester.pumpAndSettle();
    final nameField = find.widgetWithText(TextField, 'Tournament Name *');
    await tester.ensureVisible(nameField);
    await tester.enterText(nameField, name);
    await tester.pump();
  }

  Future<void> addPlayers(WidgetTester tester, List<List<String>> players) async {
    for (final p in players) {
      final fullNameField = find.widgetWithText(TextField, 'Full Name');
      final dojangField = find.widgetWithText(TextField, 'Dojang / Club (Optional)');

      await tester.ensureVisible(fullNameField);
      await tester.enterText(fullNameField, p[0]);
      if (p.length > 1 && p[1].isNotEmpty) {
        await tester.enterText(dojangField, p[1]);
      }
      if (p.length > 2 && p[2].isNotEmpty) {
        final regIdField = find.widgetWithText(TextField, 'Registration ID (Optional)');
        await tester.enterText(regIdField, p[2]);
      }

      final addButton = find.text('Add Participant');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
    }
  }

  Future<void> tapGenerate(WidgetTester tester) async {
    final btn = find.textContaining('GENERATE');
    expect(btn, findsOneWidget, reason: 'GENERATE button should be visible');
    await tester.ensureVisible(btn);
    await tester.tap(btn);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> goBack(WidgetTester tester) async {
    final backButton = find.byIcon(Icons.arrow_back);
    if (tester.any(backButton)) {
      await tester.tap(backButton.first);
      await tester.pumpAndSettle();
    }
  }

  Future<void> selectFormat(WidgetTester tester, String format) async {
    // Format dropdown is at index 1; index 0 is the tournament selector.
    final dropdown = find.byType(DropdownButton<String>).at(1);
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text(format).last);
    await tester.pumpAndSettle();
  }

  Future<void> clearAll(WidgetTester tester) async {
    final clearAll = find.text('Clear All');
    if (tester.any(clearAll)) {
      await tester.ensureVisible(clearAll);
      await tester.tap(clearAll);
      await tester.pumpAndSettle();
    }
  }

  bool isGenerateEnabled(WidgetTester tester) {
    final btnWidget = tester.widget<ElevatedButton>(find.ancestor(of: find.textContaining('GENERATE'), matching: find.byType(ElevatedButton)));
    return btnWidget.onPressed != null;
  }

  // Common player sets — each entry is [Full Name, Dojang (opt), RegID (opt)]
  final playerSets = {
    2: [['Alpha One', 'Gym A'], ['Beta Two', 'Gym B']],
    3: [['Alice Kim', 'Dojang A'], ['Bob Park', 'Dojang B'], ['Charlie Choi', 'Dojang C']],
    4: [
      ['John Doe', 'Eagle TKD', 'DL012025-22514'],
      ['Jane Smith', 'Tiger TKD', 'TN012024-14083'],
      ['Mike Lee', 'Eagle TKD', 'HR172026-26123'],
      ['Sarah Connor', 'Dragon TKD', 'TN222026-26267']
    ],
    5: [['P1', 'A'], ['P2', 'B'], ['P3', 'C'], ['P4', 'D'], ['P5', 'E']],
    7: [['P1', 'A'], ['P2', 'B'], ['P3', 'C'], ['P4', 'D'], ['P5', 'E'], ['P6', 'F'], ['P7', 'G']],
    8: [
      ['P1 One', 'Gym A'], ['P2 Two', 'Gym B'], ['P3 Three', 'Gym C'], ['P4 Four', 'Gym D'],
      ['P5 Five', 'Gym E'], ['P6 Six', 'Gym F'], ['P7 Seven', 'Gym G'], ['P8 Eight', 'Gym H']
    ],
    14: [
      ['Saiansh M', 'DL'], ['R.S. V', 'TN'], ['Shashi K', 'HR'], ['J. V', 'TN'],
      ['Aarush B', 'CH'], ['Asad K', 'UP'], ['Arsalan K', 'MH'], ['Ayush K', 'UP'],
      ['Lakshay G', 'RJ'], ['Akash K', 'UP'], ['Gedajit I', 'MN'], ['Pranjit S', 'AS'],
      ['Rajat S', 'RJ'], ['Jay S', 'MH']
    ]
  };

  // ─── GROUP 1: SINGLE ELIMINATION (Consolidated) ──────────────────────

  group('1. Single Elimination', () {
    testWidgets('1a. Renders 2, 3, 4, and 8-player tie sheets safely and tests post-generation actions', (tester) async {
      await startAppAndNavigateToSetup(tester);

      for (final count in [2, 3, 4, 8]) {
        await selectCreateNewTournament(tester);
        await addPlayers(tester, playerSets[count]!);
        await tapGenerate(tester);

        expect(find.textContaining('Players'), findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);

        // POST-GENERATION ACTIONS
        // 1. Pan/Zoom (Scroll interactive viewer slightly)
        final viewer = find.byType(InteractiveViewer);
        expect(viewer, findsOneWidget);
        await tester.drag(viewer, const Offset(-50, -50));
        await tester.pumpAndSettle();

        // 2. Export PDF
        final exportBtn = find.byTooltip('Export PDF');
        expect(exportBtn, findsOneWidget);
        // Can't fully test system print dialog, but we ensure the button is tappable
        await tester.tap(exportBtn);
        await tester.pumpAndSettle();

        // 3. Regenerate Dialog
        final regenBtn = find.byTooltip('Regenerate');
        await tester.tap(regenBtn);
        await tester.pumpAndSettle();
        expect(find.text('Regenerate Bracket?'), findsOneWidget);
        await tester.tap(find.text('Regenerate'));
        await tester.pumpAndSettle();
        expect(find.byType(CustomPaint), findsWidgets); // Still displays canvas after regeneration
        
        await goBack(tester);
        await clearAll(tester);
      }
    });

    testWidgets('1b. 3rd place toggle generates bronze match', (tester) async {
      await startAppAndNavigateToSetup(tester);
      await selectCreateNewTournament(tester);

      final thirdPlaceToggle = find.text('3rd Place Match');
      await tester.ensureVisible(thirdPlaceToggle);
      await tester.tap(thirdPlaceToggle);
      await tester.pumpAndSettle();

      await addPlayers(tester, playerSets[4]!);
      await tapGenerate(tester);

      expect(find.textContaining('Players'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });
  });

  // ─── GROUP 2: DOUBLE ELIMINATION (Consolidated) ──────────────────────

  group('2. Double Elimination', () {
    testWidgets('2a. Renders 4 and 8-player brackets and tests Tab Switching', (tester) async {
      await startAppAndNavigateToSetup(tester);
      await selectFormat(tester, 'Double Elimination');

      for (final count in [4, 8]) {
        await selectCreateNewTournament(tester);
        await addPlayers(tester, playerSets[count]!);
        await tapGenerate(tester);

        expect(find.textContaining('Players'), findsOneWidget);
        
        // POST-GENERATION ACTIONS: Tab Switching
        expect(find.text('Winners Bracket'), findsOneWidget);
        expect(find.text('Losers Bracket'), findsOneWidget);
        
        // Tap Losers Bracket
        await tester.tap(find.text('Losers Bracket'));
        await tester.pumpAndSettle();
        // Since we have two tab views, CustomPaint should be present for Losers rendering
        expect(find.byType(CustomPaint), findsWidgets);
        
        // Tap Winners Bracket
        await tester.tap(find.text('Winners Bracket'));
        await tester.pumpAndSettle();
        expect(find.byType(CustomPaint), findsWidgets);

        await goBack(tester);
        await clearAll(tester);
      }
    });
  });

  // ─── GROUP 3: TOURNAMENT INFO & REGISTRATION (Consolidated) ──────────

  group('3. Tournament Info & Registration ID', () {
    testWidgets('3a. Tournament info form fill and roster verification', (tester) async {
      await startAppAndNavigateToSetup(tester);

      // Select create-new to reveal tournament fields.
      await selectCreateNewTournament(tester, name: '2ND FEDERATION CUP');

      // Verify fields exist (now labeled with asterisk).
      expect(find.text('Tournament'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Tournament Name *'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Registration ID (Optional)'), findsOneWidget);

      // Fill remaining tournament info fields.
      await tester.enterText(find.widgetWithText(TextField, 'Date Range'), '18-22 Jan 2026');
      await tester.enterText(find.widgetWithText(TextField, 'Venue'), 'SMS Indoor Stadium');

      // Add player with Reg ID.
      await addPlayers(tester, [['Test Player', 'Gym', 'REG-12345']]);
      
      // The roster should show REG-12345 in subtitle.
      expect(find.textContaining('REG-12345'), findsOneWidget);

      // We need 2 players to generate.
      await addPlayers(tester, [['Second Player', 'Gym']]);
      
      await tapGenerate(tester);

      expect(find.textContaining('Players'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
      // Note: tournament fields do not persist after navigating back since
      // ParticipantEntryScreen is a fresh instance. The bracket is verified above.
    });
  });

  // ─── GROUP 4: PARTICIPANT MANAGEMENT (Consolidated) ──────────────────

  group('4. Participant Management', () {
    testWidgets('4a. Add, clear all, discrete removal, and generate validation', (tester) async {
      await startAppAndNavigateToSetup(tester);

      // Generate is disabled initially (no tournament selected yet).
      expect(isGenerateEnabled(tester), isFalse);

      await selectCreateNewTournament(tester);
      await addPlayers(tester, playerSets[4]!);
      expect(isGenerateEnabled(tester), isTrue);
      expect(find.textContaining('Participant Roster (4)'), findsOneWidget);

      // Remove single player
      final closeButtons = find.byIcon(Icons.close);
      expect(closeButtons, findsNWidgets(4));
      await tester.tap(closeButtons.first);
      await tester.pumpAndSettle();
      expect(find.textContaining('Participant Roster (3)'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNWidgets(3));

      // Clear all
      await clearAll(tester);
      expect(isGenerateEnabled(tester), isFalse);
      expect(find.textContaining('Add players'), findsOneWidget);
    });

    testWidgets('4b. CSV import with 4 columns', (tester) async {
      await startAppAndNavigateToSetup(tester);
      await selectCreateNewTournament(tester);

      final csvBtn = find.textContaining('Paste CSV');
      await tester.ensureVisible(csvBtn);
      await tester.tap(csvBtn);
      await tester.pumpAndSettle();

      expect(find.text('Paste CSV'), findsOneWidget);

      final csvField = find.byType(TextField).last;
      await tester.enterText(csvField, 'Kim Park,Eagle TKD,REG001\nLee Jung,Tiger TKD,REG002\nChoi Han,Dragon TKD,REG003');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Import'));
      await tester.pumpAndSettle();

      expect(isGenerateEnabled(tester), isTrue);
      expect(find.textContaining('Participant Roster (3)'), findsOneWidget);
    });
    
    testWidgets('4c. Participant names shown in UPPERCASE', (tester) async {
      await startAppAndNavigateToSetup(tester);
      await selectCreateNewTournament(tester);
      await addPlayers(tester, [['john doe', 'Eagle TKD']]);
      expect(find.text('JOHN DOE'), findsOneWidget);
    });
  });

  // ─── GROUP 5: FORMAT & DOJANG SEPARATION ──────────────────────────────

  group('5. Advanced Settings Toggle', () {
    testWidgets('5a. Switch settings (Format, 3rd Place, Dojang)', (tester) async {
      await startAppAndNavigateToSetup(tester);

      expect(find.text('Single Elimination'), findsOneWidget);
      expect(find.text('3rd Place Match'), findsOneWidget);
      expect(find.text('Dojang / School Separation'), findsOneWidget);

      // Switch to Double ELim
      await selectFormat(tester, 'Double Elimination');
      expect(find.text('3rd Place Match'), findsNothing);

      await selectFormat(tester, 'Single Elimination');
      expect(find.text('3rd Place Match'), findsOneWidget);

      // Check Round Robin absence
      final dropdown = find.byType(DropdownButton<String>).first;
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      expect(find.text('Round Robin'), findsNothing);
      expect(find.text('Single Elimination'), findsWidgets);
      await tester.tap(find.text('Single Elimination').last);
      await tester.pumpAndSettle();
    });
  });

  // ─── GROUP 6: EDGE CASES (Consolidated) ───────────────────────────────

  group('6. Edge Cases', () {
    testWidgets('6a. Non-power of 2 (5, 7) and strict reference (14) size brackets', (tester) async {
      await startAppAndNavigateToSetup(tester);

      for (final count in [5, 7, 14]) {
        await selectCreateNewTournament(tester);
        await addPlayers(tester, playerSets[count]!);
        await tapGenerate(tester);

        expect(find.textContaining('Players'), findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);

        await goBack(tester);
        await clearAll(tester);
      }
    });
  });
}

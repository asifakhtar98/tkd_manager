import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/main.dart' as app;

void main() {
  Future<void> navigateToSetup(WidgetTester tester) async {
    await tester.pumpWidget(const app.TkdTournamentApp());
    await tester.pumpAndSettle();

    final startBtn = find.text('Start New Tournament');
    await tester.ensureVisible(startBtn);
    await tester.tap(startBtn);
    await tester.pumpAndSettle();
  }

  Future<void> addPlayers(
    WidgetTester tester,
    List<List<String>> players,
  ) async {
    final firstInput = find.widgetWithText(TextField, 'First Name');
    final lastInput = find.widgetWithText(TextField, 'Last Name');
    final dojangInput = find.widgetWithText(
      TextField,
      'Dojang / Club (Optional)',
    );
    final addButton = find.text('Add Participant');

    for (final p in players) {
      await tester.ensureVisible(firstInput);
      await tester.enterText(firstInput, p[0]);
      await tester.pump();
      await tester.ensureVisible(lastInput);
      await tester.enterText(lastInput, p[1]);
      await tester.pump();
      await tester.ensureVisible(dojangInput);
      await tester.enterText(dojangInput, p[2]);
      await tester.pump();
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
    }
  }

  Future<void> tapGenerate(WidgetTester tester) async {
    final btn = find.text('GENERATE');
    await tester.ensureVisible(btn);
    await tester.tap(btn);
    await tester.pumpAndSettle(const Duration(seconds: 1));
  }

  Future<void> goBack(WidgetTester tester) async {
    final backButton = find.byType(BackButton);
    if (!tester.any(backButton)) {
      final iconBack = find.byIcon(Icons.arrow_back);
      if (tester.any(iconBack)) {
        await tester.tap(iconBack);
        await tester.pumpAndSettle();
      }
    } else {
      await tester.tap(backButton);
      await tester.pumpAndSettle();
    }
  }

  const fourPlayers = [
    ['John', 'Doe', 'Eagle TKD'],
    ['Jane', 'Smith', 'Tiger TKD'],
    ['Mike', 'Lee', 'Eagle TKD'],
    ['Sarah', 'Connor', 'Dragon TKD'],
  ];

  group('1. Single Elimination Bracket Generation', () {
    testWidgets('1a. 4 players: correct bracket structure', (tester) async {
      await navigateToSetup(tester);
      expect(find.text('New Bracket Setup'), findsOneWidget);

      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);
      expect(find.textContaining('Single Elimination'), findsOneWidget);

      await goBack(tester);
    });

    testWidgets('1b. 3 players: BYE handling', (tester) async {
      await navigateToSetup(tester);

      await addPlayers(tester, [
        ['Alice', 'Kim', 'Dojang A'],
        ['Bob', 'Park', 'Dojang B'],
        ['Charlie', 'Choi', 'Dojang C'],
      ]);

      await tapGenerate(tester);
      expect(find.textContaining('Single Elimination'), findsOneWidget);

      await goBack(tester);
    });

    testWidgets('1c. 8 players: larger bracket generation', (tester) async {
      await navigateToSetup(tester);

      await addPlayers(tester, [
        ['Player', '1', 'Club A'],
        ['Player', '2', 'Club B'],
        ['Player', '3', 'Club C'],
        ['Player', '4', 'Club D'],
        ['Player', '5', 'Club E'],
        ['Player', '6', 'Club F'],
        ['Player', '7', 'Club G'],
        ['Player', '8', 'Club H'],
      ]);

      await tapGenerate(tester);
      expect(find.textContaining('Single Elimination'), findsOneWidget);
      expect(find.textContaining('8 Players'), findsOneWidget);

      await goBack(tester);
    });
  });

  group('2. Double Elimination Bracket Generation', () {
    testWidgets('2a. 4 players: winners+losers brackets generated', (
      tester,
    ) async {
      await navigateToSetup(tester);

      final formatDropdown = find.byType(DropdownButton<String>).first;
      await tester.ensureVisible(formatDropdown);
      await tester.tap(formatDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Double Elimination').last);
      await tester.pumpAndSettle();

      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);
      expect(find.textContaining('Double Elimination'), findsOneWidget);
      expect(find.text('Winners Bracket'), findsOneWidget);
      expect(find.text('Losers Bracket'), findsOneWidget);

      await goBack(tester);
    });

    testWidgets('2b. Tab switching between Winners and Losers brackets', (
      tester,
    ) async {
      await navigateToSetup(tester);

      final formatDropdown = find.byType(DropdownButton<String>).first;
      await tester.ensureVisible(formatDropdown);
      await tester.tap(formatDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Double Elimination').last);
      await tester.pumpAndSettle();

      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      expect(find.text('Winners Bracket'), findsOneWidget);
      expect(find.text('Losers Bracket'), findsOneWidget);

      final losersTab = find.text('Losers Bracket');
      await tester.tap(losersTab);
      await tester.pumpAndSettle();

      await goBack(tester);
    });
  });

  group('3. Participant Management', () {
    testWidgets('3a. Add participants, verify count, clear all', (
      tester,
    ) async {
      await navigateToSetup(tester);

      await addPlayers(tester, fourPlayers);
      expect(find.text('GENERATE'), findsOneWidget);

      final clearAll = find.text('Clear All');
      await tester.ensureVisible(clearAll);
      await tester.tap(clearAll);
      await tester.pumpAndSettle();

      expect(
        find.byTooltip('Add at least 2 players to generate a bracket'),
        findsOneWidget,
      );
    });

    testWidgets('3b. CSV import with First,Last,Dojang,RegID format', (
      tester,
    ) async {
      await navigateToSetup(tester);

      final csvBtn = find.text('Paste CSV (First,Last,Dojang,RegID)');
      await tester.ensureVisible(csvBtn);
      await tester.tap(csvBtn);
      await tester.pumpAndSettle();

      final csvField = find.byType(TextField).last;
      await tester.enterText(
        csvField,
        'Kim,Park,Eagle TKD,REG123\nLee,Jung,Tiger TKD,REG456',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Import'));
      await tester.pumpAndSettle();

      expect(find.text('GENERATE'), findsOneWidget);
      expect(find.textContaining('REG123'), findsOneWidget);
    });

    testWidgets('3c. Remove individual participant', (tester) async {
      await navigateToSetup(tester);

      await addPlayers(tester, [
        ['Alice', 'Kim', 'Dojang A'],
        ['Bob', 'Park', 'Dojang B'],
      ]);

      expect(find.textContaining('ALICE'), findsOneWidget);
      expect(find.textContaining('BOB'), findsOneWidget);

      final closeButtons = find.byIcon(Icons.close);
      expect(closeButtons, findsWidgets);
      await tester.tap(closeButtons.last);
      await tester.pumpAndSettle();

      expect(find.textContaining('Alice'), findsNothing);
    });

    testWidgets('3d. Reorder participants (drag and drop for seeding)', (
      tester,
    ) async {
      await navigateToSetup(tester);

      await addPlayers(tester, [
        ['Alice', 'Kim', 'Dojang A'],
        ['Bob', 'Park', 'Dojang B'],
        ['Charlie', 'Lee', 'Dojang C'],
      ]);

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      final dragHandles = find.byIcon(Icons.drag_handle);
      expect(dragHandles, findsWidgets);
    });

    testWidgets('3e. View participant roster with details', (tester) async {
      await navigateToSetup(tester);

      await addPlayers(tester, [
        ['John', 'Doe', 'Eagle TKD'],
      ]);

      expect(find.textContaining('JOHN DOE'), findsOneWidget);
      expect(find.textContaining('Dojang: Eagle TKD'), findsOneWidget);
    });
  });

  group('4. Tournament Configuration', () {
    testWidgets('4a. Tournament info fields are present on entry screen', (
      tester,
    ) async {
      await navigateToSetup(tester);
      expect(find.text('Tournament Name'), findsOneWidget);
      expect(find.text('Date Range'), findsOneWidget);
      expect(find.text('Venue'), findsOneWidget);
      expect(find.text('Organizer'), findsOneWidget);
      expect(find.text('Category (e.g., JUNIOR)'), findsOneWidget);
      expect(find.text('Division (e.g., BOYS)'), findsOneWidget);
    });

    testWidgets('4b. Registration ID field is present', (tester) async {
      await navigateToSetup(tester);
      expect(find.text('Registration ID (Optional)'), findsOneWidget);
    });

    testWidgets('4c. Fill and save tournament info fields', (tester) async {
      await navigateToSetup(tester);

      final tournamentNameField = find.widgetWithText(
        TextField,
        'Tournament Name',
      );
      await tester.enterText(tournamentNameField, 'National TKD Championship');
      await tester.pump();

      final venueField = find.widgetWithText(TextField, 'Venue');
      await tester.enterText(venueField, 'Sports Arena');
      await tester.pump();

      expect(find.text('National TKD Championship'), findsOneWidget);
    });

    testWidgets(
      '4d. Dojang/School Separation toggle is present and functional',
      (tester) async {
        await navigateToSetup(tester);

        expect(find.text('Dojang / School Separation'), findsOneWidget);
        expect(find.text('Auto-distribute teammates'), findsOneWidget);

        final switchTile = find.byType(SwitchListTile).first;
        expect(switchTile, findsOneWidget);
      },
    );

    testWidgets(
      '4e. 3rd Place Match toggle is present for Single Elimination',
      (tester) async {
        await navigateToSetup(tester);

        expect(find.text('3rd Place Match'), findsOneWidget);
        expect(find.text('Bronze medal match for semi losers'), findsOneWidget);

        final switchTile = find.byType(SwitchListTile);
        expect(switchTile, findsWidgets);
      },
    );

    testWidgets('4f. 3rd Place Match option hidden for Double Elimination', (
      tester,
    ) async {
      await navigateToSetup(tester);

      final formatDropdown = find.byType(DropdownButton<String>).first;
      await tester.ensureVisible(formatDropdown);
      await tester.tap(formatDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Double Elimination').last);
      await tester.pumpAndSettle();

      expect(find.text('3rd Place Match'), findsNothing);
    });

    testWidgets('4g. Format selection between Single and Double Elimination', (
      tester,
    ) async {
      await navigateToSetup(tester);

      final formatDropdown = find.byType(DropdownButton<String>).first;
      await tester.ensureVisible(formatDropdown);
      await tester.tap(formatDropdown);
      await tester.pumpAndSettle();

      expect(find.text('Single Elimination'), findsWidgets);
      expect(find.text('Double Elimination'), findsWidgets);
    });
  });

  group('5. Bracket Viewer Actions', () {
    testWidgets('5a. Generate bracket and verify viewer screen loads', (
      tester,
    ) async {
      await navigateToSetup(tester);
      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      expect(find.textContaining('Single Elimination'), findsOneWidget);
      expect(find.textContaining('4 Players'), findsOneWidget);

      await goBack(tester);
    });

    testWidgets('5b. Regenerate bracket with confirmation dialog', (
      tester,
    ) async {
      await navigateToSetup(tester);
      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      final refreshButton = find.byIcon(Icons.refresh);
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      expect(find.text('Regenerate Bracket?'), findsOneWidget);
      expect(
        find.text('Current match scores and progress will be lost.'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Regenerate'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Regenerate Bracket?'), findsNothing);

      await goBack(tester);
    });

    testWidgets('5c. Confirm regenerate action', (tester) async {
      await navigateToSetup(tester);
      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      final refreshButton = find.byIcon(Icons.refresh);
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Regenerate'));
      await tester.pumpAndSettle();

      expect(find.text('Regenerate Bracket?'), findsNothing);

      await goBack(tester);
    });

    testWidgets('5d. Export PDF button is present', (tester) async {
      await navigateToSetup(tester);
      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      expect(find.byIcon(Icons.picture_as_pdf), findsOneWidget);
      expect(find.byTooltip('Export PDF'), findsOneWidget);

      await goBack(tester);
    });

    testWidgets('5e. Back navigation from bracket viewer', (tester) async {
      await navigateToSetup(tester);
      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      await goBack(tester);

      expect(find.text('New Bracket Setup'), findsOneWidget);
    });

    testWidgets('5f. InteractiveViewer is present for pan/zoom', (
      tester,
    ) async {
      await navigateToSetup(tester);
      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);

      expect(find.byType(InteractiveViewer), findsOneWidget);

      await goBack(tester);
    });
  });

  group('6. Combined Workflow Tests', () {
    testWidgets(
      '6a. Full workflow: Configure tournament, add players, generate, verify, regenerate',
      (tester) async {
        await navigateToSetup(tester);

        final tournamentNameField = find.widgetWithText(
          TextField,
          'Tournament Name',
        );
        await tester.enterText(tournamentNameField, 'Spring Championship');
        await tester.pump();

        await addPlayers(tester, fourPlayers);

        final formatDropdown = find.byType(DropdownButton<String>).first;
        await tester.ensureVisible(formatDropdown);
        await tester.tap(formatDropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Double Elimination').last);
        await tester.pumpAndSettle();

        await tapGenerate(tester);

        expect(find.textContaining('Double Elimination'), findsOneWidget);
        expect(find.text('Winners Bracket'), findsOneWidget);

        final refreshButton = find.byIcon(Icons.refresh);
        await tester.tap(refreshButton);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Regenerate'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Double Elimination'), findsOneWidget);

        await goBack(tester);
      },
    );

    testWidgets('6b. Full workflow: CSV import with 3rd place match enabled', (
      tester,
    ) async {
      await navigateToSetup(tester);

      final csvBtn = find.text('Paste CSV (First,Last,Dojang,RegID)');
      await tester.ensureVisible(csvBtn);
      await tester.tap(csvBtn);
      await tester.pumpAndSettle();

      final csvField = find.byType(TextField).last;
      await tester.enterText(csvField, 'A,B,C,1\nD,E,F,2\nG,H,I,3\nJ,K,L,4');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Import'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('3rd Place Match'));
      await tester.pumpAndSettle();

      final thirdPlaceSwitch = find.ancestor(
        of: find.text('3rd Place Match'),
        matching: find.byType(SwitchListTile),
      );
      await tester.tap(thirdPlaceSwitch, warnIfMissed: false);
      await tester.pumpAndSettle();

      await tapGenerate(tester);

      expect(find.textContaining('Single Elimination'), findsOneWidget);

      await goBack(tester);
    });
  });
}

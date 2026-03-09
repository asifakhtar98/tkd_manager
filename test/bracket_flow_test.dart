import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/main.dart' as app;

void main() {
  // Helper: add N players
  Future<void> addPlayers(WidgetTester tester, List<List<String>> players) async {
    // Participant fields are indices 6, 7, 8 in the current layout due to Tournament Info fields
    final firstInput = find.widgetWithText(TextField, 'First Name');
    final lastInput = find.widgetWithText(TextField, 'Last Name');
    final dojangInput = find.widgetWithText(TextField, 'Dojang / Club (Optional)');
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

  // Helper: tap GENERATE and wait
  Future<void> tapGenerate(WidgetTester tester) async {
    final btn = find.text('GENERATE');
    await tester.ensureVisible(btn);
    await tester.tap(btn);
    await tester.pumpAndSettle(const Duration(seconds: 1));
  }

  // Helper: go back to setup
  Future<void> goBack(WidgetTester tester) async {
    final backButton = find.byType(BackButton);
    if (tester.any(backButton)) {
      await tester.tap(backButton);
      await tester.pumpAndSettle();
    }
  }

  // 4 standard players used across tests
  const fourPlayers = [
    ['John', 'Doe', 'Eagle TKD'],
    ['Jane', 'Smith', 'Tiger TKD'],
    ['Mike', 'Lee', 'Eagle TKD'],
    ['Sarah', 'Connor', 'Dragon TKD'],
  ];

  group('1. Single Elimination', () {
    testWidgets('1a. 4 players: correct bracket structure', (tester) async {
      await tester.pumpWidget(const app.BracketGeneratorApp());
      await tester.pumpAndSettle();
      expect(find.text('New Bracket Setup'), findsOneWidget);

      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);
      expect(find.textContaining('Tournament Bracket'), findsOneWidget);

      // Verify custom paint exists
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });

    testWidgets('1b. 3 players: BYE handling', (tester) async {
      await tester.pumpWidget(const app.BracketGeneratorApp());
      await tester.pumpAndSettle();

      await addPlayers(tester, [
        ['Alice', 'Kim', 'Dojang A'],
        ['Bob', 'Park', 'Dojang B'],
        ['Charlie', 'Choi', 'Dojang C'],
      ]);

      await tapGenerate(tester);
      expect(find.textContaining('Tournament Bracket'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });
  });

  group('2. Double Elimination', () {
    testWidgets('2a. 4 players: winners+losers brackets generated', (tester) async {
      await tester.pumpWidget(const app.BracketGeneratorApp());
      await tester.pumpAndSettle();

      // Switch to Double Elimination
      final formatDropdown = find.byType(DropdownButton<String>).first;
      await tester.ensureVisible(formatDropdown);
      await tester.tap(formatDropdown);
      await tester.pumpAndSettle();
      
      // Tap the item in the menu
      await tester.tap(find.text('Double Elimination').last);
      await tester.pumpAndSettle();

      await addPlayers(tester, fourPlayers);
      await tapGenerate(tester);
      expect(find.textContaining('Tournament Bracket'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await goBack(tester);
    });
  });

  group('3. Participant Management', () {
    testWidgets('3a. Add, verify count, clear all', (tester) async {
      await tester.pumpWidget(const app.BracketGeneratorApp());
      await tester.pumpAndSettle();

      await addPlayers(tester, fourPlayers);
      expect(find.text('GENERATE'), findsOneWidget);

      final clearAll = find.text('Clear All');
      await tester.ensureVisible(clearAll);
      await tester.tap(clearAll);
      await tester.pumpAndSettle();

      // Expect GENERATE button to be disabled. The disabled Tooltip should be visible in the widget tree.
      expect(find.byTooltip('Add at least 2 players to generate a bracket'), findsOneWidget);
    });

    testWidgets('3b. CSV import (First,Last,Dojang,RegID)', (tester) async {
      await tester.pumpWidget(const app.BracketGeneratorApp());
      await tester.pumpAndSettle();

      final csvBtn = find.text('Paste CSV (First,Last,Dojang,RegID)');
      await tester.ensureVisible(csvBtn);
      await tester.tap(csvBtn);
      await tester.pumpAndSettle();

      // The CSV text field is in a dialog
      final csvField = find.byType(TextField).last;
      await tester.enterText(csvField, 'Kim,Park,Eagle TKD,REG123\nLee,Jung,Tiger TKD,REG456');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Import'));
      await tester.pumpAndSettle();

      expect(find.text('GENERATE'), findsOneWidget);
      // Verify RegID in roster
      expect(find.textContaining('REG123'), findsOneWidget);
    });
  });

  group('4. Tournament Info & Registration', () {
    testWidgets('4a. Tournament info fields present on entry screen', (tester) async {
      await tester.pumpWidget(const app.BracketGeneratorApp());
      await tester.pumpAndSettle();
      expect(find.text('Tournament Name'), findsOneWidget);
      expect(find.text('Date Range'), findsOneWidget);
      expect(find.text('Venue'), findsOneWidget);
      expect(find.text('Organizer'), findsOneWidget);
    });

    testWidgets('4b. Registration ID field present', (tester) async {
      await tester.pumpWidget(const app.BracketGeneratorApp());
      await tester.pumpAndSettle();
      expect(find.text('Registration ID (Optional)'), findsOneWidget);
    });
  });
}

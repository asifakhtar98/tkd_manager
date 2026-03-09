import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/main.dart' as app;

void main() {
  // Helper: add N players
  Future<void> addPlayers(WidgetTester tester, List<List<String>> players) async {
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

  testWidgets('Participant entry screen empty golden', (tester) async {
    // Set a large window size to cover the UI
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const app.BracketGeneratorApp());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(app.BracketGeneratorApp),
      matchesGoldenFile('participant_entry_screen_empty.png'),
    );

    // Reset size
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('Participant entry screen with players golden', (tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const app.BracketGeneratorApp());
    await tester.pumpAndSettle();

    await addPlayers(tester, [
      ['John', 'Doe', 'Eagle TKD'],
      ['Jane', 'Smith', 'Tiger TKD'],
      ['Mike', 'Lee', 'Eagle TKD'],
      ['Sarah', 'Connor', 'Dragon TKD'],
    ]);

    await expectLater(
      find.byType(app.BracketGeneratorApp),
      matchesGoldenFile('participant_entry_screen_with_players.png'),
    );

    // Tap generate
    await tester.tap(find.text('GENERATE'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(app.BracketGeneratorApp),
      matchesGoldenFile('bracket_viewer_screen.png'),
    );

    // Tap Regenerate
    await tester.tap(find.byTooltip('Regenerate'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(app.BracketGeneratorApp),
      matchesGoldenFile('bracket_regenerate_dialog.png'),
    );

    // Cancel out
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    addTearDown(tester.view.resetPhysicalSize);
  });
}

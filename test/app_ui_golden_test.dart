import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/main.dart' as app;

void main() {
  Future<void> navigateToSetup(WidgetTester tester) async {
    await tester.pumpWidget(const app.BracketGeneratorApp());
    await tester.pumpAndSettle();
    final startBtn = find.text('Start New Tournament');
    await tester.ensureVisible(startBtn);
    await tester.tap(startBtn);
    await tester.pumpAndSettle();
  }

  Future<void> addPlayers(WidgetTester tester, List<List<String>> players) async {
    final firstInput = find.widgetWithText(TextField, 'First Name');
    final lastInput = find.widgetWithText(TextField, 'Last Name');
    final addButton = find.text('Add Participant');

    for (final p in players) {
      await tester.enterText(firstInput, p[0]);
      await tester.enterText(lastInput, p[1]);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
    }
  }

  testWidgets('Participant entry screen empty golden', (tester) async {
    await navigateToSetup(tester);
    await expectLater(
      find.byType(app.BracketGeneratorApp),
      matchesGoldenFile('participant_entry_screen_empty.png'),
    );
  });

  testWidgets('Participant entry screen with players golden', (tester) async {
    await navigateToSetup(tester);
    await addPlayers(tester, [
      ['John', 'Doe', 'Eagle TKD'],
      ['Jane', 'Smith', 'Tiger TKD'],
    ]);

    await expectLater(
      find.byType(app.BracketGeneratorApp),
      matchesGoldenFile('participant_entry_screen_with_players.png'),
    );
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tkd_saas/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> addPlayers(
    WidgetTester tester,
    List<List<String>> players,
  ) async {
    for (final p in players) {
      final firstNameField = find.widgetWithText(TextField, 'First Name');
      final lastNameField = find.widgetWithText(TextField, 'Last Name');
      final dojangField = find.widgetWithText(
        TextField,
        'Dojang / Club (Optional)',
      );

      await tester.ensureVisible(firstNameField);
      await tester.enterText(firstNameField, p[0]);
      await tester.enterText(lastNameField, p[1]);
      if (p.length > 2 && p[2].isNotEmpty) {
        await tester.enterText(dojangField, p[2]);
      }
      if (p.length > 3 && p[3].isNotEmpty) {
        final regIdField = find.widgetWithText(
          TextField,
          'Registration ID (Optional)',
        );
        await tester.enterText(regIdField, p[3]);
      }

      final addButton = find.text('Add Participant');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
    }
  }

  Future<void> tapGenerate(WidgetTester tester) async {
    final btn = find.textContaining('GENERATE');
    await tester.ensureVisible(btn);
    await tester.tap(btn);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  testWidgets('Render 14-player bracket and hold for screenshot', (
    tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    // Wait for the home screen to appear
    final startBtn = find.text('Start New Tournament');
    await tester.ensureVisible(startBtn);
    await tester.tap(startBtn);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Tournament Name'),
      '2ND FEDERATION CUP - 2026 (Kyorugi & Poomsae)',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Date Range'),
      '18 Jan. to 22 Jan, 2026',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Venue'),
      'SMS Indoor Stadium, Jaipur, Rajasthan',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Organizer'),
      'INDIA TAEKWONDO',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Category (e.g., JUNIOR)'),
      'JUNIOR',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Division (e.g., BOYS)'),
      'BOYS',
    );
    await tester.pumpAndSettle();

    await addPlayers(tester, [
      ['Saiansh', 'Mathur', 'Delhi', 'DL012025-22514'],
      ['R.S.', 'Vignesh', 'Tamil Nadu', 'TN012024-14083'],
      ['Shashi', 'Kumar', 'Haryana', 'HR172026-26123'],
      ['J.', 'Vino', 'Tamil Nadu', 'TN222026-26267'],
      ['Aarush', 'Barua', 'Chandigarh', 'CH012026-26255'],
      ['Asad', 'Khan', 'UP', 'UP322025-20125'],
      ['Arsalan Siraj', 'Khan', 'Maharashtra', 'MH032025-25234'],
      ['Ayush', 'Kumar', 'UP', 'UP53202525572'],
      ['Lakshay', 'Goyar', 'Rajasthan', 'RJ162026-25767'],
      ['Akash', 'Kumar', 'UP', 'UP322024-16826'],
      ['Gedajit', 'Irengbam', 'Manipur', 'MN042023-5340'],
      ['Pranjit', 'Sakia', 'Assam', 'AS132023-6969'],
      ['Rajat', 'Solanki', 'Rajasthan', 'RJ062022-4069'],
      ['Jay Dinesh', 'Salaskar', 'Maharashtra', 'MH332025-25272'],
    ]);

    await tapGenerate(tester);
    expect(find.textContaining('Single Elimination'), findsOneWidget);
    expect(find.textContaining('14 Players'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Hold for 15 seconds to allow xcrun simctl screenshot
    await tester.pump(const Duration(seconds: 15));
  });
}

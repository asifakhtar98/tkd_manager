import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/main.dart' as app;

void main() {
  testWidgets('Dashboard screen golden', (tester) async {
    // Set a landscape tablet size
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const app.BracketGeneratorApp());
    await tester.pumpAndSettle();

    // Verify Dashboard is shown initially
    expect(find.text('TKD Brackets'), findsOneWidget);
    expect(find.text('Start New Tournament'), findsOneWidget);
    expect(find.text('Explore Demo Brackets'), findsOneWidget);

    await expectLater(
      find.byType(app.BracketGeneratorApp),
      matchesGoldenFile('dashboard_screen_golden.png'),
    );

    // Reset size
    addTearDown(tester.view.resetPhysicalSize);
  });
}

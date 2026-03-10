import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/main.dart' as app;

void main() {
  setUp(configureDependencies);
  tearDown(getIt.reset);

  testWidgets('Dashboard screen golden', (tester) async {
    // Set a landscape tablet size
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const app.TkdTournamentApp());
    await tester.pumpAndSettle();

    // Verify Dashboard is shown with updated UI
    expect(find.text('TKD Tournament Manager'), findsOneWidget);
    expect(find.text('New Bracket'), findsOneWidget);
    expect(find.text('Demo Brackets'), findsOneWidget);

    await expectLater(
      find.byType(app.TkdTournamentApp),
      matchesGoldenFile('dashboard_screen_golden.png'),
    );

    // Reset size
    addTearDown(tester.view.resetPhysicalSize);
  });
}

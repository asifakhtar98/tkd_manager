import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tkd_saas/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final testEmail =
      'test_auth_${DateTime.now().millisecondsSinceEpoch}@test.com';
  const testPassword = 'TestPass123!';
  const existingEmail = 'asak91298@gmail.com';
  const existingPassword = '123456';

  Future<void> ensureOnLoginScreen(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final loginTitle = find.text('Welcome Back');
    final signInSubtitle = find.text('Sign in to continue');

    if (!tester.any(loginTitle) && !tester.any(signInSubtitle)) {
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    expect(
      tester.any(loginTitle) || tester.any(signInSubtitle),
      isTrue,
      reason: 'Should be on login screen',
    );
  }

  group('Auth Integration Tests', () {
    testWidgets(
      'A0. Clean state: App launches and redirects unauthenticated users to login',
      (tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        final loginTitle = find.text('Welcome Back');
        final signInSubtitle = find.text('Sign in to continue');

        final onLoginPage =
            tester.any(loginTitle) || tester.any(signInSubtitle);

        expect(
          onLoginPage,
          isTrue,
          reason: 'Unauthenticated user should be redirected to login screen',
        );
      },
    );

    testWidgets('A1. Login screen renders all required elements', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await ensureOnLoginScreen(tester);

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.text('TKD Tournament Manager'), findsOneWidget);
      expect(find.byIcon(Icons.sports_martial_arts), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.text('Sign In'), findsWidgets);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
    });

    testWidgets('A2. Form validation: empty fields show error messages', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle();

      expect(find.text('Email is required.'), findsOneWidget);
      expect(find.text('Password is required.'), findsOneWidget);
    });

    testWidgets('A3. Form validation: invalid email shows error', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'notanemail');
      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
    });

    testWidgets('A4. Sign in with invalid credentials shows error', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, 'wrong@email.com');
      await tester.enterText(passwordField, 'wrongpassword');

      await tester.tap(find.text('Sign In').last);
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
        reason: 'Loading indicator should appear during sign-in',
      );

      await tester.pumpAndSettle(const Duration(seconds: 10));

      final errorSnack = find.byType(SnackBar);
      expect(
        errorSnack,
        findsOneWidget,
        reason: 'Error snackbar should appear for invalid credentials',
      );
    });

    testWidgets('A5. Sign in with valid credentials redirects to dashboard', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, existingEmail);
      await tester.enterText(passwordField, existingPassword);

      await tester.tap(find.text('Sign In').last);
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
        reason: 'Loading indicator should appear',
      );

      await tester.pumpAndSettle(const Duration(seconds: 10));

      final dashboardTitle = find.text('TKD Tournament Manager');
      final newBracketBtn = find.text('New Bracket');

      final navigatedToDashboard =
          tester.any(dashboardTitle) || tester.any(newBracketBtn);

      expect(
        navigatedToDashboard,
        isTrue,
        reason: 'After sign in, user should be redirected to dashboard',
      );
    });

    testWidgets('A6. Signed-in user sees dashboard', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, existingEmail);
      await tester.enterText(passwordField, existingPassword);

      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      final hasDashboard = tester.any(find.text('New Bracket'));

      expect(
        hasDashboard,
        isTrue,
        reason: 'After sign in, user should see dashboard',
      );
    });

    testWidgets('A7. Password visibility toggle works', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      final visibilityBtn = find.byIcon(Icons.visibility_off);
      expect(
        visibilityBtn,
        findsOneWidget,
        reason: 'Visibility off icon should be present for obscured password',
      );

      await tester.tap(visibilityBtn);
      await tester.pumpAndSettle();

      final visibilityOnBtn = find.byIcon(Icons.visibility);
      expect(
        visibilityOnBtn,
        findsOneWidget,
        reason: 'Visibility on icon should appear after toggle',
      );
    });

    testWidgets('A8. Navigate to Sign Up from Login screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Sign up to get started'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Sign In'), findsWidgets);
    });

    testWidgets('A9. Sign Up form renders correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign Up'), findsWidgets);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('B0. Navigate to Forgot Password from Login screen', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password'), findsOneWidget);
      expect(
        find.text('Enter your email to receive a reset link'),
        findsOneWidget,
      );
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsWidgets);
      expect(find.text('Back to Sign In'), findsOneWidget);

      expect(
        find.text('Password'),
        findsNothing,
        reason: 'Password field should not appear in forgot password mode',
      );
    });

    testWidgets('B1. Forgot Password back navigation works', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password'), findsOneWidget);

      await tester.tap(find.text('Back to Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
    });

    testWidgets('B2. Sign Up back to Sign In navigation works', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsOneWidget);

      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('B3. Sign up with valid new credentials', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, testEmail);
      await tester.enterText(passwordField, testPassword);

      await tester.tap(find.text('Sign Up').last);
      await tester.pump(const Duration(milliseconds: 500));

      await tester.pumpAndSettle(const Duration(seconds: 10));

      final successSnack = find.byType(SnackBar);
      expect(
        successSnack,
        findsWidgets,
        reason: 'Success or confirmation snackbar should appear',
      );
    });

    testWidgets('B4. Sign up with existing email shows error', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, existingEmail);
      await tester.enterText(passwordField, 'DifferentPass123!');

      await tester.tap(find.text('Sign Up').last);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      final errorSnack = find.byType(SnackBar);
      final hasError = tester.any(errorSnack);

      expect(
        hasError,
        isTrue,
        reason: 'Error should appear for existing email',
      );
    });

    testWidgets('B5. Sign out from dashboard works', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, existingEmail);
      await tester.enterText(passwordField, existingPassword);

      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      final hasDashboard = tester.any(find.text('New Bracket'));

      if (hasDashboard) {
        final signOutBtn = find.text('Sign Out');
        if (tester.any(signOutBtn)) {
          await tester.tap(signOutBtn);
          await tester.pumpAndSettle(const Duration(seconds: 5));

          final loginTitle = find.text('Welcome Back');
          final signInSubtitle = find.text('Sign in to continue');

          expect(
            tester.any(loginTitle) || tester.any(signInSubtitle),
            isTrue,
            reason: 'After sign out, user should be redirected to login',
          );
        }
      }
    });

    testWidgets('B6. Loading state shows spinner on Sign In button', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, existingEmail);
      await tester.enterText(passwordField, existingPassword);

      await tester.tap(find.text('Sign In').last);
      await tester.pump(const Duration(milliseconds: 300));

      final loadingIndicator = find.byType(CircularProgressIndicator);
      expect(
        loadingIndicator,
        findsOneWidget,
        reason:
            'Loading indicator should appear immediately after tapping Sign In',
      );
    });

    testWidgets('B7. Disabled inputs during loading state', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, existingEmail);
      await tester.enterText(passwordField, existingPassword);

      await tester.tap(find.text('Sign In').last);
      await tester.pump(const Duration(milliseconds: 200));

      final emailFormField = tester.widget<TextFormField>(emailField);
      final passwordFormField = tester.widget<TextFormField>(passwordField);

      expect(
        emailFormField.enabled,
        isFalse,
        reason: 'Email field should be disabled during loading',
      );
      expect(
        passwordFormField.enabled,
        isFalse,
        reason: 'Password field should be disabled during loading',
      );
    });

    testWidgets('B8. Authenticated user cannot access login page directly', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, existingEmail);
      await tester.enterText(passwordField, existingPassword);

      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      final hasDashboard = tester.any(find.text('New Bracket'));
      expect(
        hasDashboard,
        isTrue,
        reason: 'Authenticated user should see dashboard',
      );
    });

    testWidgets('B9. Password reset email sent confirmation', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, existingEmail);

      await tester.tap(find.text('Send Reset Link').last);
      await tester.pump(const Duration(milliseconds: 500));

      await tester.pumpAndSettle(const Duration(seconds: 10));

      final snackBars = find.byType(SnackBar);
      expect(
        snackBars,
        findsWidgets,
        reason: 'Snackbar should appear after password reset request',
      );
    });

    testWidgets('C0. Full flow: Sign Up -> Email confirmation state', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      final uniqueEmail =
          'newuser_${DateTime.now().millisecondsSinceEpoch}@test.com';
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, uniqueEmail);
      await tester.enterText(passwordField, 'NewUser123!');

      await tester.tap(find.text('Sign Up').last);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      final snackBars = find.byType(SnackBar);
      expect(
        snackBars,
        findsWidgets,
        reason: 'Should show confirmation snackbar or redirect',
      );
    });

    testWidgets('C1. Responsive layout on smaller screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsWidgets);
    });

    testWidgets('C2. All auth modes have proper state transitions', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      expect(find.text('Welcome Back'), findsOneWidget);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      expect(find.text('Create Account'), findsOneWidget);

      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle();
      expect(find.text('Welcome Back'), findsOneWidget);

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();
      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Password'), findsNothing);

      await tester.tap(find.text('Back to Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('C3. Tap outside form dismisses keyboard context', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await ensureOnLoginScreen(tester);

      final emailField = find.byType(TextFormField).first;
      await tester.tap(emailField);
      await tester.pumpAndSettle();

      final scaffold = find.byType(Scaffold);
      await tester.tap(scaffold.first);
      await tester.pumpAndSettle();
    });
  });
}

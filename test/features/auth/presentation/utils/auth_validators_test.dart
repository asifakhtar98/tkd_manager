import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/auth/presentation/utils/auth_validators.dart';

void main() {
  group('AuthValidators', () {
    // ─────────────────────────────────────────────────────────────────────────
    // validateEmail
    // ─────────────────────────────────────────────────────────────────────────

    group('validateEmail', () {
      test('returns error for null', () {
        expect(AuthValidators.validateEmail(null), isNotNull);
      });

      test('returns error for empty string', () {
        expect(AuthValidators.validateEmail(''), isNotNull);
      });

      test('returns error for whitespace-only string', () {
        expect(AuthValidators.validateEmail('   '), isNotNull);
      });

      test('returns error for missing @', () {
        expect(AuthValidators.validateEmail('foobar.com'), isNotNull);
      });

      test('returns error for missing domain', () {
        expect(AuthValidators.validateEmail('foo@'), isNotNull);
      });

      test('returns error for missing TLD dot', () {
        expect(AuthValidators.validateEmail('foo@bar'), isNotNull);
      });

      test('returns null for valid email', () {
        expect(AuthValidators.validateEmail('user@example.com'), isNull);
      });

      test('returns null for valid email with leading/trailing spaces', () {
        expect(AuthValidators.validateEmail('  user@example.com  '), isNull);
      });
    });

    // ─────────────────────────────────────────────────────────────────────────
    // validatePassword
    // ─────────────────────────────────────────────────────────────────────────

    group('validatePassword', () {
      test('returns error for null', () {
        expect(AuthValidators.validatePassword(null), isNotNull);
      });

      test('returns error for empty string', () {
        expect(AuthValidators.validatePassword(''), isNotNull);
      });

      test('returns error for fewer than 6 characters', () {
        expect(AuthValidators.validatePassword('12345'), isNotNull);
      });

      test('returns null for exactly 6 characters', () {
        expect(AuthValidators.validatePassword('123456'), isNull);
      });

      test('returns null for more than 6 characters', () {
        expect(AuthValidators.validatePassword('abcdefgh'), isNull);
      });
    });

    // ─────────────────────────────────────────────────────────────────────────
    // validateConfirmPassword
    // ─────────────────────────────────────────────────────────────────────────

    group('validateConfirmPassword', () {
      test('returns error for null confirmation', () {
        final TextEditingController controller = TextEditingController(
          text: 'abc',
        );
        final validator = AuthValidators.validateConfirmPassword(controller);
        expect(validator(null), isNotNull);
        controller.dispose();
      });

      test('returns error for empty confirmation', () {
        final TextEditingController controller = TextEditingController(
          text: 'abc',
        );
        final validator = AuthValidators.validateConfirmPassword(controller);
        expect(validator(''), isNotNull);
        controller.dispose();
      });

      test('returns error when passwords do not match', () {
        final TextEditingController controller = TextEditingController(
          text: 'abc123',
        );
        final validator = AuthValidators.validateConfirmPassword(controller);
        expect(validator('xyz789'), isNotNull);
        controller.dispose();
      });

      test('returns null when passwords match', () {
        final TextEditingController controller = TextEditingController(
          text: 'abc123',
        );
        final validator = AuthValidators.validateConfirmPassword(controller);
        expect(validator('abc123'), isNull);
        controller.dispose();
      });

      test('reads live controller text at validation time, '
          'not stale text from closure creation time', () {
        final TextEditingController controller = TextEditingController(
          text: 'initial',
        );

        // Create the validator when text is "initial".
        final validator = AuthValidators.validateConfirmPassword(controller);

        // Change the controller text AFTER the validator closure was created.
        controller.text = 'changed';

        // The validator must compare against "changed" (live), not "initial".
        expect(validator('changed'), isNull);
        expect(validator('initial'), isNotNull);

        controller.dispose();
      });
    });
  });
}

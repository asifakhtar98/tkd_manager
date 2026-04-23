import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/core/config/app_config.dart';

void main() {
  group('AppConfig — Deep Link Constants', () {
    test('deepLinkScheme is a valid custom scheme', () {
      expect(AppConfig.deepLinkScheme, isNotEmpty);
      expect(AppConfig.deepLinkScheme, isNot(contains('://')));
      expect(AppConfig.deepLinkScheme, isNot(contains(' ')));
    });

    test('emailConfirmedPath starts with forward slash', () {
      expect(AppConfig.emailConfirmedPath, startsWith('/'));
    });

    test('passwordResetPath starts with forward slash', () {
      expect(AppConfig.passwordResetPath, startsWith('/'));
    });

    test('mobileEmailConfirmationRedirectUrl is correctly composed', () {
      expect(
        AppConfig.mobileEmailConfirmationRedirectUrl,
        equals(
          '${AppConfig.deepLinkScheme}://${AppConfig.emailConfirmedPath}',
        ),
      );
    });

    test('mobilePasswordResetRedirectUrl is correctly composed', () {
      expect(
        AppConfig.mobilePasswordResetRedirectUrl,
        equals(
          '${AppConfig.deepLinkScheme}://${AppConfig.passwordResetPath}',
        ),
      );
    });

    test('mobileEmailConfirmationRedirectUrl is parseable as URI', () {
      final Uri uri = Uri.parse(AppConfig.mobileEmailConfirmationRedirectUrl);
      expect(uri.scheme, equals(AppConfig.deepLinkScheme));
    });

    test('mobilePasswordResetRedirectUrl is parseable as URI', () {
      final Uri uri = Uri.parse(AppConfig.mobilePasswordResetRedirectUrl);
      expect(uri.scheme, equals(AppConfig.deepLinkScheme));
    });

    test('appStoreUrl is a valid HTTPS URL', () {
      final Uri uri = Uri.parse(AppConfig.appStoreUrl);
      expect(uri.scheme, equals('https'));
      expect(uri.host, contains('apple.com'));
    });

    test('playStoreUrl is a valid HTTPS URL', () {
      final Uri uri = Uri.parse(AppConfig.playStoreUrl);
      expect(uri.scheme, equals('https'));
      expect(uri.host, contains('google.com'));
    });
  });

  group('AppConfig — deep link paths match RoutePaths', () {
    test('emailConfirmedPath is /email-confirmed', () {
      expect(AppConfig.emailConfirmedPath, equals('/email-confirmed'));
    });

    test('passwordResetPath is /reset-password', () {
      expect(AppConfig.passwordResetPath, equals('/reset-password'));
    });
  });
}

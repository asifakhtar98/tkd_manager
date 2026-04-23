import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/core/router/app_routes.dart';

void main() {
  group('RoutePaths — /app download route', () {
    test('appDownload path is /app', () {
      expect(RoutePaths.appDownload, equals('/app'));
    });

    test('appDownload path is distinct from other paths', () {
      final Set<String> allPaths = {
        RoutePaths.dashboard,
        RoutePaths.login,
        RoutePaths.resetPassword,
        RoutePaths.emailConfirmed,
        RoutePaths.appDownload,
      };
      expect(allPaths.length, equals(5));
    });

    test('appDownload path starts with /', () {
      expect(RoutePaths.appDownload, startsWith('/'));
    });
  });
}

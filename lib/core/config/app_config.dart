import 'package:flutter/foundation.dart';

/// Application-wide feature flags and configuration constants.
///
/// These are compile-time constants so tree-shaking removes dead code paths
/// in release builds.
abstract final class AppConfig {
  /// Master kill switch for the authentication module.
  ///
  /// When set to `false`:
  /// - Supabase is **not** initialised (no network calls, no auth sessions).
  /// - The [AuthenticationBloc] provider is omitted from the widget tree.
  /// - All GoRouter redirect guards are bypassed — every route resolves
  ///   directly without login.
  /// - The sign-out button is hidden from the dashboard AppBar.
  ///
  /// Flip to `true` to restore the full Supabase-backed auth flow.
  static const bool isAuthenticationEnabled = true;

  /// Enables special advanced features across the application.
  static const bool isSpecialPowerEnabled = kDebugMode;

  /// Background image URL for auth screens.
  static const String authBackgroundImage =
      'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/tkd-bg-4234.jpg';

  // ─────────────────────────────────────────────────────────────────────────
  // Deep Link Configuration
  // ─────────────────────────────────────────────────────────────────────────

  /// Custom URL scheme registered in iOS `Info.plist` and Android
  /// `AndroidManifest.xml`. Must match both native configurations exactly.
  static const String deepLinkScheme = 'com.gamecon.app';

  /// Path segment for email-confirmation deep links.
  static const String emailConfirmedPath = '/email-confirmed';

  /// Path segment for password-reset deep links.
  static const String passwordResetPath = '/reset-password';

  /// Full redirect URL for **mobile** email-confirmation links.
  /// Example: `com.gamecon.app://email-confirmed`
  static const String mobileEmailConfirmationRedirectUrl =
      '$deepLinkScheme://$emailConfirmedPath';

  /// Full redirect URL for **mobile** password-reset links.
  /// Example: `com.gamecon.app://reset-password`
  static const String mobilePasswordResetRedirectUrl =
      '$deepLinkScheme://$passwordResetPath';

  // ─────────────────────────────────────────────────────────────────────────
  // App Store URLs
  // ─────────────────────────────────────────────────────────────────────────

  /// Apple App Store listing URL (update after publishing).
  static const String appStoreUrl =
      'https://apps.apple.com/app/gamecon/idXXXXXXXXXX';

  /// Google Play Store listing URL (update after publishing).
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.gamecon.app';
}

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
}

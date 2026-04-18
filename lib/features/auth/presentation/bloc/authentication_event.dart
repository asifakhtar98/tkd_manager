import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authentication_event.freezed.dart';

/// Events consumed by [AuthenticationBloc].
@freezed
sealed class AuthenticationEvent with _$AuthenticationEvent {
  /// Start listening to the Supabase [onAuthStateChange] stream.
  ///
  /// Dispatched once at app startup from [main.dart].
  const factory AuthenticationEvent.subscriptionRequested() =
      AuthenticationSubscriptionRequested;

  /// User tapped the **Sign In** button with valid credentials.
  const factory AuthenticationEvent.signInRequested({
    required String email,
    required String password,
  }) = AuthenticationSignInRequested;

  /// User tapped the **Sign Up** button with valid credentials.
  const factory AuthenticationEvent.signUpRequested({
    required String email,
    required String password,
    required String organizationName,
  }) = AuthenticationSignUpRequested;

  /// User requested to sign out (e.g. from an AppBar action).
  const factory AuthenticationEvent.signOutRequested() =
      AuthenticationSignOutRequested;

  /// User tapped "Forgot Password?" and submitted their email address.
  const factory AuthenticationEvent.passwordResetRequested({
    required String email,
  }) = AuthenticationPasswordResetRequested;

  /// User submitted a new password on the password-reset screen
  /// (after clicking the recovery link in their email).
  const factory AuthenticationEvent.passwordUpdateRequested({
    required String newPassword,
  }) = AuthenticationPasswordUpdateRequested;

  /// Internal event fired by the [authStateChanges] stream listener.
  ///
  /// A `null` [user] means the session was destroyed (sign-out / deletion).
  @internal
  const factory AuthenticationEvent.statusChanged({required User? user}) =
      AuthenticationStatusChanged;

  /// Internal event fired when the auth stream reports a password recovery
  /// token (user clicked the recovery link in their email).
  @internal
  const factory AuthenticationEvent.passwordRecoveryDetected() =
      AuthenticationPasswordRecoveryDetected;

  /// Internal event fired when the auth stream detects a `signedIn` event
  /// that originated from an email confirmation PKCE redirect (the browser
  /// URL contains a `?code=` query parameter).
  @internal
  const factory AuthenticationEvent.emailConfirmationDetected({
    @Default(true) bool performSignOut,
  }) = AuthenticationEmailConfirmationDetected;

  /// User tapped "Continue to Sign In" on the [EmailConfirmedScreen].
  ///
  /// Deterministically transitions the BLoC from [emailJustConfirmed] to
  /// [unauthenticated] so the router guard can redirect to `/login`.
  const factory AuthenticationEvent.emailConfirmationAcknowledged() =
      AuthenticationEmailConfirmationAcknowledged;
}

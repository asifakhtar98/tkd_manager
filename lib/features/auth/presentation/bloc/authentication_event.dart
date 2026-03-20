part of 'authentication_bloc.dart';

/// Events consumed by [AuthenticationBloc].
///
/// All events with data fields extend [Equatable] for proper deduplication
/// and simplified test assertions.
sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => const [];
}

/// Start listening to the Supabase [onAuthStateChange] stream.
///
/// Dispatched once at app startup from [main.dart].
final class AuthenticationSubscriptionRequested extends AuthenticationEvent {
  const AuthenticationSubscriptionRequested();
}

/// User tapped the **Sign In** button with valid credentials.
final class AuthenticationSignInRequested extends AuthenticationEvent {
  const AuthenticationSignInRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// User tapped the **Sign Up** button with valid credentials.
final class AuthenticationSignUpRequested extends AuthenticationEvent {
  const AuthenticationSignUpRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// User requested to sign out (e.g. from an AppBar action).
final class AuthenticationSignOutRequested extends AuthenticationEvent {
  const AuthenticationSignOutRequested();
}

/// User tapped "Forgot Password?" and submitted their email address.
final class AuthenticationPasswordResetRequested extends AuthenticationEvent {
  const AuthenticationPasswordResetRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

/// User submitted a new password on the password-reset screen
/// (after clicking the recovery link in their email).
final class AuthenticationPasswordUpdateRequested extends AuthenticationEvent {
  const AuthenticationPasswordUpdateRequested({required this.newPassword});

  final String newPassword;

  @override
  List<Object?> get props => [newPassword];
}

/// Internal event fired by the [authStateChanges] stream listener.
///
/// A `null` [user] means the session was destroyed (sign-out / deletion).
final class _AuthenticationStatusChanged extends AuthenticationEvent {
  const _AuthenticationStatusChanged({required this.user});

  final User? user;

  @override
  List<Object?> get props => [user];
}

/// Internal event fired when the auth stream reports a password recovery
/// token (user clicked the recovery link in their email).
final class _AuthenticationPasswordRecoveryDetected
    extends AuthenticationEvent {
  const _AuthenticationPasswordRecoveryDetected();
}

/// Internal event fired when the auth stream detects a `signedIn` event
/// that originated from an email confirmation PKCE redirect (the browser
/// URL contains a `?code=` query parameter).
final class _AuthenticationEmailConfirmationDetected
    extends AuthenticationEvent {
  const _AuthenticationEmailConfirmationDetected();
}

part of 'authentication_bloc.dart';

/// Events consumed by [AuthenticationBloc].
sealed class AuthenticationEvent {
  const AuthenticationEvent();
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
}

/// User tapped the **Sign Up** button with valid credentials.
final class AuthenticationSignUpRequested extends AuthenticationEvent {
  const AuthenticationSignUpRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

/// User requested to sign out (e.g. from an AppBar action).
final class AuthenticationSignOutRequested extends AuthenticationEvent {
  const AuthenticationSignOutRequested();
}

/// Internal event fired by the [authStateChanges] stream listener.
///
/// A `null` [user] means the session was destroyed (sign-out / deletion).
final class _AuthenticationStatusChanged extends AuthenticationEvent {
  const _AuthenticationStatusChanged({required this.user});

  final User? user;
}

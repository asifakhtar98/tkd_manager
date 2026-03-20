part of 'authentication_bloc.dart';

/// Possible states emitted by [AuthenticationBloc].
///
/// The [GoRouter] redirect guard pattern-matches on this sealed family
/// to decide whether to show the login screen or the main app.
sealed class AuthenticationState {
  const AuthenticationState();

  /// App has just been launched — we have not yet checked whether a
  /// persisted session exists.
  const factory AuthenticationState.unknown() = AuthenticationUnknown;

  /// A valid session exists and the [user] is authenticated.
  const factory AuthenticationState.authenticated({required User user}) =
      AuthenticationAuthenticated;

  /// No session exists; the user must log in.
  const factory AuthenticationState.unauthenticated() =
      AuthenticationUnauthenticated;

  /// A sign-in or sign-up request is currently in flight.
  const factory AuthenticationState.authenticationInProgress() =
      AuthenticationInProgress;

  /// The most recent sign-in or sign-up attempt failed with [message].
  const factory AuthenticationState.authenticationFailure({
    required String message,
  }) = AuthenticationFailureState;
}

final class AuthenticationUnknown extends AuthenticationState {
  const AuthenticationUnknown();
}

final class AuthenticationAuthenticated extends AuthenticationState {
  const AuthenticationAuthenticated({required this.user});

  final User user;
}

final class AuthenticationUnauthenticated extends AuthenticationState {
  const AuthenticationUnauthenticated();
}

final class AuthenticationInProgress extends AuthenticationState {
  const AuthenticationInProgress();
}

final class AuthenticationFailureState extends AuthenticationState {
  const AuthenticationFailureState({required this.message});

  final String message;
}

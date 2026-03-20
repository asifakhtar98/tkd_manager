part of 'authentication_bloc.dart';

/// Possible states emitted by [AuthenticationBloc].
///
/// The [GoRouter] redirect guard pattern-matches on this sealed family
/// to decide whether to show the login screen, main app, or password
/// reset screen.
///
/// States carrying data extend [Equatable] so BLoC deduplicates identical
/// emissions and test assertions can compare by value.
sealed class AuthenticationState extends Equatable {
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

  /// A sign-in, sign-up, or password-reset request is currently in flight.
  const factory AuthenticationState.authenticationInProgress() =
      AuthenticationInProgress;

  /// The most recent sign-in or sign-up attempt failed with [message].
  const factory AuthenticationState.authenticationFailure({
    required String message,
  }) = AuthenticationFailureState;

  /// A password reset email was sent successfully.
  const factory AuthenticationState.passwordResetEmailSent() =
      AuthenticationPasswordResetEmailSent;

  /// A signup email confirmation was sent — the user must check their
  /// email before they can sign in.
  const factory AuthenticationState.emailConfirmationSent() =
      AuthenticationEmailConfirmationSent;

  /// The user arrived via a password-recovery link — show the
  /// new-password form.
  const factory AuthenticationState.passwordRecoveryInProgress() =
      AuthenticationPasswordRecoveryInProgress;

  /// The user has just confirmed their email via a PKCE redirect.
  ///
  /// The auto-created session has been destroyed; the user should see an
  /// interstitial "Email Verified" screen before logging in manually.
  const factory AuthenticationState.emailJustConfirmed() =
      AuthenticationEmailJustConfirmed;

  @override
  List<Object?> get props => const [];
}

final class AuthenticationUnknown extends AuthenticationState {
  const AuthenticationUnknown();
}

final class AuthenticationAuthenticated extends AuthenticationState {
  const AuthenticationAuthenticated({required this.user});

  final User user;

  @override
  List<Object?> get props => [user];
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

  @override
  List<Object?> get props => [message];
}

final class AuthenticationPasswordResetEmailSent extends AuthenticationState {
  const AuthenticationPasswordResetEmailSent();
}

final class AuthenticationEmailConfirmationSent extends AuthenticationState {
  const AuthenticationEmailConfirmationSent();
}

final class AuthenticationPasswordRecoveryInProgress
    extends AuthenticationState {
  const AuthenticationPasswordRecoveryInProgress();
}

final class AuthenticationEmailJustConfirmed extends AuthenticationState {
  const AuthenticationEmailJustConfirmed();
}

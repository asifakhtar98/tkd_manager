import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authentication_state.freezed.dart';

/// Possible states emitted by [AuthenticationBloc].
///
/// The [GoRouter] redirect guard pattern-matches on this sealed family
/// to decide whether to show the login screen, main app, or password
/// reset screen.
@freezed
sealed class AuthenticationState with _$AuthenticationState {
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
}

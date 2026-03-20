import 'package:flutter/material.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';

/// Shared [BlocConsumer.listener] callback for authentication screens.
///
/// Shows a floating [SnackBar] styled for:
///   • **Failure** states (`colorScheme.error` background)
///   • **Password reset email sent** (`colorScheme.primary` + switches to
///     sign-in via optional [onPasswordResetEmailSent])
///   • **Email confirmation sent** (`colorScheme.primary` + optional callback)
///
/// Extract this into a utility so [LoginScreen] and [PasswordResetScreen]
/// don't duplicate the same listener plumbing.
void handleAuthenticationStateForSnackbar(
  BuildContext context,
  AuthenticationState state, {
  VoidCallback? onPasswordResetEmailSent,
  VoidCallback? onEmailConfirmationSent,
}) {
  if (!context.mounted) return;

  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  final ColorScheme colorScheme = Theme.of(context).colorScheme;

  switch (state) {
    case AuthenticationFailureState(:final String message):
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: colorScheme.error,
          ),
        );

    case AuthenticationPasswordResetEmailSent():
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Password reset link sent! Check your email.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: colorScheme.primary,
          ),
        );
      onPasswordResetEmailSent?.call();

    case AuthenticationEmailConfirmationSent():
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text(
              'Account created! Check your email to confirm your account.',
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 6),
            backgroundColor: colorScheme.primary,
          ),
        );
      onEmailConfirmationSent?.call();

    default:
      break;
  }
}

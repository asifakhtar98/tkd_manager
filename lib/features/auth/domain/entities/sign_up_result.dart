import 'package:supabase_flutter/supabase_flutter.dart';

/// Discriminated result from a sign-up operation.
///
/// When Supabase "Confirm email" is **disabled**, the user is immediately
/// authenticated → [SignUpAuthenticated].
///
/// When "Confirm email" is **enabled**, the account is created but no session
/// exists until the user clicks the confirmation link → [SignUpConfirmationRequired].
sealed class SignUpResult {
  const SignUpResult();
}

/// The user was signed up and a session was created immediately.
final class SignUpAuthenticated extends SignUpResult {
  const SignUpAuthenticated({required this.user});

  final User user;
}

/// The account was created but the user must confirm their email before
/// a session is established.
final class SignUpConfirmationRequired extends SignUpResult {
  const SignUpConfirmationRequired();
}

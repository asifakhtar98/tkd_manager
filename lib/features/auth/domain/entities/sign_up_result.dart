import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sign_up_result.freezed.dart';

/// Discriminated result from a sign-up operation.
///
/// When Supabase "Confirm email" is **disabled**, the user is immediately
/// authenticated → [SignUpAuthenticated].
///
/// When "Confirm email" is **enabled**, the account is created but no session
/// exists until the user clicks the confirmation link → [SignUpConfirmationRequired].
@freezed
sealed class SignUpResult with _$SignUpResult {
  /// The user was signed up and a session was created immediately.
  const factory SignUpResult.authenticated({required User user}) =
      SignUpAuthenticated;

  /// The account was created but the user must confirm their email before
  /// a session is established.
  const factory SignUpResult.confirmationRequired() =
      SignUpConfirmationRequired;
}

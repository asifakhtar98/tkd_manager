import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/features/auth/domain/entities/sign_up_result.dart';

/// Contract for all authentication operations.
///
/// The domain layer depends on this abstraction — the data layer provides the
/// concrete [SupabaseClient]-backed implementation via injectable.
abstract interface class AuthenticationRepository {
  /// Signs in an existing user with [email] and [password].
  ///
  /// Returns the authenticated [User] on success, or an
  /// [AuthenticationFailure] with a human-readable message on error.
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Registers a new user with [email] and [password].
  ///
  /// Returns a [SignUpResult] that indicates whether the user was
  /// immediately authenticated or needs to confirm their email first.
  Future<Either<Failure, SignUpResult>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sends a password reset email to the given [email] address.
  ///
  /// The email contains a link that, when clicked, redirects the user
  /// back to the app with a recovery token handled by [authStateChanges].
  Future<Either<Failure, Unit>> resetPasswordForEmail({
    required String email,
  });

  /// Updates the currently authenticated user's password.
  ///
  /// Typically called after the user clicks a recovery link and lands
  /// on the password-reset screen.
  Future<Either<Failure, Unit>> updatePassword({
    required String newPassword,
  });

  /// Signs the current user out and destroys the local session.
  Future<void> signOut();

  /// The currently authenticated [User], or `null` if no session exists.
  User? get currentUser;

  /// A broadcast stream of [AuthState] changes emitted by Supabase.
  ///
  /// Listeners receive events such as `initialSession`, `signedIn`,
  /// `signedOut`, and `tokenRefreshed`.
  Stream<AuthState> get authStateChanges;
}

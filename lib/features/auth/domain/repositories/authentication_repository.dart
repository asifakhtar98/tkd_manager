import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/error/failures.dart';

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
  /// When Supabase "Confirm email" is **disabled**, the returned [User] is
  /// immediately authenticated and a session is created.
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
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

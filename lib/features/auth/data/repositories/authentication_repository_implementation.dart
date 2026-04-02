import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/features/auth/domain/entities/sign_up_result.dart';
import 'package:tkd_saas/features/auth/domain/repositories/authentication_repository.dart';

/// Supabase-backed implementation of [AuthenticationRepository].
///
/// Every public method maps Supabase [AuthException] instances into
/// [AuthenticationFailure] so the domain / presentation layers never see
/// Supabase transport types.
@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _supabaseClient.auth
          .signInWithPassword(email: email, password: password);

      final User? user = response.user;
      if (user == null) {
        return const Left(
          AuthenticationFailure('Sign-in succeeded but no user was returned.'),
        );
      }

      return Right(user);
    } on AuthException catch (authException) {
      return Left(AuthenticationFailure(_humanReadableMessage(authException)));
    } on Exception catch (exception) {
      return Left(AuthenticationFailure(exception.toString()));
    }
  }

  @override
  Future<Either<Failure, SignUpResult>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String organizationName,
  }) async {
    try {
      final AuthResponse response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': organizationName},
        emailRedirectTo: _emailConfirmationRedirectUrl,
      );

      final User? user = response.user;
      if (user == null) {
        return const Left(
          AuthenticationFailure('Sign-up succeeded but no user was returned.'),
        );
      }

      // When "Confirm email" is enabled and the email already exists,
      // Supabase returns an obfuscated user with an empty `identities` list
      // instead of throwing an error. Detect this case explicitly.
      if (user.identities == null || user.identities!.isEmpty) {
        return const Left(
          AuthenticationFailure(
            'An account with this email already exists. Please sign in instead.',
          ),
        );
      }

      // If no session was created, email confirmation is required.
      if (response.session == null) {
        return const Right(SignUpConfirmationRequired());
      }

      return Right(SignUpAuthenticated(user: user));
    } on AuthException catch (authException) {
      return Left(AuthenticationFailure(_humanReadableMessage(authException)));
    } on Exception catch (exception) {
      return Left(AuthenticationFailure(exception.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPasswordForEmail({
    required String email,
  }) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: _webRedirectUrl,
      );
      return const Right(unit);
    } on AuthException catch (authException) {
      return Left(AuthenticationFailure(_humanReadableMessage(authException)));
    } on Exception catch (exception) {
      return Left(AuthenticationFailure(exception.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword({
    required String newPassword,
  }) async {
    try {
      if (_supabaseClient.auth.currentUser == null) {
        return const Left(
          AuthenticationFailure('Session expired. Please sign in again.'),
        );
      }
      await _supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return const Right(unit);
    } on AuthException catch (authException) {
      return Left(AuthenticationFailure(_humanReadableMessage(authException)));
    } on Exception catch (exception) {
      return Left(AuthenticationFailure(exception.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfileDetails({
    String? email,
    String? organizationName,
  }) async {
    try {
      if (_supabaseClient.auth.currentUser == null) {
        return const Left(
          AuthenticationFailure('Session expired. Please sign in again.'),
        );
      }

      final Map<String, dynamic> metadata = {};
      if (organizationName != null) {
        metadata['display_name'] = organizationName;
      }

      final UserResponse response = await _supabaseClient.auth.updateUser(
        UserAttributes(
          email: email,
          data: metadata.isNotEmpty ? metadata : null,
        ),
      );

      final User? user = response.user;
      if (user == null) {
        return const Left(
          AuthenticationFailure(
            'Failed to update profile. User object returned null.',
          ),
        );
      }
      return Right(user);
    } on AuthException catch (authException) {
      return Left(AuthenticationFailure(_humanReadableMessage(authException)));
    } on Exception catch (exception) {
      return Left(AuthenticationFailure(exception.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      debugPrint('AuthException during sign out: $e');
    } on Exception catch (e) {
      debugPrint('Exception during sign out: $e');
    }
  }

  @override
  User? get currentUser => _supabaseClient.auth.currentUser;

  @override
  Stream<AuthState> get authStateChanges =>
      _supabaseClient.auth.onAuthStateChange;

  /// On Flutter web, uses the current origin so Supabase email links redirect
  /// back to the running application. Returns `null` on non-web platforms
  /// (mobile deep links are handled differently).
  String? get _webRedirectUrl => kIsWeb ? Uri.base.origin : null;

  /// Redirect URL used exclusively for **sign-up email confirmation** links.
  ///
  /// Points to the `/email-confirmed` path so the [AuthenticationBloc] can
  /// distinguish email-confirmation redirects from password-recovery redirects
  /// by inspecting `Uri.base.path` instead of the ambiguous `?code=` param.
  String? get _emailConfirmationRedirectUrl =>
      kIsWeb ? '${Uri.base.origin}/email-confirmed' : null;

  /// Maps Supabase's technical error messages to friendlier text where
  /// possible, falling back to the raw message otherwise.
  String _humanReadableMessage(AuthException authException) {
    final String rawMessage = authException.message.toLowerCase();

    if (rawMessage.contains('invalid login credentials') ||
        rawMessage.contains('invalid_credentials')) {
      return 'Incorrect email or password. Please try again.';
    }
    if (rawMessage.contains('user already registered')) {
      return 'An account with this email already exists. Please sign in instead.';
    }
    if (rawMessage.contains('email not confirmed')) {
      return 'Please verify your email address before signing in.';
    }
    if (rawMessage.contains('too many requests') ||
        rawMessage.contains('rate limit')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    if (rawMessage.contains('password') &&
        (rawMessage.contains('too short') ||
            rawMessage.contains('too weak') ||
            rawMessage.contains('at least'))) {
      return 'Password is too weak. Please use at least 6 characters.';
    }
    if (rawMessage.contains('unable to validate email address') ||
        rawMessage.contains('invalid email')) {
      return 'Please enter a valid email address.';
    }
    if (rawMessage.contains('signups not allowed') ||
        rawMessage.contains('signup is disabled')) {
      return 'New account registration is currently disabled.';
    }

    return authException.message;
  }
}

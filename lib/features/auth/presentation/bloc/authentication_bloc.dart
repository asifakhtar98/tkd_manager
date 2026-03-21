import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/features/auth/domain/entities/sign_up_result.dart';
import 'package:tkd_saas/features/auth/domain/repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// Type alias for the email-confirmation redirect predicate.
///
/// Required because `injectable_generator` cannot resolve inline function
/// types.  Using a typedef satisfies the code-gen while keeping the
/// `@visibleForTesting` semantics.
typedef IsEmailConfirmationRedirectPredicate = bool Function();

/// Manages the global authentication lifecycle for the entire application.
///
/// A single instance lives at the root [MultiBlocProvider] (created in
/// [main.dart]) and drives the [GoRouter] redirect guard so that every
/// route is protected behind login.
@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    @factoryParam @visibleForTesting IsEmailConfirmationRedirectPredicate? isEmailConfirmationRedirect,
  }) : _authenticationRepository = authenticationRepository,
       _isEmailConfirmationRedirectOverride = isEmailConfirmationRedirect,
       super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationSignInRequested>(_onSignInRequested);
    on<AuthenticationSignUpRequested>(_onSignUpRequested);
    on<AuthenticationSignOutRequested>(_onSignOutRequested);
    on<AuthenticationPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthenticationPasswordUpdateRequested>(_onPasswordUpdateRequested);
    on<_AuthenticationStatusChanged>(_onStatusChanged);
    on<_AuthenticationPasswordRecoveryDetected>(_onPasswordRecoveryDetected);
    on<_AuthenticationEmailConfirmationDetected>(_onEmailConfirmationDetected);
  }

  final AuthenticationRepository _authenticationRepository;

  /// Optional override for testing — when non-null, this predicate is used
  /// instead of the default `Uri.base` check.
  final IsEmailConfirmationRedirectPredicate? _isEmailConfirmationRedirectOverride;

  StreamSubscription<AuthState>? _authStateSubscription;

  /// Whether the PKCE email-confirmation `?code=` in the browser URL has
  /// already been consumed. Prevents re-detection on subsequent auth events
  /// within the same app session.
  bool _emailConfirmationCodeConsumed = false;

  // ───────────────────────────────────────────────────────────────────────────
  // Subscription to Supabase auth state stream
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Cancel any previous subscription defensively.
    await _authStateSubscription?.cancel();

    _authStateSubscription = _authenticationRepository.authStateChanges.listen((
      AuthState data,
    ) {
      switch (data.event) {
        case AuthChangeEvent.initialSession:
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
          // On web, detect if this sign-in was triggered by an email
          // confirmation PKCE redirect (URL contains `?code=`). If so,
          // route to the interstitial confirmation screen instead of the
          // dashboard.
          if (_isEmailConfirmationRedirect) {
            _emailConfirmationCodeConsumed = true;
            add(const _AuthenticationEmailConfirmationDetected());
          } else {
            add(_AuthenticationStatusChanged(user: data.session?.user));
          }
        case AuthChangeEvent.signedOut:
        case AuthChangeEvent.userDeleted:
          add(const _AuthenticationStatusChanged(user: null));
        case AuthChangeEvent.passwordRecovery:
          add(const _AuthenticationPasswordRecoveryDetected());
        // Events we acknowledge but take no auth-routing action for.
        case AuthChangeEvent.userUpdated:
        case AuthChangeEvent.mfaChallengeVerified:
          break;
      }
    });
  }

  /// Returns `true` when the app was opened via a Supabase email-confirmation
  /// redirect — the browser URL path is `/email-confirmed` (set by the
  /// distinct `emailRedirectTo` used during sign-up).
  ///
  /// Password-recovery redirects land on the origin (`/`) and are NOT matched
  /// here, preventing the bug where a recovery PKCE code was incorrectly
  /// treated as an email-confirmation redirect.
  bool get _isEmailConfirmationRedirect {
    if (_emailConfirmationCodeConsumed) return false;
    if (_isEmailConfirmationRedirectOverride != null) {
      return _isEmailConfirmationRedirectOverride();
    }
    if (!kIsWeb) return false;
    return Uri.base.path == '/email-confirmed';
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Sign In
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _onSignInRequested(
    AuthenticationSignInRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.authenticationInProgress());

    final result = await _authenticationRepository.signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(
        AuthenticationState.authenticationFailure(message: failure.message),
      ),
      // Success: the auth-state stream listener will emit `authenticated`.
      (_) {},
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Sign Up
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _onSignUpRequested(
    AuthenticationSignUpRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.authenticationInProgress());

    final result = await _authenticationRepository.signUpWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(
        AuthenticationState.authenticationFailure(message: failure.message),
      ),
      (signUpResult) => switch (signUpResult) {
        SignUpAuthenticated() => (), // Stream will fire `signedIn`.
        SignUpConfirmationRequired() => emit(
          const AuthenticationState.emailConfirmationSent(),
        ),
      },
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Password Reset
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _onPasswordResetRequested(
    AuthenticationPasswordResetRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.authenticationInProgress());

    final result = await _authenticationRepository.resetPasswordForEmail(
      email: event.email,
    );

    result.fold(
      (failure) => emit(
        AuthenticationState.authenticationFailure(message: failure.message),
      ),
      (_) => emit(const AuthenticationState.passwordResetEmailSent()),
    );
  }

  Future<void> _onPasswordUpdateRequested(
    AuthenticationPasswordUpdateRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.authenticationInProgress());

    final result = await _authenticationRepository.updatePassword(
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(
        AuthenticationState.authenticationFailure(message: failure.message),
      ),
      // Password updated — force an authenticated state so the router
      // redirects to the dashboard immediately.
      (_) {
        final User? currentUser = _authenticationRepository.currentUser;
        if (currentUser != null) {
          emit(AuthenticationState.authenticated(user: currentUser));
        } else {
          // The recovery session expired between submitting and completion.
          // Emit a failure so the user sees an error instead of an
          // infinite loading spinner.
          emit(
            const AuthenticationState.authenticationFailure(
              message: 'Your session has expired. Please sign in again.',
            ),
          );
        }
      },
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Sign Out
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _onSignOutRequested(
    AuthenticationSignOutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationRepository.signOut();
    // Emit unauthenticated immediately rather than relying solely on
    // the auth-state stream, which may not fire if the network is down
    // or the listener was torn down. BLoC's Equatable deduplication
    // prevents a redundant emission if the stream also fires signedOut.
    emit(const AuthenticationState.unauthenticated());
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Internal: status changed from stream
  // ───────────────────────────────────────────────────────────────────────────

  void _onStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    if (event.user != null) {
      emit(AuthenticationState.authenticated(user: event.user!));
    } else {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  void _onPasswordRecoveryDetected(
    _AuthenticationPasswordRecoveryDetected event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(const AuthenticationState.passwordRecoveryInProgress());
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Internal: email confirmation detected from PKCE redirect
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _onEmailConfirmationDetected(
    _AuthenticationEmailConfirmationDetected event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Destroy the auto-created session so the user must log in explicitly.
    await _authenticationRepository.signOut();
    emit(const AuthenticationState.emailJustConfirmed());
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Cleanup
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<void> close() async {
    await _authStateSubscription?.cancel();
    return super.close();
  }
}

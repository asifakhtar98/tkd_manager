import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/features/auth/domain/repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// Manages the global authentication lifecycle for the entire application.
///
/// A single instance lives at the root [MultiBlocProvider] (created in
/// [main.dart]) and drives the [GoRouter] redirect guard so that every
/// route is protected behind login.
@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationSignInRequested>(_onSignInRequested);
    on<AuthenticationSignUpRequested>(_onSignUpRequested);
    on<AuthenticationSignOutRequested>(_onSignOutRequested);
    on<_AuthenticationStatusChanged>(_onStatusChanged);
  }

  final AuthenticationRepository _authenticationRepository;

  StreamSubscription<AuthState>? _authStateSubscription;

  // ───────────────────────────────────────────────────────────────────────────
  // Subscription to Supabase auth state stream
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Cancel any previous subscription defensively.
    await _authStateSubscription?.cancel();

    _authStateSubscription =
        _authenticationRepository.authStateChanges.listen((AuthState data) {
      switch (data.event) {
        case AuthChangeEvent.initialSession:
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
          add(_AuthenticationStatusChanged(user: data.session?.user));
        case AuthChangeEvent.signedOut:
        case AuthChangeEvent.userDeleted:
          add(const _AuthenticationStatusChanged(user: null));
        // Events we acknowledge but take no auth-routing action for.
        case AuthChangeEvent.passwordRecovery:
        case AuthChangeEvent.userUpdated:
        case AuthChangeEvent.mfaChallengeVerified:
          break;
      }
    });
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
      (failure) => emit(AuthenticationState.authenticationFailure(
        message: failure.message,
      )),
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
      (failure) => emit(AuthenticationState.authenticationFailure(
        message: failure.message,
      )),
      // Success: the auth-state stream listener will emit `authenticated`.
      (_) {},
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Sign Out
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _onSignOutRequested(
    AuthenticationSignOutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _authenticationRepository.signOut();
      // The auth-state stream will emit `signedOut` → `unauthenticated`.
    } on Exception {
      // Even if the remote sign-out fails, force-transition to
      // unauthenticated so the user isn't stuck in a signed-in limbo.
      emit(const AuthenticationState.unauthenticated());
    }
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

  // ───────────────────────────────────────────────────────────────────────────
  // Cleanup
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<void> close() async {
    await _authStateSubscription?.cancel();
    return super.close();
  }
}

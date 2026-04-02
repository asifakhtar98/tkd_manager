import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/features/auth/domain/entities/sign_up_result.dart';
import 'package:tkd_saas/features/auth/domain/repositories/authentication_repository.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_event.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_state.dart';

export 'authentication_event.dart'
    hide
        AuthenticationStatusChanged,
        AuthenticationPasswordRecoveryDetected,
        AuthenticationEmailConfirmationDetected;
export 'authentication_state.dart';

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
    @factoryParam
    @visibleForTesting
    IsEmailConfirmationRedirectPredicate? isEmailConfirmationRedirect,
  }) : _authenticationRepository = authenticationRepository,
       _isEmailConfirmationRedirectOverride = isEmailConfirmationRedirect,
       super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationSignInRequested>(_onSignInRequested);
    on<AuthenticationSignUpRequested>(_onSignUpRequested);
    on<AuthenticationSignOutRequested>(_onSignOutRequested);
    on<AuthenticationPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthenticationPasswordUpdateRequested>(_onPasswordUpdateRequested);
    on<AuthenticationStatusChanged>(_onStatusChanged);
    on<AuthenticationPasswordRecoveryDetected>(_onPasswordRecoveryDetected);
    on<AuthenticationEmailConfirmationDetected>(_onEmailConfirmationDetected);
  }

  final AuthenticationRepository _authenticationRepository;

  /// Optional override for testing — when non-null, this predicate is used
  /// instead of the default `Uri.base` check.
  final IsEmailConfirmationRedirectPredicate?
  _isEmailConfirmationRedirectOverride;

  StreamSubscription<AuthState>? _authStateSubscription;

  /// Whether the PKCE email-confirmation `?code=` in the browser URL has
  /// already been consumed. Prevents re-detection on subsequent auth events
  /// within the same app session.
  bool _emailConfirmationCodeConsumed = false;

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authStateSubscription?.cancel();

    _authStateSubscription = _authenticationRepository.authStateChanges.listen((
      AuthState data,
    ) {
      switch (data.event) {
        case AuthChangeEvent.initialSession:
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
          if (_isEmailConfirmationRedirect) {
            _emailConfirmationCodeConsumed = true;
            add(const AuthenticationEvent.emailConfirmationDetected());
          } else {
            add(AuthenticationEvent.statusChanged(user: data.session?.user));
          }
        case AuthChangeEvent.signedOut:
          add(const AuthenticationEvent.statusChanged(user: null));
        case AuthChangeEvent.passwordRecovery:
          add(const AuthenticationEvent.passwordRecoveryDetected());
        case AuthChangeEvent.userUpdated:
          if (data.session?.user != null) {
            add(AuthenticationEvent.statusChanged(user: data.session!.user));
          }
          break;
        case AuthChangeEvent.mfaChallengeVerified:
        // ignore: deprecated_member_use
        case AuthChangeEvent.userDeleted:
          break;
      }
    });
  }

  bool get _isEmailConfirmationRedirect {
    if (_emailConfirmationCodeConsumed) return false;
    if (_isEmailConfirmationRedirectOverride != null) {
      return _isEmailConfirmationRedirectOverride();
    }
    if (!kIsWeb) return false;

    final bool isCorrectPath = Uri.base.path == '/email-confirmed';
    final bool hasCodeAndType = Uri.base.queryParameters.containsKey('code');
    final bool hasFragment = Uri.base.fragment.contains('access_token=');

    return isCorrectPath && (hasCodeAndType || hasFragment);
  }

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
      (_) {},
    );
  }

  Future<void> _onSignUpRequested(
    AuthenticationSignUpRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.authenticationInProgress());

    final result = await _authenticationRepository.signUpWithEmailAndPassword(
      email: event.email,
      password: event.password,
      organizationName: event.organizationName,
    );

    result.fold(
      (failure) => emit(
        AuthenticationState.authenticationFailure(message: failure.message),
      ),
      (signUpResult) => switch (signUpResult) {
        SignUpAuthenticated() => (),
        SignUpConfirmationRequired() => emit(
          const AuthenticationState.emailConfirmationSent(),
        ),
      },
    );
  }

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
      (_) {
        final User? currentUser = _authenticationRepository.currentUser;
        if (currentUser != null) {
          emit(AuthenticationState.authenticated(user: currentUser));
        } else {
          emit(const AuthenticationState.unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignOutRequested(
    AuthenticationSignOutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationRepository.signOut();
    // Emit unauthenticated immediately rather than relying solely on
    // the auth-state stream, which may not fire if the network is down
    // or the listener was torn down. BLoC's freezed value-equality deduplication
    // prevents a redundant emission if the stream also fires signedOut.
    emit(const AuthenticationState.unauthenticated());
  }

  void _onStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    if (event.user != null) {
      emit(AuthenticationState.authenticated(user: event.user!));
    } else {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  void _onPasswordRecoveryDetected(
    AuthenticationPasswordRecoveryDetected event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(const AuthenticationState.passwordRecoveryInProgress());
  }

  Future<void> _onEmailConfirmationDetected(
    AuthenticationEmailConfirmationDetected event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationRepository.signOut();
    emit(const AuthenticationState.emailJustConfirmed());
  }

  @override
  Future<void> close() async {
    await _authStateSubscription?.cancel();
    return super.close();
  }
}

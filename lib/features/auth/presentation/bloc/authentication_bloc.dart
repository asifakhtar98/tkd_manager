import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/config/app_config.dart';
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
       _capturedInitialUri = kIsWeb ? Uri.base : null,
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
    on<AuthenticationEmailConfirmationAcknowledged>(
      _onEmailConfirmationAcknowledged,
    );

    // On mobile, eagerly capture the initial deep link URI (if any) before
    // supabase_flutter processes it. This mirrors the web `Uri.base` capture.
    // Skip when a test override is present — tests don't have platform channels.
    if (!kIsWeb && _isEmailConfirmationRedirectOverride == null) {
      _captureInitialMobileDeepLink();
    }
  }

  final AuthenticationRepository _authenticationRepository;

  /// Optional override for testing — when non-null, this predicate is used
  /// instead of the default `Uri.base` check.
  final IsEmailConfirmationRedirectPredicate?
  _isEmailConfirmationRedirectOverride;

  /// Snapshot of [Uri.base] captured eagerly at **construction time**.
  ///
  /// By the time the Supabase auth stream fires its first event, GoRouter or
  /// the Supabase SDK may have already stripped the `?code=` query parameter
  /// from the browser address bar.  Capturing the URI at construction time
  /// (before either subsystem has run) guarantees we can always detect whether
  /// the app was opened via an email-confirmation redirect.
  Uri? _capturedInitialUri;

  StreamSubscription<AuthState>? _authStateSubscription;

  /// Subscription to the mobile deep link stream (warm-start deep links).
  StreamSubscription<Uri>? _deepLinkSubscription;

  /// Whether a mobile deep link for email confirmation was received.
  /// Set by [_captureInitialMobileDeepLink] or the deep link stream listener.
  bool _mobileEmailConfirmationDeepLinkReceived = false;

  /// Whether the PKCE email-confirmation `?code=` in the browser URL has
  /// already been consumed. Prevents re-detection on subsequent auth events
  /// within the same app session.
  bool _emailConfirmationCodeConsumed = false;

  /// Guards against the `signedOut` stream event that our own intentional
  /// `signOut()` call triggers during email-confirmation handling.
  ///
  /// Set to `true` immediately before calling `signOut()` inside
  /// [_onEmailConfirmationDetected] and cleared when the corresponding
  /// `signedOut` stream event arrives.  While `true`, the stream listener
  /// swallows the `signedOut` event instead of dispatching
  /// [AuthenticationStatusChanged], preventing the `emailJustConfirmed`
  /// state from being prematurely overwritten by `unauthenticated`.
  bool _isProcessingEmailConfirmationSignOut = false;

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
            if (data.session != null) {
              // The SDK has completed the PKCE exchange and the session is ready.
              // Consume the code and trigger the sign out.
              _emailConfirmationCodeConsumed = true;
              _capturedInitialUri = null;
              add(const AuthenticationEvent.emailConfirmationDetected(performSignOut: true));
            } else {
              // The SDK is still exchanging the PKCE token (or about to).
              // Ensure the router stays on the interstitial screen.
              add(const AuthenticationEvent.emailConfirmationDetected(performSignOut: false));
            }
          } else {
            add(AuthenticationEvent.statusChanged(user: data.session?.user));
          }
        case AuthChangeEvent.signedOut:
          if (_isProcessingEmailConfirmationSignOut) {
            _isProcessingEmailConfirmationSignOut = false;
            break;
          }
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

    // ── Mobile deep link detection ──
    if (!kIsWeb) {
      return _mobileEmailConfirmationDeepLinkReceived;
    }

    // ── Web URI detection ──
    if (_capturedInitialUri == null) return false;

    final bool isCorrectPath =
        _capturedInitialUri!.path == AppConfig.emailConfirmedPath;
    final bool hasCodeParameter =
        _capturedInitialUri!.queryParameters.containsKey('code');
    final bool hasAccessTokenFragment =
        _capturedInitialUri!.fragment.contains('access_token=');

    final bool isRedirect = isCorrectPath && (hasCodeParameter || hasAccessTokenFragment);

    // If this startup URL was definitely not an email confirmation redirect, 
    // clear it immediately so future login events from other flows don't evaluate
    // against stale data.
    if (!isRedirect) {
      _capturedInitialUri = null;
    }

    return isRedirect;
  }

  /// Eagerly captures the initial deep link URI on mobile (cold start).
  ///
  /// On mobile, `Uri.base` is not meaningful — deep links arrive via the OS.
  /// `AppLinks().getInitialLink()` returns the URI that launched the app.
  ///
  /// Also subscribes to `uriLinkStream` for warm-start deep links (when the
  /// app is already running in the background and receives a deep link).
  void _captureInitialMobileDeepLink() {
    final AppLinks appLinks = AppLinks();

    // Cold start: the app was launched via a deep link.
    appLinks.getInitialLink().then((Uri? uri) {
      if (uri != null && _isEmailConfirmationPath(uri)) {
        _mobileEmailConfirmationDeepLinkReceived = true;
      }
    }).catchError((_) {
      // Platform channels may fail in certain environments — ignore.
    });

    // Warm start: app is in background and receives a deep link.
    _deepLinkSubscription = appLinks.uriLinkStream.listen((Uri uri) {
      if (_isEmailConfirmationPath(uri)) {
        _mobileEmailConfirmationDeepLinkReceived = true;
      }
    });
  }

  /// Checks whether the given [uri] matches the email confirmation
  /// deep link redirect (e.g. `com.gamecon.app://email-confirmed?code=...`).
  bool _isEmailConfirmationPath(Uri uri) {
    // The deep link arrives as `com.gamecon.app://email-confirmed?code=...`
    // where `host` is empty and `path` contains the route,
    // OR as `com.gamecon.app:///email-confirmed?code=...` with a path.
    final String effectivePath =
        uri.host.isNotEmpty ? '/${uri.host}${uri.path}' : uri.path;
    return effectivePath == AppConfig.emailConfirmedPath;
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
    if (event.performSignOut) {
      _isProcessingEmailConfirmationSignOut = true;
      try {
        await _authenticationRepository.signOut();
      } catch (_) {
        // If signOut throws (e.g., network error), the auth stream will not fire 
        // signedOut. Clear the flag immediately to avoid swallowed events later.
        _isProcessingEmailConfirmationSignOut = false;
      }
    }
    emit(const AuthenticationState.emailJustConfirmed());
  }

  /// Deterministically transitions from [emailJustConfirmed] to
  /// [unauthenticated] when the user acknowledges the confirmation screen.
  ///
  /// This is the **only** reliable exit path from the email-confirmed
  /// interstitial — it removes the dependency on stream timing entirely.
  void _onEmailConfirmationAcknowledged(
    AuthenticationEmailConfirmationAcknowledged event,
    Emitter<AuthenticationState> emit,
  ) {
    // If the underlying PKCE exchange completely failed (e.g., missing code verifier
    // in local storage), a `signedIn` event will never fire to clean up the intercept
    // state. Defuse the interceptor manually here when the user explicitly leaves
    // the screen, so their upcoming manual login is not hijacked.
    _emailConfirmationCodeConsumed = true;
    _capturedInitialUri = null;

    emit(const AuthenticationState.unauthenticated());
  }

  @override
  Future<void> close() async {
    await _authStateSubscription?.cancel();
    await _deepLinkSubscription?.cancel();
    return super.close();
  }
}

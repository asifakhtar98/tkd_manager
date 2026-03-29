import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show Left, Right, Unit, unit;
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/features/auth/domain/entities/sign_up_result.dart';
import 'package:tkd_saas/features/auth/domain/repositories/authentication_repository.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mocks & Fakes
// ─────────────────────────────────────────────────────────────────────────────

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class FakeUser extends Fake implements User {
  @override
  String get id => 'test-user-id';

  @override
  String get email => 'test@example.com';
}

/// Helper to reduce repeated Session construction across tests.
Session createFakeSession({
  required User user,
  String accessToken = 'test-token',
}) {
  return Session(accessToken: accessToken, tokenType: 'bearer', user: user);
}

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  late MockAuthenticationRepository mockAuthenticationRepository;
  late AuthenticationBloc authenticationBloc;
  late StreamController<AuthState> authStateStreamController;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    authStateStreamController = StreamController<AuthState>.broadcast();

    when(
      () => mockAuthenticationRepository.authStateChanges,
    ).thenAnswer((_) => authStateStreamController.stream);

    authenticationBloc = AuthenticationBloc(
      authenticationRepository: mockAuthenticationRepository,
    );
  });

  tearDown(() async {
    await authenticationBloc.close();
    await authStateStreamController.close();
  });

  group('AuthenticationBloc', () {
    test('initial state is AuthenticationUnknown', () {
      expect(authenticationBloc.state, isA<AuthenticationUnknown>());
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Subscription
    // ─────────────────────────────────────────────────────────────────────────

    group('AuthenticationSubscriptionRequested', () {
      test(
        'emits unauthenticated when auth stream fires initialSession with no user',
        () async {
          authenticationBloc.add(const AuthenticationSubscriptionRequested());
          await Future<void>.delayed(Duration.zero);

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([isA<AuthenticationUnauthenticated>()]),
          );

          authStateStreamController.add(
            AuthState(AuthChangeEvent.initialSession, null),
          );
        },
      );

      test(
        'emits authenticated when auth stream fires signedIn with a valid user',
        () async {
          final FakeUser fakeUser = FakeUser();

          authenticationBloc.add(const AuthenticationSubscriptionRequested());
          await Future<void>.delayed(Duration.zero);

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([isA<AuthenticationAuthenticated>()]),
          );

          authStateStreamController.add(
            AuthState(
              AuthChangeEvent.signedIn,
              createFakeSession(user: fakeUser),
            ),
          );
        },
      );

      test('emits unauthenticated when auth stream fires signedOut', () async {
        authenticationBloc.add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationUnauthenticated>()]),
        );

        authStateStreamController.add(
          AuthState(AuthChangeEvent.signedOut, null),
        );
      });

      test(
        'emits authenticated when auth stream fires tokenRefreshed with a valid session',
        () async {
          final FakeUser fakeUser = FakeUser();

          authenticationBloc.add(const AuthenticationSubscriptionRequested());
          await Future<void>.delayed(Duration.zero);

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([isA<AuthenticationAuthenticated>()]),
          );

          authStateStreamController.add(
            AuthState(
              AuthChangeEvent.tokenRefreshed,
              createFakeSession(user: fakeUser, accessToken: 'refreshed-token'),
            ),
          );
        },
      );

      test(
        'emits passwordRecoveryInProgress when auth stream fires passwordRecovery',
        () async {
          authenticationBloc.add(const AuthenticationSubscriptionRequested());
          await Future<void>.delayed(Duration.zero);

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([isA<AuthenticationPasswordRecoveryInProgress>()]),
          );

          authStateStreamController.add(
            AuthState(AuthChangeEvent.passwordRecovery, null),
          );
        },
      );

      test('does not emit for userUpdated event', () async {
        final FakeUser fakeUser = FakeUser();

        authenticationBloc.add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        // userUpdated should be a no-op.
        authStateStreamController.add(
          AuthState(
            AuthChangeEvent.userUpdated,
            createFakeSession(user: fakeUser),
          ),
        );

        // signedOut SHOULD emit.
        authStateStreamController.add(
          AuthState(AuthChangeEvent.signedOut, null),
        );

        await expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationUnauthenticated>()]),
        );
      });

      test(
        'cancels previous subscription when dispatched multiple times',
        () async {
          final FakeUser fakeUser = FakeUser();

          // First subscription.
          authenticationBloc.add(const AuthenticationSubscriptionRequested());
          await Future<void>.delayed(Duration.zero);

          // Replace the stream for second subscription.
          final StreamController<AuthState> secondStreamController =
              StreamController<AuthState>.broadcast();
          when(
            () => mockAuthenticationRepository.authStateChanges,
          ).thenAnswer((_) => secondStreamController.stream);

          // Second subscription — should cancel first.
          authenticationBloc.add(const AuthenticationSubscriptionRequested());
          await Future<void>.delayed(Duration.zero);

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([isA<AuthenticationAuthenticated>()]),
          );

          // Event on the OLD stream — should be ignored.
          authStateStreamController.add(
            AuthState(AuthChangeEvent.signedOut, null),
          );

          // Event on the NEW stream — should be processed.
          secondStreamController.add(
            AuthState(
              AuthChangeEvent.signedIn,
              createFakeSession(user: fakeUser),
            ),
          );

          await Future<void>.delayed(const Duration(milliseconds: 50));
          await secondStreamController.close();
        },
      );
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Sign In
    // ─────────────────────────────────────────────────────────────────────────

    group('AuthenticationSignInRequested', () {
      test(
        'emits inProgress then delegates to stream on successful sign-in',
        () async {
          final FakeUser fakeUser = FakeUser();

          when(
            () => mockAuthenticationRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Right<Failure, User>(fakeUser));

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([isA<AuthenticationInProgress>()]),
          );

          authenticationBloc.add(
            const AuthenticationSignInRequested(
              email: 'test@example.com',
              password: 'password123',
            ),
          );
        },
      );

      test(
        'emits inProgress then authenticationFailure on sign-in error',
        () async {
          when(
            () => mockAuthenticationRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => const Left(
              AuthenticationFailure('Incorrect email or password.'),
            ),
          );

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([
              isA<AuthenticationInProgress>(),
              isA<AuthenticationFailureState>().having(
                (AuthenticationFailureState s) => s.message,
                'message',
                'Incorrect email or password.',
              ),
            ]),
          );

          authenticationBloc.add(
            const AuthenticationSignInRequested(
              email: 'test@example.com',
              password: 'wrong-password',
            ),
          );
        },
      );
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Sign Up
    // ─────────────────────────────────────────────────────────────────────────

    group('AuthenticationSignUpRequested', () {
      test(
        'emits inProgress then delegates to stream when signup creates session',
        () async {
          final FakeUser fakeUser = FakeUser();

          when(
            () => mockAuthenticationRepository.signUpWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              organizationName: any(named: 'organizationName'),
            ),
          ).thenAnswer((_) async => Right(SignUpAuthenticated(user: fakeUser)));

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([isA<AuthenticationInProgress>()]),
          );

          authenticationBloc.add(
            const AuthenticationSignUpRequested(
              email: 'new@example.com',
              password: 'password123',
              organizationName: 'Demo Org',
            ),
          );
        },
      );

      test(
        'emits inProgress then emailConfirmationSent when confirmation required',
        () async {
          when(
            () => mockAuthenticationRepository.signUpWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              organizationName: any(named: 'organizationName'),
            ),
          ).thenAnswer((_) async => const Right(SignUpConfirmationRequired()));

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([
              isA<AuthenticationInProgress>(),
              isA<AuthenticationEmailConfirmationSent>(),
            ]),
          );

          authenticationBloc.add(
            const AuthenticationSignUpRequested(
              email: 'new@example.com',
              password: 'password123',
              organizationName: 'Demo Org',
            ),
          );
        },
      );

      test(
        'emits inProgress then authenticationFailure on sign-up error',
        () async {
          when(
            () => mockAuthenticationRepository.signUpWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              organizationName: any(named: 'organizationName'),
            ),
          ).thenAnswer(
            (_) async => const Left(
              AuthenticationFailure(
                'An account with this email already exists.',
              ),
            ),
          );

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([
              isA<AuthenticationInProgress>(),
              isA<AuthenticationFailureState>().having(
                (AuthenticationFailureState s) => s.message,
                'message',
                'An account with this email already exists.',
              ),
            ]),
          );

          authenticationBloc.add(
            const AuthenticationSignUpRequested(
              email: 'existing@example.com',
              password: 'password123',
              organizationName: 'Demo Org',
            ),
          );
        },
      );
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Password Reset
    // ─────────────────────────────────────────────────────────────────────────

    group('AuthenticationPasswordResetRequested', () {
      test('emits inProgress then passwordResetEmailSent on success', () async {
        when(
          () => mockAuthenticationRepository.resetPasswordForEmail(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([
            isA<AuthenticationInProgress>(),
            isA<AuthenticationPasswordResetEmailSent>(),
          ]),
        );

        authenticationBloc.add(
          const AuthenticationPasswordResetRequested(email: 'test@example.com'),
        );
      });

      test('emits inProgress then authenticationFailure on error', () async {
        when(
          () => mockAuthenticationRepository.resetPasswordForEmail(
            email: any(named: 'email'),
          ),
        ).thenAnswer(
          (_) async => const Left(AuthenticationFailure('Too many attempts.')),
        );

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([
            isA<AuthenticationInProgress>(),
            isA<AuthenticationFailureState>().having(
              (AuthenticationFailureState s) => s.message,
              'message',
              'Too many attempts.',
            ),
          ]),
        );

        authenticationBloc.add(
          const AuthenticationPasswordResetRequested(email: 'test@example.com'),
        );
      });
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Password Update
    // ─────────────────────────────────────────────────────────────────────────

    group('AuthenticationPasswordUpdateRequested', () {
      test('emits inProgress then authenticated on success', () async {
        final FakeUser fakeUser = FakeUser();

        when(
          () => mockAuthenticationRepository.updatePassword(
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

        when(
          () => mockAuthenticationRepository.currentUser,
        ).thenReturn(fakeUser);

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([
            isA<AuthenticationInProgress>(),
            isA<AuthenticationAuthenticated>(),
          ]),
        );

        authenticationBloc.add(
          const AuthenticationPasswordUpdateRequested(
            newPassword: 'newPassword123',
          ),
        );
      });

      test(
        'emits inProgress then unauthenticated when currentUser is unexpectedly null',
        () async {
          when(
            () => mockAuthenticationRepository.updatePassword(
              newPassword: any(named: 'newPassword'),
            ),
          ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

          when(() => mockAuthenticationRepository.currentUser).thenReturn(null);

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([
              isA<AuthenticationInProgress>(),
              isA<AuthenticationUnauthenticated>(),
            ]),
          );

          authenticationBloc.add(
            const AuthenticationPasswordUpdateRequested(
              newPassword: 'newPassword123',
            ),
          );
        },
      );

      test('emits inProgress then authenticationFailure on error', () async {
        when(
          () => mockAuthenticationRepository.updatePassword(
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer(
          (_) async =>
              const Left(AuthenticationFailure('Password is too weak.')),
        );

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([
            isA<AuthenticationInProgress>(),
            isA<AuthenticationFailureState>().having(
              (AuthenticationFailureState s) => s.message,
              'message',
              'Password is too weak.',
            ),
          ]),
        );

        authenticationBloc.add(
          const AuthenticationPasswordUpdateRequested(newPassword: '123'),
        );
      });
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Sign Out
    // ─────────────────────────────────────────────────────────────────────────

    group('AuthenticationSignOutRequested', () {
      test(
        'always emits unauthenticated directly without waiting for stream',
        () async {
          when(
            () => mockAuthenticationRepository.signOut(),
          ).thenAnswer((_) async {});

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([isA<AuthenticationUnauthenticated>()]),
          );

          authenticationBloc.add(const AuthenticationSignOutRequested());

          // Verify the repository was called.
          await Future<void>.delayed(const Duration(milliseconds: 50));
          verify(() => mockAuthenticationRepository.signOut()).called(1);
        },
      );
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Email Confirmation Detection
    // ─────────────────────────────────────────────────────────────────────────

    group('Email confirmation redirect detection', () {
      test('emits emailJustConfirmed and calls signOut when signedIn fires '
          'with email confirmation redirect detected', () async {
        final FakeUser fakeUser = FakeUser();

        when(
          () => mockAuthenticationRepository.signOut(),
        ).thenAnswer((_) async {});

        authenticationBloc = AuthenticationBloc(
          authenticationRepository: mockAuthenticationRepository,
          isEmailConfirmationRedirect: () => true,
        );

        authenticationBloc.add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationEmailJustConfirmed>()]),
        );

        authStateStreamController.add(
          AuthState(
            AuthChangeEvent.signedIn,
            createFakeSession(user: fakeUser),
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));
        verify(() => mockAuthenticationRepository.signOut()).called(1);
      });

      test('emits authenticated (not emailJustConfirmed) when signedIn fires '
          'without email confirmation redirect', () async {
        final FakeUser fakeUser = FakeUser();

        authenticationBloc = AuthenticationBloc(
          authenticationRepository: mockAuthenticationRepository,
          isEmailConfirmationRedirect: () => false,
        );

        authenticationBloc.add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationAuthenticated>()]),
        );

        authStateStreamController.add(
          AuthState(
            AuthChangeEvent.signedIn,
            createFakeSession(user: fakeUser),
          ),
        );
      });

      test('email confirmation flag is consumed after first detection — '
          'subsequent signedIn events emit authenticated', () async {
        final FakeUser fakeUser = FakeUser();
        bool simulateRedirect = true;

        when(
          () => mockAuthenticationRepository.signOut(),
        ).thenAnswer((_) async {});

        authenticationBloc = AuthenticationBloc(
          authenticationRepository: mockAuthenticationRepository,
          isEmailConfirmationRedirect: () => simulateRedirect,
        );

        authenticationBloc.add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        // First signedIn → should detect email confirmation.
        authStateStreamController.add(
          AuthState(
            AuthChangeEvent.signedIn,
            createFakeSession(user: fakeUser),
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(
          authenticationBloc.state,
          isA<AuthenticationEmailJustConfirmed>(),
        );
        verify(() => mockAuthenticationRepository.signOut()).called(1);

        // Second signedIn → flag consumed, should emit authenticated.
        simulateRedirect =
            false; // URL would still have code but flag consumed.
        authStateStreamController.add(
          AuthState(
            AuthChangeEvent.signedIn,
            createFakeSession(user: fakeUser),
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(authenticationBloc.state, isA<AuthenticationAuthenticated>());
      });

      // ── BUG-1 regression ──────────────────────────────────────────────────
      test(
        'password recovery PKCE redirect (isEmailConfirmationRedirect = false) '
        'does NOT trigger email confirmation — emits authenticated instead',
        () async {
          // Simulates a password-recovery redirect: the URL path is "/" (origin),
          // NOT "/email-confirmed", so _isEmailConfirmationRedirect returns false.
          final FakeUser fakeUser = FakeUser();

          authenticationBloc = AuthenticationBloc(
            authenticationRepository: mockAuthenticationRepository,
            isEmailConfirmationRedirect: () => false,
          );

          authenticationBloc.add(const AuthenticationSubscriptionRequested());
          await Future<void>.delayed(Duration.zero);

          expectLater(
            authenticationBloc.stream,
            emitsInOrder([isA<AuthenticationAuthenticated>()]),
          );

          // Simulate the signedIn event that PKCE fires before passwordRecovery.
          authStateStreamController.add(
            AuthState(
              AuthChangeEvent.signedIn,
              createFakeSession(user: fakeUser),
            ),
          );

          await Future<void>.delayed(const Duration(milliseconds: 100));

          // signOut must NOT have been called — the session is preserved for
          // the subsequent passwordRecovery event to work correctly.
          verifyNever(() => mockAuthenticationRepository.signOut());
          expect(authenticationBloc.state, isA<AuthenticationAuthenticated>());
        },
      );
    });

    // ─────────────────────────────────────────────────────────────────────────
    // close() lifecycle
    // ─────────────────────────────────────────────────────────────────────────

    group('close', () {
      test('cancels auth state subscription on close', () async {
        authenticationBloc.add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        await authenticationBloc.close();

        expect(authStateStreamController.hasListener, isFalse);
      });
    });
  });
}

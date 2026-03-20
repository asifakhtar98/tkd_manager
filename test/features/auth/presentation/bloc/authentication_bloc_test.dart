import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/error/failures.dart';
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

    when(() => mockAuthenticationRepository.authStateChanges)
        .thenAnswer((_) => authStateStreamController.stream);

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
        authenticationBloc
            .add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationUnauthenticated>()]),
        );

        authStateStreamController.add(
          AuthState(AuthChangeEvent.initialSession, null),
        );
      });

      test(
          'emits authenticated when auth stream fires signedIn with a valid user',
          () async {
        final FakeUser fakeUser = FakeUser();

        authenticationBloc
            .add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationAuthenticated>()]),
        );

        final Session fakeSession = Session(
          accessToken: 'test-token',
          tokenType: 'bearer',
          user: fakeUser,
        );

        authStateStreamController.add(
          AuthState(AuthChangeEvent.signedIn, fakeSession),
        );
      });

      test('emits unauthenticated when auth stream fires signedOut', () async {
        authenticationBloc
            .add(const AuthenticationSubscriptionRequested());
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
        final Session fakeSession = Session(
          accessToken: 'refreshed-token',
          tokenType: 'bearer',
          user: fakeUser,
        );

        authenticationBloc
            .add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationAuthenticated>()]),
        );

        authStateStreamController.add(
          AuthState(AuthChangeEvent.tokenRefreshed, fakeSession),
        );
      });

      test(
          'emits unauthenticated when auth stream fires userDeleted',
          () async {
        authenticationBloc
            .add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationUnauthenticated>()]),
        );

        authStateStreamController.add(
          AuthState(AuthChangeEvent.userDeleted, null),
        );
      });

      test(
          'does not emit for passwordRecovery event',
          () async {
        authenticationBloc
            .add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        // Add passwordRecovery — should be a no-op.
        authStateStreamController.add(
          AuthState(AuthChangeEvent.passwordRecovery, null),
        );

        // Then add signedOut — this SHOULD emit.
        authStateStreamController.add(
          AuthState(AuthChangeEvent.signedOut, null),
        );

        // We should only see unauthenticated (from signedOut),
        // NOT anything from passwordRecovery.
        await expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationUnauthenticated>()]),
        );
      });

      test(
          'does not emit for userUpdated event',
          () async {
        final FakeUser fakeUser = FakeUser();
        final Session fakeSession = Session(
          accessToken: 'test-token',
          tokenType: 'bearer',
          user: fakeUser,
        );

        authenticationBloc
            .add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        // userUpdated should be a no-op.
        authStateStreamController.add(
          AuthState(AuthChangeEvent.userUpdated, fakeSession),
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
        final Session fakeSession = Session(
          accessToken: 'test-token',
          tokenType: 'bearer',
          user: fakeUser,
        );

        // First subscription.
        authenticationBloc
            .add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        // Replace the stream for second subscription.
        final StreamController<AuthState> secondStreamController =
            StreamController<AuthState>.broadcast();
        when(() => mockAuthenticationRepository.authStateChanges)
            .thenAnswer((_) => secondStreamController.stream);

        // Second subscription — should cancel first.
        authenticationBloc
            .add(const AuthenticationSubscriptionRequested());
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
          AuthState(AuthChangeEvent.signedIn, fakeSession),
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await secondStreamController.close();
      });
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
        ).thenAnswer((_) async => Right(fakeUser));

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
      });

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
      });
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Sign Up
    // ─────────────────────────────────────────────────────────────────────────

    group('AuthenticationSignUpRequested', () {
      test(
          'emits inProgress then delegates to stream on successful sign-up',
          () async {
        final FakeUser fakeUser = FakeUser();

        when(
          () => mockAuthenticationRepository.signUpWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(fakeUser));

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationInProgress>()]),
        );

        authenticationBloc.add(
          const AuthenticationSignUpRequested(
            email: 'new@example.com',
            password: 'password123',
          ),
        );
      });

      test(
          'emits inProgress then authenticationFailure on sign-up error (duplicate)',
          () async {
        when(
          () => mockAuthenticationRepository.signUpWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
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
          ),
        );
      });
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Sign Out
    // ─────────────────────────────────────────────────────────────────────────

    group('AuthenticationSignOutRequested', () {
      test('calls signOut on repository and stream emits unauthenticated',
          () async {
        when(() => mockAuthenticationRepository.signOut())
            .thenAnswer((_) async {});

        authenticationBloc
            .add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationUnauthenticated>()]),
        );

        authenticationBloc
            .add(const AuthenticationSignOutRequested());
        await Future<void>.delayed(Duration.zero);

        authStateStreamController.add(
          AuthState(AuthChangeEvent.signedOut, null),
        );

        verify(() => mockAuthenticationRepository.signOut()).called(1);
      });

      test(
          'emits unauthenticated even when signOut throws an exception',
          () async {
        when(() => mockAuthenticationRepository.signOut())
            .thenThrow(Exception('Network error'));

        expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<AuthenticationUnauthenticated>()]),
        );

        authenticationBloc
            .add(const AuthenticationSignOutRequested());
      });
    });

    // ─────────────────────────────────────────────────────────────────────────
    // close() lifecycle
    // ─────────────────────────────────────────────────────────────────────────

    group('close', () {
      test('cancels auth state subscription on close', () async {
        authenticationBloc
            .add(const AuthenticationSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);

        // Close the BLoC.
        await authenticationBloc.close();

        // The subscription should be cancelled — verify the stream
        // controller has no listeners remaining.
        expect(authStateStreamController.hasListener, isFalse);
      });
    });
  });
}

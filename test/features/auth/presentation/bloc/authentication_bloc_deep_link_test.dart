import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:tkd_saas/features/auth/domain/repositories/authentication_repository.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mocks
// ─────────────────────────────────────────────────────────────────────────────

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class FakeUser extends Fake implements User {
  @override
  String get id => 'test-user-id';
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

AuthState makeAuthState(AuthChangeEvent event, {Session? session}) {
  return AuthState(event, session);
}

Future<void> tick() => Future<void>.delayed(const Duration(milliseconds: 10));

void main() {
  late MockAuthenticationRepository mockRepository;
  late StreamController<AuthState> authStateController;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    authStateController = StreamController<AuthState>.broadcast();

    when(() => mockRepository.authStateChanges)
        .thenAnswer((_) => authStateController.stream);
    when(() => mockRepository.currentUser).thenReturn(null);
    when(() => mockRepository.signOut()).thenAnswer((_) async {});
  });

  tearDown(() {
    authStateController.close();
  });

  group('AuthenticationBloc — Mobile deep link email confirmation', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits emailJustConfirmed when deep link flag is true and '
      'signedIn fires WITHOUT a session',
      build: () => AuthenticationBloc(
        authenticationRepository: mockRepository,
        isEmailConfirmationRedirect: () => true,
      ),
      act: (bloc) async {
        bloc.add(const AuthenticationSubscriptionRequested());
        await tick();
        authStateController.add(
          makeAuthState(AuthChangeEvent.signedIn, session: null),
        );
        await tick();
      },
      expect: () => [
        const AuthenticationState.emailJustConfirmed(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits emailJustConfirmed and calls signOut when signedIn fires WITH '
      'a valid session during email confirmation redirect',
      build: () => AuthenticationBloc(
        authenticationRepository: mockRepository,
        isEmailConfirmationRedirect: () => true,
      ),
      act: (bloc) async {
        bloc.add(const AuthenticationSubscriptionRequested());
        await tick();
        final FakeUser fakeUser = FakeUser();
        authStateController.add(
          makeAuthState(
            AuthChangeEvent.signedIn,
            session: Session(
              accessToken: 'test-token',
              tokenType: 'bearer',
              user: fakeUser,
            ),
          ),
        );
        await tick();
      },
      expect: () => [
        const AuthenticationState.emailJustConfirmed(),
      ],
      verify: (_) {
        verify(() => mockRepository.signOut()).called(1);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'transitions to unauthenticated when user acknowledges the '
      'email confirmation screen',
      build: () => AuthenticationBloc(
        authenticationRepository: mockRepository,
        isEmailConfirmationRedirect: () => false,
      ),
      seed: () => const AuthenticationState.emailJustConfirmed(),
      act: (bloc) {
        bloc.add(const AuthenticationEmailConfirmationAcknowledged());
      },
      expect: () => [
        const AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'does NOT detect email confirmation when override returns false — '
      'normal sign-in flow emits authenticated',
      build: () => AuthenticationBloc(
        authenticationRepository: mockRepository,
        isEmailConfirmationRedirect: () => false,
      ),
      act: (bloc) async {
        bloc.add(const AuthenticationSubscriptionRequested());
        await tick();
        final FakeUser fakeUser = FakeUser();
        authStateController.add(
          makeAuthState(
            AuthChangeEvent.signedIn,
            session: Session(
              accessToken: 'test-token',
              tokenType: 'bearer',
              user: fakeUser,
            ),
          ),
        );
        await tick();
      },
      expect: () => [
        isA<AuthenticationAuthenticated>(),
      ],
    );
  });

  group('AuthenticationBloc — password recovery flow', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits passwordRecoveryInProgress on passwordRecovery auth event',
      build: () => AuthenticationBloc(
        authenticationRepository: mockRepository,
        isEmailConfirmationRedirect: () => false,
      ),
      act: (bloc) async {
        bloc.add(const AuthenticationSubscriptionRequested());
        await tick();
        authStateController.add(
          makeAuthState(AuthChangeEvent.passwordRecovery),
        );
        await tick();
      },
      expect: () => [
        const AuthenticationState.passwordRecoveryInProgress(),
      ],
    );
  });

  group('AuthenticationBloc — sign out flow', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits unauthenticated when signedOut fires from auth stream',
      build: () => AuthenticationBloc(
        authenticationRepository: mockRepository,
        isEmailConfirmationRedirect: () => false,
      ),
      act: (bloc) async {
        bloc.add(const AuthenticationSubscriptionRequested());
        await tick();
        authStateController.add(
          makeAuthState(AuthChangeEvent.signedOut),
        );
        await tick();
      },
      expect: () => [
        const AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'swallows signedOut event that occurs during email confirmation '
      'sign-out, leaving state at emailJustConfirmed',
      build: () {
        bool isRedirect = true;
        return AuthenticationBloc(
          authenticationRepository: mockRepository,
          isEmailConfirmationRedirect: () {
            final bool current = isRedirect;
            return current;
          },
        );
      },
      act: (bloc) async {
        bloc.add(const AuthenticationSubscriptionRequested());
        await tick();

        final FakeUser fakeUser = FakeUser();
        authStateController.add(
          makeAuthState(
            AuthChangeEvent.signedIn,
            session: Session(
              accessToken: 'test-token',
              tokenType: 'bearer',
              user: fakeUser,
            ),
          ),
        );
        await tick();

        authStateController.add(
          makeAuthState(AuthChangeEvent.signedOut),
        );
        await tick();
      },
      expect: () => [
        const AuthenticationState.emailJustConfirmed(),
      ],
    );
  });
}

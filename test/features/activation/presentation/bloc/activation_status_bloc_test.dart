import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/features/activation/domain/entities/activation_status.dart';
import 'package:tkd_saas/features/activation/domain/repositories/i_activation_repository.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_bloc.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_event.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_state.dart';

class MockActivationRepository extends Mock implements IActivationRepository {}

void main() {
  late ActivationStatusBloc bloc;
  late MockActivationRepository mockRepository;

  setUp(() {
    mockRepository = MockActivationRepository();
    bloc = ActivationStatusBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('ActivationStatusLoadRequested', () {
    test(
      'emits loaded state with Active status when user has active subscription',
      () {
        final expiresAt = DateTime.now().toUtc().add(const Duration(days: 30));

        when(
          () => mockRepository.getActivationStatusForCurrentUser(),
        ).thenAnswer(
          (_) async => Right(ActivationStatusActive(expiresAt: expiresAt)),
        );
        when(
          () => mockRepository.isCurrentUserAdmin(),
        ).thenAnswer((_) async => const Right(false));

        bloc.add(const ActivationStatusEvent.loadRequested());

        expectLater(
          bloc.stream,
          emitsInOrder([
            // loading
            isA<ActivationStatusState>().having(
              (s) => s.isLoading,
              'isLoading',
              true,
            ),
            // loaded with active status
            isA<ActivationStatusState>()
                .having((s) => s.isLoading, 'isLoading', false)
                .having(
                  (s) => s.activationStatus,
                  'activationStatus',
                  isA<ActivationStatusActive>(),
                )
                .having((s) => s.isAdmin, 'isAdmin', false),
          ]),
        );
      },
    );

    test(
      'emits loaded state with PendingReview status when user has pending request',
      () {
        when(
          () => mockRepository.getActivationStatusForCurrentUser(),
        ).thenAnswer((_) async => const Right(ActivationStatusPendingReview()));
        when(
          () => mockRepository.isCurrentUserAdmin(),
        ).thenAnswer((_) async => const Right(false));

        bloc.add(const ActivationStatusEvent.loadRequested());

        expectLater(
          bloc.stream,
          emitsInOrder([
            isA<ActivationStatusState>().having(
              (s) => s.isLoading,
              'isLoading',
              true,
            ),
            isA<ActivationStatusState>()
                .having((s) => s.isLoading, 'isLoading', false)
                .having(
                  (s) => s.activationStatus,
                  'activationStatus',
                  isA<ActivationStatusPendingReview>(),
                ),
          ]),
        );
      },
    );

    test(
      'emits loaded state with NotActivated status when user has no subscription or request',
      () {
        when(
          () => mockRepository.getActivationStatusForCurrentUser(),
        ).thenAnswer((_) async => const Right(ActivationStatusNotActivated()));
        when(
          () => mockRepository.isCurrentUserAdmin(),
        ).thenAnswer((_) async => const Right(false));

        bloc.add(const ActivationStatusEvent.loadRequested());

        expectLater(
          bloc.stream,
          emitsInOrder([
            isA<ActivationStatusState>().having(
              (s) => s.isLoading,
              'isLoading',
              true,
            ),
            isA<ActivationStatusState>()
                .having((s) => s.isLoading, 'isLoading', false)
                .having(
                  (s) => s.activationStatus,
                  'activationStatus',
                  isA<ActivationStatusNotActivated>(),
                ),
          ]),
        );
      },
    );

    test('emits isAdmin true when user is an admin', () {
      when(
        () => mockRepository.getActivationStatusForCurrentUser(),
      ).thenAnswer((_) async => const Right(ActivationStatusNotActivated()));
      when(
        () => mockRepository.isCurrentUserAdmin(),
      ).thenAnswer((_) async => const Right(true));

      bloc.add(const ActivationStatusEvent.loadRequested());

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ActivationStatusState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<ActivationStatusState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.isAdmin, 'isAdmin', true),
        ]),
      );
    });

    test('emits error when fetching status fails', () {
      when(
        () => mockRepository.getActivationStatusForCurrentUser(),
      ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
      when(
        () => mockRepository.isCurrentUserAdmin(),
      ).thenAnswer((_) async => const Right(false));

      bloc.add(const ActivationStatusEvent.loadRequested());

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ActivationStatusState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<ActivationStatusState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.error, 'error', isNotNull),
        ]),
      );
    });
  });

  group('ActivationStatusClearRequested', () {
    test('emits initial state when clear is requested', () {
      // Set bloc to some active state first
      bloc.emit(
        ActivationStatusState(
          activationStatus: ActivationStatusActive(
            expiresAt: DateTime(2030, 1, 1),
          ),
          isAdmin: true,
        ),
      );

      bloc.add(const ActivationStatusEvent.clearRequested());

      expectLater(bloc.stream, emitsInOrder([const ActivationStatusState()]));
    });
  });
}

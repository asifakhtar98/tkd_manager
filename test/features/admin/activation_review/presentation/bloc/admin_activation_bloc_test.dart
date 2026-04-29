import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/core/shared/domain/entities/activation_request_entity.dart';
import 'package:tkd_saas/features/admin/activation_review/domain/repositories/admin_activation_repository.dart';
import 'package:tkd_saas/features/admin/activation_review/presentation/bloc/admin_activation_bloc.dart';
import 'package:tkd_saas/features/admin/activation_review/presentation/bloc/admin_activation_event.dart';
import 'package:tkd_saas/features/admin/activation_review/presentation/bloc/admin_activation_state.dart';

class MockAdminActivationRepository extends Mock implements IAdminActivationRepository {}

void main() {
  late AdminActivationBloc bloc;
  late MockAdminActivationRepository mockRepository;

  final tRequest1 = ActivationRequestEntity(
    id: 'req-1',
    userId: 'user-aaa',
    contactName: 'Alice',
    requestedDays: 30,
    totalAmount: 23550,
    status: 'pending',
    createdAt: DateTime(2026, 3, 28),
  );

  final tRequest2 = ActivationRequestEntity(
    id: 'req-2',
    userId: 'user-bbb',
    contactName: 'Bob',
    requestedDays: 15,
    totalAmount: 11550,
    status: 'pending',
    createdAt: DateTime(2026, 3, 29),
  );

  setUp(() {
    mockRepository = MockAdminActivationRepository();
    bloc = AdminActivationBloc(mockRepository);

    registerFallbackValue(tRequest1);
  });

  tearDown(() {
    bloc.close();
  });

  group('LoadPendingRequests', () {
    test('emits loaded state with pending requests', () {
      when(
        () => mockRepository.getAllPendingActivationRequests(),
      ).thenAnswer((_) async => Right([tRequest1, tRequest2]));

      bloc.add(const AdminActivationEvent.loadPendingRequests());

      expectLater(
        bloc.stream,
        emitsInOrder([
          // loading
          isA<AdminActivationState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          // loaded
          isA<AdminActivationState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.pendingRequests.length, 'pendingCount', 2),
        ]),
      );
    });

    test('emits error when loading fails', () {
      when(
        () => mockRepository.getAllPendingActivationRequests(),
      ).thenAnswer((_) async => const Left(ServerFailure('Network error')));

      bloc.add(const AdminActivationEvent.loadPendingRequests());

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AdminActivationState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<AdminActivationState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.error, 'error', isNotNull),
        ]),
      );
    });
  });

  group('ApproveRequest', () {
    test('removes request from list and emits success on approval', () async {
      // Pre-load requests
      when(
        () => mockRepository.getAllPendingActivationRequests(),
      ).thenAnswer((_) async => Right([tRequest1, tRequest2]));
      when(
        () => mockRepository.approveActivationRequest(
          request: any(named: 'request'),
        ),
      ).thenAnswer((_) async => const Right(unit));

      bloc.add(const AdminActivationEvent.loadPendingRequests());

      // Wait for load to complete
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AdminActivationState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<AdminActivationState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.pendingRequests.length, 'count', 2),
        ]),
      );

      // Now approve request 1
      bloc.add(AdminActivationEvent.approveRequest(tRequest1));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          // processing state
          isA<AdminActivationState>().having(
            (s) => s.processingRequestIds.contains('req-1'),
            'processing req-1',
            true,
          ),
          // success — req-1 removed from list
          isA<AdminActivationState>()
              .having(
                (s) => s.processingRequestIds.contains('req-1'),
                'not processing',
                false,
              )
              .having((s) => s.pendingRequests.length, 'count after approve', 1)
              .having((s) => s.successMessage, 'successMessage', isNotNull),
        ]),
      );
    });

    test('emits error when approval fails', () async {
      when(
        () => mockRepository.getAllPendingActivationRequests(),
      ).thenAnswer((_) async => Right([tRequest1]));
      when(
        () => mockRepository.approveActivationRequest(
          request: any(named: 'request'),
        ),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Approval failed')));

      bloc.add(const AdminActivationEvent.loadPendingRequests());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AdminActivationState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<AdminActivationState>().having(
            (s) => s.isLoading,
            'isLoading',
            false,
          ),
        ]),
      );

      bloc.add(AdminActivationEvent.approveRequest(tRequest1));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AdminActivationState>().having(
            (s) => s.processingRequestIds.contains('req-1'),
            'processing',
            true,
          ),
          isA<AdminActivationState>()
              .having(
                (s) => s.processingRequestIds.contains('req-1'),
                'not processing',
                false,
              )
              .having((s) => s.error, 'error', isNotNull)
              .having((s) => s.pendingRequests.length, 'still has request', 1),
        ]),
      );
    });
  });

  group('RejectRequest', () {
    test('removes request from list on rejection', () async {
      when(
        () => mockRepository.getAllPendingActivationRequests(),
      ).thenAnswer((_) async => Right([tRequest1]));
      when(
        () => mockRepository.rejectActivationRequest(
          requestId: any(named: 'requestId'),
        ),
      ).thenAnswer((_) async => const Right(unit));

      bloc.add(const AdminActivationEvent.loadPendingRequests());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AdminActivationState>().having(
            (s) => s.isLoading,
            'isLoading',
            true,
          ),
          isA<AdminActivationState>().having(
            (s) => s.isLoading,
            'isLoading',
            false,
          ),
        ]),
      );

      bloc.add(const AdminActivationEvent.rejectRequest('req-1'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AdminActivationState>().having(
            (s) => s.processingRequestIds.contains('req-1'),
            'processing',
            true,
          ),
          isA<AdminActivationState>()
              .having(
                (s) => s.processingRequestIds.contains('req-1'),
                'not processing',
                false,
              )
              .having((s) => s.pendingRequests.length, 'count after reject', 0)
              .having((s) => s.successMessage, 'message', 'Request rejected'),
        ]),
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tkd_saas/core/shared/domain/entities/activation_request_entity.dart';
import 'package:tkd_saas/features/activation/domain/repositories/i_activation_repository.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_bloc.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_event.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_state.dart';

class MockActivationRepository extends Mock implements IActivationRepository {}

void main() {
  late ActivationBloc bloc;
  late MockActivationRepository mockRepository;

  setUp(() {
    mockRepository = MockActivationRepository();
    bloc = ActivationBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('Calculator Logic', () {
    test('initial state has 0 days and correct amounts', () {
      expect(bloc.state.requestedDays, 0);
      expect(bloc.state.totalAmount, 0);
      expect(bloc.state.discountAmount, 0);
    });

    test('adding 1 day sets 800 base and 50 discount', () {
      bloc.add(const ActivationEvent.addDays(1));

      expectLater(
        bloc.stream,
        emits(
          isA<ActivationState>()
              .having((s) => s.requestedDays, 'requestedDays', 1)
              .having((s) => s.totalAmount, 'totalAmount', 750)
              .having((s) => s.discountAmount, 'discountAmount', 50),
        ),
      );
    });

    test('adding 15 days sets 12000 base and 450 discount', () {
      bloc.add(const ActivationEvent.addDays(15));

      expectLater(
        bloc.stream,
        emits(
          isA<ActivationState>()
              .having((s) => s.requestedDays, 'requestedDays', 15)
              .having((s) => s.totalAmount, 'totalAmount', 11550)
              .having((s) => s.discountAmount, 'discountAmount', 450),
        ),
      );
    });

    test('adding 30 days sets discount capped at 450', () {
      bloc.add(const ActivationEvent.addDays(30));

      expectLater(
        bloc.stream,
        emits(
          isA<ActivationState>()
              .having((s) => s.requestedDays, 'requestedDays', 30)
              .having((s) => s.totalAmount, 'totalAmount', 23550)
              .having((s) => s.discountAmount, 'discountAmount', 450),
        ),
      );
    });
  });

  group('Submission Logic', () {
    final tEntity = ActivationRequestEntity(
      id: 'abc',
      userId: 'user-123',
      contactName: 'Test Name',
      requestedDays: 1,
      totalAmount: 750,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    test('does not submit if days <= 0', () async {
      bloc.add(const ActivationEvent.submitRequested());
      await Future.delayed(Duration.zero);
      verifyNever(
        () => mockRepository.submitActivationRequest(
          contactName: any(named: 'contactName'),
          requestedDays: any(named: 'requestedDays'),
          totalAmount: any(named: 'totalAmount'),
        ),
      );
    });

    test('submits successfully and clears fields', () {
      when(
        () => mockRepository.submitActivationRequest(
          contactName: any(named: 'contactName'),
          requestedDays: any(named: 'requestedDays'),
          totalAmount: any(named: 'totalAmount'),
        ),
      ).thenAnswer((_) async => Right(tEntity));

      bloc.add(const ActivationEvent.contactNameChanged('John Doe'));
      bloc.add(const ActivationEvent.addDays(1));
      bloc.add(const ActivationEvent.submitRequested());

      expectLater(
        bloc.stream,
        emitsInOrder([
          // 1. contactName changed
          isA<ActivationState>().having(
            (state) => state.contactName,
            'contact',
            'John Doe',
          ),
          // 2. add days
          isA<ActivationState>().having(
            (state) => state.requestedDays,
            'days',
            1,
          ),
          // 3. submit requested - loading
          isA<ActivationState>().having(
            (s) => s.isLoading,
            'loading true',
            true,
          ),
          // 4. completion
          isA<ActivationState>()
              .having((s) => s.isLoading, 'loading false', false)
              .having((s) => s.isSuccess, 'success true', true)
              .having((s) => s.requestedDays, 'days cleared', 0)
              .having((s) => s.contactName, 'name cleared', ''),
        ]),
      );
    });
  });
}

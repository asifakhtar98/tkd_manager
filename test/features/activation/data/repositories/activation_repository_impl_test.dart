import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/features/activation/data/datasources/activation_remote_datasource.dart';
import 'package:tkd_saas/features/activation/data/models/activation_request_model.dart';
import 'package:tkd_saas/features/activation/data/repositories/activation_repository_impl.dart';

class MockActivationRemoteDataSource extends Mock
    implements ActivationRemoteDataSource {}

void main() {
  late ActivationRepositoryImpl repository;
  late MockActivationRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockActivationRemoteDataSource();
    repository = ActivationRepositoryImpl(mockDataSource);
  });

  final tModel = ActivationRequestModel(
    id: 'abc',
    userId: 'user-123',
    contactName: 'Test',
    requestedDays: 1,
    totalAmount: 750,
    status: 'pending',
    createdAt: DateTime.now(),
  );

  group('submitActivationRequest', () {
    test(
      'returns ActivationRequestEntity when remote call is successful',
      () async {
        when(
          () => mockDataSource.submitActivationRequest(
            contactName: any(named: 'contactName'),
            requestedDays: any(named: 'requestedDays'),
            totalAmount: any(named: 'totalAmount'),
          ),
        ).thenAnswer((_) async => tModel);

        final result = await repository.submitActivationRequest(
          contactName: 'Test',
          requestedDays: 1,
          totalAmount: 750,
        );

        expect(result.isRight(), true);
        final entity = result.getRight().toNullable();
        expect(entity?.id, tModel.id);
        expect(entity?.contactName, tModel.contactName);
        expect(entity?.userId, tModel.userId);
      },
    );

    test('returns DatabaseFailure when PostgrestException is thrown', () async {
      when(
        () => mockDataSource.submitActivationRequest(
          contactName: any(named: 'contactName'),
          requestedDays: any(named: 'requestedDays'),
          totalAmount: any(named: 'totalAmount'),
        ),
      ).thenThrow(const PostgrestException(message: 'DB Error'));

      final result = await repository.submitActivationRequest(
        contactName: 'Test',
        requestedDays: 1,
        totalAmount: 750,
      );

      expect(result.isLeft(), true);
      expect(result.getLeft().toNullable(), isA<DatabaseFailure>());
      expect(result.getLeft().toNullable()?.message, 'DB Error');
    });

    test('returns ServerFailure when general Exception is thrown', () async {
      when(
        () => mockDataSource.submitActivationRequest(
          contactName: any(named: 'contactName'),
          requestedDays: any(named: 'requestedDays'),
          totalAmount: any(named: 'totalAmount'),
        ),
      ).thenThrow(Exception('Server crash'));

      final result = await repository.submitActivationRequest(
        contactName: 'Test',
        requestedDays: 1,
        totalAmount: 750,
      );

      expect(result.isLeft(), true);
      expect(result.getLeft().toNullable(), isA<ServerFailure>());
    });
  });
}

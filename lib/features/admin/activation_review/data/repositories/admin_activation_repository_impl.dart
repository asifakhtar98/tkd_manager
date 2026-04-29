import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/core/shared/domain/entities/activation_request_entity.dart';
import 'package:tkd_saas/core/shared/data/models/activation_request_model.dart';
import 'package:tkd_saas/features/admin/activation_review/domain/repositories/admin_activation_repository.dart';
import 'package:tkd_saas/features/admin/activation_review/data/datasources/admin_activation_remote_datasource.dart';
import 'package:tkd_saas/features/activation/data/datasources/activation_remote_datasource.dart';

@LazySingleton(as: IAdminActivationRepository)
class AdminActivationRepositoryImpl implements IAdminActivationRepository {
  final AdminActivationRemoteDataSource _remoteDataSource;
  final ActivationRemoteDataSource _activationRemoteDataSource;

  AdminActivationRepositoryImpl(
    this._remoteDataSource,
    this._activationRemoteDataSource,
  );

  @override
  Future<Either<Failure, List<ActivationRequestEntity>>>
  getAllPendingActivationRequests() async {
    try {
      final models = await _remoteDataSource
          .fetchAllPendingActivationRequests();
      return right(models.map((model) => model.toDomain()).toList());
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> approveActivationRequest({
    required ActivationRequestEntity request,
  }) async {
    try {
      final existingActivation = await _remoteDataSource
          .fetchUserActivationByUserId(request.userId);

      final nowUtc = DateTime.now().toUtc();
      late final DateTime expiresAt;

      if (existingActivation == null) {
        expiresAt = nowUtc.add(Duration(days: request.requestedDays));
        await _remoteDataSource.insertUserActivation(
          userId: request.userId,
          expiresAt: expiresAt,
        );
      } else {
        final isStillActive = existingActivation.expiresAt.isAfter(nowUtc);

        if (isStillActive) {
          expiresAt = existingActivation.expiresAt.add(
            Duration(days: request.requestedDays),
          );
        } else {
          expiresAt = nowUtc.add(Duration(days: request.requestedDays));
        }

        await _remoteDataSource.updateUserActivationExpiresAt(
          userId: existingActivation.userId,
          newExpiresAt: expiresAt,
        );
      }

      await _remoteDataSource.updateActivationRequestStatus(
        requestId: request.id,
        newStatus: 'approved',
      );

      unawaited(
        _activationRemoteDataSource.sendActivationApprovedEmail(
          activationRequestModel: ActivationRequestModel(
            id: request.id,
            userId: request.userId,
            contactName: request.contactName,
            requestedDays: request.requestedDays,
            totalAmount: request.totalAmount,
            status: 'approved',
            createdAt: request.createdAt,
            reviewedAt: nowUtc,
            billingInfo: request.billingInfo,
          ),
          approvedAt: nowUtc,
          expiresAt: expiresAt,
        ),
      );

      return right(unit);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> rejectActivationRequest({
    required String requestId,
  }) async {
    try {
      await _remoteDataSource.updateActivationRequestStatus(
        requestId: requestId,
        newStatus: 'rejected',
      );
      return right(unit);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}

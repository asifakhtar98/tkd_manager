import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/activation_request_entity.dart';
import '../../domain/entities/activation_status.dart';
import '../../domain/repositories/i_activation_repository.dart';
import '../datasources/activation_remote_datasource.dart';
import '../models/activation_request_model.dart';

@LazySingleton(as: IActivationRepository)
class ActivationRepositoryImpl implements IActivationRepository {
  final ActivationRemoteDataSource _remoteDataSource;

  ActivationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ActivationRequestEntity>> submitActivationRequest({
    required String contactName,
    required int requestedDays,
    required int totalAmount,
  }) async {
    try {
      final model = await _remoteDataSource.submitActivationRequest(
        contactName: contactName,
        requestedDays: requestedDays,
        totalAmount: totalAmount,
      );
      return right(model.toDomain());
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActivationStatus>>
  getActivationStatusForCurrentUser() async {
    try {
      // 1. Check if user has an active subscription
      final activationModel = await _remoteDataSource
          .fetchCurrentUserActivation();

      if (activationModel != null) {
        final isStillActive = activationModel.expiresAt.isAfter(
          DateTime.now().toUtc(),
        );
        if (isStillActive) {
          return right(
            ActivationStatusActive(expiresAt: activationModel.expiresAt),
          );
        }
      }

      // 2. No active subscription — check for pending requests
      final hasPendingRequest = await _remoteDataSource
          .hasCurrentUserPendingActivationRequest();
      if (hasPendingRequest) {
        return right(const ActivationStatusPendingReview());
      }

      // 3. Neither active nor pending
      return right(const ActivationStatusNotActivated());
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isCurrentUserAdmin() async {
    try {
      final isAdmin = await _remoteDataSource.isCurrentUserAdmin();
      return right(isAdmin);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

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
      // 1. Fetch existing user_activations row for the requesting user
      final existingActivation = await _remoteDataSource
          .fetchUserActivationByUserId(request.userId);

      final nowUtc = DateTime.now().toUtc();

      if (existingActivation == null) {
        // No existing activation — create new one starting from now
        final expiresAt = nowUtc.add(Duration(days: request.requestedDays));
        await _remoteDataSource.insertUserActivation(
          userId: request.userId,
          expiresAt: expiresAt,
        );
      } else {
        final isStillActive = existingActivation.expiresAt.isAfter(nowUtc);

        DateTime newExpiresAt;
        if (isStillActive) {
          // Still active — extend from current expiry
          newExpiresAt = existingActivation.expiresAt.add(
            Duration(days: request.requestedDays),
          );
        } else {
          // Expired — reset from now
          newExpiresAt = nowUtc.add(Duration(days: request.requestedDays));
        }

        await _remoteDataSource.updateUserActivationExpiresAt(
          userId: existingActivation.userId,
          newExpiresAt: newExpiresAt,
        );
      }

      // 2. Mark the request as approved
      await _remoteDataSource.updateActivationRequestStatus(
        requestId: request.id,
        newStatus: 'approved',
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

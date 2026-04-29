import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import 'package:tkd_saas/core/shared/domain/entities/activation_request_entity.dart';
import 'package:tkd_saas/core/shared/data/models/activation_request_model.dart';
import '../../domain/entities/activation_status.dart';
import '../../domain/repositories/i_activation_repository.dart';
import '../datasources/activation_remote_datasource.dart';

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
}

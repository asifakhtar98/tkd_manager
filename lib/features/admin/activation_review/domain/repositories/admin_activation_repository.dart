import 'package:fpdart/fpdart.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/core/shared/domain/entities/activation_request_entity.dart';

abstract class IAdminActivationRepository {
  /// Returns all activation requests with `status = 'pending'`.
  Future<Either<Failure, List<ActivationRequestEntity>>>
  getAllPendingActivationRequests();

  /// Approves an activation request and creates/extends the user's subscription.
  Future<Either<Failure, Unit>> approveActivationRequest({
    required ActivationRequestEntity request,
  });

  /// Rejects an activation request.
  Future<Either<Failure, Unit>> rejectActivationRequest({
    required String requestId,
  });
}

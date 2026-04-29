import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import 'package:tkd_saas/core/shared/domain/entities/activation_request_entity.dart';
import '../entities/activation_status.dart';

/// Contract for all activation-related data operations.
///
/// Handles the user-facing flow (submit request, check status).
/// Admin operations live in [IAdminActivationRepository].
abstract class IActivationRepository {
  /// Submits an activation request for the currently authenticated user.
  Future<Either<Failure, ActivationRequestEntity>> submitActivationRequest({
    required String contactName,
    required int requestedDays,
    required int totalAmount,
  });

  /// Returns the activation status of the currently authenticated user.
  ///
  /// Checks `user_activations` first, then falls back to pending requests
  /// in `activation_requests`.
  Future<Either<Failure, ActivationStatus>> getActivationStatusForCurrentUser();

  /// Returns `true` if the currently authenticated user is in the `admin_users` table.
  Future<Either<Failure, bool>> isCurrentUserAdmin();
}

import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/activation_request_entity.dart';
import '../entities/activation_status.dart';

/// Contract for all activation-related data operations.
///
/// Handles both the user-facing flow (submit request, check status) and
/// the admin flow (list pending requests, approve/reject).
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

  /// Returns all activation requests with `status = 'pending'`.
  ///
  /// Only callable by admin users (enforced by RLS).
  Future<Either<Failure, List<ActivationRequestEntity>>>
  getAllPendingActivationRequests();

  /// Approves an activation request and creates/extends the user's subscription.
  ///
  /// Business logic (all in Flutter):
  /// 1. Fetch `user_activations` for the request's `userId`.
  /// 2. If no record → INSERT with `expires_at = now + requestedDays`.
  /// 3. If record exists and still active → UPDATE `expires_at += requestedDays`.
  /// 4. If record exists but expired → UPDATE `expires_at = now + requestedDays`.
  /// 5. Set request status to `'approved'` and `reviewed_at = now`.
  Future<Either<Failure, Unit>> approveActivationRequest({
    required ActivationRequestEntity request,
  });

  /// Rejects an activation request (sets status to 'rejected' and reviewed_at).
  Future<Either<Failure, Unit>> rejectActivationRequest({
    required String requestId,
  });
}

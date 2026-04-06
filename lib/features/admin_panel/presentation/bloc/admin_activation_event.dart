import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/activation/domain/entities/activation_request_entity.dart';

part 'admin_activation_event.freezed.dart';

@freezed
abstract class AdminActivationEvent with _$AdminActivationEvent {
  /// Load all pending activation requests.
  const factory AdminActivationEvent.loadPendingRequests() =
      AdminActivationLoadPendingRequests;

  /// Admin approves a single activation request, creating/extending
  /// the user's subscription.
  const factory AdminActivationEvent.approveRequest(
    ActivationRequestEntity request,
  ) = AdminActivationApproveRequest;

  /// Admin rejects a single activation request.
  const factory AdminActivationEvent.rejectRequest(String requestId) =
      AdminActivationRejectRequest;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import 'package:tkd_saas/features/activation/domain/entities/activation_request_entity.dart';

part 'admin_activation_state.freezed.dart';

@freezed
abstract class AdminActivationState with _$AdminActivationState {
  const factory AdminActivationState({
    @Default(true) bool isLoading,
    @Default([]) List<ActivationRequestEntity> pendingRequests,

    /// Set of request IDs currently being processed (approve/reject in flight).
    @Default({}) Set<String> processingRequestIds,
    Failure? error,

    /// Transient success message, e.g. "Request approved successfully".
    String? successMessage,
  }) = _AdminActivationState;
}

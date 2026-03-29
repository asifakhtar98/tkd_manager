import 'package:freezed_annotation/freezed_annotation.dart';

part 'activation_status_event.freezed.dart';

@freezed
abstract class ActivationStatusEvent with _$ActivationStatusEvent {
  /// Fired when the dashboard mounts to fetch the user's activation status.
  const factory ActivationStatusEvent.loadRequested() =
      ActivationStatusLoadRequested;

  /// Fired when the user's admin role should be checked.
  const factory ActivationStatusEvent.adminCheckRequested() =
      ActivationStatusAdminCheckRequested;

  /// Fired when the user signs out to clear state.
  const factory ActivationStatusEvent.clearRequested() =
      ActivationStatusClearRequested;
}

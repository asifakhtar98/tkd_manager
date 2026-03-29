import 'package:freezed_annotation/freezed_annotation.dart';

part 'activation_event.freezed.dart';

@freezed
abstract class ActivationEvent with _$ActivationEvent {
  const factory ActivationEvent.addDays(int days) = _AddDays;
  const factory ActivationEvent.setDays(int days) = _SetDays;
  const factory ActivationEvent.clearDays() = _ClearDays;
  const factory ActivationEvent.contactNameChanged(String name) =
      _ContactNameChanged;
  const factory ActivationEvent.submitRequested() = _SubmitRequested;
}

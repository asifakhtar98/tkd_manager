import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/activation_status.dart';

part 'activation_status_state.freezed.dart';

@freezed
abstract class ActivationStatusState with _$ActivationStatusState {
  const factory ActivationStatusState({
    @Default(true) bool isLoading,
    ActivationStatus? activationStatus,
    @Default(false) bool isAdmin,
    Failure? error,
  }) = _ActivationStatusState;
}

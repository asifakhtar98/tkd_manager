import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';

part 'activation_state.freezed.dart';

@freezed
abstract class ActivationState with _$ActivationState {
  const factory ActivationState({
    @Default(0) int requestedDays,
    @Default('') String contactName,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    Failure? error,
  }) = _ActivationState;

  const ActivationState._();

  int get discountPercentage {
    if (requestedDays >= 365) return 50;
    if (requestedDays >= 30) return 25;
    if (requestedDays >= 15) return 15;
    return 0;
  }

  int get totalAmount {
    if (requestedDays <= 0) return 0;
    int baseCost = requestedDays * 800;
    return baseCost - discountAmount;
  }

  int get discountAmount {
    if (requestedDays <= 0) return 0;

    int baseCost = requestedDays * 800;

    if (requestedDays < 15) {
      // Direct discount of 50rs per day for less than 15 days
      return 50 * requestedDays;
    }

    // Percentage discount for 15 or more days
    return (baseCost * (discountPercentage / 100)).toInt();
  }
}

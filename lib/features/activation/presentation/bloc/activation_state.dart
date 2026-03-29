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

  int get totalAmount {
    if (requestedDays <= 0) return 0;

    // Base cost is 800 per day
    int baseCost = requestedDays * 800;

    // Discount is 50 * number of days, capped at 450
    int discount = (50 * requestedDays).clamp(0, 450).toInt();

    return baseCost - discount;
  }

  int get discountAmount {
    if (requestedDays <= 0) return 0;
    return (50 * requestedDays).clamp(0, 450).toInt();
  }
}

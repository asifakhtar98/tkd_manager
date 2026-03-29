import 'package:freezed_annotation/freezed_annotation.dart';

part 'activation_request_entity.freezed.dart';

@freezed
abstract class ActivationRequestEntity with _$ActivationRequestEntity {
  const factory ActivationRequestEntity({
    required String id,
    required String userId,
    required String contactName,
    required int requestedDays,
    required int totalAmount,
    required String status,
    required DateTime createdAt,
    DateTime? reviewedAt,
  }) = _ActivationRequestEntity;
}

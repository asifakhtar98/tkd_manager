import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/activation_request_entity.dart';

part 'activation_request_model.freezed.dart';
part 'activation_request_model.g.dart';

@freezed
abstract class ActivationRequestModel with _$ActivationRequestModel {
  const factory ActivationRequestModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'contact_name') required String contactName,
    @JsonKey(name: 'requested_days') required int requestedDays,
    @JsonKey(name: 'total_amount') required int totalAmount,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
  }) = _ActivationRequestModel;

  factory ActivationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ActivationRequestModelFromJson(json);
}

extension ActivationRequestModelToDomain on ActivationRequestModel {
  ActivationRequestEntity toDomain() {
    return ActivationRequestEntity(
      id: id,
      userId: userId,
      contactName: contactName,
      requestedDays: requestedDays,
      totalAmount: totalAmount,
      status: status,
      createdAt: createdAt,
      reviewedAt: reviewedAt,
    );
  }
}

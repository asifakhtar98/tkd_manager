// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivationRequestModel _$ActivationRequestModelFromJson(
  Map<String, dynamic> json,
) => _ActivationRequestModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  contactName: json['contact_name'] as String,
  requestedDays: (json['requested_days'] as num).toInt(),
  totalAmount: (json['total_amount'] as num).toInt(),
  status: json['status'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  reviewedAt: json['reviewed_at'] == null
      ? null
      : DateTime.parse(json['reviewed_at'] as String),
);

Map<String, dynamic> _$ActivationRequestModelToJson(
  _ActivationRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'contact_name': instance.contactName,
  'requested_days': instance.requestedDays,
  'total_amount': instance.totalAmount,
  'status': instance.status,
  'created_at': instance.createdAt.toIso8601String(),
  'reviewed_at': instance.reviewedAt?.toIso8601String(),
};

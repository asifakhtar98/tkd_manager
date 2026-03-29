// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserActivationModel _$UserActivationModelFromJson(Map<String, dynamic> json) =>
    _UserActivationModel(
      userId: json['user_id'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserActivationModelToJson(
  _UserActivationModel instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'expires_at': instance.expiresAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

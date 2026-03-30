// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bracket_theme_preset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BracketThemePresetModel _$BracketThemePresetModelFromJson(
  Map<String, dynamic> json,
) => _BracketThemePresetModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  themeConfig: TieSheetThemeConfig.fromJson(
    json['theme_config'] as Map<String, dynamic>,
  ),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$BracketThemePresetModelToJson(
  _BracketThemePresetModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'theme_config': instance.themeConfig.toJson(),
  'created_at': instance.createdAt.toIso8601String(),
};

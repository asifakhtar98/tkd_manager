// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bracket_classification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BracketClassification _$BracketClassificationFromJson(
  Map<String, dynamic> json,
) => _BracketClassification(
  ageCategoryLabel: json['ageCategoryLabel'] as String? ?? '',
  genderLabel: json['genderLabel'] as String? ?? '',
  weightDivisionLabel: json['weightDivisionLabel'] as String? ?? '',
);

Map<String, dynamic> _$BracketClassificationToJson(
  _BracketClassification instance,
) => <String, dynamic>{
  'ageCategoryLabel': instance.ageCategoryLabel,
  'genderLabel': instance.genderLabel,
  'weightDivisionLabel': instance.weightDivisionLabel,
};

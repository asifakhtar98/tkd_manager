// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bracket_generation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BracketGenerationResult _$BracketGenerationResultFromJson(
  Map<String, dynamic> json,
) => _BracketGenerationResult(
  bracket: BracketEntity.fromJson(json['bracket'] as Map<String, dynamic>),
  matches: (json['matches'] as List<dynamic>)
      .map((e) => MatchEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BracketGenerationResultToJson(
  _BracketGenerationResult instance,
) => <String, dynamic>{
  'bracket': instance.bracket.toJson(),
  'matches': instance.matches.map((e) => e.toJson()).toList(),
};

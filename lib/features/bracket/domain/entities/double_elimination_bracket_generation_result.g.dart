// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'double_elimination_bracket_generation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoubleEliminationBracketGenerationResult
_$DoubleEliminationBracketGenerationResultFromJson(Map<String, dynamic> json) =>
    _DoubleEliminationBracketGenerationResult(
      winnersBracket: BracketEntity.fromJson(
        json['winnersBracket'] as Map<String, dynamic>,
      ),
      losersBracket: BracketEntity.fromJson(
        json['losersBracket'] as Map<String, dynamic>,
      ),
      grandFinalsMatch: MatchEntity.fromJson(
        json['grandFinalsMatch'] as Map<String, dynamic>,
      ),
      resetMatch: json['resetMatch'] == null
          ? null
          : MatchEntity.fromJson(json['resetMatch'] as Map<String, dynamic>),
      allMatches: (json['allMatches'] as List<dynamic>)
          .map((e) => MatchEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DoubleEliminationBracketGenerationResultToJson(
  _DoubleEliminationBracketGenerationResult instance,
) => <String, dynamic>{
  'winnersBracket': instance.winnersBracket.toJson(),
  'losersBracket': instance.losersBracket.toJson(),
  'grandFinalsMatch': instance.grandFinalsMatch.toJson(),
  'resetMatch': instance.resetMatch?.toJson(),
  'allMatches': instance.allMatches.map((e) => e.toJson()).toList(),
};

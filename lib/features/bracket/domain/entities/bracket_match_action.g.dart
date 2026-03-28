// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bracket_match_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BracketMatchAction _$BracketMatchActionFromJson(Map<String, dynamic> json) =>
    _BracketMatchAction(
      matchId: json['matchId'] as String,
      winnerId: json['winnerId'] as String,
      resultType: $enumDecode(_$MatchResultTypeEnumMap, json['resultType']),
      blueScore: (json['blueScore'] as num?)?.toInt(),
      redScore: (json['redScore'] as num?)?.toInt(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      displayLabel: json['displayLabel'] as String,
    );

Map<String, dynamic> _$BracketMatchActionToJson(_BracketMatchAction instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'winnerId': instance.winnerId,
      'resultType': _$MatchResultTypeEnumMap[instance.resultType]!,
      'blueScore': instance.blueScore,
      'redScore': instance.redScore,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'displayLabel': instance.displayLabel,
    };

const _$MatchResultTypeEnumMap = {
  MatchResultType.points: 'points',
  MatchResultType.knockout: 'knockout',
  MatchResultType.disqualification: 'disqualification',
  MatchResultType.withdrawal: 'withdrawal',
  MatchResultType.refereeDecision: 'referee_decision',
  MatchResultType.bye: 'bye',
};

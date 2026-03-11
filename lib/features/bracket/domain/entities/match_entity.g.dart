// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchEntity _$MatchEntityFromJson(Map<String, dynamic> json) => _MatchEntity(
  id: json['id'] as String,
  bracketId: json['bracketId'] as String,
  roundNumber: (json['roundNumber'] as num).toInt(),
  matchNumberInRound: (json['matchNumberInRound'] as num).toInt(),
  createdAtTimestamp: DateTime.parse(json['createdAtTimestamp'] as String),
  updatedAtTimestamp: DateTime.parse(json['updatedAtTimestamp'] as String),
  participantRedId: json['participantRedId'] as String?,
  participantBlueId: json['participantBlueId'] as String?,
  winnerId: json['winnerId'] as String?,
  winnerAdvancesToMatchId: json['winnerAdvancesToMatchId'] as String?,
  loserAdvancesToMatchId: json['loserAdvancesToMatchId'] as String?,
  scheduledRingNumber: (json['scheduledRingNumber'] as num?)?.toInt(),
  scheduledTime: json['scheduledTime'] == null
      ? null
      : DateTime.parse(json['scheduledTime'] as String),
  status:
      $enumDecodeNullable(_$MatchStatusEnumMap, json['status']) ??
      MatchStatus.pending,
  resultType: $enumDecodeNullable(_$MatchResultTypeEnumMap, json['resultType']),
  notes: json['notes'] as String?,
  blueScore: (json['blueScore'] as num?)?.toInt(),
  redScore: (json['redScore'] as num?)?.toInt(),
  startedAtTimestamp: json['startedAtTimestamp'] == null
      ? null
      : DateTime.parse(json['startedAtTimestamp'] as String),
  completedAtTimestamp: json['completedAtTimestamp'] == null
      ? null
      : DateTime.parse(json['completedAtTimestamp'] as String),
  syncVersion: (json['syncVersion'] as num?)?.toInt() ?? 1,
  isDeleted: json['isDeleted'] as bool? ?? false,
  deletedAtTimestamp: json['deletedAtTimestamp'] == null
      ? null
      : DateTime.parse(json['deletedAtTimestamp'] as String),
  isDemoData: json['isDemoData'] as bool? ?? false,
);

Map<String, dynamic> _$MatchEntityToJson(_MatchEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bracketId': instance.bracketId,
      'roundNumber': instance.roundNumber,
      'matchNumberInRound': instance.matchNumberInRound,
      'createdAtTimestamp': instance.createdAtTimestamp.toIso8601String(),
      'updatedAtTimestamp': instance.updatedAtTimestamp.toIso8601String(),
      'participantRedId': instance.participantRedId,
      'participantBlueId': instance.participantBlueId,
      'winnerId': instance.winnerId,
      'winnerAdvancesToMatchId': instance.winnerAdvancesToMatchId,
      'loserAdvancesToMatchId': instance.loserAdvancesToMatchId,
      'scheduledRingNumber': instance.scheduledRingNumber,
      'scheduledTime': instance.scheduledTime?.toIso8601String(),
      'status': _$MatchStatusEnumMap[instance.status]!,
      'resultType': _$MatchResultTypeEnumMap[instance.resultType],
      'notes': instance.notes,
      'blueScore': instance.blueScore,
      'redScore': instance.redScore,
      'startedAtTimestamp': instance.startedAtTimestamp?.toIso8601String(),
      'completedAtTimestamp': instance.completedAtTimestamp?.toIso8601String(),
      'syncVersion': instance.syncVersion,
      'isDeleted': instance.isDeleted,
      'deletedAtTimestamp': instance.deletedAtTimestamp?.toIso8601String(),
      'isDemoData': instance.isDemoData,
    };

const _$MatchStatusEnumMap = {
  MatchStatus.pending: 'pending',
  MatchStatus.ready: 'ready',
  MatchStatus.inProgress: 'in_progress',
  MatchStatus.completed: 'completed',
  MatchStatus.cancelled: 'cancelled',
};

const _$MatchResultTypeEnumMap = {
  MatchResultType.points: 'points',
  MatchResultType.knockout: 'knockout',
  MatchResultType.disqualification: 'disqualification',
  MatchResultType.withdrawal: 'withdrawal',
  MatchResultType.refereeDecision: 'referee_decision',
  MatchResultType.bye: 'bye',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bracket_snapshot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BracketSnapshotModel _$BracketSnapshotModelFromJson(
  Map<String, dynamic> json,
) => _BracketSnapshotModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  tournamentId: json['tournament_id'] as String,
  label: json['label'] as String,
  format: $enumDecode(_$BracketFormatEnumMap, json['format']),
  participantCount: (json['participant_count'] as num).toInt(),
  includeThirdPlaceMatch: json['include_third_place_match'] as bool,
  dojangSeparation: json['dojang_separation'] as bool,
  classification: json['classification'] == null
      ? const BracketClassification()
      : BracketClassification.fromJson(
          json['classification'] as Map<String, dynamic>,
        ),
  generatedAt: DateTime.parse(json['generated_at'] as String),
  participants: (json['participants'] as List<dynamic>)
      .map((e) => ParticipantEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  result: BracketResult.fromJson(json['result'] as Map<String, dynamic>),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  actionHistory:
      (json['action_history'] as List<dynamic>?)
          ?.map((e) => BracketHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$BracketSnapshotModelToJson(
  _BracketSnapshotModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'tournament_id': instance.tournamentId,
  'label': instance.label,
  'format': _$BracketFormatEnumMap[instance.format]!,
  'participant_count': instance.participantCount,
  'include_third_place_match': instance.includeThirdPlaceMatch,
  'dojang_separation': instance.dojangSeparation,
  'classification': instance.classification.toJson(),
  'generated_at': instance.generatedAt.toIso8601String(),
  'participants': instance.participants.map((e) => e.toJson()).toList(),
  'result': instance.result.toJson(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'action_history': instance.actionHistory.map((e) => e.toJson()).toList(),
};

const _$BracketFormatEnumMap = {
  BracketFormat.singleElimination: 'singleElimination',
  BracketFormat.doubleElimination: 'doubleElimination',
};

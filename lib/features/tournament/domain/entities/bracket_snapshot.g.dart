// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bracket_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BracketSnapshot _$BracketSnapshotFromJson(Map<String, dynamic> json) =>
    _BracketSnapshot(
      id: json['id'] as String,
      userId: json['userId'] as String,
      tournamentId: json['tournamentId'] as String,
      label: json['label'] as String,
      format: $enumDecode(_$BracketFormatEnumMap, json['format']),
      participantCount: (json['participantCount'] as num).toInt(),
      includeThirdPlaceMatch: json['includeThirdPlaceMatch'] as bool,
      dojangSeparation: json['dojangSeparation'] as bool,
      classification: json['classification'] == null
          ? const BracketClassification()
          : BracketClassification.fromJson(
              json['classification'] as Map<String, dynamic>,
            ),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => ParticipantEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      result: BracketResult.fromJson(json['result'] as Map<String, dynamic>),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BracketSnapshotToJson(_BracketSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'tournamentId': instance.tournamentId,
      'label': instance.label,
      'format': _$BracketFormatEnumMap[instance.format]!,
      'participantCount': instance.participantCount,
      'includeThirdPlaceMatch': instance.includeThirdPlaceMatch,
      'dojangSeparation': instance.dojangSeparation,
      'classification': instance.classification.toJson(),
      'generatedAt': instance.generatedAt.toIso8601String(),
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'result': instance.result.toJson(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$BracketFormatEnumMap = {
  BracketFormat.singleElimination: 'singleElimination',
  BracketFormat.doubleElimination: 'doubleElimination',
};

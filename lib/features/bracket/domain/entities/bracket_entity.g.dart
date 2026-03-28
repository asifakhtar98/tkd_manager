// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bracket_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BracketEntity _$BracketEntityFromJson(Map<String, dynamic> json) =>
    _BracketEntity(
      id: json['id'] as String,
      genderId: json['genderId'] as String,
      bracketType: $enumDecode(_$BracketTypeEnumMap, json['bracketType']),
      totalRounds: (json['totalRounds'] as num).toInt(),
      createdAtTimestamp: DateTime.parse(json['createdAtTimestamp'] as String),
      updatedAtTimestamp: DateTime.parse(json['updatedAtTimestamp'] as String),
      poolIdentifier: json['poolIdentifier'] as String?,
      isFinalized: json['isFinalized'] as bool? ?? false,
      generatedAtTimestamp: json['generatedAtTimestamp'] == null
          ? null
          : DateTime.parse(json['generatedAtTimestamp'] as String),
      finalizedAtTimestamp: json['finalizedAtTimestamp'] == null
          ? null
          : DateTime.parse(json['finalizedAtTimestamp'] as String),
      bracketDataJson: json['bracketDataJson'] as Map<String, dynamic>?,
      syncVersion: (json['syncVersion'] as num?)?.toInt() ?? 1,
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAtTimestamp: json['deletedAtTimestamp'] == null
          ? null
          : DateTime.parse(json['deletedAtTimestamp'] as String),
      finalMedalPlacements: (json['finalMedalPlacements'] as List<dynamic>?)
          ?.map(
            (e) =>
                BracketMedalPlacementEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$BracketEntityToJson(_BracketEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'genderId': instance.genderId,
      'bracketType': _$BracketTypeEnumMap[instance.bracketType]!,
      'totalRounds': instance.totalRounds,
      'createdAtTimestamp': instance.createdAtTimestamp.toIso8601String(),
      'updatedAtTimestamp': instance.updatedAtTimestamp.toIso8601String(),
      'poolIdentifier': instance.poolIdentifier,
      'isFinalized': instance.isFinalized,
      'generatedAtTimestamp': instance.generatedAtTimestamp?.toIso8601String(),
      'finalizedAtTimestamp': instance.finalizedAtTimestamp?.toIso8601String(),
      'bracketDataJson': instance.bracketDataJson,
      'syncVersion': instance.syncVersion,
      'isDeleted': instance.isDeleted,
      'deletedAtTimestamp': instance.deletedAtTimestamp?.toIso8601String(),
      'finalMedalPlacements': instance.finalMedalPlacements
          ?.map((e) => e.toJson())
          .toList(),
    };

const _$BracketTypeEnumMap = {
  BracketType.winners: 'winners',
  BracketType.losers: 'losers',
  BracketType.pool: 'pool',
};

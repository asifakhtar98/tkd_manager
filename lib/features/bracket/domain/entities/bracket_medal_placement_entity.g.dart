// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bracket_medal_placement_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BracketMedalPlacementEntity _$BracketMedalPlacementEntityFromJson(
  Map<String, dynamic> json,
) => _BracketMedalPlacementEntity(
  participantId: json['participantId'] as String,
  rankStatus: (json['rankStatus'] as num).toInt(),
  displayPlacementLabel: json['displayPlacementLabel'] as String,
);

Map<String, dynamic> _$BracketMedalPlacementEntityToJson(
  _BracketMedalPlacementEntity instance,
) => <String, dynamic>{
  'participantId': instance.participantId,
  'rankStatus': instance.rankStatus,
  'displayPlacementLabel': instance.displayPlacementLabel,
};

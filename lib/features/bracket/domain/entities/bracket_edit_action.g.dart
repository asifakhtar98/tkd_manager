// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bracket_edit_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BracketEditActionParticipantSlotSwapped
_$BracketEditActionParticipantSlotSwappedFromJson(Map<String, dynamic> json) =>
    BracketEditActionParticipantSlotSwapped(
      sourceMatchId: json['sourceMatchId'] as String,
      sourceSlotPosition: json['sourceSlotPosition'] as String,
      targetMatchId: json['targetMatchId'] as String,
      targetSlotPosition: json['targetSlotPosition'] as String,
      displayLabel: json['displayLabel'] as String,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$BracketEditActionParticipantSlotSwappedToJson(
  BracketEditActionParticipantSlotSwapped instance,
) => <String, dynamic>{
  'sourceMatchId': instance.sourceMatchId,
  'sourceSlotPosition': instance.sourceSlotPosition,
  'targetMatchId': instance.targetMatchId,
  'targetSlotPosition': instance.targetSlotPosition,
  'displayLabel': instance.displayLabel,
  'recordedAt': instance.recordedAt.toIso8601String(),
  'runtimeType': instance.$type,
};

BracketEditActionParticipantDetailsUpdated
_$BracketEditActionParticipantDetailsUpdatedFromJson(
  Map<String, dynamic> json,
) => BracketEditActionParticipantDetailsUpdated(
  participantId: json['participantId'] as String,
  updatedFullName: json['updatedFullName'] as String,
  updatedRegistrationId: json['updatedRegistrationId'] as String?,
  displayLabel: json['displayLabel'] as String,
  recordedAt: DateTime.parse(json['recordedAt'] as String),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$BracketEditActionParticipantDetailsUpdatedToJson(
  BracketEditActionParticipantDetailsUpdated instance,
) => <String, dynamic>{
  'participantId': instance.participantId,
  'updatedFullName': instance.updatedFullName,
  'updatedRegistrationId': instance.updatedRegistrationId,
  'displayLabel': instance.displayLabel,
  'recordedAt': instance.recordedAt.toIso8601String(),
  'runtimeType': instance.$type,
};

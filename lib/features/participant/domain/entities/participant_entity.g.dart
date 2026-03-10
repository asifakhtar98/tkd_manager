// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParticipantEntity _$ParticipantEntityFromJson(Map<String, dynamic> json) =>
    _ParticipantEntity(
      id: json['id'] as String,
      divisionId: json['divisionId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      schoolOrDojangName: json['schoolOrDojangName'] as String?,
      beltRank: json['beltRank'] as String?,
      registrationId: json['registrationId'] as String?,
      seedNumber: (json['seedNumber'] as num?)?.toInt(),
      isBye: json['isBye'] as bool? ?? false,
    );

Map<String, dynamic> _$ParticipantEntityToJson(_ParticipantEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'divisionId': instance.divisionId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'schoolOrDojangName': instance.schoolOrDojangName,
      'beltRank': instance.beltRank,
      'registrationId': instance.registrationId,
      'seedNumber': instance.seedNumber,
      'isBye': instance.isBye,
    };

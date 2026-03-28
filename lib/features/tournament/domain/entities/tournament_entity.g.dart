// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TournamentEntity _$TournamentEntityFromJson(
  Map<String, dynamic> json,
) => _TournamentEntity(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  dateRange: json['dateRange'] as String? ?? '',
  venue: json['venue'] as String? ?? '',
  organizer: json['organizer'] as String? ?? '',
  rightLogoUrl:
      json['rightLogoUrl'] as String? ??
      'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/India_Taekwondo_logo_5346.png',
  leftLogoUrl:
      json['leftLogoUrl'] as String? ??
      'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/World_Taekwondo+logo_356345.png',
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TournamentEntityToJson(_TournamentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'dateRange': instance.dateRange,
      'venue': instance.venue,
      'organizer': instance.organizer,
      'rightLogoUrl': instance.rightLogoUrl,
      'leftLogoUrl': instance.leftLogoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

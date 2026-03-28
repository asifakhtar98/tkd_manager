// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TournamentModel _$TournamentModelFromJson(
  Map<String, dynamic> json,
) => _TournamentModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  dateRange: json['date_range'] as String? ?? '',
  venue: json['venue'] as String? ?? '',
  organizer: json['organizer'] as String? ?? '',
  rightLogoUrl:
      json['right_logo_url'] as String? ??
      'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/India_Taekwondo_logo_5346.png',
  leftLogoUrl:
      json['left_logo_url'] as String? ??
      'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/World_Taekwondo+logo_356345.png',
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TournamentModelToJson(_TournamentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'date_range': instance.dateRange,
      'venue': instance.venue,
      'organizer': instance.organizer,
      'right_logo_url': instance.rightLogoUrl,
      'left_logo_url': instance.leftLogoUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

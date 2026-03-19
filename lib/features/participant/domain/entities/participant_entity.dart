import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_entity.freezed.dart';
part 'participant_entity.g.dart';

@freezed
abstract class ParticipantEntity with _$ParticipantEntity {
  const factory ParticipantEntity({
    required String id,
    required String genderId,
    required String fullName,
    String? schoolOrDojangName,
    String? beltRank,
    String? registrationId,
    int? seedNumber,
    @Default(false) bool isBye,
  }) = _ParticipantEntity;

  factory ParticipantEntity.fromJson(Map<String, dynamic> json) =>
      _$ParticipantEntityFromJson(json);
}

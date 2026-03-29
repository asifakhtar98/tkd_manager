import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_classification.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';

part 'bracket_snapshot_model.freezed.dart';
part 'bracket_snapshot_model.g.dart';

@freezed
abstract class BracketSnapshotModel with _$BracketSnapshotModel {
  const BracketSnapshotModel._();

  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory BracketSnapshotModel({
    required String id,
    required String userId,
    required String tournamentId,
    required String label,
    required BracketFormat format,
    required int participantCount,
    required bool includeThirdPlaceMatch,
    required bool dojangSeparation,
    @Default(BracketClassification()) BracketClassification classification,
    required DateTime generatedAt,
    required List<ParticipantEntity> participants,
    required BracketResult result,
    required DateTime updatedAt,
  }) = _BracketSnapshotModel;

  factory BracketSnapshotModel.fromJson(Map<String, dynamic> json) =>
      _$BracketSnapshotModelFromJson(json);

  factory BracketSnapshotModel.fromEntity(BracketSnapshot entity) {
    return BracketSnapshotModel(
      id: entity.id,
      userId: entity.userId,
      tournamentId: entity.tournamentId,
      label: entity.label,
      format: entity.format,
      participantCount: entity.participantCount,
      includeThirdPlaceMatch: entity.includeThirdPlaceMatch,
      dojangSeparation: entity.dojangSeparation,
      classification: entity.classification,
      generatedAt: entity.generatedAt,
      participants: entity.participants,
      result: entity.result,
      updatedAt: entity.updatedAt,
    );
  }
}

extension BracketSnapshotModelToEntity on BracketSnapshotModel {
  BracketSnapshot toEntity() {
    return BracketSnapshot(
      id: id,
      userId: userId,
      tournamentId: tournamentId,
      label: label,
      format: format,
      participantCount: participantCount,
      includeThirdPlaceMatch: includeThirdPlaceMatch,
      dojangSeparation: dojangSeparation,
      classification: classification,
      generatedAt: generatedAt,
      participants: participants,
      result: result,
      updatedAt: updatedAt,
    );
  }
}

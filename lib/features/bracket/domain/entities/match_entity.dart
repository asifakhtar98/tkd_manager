import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_entity.freezed.dart';
part 'match_entity.g.dart';

/// Match lifecycle status.
@JsonEnum(valueField: 'value')
enum MatchStatus {
  pending('pending'),
  ready('ready'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled');

  const MatchStatus(this.value);
  final String value;
}

/// How a match was decided.
@JsonEnum(valueField: 'value')
enum MatchResultType {
  points('points'),
  knockout('knockout'),
  disqualification('disqualification'),
  withdrawal('withdrawal'),
  refereeDecision('referee_decision'),
  bye('bye');

  const MatchResultType(this.value);
  final String value;
}

@freezed
abstract class MatchEntity with _$MatchEntity {
  const factory MatchEntity({
    required String id,
    required String bracketId,
    required int roundNumber,
    required int matchNumberInRound,
    required DateTime createdAtTimestamp,
    required DateTime updatedAtTimestamp,
    String? participantRedId,
    String? participantBlueId,
    String? winnerId,
    String? winnerAdvancesToMatchId,
    String? loserAdvancesToMatchId,
    int? scheduledRingNumber,
    DateTime? scheduledTime,
    @Default(MatchStatus.pending) MatchStatus status,
    MatchResultType? resultType,
    String? notes,
    DateTime? startedAtTimestamp,
    DateTime? completedAtTimestamp,
    @Default(1) int syncVersion,
    @Default(false) bool isDeleted,
    DateTime? deletedAtTimestamp,
    @Default(false) bool isDemoData,
  }) = _MatchEntity;

  factory MatchEntity.fromJson(Map<String, dynamic> json) =>
      _$MatchEntityFromJson(json);
}

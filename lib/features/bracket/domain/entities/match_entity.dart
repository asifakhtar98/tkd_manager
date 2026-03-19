import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_entity.freezed.dart';
part 'match_entity.g.dart';

/// Match lifecycle status — tracks how far along a match is from creation
/// through completion or cancellation.
@JsonEnum(valueField: 'value')
enum MatchStatus {
  /// Match created but participants not yet assigned.
  pending('pending'),

  /// Both participants assigned; waiting to start.
  ready('ready'),

  /// Match is actively being fought.
  inProgress('in_progress'),

  /// Match finished with a recorded result.
  completed('completed'),

  /// Match was cancelled before completion.
  cancelled('cancelled');

  const MatchStatus(this.value);
  final String value;

  /// Human-readable label for UI display purposes.
  String get displayName => switch (this) {
    MatchStatus.pending => 'Pending',
    MatchStatus.ready => 'Ready',
    MatchStatus.inProgress => 'In Progress',
    MatchStatus.completed => 'Completed',
    MatchStatus.cancelled => 'Cancelled',
  };
}

/// How a match was decided — describes the method of victory.
@JsonEnum(valueField: 'value')
enum MatchResultType {
  /// Won by point differential within regulation time.
  points('points'),

  /// Won by knockout (KO) during the match.
  knockout('knockout'),

  /// Opponent disqualified for rules violation.
  disqualification('disqualification'),

  /// Opponent withdrew from the match voluntarily.
  withdrawal('withdrawal'),

  /// Official referee decision (e.g., golden point, video review).
  refereeDecision('referee_decision'),

  /// Automatic advancement — opponent slot was empty (BYE).
  bye('bye');

  const MatchResultType(this.value);
  final String value;

  /// Human-readable label for UI display purposes.
  String get displayName => switch (this) {
    MatchResultType.points => 'Points',
    MatchResultType.knockout => 'Knockout',
    MatchResultType.disqualification => 'Disqualification',
    MatchResultType.withdrawal => 'Withdrawal',
    MatchResultType.refereeDecision => 'Referee Decision',
    MatchResultType.bye => 'BYE',
  };
}

/// A single match within a bracket, tracking participants, scoring, and results.
@freezed
abstract class MatchEntity with _$MatchEntity {
  const MatchEntity._();

  const factory MatchEntity({
    /// Unique identifier for this match (UUID v4).
    required String id,

    /// The bracket this match belongs to.
    required String bracketId,

    /// 1-based round number within the bracket.
    required int roundNumber,

    /// 1-based position of this match within its round.
    required int matchNumberInRound,

    /// Timestamp when the match record was created.
    required DateTime createdAtTimestamp,

    /// Timestamp of the most recent update.
    required DateTime updatedAtTimestamp,

    /// ID of the participant in the red corner (null if unassigned / BYE).
    String? participantRedId,

    /// ID of the participant in the blue corner (null if unassigned / BYE).
    String? participantBlueId,

    /// ID of the victorious participant (null until result is recorded).
    String? winnerId,

    /// Match ID to which the winner advances (null for final match).
    String? winnerAdvancesToMatchId,

    /// Match ID to which the loser drops (only in double-elimination).
    String? loserAdvancesToMatchId,

    /// Assigned ring / mat number for the match.
    int? scheduledRingNumber,

    /// Scheduled start time.
    DateTime? scheduledTime,

    /// Current lifecycle status of the match.
    @Default(MatchStatus.pending) MatchStatus status,

    /// How the match was decided (null if not yet completed).
    MatchResultType? resultType,

    /// Free-form notes attached to the match.
    String? notes,

    /// Score awarded to the blue-corner participant.
    int? blueScore,

    /// Score awarded to the red-corner participant.
    int? redScore,

    /// Timestamp when the match started.
    DateTime? startedAtTimestamp,

    /// Timestamp when the match was completed.
    DateTime? completedAtTimestamp,

    /// Optimistic concurrency version counter.
    @Default(1) int syncVersion,

    /// Soft-delete flag.
    @Default(false) bool isDeleted,

    /// Timestamp of soft deletion, if applicable.
    DateTime? deletedAtTimestamp,

    /// Whether this match was created from demo/sample data.
    @Default(false) bool isDemoData,
  }) = _MatchEntity;

  factory MatchEntity.fromJson(Map<String, dynamic> json) =>
      _$MatchEntityFromJson(json);

  // ─────────────────────────────────────────
  // Convenience Getters
  // ─────────────────────────────────────────

  /// True when the match has a recorded winner.
  bool get hasWinner => winnerId != null;

  /// True when the match has been completed.
  bool get isCompleted => status == MatchStatus.completed;

  /// True when the match is still pending (no participants assigned yet).
  bool get isPending => status == MatchStatus.pending;

  /// True when this match represents a BYE (automatic advancement).
  bool get isBye => resultType == MatchResultType.bye;

  /// True when both participant slots are filled and the match is ready.
  bool get hasBothParticipantsAssigned =>
      participantRedId != null && participantBlueId != null;
}

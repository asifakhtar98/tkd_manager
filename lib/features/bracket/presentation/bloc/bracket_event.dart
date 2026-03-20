import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

part 'bracket_event.freezed.dart';

/// Base class for all bracket BLoC events.
@freezed
sealed class BracketEvent with _$BracketEvent {
  /// Request initial bracket generation with participant list and config.
  const factory BracketEvent.generateRequested({
    required List<ParticipantEntity> participants,

    /// The elimination format to generate.
    required BracketFormat bracketFormat,

    /// Whether to apply dojang (gym) separation seeding.
    required bool dojangSeparation,
    required bool includeThirdPlaceMatch,
  }) = BracketGenerateRequested;

  /// Re-generate using the same params stored from the last [BracketGenerateRequested].
  const factory BracketEvent.regenerateRequested() = BracketRegenerateRequested;

  /// Record a match result (winner, optional scores).
  const factory BracketEvent.matchResultRecorded({
    required String matchId,
    required String winnerId,
    required MatchResultType resultType,
    int? blueScore,
    int? redScore,
  }) = BracketMatchResultRecorded;

  /// Clear the [BracketLoadSuccess.errorMessage] after the UI has shown it.
  const factory BracketEvent.errorDismissed() = BracketErrorDismissed;

  /// Undo the most recent match result recording.
  const factory BracketEvent.undoRequested() = BracketUndoRequested;

  /// Redo the last undone match result recording.
  const factory BracketEvent.redoRequested() = BracketRedoRequested;

  /// Start replaying all recorded actions from the initial bracket state.
  const factory BracketEvent.replayRequested() = BracketReplayRequested;

  /// Advance replay by one step (called by the replay timer).
  const factory BracketEvent.replayStepAdvanced() = BracketReplayStepAdvanced;

  /// Cancel an in-progress replay.
  const factory BracketEvent.replayCancelled() = BracketReplayCancelled;

  /// Jump directly to a specific point in the history.
  const factory BracketEvent.historyJumpRequested({
    required int targetHistoryIndex,
  }) = BracketHistoryJumpRequested;

  /// Toggle bracket edit mode on or off.
  const factory BracketEvent.editModeToggled() = BracketEditModeToggled;

  /// Swap two participant slots in the bracket.
  const factory BracketEvent.participantSlotSwapped({
    required String sourceMatchId,
    required String sourceSlotPosition,
    required String targetMatchId,
    required String targetSlotPosition,
  }) = BracketParticipantSlotSwapped;

  /// Update a participant's name and/or registration ID.
  const factory BracketEvent.participantDetailsUpdated({
    required String participantId,
    required String updatedFullName,
    String? updatedRegistrationId,
  }) = BracketParticipantDetailsUpdated;
}

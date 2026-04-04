import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';

part 'bracket_event.freezed.dart';

@freezed
sealed class BracketEvent with _$BracketEvent {
  const factory BracketEvent.generateRequested({
    required List<ParticipantEntity> participants,
    required BracketFormat bracketFormat,
    required bool dojangSeparation,
    required bool includeThirdPlaceMatch,
  }) = BracketGenerateRequested;

  const factory BracketEvent.regenerateRequested() = BracketRegenerateRequested;

  const factory BracketEvent.loadFromSnapshotRequested(
    BracketSnapshot snapshot,
  ) = BracketLoadFromSnapshotRequested;

  const factory BracketEvent.matchResultRecorded({
    required String matchId,
    required String winnerId,
    required MatchResultType resultType,
    int? blueScore,
    int? redScore,
  }) = BracketMatchResultRecorded;

  const factory BracketEvent.errorDismissed() = BracketErrorDismissed;

  const factory BracketEvent.undoRequested() = BracketUndoRequested;

  const factory BracketEvent.redoRequested() = BracketRedoRequested;

  const factory BracketEvent.replayRequested() = BracketReplayRequested;

  const factory BracketEvent.replayStepAdvanced() = BracketReplayStepAdvanced;

  const factory BracketEvent.replayCancelled() = BracketReplayCancelled;

  const factory BracketEvent.historyJumpRequested({
    required int targetHistoryIndex,
  }) = BracketHistoryJumpRequested;

  const factory BracketEvent.saveRequested() = BracketSaveRequested;
}

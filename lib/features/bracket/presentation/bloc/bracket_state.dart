import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';

import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';

part 'bracket_state.freezed.dart';

// ─────────────────────────────────────────
// State classes
// ─────────────────────────────────────────

@freezed
sealed class BracketState with _$BracketState {
  const factory BracketState.initial() = BracketInitial;
  const factory BracketState.generating() = BracketGenerating;
  const factory BracketState.loadSuccess({
    required BracketResult result,
    required List<ParticipantEntity> participants,

    /// The elimination format that was used to generate this bracket.
    required BracketFormat format,

    required bool includeThirdPlaceMatch,
    String? errorMessage,

    /// Chronological list of all actions taken since generation.
    /// The initial (generation) state is NOT in this list — it is stored as
    /// [initialResult] / [initialParticipants] below.
    @Default([]) List<BracketHistoryEntry> actionHistory,

    /// Pointer into [actionHistory]. -1 means we are at the initial
    /// (pre-any-action) state. 0 means after the first action, etc.
    @Default(-1) int historyPointer,

    /// True when an animated replay is in progress.
    @Default(false) bool isReplayInProgress,

    /// True when bracket edit mode (drag-swap / tap-edit) is active.
    @Default(false) bool isEditModeEnabled,

    /// The bracket result immediately after generation, before any
    /// actions were applied. Used as the baseline for undo and replay.
    BracketResult? initialResult,

    /// The participants list immediately after generation, before any
    /// name/ID edits were applied. Used as the baseline for undo.
    List<ParticipantEntity>? initialParticipants,

    /// True when saving bracket to DB.
    @Default(false) bool isSaving,

    /// True if there are unsaved changes.
    @Default(false) bool hasUnsavedChanges,

    /// Timestamp of the last successful save to DB.
    DateTime? lastSaveTimestamp,

    /// Error message from the most recent failed save attempt.
    /// Cleared on the next successful save.
    String? saveError,
  }) = BracketLoadSuccess;
  const factory BracketState.failure(String message) = BracketFailure;
}

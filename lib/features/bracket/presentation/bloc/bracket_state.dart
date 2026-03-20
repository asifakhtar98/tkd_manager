import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_edit_action.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_generation_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_match_action.dart';
import 'package:tkd_saas/features/bracket/domain/entities/double_elimination_bracket_generation_result.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

part 'bracket_state.freezed.dart';

/// Tagged union wrapping either [BracketGenerationResult] or
/// [DoubleEliminationBracketGenerationResult]. Eliminates `dynamic` from
/// the presentation layer.
@freezed
sealed class BracketResult with _$BracketResult {
  const factory BracketResult.singleElimination(BracketGenerationResult data) =
      SingleEliminationResult;
  const factory BracketResult.doubleElimination(
    DoubleEliminationBracketGenerationResult data,
  ) = DoubleEliminationResult;
}

/// Tagged union wrapping the two kinds of actions that can be stored in
/// the undo/redo history: match-result recordings and bracket-edit operations.
@freezed
sealed class BracketAction with _$BracketAction {
  const factory BracketAction.matchResult(BracketMatchAction data) =
      BracketActionMatchResult;
  const factory BracketAction.editAction(BracketEditAction data) =
      BracketActionEditAction;
}

/// A single entry in the undo/redo history stack.
///
/// Pairs the action metadata (for display in the history panel) with the
/// full [BracketResult] and [participants] snapshot produced after applying
/// the action.
@freezed
abstract class BracketHistoryEntry with _$BracketHistoryEntry {
  const factory BracketHistoryEntry({
    /// Type-safe action metadata (match result or bracket edit).
    required BracketAction action,

    /// The full bracket result snapshot AFTER this action was applied.
    required BracketResult resultSnapshot,

    /// The full participants list snapshot AFTER this action was applied.
    /// Needed because name/ID edits mutate participants, not matches.
    required List<ParticipantEntity> participantsSnapshot,
  }) = _BracketHistoryEntry;
}

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
  }) = BracketLoadSuccess;
  const factory BracketState.failure(String message) = BracketFailure;
}

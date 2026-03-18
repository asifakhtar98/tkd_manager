import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
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
  const factory BracketResult.singleElimination(BracketGenerationResult data) = SingleEliminationResult;
  const factory BracketResult.doubleElimination(DoubleEliminationBracketGenerationResult data) = DoubleEliminationResult;
}

/// A single entry in the undo/redo history stack.
///
/// Pairs the action metadata (for display in the history panel) with the
/// full [BracketResult] snapshot that was produced after applying the action.
@freezed
abstract class BracketHistoryEntry with _$BracketHistoryEntry {
  const factory BracketHistoryEntry({
    /// Metadata describing what action was taken.
    required BracketMatchAction action,

    /// The full bracket result snapshot AFTER this action was applied.
    required BracketResult resultSnapshot,
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

    /// Chronological list of all match-result actions taken since generation.
    /// The initial (generation) state is NOT in this list — it is stored as
    /// [initialResult] below.
    @Default([]) List<BracketHistoryEntry> actionHistory,

    /// Pointer into [actionHistory]. -1 means we are at the initial
    /// (pre-any-action) state. 0 means after the first action, etc.
    @Default(-1) int historyPointer,

    /// True when an animated replay is in progress.
    @Default(false) bool isReplayInProgress,

    /// The bracket result immediately after generation, before any match
    /// results were recorded. Used as the baseline for undo and replay.
    BracketResult? initialResult,
  }) = BracketLoadSuccess;
  const factory BracketState.failure(String message) = BracketFailure;
}

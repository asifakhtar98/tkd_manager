import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_edit_action.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_generation_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_match_action.dart';
import 'package:tkd_saas/features/bracket/domain/entities/double_elimination_bracket_generation_result.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';

part 'bracket_result.freezed.dart';
part 'bracket_result.g.dart';

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

  factory BracketResult.fromJson(Map<String, dynamic> json) =>
      _$BracketResultFromJson(json);
}

/// Tagged union wrapping the two kinds of actions that can be stored in
/// the undo/redo history: match-result recordings and bracket-edit operations.
@freezed
sealed class BracketAction with _$BracketAction {
  const factory BracketAction.matchResult(BracketMatchAction data) =
      BracketActionMatchResult;
  const factory BracketAction.editAction(BracketEditAction data) =
      BracketActionEditAction;

  factory BracketAction.fromJson(Map<String, dynamic> json) =>
      _$BracketActionFromJson(json);
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

  factory BracketHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$BracketHistoryEntryFromJson(json);
}

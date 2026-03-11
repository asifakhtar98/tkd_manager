import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_generation_result.dart';
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
    required String format,
    required bool includeThirdPlaceMatch,
    String? errorMessage,
  }) = BracketLoadSuccess;
  const factory BracketState.failure(String message) = BracketFailure;
}

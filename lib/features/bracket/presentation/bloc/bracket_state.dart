import 'package:tkd_saas/features/bracket/domain/entities/bracket_generation_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/double_elimination_bracket_generation_result.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

/// Tagged union wrapping either [BracketGenerationResult] or
/// [DoubleEliminationBracketGenerationResult]. Eliminates `dynamic` from
/// the presentation layer.
sealed class BracketResult {
  const BracketResult();
}

final class SingleEliminationResult extends BracketResult {
  const SingleEliminationResult(this.data);
  final BracketGenerationResult data;
}

final class DoubleEliminationResult extends BracketResult {
  const DoubleEliminationResult(this.data);
  final DoubleEliminationBracketGenerationResult data;
}

// ─────────────────────────────────────────
// State classes
// ─────────────────────────────────────────

sealed class BracketState {
  const BracketState();
}

final class BracketInitial extends BracketState {
  const BracketInitial();
}

final class BracketGenerating extends BracketState {
  const BracketGenerating();
}

final class BracketLoadSuccess extends BracketState {
  const BracketLoadSuccess({
    required this.result,
    required this.participants,
    required this.format,
    required this.includeThirdPlaceMatch,
  });

  final BracketResult result;
  final List<ParticipantEntity> participants;
  final String format;
  final bool includeThirdPlaceMatch;

  @override
  String toString() =>
      'BracketLoadSuccess(format: $format, participants: ${participants.length})';
}

final class BracketFailure extends BracketState {
  const BracketFailure(this.message);
  final String message;

  @override
  String toString() => 'BracketFailure($message)';
}

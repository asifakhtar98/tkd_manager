import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';

part 'double_elimination_bracket_generation_result.freezed.dart';

/// Value object containing the results of a double elimination
/// bracket generation operation.
@freezed
abstract class DoubleEliminationBracketGenerationResult with _$DoubleEliminationBracketGenerationResult {
  const factory DoubleEliminationBracketGenerationResult({
    required BracketEntity winnersBracket,
    required BracketEntity losersBracket,
    required MatchEntity grandFinalsMatch,
    MatchEntity? resetMatch,
    required List<MatchEntity> allMatches,
  }) = _DoubleEliminationBracketGenerationResult;
}

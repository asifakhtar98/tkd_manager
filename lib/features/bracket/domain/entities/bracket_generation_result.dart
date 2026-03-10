import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';

part 'bracket_generation_result.freezed.dart';

/// Value object containing the results of a bracket generation
/// operation. This includes the generated [BracketEntity] and
/// its associated [MatchEntity] records.
@freezed
abstract class BracketGenerationResult with _$BracketGenerationResult {
  const factory BracketGenerationResult({
    required BracketEntity bracket,
    required List<MatchEntity> matches,
  }) = _BracketGenerationResult;
}

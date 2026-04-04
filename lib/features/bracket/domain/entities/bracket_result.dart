import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_generation_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_match_action.dart';
import 'package:tkd_saas/features/bracket/domain/entities/double_elimination_bracket_generation_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';

part 'bracket_result.freezed.dart';
part 'bracket_result.g.dart';

@freezed
sealed class BracketResult with _$BracketResult {
  const BracketResult._();

  const factory BracketResult.singleElimination(BracketGenerationResult data) =
      SingleEliminationResult;
  const factory BracketResult.doubleElimination(
    DoubleEliminationBracketGenerationResult data,
  ) = DoubleEliminationResult;

  factory BracketResult.fromJson(Map<String, dynamic> json) =>
      _$BracketResultFromJson(json);

  List<MatchEntity> get allMatches => switch (this) {
    SingleEliminationResult(:final data) => data.matches,
    DoubleEliminationResult(:final data) => data.allMatches,
  };

  BracketResult replaceMatches(List<MatchEntity> updatedMatches) =>
      switch (this) {
        SingleEliminationResult(:final data) =>
          BracketResult.singleElimination(data.copyWith(matches: updatedMatches)),
        DoubleEliminationResult(:final data) =>
          BracketResult.doubleElimination(data.copyWith(allMatches: updatedMatches)),
      };
}

@freezed
sealed class BracketAction with _$BracketAction {
  const factory BracketAction.matchResult(BracketMatchAction data) =
      BracketActionMatchResult;

  factory BracketAction.fromJson(Map<String, dynamic> json) =>
      _$BracketActionFromJson(json);
}

@freezed
abstract class BracketHistoryEntry with _$BracketHistoryEntry {
  const factory BracketHistoryEntry({
    required BracketAction action,
    required BracketResult resultSnapshot,
    required List<ParticipantEntity> participantsSnapshot,
  }) = _BracketHistoryEntry;

  factory BracketHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$BracketHistoryEntryFromJson(json);
}

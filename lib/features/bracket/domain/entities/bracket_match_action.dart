import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';

part 'bracket_match_action.freezed.dart';
part 'bracket_match_action.g.dart';

/// Metadata describing a single match-result recording action.
///
/// Used by the undo/redo history stack to display a human-readable summary
/// of each action and to identify which match was affected.
@freezed
abstract class BracketMatchAction with _$BracketMatchAction {
  const factory BracketMatchAction({
    /// The match that was scored.
    required String matchId,

    /// The participant who was declared the winner.
    required String winnerId,

    /// How the match was decided (points, KO, etc.).
    required MatchResultType resultType,

    /// Optional blue-corner score.
    int? blueScore,

    /// Optional red-corner score.
    int? redScore,

    /// When this action was recorded.
    required DateTime recordedAt,

    /// Human-readable label for the history panel,
    /// e.g. "R1-M2: John Doe won by Points (3-1)".
    required String displayLabel,
  }) = _BracketMatchAction;

  factory BracketMatchAction.fromJson(Map<String, dynamic> json) =>
      _$BracketMatchActionFromJson(json);
}

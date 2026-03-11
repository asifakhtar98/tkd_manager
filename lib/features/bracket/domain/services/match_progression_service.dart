import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';

/// Pure domain service that handles match result recording and
/// bracket progression (advancing winners / dropping losers).
///
/// This service is stateless — it takes a match list, applies a result,
/// and returns the updated match list. No database access.
abstract interface class MatchProgressionService {
  /// Records a result for [matchId] in the given [matches] list.
  ///
  /// 1. Marks the match as completed with the given [winnerId].
  /// 2. Populates the winner into the next match's Blue/Red slot
  ///    (via `winnerAdvancesToMatchId`).
  /// 3. Populates the loser into the LB match slot
  ///    (via `loserAdvancesToMatchId`) for double elimination.
  /// 4. Handles bye auto-advancement cascades (max depth 3).
  ///
  /// Returns a new match list with all updates applied.
  /// Throws [ArgumentError] if the match is not found or already completed.
  List<MatchEntity> recordResult({
    required List<MatchEntity> matches,
    required String matchId,
    required String winnerId,
    MatchResultType resultType = MatchResultType.points,
    int? blueScore,
    int? redScore,
  });
}

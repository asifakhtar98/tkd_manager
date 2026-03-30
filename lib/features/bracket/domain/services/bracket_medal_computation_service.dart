import 'package:tkd_saas/features/bracket/domain/entities/bracket_medal_placement_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';

/// Computes runtime medal placements (Gold, Silver, Bronze) from a bracket's
/// current match state.
///
/// This service encapsulates the logic that was previously inlined inside
/// [TieSheetPainter._paintMedalTable], making it testable and reusable across
/// both the canvas UI and PDF export paths.
///
/// Two strategies are supported:
/// - **Single Elimination**: Gold/Silver from the final match; Bronze from the
///   optional 3rd-place match.
/// - **Double Elimination**: Gold/Silver from the last completed Grand Final
///   (GF2 if played, else GF1); Bronze from the Losers Bracket final loser.
abstract class BracketMedalComputationService {
  /// Derives medal placements from the current [matches] state.
  ///
  /// Returns an empty list when insufficient match data exists to determine
  /// any placements (e.g., the final match has not yet been completed).
  ///
  /// [isDoubleElimination] selects which placement strategy to use.
  /// [winnersBracketId] and [losersBracketId] are required for DE brackets.
  /// [includeThirdPlaceMatch] controls whether bronze is derived from a
  /// 3rd-place match (SE only).
  List<BracketMedalPlacementEntity> computeRuntimeMedalPlacements({
    required List<MatchEntity> matches,
    required bool isDoubleElimination,
    String? winnersBracketId,
    String? losersBracketId,
    bool includeThirdPlaceMatch = false,
  });
}

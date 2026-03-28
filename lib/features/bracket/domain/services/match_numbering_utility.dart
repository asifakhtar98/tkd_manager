import 'dart:math';

import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';

/// Pure, stateless utility that computes global match numbers for tie sheet
/// display.
///
/// Follows the real-world DinuFix convention:
///
/// **Single Elimination**
/// - Per round: left-side matches first (top → bottom), then right-side
/// - 3rd-place match numbered before the final
/// - Final is always the last numbered match
///
/// **Double Elimination**
/// - WB section: left-first / right-second per round
/// - LB section: sequential round-by-round (no left/right split)
/// - GF section: sequential after LB
abstract final class MatchNumberingUtility {
  /// Builds a map of `matchId → globalDisplayNumber` for all provided matches.
  ///
  /// [isDoubleElimination] selects the numbering strategy.
  /// [winnersBracketId] and [losersBracketId] are required when
  /// [isDoubleElimination] is `true`.
  static Map<String, int> buildGlobalMatchNumbers({
    required List<MatchEntity> matches,
    required bool isDoubleElimination,
    String? winnersBracketId,
    String? losersBracketId,
  }) {
    if (matches.isEmpty) return {};

    if (isDoubleElimination) {
      return _buildDoubleEliminationNumbering(
        matches: matches,
        winnersBracketId: winnersBracketId!,
        losersBracketId: losersBracketId!,
      );
    }

    return _buildSingleEliminationNumbering(matches);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Single Elimination
  // ─────────────────────────────────────────────────────────────────────────

  static Map<String, int> _buildSingleEliminationNumbering(
    List<MatchEntity> matches,
  ) {
    final result = <String, int>{};
    final maxRound = _maxRound(matches);

    // Identify special matches in the final round.
    final thirdPlaceMatch = matches
        .where((m) => m.roundNumber == maxRound && m.matchNumberInRound == 2)
        .firstOrNull;
    final finalMatch = matches
        .where((m) => m.roundNumber == maxRound && m.matchNumberInRound == 1)
        .firstOrNull;

    // Exclude the 3rd-place match from the main round loop — it's numbered
    // separately between the semi-finals and the final.
    final mainMatches = matches
        .where((m) => !(m.roundNumber == maxRound && m.matchNumberInRound == 2))
        .toList();

    final byRound = _groupByRound(mainMatches);
    final mainMaxRound = mainMatches.isEmpty ? 0 : _maxRound(mainMatches);

    var globalNumber = 1;

    // Rounds 1 through the semi-final round: left first, right second.
    for (var roundNumber = 1; roundNumber <= mainMaxRound; roundNumber++) {
      final roundMatches = byRound[roundNumber] ?? [];
      final matchCount = roundMatches.length;

      // The final round (1 match) is handled specially below.
      if (roundNumber == mainMaxRound && matchCount == 1) break;

      globalNumber = _numberMatchesLeftThenRight(
        roundMatches,
        result,
        globalNumber,
      );
    }

    // 3rd-place match comes before the final.
    if (thirdPlaceMatch != null &&
        thirdPlaceMatch.resultType != MatchResultType.bye) {
      result[thirdPlaceMatch.id] = globalNumber++;
    }

    // Final match is always last.
    if (finalMatch != null && finalMatch.resultType != MatchResultType.bye) {
      result[finalMatch.id] = globalNumber++;
    }

    return result;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Double Elimination
  // ─────────────────────────────────────────────────────────────────────────

  static Map<String, int> _buildDoubleEliminationNumbering({
    required List<MatchEntity> matches,
    required String winnersBracketId,
    required String losersBracketId,
  }) {
    final result = <String, int>{};

    final winnersMatches = matches
        .where((m) => m.bracketId == winnersBracketId)
        .toList();
    final losersMatches = matches
        .where((m) => m.bracketId == losersBracketId)
        .toList();
    final grandFinalsMatches = matches
        .where(
          (m) =>
              m.bracketId != winnersBracketId && m.bracketId != losersBracketId,
        )
        .toList();

    var globalNumber = 1;

    // Winners Bracket: left-first / right-second per round.
    final winnersMaxRound = winnersMatches.isEmpty
        ? 0
        : _maxRound(winnersMatches);
    final winnersByRound = _groupByRound(winnersMatches);
    for (var r = 1; r <= winnersMaxRound; r++) {
      globalNumber = _numberMatchesLeftThenRight(
        winnersByRound[r] ?? [],
        result,
        globalNumber,
      );
    }

    // Losers Bracket: sequential round-by-round (no left/right split —
    // LB is rendered linearly, not mirrored).
    final losersMaxRound = losersMatches.isEmpty ? 0 : _maxRound(losersMatches);
    final losersByRound = _groupByRound(losersMatches);
    for (var r = 1; r <= losersMaxRound; r++) {
      globalNumber = _numberMatchesSequentially(
        losersByRound[r] ?? [],
        result,
        globalNumber,
      );
    }

    // Grand Finals: sequential.
    final grandFinalsSorted = List<MatchEntity>.from(grandFinalsMatches)
      ..sort((a, b) {
        if (a.roundNumber != b.roundNumber) {
          return a.roundNumber.compareTo(b.roundNumber);
        }
        return a.matchNumberInRound.compareTo(b.matchNumberInRound);
      });
    for (final match in grandFinalsSorted) {
      if (match.resultType != MatchResultType.bye) {
        result[match.id] = globalNumber++;
      }
    }

    return result;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shared Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Numbers the round's matches left-first then right-second (split at the
  /// midpoint of [matchNumberInRound]).
  ///
  /// Returns the next available global number.
  static int _numberMatchesLeftThenRight(
    List<MatchEntity> roundMatches,
    Map<String, int> result,
    int startingNumber,
  ) {
    var globalNumber = startingNumber;
    final matchCount = roundMatches.length;
    final leftHalfCount = (matchCount + 1) ~/ 2;

    final leftMatches = roundMatches
        .where((m) => m.matchNumberInRound <= leftHalfCount)
        .toList();
    final rightMatches = roundMatches
        .where((m) => m.matchNumberInRound > leftHalfCount)
        .toList();

    for (final match in leftMatches) {
      if (match.resultType != MatchResultType.bye) {
        result[match.id] = globalNumber++;
      }
    }
    for (final match in rightMatches) {
      if (match.resultType != MatchResultType.bye) {
        result[match.id] = globalNumber++;
      }
    }
    return globalNumber;
  }

  /// Numbers the matches in their natural [matchNumberInRound] order.
  ///
  /// Returns the next available global number.
  static int _numberMatchesSequentially(
    List<MatchEntity> roundMatches,
    Map<String, int> result,
    int startingNumber,
  ) {
    var globalNumber = startingNumber;
    for (final match in roundMatches) {
      if (match.resultType != MatchResultType.bye) {
        result[match.id] = globalNumber++;
      }
    }
    return globalNumber;
  }

  /// Highest round number in the list.
  static int _maxRound(List<MatchEntity> matches) =>
      matches.map((m) => m.roundNumber).reduce(max);

  /// Groups matches by round, sorted by [matchNumberInRound] within each round.
  static Map<int, List<MatchEntity>> _groupByRound(List<MatchEntity> matches) {
    final map = <int, List<MatchEntity>>{};
    for (final m in matches) {
      map.putIfAbsent(m.roundNumber, () => []).add(m);
    }
    for (final matchesInRound in map.values) {
      matchesInRound.sort(
        (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
      );
    }
    return map;
  }
}

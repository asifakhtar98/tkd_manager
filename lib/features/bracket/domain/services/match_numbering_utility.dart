import 'dart:math';

import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';

/// Pure, stateless utility that computes global match numbers for tie sheet
/// display.
///
/// Follows the real-world DinuFix convention:
///
/// **Single Elimination**
/// - Per round: ordered by rest priority (fewer incoming bouts go first), then top → bottom.
/// - 3rd-place match numbered before the final
/// - Final is always the last numbered match
///
/// **Double Elimination**
/// - WB section: ordered by rest priority per round
/// - LB section: sequential round-by-round (no left/right split)
/// - GF section: sequential after LB
abstract final class MatchNumberingUtility {
  /// Returns a new list of matches where each match's `globalMatchDisplayNumber`
  /// has been assigned based on the visual arrangement logic.
  ///
  /// [isDoubleElimination] selects the numbering strategy.
  /// [winnersBracketId] and [losersBracketId] are required when
  /// [isDoubleElimination] is `true`.
  static List<MatchEntity> assignGlobalMatchNumbers({
    required List<MatchEntity> matches,
    required bool isDoubleElimination,
    String? winnersBracketId,
    String? losersBracketId,
  }) {
    if (matches.isEmpty) return [];

    final incomingNonByeCounts = <String, int>{};
    for (final m in matches) {
      if (!m.isBye && m.winnerAdvancesToMatchId != null) {
        incomingNonByeCounts[m.winnerAdvancesToMatchId!] =
            (incomingNonByeCounts[m.winnerAdvancesToMatchId!] ?? 0) + 1;
      }
    }

    final Map<String, int> numberingMap;
    if (isDoubleElimination) {
      numberingMap = _buildDoubleEliminationNumbering(
        matches: matches,
        winnersBracketId: winnersBracketId!,
        losersBracketId: losersBracketId!,
        incomingNonByeCounts: incomingNonByeCounts,
      );
    } else {
      numberingMap = _buildSingleEliminationNumbering(
        matches,
        incomingNonByeCounts,
      );
    }

    // Apply the numbers to the entity
    return matches.map((m) {
      final number = numberingMap[m.id];
      if (number != null) {
        return m.copyWith(globalMatchDisplayNumber: number);
      }
      return m;
    }).toList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Single Elimination
  // ─────────────────────────────────────────────────────────────────────────

  static Map<String, int> _buildSingleEliminationNumbering(
    List<MatchEntity> matches,
    Map<String, int> incomingNonByeCounts,
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

      globalNumber = _numberMatchesWithRestPriority(
        roundMatches,
        result,
        globalNumber,
        incomingNonByeCounts,
      );
    }

    // 3rd-place match comes before the final.
    if (thirdPlaceMatch != null && !thirdPlaceMatch.isBye) {
      result[thirdPlaceMatch.id] = globalNumber++;
    }

    // Final match is always last.
    if (finalMatch != null && !finalMatch.isBye) {
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
    required Map<String, int> incomingNonByeCounts,
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

    // Winners Bracket: sort by rest priority.
    final winnersMaxRound = winnersMatches.isEmpty
        ? 0
        : _maxRound(winnersMatches);
    final winnersByRound = _groupByRound(winnersMatches);
    for (var r = 1; r <= winnersMaxRound; r++) {
      globalNumber = _numberMatchesWithRestPriority(
        winnersByRound[r] ?? [],
        result,
        globalNumber,
        incomingNonByeCounts,
      );
    }

    // Losers Bracket: sequential round-by-round (no left/right split —
    // LB is rendered linearly). Using rest priority here ensures that if an LB
    // player advances via bye/walkover, they are given fair rest spacing too.
    final losersMaxRound = losersMatches.isEmpty ? 0 : _maxRound(losersMatches);
    final losersByRound = _groupByRound(losersMatches);
    for (var r = 1; r <= losersMaxRound; r++) {
      globalNumber = _numberMatchesWithRestPriority(
        losersByRound[r] ?? [],
        result,
        globalNumber,
        incomingNonByeCounts,
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
      if (!match.isBye) {
        result[match.id] = globalNumber++;
      }
    }

    return result;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shared Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Numbers the round's matches ordering matches with fewer dependencies first
  /// (rest priority), then top-to-bottom.
  ///
  /// Returns the next available global number.
  static int _numberMatchesWithRestPriority(
    List<MatchEntity> roundMatches,
    Map<String, int> result,
    int startingNumber,
    Map<String, int> incomingNonByeCounts,
  ) {
    var globalNumber = startingNumber;

    // Sort matches:
    // 1. Matches with FEWER incoming non-bye matches go FIRST.
    // 2. Tie-breaker: natural layout order (matchNumberInRound).
    final sortedMatches = List<MatchEntity>.from(roundMatches)
      ..sort((a, b) {
        final aIncoming = incomingNonByeCounts[a.id] ?? 0;
        final bIncoming = incomingNonByeCounts[b.id] ?? 0;
        if (aIncoming != bIncoming) {
          return aIncoming.compareTo(bIncoming);
        }
        return a.matchNumberInRound.compareTo(b.matchNumberInRound);
      });

    for (final match in sortedMatches) {
      if (!match.isBye) {
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

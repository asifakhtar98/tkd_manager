import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/services/match_numbering_utility.dart';

void main() {
  const uuid = Uuid();
  final singleEliminationGenerator =
      SingleEliminationBracketGeneratorServiceImplementation(uuid);
  final doubleEliminationGenerator =
      DoubleEliminationBracketGeneratorServiceImplementation(uuid);

  // ─────────────────────────────────────────────────────────────────────────
  // Shared helpers
  // ─────────────────────────────────────────────────────────────────────────

  Map<int, List<MatchEntity>> groupByRound(List<MatchEntity> matches) {
    final map = <int, List<MatchEntity>>{};
    for (final match in matches) {
      map.putIfAbsent(match.roundNumber, () => []).add(match);
    }
    for (final matchesInRound in map.values) {
      matchesInRound.sort(
        (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
      );
    }
    return map;
  }

  /// Asserts that [numbering] is a contiguous 1..N sequence with no gaps
  /// or duplicates.
  void expectContiguousNumbering(Map<String, int> numbering) {
    final expectedLength = numbering.length;
    expect(numbering.values.toSet().length, expectedLength,
        reason: 'Numbering must have no duplicates');
    if (expectedLength > 0) {
      expect(numbering.values.reduce(min), 1,
          reason: 'Numbering must start at 1');
      expect(numbering.values.reduce(max), expectedLength,
          reason: 'Numbering must be contiguous to N');
    }
  }

  void debugPrintNumbering(
    String label,
    List<MatchEntity> matches,
    Map<String, int> numbering,
  ) {
    final maxRound =
        matches.isEmpty ? 0 : matches.map((m) => m.roundNumber).reduce(max);
    final byRound = groupByRound(matches);

    debugPrint('\n=== $label ===');
    for (var roundIndex = 1; roundIndex <= maxRound; roundIndex++) {
      final roundMatches = byRound[roundIndex] ?? [];
      final descriptions = roundMatches.map((m) {
        final displayNumber = numbering[m.id] ?? -1;
        final byeMarker = m.resultType == MatchResultType.bye ? ',BYE' : '';
        final bracketPrefix =
            '${m.bracketId.substring(0, min(2, m.bracketId.length))}:';
        return '$displayNumber($bracketPrefix${m.matchNumberInRound}$byeMarker)';
      }).join(', ');
      debugPrint('  R$roundIndex: $descriptions');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Single Elimination Tests
  // ─────────────────────────────────────────────────────────────────────────

  group('MatchNumberingUtility — Single Elimination', () {
    ({List<MatchEntity> matches, Map<String, int> numbering})
        generateSingleEliminationBracket(
      int playerCount, {
      bool includeThirdPlaceMatch = false,
    }) {
      final participantIds = List.generate(playerCount, (i) => 'p$i');
      final result = singleEliminationGenerator.generate(
        genderId: 'div1',
        participantIds: participantIds,
        bracketId: 'bracket',
        includeThirdPlaceMatch: includeThirdPlaceMatch,
      );
      final numbering = MatchNumberingUtility.buildGlobalMatchNumbers(
        matches: result.matches,
        isDoubleElimination: false,
      );
      return (matches: result.matches, numbering: numbering);
    }

    test('empty matches returns empty map', () {
      final result = MatchNumberingUtility.buildGlobalMatchNumbers(
        matches: [],
        isDoubleElimination: false,
      );
      expect(result, isEmpty);
    });

    test('2-player bracket: single match numbered 1', () {
      final (:matches, :numbering) = generateSingleEliminationBracket(2);
      debugPrintNumbering('SE 2 players', matches, numbering);

      expect(matches.length, 1);
      expectContiguousNumbering(numbering);
      expect(numbering[matches.first.id], 1);
    });

    test('3-player bracket: BYE + real match, then final', () {
      final (:matches, :numbering) = generateSingleEliminationBracket(3);
      final byRound = groupByRound(matches);
      debugPrintNumbering('SE 3 players', matches, numbering);

      // R1: 2 matches (one BYE), R2: 1 final
      expect(byRound[1]!.length, 2);
      expect(byRound[2]!.length, 1);
      expectContiguousNumbering(numbering);

      // Left match (M1) numbered before right match (M2)
      expect(numbering[byRound[1]![0].id], 1);
      expect(numbering[byRound[1]![1].id], 2);
      // Final is last
      expect(numbering[byRound[2]![0].id], 3);
    });

    test('4-player bracket: left-first per round, final last', () {
      final (:matches, :numbering) = generateSingleEliminationBracket(4);
      final byRound = groupByRound(matches);
      debugPrintNumbering('SE 4 players', matches, numbering);

      expectContiguousNumbering(numbering);

      // R1: M1(left) → 1, M2(right) → 2
      expect(numbering[byRound[1]![0].id], 1);
      expect(numbering[byRound[1]![1].id], 2);
      // R2: final → 3
      expect(numbering[byRound[2]![0].id], 3);
    });

    test('8-player: left-first, right-second per round, final last', () {
      final (:matches, :numbering) = generateSingleEliminationBracket(8);
      final byRound = groupByRound(matches);
      debugPrintNumbering('SE 8 players', matches, numbering);

      expectContiguousNumbering(numbering);

      // R1: 4 matches — left (M1,M2) → 1,2, right (M3,M4) → 3,4
      final r1 = byRound[1]!;
      expect(numbering[r1[0].id], 1);
      expect(numbering[r1[1].id], 2);
      expect(numbering[r1[2].id], 3);
      expect(numbering[r1[3].id], 4);

      // R2: left semi → 5, right semi → 6
      final r2 = byRound[2]!;
      expect(numbering[r2[0].id], 5);
      expect(numbering[r2[1].id], 6);

      // R3: final → 7
      expect(numbering[byRound[3]![0].id], 7);
    });

    test('8-player with 3rd place: 3rd place numbered before final', () {
      final (:matches, :numbering) =
          generateSingleEliminationBracket(8, includeThirdPlaceMatch: true);
      final byRound = groupByRound(matches);
      debugPrintNumbering('SE 8 players + 3rd place', matches, numbering);

      expectContiguousNumbering(numbering);

      // Semis numbering unchanged
      expect(numbering[byRound[2]![0].id], 5);
      expect(numbering[byRound[2]![1].id], 6);

      // R3: 3rd place (matchNumberInRound=2) before final (matchNumberInRound=1)
      final r3 = byRound[3]!;
      final finalMatch = r3.firstWhere((m) => m.matchNumberInRound == 1);
      final thirdPlaceMatch = r3.firstWhere((m) => m.matchNumberInRound == 2);
      expect(numbering[thirdPlaceMatch.id], 7);
      expect(numbering[finalMatch.id], 8);
    });

    test('14-player: BYE matches receive numbers, contiguous 1..15', () {
      final (:matches, :numbering) = generateSingleEliminationBracket(14);
      final byRound = groupByRound(matches);
      debugPrintNumbering('SE 14 players', matches, numbering);

      expectContiguousNumbering(numbering);
      expect(numbering.length, 15);

      // R1: left M1-M4 → 1-4, right M5-M8 → 5-8
      final r1 = byRound[1]!;
      for (var i = 0; i < 4; i++) {
        expect(numbering[r1[i].id], i + 1);
      }
      for (var i = 4; i < 8; i++) {
        expect(numbering[r1[i].id], i + 1);
      }

      // Final is last
      final maxRound = byRound.keys.reduce(max);
      final finalRound = byRound[maxRound]!;
      expect(numbering[finalRound[0].id], 15);
    });

    test('16-player: all assignments contiguous 1..15', () {
      final (:matches, :numbering) = generateSingleEliminationBracket(16);
      debugPrintNumbering('SE 16 players', matches, numbering);

      expect(numbering.length, 15);
      expectContiguousNumbering(numbering);
    });

    test('14-player with 3rd place: contiguous 1..16', () {
      final (:matches, :numbering) =
          generateSingleEliminationBracket(14, includeThirdPlaceMatch: true);
      debugPrintNumbering('SE 14 players + 3rd place', matches, numbering);

      expect(numbering.length, 16);
      expectContiguousNumbering(numbering);

      // 3rd place (last round, M2) is numbered before final (last round, M1)
      final maxRound =
          matches.map((m) => m.roundNumber).reduce(max);
      final lastRoundMatches = matches
          .where((m) => m.roundNumber == maxRound)
          .toList();
      final finalMatch =
          lastRoundMatches.firstWhere((m) => m.matchNumberInRound == 1);
      final thirdPlaceMatch =
          lastRoundMatches.firstWhere((m) => m.matchNumberInRound == 2);
      expect(
        numbering[thirdPlaceMatch.id]!,
        lessThan(numbering[finalMatch.id]!),
        reason: '3rd place must be numbered before the final',
      );
      expect(numbering[finalMatch.id], 16);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Double Elimination Tests
  // ─────────────────────────────────────────────────────────────────────────

  group('MatchNumberingUtility — Double Elimination', () {
    /// Generates a DE bracket and returns all sections with numbering.
    ({
      List<MatchEntity> allMatches,
      List<MatchEntity> winnersMatches,
      List<MatchEntity> losersMatches,
      List<MatchEntity> grandFinalsMatches,
      Map<String, int> numbering,
    })
    generateDoubleEliminationBracket(int playerCount) {
      final participantIds = List.generate(playerCount, (i) => 'p$i');
      final result = doubleEliminationGenerator.generate(
        genderId: 'div1',
        participantIds: participantIds,
        winnersBracketId: 'wb',
        losersBracketId: 'lb',
      );

      final numbering = MatchNumberingUtility.buildGlobalMatchNumbers(
        matches: result.allMatches,
        isDoubleElimination: true,
        winnersBracketId: 'wb',
        losersBracketId: 'lb',
      );

      return (
        allMatches: result.allMatches,
        winnersMatches:
            result.allMatches.where((m) => m.bracketId == 'wb').toList(),
        losersMatches:
            result.allMatches.where((m) => m.bracketId == 'lb').toList(),
        grandFinalsMatches: result.allMatches
            .where((m) => m.bracketId != 'wb' && m.bracketId != 'lb')
            .toList(),
        numbering: numbering,
      );
    }

    test('DE 2-player: minimal bracket with GF only', () {
      final result = generateDoubleEliminationBracket(2);
      debugPrintNumbering('DE 2 all', result.allMatches, result.numbering);

      expectContiguousNumbering(result.numbering);
      // Should have WB final + GF + reset = at least 3 matches
      expect(result.numbering.length, result.allMatches.length);
    });

    test('DE 4-player: WB → LB → GF ordering, contiguous', () {
      final result = generateDoubleEliminationBracket(4);
      debugPrintNumbering('DE 4 WB', result.winnersMatches, result.numbering);
      debugPrintNumbering('DE 4 LB', result.losersMatches, result.numbering);
      debugPrintNumbering('DE 4 GF', result.grandFinalsMatches, result.numbering);

      expectContiguousNumbering(result.numbering);

      // WB before LB before GF
      if (result.winnersMatches.isNotEmpty && result.losersMatches.isNotEmpty) {
        final maxWinnersNumber =
            result.winnersMatches.map((m) => result.numbering[m.id]!).reduce(max);
        final minLosersNumber =
            result.losersMatches.map((m) => result.numbering[m.id]!).reduce(min);
        expect(maxWinnersNumber, lessThan(minLosersNumber),
            reason: 'WB must be numbered entirely before LB');
      }
      if (result.losersMatches.isNotEmpty &&
          result.grandFinalsMatches.isNotEmpty) {
        final maxLosersNumber =
            result.losersMatches.map((m) => result.numbering[m.id]!).reduce(max);
        final minGrandFinalNumber = result.grandFinalsMatches
            .map((m) => result.numbering[m.id]!)
            .reduce(min);
        expect(maxLosersNumber, lessThan(minGrandFinalNumber),
            reason: 'LB must be numbered entirely before GF');
      }
    });

    test('DE 8-player: WB left-first/right-second, LB sequential, GF last', () {
      final result = generateDoubleEliminationBracket(8);
      debugPrintNumbering('DE 8 WB', result.winnersMatches, result.numbering);
      debugPrintNumbering('DE 8 LB', result.losersMatches, result.numbering);
      debugPrintNumbering('DE 8 GF', result.grandFinalsMatches, result.numbering);

      expectContiguousNumbering(result.numbering);
      expect(result.numbering.length, result.allMatches.length);

      // WB → LB → GF ordering
      final maxWinnersNumber =
          result.winnersMatches.map((m) => result.numbering[m.id]!).reduce(max);
      final minLosersNumber =
          result.losersMatches.map((m) => result.numbering[m.id]!).reduce(min);
      final maxLosersNumber =
          result.losersMatches.map((m) => result.numbering[m.id]!).reduce(max);
      final minGrandFinalNumber = result.grandFinalsMatches
          .map((m) => result.numbering[m.id]!)
          .reduce(min);

      expect(maxWinnersNumber, lessThan(minLosersNumber),
          reason: 'All WB matches before LB');
      expect(maxLosersNumber, lessThan(minGrandFinalNumber),
          reason: 'All LB matches before GF');

      // WB R1 specifically: left-first/right-second
      final wbByRound = groupByRound(result.winnersMatches);
      final wbR1 = wbByRound[1]!;
      // 4 matches: left M1,M2 → 1,2; right M3,M4 → 3,4
      expect(result.numbering[wbR1[0].id], 1);
      expect(result.numbering[wbR1[1].id], 2);
      expect(result.numbering[wbR1[2].id], 3);
      expect(result.numbering[wbR1[3].id], 4);
    });
  });
}

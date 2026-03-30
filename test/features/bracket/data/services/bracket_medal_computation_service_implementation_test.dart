import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/data/services/bracket_medal_computation_service_implementation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';

void main() {
  late BracketMedalComputationServiceImplementation serviceUnderTest;

  setUp(() {
    serviceUnderTest = const BracketMedalComputationServiceImplementation();
  });

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Creates a minimal match with the fields needed for medal computation.
  MatchEntity _createMatch({
    required String id,
    required String bracketId,
    required int roundNumber,
    required int matchNumberInRound,
    String? participantBlueId,
    String? participantRedId,
    String? winnerId,
    MatchStatus status = MatchStatus.pending,
    MatchResultType? resultType,
    String? winnerAdvancesToMatchId,
    String? loserAdvancesToMatchId,
  }) {
    final now = DateTime(2026);
    return MatchEntity(
      id: id,
      bracketId: bracketId,
      roundNumber: roundNumber,
      matchNumberInRound: matchNumberInRound,
      createdAtTimestamp: now,
      updatedAtTimestamp: now,
      participantBlueId: participantBlueId,
      participantRedId: participantRedId,
      winnerId: winnerId,
      status: status,
      resultType: resultType,
      winnerAdvancesToMatchId: winnerAdvancesToMatchId,
      loserAdvancesToMatchId: loserAdvancesToMatchId,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EDGE CASES
  // ═══════════════════════════════════════════════════════════════════════════

  group('Edge cases', () {
    test('returns empty list when matches list is empty', () {
      final placements = serviceUnderTest.computeRuntimeMedalPlacements(
        matches: [],
        isDoubleElimination: false,
      );

      expect(placements, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SINGLE ELIMINATION
  // ═══════════════════════════════════════════════════════════════════════════

  group('Single Elimination', () {
    // 4-player bracket layout:
    //   R1-M1: Alice vs Bob  → winner → R2-M1 (Final)
    //   R1-M2: Carol vs Dave → winner → R2-M1 (Final)
    //   R2-M1: (Final)
    //   R2-M2: (3rd-place, optional)

    const bracketId = 'se-bracket';
    const alice = 'alice-id';
    const bob = 'bob-id';
    const carol = 'carol-id';
    const dave = 'dave-id';

    List<MatchEntity> _buildCompleteSingleEliminationBracket({
      required String finalWinnerId,
      required String finalLoserId,
      String? thirdPlaceWinnerId,
      String? thirdPlaceLoserId,
      bool includeThirdPlaceMatch = true,
    }) {
      final matches = <MatchEntity>[
        // Round 1
        _createMatch(
          id: 'se-r1-m1',
          bracketId: bracketId,
          roundNumber: 1,
          matchNumberInRound: 1,
          participantBlueId: alice,
          participantRedId: bob,
          winnerId: finalWinnerId == alice || finalWinnerId == bob
              ? (finalWinnerId == alice ? alice : bob)
              : alice,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
        _createMatch(
          id: 'se-r1-m2',
          bracketId: bracketId,
          roundNumber: 1,
          matchNumberInRound: 2,
          participantBlueId: carol,
          participantRedId: dave,
          winnerId: finalWinnerId == carol || finalWinnerId == dave
              ? (finalWinnerId == carol ? carol : dave)
              : carol,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
        // Round 2 - Final (matchNumberInRound == 1)
        _createMatch(
          id: 'se-r2-m1',
          bracketId: bracketId,
          roundNumber: 2,
          matchNumberInRound: 1,
          participantBlueId: finalWinnerId,
          participantRedId: finalLoserId,
          winnerId: finalWinnerId,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
      ];

      // Optionally add 3rd-place match (round 2, match #2)
      if (includeThirdPlaceMatch) {
        matches.add(
          _createMatch(
            id: 'se-r2-m2',
            bracketId: bracketId,
            roundNumber: 2,
            matchNumberInRound: 2,
            participantBlueId: thirdPlaceWinnerId,
            participantRedId: thirdPlaceLoserId,
            winnerId: thirdPlaceWinnerId,
            status: thirdPlaceWinnerId != null
                ? MatchStatus.completed
                : MatchStatus.pending,
            resultType: thirdPlaceWinnerId != null
                ? MatchResultType.points
                : null,
          ),
        );
      }

      return matches;
    }

    test('assigns Gold and Silver from final match winner and loser', () {
      final matches = _buildCompleteSingleEliminationBracket(
        finalWinnerId: alice,
        finalLoserId: carol,
        includeThirdPlaceMatch: false,
      );

      final placements = serviceUnderTest.computeRuntimeMedalPlacements(
        matches: matches,
        isDoubleElimination: false,
        includeThirdPlaceMatch: false,
      );

      expect(placements, hasLength(2));

      // Gold
      expect(placements[0].participantId, equals(alice));
      expect(placements[0].rankStatus, equals(1));
      expect(placements[0].displayPlacementLabel, equals('Gold'));

      // Silver
      expect(placements[1].participantId, equals(carol));
      expect(placements[1].rankStatus, equals(2));
      expect(placements[1].displayPlacementLabel, equals('Silver'));
    });

    test(
      'assigns Bronze positions from 3rd-place match winner and loser',
      () {
        final matches = _buildCompleteSingleEliminationBracket(
          finalWinnerId: alice,
          finalLoserId: carol,
          thirdPlaceWinnerId: bob,
          thirdPlaceLoserId: dave,
          includeThirdPlaceMatch: true,
        );

        final placements = serviceUnderTest.computeRuntimeMedalPlacements(
          matches: matches,
          isDoubleElimination: false,
          includeThirdPlaceMatch: true,
        );

        expect(placements, hasLength(4));

        // Gold
        expect(placements[0].participantId, equals(alice));
        expect(placements[0].rankStatus, equals(1));

        // Silver
        expect(placements[1].participantId, equals(carol));
        expect(placements[1].rankStatus, equals(2));

        // 1st Bronze
        expect(placements[2].participantId, equals(bob));
        expect(placements[2].rankStatus, equals(3));
        expect(placements[2].displayPlacementLabel, equals('1st Bronze'));

        // 2nd Bronze
        expect(placements[3].participantId, equals(dave));
        expect(placements[3].rankStatus, equals(4));
        expect(placements[3].displayPlacementLabel, equals('2nd Bronze'));
      },
    );

    test('returns no bronze when includeThirdPlaceMatch is false', () {
      final matches = _buildCompleteSingleEliminationBracket(
        finalWinnerId: alice,
        finalLoserId: carol,
        thirdPlaceWinnerId: bob,
        thirdPlaceLoserId: dave,
        includeThirdPlaceMatch: true,
      );

      final placements = serviceUnderTest.computeRuntimeMedalPlacements(
        matches: matches,
        isDoubleElimination: false,
        includeThirdPlaceMatch: false,
      );

      expect(placements, hasLength(2));
      expect(placements[0].rankStatus, equals(1)); // Gold only
      expect(placements[1].rankStatus, equals(2)); // Silver only
    });

    test('returns empty list when final match has no winner yet', () {
      final matches = [
        _createMatch(
          id: 'se-r1-m1',
          bracketId: bracketId,
          roundNumber: 1,
          matchNumberInRound: 1,
          participantBlueId: alice,
          participantRedId: bob,
          winnerId: alice,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
        _createMatch(
          id: 'se-r1-m2',
          bracketId: bracketId,
          roundNumber: 1,
          matchNumberInRound: 2,
          participantBlueId: carol,
          participantRedId: dave,
          winnerId: carol,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
        // Final — NOT yet completed
        _createMatch(
          id: 'se-r2-m1',
          bracketId: bracketId,
          roundNumber: 2,
          matchNumberInRound: 1,
          participantBlueId: alice,
          participantRedId: carol,
          // winnerId: null → not yet played
          status: MatchStatus.pending,
        ),
      ];

      final placements = serviceUnderTest.computeRuntimeMedalPlacements(
        matches: matches,
        isDoubleElimination: false,
        includeThirdPlaceMatch: false,
      );

      expect(placements, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // DOUBLE ELIMINATION
  // ═══════════════════════════════════════════════════════════════════════════

  group('Double Elimination', () {
    // 4-player DE layout:
    //   WB R1-M1: Alice vs Bob
    //   WB R1-M2: Carol vs Dave
    //   WB R2-M1: (WB Final)
    //   LB R1-M1: (LB match fed from WB R1 losers)
    //   LB R2-M1: (LB Final — LB R1 winner vs WB R2 loser)
    //   GF: (bracketId = 'gf_wb') — WB champion vs LB champion
    //   RESET: (bracketId = 'gf_wb', roundNumber = GF+1)

    const winnersBracketId = 'wb-bracket';
    const losersBracketId = 'lb-bracket';
    const grandFinalsBracketId = 'gf_wb-bracket';

    const alice = 'alice-id';
    const bob = 'bob-id';
    const carol = 'carol-id';
    const dave = 'dave-id';

    /// Builds a minimal 4-player DE bracket with configurable match outcomes.
    List<MatchEntity> _buildDoubleEliminationBracket({
      required String wbFinalWinnerId,
      required String wbFinalLoserId,
      required String lbFinalWinnerId,
      required String lbFinalLoserId,
      required String gf1WinnerId,
      String? gf2WinnerId,
      bool includeResetMatch = true,
    }) {
      // WB final determines WB champion (goes to GF)
      // LB final determines LB champion (goes to GF)
      // GF: WB champion vs LB champion
      // Reset: only if GF1 was won by LB champion

      final gf1LoserId = gf1WinnerId == wbFinalWinnerId
          ? lbFinalWinnerId
          : wbFinalWinnerId;

      final matches = <MatchEntity>[
        // WB R1
        _createMatch(
          id: 'wb-r1-m1',
          bracketId: winnersBracketId,
          roundNumber: 1,
          matchNumberInRound: 1,
          participantBlueId: alice,
          participantRedId: bob,
          winnerId: alice,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
        _createMatch(
          id: 'wb-r1-m2',
          bracketId: winnersBracketId,
          roundNumber: 1,
          matchNumberInRound: 2,
          participantBlueId: carol,
          participantRedId: dave,
          winnerId: carol,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
        // WB R2 (WB Final)
        _createMatch(
          id: 'wb-r2-m1',
          bracketId: winnersBracketId,
          roundNumber: 2,
          matchNumberInRound: 1,
          participantBlueId: alice,
          participantRedId: carol,
          winnerId: wbFinalWinnerId,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
        // LB R1
        _createMatch(
          id: 'lb-r1-m1',
          bracketId: losersBracketId,
          roundNumber: 1,
          matchNumberInRound: 1,
          participantBlueId: bob,
          participantRedId: dave,
          winnerId: lbFinalWinnerId == bob || lbFinalWinnerId == dave
              ? lbFinalWinnerId
              : bob,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
        // LB R2 (LB Final)
        _createMatch(
          id: 'lb-r2-m1',
          bracketId: losersBracketId,
          roundNumber: 2,
          matchNumberInRound: 1,
          participantBlueId: lbFinalWinnerId,
          participantRedId: lbFinalLoserId,
          winnerId: lbFinalWinnerId,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
        // Grand Final (GF1)
        _createMatch(
          id: 'gf1',
          bracketId: grandFinalsBracketId,
          roundNumber: 3,
          matchNumberInRound: 1,
          participantBlueId: wbFinalWinnerId,
          participantRedId: lbFinalWinnerId,
          winnerId: gf1WinnerId,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
      ];

      // Optionally add reset match
      if (includeResetMatch) {
        final String? resetWinnerId = gf2WinnerId;
        matches.add(
          _createMatch(
            id: 'gf2-reset',
            bracketId: grandFinalsBracketId,
            roundNumber: 4,
            matchNumberInRound: 1,
            participantBlueId: resetWinnerId != null ? gf1WinnerId : null,
            participantRedId: resetWinnerId != null ? gf1LoserId : null,
            winnerId: resetWinnerId,
            status: resetWinnerId != null
                ? MatchStatus.completed
                : MatchStatus.pending,
            resultType:
                resetWinnerId != null ? MatchResultType.points : null,
          ),
        );
      }

      return matches;
    }

    test('assigns Gold and Silver from GF1 when no reset match exists', () {
      final matches = _buildDoubleEliminationBracket(
        wbFinalWinnerId: alice,
        wbFinalLoserId: carol,
        lbFinalWinnerId: bob,
        lbFinalLoserId: dave,
        gf1WinnerId: alice,
        includeResetMatch: false,
      );

      final placements = serviceUnderTest.computeRuntimeMedalPlacements(
        matches: matches,
        isDoubleElimination: true,
        winnersBracketId: winnersBracketId,
        losersBracketId: losersBracketId,
      );

      expect(placements.length, greaterThanOrEqualTo(2));
      expect(placements[0].participantId, equals(alice));
      expect(placements[0].rankStatus, equals(1));
      expect(placements[1].participantId, equals(bob));
      expect(placements[1].rankStatus, equals(2));
    });

    test('assigns Gold and Silver from GF2 when reset match is played', () {
      final matches = _buildDoubleEliminationBracket(
        wbFinalWinnerId: alice,
        wbFinalLoserId: carol,
        lbFinalWinnerId: bob,
        lbFinalLoserId: dave,
        gf1WinnerId: bob, // LB champion wins GF1 → triggers reset
        gf2WinnerId: alice, // WB champion wins reset
        includeResetMatch: true,
      );

      final placements = serviceUnderTest.computeRuntimeMedalPlacements(
        matches: matches,
        isDoubleElimination: true,
        winnersBracketId: winnersBracketId,
        losersBracketId: losersBracketId,
      );

      expect(placements.length, greaterThanOrEqualTo(2));
      // Gold = GF2 winner (alice)
      expect(placements[0].participantId, equals(alice));
      expect(placements[0].rankStatus, equals(1));
      // Silver = GF2 loser (bob)
      expect(placements[1].participantId, equals(bob));
      expect(placements[1].rankStatus, equals(2));
    });

    test(
      'assigns Gold and Silver from GF1 when reset exists but is unplayed',
      () {
        // This was the original BUG — the code would find the unplayed reset
        // match (max round), see winnerId == null, and assign NO medals.
        final matches = _buildDoubleEliminationBracket(
          wbFinalWinnerId: alice,
          wbFinalLoserId: carol,
          lbFinalWinnerId: bob,
          lbFinalLoserId: dave,
          gf1WinnerId: alice, // WB champion wins GF1 → no reset needed
          gf2WinnerId: null, // Reset match exists but is unplayed
          includeResetMatch: true,
        );

        final placements = serviceUnderTest.computeRuntimeMedalPlacements(
          matches: matches,
          isDoubleElimination: true,
          winnersBracketId: winnersBracketId,
          losersBracketId: losersBracketId,
        );

        expect(placements.length, greaterThanOrEqualTo(2));
        // Gold = GF1 winner (alice), NOT empty!
        expect(placements[0].participantId, equals(alice));
        expect(placements[0].rankStatus, equals(1));
        // Silver = GF1 loser (bob)
        expect(placements[1].participantId, equals(bob));
        expect(placements[1].rankStatus, equals(2));
      },
    );

    test('assigns Bronze from LB final loser', () {
      final matches = _buildDoubleEliminationBracket(
        wbFinalWinnerId: alice,
        wbFinalLoserId: carol,
        lbFinalWinnerId: bob,
        lbFinalLoserId: dave,
        gf1WinnerId: alice,
        includeResetMatch: false,
      );

      final placements = serviceUnderTest.computeRuntimeMedalPlacements(
        matches: matches,
        isDoubleElimination: true,
        winnersBracketId: winnersBracketId,
        losersBracketId: losersBracketId,
      );

      expect(placements, hasLength(3));

      // 1st Bronze = LB final loser (dave)
      expect(placements[2].participantId, equals(dave));
      expect(placements[2].rankStatus, equals(3));
      expect(placements[2].displayPlacementLabel, equals('1st Bronze'));
    });

    test('returns empty list when no GF match has a winner', () {
      final matches = [
        // WB and LB completed, but GF not yet played
        _createMatch(
          id: 'wb-r1-m1',
          bracketId: winnersBracketId,
          roundNumber: 1,
          matchNumberInRound: 1,
          participantBlueId: alice,
          participantRedId: bob,
          winnerId: alice,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
        _createMatch(
          id: 'lb-r1-m1',
          bracketId: losersBracketId,
          roundNumber: 1,
          matchNumberInRound: 1,
          participantBlueId: bob,
          participantRedId: dave,
          winnerId: bob,
          status: MatchStatus.completed,
          resultType: MatchResultType.points,
        ),
        // GF — pending
        _createMatch(
          id: 'gf1',
          bracketId: grandFinalsBracketId,
          roundNumber: 3,
          matchNumberInRound: 1,
          participantBlueId: alice,
          participantRedId: bob,
          status: MatchStatus.pending,
        ),
      ];

      final placements = serviceUnderTest.computeRuntimeMedalPlacements(
        matches: matches,
        isDoubleElimination: true,
        winnersBracketId: winnersBracketId,
        losersBracketId: losersBracketId,
      );

      expect(placements, isEmpty);
    });
  });
}

import 'dart:math';

import 'package:tkd_saas/features/bracket/domain/entities/bracket_medal_placement_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/services/bracket_medal_computation_service.dart';

/// Implementation of [BracketMedalComputationService].
///
/// This is a stateless, pure-logic class that can be instantiated directly
/// anywhere — no DI registration needed since it holds no dependencies.
class BracketMedalComputationServiceImplementation
    implements BracketMedalComputationService {
  const BracketMedalComputationServiceImplementation();

  @override
  List<BracketMedalPlacementEntity> computeRuntimeMedalPlacements({
    required List<MatchEntity> matches,
    required bool isDoubleElimination,
    String? winnersBracketId,
    String? losersBracketId,
    bool includeThirdPlaceMatch = false,
  }) {
    if (matches.isEmpty) return const [];

    if (isDoubleElimination) {
      return _computeDoubleEliminationMedalPlacements(
        matches: matches,
        winnersBracketId: winnersBracketId,
        losersBracketId: losersBracketId,
      );
    }

    return _computeSingleEliminationMedalPlacements(
      matches: matches,
      includeThirdPlaceMatch: includeThirdPlaceMatch,
    );
  }

  // ── Single Elimination ──────────────────────────────────────────────────────

  /// Gold/Silver come from the championship final (max round, match #1).
  /// Bronze positions come from the optional 3rd-place match (max round, match #2).
  List<BracketMedalPlacementEntity> _computeSingleEliminationMedalPlacements({
    required List<MatchEntity> matches,
    required bool includeThirdPlaceMatch,
  }) {
    final placements = <BracketMedalPlacementEntity>[];

    final maximumRoundNumber =
        matches.map((matchEntity) => matchEntity.roundNumber).reduce(max);

    // ── Gold & Silver from the final match ──
    final championshipFinalMatch = matches
        .where(
          (matchEntity) =>
              matchEntity.roundNumber == maximumRoundNumber &&
              matchEntity.matchNumberInRound == 1,
        )
        .firstOrNull;

    if (championshipFinalMatch == null ||
        championshipFinalMatch.winnerId == null) {
      return placements;
    }

    // Gold = winner of the final
    placements.add(
      BracketMedalPlacementEntity(
        participantId: championshipFinalMatch.winnerId!,
        rankStatus: 1,
        displayPlacementLabel: 'Gold',
      ),
    );

    // Silver = loser of the final
    final silverMedalistParticipantId = _determineLoserParticipantId(
      championshipFinalMatch,
    );
    if (silverMedalistParticipantId != null) {
      placements.add(
        BracketMedalPlacementEntity(
          participantId: silverMedalistParticipantId,
          rankStatus: 2,
          displayPlacementLabel: 'Silver',
        ),
      );
    }

    // ── Bronze from the 3rd-place match ──
    if (!includeThirdPlaceMatch) return placements;

    final thirdPlaceMatch = matches
        .where(
          (matchEntity) =>
              matchEntity.roundNumber == maximumRoundNumber &&
              matchEntity.matchNumberInRound == 2,
        )
        .firstOrNull;

    if (thirdPlaceMatch == null) return placements;

    // 1st Bronze = 3rd-place match winner
    if (thirdPlaceMatch.winnerId != null) {
      placements.add(
        BracketMedalPlacementEntity(
          participantId: thirdPlaceMatch.winnerId!,
          rankStatus: 3,
          displayPlacementLabel: '1st Bronze',
        ),
      );
    }

    // 2nd Bronze = 3rd-place match loser
    final secondBronzeMedalistParticipantId = _determineLoserParticipantId(
      thirdPlaceMatch,
    );
    if (secondBronzeMedalistParticipantId != null) {
      placements.add(
        BracketMedalPlacementEntity(
          participantId: secondBronzeMedalistParticipantId,
          rankStatus: 4,
          displayPlacementLabel: '2nd Bronze',
        ),
      );
    }

    return placements;
  }

  // ── Double Elimination ──────────────────────────────────────────────────────

  /// Gold/Silver come from the last completed Grand Final match.
  /// In DE, GF matches have a `bracketId` that is neither [winnersBracketId]
  /// nor [losersBracketId]. If a reset match (GF2) was played, medals come
  /// from it; otherwise from GF1.
  ///
  /// Bronze = the loser of the Losers Bracket final (the participant who lost
  /// the last LB round and did not advance to the Grand Finals).
  List<BracketMedalPlacementEntity> _computeDoubleEliminationMedalPlacements({
    required List<MatchEntity> matches,
    required String? winnersBracketId,
    required String? losersBracketId,
  }) {
    final placements = <BracketMedalPlacementEntity>[];

    // Identify Grand Finals matches (bracketId ≠ WB and ≠ LB).
    final grandFinalsMatches = matches
        .where(
          (matchEntity) =>
              matchEntity.bracketId != winnersBracketId &&
              matchEntity.bracketId != losersBracketId,
        )
        .toList()
      ..sort(
        (a, b) => b.roundNumber.compareTo(a.roundNumber),
      ); // Descending by round — GF2 first, then GF1.

    if (grandFinalsMatches.isEmpty) return placements;

    // Find the last completed GF match (GF2 if played, else GF1).
    final decidingGrandFinalMatch = grandFinalsMatches
        .where(
          (matchEntity) => matchEntity.winnerId != null,
        )
        .firstOrNull;

    if (decidingGrandFinalMatch == null) return placements;

    // ── Gold = GF winner ──
    placements.add(
      BracketMedalPlacementEntity(
        participantId: decidingGrandFinalMatch.winnerId!,
        rankStatus: 1,
        displayPlacementLabel: 'Gold',
      ),
    );

    // ── Silver = GF loser ──
    final silverMedalistParticipantId = _determineLoserParticipantId(
      decidingGrandFinalMatch,
    );
    if (silverMedalistParticipantId != null) {
      placements.add(
        BracketMedalPlacementEntity(
          participantId: silverMedalistParticipantId,
          rankStatus: 2,
          displayPlacementLabel: 'Silver',
        ),
      );
    }

    // ── Bronze = LB final loser ──
    if (losersBracketId == null) return placements;

    final losersBracketMatches = matches
        .where((matchEntity) => matchEntity.bracketId == losersBracketId)
        .toList();

    if (losersBracketMatches.isEmpty) return placements;

    final maximumLosersBracketRoundNumber = losersBracketMatches
        .map((matchEntity) => matchEntity.roundNumber)
        .reduce(max);

    final losersBracketFinalMatch = losersBracketMatches
        .where(
          (matchEntity) =>
              matchEntity.roundNumber == maximumLosersBracketRoundNumber &&
              matchEntity.matchNumberInRound == 1,
        )
        .firstOrNull;

    if (losersBracketFinalMatch == null ||
        losersBracketFinalMatch.winnerId == null) {
      return placements;
    }

    // The person who LOST the LB final is 3rd place (they were eliminated
    // and did not advance to the GF).
    final bronzeMedalistParticipantId = _determineLoserParticipantId(
      losersBracketFinalMatch,
    );
    if (bronzeMedalistParticipantId != null) {
      placements.add(
        BracketMedalPlacementEntity(
          participantId: bronzeMedalistParticipantId,
          rankStatus: 3,
          displayPlacementLabel: '1st Bronze',
        ),
      );
    }

    return placements;
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /// Determines the loser of a completed [matchEntity] given its [winnerId].
  /// Returns `null` when the loser cannot be determined (e.g., a BYE match
  /// with only one participant).
  String? _determineLoserParticipantId(MatchEntity matchEntity) {
    if (matchEntity.winnerId == null) return null;
    if (matchEntity.winnerId == matchEntity.participantBlueId) {
      return matchEntity.participantRedId;
    }
    if (matchEntity.winnerId == matchEntity.participantRedId) {
      return matchEntity.participantBlueId;
    }
    return null;
  }
}

import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/services/match_progression_service.dart';

/// Implementation of [MatchProgressionService].
///
/// The match list is treated as immutable — all mutations produce new
/// copies via `copyWith`. The returned list preserves the original order.
@LazySingleton(as: MatchProgressionService)
class MatchProgressionServiceImplementation
    implements MatchProgressionService {
  /// Maximum consecutive auto-advancement walkovers before an error.
  static const _maxByeDepth = 3;

  @override
  List<MatchEntity> recordResult({
    required List<MatchEntity> matches,
    required String matchId,
    required String winnerId,
    MatchResultType resultType = MatchResultType.points,
    int? blueScore,
    int? redScore,
  }) {
    // Build a mutable indexed map for efficient updates.
    final matchesById = {for (final matchEntity in matches) matchEntity.id: matchEntity};
    final targetMatch = matchesById[matchId];

    if (targetMatch == null) {
      throw ArgumentError('Match $matchId not found');
    }
    if (targetMatch.status == MatchStatus.completed) {
      throw ArgumentError('Match $matchId is already completed');
    }

    // F5: Validate winnerId belongs to this match.
    if (winnerId != targetMatch.participantBlueId &&
        winnerId != targetMatch.participantRedId) {
      throw ArgumentError(
        'Winner $winnerId is not a participant in match $matchId',
      );
    }

    // Determine loser.
    final defeatedParticipantId = _determineDefeatedParticipantId(targetMatch, winnerId);

    // 1. Mark match completed.
    final now = DateTime.now();
    matchesById[matchId] = targetMatch.copyWith(
      winnerId: winnerId,
      status: MatchStatus.completed,
      resultType: resultType,
      completedAtTimestamp: now,
      blueScore: blueScore,
      redScore: redScore,
    );

    // 2. Advance winner to next match.
    if (targetMatch.winnerAdvancesToMatchId != null) {
      _placeParticipantIntoNextMatch(
        matchesById: matchesById,
        intoMatchId: targetMatch.winnerAdvancesToMatchId!,
        participantId: winnerId,
        sourceMatchId: matchId,
      );
    }

    // 3. Drop loser to LB match (double elimination).
    if (targetMatch.loserAdvancesToMatchId != null && defeatedParticipantId != null) {
      _placeParticipantIntoNextMatch(
        matchesById: matchesById,
        intoMatchId: targetMatch.loserAdvancesToMatchId!,
        participantId: defeatedParticipantId,
        sourceMatchId: matchId,
      );
    }

    // 4. Auto-advance any resulting byes (cascading).
    _cascadeByeAdvancements(matchesById, depth: 0);

    // Return the list in original order.
    return matches.map((matchEntity) => matchesById[matchEntity.id]!).toList();
  }

  /// Determines which participant lost the match given the [winnerId].
  String? _determineDefeatedParticipantId(MatchEntity match, String winnerId) {
    if (match.participantBlueId == winnerId) {
      return match.participantRedId;
    }
    if (match.participantRedId == winnerId) {
      return match.participantBlueId;
    }
    return null;
  }

  /// Places [participantId] into the correct slot of [intoMatchId].
  ///
  /// Slot assignment logic:
  /// - Find the feeder match [sourceMatchId] in the target's inputs.
  /// - If the source fed the "top" input → Blue slot.
  /// - If the source fed the "bottom" input → Red slot.
  /// - Fallback: fill whichever slot is empty.
  ///
  /// Uses compound sort key (roundNumber, matchNumberInRound) and
  /// detects whether the source fed via winnerAdvancesToMatchId or
  /// loserAdvancesToMatchId for cross-bracket routing in DE.
  void _placeParticipantIntoNextMatch({
    required Map<String, MatchEntity> matchesById,
    required String intoMatchId,
    required String participantId,
    required String sourceMatchId,
  }) {
    final targetMatch = matchesById[intoMatchId];
    if (targetMatch == null) return;

    // Find all matches whose winner or loser routes to this target.
    final feederMatches = matchesById.values
        .where((feeder) =>
            feeder.winnerAdvancesToMatchId == intoMatchId ||
            feeder.loserAdvancesToMatchId == intoMatchId)
        .toList()
      ..sort((a, b) {
        // F4: compound sort by (roundNumber, matchNumberInRound)
        final roundComparison = a.roundNumber.compareTo(b.roundNumber);
        if (roundComparison != 0) return roundComparison;
        return a.matchNumberInRound.compareTo(b.matchNumberInRound);
      });

    // Determine slot based on feeder ordering.
    bool assignToBlueSlot;
    if (feederMatches.length >= 2) {
      // First feeder (earlier round or lower matchNumber) → Blue.
      assignToBlueSlot = feederMatches.first.id == sourceMatchId;
    } else {
      // Single feeder or fallback: fill whichever slot is empty.
      assignToBlueSlot = targetMatch.participantBlueId == null;
    }

    if (assignToBlueSlot) {
      matchesById[intoMatchId] = targetMatch.copyWith(participantBlueId: participantId);
    } else {
      matchesById[intoMatchId] = targetMatch.copyWith(participantRedId: participantId);
    }
  }

  /// Recursively auto-advances matches where one participant faces a bye
  /// (i.e., only one slot is filled and no feeder can provide the other).
  ///
  /// F3 fix: Also handles loser routing — a bye winner's "loser" slot is
  /// phantom, so we don't route a real participant to LB but we do need the
  /// feeder to be marked completed so downstream `_hasPendingFeeder` checks
  /// can resolve. This is handled naturally since we mark the match completed.
  void _cascadeByeAdvancements(Map<String, MatchEntity> matchesById, {required int depth}) {
    if (depth >= _maxByeDepth) return;

    bool hasChanges = false;
    for (final matchId in matchesById.keys.toList()) {
      final currentMatch = matchesById[matchId]!;
      if (currentMatch.status == MatchStatus.completed) continue;

      final hasBlueParticipant = currentMatch.participantBlueId != null;
      final hasRedParticipant = currentMatch.participantRedId != null;

      // Both slots empty + no pending feeders → phantom match, mark completed.
      if (!hasBlueParticipant && !hasRedParticipant && !_hasPendingFeederMatch(matchesById, matchId)) {
        matchesById[matchId] = currentMatch.copyWith(
          status: MatchStatus.completed,
          resultType: MatchResultType.bye,
          completedAtTimestamp: DateTime.now(),
        );
        hasChanges = true;
        continue;
      }

      if (hasBlueParticipant && !hasRedParticipant) {
        if (!_hasPendingFeederMatch(matchesById, matchId)) {
          final now = DateTime.now();
          matchesById[matchId] = currentMatch.copyWith(
            winnerId: currentMatch.participantBlueId,
            status: MatchStatus.completed,
            resultType: MatchResultType.bye,
            completedAtTimestamp: now,
          );
          if (currentMatch.winnerAdvancesToMatchId != null) {
            _placeParticipantIntoNextMatch(
              matchesById: matchesById,
              intoMatchId: currentMatch.winnerAdvancesToMatchId!,
              participantId: currentMatch.participantBlueId!,
              sourceMatchId: matchId,
            );
          }
          // F3: loserAdvancesToMatchId is not routed (no real loser in a bye)
          // but marking this match completed resolves downstream pending checks.
          hasChanges = true;
        }
      } else if (!hasBlueParticipant && hasRedParticipant) {
        if (!_hasPendingFeederMatch(matchesById, matchId)) {
          final now = DateTime.now();
          matchesById[matchId] = currentMatch.copyWith(
            winnerId: currentMatch.participantRedId,
            status: MatchStatus.completed,
            resultType: MatchResultType.bye,
            completedAtTimestamp: now,
          );
          if (currentMatch.winnerAdvancesToMatchId != null) {
            _placeParticipantIntoNextMatch(
              matchesById: matchesById,
              intoMatchId: currentMatch.winnerAdvancesToMatchId!,
              participantId: currentMatch.participantRedId!,
              sourceMatchId: matchId,
            );
          }
          hasChanges = true;
        }
      }
    }

    if (hasChanges) {
      _cascadeByeAdvancements(matchesById, depth: depth + 1);
    }
  }

  /// Returns true if there is at least one pending match that feeds into [matchId].
  bool _hasPendingFeederMatch(Map<String, MatchEntity> matchesById, String matchId) {
    return matchesById.values.any((feederMatch) =>
        feederMatch.status != MatchStatus.completed &&
        (feederMatch.winnerAdvancesToMatchId == matchId ||
            feederMatch.loserAdvancesToMatchId == matchId));
  }
}

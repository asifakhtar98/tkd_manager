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
    final byId = {for (final m in matches) m.id: m};
    final target = byId[matchId];

    if (target == null) {
      throw ArgumentError('Match $matchId not found');
    }
    if (target.status == MatchStatus.completed) {
      throw ArgumentError('Match $matchId is already completed');
    }

    // F5: Validate winnerId belongs to this match.
    if (winnerId != target.participantBlueId &&
        winnerId != target.participantRedId) {
      throw ArgumentError(
        'Winner $winnerId is not a participant in match $matchId',
      );
    }

    // Determine loser.
    final loserId = _loserId(target, winnerId);

    // 1. Mark match completed.
    final now = DateTime.now();
    byId[matchId] = target.copyWith(
      winnerId: winnerId,
      status: MatchStatus.completed,
      resultType: resultType,
      completedAtTimestamp: now,
      blueScore: blueScore,
      redScore: redScore,
    );

    // 2. Advance winner to next match.
    if (target.winnerAdvancesToMatchId != null) {
      _placeParticipant(
        byId: byId,
        intoMatchId: target.winnerAdvancesToMatchId!,
        participantId: winnerId,
        sourceMatchId: matchId,
      );
    }

    // 3. Drop loser to LB match (double elimination).
    if (target.loserAdvancesToMatchId != null && loserId != null) {
      _placeParticipant(
        byId: byId,
        intoMatchId: target.loserAdvancesToMatchId!,
        participantId: loserId,
        sourceMatchId: matchId,
      );
    }

    // 4. Auto-advance any resulting byes (cascading).
    _autoAdvanceByes(byId, depth: 0);

    // Return the list in original order.
    return matches.map((m) => byId[m.id]!).toList();
  }

  /// Determines which participant is the loser.
  String? _loserId(MatchEntity match, String winnerId) {
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
  /// Places [participantId] into the correct slot of [intoMatchId].
  ///
  /// F4 fix: Uses compound sort key (roundNumber, matchNumberInRound) and
  /// detects whether the source fed via winnerAdvancesToMatchId or
  /// loserAdvancesToMatchId for cross-bracket routing in DE.
  void _placeParticipant({
    required Map<String, MatchEntity> byId,
    required String intoMatchId,
    required String participantId,
    required String sourceMatchId,
  }) {
    final target = byId[intoMatchId];
    if (target == null) return;

    // Find all matches whose winner or loser routes to this target.
    final feeders = byId.values
        .where((m) =>
            m.winnerAdvancesToMatchId == intoMatchId ||
            m.loserAdvancesToMatchId == intoMatchId)
        .toList()
      ..sort((a, b) {
        // F4: compound sort by (roundNumber, matchNumberInRound)
        final rCmp = a.roundNumber.compareTo(b.roundNumber);
        if (rCmp != 0) return rCmp;
        return a.matchNumberInRound.compareTo(b.matchNumberInRound);
      });

    // Determine slot based on feeder ordering.
    bool isBlue;
    if (feeders.length >= 2) {
      // First feeder (earlier round or lower matchNumber) → Blue.
      isBlue = feeders.first.id == sourceMatchId;
    } else {
      // Single feeder or fallback: fill whichever slot is empty.
      isBlue = target.participantBlueId == null;
    }

    if (isBlue) {
      byId[intoMatchId] = target.copyWith(participantBlueId: participantId);
    } else {
      byId[intoMatchId] = target.copyWith(participantRedId: participantId);
    }
  }

  /// Recursively auto-advances matches where one participant faces a bye
  /// (i.e., only one slot is filled and no feeder can provide the other).
  ///
  /// F3 fix: Also handles loser routing — a bye winner's "loser" slot is
  /// phantom, so we don't route a real participant to LB but we do need the
  /// feeder to be marked completed so downstream `_hasPendingFeeder` checks
  /// can resolve. This is handled naturally since we mark the match completed.
  void _autoAdvanceByes(Map<String, MatchEntity> byId, {required int depth}) {
    if (depth >= _maxByeDepth) return;

    bool changed = false;
    for (final matchId in byId.keys.toList()) {
      final m = byId[matchId]!;
      if (m.status == MatchStatus.completed) continue;

      final hasBlue = m.participantBlueId != null;
      final hasRed = m.participantRedId != null;

      // Both slots empty + no pending feeders → phantom match, mark completed.
      if (!hasBlue && !hasRed && !_hasPendingFeeder(byId, matchId)) {
        byId[matchId] = m.copyWith(
          status: MatchStatus.completed,
          resultType: MatchResultType.bye,
          completedAtTimestamp: DateTime.now(),
        );
        changed = true;
        continue;
      }

      if (hasBlue && !hasRed) {
        if (!_hasPendingFeeder(byId, matchId)) {
          final now = DateTime.now();
          byId[matchId] = m.copyWith(
            winnerId: m.participantBlueId,
            status: MatchStatus.completed,
            resultType: MatchResultType.bye,
            completedAtTimestamp: now,
          );
          if (m.winnerAdvancesToMatchId != null) {
            _placeParticipant(
              byId: byId,
              intoMatchId: m.winnerAdvancesToMatchId!,
              participantId: m.participantBlueId!,
              sourceMatchId: matchId,
            );
          }
          // F3: loserAdvancesToMatchId is not routed (no real loser in a bye)
          // but marking this match completed resolves downstream pending checks.
          changed = true;
        }
      } else if (!hasBlue && hasRed) {
        if (!_hasPendingFeeder(byId, matchId)) {
          final now = DateTime.now();
          byId[matchId] = m.copyWith(
            winnerId: m.participantRedId,
            status: MatchStatus.completed,
            resultType: MatchResultType.bye,
            completedAtTimestamp: now,
          );
          if (m.winnerAdvancesToMatchId != null) {
            _placeParticipant(
              byId: byId,
              intoMatchId: m.winnerAdvancesToMatchId!,
              participantId: m.participantRedId!,
              sourceMatchId: matchId,
            );
          }
          changed = true;
        }
      }
    }

    if (changed) {
      _autoAdvanceByes(byId, depth: depth + 1);
    }
  }

  /// Returns true if there's at least one pending match that feeds into [matchId].
  bool _hasPendingFeeder(Map<String, MatchEntity> byId, String matchId) {
    return byId.values.any((m) =>
        m.status != MatchStatus.completed &&
        (m.winnerAdvancesToMatchId == matchId ||
            m.loserAdvancesToMatchId == matchId));
  }

}

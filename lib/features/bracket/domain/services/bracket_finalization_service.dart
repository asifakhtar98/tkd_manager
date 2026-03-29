import 'package:tkd_saas/features/bracket/domain/entities/bracket_medal_placement_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/double_elimination_bracket_generation_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_generation_result.dart';

/// Service responsible for finalizing a bracket.
/// This freezes the runtime state (like medal placements) into persistent fields
/// on the BracketEntity so that historical results remain immune to future logic changes.
class BracketFinalizationService {
  /// Marks a bracket result as finalized, calculating and inserting final medal placements.
  ///
  /// Returns a new finalized [BracketResult] instance.
  BracketResult finalizeBracket(BracketResult result) {
    return result.map(
      singleElimination: (s) {
        if (s.data.bracket.isFinalized) return result;
        final placements = _calculateSingleElimination(s.data);
        return BracketResult.singleElimination(
          s.data.copyWith(
            bracket: s.data.bracket.copyWith(
              isFinalized: true,
              finalizedAtTimestamp: DateTime.timestamp(),
              finalMedalPlacements: placements,
            ),
          ),
        );
      },
      doubleElimination: (d) {
        if (d.data.winnersBracket.isFinalized) return result;
        final placements = _calculateDoubleElimination(d.data);
        return BracketResult.doubleElimination(
          d.data.copyWith(
            winnersBracket: d.data.winnersBracket.copyWith(
              isFinalized: true,
              finalizedAtTimestamp: DateTime.timestamp(),
              finalMedalPlacements: placements,
            ),
            losersBracket: d.data.losersBracket.copyWith(
              isFinalized: true,
              finalizedAtTimestamp: DateTime.timestamp(),
            ),
          ),
        );
      },
    );
  }

  List<BracketMedalPlacementEntity> _calculateSingleElimination(
    BracketGenerationResult data,
  ) {
    final matches = data.matches;
    if (matches.isEmpty) return [];

    int allRounds = 1;
    for (final m in matches) {
      if (m.roundNumber > allRounds) allRounds = m.roundNumber;
    }

    // Finals
    final finals = matches
        .where((m) => m.roundNumber == allRounds && m.matchNumberInRound == 1)
        .firstOrNull;
    final placements = <BracketMedalPlacementEntity>[];

    if (finals != null && finals.winnerId != null) {
      placements.add(
        BracketMedalPlacementEntity(
          participantId: finals.winnerId!,
          rankStatus: 1,
          displayPlacementLabel: '1st',
        ),
      );
      final silverId = finals.winnerId == finals.participantRedId
          ? finals.participantBlueId
          : finals.participantRedId;
      if (silverId != null) {
        placements.add(
          BracketMedalPlacementEntity(
            participantId: silverId,
            rankStatus: 2,
            displayPlacementLabel: '2nd',
          ),
        );
      }
    }

    // 3rd place match
    final thirdM = matches
        .where((m) => m.roundNumber == allRounds && m.matchNumberInRound == 2)
        .firstOrNull;
    if (thirdM != null) {
      if (thirdM.winnerId != null) {
        placements.add(
          BracketMedalPlacementEntity(
            participantId: thirdM.winnerId!,
            rankStatus: 3,
            displayPlacementLabel: '3rd',
          ),
        );
        final loserId = thirdM.winnerId == thirdM.participantRedId
            ? thirdM.participantBlueId
            : thirdM.participantRedId;
        if (loserId != null) {
          placements.add(
            BracketMedalPlacementEntity(
              participantId: loserId,
              rankStatus: 4,
              displayPlacementLabel: '3rd',
            ),
          );
        }
      }
    } else {
      // Award bronze to both semi-final losers
      if (allRounds > 1) {
        final semiFinals = matches
            .where((m) => m.roundNumber == allRounds - 1)
            .toList();
        for (final semi in semiFinals) {
          if (semi.winnerId != null) {
            final loserId = semi.winnerId == semi.participantRedId
                ? semi.participantBlueId
                : semi.participantRedId;
            if (loserId != null) {
              placements.add(
                BracketMedalPlacementEntity(
                  participantId: loserId,
                  rankStatus: placements.length == 2 ? 3 : 4,
                  displayPlacementLabel: '3rd',
                ),
              );
            }
          }
        }
      }
    }
    return placements;
  }

  List<BracketMedalPlacementEntity> _calculateDoubleElimination(
    DoubleEliminationBracketGenerationResult data,
  ) {
    final placements = <BracketMedalPlacementEntity>[];

    // Grand Finals (consider Reset Match if it exists and has a winner)
    final finalMatchInfo =
        (data.resetMatch != null && data.resetMatch!.winnerId != null)
        ? data.resetMatch!
        : data.grandFinalsMatch;

    if (finalMatchInfo.winnerId != null) {
      placements.add(
        BracketMedalPlacementEntity(
          participantId: finalMatchInfo.winnerId!,
          rankStatus: 1,
          displayPlacementLabel: '1st',
        ),
      );
      final silverId =
          finalMatchInfo.winnerId == finalMatchInfo.participantRedId
          ? finalMatchInfo.participantBlueId
          : finalMatchInfo.participantRedId;
      if (silverId != null) {
        placements.add(
          BracketMedalPlacementEntity(
            participantId: silverId,
            rankStatus: 2,
            displayPlacementLabel: '2nd',
          ),
        );
      }
    }

    // Bronze goes to the loser of the Losers Bracket Final.
    // The Losers Bracket Final is the match in the losers bracket with the highest round number.
    final losersMatches = data.allMatches
        .where((m) => m.bracketId == data.losersBracket.id)
        .toList();
    if (losersMatches.isNotEmpty) {
      int maxLoserRound = 1;
      for (final m in losersMatches) {
        if (m.roundNumber > maxLoserRound) maxLoserRound = m.roundNumber;
      }
      final losersFinal = losersMatches
          .where(
            (m) => m.roundNumber == maxLoserRound && m.matchNumberInRound == 1,
          )
          .firstOrNull;
      if (losersFinal != null && losersFinal.winnerId != null) {
        final bronzeId = losersFinal.winnerId == losersFinal.participantRedId
            ? losersFinal.participantBlueId
            : losersFinal.participantRedId;
        if (bronzeId != null) {
          placements.add(
            BracketMedalPlacementEntity(
              participantId: bronzeId,
              rankStatus: 3,
              displayPlacementLabel: '3rd',
            ),
          );
        }
      }
    }

    return placements;
  }
}

import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_generation_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/services/match_numbering_utility.dart';
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart';
import 'package:uuid/uuid.dart';

/// Minimum number of participants required for a valid bracket.
const int _minimumParticipantCount = 2;

/// Returns `2^exponent` as an integer.
int _powerOfTwo(int exponent) => pow(2, exponent).toInt();

/// Implementation of [SingleEliminationBracketGeneratorService].
///
/// Generates a complete single-elimination bracket with proper seeding,
/// BYE handling, and optional 3rd-place match support.
@LazySingleton(as: SingleEliminationBracketGeneratorService)
class SingleEliminationBracketGeneratorServiceImplementation
    implements SingleEliminationBracketGeneratorService {
  SingleEliminationBracketGeneratorServiceImplementation(this._uuid);

  final Uuid _uuid;

  @override
  BracketGenerationResult generate({
    required String genderId,
    required List<String> participantIds,
    required String bracketId,
    bool includeThirdPlaceMatch = false,
  }) {
    final participantCount = participantIds.length;
    if (participantCount < _minimumParticipantCount) {
      throw ArgumentError(
        'At least $_minimumParticipantCount participants are required '
        'to generate a single elimination bracket.',
      );
    }

    final numberOfRounds = (log(participantCount) / ln2).ceil();
    final bracketSize = _powerOfTwo(numberOfRounds);
    final now = DateTime.now();

    // Total matches: bracketSize - 1 (standard) + optional 3rd place
    final standardMatchCount = bracketSize - 1;
    final hasThirdPlaceMatch = includeThirdPlaceMatch && numberOfRounds >= 2;
    final totalMatchCount = standardMatchCount + (hasThirdPlaceMatch ? 1 : 0);

    // Pre-generate all match IDs upfront for deterministic linking.
    final matchIds = List.generate(totalMatchCount, (_) => _uuid.v4());

    final bracket = BracketEntity(
      id: bracketId,
      genderId: genderId,
      bracketType: BracketType.winners,
      totalRounds: numberOfRounds,
      createdAtTimestamp: now,
      updatedAtTimestamp: now,
      generatedAtTimestamp: now,
      bracketDataJson: {
        'includeThirdPlaceMatch': includeThirdPlaceMatch,
        'participantCount': participantCount,
      },
    );

    // 1. Create all match slots, indexed by round and position.
    final matchesByRoundAndPosition = _createMatchSlots(
      bracketId,
      numberOfRounds,
      bracketSize,
      matchIds,
      now,
    );

    // 2. Link winner-advancement paths between rounds.
    _linkMatchAdvancements(matchesByRoundAndPosition, numberOfRounds);

    // 3. Assign participants to Round 1 using standard WT seeding.
    _assignParticipantsToFirstRound(
      matchesByRoundAndPosition: matchesByRoundAndPosition,
      participantIds: participantIds,
      participantCount: participantCount,
      numberOfRounds: numberOfRounds,
      now: now,
    );

    // 4. Create and link 3rd-place match if requested.
    MatchEntity? thirdPlaceMatch;
    if (hasThirdPlaceMatch) {
      thirdPlaceMatch = _createThirdPlaceMatch(
        matchesByRoundAndPosition: matchesByRoundAndPosition,
        matchId: matchIds.last,
        bracketId: bracketId,
        numberOfRounds: numberOfRounds,
        now: now,
      );
    }

    // 5. Advance BYE winners into Round 2.
    if (numberOfRounds >= 2) {
      _advanceByeWinnersToNextRound(matchesByRoundAndPosition);
    }

    // Flatten into a single list.
    final rawMatches = <MatchEntity>[
      for (final roundMatches in matchesByRoundAndPosition.values)
        ...roundMatches.values,
      ?thirdPlaceMatch,
    ];

    // Assign global display numbers.
    final allMatches = MatchNumberingUtility.assignGlobalMatchNumbers(
      matches: rawMatches,
      isDoubleElimination: false,
    );

    return BracketGenerationResult(bracket: bracket, matches: allMatches);
  }

  // ─────────────────────────────────────────
  // Private Helpers
  // ─────────────────────────────────────────

  /// Creates all match slots for every round, returning a map of
  /// `round → { matchPosition → MatchEntity }`.
  Map<int, Map<int, MatchEntity>> _createMatchSlots(
    String bracketId,
    int numberOfRounds,
    int bracketSize,
    List<String> matchIds,
    DateTime now,
  ) {
    final matchesByRoundAndPosition = <int, Map<int, MatchEntity>>{};
    var matchIdIndex = 0;

    for (var roundNumber = 1; roundNumber <= numberOfRounds; roundNumber++) {
      matchesByRoundAndPosition[roundNumber] = {};
      final matchCountInRound = bracketSize ~/ _powerOfTwo(roundNumber);

      for (
        var matchPosition = 1;
        matchPosition <= matchCountInRound;
        matchPosition++
      ) {
        matchesByRoundAndPosition[roundNumber]![matchPosition] = MatchEntity(
          id: matchIds[matchIdIndex++],
          bracketId: bracketId,
          roundNumber: roundNumber,
          matchNumberInRound: matchPosition,
          createdAtTimestamp: now,
          updatedAtTimestamp: now,
          status: MatchStatus.pending,
        );
      }
    }

    return matchesByRoundAndPosition;
  }

  /// Links each match's winner to the next round's corresponding match slot.
  void _linkMatchAdvancements(
    Map<int, Map<int, MatchEntity>> matchesByRoundAndPosition,
    int numberOfRounds,
  ) {
    for (var roundNumber = 1; roundNumber < numberOfRounds; roundNumber++) {
      final currentRoundMatches = matchesByRoundAndPosition[roundNumber]!;
      for (
        var matchPosition = 1;
        matchPosition <= currentRoundMatches.length;
        matchPosition++
      ) {
        final nextRoundMatchPosition = (matchPosition + 1) ~/ 2;
        final nextRoundMatch =
            matchesByRoundAndPosition[roundNumber +
                1]![nextRoundMatchPosition]!;

        currentRoundMatches[matchPosition] = currentRoundMatches[matchPosition]!
            .copyWith(winnerAdvancesToMatchId: nextRoundMatch.id);
      }
    }
  }

  /// Assigns participants to Round 1 using standard WT bracket seeding.
  /// Automatically marks single-entrant (BYE) slots as completed.
  void _assignParticipantsToFirstRound({
    required Map<int, Map<int, MatchEntity>> matchesByRoundAndPosition,
    required List<String> participantIds,
    required int participantCount,
    required int numberOfRounds,
    required DateTime now,
  }) {
    final firstRoundMatches = matchesByRoundAndPosition[1]!;
    final seedingOrder = _generateSeedingOrder(numberOfRounds);

    for (
      var matchPosition = 1;
      matchPosition <= firstRoundMatches.length;
      matchPosition++
    ) {
      final blueSeedNumber = seedingOrder[(matchPosition - 1) * 2];
      final redSeedNumber = seedingOrder[(matchPosition - 1) * 2 + 1];

      final blueParticipantId = blueSeedNumber <= participantCount
          ? participantIds[blueSeedNumber - 1]
          : null;
      final redParticipantId = redSeedNumber <= participantCount
          ? participantIds[redSeedNumber - 1]
          : null;

      var currentMatch = firstRoundMatches[matchPosition]!.copyWith(
        participantBlueId: blueParticipantId,
        participantRedId: redParticipantId,
      );

      // Auto-complete BYE matches.
      if (blueParticipantId != null && redParticipantId == null) {
        currentMatch = currentMatch.copyWith(
          status: MatchStatus.completed,
          resultType: MatchResultType.bye,
          completedAtTimestamp: now,
          winnerId: blueParticipantId,
        );
      } else if (blueParticipantId == null && redParticipantId != null) {
        currentMatch = currentMatch.copyWith(
          status: MatchStatus.completed,
          resultType: MatchResultType.bye,
          completedAtTimestamp: now,
          winnerId: redParticipantId,
        );
      }

      firstRoundMatches[matchPosition] = currentMatch;
    }
  }

  /// Recursively builds the standard WT seeding order for a given round count.
  ///
  /// For 3 rounds (8 slots): [1, 8, 5, 4, 3, 6, 7, 2]
  List<int> _generateSeedingOrder(int roundCount) {
    if (roundCount == 1) return [1, 2];
    final previousSeeding = _generateSeedingOrder(roundCount - 1);
    final totalPositions = 1 << roundCount; // 2^roundCount
    final complementSum = totalPositions + 1;
    final seedingOrder = <int>[];
    for (final seedPosition in previousSeeding) {
      seedingOrder.add(seedPosition);
      seedingOrder.add(complementSum - seedPosition);
    }
    return seedingOrder;
  }

  /// Creates the 3rd-place match and links semi-final losers to it.
  MatchEntity _createThirdPlaceMatch({
    required Map<int, Map<int, MatchEntity>> matchesByRoundAndPosition,
    required String matchId,
    required String bracketId,
    required int numberOfRounds,
    required DateTime now,
  }) {
    final thirdPlaceMatch = MatchEntity(
      id: matchId,
      bracketId: bracketId,
      roundNumber: numberOfRounds,
      matchNumberInRound: 2, // Final is position 1
      createdAtTimestamp: now,
      updatedAtTimestamp: now,
      status: MatchStatus.pending,
    );

    // Link semi-final losers to the 3rd-place match.
    final semiFinalsRoundNumber = numberOfRounds - 1;
    final semiFinalsMatches = matchesByRoundAndPosition[semiFinalsRoundNumber]!;

    for (final semiPosition in [1, 2]) {
      if (semiFinalsMatches.containsKey(semiPosition)) {
        semiFinalsMatches[semiPosition] = semiFinalsMatches[semiPosition]!
            .copyWith(loserAdvancesToMatchId: thirdPlaceMatch.id);
      }
    }

    return thirdPlaceMatch;
  }

  /// Advances BYE winners from Round 1 into their Round 2 slots.
  void _advanceByeWinnersToNextRound(
    Map<int, Map<int, MatchEntity>> matchesByRoundAndPosition,
  ) {
    final firstRoundMatches = matchesByRoundAndPosition[1]!;
    final secondRoundMatches = matchesByRoundAndPosition[2]!;

    for (
      var matchPosition = 1;
      matchPosition <= firstRoundMatches.length;
      matchPosition++
    ) {
      final firstRoundMatch = firstRoundMatches[matchPosition]!;
      if (firstRoundMatch.resultType != MatchResultType.bye ||
          firstRoundMatch.winnerId == null) {
        continue;
      }

      final nextRoundMatchPosition = (matchPosition + 1) ~/ 2;
      var nextRoundMatch = secondRoundMatches[nextRoundMatchPosition]!;

      // Odd matches feed blue (top), even matches feed red (bottom).
      if (matchPosition % 2 != 0) {
        nextRoundMatch = nextRoundMatch.copyWith(
          participantBlueId: firstRoundMatch.winnerId,
        );
      } else {
        nextRoundMatch = nextRoundMatch.copyWith(
          participantRedId: firstRoundMatch.winnerId,
        );
      }

      secondRoundMatches[nextRoundMatchPosition] = nextRoundMatch;
    }
  }
}

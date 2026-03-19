import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/double_elimination_bracket_generation_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart';
import 'package:uuid/uuid.dart';

/// Minimum number of participants required for a valid bracket.
const int _minimumParticipantCount = 2;

/// Returns `2^exponent` as an integer.
int _powerOfTwo(int exponent) => pow(2, exponent).toInt();

/// Implementation of [DoubleEliminationBracketGeneratorService].
@LazySingleton(as: DoubleEliminationBracketGeneratorService)
class DoubleEliminationBracketGeneratorServiceImplementation
    implements DoubleEliminationBracketGeneratorService {
  DoubleEliminationBracketGeneratorServiceImplementation(this._uuid);

  final Uuid _uuid;

  @override
  DoubleEliminationBracketGenerationResult generate({
    required String genderId,
    required List<String> participantIds,
    required String winnersBracketId,
    required String losersBracketId,
    bool includeResetMatch = true,
  }) {
    final participantCount = participantIds.length;
    if (participantCount < _minimumParticipantCount) {
      throw ArgumentError(
        'At least $_minimumParticipantCount participants are required '
        'to generate a double elimination bracket.',
      );
    }
    final winnersRoundCount = (log(participantCount) / ln2).ceil();
    final bracketSize = _powerOfTwo(winnersRoundCount);
    // Losers bracket has 2 * (winnersRoundCount - 1) rounds (for n >= 4)
    // For n=2, winnersRoundCount=1, losersRoundCount=0
    final losersRoundCount = max(0, 2 * (winnersRoundCount - 1));
    final now = DateTime.now();

    // Step 1: Calculate total matches and pre-generate all IDs
    final winnersMatchCount = bracketSize - 1;
    final losersMatchCount = max(0, bracketSize - 2);
    const grandFinalsCount = 1;
    final resetCount = includeResetMatch ? 1 : 0;
    final totalMatchCount =
        winnersMatchCount + losersMatchCount + grandFinalsCount + resetCount;
    final matchIds = List.generate(totalMatchCount, (_) => _uuid.v4());

    var matchIdIndex = 0;

    // Step 2: Create winners bracket entity
    final winnersBracket = BracketEntity(
      id: winnersBracketId,
      genderId: genderId,
      bracketType: BracketType.winners,
      totalRounds: winnersRoundCount,
      createdAtTimestamp: now,
      updatedAtTimestamp: now,
      generatedAtTimestamp: now,
      bracketDataJson: {
        'doubleElimination': true,
        'participantCount': participantCount,
        'includeResetMatch': includeResetMatch,
      },
    );

    // Step 3: Create losers bracket entity
    final losersBracket = BracketEntity(
      id: losersBracketId,
      genderId: genderId,
      bracketType: BracketType.losers,
      totalRounds: losersRoundCount,
      createdAtTimestamp: now,
      updatedAtTimestamp: now,
      generatedAtTimestamp: now,
      bracketDataJson: {
        'doubleElimination': true,
        'participantCount': participantCount,
        'includeResetMatch': includeResetMatch,
      },
    );

    // Maps to store matches by round and match number
    final winnersBracketMatches = <int, Map<int, MatchEntity>>{};
    final losersBracketMatches = <int, Map<int, MatchEntity>>{};

    // Step 4: Build winners bracket match slots
    for (var roundNumber = 1; roundNumber <= winnersRoundCount; roundNumber++) {
      winnersBracketMatches[roundNumber] = {};
      final matchCountInRound = bracketSize ~/ _powerOfTwo(roundNumber);
      for (
        var matchPosition = 1;
        matchPosition <= matchCountInRound;
        matchPosition++
      ) {
        winnersBracketMatches[roundNumber]![matchPosition] = MatchEntity(
          id: matchIds[matchIdIndex++],
          bracketId: winnersBracketId,
          roundNumber: roundNumber,
          matchNumberInRound: matchPosition,
          createdAtTimestamp: now,
          updatedAtTimestamp: now,
          status: MatchStatus.pending,
        );
      }
    }

    // Step 5: Build losers bracket match slots
    for (var roundNumber = 1; roundNumber <= losersRoundCount; roundNumber++) {
      losersBracketMatches[roundNumber] = {};
      final pairIndex = (roundNumber + 1) ~/ 2;
      final matchCountInRound = bracketSize ~/ _powerOfTwo(pairIndex + 1);
      for (
        var matchPosition = 1;
        matchPosition <= matchCountInRound;
        matchPosition++
      ) {
        losersBracketMatches[roundNumber]![matchPosition] = MatchEntity(
          id: matchIds[matchIdIndex++],
          bracketId: losersBracketId,
          roundNumber: roundNumber,
          matchNumberInRound: matchPosition,
          createdAtTimestamp: now,
          updatedAtTimestamp: now,
          status: MatchStatus.pending,
        );
      }
    }

    // Step 6: Create Grand Finals and Reset slots
    // GF matches use a dedicated bracketId so the painter can distinguish
    // them from regular WB matches (F1 fix).
    final grandFinalsBracketId = 'gf_$winnersBracketId';
    MatchEntity? resetMatch;

    var grandFinalsMatch = MatchEntity(
      id: matchIds[matchIdIndex++],
      bracketId: grandFinalsBracketId,
      roundNumber: winnersRoundCount + 1,
      matchNumberInRound: 1,
      createdAtTimestamp: now,
      updatedAtTimestamp: now,
      status: MatchStatus.pending,
    );

    if (includeResetMatch) {
      resetMatch = MatchEntity(
        id: matchIds[matchIdIndex++],
        bracketId: grandFinalsBracketId,
        roundNumber: winnersRoundCount + 2,
        matchNumberInRound: 1,
        createdAtTimestamp: now,
        updatedAtTimestamp: now,
        status: MatchStatus.pending,
      );
      grandFinalsMatch = grandFinalsMatch.copyWith(
        winnerAdvancesToMatchId: resetMatch.id,
      );
    }

    // Step 7: Link intra-Winners advancement
    for (var roundNumber = 1; roundNumber < winnersRoundCount; roundNumber++) {
      for (
        var matchPosition = 1;
        matchPosition <= winnersBracketMatches[roundNumber]!.length;
        matchPosition++
      ) {
        final nextMatchPosition = (matchPosition + 1) ~/ 2;
        winnersBracketMatches[roundNumber]![matchPosition] =
            winnersBracketMatches[roundNumber]![matchPosition]!.copyWith(
              winnerAdvancesToMatchId:
                  winnersBracketMatches[roundNumber + 1]![nextMatchPosition]!
                      .id,
            );
      }
    }
    // Winners Final winner advances to Grand Finals
    winnersBracketMatches[winnersRoundCount]![1] =
        winnersBracketMatches[winnersRoundCount]![1]!.copyWith(
          winnerAdvancesToMatchId: grandFinalsMatch.id,
        );

    // Step 8: Link intra-Losers advancement
    for (var roundNumber = 1; roundNumber < losersRoundCount; roundNumber++) {
      final currentRoundMatches = losersBracketMatches[roundNumber]!;
      final nextRoundMatches = losersBracketMatches[roundNumber + 1]!;
      if (roundNumber.isOdd) {
        // Elimination round -> next is drop-down (same count)
        for (
          var matchPosition = 1;
          matchPosition <= currentRoundMatches.length;
          matchPosition++
        ) {
          losersBracketMatches[roundNumber]![matchPosition] =
              losersBracketMatches[roundNumber]![matchPosition]!.copyWith(
                winnerAdvancesToMatchId: nextRoundMatches[matchPosition]!.id,
              );
        }
      } else {
        // Drop-down round -> next is elimination (half count)
        for (
          var matchPosition = 1;
          matchPosition <= currentRoundMatches.length;
          matchPosition++
        ) {
          final nextMatchPosition = (matchPosition + 1) ~/ 2;
          losersBracketMatches[roundNumber]![matchPosition] =
              losersBracketMatches[roundNumber]![matchPosition]!.copyWith(
                winnerAdvancesToMatchId:
                    nextRoundMatches[nextMatchPosition]!.id,
              );
        }
      }
    }
    // Losers Final winner advances to Grand Finals
    if (losersRoundCount > 0) {
      losersBracketMatches[losersRoundCount]![1] =
          losersBracketMatches[losersRoundCount]![1]!.copyWith(
            winnerAdvancesToMatchId: grandFinalsMatch.id,
          );
    }

    // Step 9: Link cross-bracket routing (WB losers -> LB)
    // WB R1 losers -> LB R1
    for (
      var matchPosition = 1;
      matchPosition <= winnersBracketMatches[1]!.length;
      matchPosition++
    ) {
      final losersMatchPosition = (matchPosition + 1) ~/ 2;
      if (losersRoundCount >= 1) {
        winnersBracketMatches[1]![matchPosition] =
            winnersBracketMatches[1]![matchPosition]!.copyWith(
              loserAdvancesToMatchId:
                  losersBracketMatches[1]![losersMatchPosition]!.id,
            );
      } else {
        // Special case n=2: WB loser goes to GF
        winnersBracketMatches[1]![matchPosition] =
            winnersBracketMatches[1]![matchPosition]!.copyWith(
              loserAdvancesToMatchId: grandFinalsMatch.id,
            );
      }
    }

    // WB Round R (R>=2) losers -> LB Round 2*(R-1)
    for (var roundNumber = 2; roundNumber <= winnersRoundCount; roundNumber++) {
      final losersTargetRound = 2 * (roundNumber - 1);
      final winnersRoundMatches = winnersBracketMatches[roundNumber]!;
      final losersRoundMatches = losersBracketMatches[losersTargetRound];
      if (losersRoundMatches != null) {
        for (
          var matchPosition = 1;
          matchPosition <= winnersRoundMatches.length;
          matchPosition++
        ) {
          // Reverse order for fairness
          final losersMatchPosition =
              losersRoundMatches.length - matchPosition + 1;
          winnersBracketMatches[roundNumber]![matchPosition] =
              winnersBracketMatches[roundNumber]![matchPosition]!.copyWith(
                loserAdvancesToMatchId:
                    losersRoundMatches[losersMatchPosition]!.id,
              );
        }
      }
    }

    // Step 10: Assign participants to WB Round 1 (Standard WT Seeding)
    final winnersFirstRoundMatches = winnersBracketMatches[1]!;
    final winnersFirstRoundMatchCount = winnersFirstRoundMatches.length;

    final seedingOrder = _generateSeedingOrder(max(1, winnersRoundCount));

    for (
      var matchPosition = 1;
      matchPosition <= winnersFirstRoundMatchCount;
      matchPosition++
    ) {
      final blueSeedNumber =
          seedingOrder[(matchPosition - 1) * 2]; // Top slot (Blue)
      final redSeedNumber =
          seedingOrder[(matchPosition - 1) * 2 + 1]; // Bottom slot (Red)

      String? blueParticipantId;
      String? redParticipantId;

      if (blueSeedNumber <= participantCount) {
        blueParticipantId = participantIds[blueSeedNumber - 1];
      }
      if (redSeedNumber <= participantCount) {
        redParticipantId = participantIds[redSeedNumber - 1];
      }

      var currentMatch = winnersFirstRoundMatches[matchPosition]!;
      currentMatch = currentMatch.copyWith(
        participantBlueId: blueParticipantId,
        participantRedId: redParticipantId,
      );
      winnersFirstRoundMatches[matchPosition] = currentMatch;
    }

    // Flatten all matches into a map for topological processing
    final allMatchesMap = <String, MatchEntity>{};
    for (final roundMatches in winnersBracketMatches.values) {
      for (final matchEntity in roundMatches.values) {
        allMatchesMap[matchEntity.id] = matchEntity;
      }
    }
    for (final roundMatches in losersBracketMatches.values) {
      for (final matchEntity in roundMatches.values) {
        allMatchesMap[matchEntity.id] = matchEntity;
      }
    }
    allMatchesMap[grandFinalsMatch.id] = grandFinalsMatch;
    if (resetMatch != null) allMatchesMap[resetMatch.id] = resetMatch;

    // Evaluate phantom paths
    final matchInputs = <String, List<String>>{};
    for (final matchEntity in allMatchesMap.values) {
      matchInputs[matchEntity.id] = [];
    }

    // Initialize WB R1 inputs
    for (
      var matchPosition = 1;
      matchPosition <= winnersFirstRoundMatchCount;
      matchPosition++
    ) {
      final blueSeedNumber = seedingOrder[(matchPosition - 1) * 2];
      final redSeedNumber = seedingOrder[(matchPosition - 1) * 2 + 1];
      matchInputs[winnersBracketMatches[1]![matchPosition]!.id]!.add(
        blueSeedNumber <= participantCount ? 'REAL' : 'PHANTOM',
      );
      matchInputs[winnersBracketMatches[1]![matchPosition]!.id]!.add(
        redSeedNumber <= participantCount ? 'REAL' : 'PHANTOM',
      );
    }

    final evaluatedMatchIds = <String>{};
    bool hasChanges = true;
    while (hasChanges) {
      hasChanges = false;
      for (final matchId in allMatchesMap.keys) {
        if (evaluatedMatchIds.contains(matchId)) continue;
        final inputs = matchInputs[matchId]!;
        if (inputs.length == 2) {
          final phantomInputCount = inputs
              .where((input) => input == 'PHANTOM')
              .length;

          String winnerOutput;
          String loserOutput;

          if (phantomInputCount == 2) {
            winnerOutput = 'PHANTOM';
            loserOutput = 'PHANTOM';
          } else if (phantomInputCount == 1) {
            winnerOutput = 'REAL';
            loserOutput = 'PHANTOM';
          } else {
            winnerOutput = 'REAL';
            loserOutput = 'REAL';
          }

          // Push outputs down the graph
          final currentMatch = allMatchesMap[matchId]!;
          if (currentMatch.winnerAdvancesToMatchId != null) {
            matchInputs[currentMatch.winnerAdvancesToMatchId!]!.add(
              winnerOutput,
            );
          }
          if (currentMatch.loserAdvancesToMatchId != null) {
            matchInputs[currentMatch.loserAdvancesToMatchId!]!.add(loserOutput);
          }

          evaluatedMatchIds.add(matchId);
          hasChanges = true;
        }
      }
    }

    // Apply phantom status to the matches
    for (final matchId in allMatchesMap.keys) {
      final currentMatch = allMatchesMap[matchId]!;
      final inputs = matchInputs[matchId]!;
      if (inputs.length == 2) {
        final phantomInputCount = inputs
            .where((input) => input == 'PHANTOM')
            .length;
        if (phantomInputCount > 0) {
          // For WB R1, we know the real player immediately, so complete it.
          if (currentMatch.roundNumber == 1 &&
              currentMatch.bracketId == winnersBracketId) {
            final byeWinnerId =
                currentMatch.participantBlueId ?? currentMatch.participantRedId;
            allMatchesMap[matchId] = currentMatch.copyWith(
              status: MatchStatus.completed,
              resultType: MatchResultType.bye,
              completedAtTimestamp: now,
              winnerId: byeWinnerId,
              loserAdvancesToMatchId: null, // WB R1 bye loser doesn't drop
            );
          } else if (phantomInputCount == 2) {
            // Both slots are phantom → permanent ghost match, mark completed.
            allMatchesMap[matchId] = currentMatch.copyWith(
              status: MatchStatus.completed,
              resultType: MatchResultType.bye,
              completedAtTimestamp: now,
            );
          }
          // phantomInputCount == 1 in non-R1: leave pending for runtime auto-advance.
        }
      }
    }

    // Re-pack match maps if needed, or just use allMatchesMap values
    // But Step 11 expects wbMatchMap to be updated!
    for (int roundNumber = 1; roundNumber <= winnersRoundCount; roundNumber++) {
      for (final key in winnersBracketMatches[roundNumber]!.keys.toList()) {
        winnersBracketMatches[roundNumber]![key] =
            allMatchesMap[winnersBracketMatches[roundNumber]![key]!.id]!;
      }
    }
    for (int roundNumber = 1; roundNumber <= losersRoundCount; roundNumber++) {
      for (final key in losersBracketMatches[roundNumber]!.keys.toList()) {
        losersBracketMatches[roundNumber]![key] =
            allMatchesMap[losersBracketMatches[roundNumber]![key]!.id]!;
      }
    }
    grandFinalsMatch = allMatchesMap[grandFinalsMatch.id]!;
    if (resetMatch != null) resetMatch = allMatchesMap[resetMatch.id]!;

    // Step 11: Advance bye winners in Winners Bracket
    if (winnersRoundCount >= 2) {
      final firstRoundMatches = winnersBracketMatches[1]!;
      final firstRoundCount = firstRoundMatches.length;
      for (
        var matchPosition = 1;
        matchPosition <= firstRoundCount;
        matchPosition++
      ) {
        final currentMatch = firstRoundMatches[matchPosition]!;
        if (currentMatch.resultType == MatchResultType.bye &&
            currentMatch.winnerId != null) {
          final nextMatchPosition = (matchPosition + 1) ~/ 2;
          var nextRoundMatch = winnersBracketMatches[2]![nextMatchPosition]!;
          if (matchPosition % 2 != 0) {
            nextRoundMatch = nextRoundMatch.copyWith(
              participantBlueId: currentMatch.winnerId,
            );
          } else {
            nextRoundMatch = nextRoundMatch.copyWith(
              participantRedId: currentMatch.winnerId,
            );
          }
          winnersBracketMatches[2]![nextMatchPosition] = nextRoundMatch;
        }
      }
    }

    // Flatten matches
    final allMatches = <MatchEntity>[];
    for (final roundMatches in winnersBracketMatches.values) {
      allMatches.addAll(roundMatches.values);
    }
    for (final roundMatches in losersBracketMatches.values) {
      allMatches.addAll(roundMatches.values);
    }
    allMatches.add(grandFinalsMatch);
    if (resetMatch != null) {
      allMatches.add(resetMatch);
    }

    return DoubleEliminationBracketGenerationResult(
      winnersBracket: winnersBracket,
      losersBracket: losersBracket,
      grandFinalsMatch: grandFinalsMatch,
      resetMatch: resetMatch,
      allMatches: allMatches,
    );
  }

  /// Recursively builds the standard WT seeding order for a given round count.
  List<int> _generateSeedingOrder(int roundCount) {
    if (roundCount <= 1) return [1, 2];
    final previousSeeding = _generateSeedingOrder(roundCount - 1);
    final totalPositions = 1 << roundCount;
    final complementSum = totalPositions + 1;
    final seedingOrder = <int>[];
    for (final seedPosition in previousSeeding) {
      seedingOrder.add(seedPosition);
      seedingOrder.add(complementSum - seedPosition);
    }
    return seedingOrder;
  }
}

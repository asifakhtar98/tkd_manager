import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/bracket/domain/services/participant_shuffle_service.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

/// Implementation of [ParticipantShuffleService].
///
/// Uses Fisher-Yates shuffle for uniform randomisation, with an optional
/// dojang-separation constraint-repair pass that distributes same-school
/// athletes across opposite bracket halves.
@LazySingleton(as: ParticipantShuffleService)
class ParticipantShuffleServiceImplementation
    implements ParticipantShuffleService {
  /// Creates the service with a default [Random] instance.
  ///
  /// Injectable uses this zero-arg constructor automatically.
  @factoryMethod
  ParticipantShuffleServiceImplementation() : _random = Random();

  /// Test-only constructor allowing a seeded [Random] for deterministic tests.
  ParticipantShuffleServiceImplementation.seeded(Random random)
      : _random = random;

  final Random _random;

  @override
  List<ParticipantEntity> shuffleParticipantsForBracketGeneration({
    required List<ParticipantEntity> participants,
    required bool dojangSeparation,
  }) {
    if (participants.length <= 1) return List.of(participants);

    // Step 1: Fisher-Yates shuffle for uniform random draw.
    final shuffledParticipants = List<ParticipantEntity>.of(participants);
    _fisherYatesShuffle(shuffledParticipants);

    // Step 2: If dojang separation is requested, apply constraint repair.
    if (dojangSeparation) {
      _applyDojangSeparationConstraintRepair(shuffledParticipants);
    }

    return shuffledParticipants;
  }

  /// In-place Fisher-Yates shuffle for uniform randomisation.
  void _fisherYatesShuffle(List<ParticipantEntity> participants) {
    for (var index = participants.length - 1; index > 0; index--) {
      final swapIndex = _random.nextInt(index + 1);
      final temporary = participants[index];
      participants[index] = participants[swapIndex];
      participants[swapIndex] = temporary;
    }
  }

  /// Repairs the shuffled list so that athletes sharing the same
  /// [ParticipantEntity.schoolOrDojangName] are placed in opposite bracket
  /// halves wherever possible.
  ///
  /// The "half boundary" is at `participants.length ~/ 2`. Participants at
  /// indices `[0, halfBoundary)` occupy the top half of the bracket, and
  /// `[halfBoundary, length)` occupy the bottom half.
  ///
  /// Uses a fixpoint loop: each iteration rebuilds the dojang-to-indices map
  /// from the current list state, finds the largest imbalanced group, and
  /// repairs it. Stops when no more swaps are needed (or possible).
  void _applyDojangSeparationConstraintRepair(
    List<ParticipantEntity> participants,
  ) {
    final totalParticipantCount = participants.length;
    final halfBoundary = totalParticipantCount ~/ 2;
    if (halfBoundary == 0) return; // Only 1 participant — nothing to separate.

    // Guard against infinite loops — the maximum number of swaps is bounded by
    // the participant count (each swap fixes at least one conflict).
    var remainingIterations = totalParticipantCount;

    while (remainingIterations > 0) {
      remainingIterations--;

      // Rebuild the dojang-to-indices map from CURRENT list state.
      final dojangToIndicesMap =
          _buildDojangToIndicesMap(participants, totalParticipantCount);

      // Find the most imbalanced dojang group (largest first).
      final imbalancedEntry = _findMostImbalancedDojangGroup(
        dojangToIndicesMap,
        halfBoundary,
      );
      if (imbalancedEntry == null) break; // All groups are balanced.

      final dojangKey = imbalancedEntry.key;
      final indicesForDojang = imbalancedEntry.value;
      final maximumAllowedPerHalf = (indicesForDojang.length + 1) ~/ 2;

      final indicesInTopHalf = indicesForDojang
          .where((index) => index < halfBoundary)
          .toList();
      final indicesInBottomHalf = indicesForDojang
          .where((index) => index >= halfBoundary)
          .toList();

      bool swapPerformed = false;

      // Try to fix top-half overflow first.
      if (indicesInTopHalf.length > maximumAllowedPerHalf) {
        swapPerformed = _swapOneExcessParticipant(
          participants: participants,
          excessIndices: indicesInTopHalf,
          targetHalfStartIndex: halfBoundary,
          targetHalfEndIndex: totalParticipantCount,
          maximumAllowedPerHalf: maximumAllowedPerHalf,
          dojangKey: dojangKey,
        );
      }
      // Then try to fix bottom-half overflow.
      else if (indicesInBottomHalf.length > maximumAllowedPerHalf) {
        swapPerformed = _swapOneExcessParticipant(
          participants: participants,
          excessIndices: indicesInBottomHalf,
          targetHalfStartIndex: 0,
          targetHalfEndIndex: halfBoundary,
          maximumAllowedPerHalf: maximumAllowedPerHalf,
          dojangKey: dojangKey,
        );
      }

      // If no swap was possible, this group can't be further improved.
      // Break to avoid infinite looping.
      if (!swapPerformed) break;
    }
  }

  /// Builds a map of canonical dojang key → list of participant indices.
  /// Only includes named dojangs (non-null, non-blank). Unaffiliated
  /// participants are excluded because they have no grouping constraint.
  Map<String, List<int>> _buildDojangToIndicesMap(
    List<ParticipantEntity> participants,
    int totalParticipantCount,
  ) {
    final dojangToIndicesMap = <String, List<int>>{};
    for (var index = 0; index < totalParticipantCount; index++) {
      final rawDojangName = participants[index].schoolOrDojangName;
      if (rawDojangName == null || rawDojangName.trim().isEmpty) continue;
      final dojangKey = rawDojangName.trim().toLowerCase();
      dojangToIndicesMap.putIfAbsent(dojangKey, () => []).add(index);
    }
    return dojangToIndicesMap;
  }

  /// Finds the dojang group with the largest half-imbalance.
  /// Returns `null` if all groups are balanced.
  MapEntry<String, List<int>>? _findMostImbalancedDojangGroup(
    Map<String, List<int>> dojangToIndicesMap,
    int halfBoundary,
  ) {
    MapEntry<String, List<int>>? worstEntry;
    int worstImbalance = 0;

    for (final entry in dojangToIndicesMap.entries) {
      if (entry.value.length <= 1) continue; // No separation needed.

      final maximumAllowedPerHalf = (entry.value.length + 1) ~/ 2;
      final inTopHalf =
          entry.value.where((index) => index < halfBoundary).length;
      final inBottomHalf = entry.value.length - inTopHalf;

      final topOverflow =
          inTopHalf > maximumAllowedPerHalf ? inTopHalf - maximumAllowedPerHalf : 0;
      final bottomOverflow =
          inBottomHalf > maximumAllowedPerHalf ? inBottomHalf - maximumAllowedPerHalf : 0;
      final imbalance = topOverflow + bottomOverflow;

      if (imbalance > worstImbalance) {
        worstImbalance = imbalance;
        worstEntry = entry;
      }
    }

    return worstEntry;
  }

  /// Swaps exactly ONE excess participant from [excessIndices] into the
  /// target half. Returns `true` if a swap was performed, `false` if no
  /// safe swap partner exists.
  bool _swapOneExcessParticipant({
    required List<ParticipantEntity> participants,
    required List<int> excessIndices,
    required int targetHalfStartIndex,
    required int targetHalfEndIndex,
    required int maximumAllowedPerHalf,
    required String dojangKey,
  }) {
    if (excessIndices.length <= maximumAllowedPerHalf) return false;

    // Pick the first excess participant to move.
    final sourceIndex = excessIndices[maximumAllowedPerHalf];

    // Find a safe swap target in the other half: someone whose dojang
    // doesn't match the one we're trying to separate.
    for (var candidateIndex = targetHalfStartIndex;
        candidateIndex < targetHalfEndIndex;
        candidateIndex++) {
      final candidateRawDojang =
          participants[candidateIndex].schoolOrDojangName;
      final candidateDojangKey =
          (candidateRawDojang != null && candidateRawDojang.trim().isNotEmpty)
              ? candidateRawDojang.trim().toLowerCase()
              : null;

      if (candidateDojangKey != dojangKey) {
        // Swap.
        final temporary = participants[sourceIndex];
        participants[sourceIndex] = participants[candidateIndex];
        participants[candidateIndex] = temporary;
        return true;
      }
    }

    // No safe swap partner (e.g. everyone is from the same dojang).
    return false;
  }
}

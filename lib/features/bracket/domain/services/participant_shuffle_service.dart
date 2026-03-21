import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

/// Domain service for shuffling participants before bracket generation.
///
/// Implements real-world tie-sheet draw semantics: a random Fisher-Yates
/// shuffle with optional dojang-separation constraint repair.
abstract interface class ParticipantShuffleService {
  /// Returns a new list with the same participants in a shuffled order.
  ///
  /// When [dojangSeparation] is `true`, participants sharing the same
  /// [ParticipantEntity.schoolOrDojangName] are distributed across opposite
  /// bracket halves so they cannot meet in early rounds.
  List<ParticipantEntity> shuffleParticipantsForBracketGeneration({
    required List<ParticipantEntity> participants,
    required bool dojangSeparation,
  });
}

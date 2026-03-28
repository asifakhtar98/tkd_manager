import 'package:freezed_annotation/freezed_annotation.dart';

part 'bracket_medal_placement_entity.freezed.dart';
part 'bracket_medal_placement_entity.g.dart';

/// Represents a finalized historical placement slot for a single participant
/// within a completed bracket division.
@freezed
abstract class BracketMedalPlacementEntity with _$BracketMedalPlacementEntity {
  const factory BracketMedalPlacementEntity({
    /// The participant who secured this medal.
    required String participantId,

    /// Absolute numerical rank status (1 = Gold, 2 = Silver, 3 = Bronze A, 4 = Bronze B).
    required int rankStatus, 

    /// Verbose human-readable label for UI rendering (e.g., "1st", "2nd", "3rd").
    required String displayPlacementLabel, 
  }) = _BracketMedalPlacementEntity;

  factory BracketMedalPlacementEntity.fromJson(Map<String, dynamic> json) =>
      _$BracketMedalPlacementEntityFromJson(json);
}

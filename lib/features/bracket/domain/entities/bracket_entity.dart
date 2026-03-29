// ignore_for_file: avoid_dynamic_calls

import 'package:freezed_annotation/freezed_annotation.dart';
import 'bracket_medal_placement_entity.dart';
part 'bracket_entity.freezed.dart';
part 'bracket_entity.g.dart';

/// Classifies the role of a bracket within an elimination tournament.
@JsonEnum(valueField: 'value')
enum BracketType {
  /// The main (upper) bracket in single or double elimination.
  winners('winners'),

  /// The losers (lower) bracket — only used in double elimination.
  losers('losers'),

  /// Round-robin pool bracket (reserved for future use).
  pool('pool');

  const BracketType(this.value);
  final String value;

  /// Human-readable label for UI display purposes.
  String get displayLabel => switch (this) {
    BracketType.winners => 'Winners',
    BracketType.losers => 'Losers',
    BracketType.pool => 'Pool',
  };
}

/// Represents a single bracket structure within a tournament division.
///
/// A division may contain one bracket (single elimination) or two
/// (winners + losers in double elimination).
@freezed
abstract class BracketEntity with _$BracketEntity {
  const factory BracketEntity({
    /// Unique identifier (UUID v4).
    required String id,

    /// The division this bracket belongs to.
    required String genderId,

    /// Role of this bracket (winners, losers, or pool).
    required BracketType bracketType,

    /// Total number of rounds in this bracket.
    required int totalRounds,

    /// Record creation timestamp.
    required DateTime createdAtTimestamp,

    /// Most recent update timestamp.
    required DateTime updatedAtTimestamp,

    /// Pool letter identifier (only used for round-robin brackets).
    String? poolIdentifier,

    /// Whether bracket results have been finalized.
    @Default(false) bool isFinalized,

    /// Timestamp when the bracket structure was generated.
    DateTime? generatedAtTimestamp,

    /// Timestamp when the bracket was finalized.
    DateTime? finalizedAtTimestamp,

    /// Raw JSON payload for the bracket structure (legacy / export).
    Map<String, dynamic>? bracketDataJson,

    /// Optimistic concurrency version counter.
    @Default(1) int syncVersion,

    /// Soft-delete flag.
    @Default(false) bool isDeleted,

    /// Timestamp of soft deletion, if applicable.
    DateTime? deletedAtTimestamp,

    /// Final medal placements, frozen when bracket is marked as finalized.
    /// This removes the need for UI to traverse the match tree defensively,
    /// protecting historical accuracy against future logic regressions.
    List<BracketMedalPlacementEntity>? finalMedalPlacements,
  }) = _BracketEntity;

  factory BracketEntity.fromJson(Map<String, dynamic> json) =>
      _$BracketEntityFromJson(json);
}

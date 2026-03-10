// ignore_for_file: avoid_dynamic_calls

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bracket_entity.freezed.dart';
part 'bracket_entity.g.dart';

/// Bracket type — winners/losers for elimination, pool for round robin.
@JsonEnum(valueField: 'value')
enum BracketType {
  winners('winners'),
  losers('losers'),
  pool('pool');

  const BracketType(this.value);
  final String value;
}

@freezed
abstract class BracketEntity with _$BracketEntity {
  const factory BracketEntity({
    required String id,
    required String divisionId,
    required BracketType bracketType,
    required int totalRounds,
    required DateTime createdAtTimestamp,
    required DateTime updatedAtTimestamp,
    String? poolIdentifier,
    @Default(false) bool isFinalized,
    DateTime? generatedAtTimestamp,
    DateTime? finalizedAtTimestamp,
    Map<String, dynamic>? bracketDataJson,
    @Default(1) int syncVersion,
    @Default(false) bool isDeleted,
    DateTime? deletedAtTimestamp,
    @Default(false) bool isDemoData,
  }) = _BracketEntity;

  factory BracketEntity.fromJson(Map<String, dynamic> json) =>
      _$BracketEntityFromJson(json);
}

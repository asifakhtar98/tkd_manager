import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament_entity.freezed.dart';

/// Core tournament identity object. Owns all metadata fields and groups
/// multiple [BracketSnapshot]s generated under a single tournament.
@freezed
abstract class TournamentEntity with _$TournamentEntity {
  const factory TournamentEntity({
    /// Globally unique identifier (UUID v4).
    required String id,

    /// Human-readable name shown across all screens and bracket headers.
    required String name,

    @Default('') String dateRange,
    @Default('') String venue,
    @Default('') String organizer,
    @Default('') String categoryLabel,
    @Default('') String divisionLabel,
    @Default('') String weightClassLabel,

    /// Wall-clock time when this tournament was first created in-memory.
    required DateTime createdAt,
  }) = _TournamentEntity;
}

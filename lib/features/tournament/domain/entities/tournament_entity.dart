import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament_entity.freezed.dart';
part 'tournament_entity.g.dart';

/// Core tournament identity object. Owns all metadata fields and groups
/// multiple [BracketSnapshot]s generated under a single tournament.
@freezed
abstract class TournamentEntity with _$TournamentEntity {
  const factory TournamentEntity({
    /// Globally unique identifier (UUID v4).
    required String id,

    /// Creator of the tournament.
    required String userId,

    /// Human-readable name shown across all screens and bracket headers.
    required String name,

    @Default('') String dateRange,
    @Default('') String venue,
    @Default('') String organizer,

    /// URL of the right-side logo displayed in the tie sheet header.
    /// Defaults to India Taekwondo federation logo.
    @Default(
      'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/logo_placeholder_4536.png',
    )
    String rightLogoUrl,

    /// URL of the left-side logo displayed in the tie sheet header.
    /// Defaults to World Taekwondo federation logo.
    @Default(
      'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/logo_placeholder_4536.png',
    )
    String leftLogoUrl,

    /// Wall-clock time when this tournament was first created.
    required DateTime createdAt,

    /// Wall-clock time when this tournament was last updated.
    required DateTime updatedAt,
  }) = _TournamentEntity;

  factory TournamentEntity.fromJson(Map<String, dynamic> json) =>
      _$TournamentEntityFromJson(json);
}

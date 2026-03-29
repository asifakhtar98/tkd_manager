import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_classification.dart';

part 'bracket_snapshot.freezed.dart';
part 'bracket_snapshot.g.dart';

/// Immutable record of a single bracket generation event within a tournament.
/// Stored in [TournamentBloc] state as the in-memory history.
@freezed
abstract class BracketSnapshot with _$BracketSnapshot {
  const factory BracketSnapshot({
    /// Unique ID for this snapshot (UUID v4).
    required String id,

    /// Foreign key to 'auth.users'. The owner of the tournament snapshot.
    required String userId,

    /// Foreign key to 'tournaments'. Which tournament this bracket belongs to.
    required String tournamentId,

    /// Display label, e.g. "Single Elim — 8 Players".
    required String label,

    /// The elimination format used for this bracket generation.
    required BracketFormat format,

    required int participantCount,
    required bool includeThirdPlaceMatch,
    required bool dojangSeparation,

    /// Bracket-level classification labels displayed in the tie sheet header.
    @Default(BracketClassification()) BracketClassification classification,

    /// Wall-clock time when the bracket was generated.
    required DateTime generatedAt,

    /// Full participant list at the time of generation.
    required List<ParticipantEntity> participants,

    /// The generated bracket data (single or double elimination union).
    required BracketResult result,

    /// Last update timestamp.
    required DateTime updatedAt,

    /// Persisted undo/redo history entries.
    ///
    /// Stored as JSONB in the `action_history` column so the full undo/redo
    /// stack survives page navigation and browser reloads.
    @Default([]) List<BracketHistoryEntry> actionHistory,
  }) = _BracketSnapshot;

  factory BracketSnapshot.fromJson(Map<String, dynamic> json) =>
      _$BracketSnapshotFromJson(json);
}

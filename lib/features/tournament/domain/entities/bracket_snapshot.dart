import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

part 'bracket_snapshot.freezed.dart';

/// Immutable record of a single bracket generation event within a tournament.
/// Stored in [TournamentBloc] state as the in-memory history.
@freezed
abstract class BracketSnapshot with _$BracketSnapshot {
  const factory BracketSnapshot({
    /// Unique ID for this snapshot (UUID v4).
    required String id,

    /// Display label, e.g. "Single Elim — 8 Players".
    required String label,

    /// The elimination format used for this bracket generation.
    required BracketFormat format,

    required int participantCount,
    required bool includeThirdPlaceMatch,
    required bool dojangSeparation,

    /// Wall-clock time when the bracket was generated.
    required DateTime generatedAt,

    /// Full participant list at the time of generation.
    required List<ParticipantEntity> participants,

    /// The generated bracket data (single or double elimination union).
    required BracketResult result,
  }) = _BracketSnapshot;
}

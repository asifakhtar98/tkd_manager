import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';

part 'tournament_event.freezed.dart';

/// All events for the [TournamentBloc].
@freezed
sealed class TournamentEvent with _$TournamentEvent {
  /// Request all tournaments and their associated snapshots from remote DB.
  const factory TournamentEvent.loadRequested() = TournamentLoadRequested;

  /// Request the next page of tournaments.
  const factory TournamentEvent.loadMoreRequested() = TournamentLoadMoreRequested;

  /// Clear all loaded tournaments and brackets (e.g. on sign out).
  const factory TournamentEvent.clearRequested() = TournamentClearRequested;

  /// Create and store a new tournament in memory.
  const factory TournamentEvent.created(TournamentEntity tournament) =
      TournamentCreated;

  /// Append a generated bracket snapshot to the tournament's history.
  const factory TournamentEvent.bracketSnapshotAdded({
    required String tournamentId,
    required BracketSnapshot snapshot,
  }) = TournamentBracketSnapshotAdded;

  /// Remove a specific bracket snapshot from a tournament.
  const factory TournamentEvent.bracketSnapshotRemoved({
    required String tournamentId,
    required String snapshotId,
  }) = TournamentBracketSnapshotRemoved;

  /// Delete a tournament and all its bracket snapshots.
  const factory TournamentEvent.deleted(String tournamentId) =
      TournamentDeleted;

  /// Replace existing tournament metadata (name, venue, dates, etc.).
  const factory TournamentEvent.updated(TournamentEntity tournament) =
      TournamentUpdated;

  /// Update an existing bracket snapshot inside the tournament's history.
  const factory TournamentEvent.bracketSnapshotUpdated(
    BracketSnapshot snapshot,
  ) = TournamentBracketSnapshotUpdated;
}

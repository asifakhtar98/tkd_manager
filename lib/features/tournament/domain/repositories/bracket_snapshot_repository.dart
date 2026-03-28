import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';

/// Repository interface for BracketSnapshot CRUD operations.
abstract class BracketSnapshotRepository {
  /// Fetches all bracket snapshots for a given tournament.
  Future<List<BracketSnapshot>> getBracketSnapshots(String tournamentId);

  /// Fetches a specific bracket snapshot by its ID.
  Future<BracketSnapshot> getBracketSnapshot(String id);

  /// Creates a new bracket snapshot and returns the persisted entity.
  Future<BracketSnapshot> createBracketSnapshot(BracketSnapshot snapshot, String tournamentId);

  /// Updates an existing bracket snapshot.
  Future<BracketSnapshot> updateBracketSnapshot(BracketSnapshot snapshot);

  /// Deletes a bracket snapshot.
  Future<void> deleteBracketSnapshot(String id);
}

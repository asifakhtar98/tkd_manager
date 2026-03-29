import 'package:fpdart/fpdart.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';

/// Repository interface for BracketSnapshot CRUD operations.
abstract class BracketSnapshotRepository {
  /// Fetches all bracket snapshots for a given tournament.
  Future<Either<Failure, List<BracketSnapshot>>> getBracketSnapshots(
    String tournamentId,
  );

  /// Fetches a specific bracket snapshot by its ID.
  Future<Either<Failure, BracketSnapshot>> getBracketSnapshot(String id);

  /// Creates a new bracket snapshot and returns the persisted entity.
  Future<Either<Failure, BracketSnapshot>> createBracketSnapshot(
    BracketSnapshot snapshot,
    String tournamentId,
  );

  /// Updates an existing bracket snapshot.
  Future<Either<Failure, BracketSnapshot>> updateBracketSnapshot(
    BracketSnapshot snapshot,
  );

  /// Deletes a bracket snapshot.
  Future<Either<Failure, void>> deleteBracketSnapshot(String id);
}

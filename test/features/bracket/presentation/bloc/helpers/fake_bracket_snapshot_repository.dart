import 'package:fpdart/fpdart.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/bracket_snapshot_repository.dart';

/// In-memory no-op implementation of [BracketSnapshotRepository] for tests.
///
/// All methods return success with minimal stub data so that [BracketBloc]
/// auto-save / explicit-save paths complete without any network or Supabase
/// dependency in unit tests.
class FakeBracketSnapshotRepository implements BracketSnapshotRepository {
  /// Counts how many times [updateBracketSnapshot] was invoked.
  int updateCallCount = 0;

  /// The last snapshot passed to [updateBracketSnapshot], or null if never
  /// called.
  BracketSnapshot? lastUpdatedSnapshot;

  @override
  Future<Either<Failure, List<BracketSnapshot>>> getBracketSnapshots(
    String tournamentId,
  ) async => const Right([]);

  @override
  Future<Either<Failure, BracketSnapshot>> getBracketSnapshot(String id) async {
    return Left(ServerFailure('FakeBracketSnapshotRepository: not implemented'));
  }

  @override
  Future<Either<Failure, BracketSnapshot>> createBracketSnapshot(
    BracketSnapshot snapshot,
    String tournamentId,
  ) async => Right(snapshot);

  @override
  Future<Either<Failure, BracketSnapshot>> updateBracketSnapshot(
    BracketSnapshot snapshot,
  ) async {
    updateCallCount++;
    lastUpdatedSnapshot = snapshot;
    return Right(snapshot);
  }

  @override
  Future<Either<Failure, void>> deleteBracketSnapshot(String id) async =>
      const Right(null);
}

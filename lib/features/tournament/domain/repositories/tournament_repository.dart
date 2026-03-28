import 'package:fpdart/fpdart.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';

/// Repository interface for Tournament CRUD operations.
abstract class TournamentRepository {
  /// Fetches all tournaments belonging to the current user.
  Future<Either<Failure, List<TournamentEntity>>> getTournaments({int limit = 20, int offset = 0});

  /// Fetches a specific tournament by ID.
  Future<Either<Failure, TournamentEntity>> getTournament(String id);

  /// Creates a new tournament and returns the persisted entity.
  Future<Either<Failure, TournamentEntity>> createTournament(TournamentEntity tournament);

  /// Updates an existing tournament.
  Future<Either<Failure, TournamentEntity>> updateTournament(TournamentEntity tournament);

  /// Deletes a tournament by ID.
  Future<Either<Failure, void>> deleteTournament(String id);
}

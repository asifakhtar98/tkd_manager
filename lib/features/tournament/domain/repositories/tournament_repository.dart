import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';

/// Repository interface for Tournament CRUD operations.
abstract class TournamentRepository {
  /// Fetches all tournaments belonging to the current user.
  Future<List<TournamentEntity>> getTournaments();

  /// Fetches a specific tournament by ID.
  Future<TournamentEntity> getTournament(String id);

  /// Creates a new tournament and returns the persisted entity.
  Future<TournamentEntity> createTournament(TournamentEntity tournament);

  /// Updates an existing tournament.
  Future<TournamentEntity> updateTournament(TournamentEntity tournament);

  /// Deletes a tournament by ID.
  Future<void> deleteTournament(String id);
}

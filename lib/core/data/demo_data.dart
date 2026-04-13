import '../../features/tournament/domain/entities/tournament_entity.dart';

/// Static helpers that produce deterministic demo data for the pre-seeded
/// demo tournament.
///
/// Uses a fixed ID so the same demo tournament is always returned — no UUID
/// randomness.
class DemoData {
  DemoData._();

  static TournamentEntity get demoTournament => TournamentEntity(
    id: 'demo-tournament-1',
    userId: 'demo-user-1',
    name: 'Demo Tournament 2022',
    dateRange: '18 Jan. to 22 Jan, 2022',
    venue: 'Abc School, Delhi',
    organizer: 'Xyz Association',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

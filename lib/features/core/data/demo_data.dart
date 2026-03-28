import '../../tournament/domain/entities/tournament_entity.dart';

/// Static helpers that produce deterministic demo data for the pre-seeded
/// demo tournament.
///
/// Uses a fixed ID so the same demo tournament is always returned — no UUID
/// randomness.
class DemoData {
  DemoData._();

  // ── Tournament ─────────────────────────────────────────────────────────

  /// Returns a single, reusable demo [TournamentEntity].
  ///
  /// Seeded into [TournamentBloc] at startup so the demo tournament
  /// appears in the tournament list like any user-created tournament.
  static TournamentEntity get demoTournament => TournamentEntity(
    id: 'demo-tournament-1',
    userId: 'demo-user-1',
    name: '1ST WTF OPEN NATIONAL TAEKWONDO CHAMPIONSHIP - 2026',
    dateRange: '18 Jan. to 22 Jan, 2026',
    venue: 'Sanskriti School, Ajmer, Rajasthan',
    organizer: 'Rajasthan Taekwondo Association',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

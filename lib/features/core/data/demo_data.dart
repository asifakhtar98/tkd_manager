import '../../tournament/domain/entities/tournament_entity.dart';

/// Static helpers that produce deterministic demo data for the pre-seeded
/// demo tournament.
///
/// Uses a fixed ID so the same demo tournament is always returned — no UUID
/// randomness.
class DemoData {
  DemoData._();

  // ── Deterministic IDs ──────────────────────────────────────────────────

  /// Fixed tournament ID for the demo tournament.
  static const _demoTournamentId = 'demo-tournament-00';

  // ── Tournament ─────────────────────────────────────────────────────────

  /// Returns a single, reusable demo [TournamentEntity].
  ///
  /// Seeded into [TournamentBloc] at startup so the demo tournament
  /// appears in the tournament list like any user-created tournament.
  static TournamentEntity get demoTournament => TournamentEntity(
    id: _demoTournamentId,
    name: 'Demo Tournament',
    dateRange: 'March 10, 2026',
    venue: 'Demo Arena',
    organizer: 'TKD Brackets',
    createdAt: DateTime(2026, 3, 10),
  );
}

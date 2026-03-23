import '../../participant/domain/entities/participant_entity.dart';
import '../../tournament/domain/entities/tournament_entity.dart';

/// Static helpers that produce deterministic demo data for bracket previews.
///
/// Uses fixed IDs so the same demo tournament / participants are always
/// returned — no UUID randomness.
class DemoData {
  DemoData._();

  // ── Deterministic IDs ──────────────────────────────────────────────────

  /// Fixed tournament ID shared by all demo brackets.
  static const _demoTournamentId = 'demo-tournament-00';

  // ── Tournament ─────────────────────────────────────────────────────────

  /// Returns a single, reusable demo [TournamentEntity].
  ///
  /// All demo brackets reference this tournament so that snapshots,
  /// history, and the viewer work correctly without polluting real data.
  static TournamentEntity get demoTournament => TournamentEntity(
    id: _demoTournamentId,
    name: 'Demo Tournament',
    dateRange: 'March 10, 2026',
    venue: 'Demo Arena',
    organizer: 'TKD Brackets',
    ageCategoryLabel: 'Demo Age Category',
    genderLabel: 'Demo Gender',
    weightDivisionLabel: 'Under 59',
    createdAt: DateTime(2026, 3, 10),
  );

  // ── Participants ───────────────────────────────────────────────────────

  /// Indian-inspired demo full names for realistic bracket previews.
  static const _fullNames = [
    'Aarav Patel',
    'Diya Sharma',
    'Vihaan Singh',
    'Aanya Gupta',
    'Arjun Kumar',
    'Kiara Reddy',
    'Rohan Desai',
    'Isha Joshi',
    'Aditya Verma',
    'Meera Nair',
    'Kabir Das',
    'Ananya Rao',
    'Dhruv Iyer',
    'Neha Pillai',
    'Aryan Mehta',
    'Riya Kapoor',
  ];

  static const _schools = [
    'Kerala Martial Arts',
    'Mumbai Taekwondo',
    'Delhi Sports Club',
    'Bengaluru Dojang',
    'Chennai Dragons',
    'Punjab Tigers',
  ];

  /// Builds a deterministic list of [count] participants.
  ///
  /// Participant IDs are derived from [count] so different demo sizes
  /// produce the same IDs on every invocation.
  static List<ParticipantEntity> getParticipants(int count) {
    return List.generate(count, (i) {
      return ParticipantEntity(
        id: 'demo-p-$count-${i + 1}',
        genderId: 'demo_division',
        fullName: _fullNames[i % _fullNames.length],
        schoolOrDojangName: _schools[i % _schools.length],
        registrationId: 'DEMO-${1000 + i}',
        seedNumber: i + 1,
      );
    });
  }
}

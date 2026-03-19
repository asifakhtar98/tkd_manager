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

  /// Korean-inspired demo full names for realistic bracket previews.
  static const _fullNames = [
    'Jimin Park',
    'Seoyeon Kim',
    'Taeyang Lee',
    'Hana Choi',
    'Minho Jung',
    'Yuna Kang',
    'Jisoo Yoon',
    'Donghyun Shin',
    'Soojin Han',
    'Hyunjin Oh',
    'Yeji Seo',
    'Wooyoung Jang',
    'Dahyun Hwang',
    'Jaehyun Baek',
    'Sana Kwon',
    'Jungkook Im',
  ];

  static const _schools = [
    'Dragon TKD',
    'Eagle Martial Arts',
    'Phoenix Academy',
    'Tiger Clan',
    'Hawk Taekwondo',
    'Panther Dojang',
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

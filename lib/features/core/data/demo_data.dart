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
        categoryLabel: 'Demo Category',
        divisionLabel: 'Demo Division',
        createdAt: DateTime(2026, 3, 10),
      );

  // ── Participants ───────────────────────────────────────────────────────

  /// Korean-inspired demo names for realistic bracket previews.
  static const _firstNames = [
    'Jimin',
    'Seoyeon',
    'Taeyang',
    'Hana',
    'Minho',
    'Yuna',
    'Jisoo',
    'Donghyun',
    'Soojin',
    'Hyunjin',
    'Yeji',
    'Wooyoung',
    'Dahyun',
    'Jaehyun',
    'Sana',
    'Jungkook',
  ];

  static const _lastNames = [
    'Park',
    'Kim',
    'Lee',
    'Choi',
    'Jung',
    'Kang',
    'Yoon',
    'Shin',
    'Han',
    'Oh',
    'Seo',
    'Jang',
    'Hwang',
    'Baek',
    'Kwon',
    'Im',
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
        divisionId: 'demo_division',
        firstName: _firstNames[i % _firstNames.length],
        lastName: _lastNames[i % _lastNames.length],
        schoolOrDojangName: _schools[i % _schools.length],
        registrationId: 'DEMO-${1000 + i}',
        seedNumber: i + 1,
      );
    });
  }
}

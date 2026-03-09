import 'package:uuid/uuid.dart';
import '../../participant/domain/entities/participant_entity.dart';
import '../../bracket/domain/entities/tournament_info.dart';

class DemoData {
  static const _uuid = Uuid();

  static List<ParticipantEntity> getParticipants(int count) {
    final List<ParticipantEntity> participants = [];
    final schools = ['Dragon TKD', 'Eagle Martial Arts', 'Phoenix Academy', 'Tiger Clan'];
    
    for (int i = 0; i < count; i++) {
      participants.add(
        ParticipantEntity(
          id: _uuid.v4(),
          divisionId: 'demo_division',
          firstName: 'Player',
          lastName: '${i + 1}',
          schoolOrDojangName: schools[i % schools.length],
          registrationId: 'REG-${1000 + i}',
          seedNumber: i + 1,
        ),
      );
    }
    return participants;
  }

  static TournamentInfo getTournamentInfo(String type) {
    return TournamentInfo(
      tournamentName: '$type Demo Tournament',
      dateRange: 'March 10, 2026',
      venue: 'Demo Arena',
      organizer: 'TKD Brackets AI',
      categoryLabel: 'Mixed Category',
      divisionLabel: 'Demo Division',
    );
  }
}

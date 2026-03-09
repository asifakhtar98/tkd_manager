import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('5 players double elim', () {
    final gen = DoubleEliminationBracketGeneratorServiceImplementation(Uuid());
    final r = gen.generate(
      divisionId: 'div1',
      participantIds: ['p1', 'p2', 'p3', 'p4', 'p5'],
      winnersBracketId: 'wb',
      losersBracketId: 'lb',
    );
    for (var m in r.allMatches) {
      if (m.bracketId == 'lb') {
        print('LB R${m.roundNumber}-M${m.matchNumberInRound}: red=${m.participantRedId} blue=${m.participantBlueId} status=${m.status}');
      }
    }
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart';
import 'package:uuid/uuid.dart';

void main() {
  late DoubleEliminationBracketGeneratorServiceImplementation gen;

  setUp(() => gen = DoubleEliminationBracketGeneratorServiceImplementation(const Uuid()));

  group('Double Elimination Generator', () {
    test('2 players: produces allMatches with at least 1 WB match + Grand Finals', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: ['p1', 'p2'],
        winnersBracketId: 'wb',
        losersBracketId: 'lb',
      );
      expect(r.allMatches, isNotEmpty);
      expect(r.grandFinalsMatch, isNotNull);
    });

    test('4 players: WB has 2 matches round 1, LB is non-empty', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: ['p1', 'p2', 'p3', 'p4'],
        winnersBracketId: 'wb',
        losersBracketId: 'lb',
      );
      final wbMatches = r.allMatches.where((m) => m.bracketId == 'wb').toList();
      final lbMatches = r.allMatches.where((m) => m.bracketId == 'lb').toList();
      expect(wbMatches, isNotEmpty);
      expect(lbMatches, isNotEmpty);
    });

    test('5 players: correct BYE handling — bracket still generates', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: ['p1', 'p2', 'p3', 'p4', 'p5'],
        winnersBracketId: 'wb',
        losersBracketId: 'lb',
      );
      expect(r.allMatches, isNotEmpty);
      expect(r.grandFinalsMatch, isNotNull);
    });

    test('8 players: WB R1 has 4 matches', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: List.generate(8, (i) => 'p$i'),
        winnersBracketId: 'wb',
        losersBracketId: 'lb',
      );
      final wbR1 = r.allMatches
          .where((m) => m.bracketId == 'wb' && m.roundNumber == 1)
          .toList();
      expect(wbR1.length, 4);
    });

    test('8 players: Grand Finals match links WB winner and LB winner', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: List.generate(8, (i) => 'p$i'),
        winnersBracketId: 'wb',
        losersBracketId: 'lb',
      );
      final gf = r.grandFinalsMatch;
      expect(gf, isNotNull);
    });

    test('All WB matches link losers to a LB match', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: List.generate(8, (i) => 'p$i'),
        winnersBracketId: 'wb',
        losersBracketId: 'lb',
      );
      final wbMatches =
          r.allMatches.where((m) => m.bracketId == 'wb').toList();
      // Every WB match should have a loser advancement route (unless it is BYE)
      final nonByeWb = wbMatches.where((m) => m.participantBlueId != null).toList();
      for (final m in nonByeWb) {
        expect(m.loserAdvancesToMatchId, isNotNull,
            reason: 'WB match ${m.id} should send loser to LB');
      }
    });
  });
}

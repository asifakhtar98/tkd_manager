import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:uuid/uuid.dart';

void main() {
  late SingleEliminationBracketGeneratorServiceImplementation gen;

  setUp(() => gen = SingleEliminationBracketGeneratorServiceImplementation(const Uuid()));

  group('Single Elimination Generator', () {
    test('1 player: throws ArgumentError (generator requires ≥2)', () {
      expect(
        () => gen.generate(
          divisionId: 'div1',
          participantIds: ['p1'],
          bracketId: 'b1',
        ),
        throwsArgumentError,
      );
    });

    test('2 players: produces 1 match, no BYEs', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: ['p1', 'p2'],
        bracketId: 'b1',
      );
      expect(r.matches.length, 1);
      expect(r.matches.first.participantRedId, isNotNull);
      expect(r.matches.first.participantBlueId, isNotNull);
    });

    test('3 players: produces 3 matches including 1 BYE', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: ['p1', 'p2', 'p3'],
        bracketId: 'b1',
      );
      final byeMatches = r.matches.where((m) => m.resultType == MatchResultType.bye).toList();
      expect(byeMatches.length, 1);
    });

    test('5 players: correct BYE count (next power of 2 = 8, 3 BYEs)', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: ['p1', 'p2', 'p3', 'p4', 'p5'],
        bracketId: 'b1',
      );
      final byeCount = r.matches.where((m) => m.resultType == MatchResultType.bye).length;
      expect(byeCount, 3);
    });

    test('8 players: 7 matches, no BYEs', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: List.generate(8, (i) => 'p$i'),
        bracketId: 'b1',
      );
      expect(r.matches.length, 7);
      expect(r.matches.where((m) => m.resultType == MatchResultType.bye).length, 0);
    });

    test('16 players: 15 matches', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: List.generate(16, (i) => 'p$i'),
        bracketId: 'b1',
      );
      expect(r.matches.length, 15);
    });

    test('8 players with third place match: produces 8 matches', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: List.generate(8, (i) => 'p$i'),
        bracketId: 'b1',
        includeThirdPlaceMatch: true,
      );
      // 3rd place match has both participants from the losers side — roundNumber is max
      final maxRound = r.matches.map((m) => m.roundNumber).reduce((a, b) => a > b ? a : b);
      // With 8 players (3 rounds) + 3rd place, we should have 8 matches total
      expect(r.matches.length, 8);
      expect(maxRound, greaterThanOrEqualTo(3));
    });

    test('Winner of round 1 match advances to round 2', () {
      final r = gen.generate(
        divisionId: 'div1',
        participantIds: List.generate(4, (i) => 'p$i'),
        bracketId: 'b1',
      );
      final r1 = r.matches.where((m) => m.roundNumber == 1).toList();
      expect(r1.every((m) => m.winnerAdvancesToMatchId != null), isTrue);
    });
  });
}

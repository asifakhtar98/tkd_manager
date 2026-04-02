import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:uuid/uuid.dart';

void main() {
  late SingleEliminationBracketGeneratorServiceImplementation service;
  const uuid = Uuid();

  setUp(() {
    service = SingleEliminationBracketGeneratorServiceImplementation(uuid);
  });

  List<String> makeIds(int n) => List.generate(n, (i) => 'p${i + 1}');

  group('SingleEliminationBracketGeneratorService', () {
    test('throws ArgumentError when fewer than 2 participants', () {
      expect(
        () => service.generate(
          genderId: 'd1',
          participantIds: ['p1'],
          bracketId: 'b1',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError for empty participants', () {
      expect(
        () => service.generate(
          genderId: 'd1',
          participantIds: [],
          bracketId: 'b1',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    group('2 players', () {
      test('generates exactly 1 match', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(2),
          bracketId: 'b1',
        );
        expect(result.matches.length, 1);
      });

      test('bracket has 1 round', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(2),
          bracketId: 'b1',
        );
        expect(result.bracket.totalRounds, 1);
      });

      test('the single match has both participants assigned', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(2),
          bracketId: 'b1',
        );
        final match = result.matches.first;
        expect(match.participantBlueId, isNotNull);
        expect(match.participantRedId, isNotNull);
        // Seed 1 = Blue, Seed 2 = Red
        expect(match.participantBlueId, 'p1');
        expect(match.participantRedId, 'p2');
      });

      test('no bye matches exist', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(2),
          bracketId: 'b1',
        );
        final byes = result.matches.where(
          (m) => m.resultType == MatchResultType.bye,
        );
        expect(byes, isEmpty);
      });

      test('the final has no winnerAdvancesToMatchId', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(2),
          bracketId: 'b1',
        );
        expect(result.matches.first.winnerAdvancesToMatchId, isNull);
      });
    });

    group('3 players', () {
      test('pads to 4, generates 3 matches (bracketSize - 1)', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(3),
          bracketId: 'b1',
        );
        // bracketSize = 4, matches = 3
        expect(result.matches.length, 3);
      });

      test('bracket has 2 rounds', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(3),
          bracketId: 'b1',
        );
        expect(result.bracket.totalRounds, 2);
      });

      test('exactly 1 bye match in Round 1', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(3),
          bracketId: 'b1',
        );
        final r1Byes = result.matches
            .where(
              (m) => m.roundNumber == 1 && m.resultType == MatchResultType.bye,
            )
            .toList();
        expect(r1Byes.length, 1);
      });

      test('bye match has correct winner (the real participant)', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(3),
          bracketId: 'b1',
        );
        final byeMatch = result.matches.firstWhere(
          (m) => m.resultType == MatchResultType.bye,
        );
        expect(byeMatch.winnerId, isNotNull);
        expect(byeMatch.status, MatchStatus.completed);
        // The winner must be one of the real participants (p1, p2, p3)
        expect(
          makeIds(3).contains(byeMatch.winnerId),
          isTrue,
          reason: 'Bye winner must be a real participant',
        );
      });

      test('no byes appear in Round 2', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(3),
          bracketId: 'b1',
        );
        final r2 = result.matches.where((m) => m.roundNumber == 2);
        for (final m in r2) {
          expect(m.resultType, isNot(MatchResultType.bye));
        }
      });

      test('bye winner is advanced to Round 2', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(3),
          bracketId: 'b1',
        );
        final byeMatch = result.matches.firstWhere(
          (m) => m.resultType == MatchResultType.bye,
        );
        final r2Match = result.matches.firstWhere((m) => m.roundNumber == 2);
        // The bye winner should appear in the R2 match
        final r2Participants = [
          r2Match.participantBlueId,
          r2Match.participantRedId,
        ];
        expect(
          r2Participants.contains(byeMatch.winnerId),
          isTrue,
          reason: 'Bye winner must be advanced to Round 2',
        );
      });
    });

    group('4 players', () {
      test('generates exactly 3 matches', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        expect(result.matches.length, 3);
      });

      test('bracket has 2 rounds', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        expect(result.bracket.totalRounds, 2);
      });

      test('no bye matches', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        final byes = result.matches.where(
          (m) => m.resultType == MatchResultType.bye,
        );
        expect(byes, isEmpty);
      });

      test('fold seeding: seed 1 vs 4, seed 2 vs 3', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );

        // Match 1: Seed 1 (Blue) vs Seed 4 (Red)
        expect(r1[0].participantBlueId, 'p1');
        expect(r1[0].participantRedId, 'p4');
        // Match 2: Seed 2 (Blue) vs Seed 3 (Red)
        expect(r1[1].participantBlueId, 'p2');
        expect(r1[1].participantRedId, 'p3');
      });

      test('R1 winners advance to R2 final', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList();
        final r2Final = result.matches.firstWhere((m) => m.roundNumber == 2);
        for (final m in r1) {
          expect(m.winnerAdvancesToMatchId, r2Final.id);
        }
      });

      test('all R1 matches are pending', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1);
        for (final m in r1) {
          expect(m.status, MatchStatus.pending);
        }
      });
    });

    // ─────────────────────────────────────────────────────────────
    group('5 players', () {
      test('pads to 8, generates 7 matches', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(5),
          bracketId: 'b1',
        );
        expect(result.matches.length, 7);
      });

      test('bracket has 3 rounds', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(5),
          bracketId: 'b1',
        );
        expect(result.bracket.totalRounds, 3);
      });

      test('exactly 3 bye matches in Round 1', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(5),
          bracketId: 'b1',
        );
        final r1Byes = result.matches
            .where(
              (m) => m.roundNumber == 1 && m.resultType == MatchResultType.bye,
            )
            .toList();
        expect(r1Byes.length, 3);
      });

      test('all bye winners are advanced to Round 2', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(5),
          bracketId: 'b1',
        );
        final byeMatches = result.matches
            .where((m) => m.resultType == MatchResultType.bye)
            .toList();
        final r2Matches = result.matches
            .where((m) => m.roundNumber == 2)
            .toList();

        for (final bye in byeMatches) {
          final winnerId = bye.winnerId!;
          // Check this winner appears in some R2 match
          final inR2 = r2Matches.any(
            (m) =>
                m.participantBlueId == winnerId ||
                m.participantRedId == winnerId,
          );
          expect(
            inR2,
            isTrue,
            reason: 'Bye winner $winnerId must appear in Round 2',
          );
        }
      });

      test('top seed gets a bye (placed against bye slot)', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(5),
          bracketId: 'b1',
        );
        // Seed 1 should have a bye (opponent is seed 8 which doesn't exist)
        final byeMatches = result.matches.where(
          (m) => m.resultType == MatchResultType.bye,
        );
        final seed1ByeMatch = byeMatches.where((m) => m.winnerId == 'p1');
        expect(
          seed1ByeMatch,
          isNotEmpty,
          reason: 'Seed 1 should receive a first-round bye',
        );
      });
    });

    // ─────────────────────────────────────────────────────────────
    group('7 players', () {
      test('pads to 8, generates 7 matches', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(7),
          bracketId: 'b1',
        );
        expect(result.matches.length, 7);
      });

      test('exactly 1 bye match', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(7),
          bracketId: 'b1',
        );
        final byes = result.matches.where(
          (m) => m.resultType == MatchResultType.bye,
        );
        expect(byes.length, 1);
      });

      test('seed 1 gets the bye', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(7),
          bracketId: 'b1',
        );
        final byeMatch = result.matches.firstWhere(
          (m) => m.resultType == MatchResultType.bye,
        );
        expect(byeMatch.winnerId, 'p1');
      });
    });

    // ─────────────────────────────────────────────────────────────
    group('8 players', () {
      test('generates exactly 7 matches', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        expect(result.matches.length, 7);
      });

      test('bracket has 3 rounds', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        expect(result.bracket.totalRounds, 3);
      });

      test('no bye matches', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final byes = result.matches.where(
          (m) => m.resultType == MatchResultType.bye,
        );
        expect(byes, isEmpty);
      });

      test('round structure: R1=4, R2=2, R3=1', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1);
        final r2 = result.matches.where((m) => m.roundNumber == 2);
        final r3 = result.matches.where((m) => m.roundNumber == 3);
        expect(r1.length, 4);
        expect(r2.length, 2);
        expect(r3.length, 1);
      });

      test('fold seeding prevents top 2 seeds meeting before final', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );

        // Seed 1 and Seed 2 must not be in the same R1 match
        for (final m in r1) {
          final pair = {m.participantBlueId, m.participantRedId};
          expect(
            pair.containsAll({'p1', 'p2'}),
            isFalse,
            reason: 'Seeds 1 and 2 must not meet in Round 1',
          );
        }

        // Seeds 1 and 2 must be in different halves (different R2 matches)

        // Find which R1 match has p1 and which has p2
        final p1R1 = r1.firstWhere(
          (m) => m.participantBlueId == 'p1' || m.participantRedId == 'p1',
        );
        final p2R1 = r1.firstWhere(
          (m) => m.participantBlueId == 'p2' || m.participantRedId == 'p2',
        );

        // p1 and p2 should advance to different R2 matches
        expect(
          p1R1.winnerAdvancesToMatchId,
          isNot(p2R1.winnerAdvancesToMatchId),
          reason: 'Seeds 1 and 2 must be in different bracket halves',
        );
      });

      test('fold seeding: seed 1 vs seed 8 in R1 match 1', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );

        expect(r1[0].participantBlueId, 'p1');
        expect(r1[0].participantRedId, 'p8');
      });

      test('all R1 participants are assigned', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1);
        for (final m in r1) {
          expect(m.participantBlueId, isNotNull);
          expect(m.participantRedId, isNotNull);
        }
      });

      test('all participants appear exactly once in R1', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1);
        final allPlayers = <String>{};
        for (final m in r1) {
          if (m.participantBlueId != null) allPlayers.add(m.participantBlueId!);
          if (m.participantRedId != null) allPlayers.add(m.participantRedId!);
        }
        expect(allPlayers, makeIds(8).toSet());
      });
    });

    // ─────────────────────────────────────────────────────────────
    group('16 players', () {
      test('generates exactly 15 matches', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(16),
          bracketId: 'b1',
        );
        expect(result.matches.length, 15);
      });

      test('bracket has 4 rounds', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(16),
          bracketId: 'b1',
        );
        expect(result.bracket.totalRounds, 4);
      });

      test('round structure: R1=8, R2=4, R3=2, R4=1', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(16),
          bracketId: 'b1',
        );
        expect(result.matches.where((m) => m.roundNumber == 1).length, 8);
        expect(result.matches.where((m) => m.roundNumber == 2).length, 4);
        expect(result.matches.where((m) => m.roundNumber == 3).length, 2);
        expect(result.matches.where((m) => m.roundNumber == 4).length, 1);
      });

      test('seeds 1-4 cannot meet before semi-finals', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(16),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );

        // Map each top-4 seed to its R1 match's winnerAdvancesToMatchId
        final topSeedR2 = <String, String>{};
        for (final pid in ['p1', 'p2', 'p3', 'p4']) {
          final m = r1.firstWhere(
            (m) => m.participantBlueId == pid || m.participantRedId == pid,
          );
          topSeedR2[pid] = m.winnerAdvancesToMatchId!;
        }

        // Find which R2 match each goes to, then which R3 match
        final r2 = result.matches.where((m) => m.roundNumber == 2).toList();
        final topSeedR3 = <String, String>{};
        for (final entry in topSeedR2.entries) {
          final r2Match = r2.firstWhere((m) => m.id == entry.value);
          topSeedR3[entry.key] = r2Match.winnerAdvancesToMatchId!;
        }

        // Seeds 1 and 2 must go to different R3 (semi) matches
        expect(topSeedR3['p1'], isNot(topSeedR3['p2']));
        // Seeds 1 and 3 must go to different R3 matches
        expect(topSeedR3['p1'], isNot(topSeedR3['p3']));
        // Seeds 2 and 4 must go to different R3 matches
        expect(topSeedR3['p2'], isNot(topSeedR3['p4']));
      });
    });

    // ─────────────────────────────────────────────────────────────
    group('routing table', () {
      test('every non-final match has winnerAdvancesToMatchId', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final maxRound = result.bracket.totalRounds;
        final nonFinalMatches = result.matches.where(
          (m) => m.roundNumber < maxRound,
        );
        for (final m in nonFinalMatches) {
          expect(
            m.winnerAdvancesToMatchId,
            isNotNull,
            reason:
                'R${m.roundNumber}M${m.matchNumberInRound} must have winner route',
          );
        }
      });

      test('final match has no winnerAdvancesToMatchId', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final maxRound = result.bracket.totalRounds;
        final finalMatch = result.matches.firstWhere(
          (m) => m.roundNumber == maxRound,
        );
        expect(finalMatch.winnerAdvancesToMatchId, isNull);
      });

      test('winnerAdvancesToMatchId always points to a valid match', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final matchIds = result.matches.map((m) => m.id).toSet();
        for (final m in result.matches) {
          if (m.winnerAdvancesToMatchId != null) {
            expect(
              matchIds.contains(m.winnerAdvancesToMatchId),
              isTrue,
              reason:
                  'R${m.roundNumber}M${m.matchNumberInRound} points to non-existent match',
            );
          }
        }
      });

      test('two R1 matches feed into each R2 match', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final r2 = result.matches.where((m) => m.roundNumber == 2).toList();
        for (final r2Match in r2) {
          final feeders = result.matches.where(
            (m) => m.winnerAdvancesToMatchId == r2Match.id,
          );
          expect(
            feeders.length,
            2,
            reason:
                'R2M${r2Match.matchNumberInRound} should have exactly 2 feeder matches',
          );
        }
      });
    });

    // ─────────────────────────────────────────────────────────────
    // 3rd place match
    // ─────────────────────────────────────────────────────────────
    group('3rd place match', () {
      test('adds 1 extra match when enabled with 4 players', () {
        final without = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
          includeThirdPlaceMatch: false,
        );
        final with3rd = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
          includeThirdPlaceMatch: true,
        );
        expect(with3rd.matches.length, without.matches.length + 1);
      });

      test('3rd place match is in the final round', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
          includeThirdPlaceMatch: true,
        );
        final maxRound = result.bracket.totalRounds;
        final thirdPlaceMatch = result.matches.firstWhere(
          (m) => m.roundNumber == maxRound && m.matchNumberInRound == 2,
        );
        expect(thirdPlaceMatch, isNotNull);
      });

      test('both semi-final losers route to 3rd place match', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
          includeThirdPlaceMatch: true,
        );
        final maxRound = result.bracket.totalRounds;
        final thirdPlaceMatch = result.matches.firstWhere(
          (m) => m.roundNumber == maxRound && m.matchNumberInRound == 2,
        );

        final semiRound = maxRound - 1;
        final semiFinals = result.matches
            .where((m) => m.roundNumber == semiRound)
            .toList();

        expect(semiFinals.length, 2);
        for (final semi in semiFinals) {
          expect(
            semi.loserAdvancesToMatchId,
            thirdPlaceMatch.id,
            reason:
                'Semi R${semi.roundNumber}M${semi.matchNumberInRound} must route loser to 3rd place match',
          );
        }
      });

      test('3rd place not added when only 2 players', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(2),
          bracketId: 'b1',
          includeThirdPlaceMatch: true,
        );
        // With only 1 round, no semi-finals exist, so no 3rd place match
        expect(result.matches.length, 1);
      });

      test('8 players with 3rd place match: semi losers route correctly', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
          includeThirdPlaceMatch: true,
        );
        // 7 + 1 = 8 matches
        expect(result.matches.length, 8);

        final maxRound = result.bracket.totalRounds; // 3
        final thirdPlaceMatch = result.matches.firstWhere(
          (m) => m.roundNumber == maxRound && m.matchNumberInRound == 2,
        );

        // Semi-finals are round 2
        final semiFinals = result.matches
            .where((m) => m.roundNumber == maxRound - 1)
            .toList();
        expect(semiFinals.length, 2);
        for (final semi in semiFinals) {
          expect(semi.loserAdvancesToMatchId, thirdPlaceMatch.id);
        }
      });
    });

    // ─────────────────────────────────────────────────────────────
    // Bracket entity
    // ─────────────────────────────────────────────────────────────
    group('bracket entity', () {
      test('bracket has correct genderId', () {
        final result = service.generate(
          genderId: 'div_42',
          participantIds: makeIds(4),
          bracketId: 'b_test',
        );
        expect(result.bracket.genderId, 'div_42');
      });

      test('bracket has correct id', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b_custom',
        );
        expect(result.bracket.id, 'b_custom');
      });

      test('bracket type is winners', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        expect(result.bracket.bracketType, BracketType.winners);
      });

      test('all matches reference the bracket id', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b_ref',
        );
        for (final m in result.matches) {
          expect(m.bracketId, 'b_ref');
        }
      });
    });

    // ─────────────────────────────────────────────────────────────
    // Match uniqueness
    // ─────────────────────────────────────────────────────────────
    group('match uniqueness', () {
      test('all match IDs are unique', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(16),
          bracketId: 'b1',
        );
        final ids = result.matches.map((m) => m.id).toSet();
        expect(ids.length, result.matches.length);
      });

      test('matchNumberInRound is unique within each round', () {
        final result = service.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final byRound = <int, Set<int>>{};
        for (final m in result.matches) {
          byRound.putIfAbsent(m.roundNumber, () => {});
          expect(
            byRound[m.roundNumber]!.add(m.matchNumberInRound),
            isTrue,
            reason:
                'Duplicate matchNumberInRound ${m.matchNumberInRound} in round ${m.roundNumber}',
          );
        }
      });
    });
  });
}

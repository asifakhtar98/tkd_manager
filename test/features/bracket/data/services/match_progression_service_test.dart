import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/data/services/match_progression_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:uuid/uuid.dart';

void main() {
  late MatchProgressionServiceImplementation service;
  late SingleEliminationBracketGeneratorServiceImplementation generator;
  const uuid = Uuid();

  setUp(() {
    service = MatchProgressionServiceImplementation();
    generator = SingleEliminationBracketGeneratorServiceImplementation(uuid);
  });

  List<String> makeIds(int n) => List.generate(n, (i) => 'p${i + 1}');

  group('MatchProgressionService', () {
    // ─────────────────────────────────────────────────────────────
    // Basic result recording
    // ─────────────────────────────────────────────────────────────
    group('basic result recording', () {
      test('marks match as completed with winner', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );
        final match = r1.first; // p1 vs p4

        final updated = service.recordResult(
          matches: result.matches,
          matchId: match.id,
          winnerId: 'p1',
        );

        final m = updated.firstWhere((m) => m.id == match.id);
        expect(m.status, MatchStatus.completed);
        expect(m.winnerId, 'p1');
        expect(m.resultType, MatchResultType.points);
      });

      test('stores scores as proper fields when provided', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );

        final updated = service.recordResult(
          matches: result.matches,
          matchId: r1.first.id,
          winnerId: 'p1',
          blueScore: 10,
          redScore: 5,
        );

        final m = updated.firstWhere((m) => m.id == r1.first.id);
        expect(m.blueScore, 10);
        expect(m.redScore, 5);
      });

      test('throws when match not found', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        expect(
          () => service.recordResult(
            matches: result.matches,
            matchId: 'nonexistent',
            winnerId: 'p1',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws when match already completed', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );

        final after1 = service.recordResult(
          matches: result.matches,
          matchId: r1.first.id,
          winnerId: 'p1',
        );

        expect(
          () => service.recordResult(
            matches: after1,
            matchId: r1.first.id,
            winnerId: 'p1',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    // ─────────────────────────────────────────────────────────────
    // Winner advancement
    // ─────────────────────────────────────────────────────────────
    group('winner advancement', () {
      test('winner is placed in the next match', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );
        final r2Match = result.matches.firstWhere((m) => m.roundNumber == 2);

        // Record winner for first R1 match (p1 vs p4, p1 wins)
        final updated = service.recordResult(
          matches: result.matches,
          matchId: r1.first.id,
          winnerId: 'p1',
        );

        final r2Updated = updated.firstWhere((m) => m.id == r2Match.id);
        final r2Participants = [
          r2Updated.participantBlueId,
          r2Updated.participantRedId,
        ];
        expect(
          r2Participants.contains('p1'),
          isTrue,
          reason: 'Winner p1 must be placed in the R2 final',
        );
      });

      test('both R1 winners are placed in R2 final', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );
        final r2Match = result.matches.firstWhere((m) => m.roundNumber == 2);

        var updated = service.recordResult(
          matches: result.matches,
          matchId: r1[0].id,
          winnerId: 'p1',
        );
        updated = service.recordResult(
          matches: updated,
          matchId: r1[1].id,
          winnerId: 'p2',
        );

        final r2Updated = updated.firstWhere((m) => m.id == r2Match.id);
        expect(
          {r2Updated.participantBlueId, r2Updated.participantRedId},
          {'p1', 'p2'},
        );
      });
    });

    // ─────────────────────────────────────────────────────────────
    // 3rd place match loser routing
    // ─────────────────────────────────────────────────────────────
    group('3rd place match', () {
      test('semi-final losers are placed in 3rd place match', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
          includeThirdPlaceMatch: true,
        );
        // Semi-finals are in round 2 for 8-player bracket

        // To test, we need to play through R1 first
        var matches = result.matches;

        // Play all R1 matches (p1 vs p8, p4 vs p5, p2 vs p7, p3 vs p6)
        final r1 = matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );

        for (final m in r1) {
          matches = service.recordResult(
            matches: matches,
            matchId: m.id,
            winnerId: m.participantBlueId!,
          );
        }

        // Now play semi-finals (the blue participants won R1)
        final updatedSemis = matches.where((m) => m.roundNumber == 2).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );

        for (final semi in updatedSemis) {
          matches = service.recordResult(
            matches: matches,
            matchId: semi.id,
            winnerId: semi.participantBlueId!,
          );
        }

        // Check 3rd place match has the losers
        final thirdPlaceMatch = matches.firstWhere(
          (m) => m.roundNumber == 3 && m.matchNumberInRound == 2,
        );
        expect(thirdPlaceMatch.participantBlueId, isNotNull);
        expect(thirdPlaceMatch.participantRedId, isNotNull);
      });
    });

    // ─────────────────────────────────────────────────────────────
    // Full tournament progression
    // ─────────────────────────────────────────────────────────────
    group('full tournament progression', () {
      test('4-player single elimination: full tournament runs to completion', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        var matches = result.matches;

        // R1 M1: p1 beats p4
        matches = service.recordResult(
          matches: matches,
          matchId: matches
              .firstWhere(
                (m) => m.roundNumber == 1 && m.matchNumberInRound == 1,
              )
              .id,
          winnerId: 'p1',
        );

        // R1 M2: p2 beats p3
        matches = service.recordResult(
          matches: matches,
          matchId: matches
              .firstWhere(
                (m) => m.roundNumber == 1 && m.matchNumberInRound == 2,
              )
              .id,
          winnerId: 'p2',
        );

        // R2 (final): p1 beats p2
        final finalMatch = matches.firstWhere((m) => m.roundNumber == 2);
        expect(finalMatch.participantBlueId, isNotNull);
        expect(finalMatch.participantRedId, isNotNull);

        matches = service.recordResult(
          matches: matches,
          matchId: finalMatch.id,
          winnerId: 'p1',
        );

        // All matches should be completed
        for (final m in matches) {
          expect(
            m.status,
            MatchStatus.completed,
            reason:
                'R${m.roundNumber}M${m.matchNumberInRound} should be completed',
          );
        }
      });

      test('preserves match list length', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final originalLength = result.matches.length;

        final r1 = result.matches.where((m) => m.roundNumber == 1).toList();
        final updated = service.recordResult(
          matches: result.matches,
          matchId: r1.first.id,
          winnerId: r1.first.participantBlueId!,
        );

        expect(updated.length, originalLength);
      });

      test('preserves match order', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(8),
          bracketId: 'b1',
        );
        final originalIds = result.matches.map((m) => m.id).toList();

        final r1 = result.matches.where((m) => m.roundNumber == 1).toList();
        final updated = service.recordResult(
          matches: result.matches,
          matchId: r1.first.id,
          winnerId: r1.first.participantBlueId!,
        );

        final updatedIds = updated.map((m) => m.id).toList();
        expect(updatedIds, originalIds);
      });
    });

    // ─────────────────────────────────────────────────────────────
    // Bye auto-advancement cascade
    // ─────────────────────────────────────────────────────────────
    group('bye auto-advancement', () {
      test('when a participant advances to a match with only one feeder, '
          'they auto-advance', () {
        // 3 players: 1 bye in R1, bye winner auto-advances to R2
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(3),
          bracketId: 'b1',
        );
        var matches = result.matches;

        // The non-bye R1 match
        final nonByeR1 = matches.firstWhere(
          (m) => m.roundNumber == 1 && m.resultType != MatchResultType.bye,
        );

        // Record winner for the non-bye match
        matches = service.recordResult(
          matches: matches,
          matchId: nonByeR1.id,
          winnerId: nonByeR1.participantBlueId!,
        );

        // R2 final should now have both participants
        final r2 = matches.firstWhere((m) => m.roundNumber == 2);
        expect(r2.participantBlueId, isNotNull);
        expect(r2.participantRedId, isNotNull);
      });
    });

    // ─────────────────────────────────────────────────────────────
    // F5: winnerId validation
    // ─────────────────────────────────────────────────────────────
    group('winnerId validation (F5)', () {
      test('throws when winnerId is not a participant in the match', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );
        final match = r1.first; // p1 vs p4

        expect(
          () => service.recordResult(
            matches: result.matches,
            matchId: match.id,
            winnerId: 'p999', // Not in this match
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message.toString(),
              'message',
              contains('not a participant'),
            ),
          ),
        );
      });

      test('succeeds when winnerId is a valid participant', () {
        final result = generator.generate(
          genderId: 'd1',
          participantIds: makeIds(4),
          bracketId: 'b1',
        );
        final r1 = result.matches.where((m) => m.roundNumber == 1).toList()
          ..sort(
            (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
          );
        final match = r1.first; // p1 vs p4

        final updated = service.recordResult(
          matches: result.matches,
          matchId: match.id,
          winnerId: match.participantRedId!,
        );

        final m = updated.firstWhere((m) => m.id == match.id);
        expect(m.winnerId, match.participantRedId);
      });
    });

    // ─────────────────────────────────────────────────────────────
    // F3: phantom auto-advance (empty slot matches)
    // ─────────────────────────────────────────────────────────────
    group('phantom auto-advance (F3)', () {
      test(
        'auto-completes a match with both slots empty and no pending feeders',
        () {
          final now = DateTime.now();
          // Create a minimal match chain: R1 completed bye → R2 has one slot
          // + an unreachable second feeder → should auto-advance
          final matches = [
            MatchEntity(
              id: 'm1',
              bracketId: 'b',
              roundNumber: 1,
              matchNumberInRound: 1,
              createdAtTimestamp: now,
              updatedAtTimestamp: now,
              status: MatchStatus.completed,
              resultType: MatchResultType.bye,
              winnerId: 'p1',
              participantBlueId: 'p1',
              winnerAdvancesToMatchId: 'm3',
            ),
            MatchEntity(
              id: 'm2',
              bracketId: 'b',
              roundNumber: 1,
              matchNumberInRound: 2,
              createdAtTimestamp: now,
              updatedAtTimestamp: now,
              participantBlueId: 'p2',
              participantRedId: 'p3',
              winnerAdvancesToMatchId: 'm3',
            ),
            MatchEntity(
              id: 'm3',
              bracketId: 'b',
              roundNumber: 2,
              matchNumberInRound: 1,
              createdAtTimestamp: now,
              updatedAtTimestamp: now,
              participantBlueId: 'p1', // From m1 bye
            ),
          ];

          // Score m2 → should advance winner to m3
          final updated = service.recordResult(
            matches: matches,
            matchId: 'm2',
            winnerId: 'p2',
          );

          final m3 = updated.firstWhere((m) => m.id == 'm3');
          expect(m3.participantBlueId, 'p1');
          expect(m3.participantRedId, 'p2');
        },
      );
    });
  });
}

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:uuid/uuid.dart';

void main() {
  late DoubleEliminationBracketGeneratorServiceImplementation service;
  const uuid = Uuid();

  setUp(() {
    service = DoubleEliminationBracketGeneratorServiceImplementation(uuid);
  });

  List<String> makeIds(int n) => List.generate(n, (i) => 'p${i + 1}');

  group('DoubleEliminationBracketGeneratorService', () {
    // ─────────────────────────────────────────────────────────────
    // Argument validation
    // ─────────────────────────────────────────────────────────────
    test('throws ArgumentError for fewer than 2 participants', () {
      expect(
        () => service.generate(
          divisionId: 'd1',
          participantIds: ['p1'],
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    // ─────────────────────────────────────────────────────────────
    // 2 players
    // ─────────────────────────────────────────────────────────────
    group('2 players', () {
      test('WB has 1 round, LB has 0 rounds', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(2),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        expect(result.winnersBracket.totalRounds, 1);
        expect(result.losersBracket.totalRounds, 0);
      });

      test('has grand finals match', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(2),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        expect(result.grandFinalsMatch, isNotNull);
      });

      test('WB R1 match routes loser to grand finals (no LB)', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(2),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR1 = result.allMatches
            .where((m) =>
                m.bracketId == 'wb1' && m.roundNumber == 1)
            .toList();
        expect(wbR1.length, 1);
        expect(
          wbR1.first.loserAdvancesToMatchId,
          result.grandFinalsMatch.id,
        );
      });

      test('total matches: WB(1) + GF(1) + reset(1) = 3', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(2),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
          includeResetMatch: true,
        );
        expect(result.allMatches.length, 3);
      });
    });

    // ─────────────────────────────────────────────────────────────
    // 4 players — standard double elimination
    // ─────────────────────────────────────────────────────────────
    group('4 players', () {
      test('WB has 2 rounds', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        expect(result.winnersBracket.totalRounds, 2);
      });

      test('LB has 2 rounds', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        expect(result.losersBracket.totalRounds, 2);
      });

      test('WB match count: 3 (bracketSize - 1)', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbMatches = result.allMatches
            .where((m) => m.bracketId == 'wb1')
            .toList();
        // WB R1 = 2, WB R2 = 1, GF is also bracketId == wb1
        // GF round = wRounds + 1 = 3
        final wbCore = wbMatches
            .where((m) => m.roundNumber <= 2)
            .toList();
        expect(wbCore.length, 3);
      });

      test('LB match count: 2', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final lbMatches = result.allMatches
            .where((m) => m.bracketId == 'lb1')
            .toList();
        expect(lbMatches.length, 2);
      });

      test('WB R1 seeding: seed 1 vs seed 4, seed 2 vs seed 3', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final r1 = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber == 1)
            .toList()
          ..sort((a, b) =>
              a.matchNumberInRound.compareTo(b.matchNumberInRound));

        expect(r1[0].participantBlueId, 'p1');
        expect(r1[0].participantRedId, 'p4');
        expect(r1[1].participantBlueId, 'p2');
        expect(r1[1].participantRedId, 'p3');
      });

      test('WB R1 losers route to LB R1', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR1 = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber == 1)
            .toList();
        final lbR1 = result.allMatches
            .where((m) => m.bracketId == 'lb1' && m.roundNumber == 1)
            .toList();

        for (final m in wbR1) {
          expect(m.loserAdvancesToMatchId, isNotNull);
          final target = lbR1.firstWhere(
            (l) => l.id == m.loserAdvancesToMatchId,
            orElse: () => throw StateError(
              'WB R1 M${m.matchNumberInRound} loser does not route to LB R1',
            ),
          );
          expect(target.bracketId, 'lb1');
          expect(target.roundNumber, 1);
        }
      });

      test('WB R2 loser routes to LB R2', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR2 = result.allMatches
            .firstWhere(
                (m) => m.bracketId == 'wb1' && m.roundNumber == 2);
        final lbR2 = result.allMatches
            .where((m) => m.bracketId == 'lb1' && m.roundNumber == 2)
            .toList();

        expect(wbR2.loserAdvancesToMatchId, isNotNull);
        expect(
          lbR2.any((l) => l.id == wbR2.loserAdvancesToMatchId),
          isTrue,
          reason: 'WB R2 loser must route to LB R2',
        );
      });

      test('WB final winner routes to grand finals', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbFinal = result.allMatches
            .firstWhere(
                (m) => m.bracketId == 'wb1' && m.roundNumber == 2);
        expect(
          wbFinal.winnerAdvancesToMatchId,
          result.grandFinalsMatch.id,
        );
      });

      test('LB final winner routes to grand finals', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final lbFinal = result.allMatches
            .where((m) => m.bracketId == 'lb1')
            .reduce((a, b) => a.roundNumber > b.roundNumber ? a : b);
        expect(
          lbFinal.winnerAdvancesToMatchId,
          result.grandFinalsMatch.id,
        );
      });

      test('LB R1 winner routes to LB R2', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final lbR1 = result.allMatches
            .firstWhere(
                (m) => m.bracketId == 'lb1' && m.roundNumber == 1);
        final lbR2 = result.allMatches
            .firstWhere(
                (m) => m.bracketId == 'lb1' && m.roundNumber == 2);
        expect(lbR1.winnerAdvancesToMatchId, lbR2.id);
      });

      test('grand finals routes to reset match when enabled', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
          includeResetMatch: true,
        );
        expect(result.resetMatch, isNotNull);
        expect(
          result.grandFinalsMatch.winnerAdvancesToMatchId,
          result.resetMatch!.id,
        );
      });

      test('no reset match when disabled', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
          includeResetMatch: false,
        );
        expect(result.resetMatch, isNull);
        expect(
          result.grandFinalsMatch.winnerAdvancesToMatchId,
          isNull,
        );
      });

      test('total matches: WB(3) + LB(2) + GF(1) + reset(1) = 7', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
          includeResetMatch: true,
        );
        expect(result.allMatches.length, 7);
      });

      test('total matches without reset: 6', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
          includeResetMatch: false,
        );
        expect(result.allMatches.length, 6);
      });
    });

    // ─────────────────────────────────────────────────────────────
    // 3 players — 1 bye
    // ─────────────────────────────────────────────────────────────
    group('3 players', () {
      test('WB has 2 rounds, LB has 2 rounds', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(3),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        expect(result.winnersBracket.totalRounds, 2);
        expect(result.losersBracket.totalRounds, 2);
      });

      test('WB R1 has exactly 1 bye match', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(3),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR1Byes = result.allMatches
            .where((m) =>
                m.bracketId == 'wb1' &&
                m.roundNumber == 1 &&
                m.resultType == MatchResultType.bye)
            .toList();
        expect(wbR1Byes.length, 1);
      });

      test('bye winner is advanced to WB R2', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(3),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR2 = result.allMatches
            .firstWhere(
                (m) => m.bracketId == 'wb1' && m.roundNumber == 2);
        final byeMatch = result.allMatches
            .firstWhere((m) =>
                m.bracketId == 'wb1' &&
                m.resultType == MatchResultType.bye);
        final byeWinner = byeMatch.winnerId!;
        expect(
          wbR2.participantBlueId == byeWinner ||
              wbR2.participantRedId == byeWinner,
          isTrue,
          reason: 'Bye winner must be advanced to WB R2',
        );
      });

      test('WB bye match does NOT route loser to LB', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(3),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final byeMatch = result.allMatches
            .firstWhere((m) =>
                m.bracketId == 'wb1' &&
                m.resultType == MatchResultType.bye);
        expect(
          byeMatch.loserAdvancesToMatchId,
          isNull,
          reason: 'A bye has no real loser to drop to LB',
        );
      });
    });

    // ─────────────────────────────────────────────────────────────
    // 5 players — 3 byes
    // ─────────────────────────────────────────────────────────────
    group('5 players', () {
      test('WB has 3 rounds, LB has 4 rounds', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(5),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        expect(result.winnersBracket.totalRounds, 3);
        expect(result.losersBracket.totalRounds, 4);
      });

      test('WB R1 has 3 bye matches', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(5),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR1Byes = result.allMatches
            .where((m) =>
                m.bracketId == 'wb1' &&
                m.roundNumber == 1 &&
                m.resultType == MatchResultType.bye)
            .toList();
        expect(wbR1Byes.length, 3);
      });

      test('all bye winners advance to WB R2', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(5),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR2 = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber == 2)
            .toList();
        final byes = result.allMatches
            .where((m) =>
                m.bracketId == 'wb1' &&
                m.resultType == MatchResultType.bye)
            .toList();

        for (final bye in byes) {
          final winnerId = bye.winnerId!;
          final inR2 = wbR2.any((m) =>
              m.participantBlueId == winnerId ||
              m.participantRedId == winnerId);
          expect(
            inR2,
            isTrue,
            reason: 'Bye winner $winnerId must appear in WB R2',
          );
        }
      });
    });

    // ─────────────────────────────────────────────────────────────
    // 8 players — large bracket, no byes
    // ─────────────────────────────────────────────────────────────
    group('8 players', () {
      test('WB has 3 rounds', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        expect(result.winnersBracket.totalRounds, 3);
      });

      test('LB has 4 rounds', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        expect(result.losersBracket.totalRounds, 4);
      });

      test('WB match count: 7', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbMatches = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber <= 3)
            .toList();
        expect(wbMatches.length, 7);
      });

      test('LB match count: 6', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final lbMatches = result.allMatches
            .where((m) => m.bracketId == 'lb1')
            .toList();
        expect(lbMatches.length, 6);
      });

      test('LB round structure: R1=2, R2=2, R3=1, R4=1', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final lbByRound = <int, int>{};
        for (final m in result.allMatches.where((m) => m.bracketId == 'lb1')) {
          lbByRound[m.roundNumber] = (lbByRound[m.roundNumber] ?? 0) + 1;
        }
        expect(lbByRound[1], 2);
        expect(lbByRound[2], 2);
        expect(lbByRound[3], 1);
        expect(lbByRound[4], 1);
      });

      test('no bye matches in WB', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final byes = result.allMatches
            .where((m) =>
                m.bracketId == 'wb1' &&
                m.resultType == MatchResultType.bye);
        expect(byes, isEmpty);
      });

      test('WB R1 losers route to LB R1 (consolidation)', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR1 = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber == 1)
            .toList();
        final lbR1Ids = result.allMatches
            .where((m) => m.bracketId == 'lb1' && m.roundNumber == 1)
            .map((m) => m.id)
            .toSet();

        for (final m in wbR1) {
          expect(
            m.loserAdvancesToMatchId,
            isNotNull,
            reason: 'WB R1 M${m.matchNumberInRound} must route loser',
          );
          expect(
            lbR1Ids.contains(m.loserAdvancesToMatchId),
            isTrue,
            reason:
                'WB R1 M${m.matchNumberInRound} loser must route to LB R1',
          );
        }
      });

      test('WB R2 losers route to LB R2 (drop-in)', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR2 = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber == 2)
            .toList();
        final lbR2Ids = result.allMatches
            .where((m) => m.bracketId == 'lb1' && m.roundNumber == 2)
            .map((m) => m.id)
            .toSet();

        for (final m in wbR2) {
          expect(
            m.loserAdvancesToMatchId,
            isNotNull,
            reason: 'WB R2 M${m.matchNumberInRound} must route loser',
          );
          expect(
            lbR2Ids.contains(m.loserAdvancesToMatchId),
            isTrue,
            reason:
                'WB R2 M${m.matchNumberInRound} loser must route to LB R2',
          );
        }
      });

      test('WB R3 loser routes to LB R4 (drop-in)', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR3 = result.allMatches
            .firstWhere(
                (m) => m.bracketId == 'wb1' && m.roundNumber == 3);
        final lbR4Ids = result.allMatches
            .where((m) => m.bracketId == 'lb1' && m.roundNumber == 4)
            .map((m) => m.id)
            .toSet();

        expect(
          wbR3.loserAdvancesToMatchId,
          isNotNull,
          reason: 'WB Final loser must route to LB R4',
        );
        expect(
          lbR4Ids.contains(wbR3.loserAdvancesToMatchId),
          isTrue,
          reason: 'WB Final loser must route to LB R4',
        );
      });

      test('LB internal routing: odd rounds feed same count, even halve', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final lb = result.allMatches
            .where((m) => m.bracketId == 'lb1')
            .toList();
        final lbByRound = <int, List<MatchEntity>>{};
        for (final m in lb) {
          lbByRound.putIfAbsent(m.roundNumber, () => []).add(m);
        }

        // LB R1 (2 matches) → LB R2 (2 matches, same count)
        for (final m in lbByRound[1]!) {
          expect(m.winnerAdvancesToMatchId, isNotNull);
          final target = lb.firstWhere(
            (t) => t.id == m.winnerAdvancesToMatchId,
          );
          expect(target.roundNumber, 2);
        }

        // LB R2 (2 matches) → LB R3 (1 match, half count)
        for (final m in lbByRound[2]!) {
          expect(m.winnerAdvancesToMatchId, isNotNull);
          final target = lb.firstWhere(
            (t) => t.id == m.winnerAdvancesToMatchId,
          );
          expect(target.roundNumber, 3);
        }

        // LB R3 (1 match) → LB R4 (1 match, same count)
        for (final m in lbByRound[3]!) {
          expect(m.winnerAdvancesToMatchId, isNotNull);
          final target = lb.firstWhere(
            (t) => t.id == m.winnerAdvancesToMatchId,
          );
          expect(target.roundNumber, 4);
        }
      });

      test('LB final winner routes to grand finals', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final lbFinal = result.allMatches
            .where((m) => m.bracketId == 'lb1')
            .reduce((a, b) => a.roundNumber > b.roundNumber ? a : b);
        expect(
          lbFinal.winnerAdvancesToMatchId,
          result.grandFinalsMatch.id,
        );
      });

      test(
          'total matches: WB(7) + LB(6) + GF(1) + reset(1) = 15', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
          includeResetMatch: true,
        );
        expect(result.allMatches.length, 15);
      });

      test('all R1 participants in WB are assigned', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR1 = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber == 1);
        for (final m in wbR1) {
          expect(m.participantBlueId, isNotNull);
          expect(m.participantRedId, isNotNull);
        }
      });

      test('all participants appear exactly once in WB R1', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbR1 = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber == 1);
        final allP = <String>{};
        for (final m in wbR1) {
          if (m.participantBlueId != null) allP.add(m.participantBlueId!);
          if (m.participantRedId != null) allP.add(m.participantRedId!);
        }
        expect(allP, makeIds(8).toSet());
      });
    });

    // ─────────────────────────────────────────────────────────────
    // Bracket entities
    // ─────────────────────────────────────────────────────────────
    group('bracket entities', () {
      test('correct IDs and types', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(4),
          winnersBracketId: 'wb_test',
          losersBracketId: 'lb_test',
        );
        expect(result.winnersBracket.id, 'wb_test');
        expect(result.winnersBracket.bracketType, BracketType.winners);
        expect(result.losersBracket.id, 'lb_test');
        expect(result.losersBracket.bracketType, BracketType.losers);
      });

      test('both brackets reference correct divisionId', () {
        final result = service.generate(
          divisionId: 'div_99',
          participantIds: makeIds(4),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        expect(result.winnersBracket.divisionId, 'div_99');
        expect(result.losersBracket.divisionId, 'div_99');
      });
    });

    // ─────────────────────────────────────────────────────────────
    // Match uniqueness
    // ─────────────────────────────────────────────────────────────
    group('match uniqueness', () {
      test('all match IDs are unique', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
          includeResetMatch: true,
        );
        final ids = result.allMatches.map((m) => m.id).toSet();
        expect(ids.length, result.allMatches.length);
      });

      test('routing targets always point to valid matches', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
          includeResetMatch: true,
        );
        final allIds = result.allMatches.map((m) => m.id).toSet();
        for (final m in result.allMatches) {
          if (m.winnerAdvancesToMatchId != null) {
            expect(
              allIds.contains(m.winnerAdvancesToMatchId),
              isTrue,
              reason:
                  'R${m.roundNumber}M${m.matchNumberInRound} winnerAdvancesTo points to invalid match',
            );
          }
          if (m.loserAdvancesToMatchId != null) {
            expect(
              allIds.contains(m.loserAdvancesToMatchId),
              isTrue,
              reason:
                  'R${m.roundNumber}M${m.matchNumberInRound} loserAdvancesTo points to invalid match',
            );
          }
        }
      });
    });

    // ─────────────────────────────────────────────────────────────
    // Cross-bracket routing rule verification  
    // ─────────────────────────────────────────────────────────────
    group('cross-bracket routing rules', () {
      test('WB Round R losers go to LB Round 2*(R-1) for R>=2', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(8),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final lbById = {
          for (final m
              in result.allMatches.where((m) => m.bracketId == 'lb1'))
            m.id: m,
        };

        // WB R2 → LB R2 (2*(2-1) = 2)
        final wbR2 = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber == 2);
        for (final m in wbR2) {
          final target = lbById[m.loserAdvancesToMatchId!]!;
          expect(target.roundNumber, 2,
              reason: 'WB R2 loser must go to LB R2');
        }

        // WB R3 → LB R4 (2*(3-1) = 4)
        final wbR3 = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber == 3);
        for (final m in wbR3) {
          final target = lbById[m.loserAdvancesToMatchId!]!;
          expect(target.roundNumber, 4,
              reason: 'WB R3 loser must go to LB R4');
        }
      });

      test('16 players: WB R4 loser routes to LB R6', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(16),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final lbById = {
          for (final m
              in result.allMatches.where((m) => m.bracketId == 'lb1'))
            m.id: m,
        };

        final wbR4 = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber == 4);
        for (final m in wbR4) {
          final target = lbById[m.loserAdvancesToMatchId!]!;
          expect(target.roundNumber, 6,
              reason: 'WB R4 (final) loser must go to LB R6');
        }
      });
    });

    // ─────────────────────────────────────────────────────────────
    // 16 player bracket structure
    // ─────────────────────────────────────────────────────────────
    group('16 players', () {
      test('WB: 4 rounds, LB: 6 rounds', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(16),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        expect(result.winnersBracket.totalRounds, 4);
        expect(result.losersBracket.totalRounds, 6);
      });

      test('WB match count: 15', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(16),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final wbCore = result.allMatches
            .where((m) => m.bracketId == 'wb1' && m.roundNumber <= 4)
            .toList();
        expect(wbCore.length, 15);
      });

      test('LB match count: 14', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(16),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final lbMatches = result.allMatches
            .where((m) => m.bracketId == 'lb1')
            .toList();
        expect(lbMatches.length, 14);
      });

      test('total with reset: WB(15) + LB(14) + GF(1) + reset(1) = 31', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(16),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
          includeResetMatch: true,
        );
        expect(result.allMatches.length, 31);
      });

      test('LB round structure: R1=4, R2=4, R3=2, R4=2, R5=1, R6=1', () {
        final result = service.generate(
          divisionId: 'd1',
          participantIds: makeIds(16),
          winnersBracketId: 'wb1',
          losersBracketId: 'lb1',
        );
        final lbByRound = <int, int>{};
        for (final m in result.allMatches.where((m) => m.bracketId == 'lb1')) {
          lbByRound[m.roundNumber] = (lbByRound[m.roundNumber] ?? 0) + 1;
        }
        expect(lbByRound[1], 4);
        expect(lbByRound[2], 4);
        expect(lbByRound[3], 2);
        expect(lbByRound[4], 2);
        expect(lbByRound[5], 1);
        expect(lbByRound[6], 1);
      });
    });
  });
}

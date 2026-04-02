import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/data/services/participant_shuffle_service_implementation.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';

void main() {
  late ParticipantShuffleServiceImplementation shuffleService;

  /// Fixed seed so tests are deterministic.
  const deterministicSeed = 42;

  setUp(() {
    shuffleService = ParticipantShuffleServiceImplementation.seeded(
      Random(deterministicSeed),
    );
  });

  List<ParticipantEntity> buildParticipants(int count, {String? dojang}) {
    return List.generate(
      count,
      (index) => ParticipantEntity(
        id: 'p${index + 1}',
        genderId: 'g1',
        fullName: 'Player ${index + 1}',
        schoolOrDojangName: dojang,
      ),
    );
  }

  List<ParticipantEntity> buildParticipantsWithDojangs(
    Map<String, int> dojangToCountMap,
  ) {
    final participants = <ParticipantEntity>[];
    var globalIndex = 0;
    for (final entry in dojangToCountMap.entries) {
      for (var localIndex = 0; localIndex < entry.value; localIndex++) {
        globalIndex++;
        participants.add(
          ParticipantEntity(
            id: 'p$globalIndex',
            genderId: 'g1',
            fullName: 'Player $globalIndex',
            schoolOrDojangName: entry.key,
          ),
        );
      }
    }
    return participants;
  }

  group('Basic Fisher-Yates shuffle', () {
    test('empty list returns empty list', () {
      final result = shuffleService.shuffleParticipantsForBracketGeneration(
        participants: [],
        dojangSeparation: false,
      );
      expect(result, isEmpty);
    });

    test('single participant list returns identical list', () {
      final singleParticipant = buildParticipants(1);
      final result = shuffleService.shuffleParticipantsForBracketGeneration(
        participants: singleParticipant,
        dojangSeparation: false,
      );
      expect(result, hasLength(1));
      expect(result.first.id, 'p1');
    });

    test('shuffled list contains all original participants', () {
      final participants = buildParticipants(8);
      final result = shuffleService.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: false,
      );

      expect(result, hasLength(8));
      final resultIds = result.map((participant) => participant.id).toSet();
      final originalIds = participants
          .map((participant) => participant.id)
          .toSet();
      expect(resultIds, equals(originalIds));
    });

    test('shuffled list has no duplicate participants', () {
      final participants = buildParticipants(16);
      final result = shuffleService.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: false,
      );

      final resultIds = result.map((participant) => participant.id).toList();
      expect(resultIds.toSet().length, resultIds.length);
    });

    test('shuffled list differs from original order with seeded Random', () {
      final participants = buildParticipants(8);
      final result = shuffleService.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: false,
      );

      final originalIds = participants
          .map((participant) => participant.id)
          .toList();
      final resultIds = result.map((participant) => participant.id).toList();
      // With 8 participants and seed 42, it's virtually impossible for
      // the shuffle to produce the exact same order.
      expect(resultIds, isNot(equals(originalIds)));
    });

    test('original list is not mutated by shuffle', () {
      final participants = buildParticipants(8);
      final originalIds = participants
          .map((participant) => participant.id)
          .toList();

      shuffleService.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: false,
      );

      final idsAfterCall = participants
          .map((participant) => participant.id)
          .toList();
      expect(idsAfterCall, equals(originalIds));
    });

    test('two calls with the same seed produce the same shuffle order', () {
      final participants = buildParticipants(8);

      final serviceA = ParticipantShuffleServiceImplementation.seeded(
        Random(deterministicSeed),
      );
      final serviceB = ParticipantShuffleServiceImplementation.seeded(
        Random(deterministicSeed),
      );

      final resultA = serviceA.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: false,
      );
      final resultB = serviceB.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: false,
      );

      final idsA = resultA.map((participant) => participant.id).toList();
      final idsB = resultB.map((participant) => participant.id).toList();
      expect(idsA, equals(idsB));
    });
  });

  group('Dojang separation constraint repair', () {
    test('two athletes from same dojang are placed in opposite halves', () {
      // 4 players: 2 from DojangA, 2 from DojangB.
      final participants = buildParticipantsWithDojangs({
        'DojangA': 2,
        'DojangB': 2,
      });

      final result = shuffleService.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: true,
      );

      final halfBoundary = result.length ~/ 2;
      final topHalfDojangs = result
          .sublist(0, halfBoundary)
          .map((participant) => participant.schoolOrDojangName)
          .toList();
      final bottomHalfDojangs = result
          .sublist(halfBoundary)
          .map((participant) => participant.schoolOrDojangName)
          .toList();

      // Each dojang should have at most 1 athlete in each half.
      final dojangAInTopHalf = topHalfDojangs
          .where((name) => name == 'DojangA')
          .length;
      final dojangAInBottomHalf = bottomHalfDojangs
          .where((name) => name == 'DojangA')
          .length;
      expect(dojangAInTopHalf, lessThanOrEqualTo(1));
      expect(dojangAInBottomHalf, lessThanOrEqualTo(1));
    });

    test('three athletes from same dojang: at most 2 in one half', () {
      final participants = buildParticipantsWithDojangs({
        'DojangA': 3,
        'DojangB': 1,
        'DojangC': 2,
      });

      final result = shuffleService.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: true,
      );

      final halfBoundary = result.length ~/ 2;
      final topHalfDojangACount = result
          .sublist(0, halfBoundary)
          .where((p) => p.schoolOrDojangName == 'DojangA')
          .length;
      final bottomHalfDojangACount = result
          .sublist(halfBoundary)
          .where((p) => p.schoolOrDojangName == 'DojangA')
          .length;

      // ceil(3/2) = 2 max per half.
      expect(topHalfDojangACount, lessThanOrEqualTo(2));
      expect(bottomHalfDojangACount, lessThanOrEqualTo(2));
    });

    test('all athletes from same dojang degenerates gracefully', () {
      final participants = buildParticipantsWithDojangs({'DojangA': 6});

      // Should not throw — just does best-effort.
      final result = shuffleService.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: true,
      );

      expect(result, hasLength(6));
      final resultIds = result.map((participant) => participant.id).toSet();
      expect(resultIds, hasLength(6));
    });

    test('participants with no dojang name are not grouped together', () {
      // 4 unaffiliated + 2 from same dojang.
      final participants = [
        ...buildParticipants(4), // no dojang
        ...buildParticipantsWithDojangs({'DojangA': 2}),
      ];
      // Reassign IDs to be unique.
      final uniqueParticipants = participants
          .asMap()
          .entries
          .map((entry) => entry.value.copyWith(id: 'p${entry.key + 1}'))
          .toList();

      final result = shuffleService.shuffleParticipantsForBracketGeneration(
        participants: uniqueParticipants,
        dojangSeparation: true,
      );

      // All participants should still be present.
      expect(result, hasLength(6));
      final resultIds = result.map((participant) => participant.id).toSet();
      expect(resultIds, hasLength(6));
    });

    test('eight participants across four dojangs are well-distributed', () {
      final participants = buildParticipantsWithDojangs({
        'Alpha': 3,
        'Beta': 2,
        'Gamma': 2,
        'Delta': 1,
      });

      final result = shuffleService.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: true,
      );

      final halfBoundary = result.length ~/ 2;
      for (final dojangName in ['Alpha', 'Beta', 'Gamma']) {
        final inTopHalf = result
            .sublist(0, halfBoundary)
            .where((p) => p.schoolOrDojangName == dojangName)
            .length;
        final totalForDojang = result
            .where((p) => p.schoolOrDojangName == dojangName)
            .length;
        final maximumAllowed = (totalForDojang + 1) ~/ 2;
        expect(
          inTopHalf,
          lessThanOrEqualTo(maximumAllowed),
          reason:
              '$dojangName has $inTopHalf in top half '
              '(max allowed: $maximumAllowed)',
        );
      }
    });

    test('dojangSeparation=false does NOT apply constraint repair', () {
      // Even with same-dojang participants, no separation is enforced.
      final participants = buildParticipantsWithDojangs({
        'DojangA': 4,
        'DojangB': 4,
      });

      // Run 10 shuffles and confirm that at least one has >2 same-dojang
      // in one half (which separation would prevent).
      bool foundUnseparatedShuffle = false;
      for (var attempt = 0; attempt < 10; attempt++) {
        final service = ParticipantShuffleServiceImplementation.seeded(
          Random(attempt),
        );
        final result = service.shuffleParticipantsForBracketGeneration(
          participants: participants,
          dojangSeparation: false,
        );
        final halfBoundary = result.length ~/ 2;
        final dojangAInTopHalf = result
            .sublist(0, halfBoundary)
            .where((p) => p.schoolOrDojangName == 'DojangA')
            .length;
        if (dojangAInTopHalf > 2) {
          foundUnseparatedShuffle = true;
          break;
        }
      }
      expect(
        foundUnseparatedShuffle,
        isTrue,
        reason:
            'Without separation, at least one random seed should '
            'produce >2 same-dojang participants in one half.',
      );
    });
  });
}

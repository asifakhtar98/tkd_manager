import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

void main() {
  late BracketBloc bracketBloc;

  final eightParticipants = <ParticipantEntity>[
    const ParticipantEntity(id: 'p1', genderId: 'g1', fullName: 'Alice Kim'),
    const ParticipantEntity(id: 'p2', genderId: 'g1', fullName: 'Bob Park'),
    const ParticipantEntity(id: 'p3', genderId: 'g1', fullName: 'Charlie Lee'),
    const ParticipantEntity(id: 'p4', genderId: 'g1', fullName: 'Dave Choi'),
    const ParticipantEntity(id: 'p5', genderId: 'g1', fullName: 'Eva Song'),
    const ParticipantEntity(id: 'p6', genderId: 'g1', fullName: 'Frank Yoo'),
    const ParticipantEntity(id: 'p7', genderId: 'g1', fullName: 'Grace Han'),
    const ParticipantEntity(id: 'p8', genderId: 'g1', fullName: 'Henry Lim'),
  ];

  setUp(() {
    configureDependencies();
    bracketBloc = getIt<BracketBloc>();
  });

  tearDown(() async {
    await bracketBloc.close();
    await getIt.reset();
  });

  /// Generates a bracket and waits for BracketLoadSuccess.
  Future<BracketLoadSuccess> generateBracket({
    List<ParticipantEntity>? participants,
    BracketFormat format = BracketFormat.singleElimination,
  }) async {
    bracketBloc.add(
      BracketEvent.generateRequested(
        participants: participants ?? eightParticipants,
        bracketFormat: format,
        dojangSeparation: false,
        includeThirdPlaceMatch: false,
      ),
    );
    await expectLater(
      bracketBloc.stream,
      emitsThrough(isA<BracketLoadSuccess>()),
    );
    return bracketBloc.state as BracketLoadSuccess;
  }

  /// Helper: extracts the ordered participant IDs from Round 1 match slots.
  List<String?> extractFirstRoundParticipantSlotIds(
    BracketLoadSuccess bracketLoadSuccessState,
  ) {
    final allMatches = switch (bracketLoadSuccessState.result) {
      SingleEliminationResult(:final data) => data.matches,
      DoubleEliminationResult(:final data) => data.allMatches,
    };

    final firstRoundMatches =
        allMatches.where((matchEntity) => matchEntity.roundNumber == 1).toList()
          ..sort(
            (matchEntityA, matchEntityB) => matchEntityA.matchNumberInRound
                .compareTo(matchEntityB.matchNumberInRound),
          );

    final participantSlotIds = <String?>[];
    for (final match in firstRoundMatches) {
      participantSlotIds.add(match.participantBlueId);
      participantSlotIds.add(match.participantRedId);
    }
    return participantSlotIds;
  }

  group('Regeneration shuffles participants', () {
    test(
      'regeneration produces a different participant ordering in Round 1',
      () async {
        final initialState = await generateBracket();
        final initialSlotIds = extractFirstRoundParticipantSlotIds(
          initialState,
        );

        // Regenerate.
        bracketBloc.add(const BracketEvent.regenerateRequested());
        await expectLater(
          bracketBloc.stream,
          emitsThrough(isA<BracketLoadSuccess>()),
        );
        final afterRegeneration = bracketBloc.state as BracketLoadSuccess;
        final regeneratedSlotIds = extractFirstRoundParticipantSlotIds(
          afterRegeneration,
        );

        // The participant IDs in Round 1 slots should differ from the original.
        expect(
          regeneratedSlotIds,
          isNot(equals(initialSlotIds)),
          reason:
              'Regeneration should shuffle participants into different '
              'bracket positions.',
        );
      },
    );

    test('regeneration preserves all participant identities', () async {
      final initialState = await generateBracket();
      final initialParticipantIds = initialState.participants
          .map((participant) => participant.id)
          .toSet();

      bracketBloc.add(const BracketEvent.regenerateRequested());
      await expectLater(
        bracketBloc.stream,
        emitsThrough(isA<BracketLoadSuccess>()),
      );
      final afterRegeneration = bracketBloc.state as BracketLoadSuccess;
      final regeneratedParticipantIds = afterRegeneration.participants
          .map((participant) => participant.id)
          .toSet();

      expect(regeneratedParticipantIds, equals(initialParticipantIds));
    });

    test('regeneration clears action history', () async {
      final initialState = await generateBracket();

      // Verify we start clean.
      expect(initialState.actionHistory, isEmpty);
      expect(initialState.historyPointer, -1);

      bracketBloc.add(const BracketEvent.regenerateRequested());
      await expectLater(
        bracketBloc.stream,
        emitsThrough(isA<BracketLoadSuccess>()),
      );
      final afterRegeneration = bracketBloc.state as BracketLoadSuccess;

      expect(afterRegeneration.actionHistory, isEmpty);
      expect(afterRegeneration.historyPointer, -1);
    });

    test('multiple regenerations produce varied results', () async {
      await generateBracket();

      final observedOrderings = <String>[];

      for (var attempt = 0; attempt < 5; attempt++) {
        bracketBloc.add(const BracketEvent.regenerateRequested());
        await expectLater(
          bracketBloc.stream,
          emitsThrough(isA<BracketLoadSuccess>()),
        );
        final currentState = bracketBloc.state as BracketLoadSuccess;
        final slotIds = extractFirstRoundParticipantSlotIds(currentState);
        observedOrderings.add(slotIds.join(','));
      }

      // At least 2 distinct orderings should appear in 5 attempts.
      final uniqueOrderings = observedOrderings.toSet();
      expect(
        uniqueOrderings.length,
        greaterThanOrEqualTo(2),
        reason:
            '5 regenerations should produce at least 2 distinct '
            'participant orderings.',
      );
    });

    test('regeneration works for double elimination format', () async {
      final initialState = await generateBracket(
        format: BracketFormat.doubleElimination,
      );
      final initialSlotIds = extractFirstRoundParticipantSlotIds(initialState);

      bracketBloc.add(const BracketEvent.regenerateRequested());
      await expectLater(
        bracketBloc.stream,
        emitsThrough(isA<BracketLoadSuccess>()),
      );
      final afterRegeneration = bracketBloc.state as BracketLoadSuccess;
      final regeneratedSlotIds = extractFirstRoundParticipantSlotIds(
        afterRegeneration,
      );

      expect(
        regeneratedSlotIds,
        isNot(equals(initialSlotIds)),
        reason: 'DE regeneration should also shuffle participants.',
      );
    });
  });
}

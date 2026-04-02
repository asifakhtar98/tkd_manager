import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/setup_bracket/presentation/bloc/setup_bracket_bloc.dart';
import 'package:uuid/uuid.dart';

class _MockStorage extends Mock implements Storage {}

const _testTournamentId = 'test-tournament-id-001';

SetupBracketBloc _createTestBloc() {
  return SetupBracketBloc(_testTournamentId, const Uuid());
}

ParticipantEntity _buildParticipant({
  required String fullName,
  String? schoolOrDojangName,
  int seedNumber = 1,
}) {
  return ParticipantEntity(
    id: const Uuid().v4(),
    genderId: 'manual_division',
    fullName: fullName,
    seedNumber: seedNumber,
    schoolOrDojangName: schoolOrDojangName,
  );
}

void main() {
  late _MockStorage mockHydratedStorage;

  setUpAll(() {
    mockHydratedStorage = _MockStorage();
    when(
      () => mockHydratedStorage.write(any(), any()),
    ).thenAnswer((_) async {});
    when(() => mockHydratedStorage.read(any())).thenReturn(null);
    when(() => mockHydratedStorage.delete(any())).thenAnswer((_) async {});
    when(() => mockHydratedStorage.clear()).thenAnswer((_) async {});
    HydratedBloc.storage = mockHydratedStorage;
  });

  group('SetupBracketBloc — initial state', () {
    test('emits correct default values for a new tournament', () {
      final setupBracketBloc = _createTestBloc();

      final initialState = setupBracketBloc.state;

      expect(initialState.tournamentId, equals(_testTournamentId));
      expect(initialState.participants, isEmpty);
      expect(
        initialState.selectedBracketFormat,
        equals(BracketFormat.singleElimination),
      );
      expect(initialState.isDojangSeparationEnabled, isTrue);
      expect(initialState.isThirdPlaceMatchIncluded, isFalse);
      expect(initialState.bracketAgeCategoryLabel, isEmpty);
      expect(initialState.bracketGenderLabel, isEmpty);
      expect(initialState.bracketWeightDivisionLabel, isEmpty);
      expect(initialState.isAwaitingBracketGeneration, isFalse);
      expect(initialState.pendingSnapshotId, isNull);

      addTearDown(setupBracketBloc.close);
    });
  });

  group('SetupBracketBloc — storage key', () {
    test(
      'id is scoped to tournamentId so different tournaments are isolated',
      () {
        final setupBracketBloc = _createTestBloc();
        expect(setupBracketBloc.id, equals('setup_bracket_$_testTournamentId'));
        addTearDown(setupBracketBloc.close);
      },
    );
  });

  group('SetupBracketParticipantAdded', () {
    test('appends participant to empty roster with seed 1', () {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: 'John Doe'),
      );

      expect(
        setupBracketBloc.stream,
        emits(
          predicate<SetupBracketState>((state) {
            return state.participants.length == 1 &&
                state.participants.first.fullName == 'John Doe' &&
                state.participants.first.seedNumber == 1;
          }),
        ),
      );

      addTearDown(setupBracketBloc.close);
    });

    test(
      'seed numbers increment sequentially for each added participant',
      () async {
        final setupBracketBloc = _createTestBloc();

        setupBracketBloc.add(
          const SetupBracketEvent.participantAdded(fullName: 'Alice'),
        );
        setupBracketBloc.add(
          const SetupBracketEvent.participantAdded(fullName: 'Bob'),
        );
        setupBracketBloc.add(
          const SetupBracketEvent.participantAdded(fullName: 'Charlie'),
        );

        await Future<void>.delayed(Duration.zero);

        final participants = setupBracketBloc.state.participants;
        expect(participants.length, equals(3));
        expect(participants[0].seedNumber, equals(1));
        expect(participants[1].seedNumber, equals(2));
        expect(participants[2].seedNumber, equals(3));

        addTearDown(setupBracketBloc.close);
      },
    );

    test('trims whitespace from full name', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: '  Jane Smith  '),
      );

      await Future<void>.delayed(Duration.zero);

      expect(
        setupBracketBloc.state.participants.first.fullName,
        equals('Jane Smith'),
      );
      addTearDown(setupBracketBloc.close);
    });

    test('empty registrationId and dojang become null', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(
          fullName: 'No ID Athlete',
          registrationId: '',
          schoolOrDojangName: '  ',
        ),
      );

      await Future<void>.delayed(Duration.zero);

      final participant = setupBracketBloc.state.participants.first;
      expect(participant.registrationId, isNull);
      expect(participant.schoolOrDojangName, isNull);
      addTearDown(setupBracketBloc.close);
    });
  });

  group('SetupBracketParticipantsImportedFromCsv', () {
    test('parses three-column CSV correctly', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantsImportedFromCsv(
          csvRawText:
              'John Doe, REG001, Tiger Dojang\nJane Smith, REG002, Dragon Club',
        ),
      );

      await Future<void>.delayed(Duration.zero);

      final participants = setupBracketBloc.state.participants;
      expect(participants.length, equals(2));
      expect(participants[0].fullName, equals('John Doe'));
      expect(participants[0].registrationId, equals('REG001'));
      expect(participants[0].schoolOrDojangName, equals('Tiger Dojang'));
      expect(participants[1].fullName, equals('Jane Smith'));
      expect(participants[1].seedNumber, equals(2));
      addTearDown(setupBracketBloc.close);
    });

    test('skips blank lines in CSV', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantsImportedFromCsv(
          csvRawText: 'Alice\n\nBob\n\n',
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(setupBracketBloc.state.participants.length, equals(2));
      addTearDown(setupBracketBloc.close);
    });

    test('empty CSV string produces no state change', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantsImportedFromCsv(csvRawText: '   '),
      );

      await Future<void>.delayed(Duration.zero);

      expect(setupBracketBloc.state.participants, isEmpty);
      addTearDown(setupBracketBloc.close);
    });

    test('appends imported participants to existing roster', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: 'Existing Player'),
      );
      setupBracketBloc.add(
        const SetupBracketEvent.participantsImportedFromCsv(
          csvRawText: 'New Player 1\nNew Player 2',
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(setupBracketBloc.state.participants.length, equals(3));
      addTearDown(setupBracketBloc.close);
    });
  });

  group('SetupBracketParticipantRemoved', () {
    test('removes participant at given index and reseeds remaining', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: 'A'),
      );
      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: 'B'),
      );
      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: 'C'),
      );
      await Future<void>.delayed(Duration.zero);

      setupBracketBloc.add(
        const SetupBracketEvent.participantRemoved(rosterIndex: 1),
      );
      await Future<void>.delayed(Duration.zero);

      final participants = setupBracketBloc.state.participants;
      expect(participants.length, equals(2));
      expect(participants[0].fullName, equals('A'));
      expect(participants[0].seedNumber, equals(1));
      expect(participants[1].fullName, equals('C'));
      expect(participants[1].seedNumber, equals(2));
      addTearDown(setupBracketBloc.close);
    });

    test('out-of-range index is silently ignored (no RangeError)', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: 'Only'),
      );
      await Future<void>.delayed(Duration.zero);

      // Index 5 is way out of range for a 1-element list.
      setupBracketBloc.add(
        const SetupBracketEvent.participantRemoved(rosterIndex: 5),
      );
      // Negative index should also be safe.
      setupBracketBloc.add(
        const SetupBracketEvent.participantRemoved(rosterIndex: -1),
      );
      await Future<void>.delayed(Duration.zero);

      // Roster unchanged.
      expect(setupBracketBloc.state.participants.length, equals(1));
      addTearDown(setupBracketBloc.close);
    });
  });

  group('SetupBracketParticipantsCleared', () {
    test('empties the entire roster', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: 'Player1'),
      );
      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: 'Player2'),
      );
      await Future<void>.delayed(Duration.zero);

      setupBracketBloc.add(const SetupBracketEvent.participantsCleared());
      await Future<void>.delayed(Duration.zero);

      expect(setupBracketBloc.state.participants, isEmpty);
      addTearDown(setupBracketBloc.close);
    });
  });

  group('SetupBracketParticipantsReordered', () {
    test('moves participant forwards and reseeds', () async {
      final setupBracketBloc = _createTestBloc();

      for (final name in ['A', 'B', 'C', 'D']) {
        setupBracketBloc.add(
          SetupBracketEvent.participantAdded(fullName: name),
        );
      }
      await Future<void>.delayed(Duration.zero);

      // Move A (index 0) to after D (ReorderableListView reports newIndex=4).
      setupBracketBloc.add(
        const SetupBracketEvent.participantsReordered(oldIndex: 0, newIndex: 4),
      );
      await Future<void>.delayed(Duration.zero);

      final participants = setupBracketBloc.state.participants;
      expect(
        participants.map((p) => p.fullName).toList(),
        equals(['B', 'C', 'D', 'A']),
      );
      expect(
        participants.map((p) => p.seedNumber).toList(),
        equals([1, 2, 3, 4]),
      );
      addTearDown(setupBracketBloc.close);
    });

    test('moves participant backwards and reseeds', () async {
      final setupBracketBloc = _createTestBloc();

      for (final name in ['A', 'B', 'C', 'D']) {
        setupBracketBloc.add(
          SetupBracketEvent.participantAdded(fullName: name),
        );
      }
      await Future<void>.delayed(Duration.zero);

      // Move D (index 3) to the front (newIndex=0).
      setupBracketBloc.add(
        const SetupBracketEvent.participantsReordered(oldIndex: 3, newIndex: 0),
      );
      await Future<void>.delayed(Duration.zero);

      final participants = setupBracketBloc.state.participants;
      expect(
        participants.map((p) => p.fullName).toList(),
        equals(['D', 'A', 'B', 'C']),
      );
      addTearDown(setupBracketBloc.close);
    });

    test('out-of-range indices are silently ignored (no RangeError)', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: 'Solo'),
      );
      await Future<void>.delayed(Duration.zero);

      // oldIndex out of range.
      setupBracketBloc.add(
        const SetupBracketEvent.participantsReordered(
          oldIndex: 10,
          newIndex: 0,
        ),
      );
      // Negative oldIndex.
      setupBracketBloc.add(
        const SetupBracketEvent.participantsReordered(
          oldIndex: -1,
          newIndex: 0,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      // Roster unchanged.
      expect(setupBracketBloc.state.participants.length, equals(1));
      expect(
        setupBracketBloc.state.participants.first.fullName,
        equals('Solo'),
      );
      addTearDown(setupBracketBloc.close);
    });
  });

  group('SetupBracketFormatChanged', () {
    test('updates selected format', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.bracketFormatChanged(
          newFormat: BracketFormat.doubleElimination,
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(
        setupBracketBloc.state.selectedBracketFormat,
        equals(BracketFormat.doubleElimination),
      );
      addTearDown(setupBracketBloc.close);
    });

    test(
      'clears third place match when switching away from single-elimination',
      () async {
        final setupBracketBloc = _createTestBloc();

        // Enable third-place match first.
        setupBracketBloc.add(
          const SetupBracketEvent.thirdPlaceMatchToggled(isEnabled: true),
        );
        await Future<void>.delayed(Duration.zero);

        expect(setupBracketBloc.state.isThirdPlaceMatchIncluded, isTrue);

        // Switch to double elimination — third place match must be cleared.
        setupBracketBloc.add(
          const SetupBracketEvent.bracketFormatChanged(
            newFormat: BracketFormat.doubleElimination,
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(setupBracketBloc.state.isThirdPlaceMatchIncluded, isFalse);
        addTearDown(setupBracketBloc.close);
      },
    );
  });

  group('SetupBracketDojangSeparationToggled', () {
    test('toggles dojang separation flag', () async {
      final setupBracketBloc = _createTestBloc();

      expect(setupBracketBloc.state.isDojangSeparationEnabled, isTrue);

      setupBracketBloc.add(
        const SetupBracketEvent.dojangSeparationToggled(isEnabled: false),
      );
      await Future<void>.delayed(Duration.zero);

      expect(setupBracketBloc.state.isDojangSeparationEnabled, isFalse);
      addTearDown(setupBracketBloc.close);
    });
  });

  group('SetupBracketThirdPlaceMatchToggled', () {
    test('toggles third place match flag', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.thirdPlaceMatchToggled(isEnabled: true),
      );
      await Future<void>.delayed(Duration.zero);

      expect(setupBracketBloc.state.isThirdPlaceMatchIncluded, isTrue);
      addTearDown(setupBracketBloc.close);
    });
  });

  group('SetupBracketClassificationUpdated', () {
    test('updates all three classification labels', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.classificationUpdated(
          ageCategoryLabel: 'Junior',
          genderLabel: 'Male',
          weightDivisionLabel: '-58kg',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(setupBracketBloc.state.bracketAgeCategoryLabel, equals('Junior'));
      expect(setupBracketBloc.state.bracketGenderLabel, equals('Male'));
      expect(
        setupBracketBloc.state.bracketWeightDivisionLabel,
        equals('-58kg'),
      );
      addTearDown(setupBracketBloc.close);
    });
  });

  group('SetupBracketGenerationDispatched', () {
    test(
      'sets isAwaitingBracketGeneration and stores pendingSnapshotId',
      () async {
        final setupBracketBloc = _createTestBloc();
        const fakeSnapshotId = 'snapshot-abc-123';

        setupBracketBloc.add(
          const SetupBracketEvent.bracketGenerationDispatched(
            pendingSnapshotId: fakeSnapshotId,
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(setupBracketBloc.state.isAwaitingBracketGeneration, isTrue);
        expect(
          setupBracketBloc.state.pendingSnapshotId,
          equals(fakeSnapshotId),
        );
        addTearDown(setupBracketBloc.close);
      },
    );
  });

  group('SetupBracketGenerationSucceeded', () {
    test(
      'resets state to fresh SetupBracketState preserving tournamentId',
      () async {
        final setupBracketBloc = _createTestBloc();

        // Simulate a full bracket setup session.
        setupBracketBloc.add(
          const SetupBracketEvent.participantAdded(fullName: 'Athlete One'),
        );
        setupBracketBloc.add(
          const SetupBracketEvent.classificationUpdated(
            ageCategoryLabel: 'Senior',
            genderLabel: 'Female',
            weightDivisionLabel: '-68kg',
          ),
        );
        setupBracketBloc.add(
          const SetupBracketEvent.bracketGenerationDispatched(
            pendingSnapshotId: 'snap-001',
          ),
        );
        await Future<void>.delayed(Duration.zero);

        setupBracketBloc.add(
          const SetupBracketEvent.bracketGenerationSucceeded(),
        );
        await Future<void>.delayed(Duration.zero);

        final stateAfterSuccess = setupBracketBloc.state;
        expect(stateAfterSuccess.tournamentId, equals(_testTournamentId));
        expect(stateAfterSuccess.participants, isEmpty);
        expect(stateAfterSuccess.isAwaitingBracketGeneration, isFalse);
        expect(stateAfterSuccess.pendingSnapshotId, isNull);
        expect(stateAfterSuccess.bracketAgeCategoryLabel, isEmpty);
        addTearDown(setupBracketBloc.close);
      },
    );
  });

  group('SetupBracketGenerationFailed', () {
    test('clears generation loading state but retains roster', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: 'Player1'),
      );
      setupBracketBloc.add(
        const SetupBracketEvent.bracketGenerationDispatched(
          pendingSnapshotId: 'snap-002',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      setupBracketBloc.add(const SetupBracketEvent.bracketGenerationFailed());
      await Future<void>.delayed(Duration.zero);

      final stateAfterFailure = setupBracketBloc.state;
      expect(stateAfterFailure.isAwaitingBracketGeneration, isFalse);
      expect(stateAfterFailure.pendingSnapshotId, isNull);
      // Roster is retained so the user can try again without re-entering data.
      expect(stateAfterFailure.participants.length, equals(1));
      addTearDown(setupBracketBloc.close);
    });
  });

  group('SetupBracketState convenience getters', () {
    test(
      'hasEnoughParticipantsToGenerate is false for 0 and 1 participants',
      () async {
        final setupBracketBloc = _createTestBloc();

        expect(setupBracketBloc.state.hasEnoughParticipantsToGenerate, isFalse);

        setupBracketBloc.add(
          const SetupBracketEvent.participantAdded(fullName: 'Solo Player'),
        );
        await Future<void>.delayed(Duration.zero);

        expect(setupBracketBloc.state.hasEnoughParticipantsToGenerate, isFalse);
        addTearDown(setupBracketBloc.close);
      },
    );

    test(
      'hasEnoughParticipantsToGenerate is true with 2+ participants',
      () async {
        final setupBracketBloc = _createTestBloc();

        setupBracketBloc.add(
          const SetupBracketEvent.participantAdded(fullName: 'Player One'),
        );
        setupBracketBloc.add(
          const SetupBracketEvent.participantAdded(fullName: 'Player Two'),
        );
        await Future<void>.delayed(Duration.zero);

        expect(setupBracketBloc.state.hasEnoughParticipantsToGenerate, isTrue);
        addTearDown(setupBracketBloc.close);
      },
    );

    test('isDuplicateParticipantName is case-insensitive', () async {
      final setupBracketBloc = _createTestBloc();

      setupBracketBloc.add(
        const SetupBracketEvent.participantAdded(fullName: 'John Doe'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        setupBracketBloc.state.isDuplicateParticipantName('john doe'),
        isTrue,
      );
      expect(
        setupBracketBloc.state.isDuplicateParticipantName('JOHN DOE'),
        isTrue,
      );
      expect(
        setupBracketBloc.state.isDuplicateParticipantName('Jane Doe'),
        isFalse,
      );
      addTearDown(setupBracketBloc.close);
    });
  });

  group('SetupBracketBloc JSON hydration round-trip', () {
    test('toJson / fromJson preserves all state fields', () {
      final setupBracketBloc = _createTestBloc();

      final originalState = SetupBracketState(
        tournamentId: 'tour-123',
        participants: [
          _buildParticipant(fullName: 'Athlete A', seedNumber: 1),
          _buildParticipant(
            fullName: 'Athlete B',
            schoolOrDojangName: 'Tiger Dojang',
            seedNumber: 2,
          ),
        ],
        selectedBracketFormat: BracketFormat.doubleElimination,
        isDojangSeparationEnabled: false,
        isThirdPlaceMatchIncluded: false,
        bracketAgeCategoryLabel: 'Senior',
        bracketGenderLabel: 'Female',
        bracketWeightDivisionLabel: '-62kg',
      );

      final json = setupBracketBloc.toJson(originalState);
      expect(json, isNotNull);

      final restoredState = setupBracketBloc.fromJson(json!);
      expect(restoredState, isNotNull);

      expect(restoredState!.tournamentId, equals(originalState.tournamentId));
      expect(
        restoredState.participants.length,
        equals(originalState.participants.length),
      );
      expect(restoredState.participants[0].fullName, equals('Athlete A'));
      expect(
        restoredState.participants[1].schoolOrDojangName,
        equals('Tiger Dojang'),
      );
      expect(
        restoredState.selectedBracketFormat,
        equals(BracketFormat.doubleElimination),
      );
      expect(restoredState.isDojangSeparationEnabled, isFalse);
      expect(restoredState.bracketAgeCategoryLabel, equals('Senior'));
      expect(restoredState.bracketGenderLabel, equals('Female'));
      expect(restoredState.bracketWeightDivisionLabel, equals('-62kg'));

      addTearDown(setupBracketBloc.close);
    });

    test('fromJson returns null (not crash) for corrupt JSON', () {
      final setupBracketBloc = _createTestBloc();

      final corruptJson = <String, dynamic>{'invalid_key': 'garbage_value'};
      final restoredState = setupBracketBloc.fromJson(corruptJson);

      // Must return null and log — not throw.
      expect(restoredState, isNull);
      addTearDown(setupBracketBloc.close);
    });
  });
}

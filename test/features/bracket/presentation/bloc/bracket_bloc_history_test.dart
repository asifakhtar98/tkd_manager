import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

void main() {
  late BracketBloc bracketBloc;

  final fourParticipants = <ParticipantEntity>[
    const ParticipantEntity(id: 'p1', genderId: 'div1', fullName: 'Alice Kim'),
    const ParticipantEntity(id: 'p2', genderId: 'div1', fullName: 'Bob Park'),
    const ParticipantEntity(
      id: 'p3',
      genderId: 'div1',
      fullName: 'Charlie Lee',
    ),
    const ParticipantEntity(id: 'p4', genderId: 'div1', fullName: 'Dave Choi'),
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
        participants: participants ?? fourParticipants,
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

  /// Finds the first scorable match (both participants assigned, not completed).
  MatchEntity findFirstScorableMatch(BracketLoadSuccess state) {
    final allMatches = switch (state.result) {
      SingleEliminationResult(:final data) => data.matches,
      DoubleEliminationResult(:final data) => data.allMatches,
    };
    return allMatches.firstWhere(
      (matchEntity) =>
          matchEntity.participantBlueId != null &&
          matchEntity.participantRedId != null &&
          matchEntity.status != MatchStatus.completed,
    );
  }

  /// Records a result on the given match (blue player wins by points).
  Future<BracketLoadSuccess> recordMatchResult(
    MatchEntity match, {
    int? blueScore,
    int? redScore,
  }) async {
    bracketBloc.add(
      BracketEvent.matchResultRecorded(
        matchId: match.id,
        winnerId: match.participantBlueId!,
        resultType: MatchResultType.points,
        blueScore: blueScore,
        redScore: redScore,
      ),
    );
    // Wait for a new BracketLoadSuccess with updated history pointer.
    await expectLater(
      bracketBloc.stream,
      emitsThrough(isA<BracketLoadSuccess>()),
    );
    return bracketBloc.state as BracketLoadSuccess;
  }

  group('History tracking', () {
    test(
      'recording a match result adds an entry to actionHistory and increments historyPointer',
      () async {
        final initialState = await generateBracket();
        expect(initialState.actionHistory, isEmpty);
        expect(initialState.historyPointer, -1);
        expect(initialState.initialResult, isNotNull);

        final match = findFirstScorableMatch(initialState);
        final afterRecord = await recordMatchResult(match);

        expect(afterRecord.actionHistory, hasLength(1));
        expect(afterRecord.historyPointer, 0);
        expect(
          afterRecord.actionHistory.first.action,
          isA<BracketActionMatchResult>(),
        );
        final firstAction =
            afterRecord.actionHistory.first.action as BracketActionMatchResult;
        expect(firstAction.data.matchId, match.id);
        expect(firstAction.data.displayLabel, contains('won by'));
      },
    );

    test(
      'multiple recordings accumulate in actionHistory sequentially',
      () async {
        var state = await generateBracket();
        final match1 = findFirstScorableMatch(state);
        state = await recordMatchResult(match1, blueScore: 5, redScore: 2);

        expect(state.actionHistory, hasLength(1));
        expect(state.historyPointer, 0);

        final match2 = findFirstScorableMatch(state);
        state = await recordMatchResult(match2, blueScore: 3, redScore: 1);

        expect(state.actionHistory, hasLength(2));
        expect(state.historyPointer, 1);
      },
    );
  });

  group('Undo', () {
    test(
      'undo decrements historyPointer and restores previous snapshot',
      () async {
        var state = await generateBracket();
        final initialResult = state.result;

        final match = findFirstScorableMatch(state);
        state = await recordMatchResult(match);
        final afterRecordResult = state.result;

        // Undo should restore to initial state.
        bracketBloc.add(const BracketEvent.undoRequested());
        await expectLater(
          bracketBloc.stream,
          emitsThrough(isA<BracketLoadSuccess>()),
        );
        state = bracketBloc.state as BracketLoadSuccess;

        expect(state.historyPointer, -1);
        expect(state.result, equals(initialResult));
        // History list should still contain the entry (for redo).
        expect(state.actionHistory, hasLength(1));
        // Result should no longer be the recorded one.
        expect(state.result, isNot(equals(afterRecordResult)));
      },
    );

    test('undo at initial state (historyPointer = -1) is a no-op', () async {
      final state = await generateBracket();
      expect(state.historyPointer, -1);

      bracketBloc.add(const BracketEvent.undoRequested());
      // Give a small window for any state change.
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final afterUndo = bracketBloc.state as BracketLoadSuccess;

      expect(afterUndo.historyPointer, -1);
      expect(afterUndo.result, equals(state.result));
    });

    test('multiple undos walk back through history correctly', () async {
      var state = await generateBracket();
      final initialResult = state.result;

      // Score two matches.
      final match1 = findFirstScorableMatch(state);
      state = await recordMatchResult(match1);
      final afterMatch1Result = state.result;

      final match2 = findFirstScorableMatch(state);
      state = await recordMatchResult(match2);

      // Undo once → should be at match1 state.
      bracketBloc.add(const BracketEvent.undoRequested());
      await expectLater(
        bracketBloc.stream,
        emitsThrough(isA<BracketLoadSuccess>()),
      );
      state = bracketBloc.state as BracketLoadSuccess;
      expect(state.historyPointer, 0);
      expect(state.result, equals(afterMatch1Result));

      // Undo again → should be at initial state.
      bracketBloc.add(const BracketEvent.undoRequested());
      await expectLater(
        bracketBloc.stream,
        emitsThrough(isA<BracketLoadSuccess>()),
      );
      state = bracketBloc.state as BracketLoadSuccess;
      expect(state.historyPointer, -1);
      expect(state.result, equals(initialResult));
    });
  });

  group('Redo', () {
    test(
      'redo increments historyPointer and restores the next snapshot',
      () async {
        var state = await generateBracket();
        final match = findFirstScorableMatch(state);
        state = await recordMatchResult(match);
        final afterRecordResult = state.result;

        // Undo.
        bracketBloc.add(const BracketEvent.undoRequested());
        await expectLater(
          bracketBloc.stream,
          emitsThrough(isA<BracketLoadSuccess>()),
        );

        // Redo.
        bracketBloc.add(const BracketEvent.redoRequested());
        await expectLater(
          bracketBloc.stream,
          emitsThrough(isA<BracketLoadSuccess>()),
        );
        state = bracketBloc.state as BracketLoadSuccess;

        expect(state.historyPointer, 0);
        expect(state.result, equals(afterRecordResult));
      },
    );

    test('redo at latest action is a no-op', () async {
      var state = await generateBracket();
      final match = findFirstScorableMatch(state);
      state = await recordMatchResult(match);

      expect(state.historyPointer, 0);

      bracketBloc.add(const BracketEvent.redoRequested());
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final afterRedo = bracketBloc.state as BracketLoadSuccess;

      expect(afterRedo.historyPointer, 0);
      expect(afterRedo.result, equals(state.result));
    });
  });

  group('Redo truncation', () {
    test(
      'recording a new result after undo truncates the redo stack',
      () async {
        var state = await generateBracket();

        // Score two matches.
        final match1 = findFirstScorableMatch(state);
        state = await recordMatchResult(match1);
        final match2 = findFirstScorableMatch(state);
        state = await recordMatchResult(match2);
        expect(state.actionHistory, hasLength(2));

        // Undo to match1 state.
        bracketBloc.add(const BracketEvent.undoRequested());
        await expectLater(
          bracketBloc.stream,
          emitsThrough(isA<BracketLoadSuccess>()),
        );
        state = bracketBloc.state as BracketLoadSuccess;
        expect(state.historyPointer, 0);

        // Score a different match → should truncate the old match2 entry.
        final newMatch = findFirstScorableMatch(state);
        state = await recordMatchResult(newMatch);

        expect(state.actionHistory, hasLength(2));
        expect(state.historyPointer, 1);
        // The second entry should reference the new match, not match2.
        final secondAction =
            state.actionHistory[1].action as BracketActionMatchResult;
        expect(secondAction.data.matchId, equals(newMatch.id));
      },
    );
  });

  group('Replay', () {
    test(
      'replay steps through all actions sequentially',
      () async {
        var state = await generateBracket();
        final initialResult = state.result;

        // Score two matches.
        final match1 = findFirstScorableMatch(state);
        state = await recordMatchResult(match1);
        final afterMatch1Snapshot = state.actionHistory[0].resultSnapshot;

        final match2 = findFirstScorableMatch(state);
        state = await recordMatchResult(match2);
        final afterMatch2Snapshot = state.actionHistory[1].resultSnapshot;

        // Start replay.
        bracketBloc.add(const BracketEvent.replayRequested());
        await expectLater(
          bracketBloc.stream,
          emitsThrough(isA<BracketLoadSuccess>()),
        );
        state = bracketBloc.state as BracketLoadSuccess;

        // Should be at initial state with replay in progress.
        expect(state.isReplayInProgress, isTrue);
        expect(state.historyPointer, -1);
        expect(state.result, equals(initialResult));

        // Wait for step 1 (800ms + buffer).
        await expectLater(
          bracketBloc.stream,
          emitsThrough(
            isA<BracketLoadSuccess>().having(
              (stateValue) => stateValue.historyPointer,
              'historyPointer',
              0,
            ),
          ),
        );
        state = bracketBloc.state as BracketLoadSuccess;
        expect(state.result, equals(afterMatch1Snapshot));

        // Wait for step 2.
        await expectLater(
          bracketBloc.stream,
          emitsThrough(
            isA<BracketLoadSuccess>().having(
              (stateValue) => stateValue.historyPointer,
              'historyPointer',
              1,
            ),
          ),
        );
        state = bracketBloc.state as BracketLoadSuccess;
        expect(state.result, equals(afterMatch2Snapshot));

        // Wait for replay to finish.
        await expectLater(
          bracketBloc.stream,
          emitsThrough(
            isA<BracketLoadSuccess>().having(
              (stateValue) => stateValue.isReplayInProgress,
              'isReplayInProgress',
              false,
            ),
          ),
        );
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    test(
      'cancel replay stops mid-way and restores pre-replay position',
      () async {
        var state = await generateBracket();

        // Score two matches.
        final match1 = findFirstScorableMatch(state);
        state = await recordMatchResult(match1);
        final match2 = findFirstScorableMatch(state);
        state = await recordMatchResult(match2);

        final preReplayPointer = state.historyPointer; // Should be 1.
        final preReplayResult = state.result;

        // Start replay.
        bracketBloc.add(const BracketEvent.replayRequested());
        await expectLater(
          bracketBloc.stream,
          emitsThrough(
            isA<BracketLoadSuccess>().having(
              (stateValue) => stateValue.isReplayInProgress,
              'isReplayInProgress',
              true,
            ),
          ),
        );

        // Cancel immediately.
        bracketBloc.add(const BracketEvent.replayCancelled());
        await expectLater(
          bracketBloc.stream,
          emitsThrough(
            isA<BracketLoadSuccess>().having(
              (stateValue) => stateValue.isReplayInProgress,
              'isReplayInProgress',
              false,
            ),
          ),
        );
        state = bracketBloc.state as BracketLoadSuccess;

        // Should be restored to pre-replay position.
        expect(state.historyPointer, preReplayPointer);
        expect(state.result, equals(preReplayResult));
      },
    );
  });

  group('History jump', () {
    test(
      'jumping to a specific history index restores that snapshot',
      () async {
        var state = await generateBracket();

        // Score two matches.
        final match1 = findFirstScorableMatch(state);
        state = await recordMatchResult(match1);
        final afterMatch1Result = state.result;

        final match2 = findFirstScorableMatch(state);
        state = await recordMatchResult(match2);

        // Jump to index 0 (after match 1).
        bracketBloc.add(
          const BracketEvent.historyJumpRequested(targetHistoryIndex: 0),
        );
        await expectLater(
          bracketBloc.stream,
          emitsThrough(isA<BracketLoadSuccess>()),
        );
        state = bracketBloc.state as BracketLoadSuccess;

        expect(state.historyPointer, 0);
        expect(state.result, equals(afterMatch1Result));
      },
    );

    test('jumping to -1 restores initial state', () async {
      var state = await generateBracket();
      final initialResult = state.result;

      final match1 = findFirstScorableMatch(state);
      state = await recordMatchResult(match1);

      bracketBloc.add(
        const BracketEvent.historyJumpRequested(targetHistoryIndex: -1),
      );
      await expectLater(
        bracketBloc.stream,
        emitsThrough(isA<BracketLoadSuccess>()),
      );
      state = bracketBloc.state as BracketLoadSuccess;

      expect(state.historyPointer, -1);
      expect(state.result, equals(initialResult));
    });

    test('jumping to an out-of-range index is a no-op', () async {
      var state = await generateBracket();
      final match = findFirstScorableMatch(state);
      state = await recordMatchResult(match);
      final currentPointer = state.historyPointer;

      bracketBloc.add(
        const BracketEvent.historyJumpRequested(targetHistoryIndex: 999),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final afterJump = bracketBloc.state as BracketLoadSuccess;

      expect(afterJump.historyPointer, currentPointer);
    });
  });

  group('Regeneration clears history', () {
    test('regenerating after recording results clears all history', () async {
      var state = await generateBracket();
      final match = findFirstScorableMatch(state);
      state = await recordMatchResult(match);
      expect(state.actionHistory, hasLength(1));

      bracketBloc.add(const BracketEvent.regenerateRequested());
      await expectLater(
        bracketBloc.stream,
        emitsThrough(isA<BracketLoadSuccess>()),
      );
      state = bracketBloc.state as BracketLoadSuccess;

      expect(state.actionHistory, isEmpty);
      expect(state.historyPointer, -1);
      expect(state.isReplayInProgress, isFalse);
      expect(state.initialResult, isNotNull);
    });
  });

  group('Replay-blocking guards', () {
    /// Helper: starts a bracket, records a match, and starts replay.
    /// Returns the state right after replay begins.
    Future<BracketLoadSuccess> startReplay() async {
      var state = await generateBracket();
      final match = findFirstScorableMatch(state);
      state = await recordMatchResult(match);

      bracketBloc.add(const BracketEvent.replayRequested());
      await expectLater(
        bracketBloc.stream,
        emitsThrough(
          isA<BracketLoadSuccess>().having(
            (stateValue) => stateValue.isReplayInProgress,
            'isReplayInProgress',
            true,
          ),
        ),
      );
      return bracketBloc.state as BracketLoadSuccess;
    }

    test('match recording is blocked during replay', () async {
      final replayState = await startReplay();

      // Try to record a match during replay.
      bracketBloc.add(
        BracketEvent.matchResultRecorded(
          matchId:
              (replayState.actionHistory.first.action
                      as BracketActionMatchResult)
                  .data
                  .matchId,
          winnerId: 'p1',
          resultType: MatchResultType.points,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final afterAttempt = bracketBloc.state as BracketLoadSuccess;

      // ActionHistory should NOT have grown because recording is blocked.
      expect(afterAttempt.actionHistory, hasLength(1));
      expect(afterAttempt.isReplayInProgress, isTrue);
    });

    test('undo is blocked during replay', () async {
      await startReplay();

      bracketBloc.add(const BracketEvent.undoRequested());
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final afterAttempt = bracketBloc.state as BracketLoadSuccess;

      // Replay should still be in progress — undo did nothing.
      expect(afterAttempt.isReplayInProgress, isTrue);
    });

    test('redo is blocked during replay', () async {
      await startReplay();

      bracketBloc.add(const BracketEvent.redoRequested());
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final afterAttempt = bracketBloc.state as BracketLoadSuccess;

      expect(afterAttempt.isReplayInProgress, isTrue);
    });

    test('history jump is blocked during replay', () async {
      final replayState = await startReplay();
      final pointerBeforeAttempt = replayState.historyPointer;

      bracketBloc.add(
        const BracketEvent.historyJumpRequested(targetHistoryIndex: 0),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final afterAttempt = bracketBloc.state as BracketLoadSuccess;

      expect(afterAttempt.isReplayInProgress, isTrue);
      expect(afterAttempt.historyPointer, pointerBeforeAttempt);
    });
  });
}

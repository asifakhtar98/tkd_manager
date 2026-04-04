import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_event.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_state.dart';

/// Encapsulates undo, redo, replay, and history-jump logic for the
/// bracket BLoC.
///
/// All handler methods are designed to be called from `on<Event>(...)`
/// registrations in the main [BracketBloc] constructor.
mixin BracketHistoryManagerMixin on Bloc<BracketEvent, BracketState> {
  Timer? _replayTimer;
  int _preReplayHistoryPointer = -1;

  static const _replayStepDuration = Duration(milliseconds: 800);

  // ─────────────────────────────────────────────────────────────
  // Undo / Redo
  // ─────────────────────────────────────────────────────────────

  void handleUndoRequested(
    BracketUndoRequested event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.isReplayInProgress) return;
    if (currentState.historyPointer < 0) return;

    final newPointer = currentState.historyPointer - 1;
    assert(
      currentState.initialResult != null,
      'initialResult must be set before undo can operate',
    );
    final restoredResult = newPointer >= 0
        ? currentState.actionHistory[newPointer].resultSnapshot
        : currentState.initialResult!;
    final restoredParticipants = newPointer >= 0
        ? currentState.actionHistory[newPointer].participantsSnapshot
        : currentState.initialParticipants ?? currentState.participants;

    emit(
      currentState.copyWith(
        result: restoredResult,
        participants: restoredParticipants,
        historyPointer: newPointer,
        errorMessage: null,
        hasUnsavedChanges: true,
      ),
    );
  }

  void handleRedoRequested(
    BracketRedoRequested event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.isReplayInProgress) return;
    if (currentState.historyPointer >= currentState.actionHistory.length - 1) {
      return;
    }

    final newPointer = currentState.historyPointer + 1;
    final entry = currentState.actionHistory[newPointer];

    emit(
      currentState.copyWith(
        result: entry.resultSnapshot,
        participants: entry.participantsSnapshot,
        historyPointer: newPointer,
        errorMessage: null,
        hasUnsavedChanges: true,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Replay
  // ─────────────────────────────────────────────────────────────

  void handleReplayRequested(
    BracketReplayRequested event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.actionHistory.isEmpty) return;
    if (currentState.isReplayInProgress) return;

    _preReplayHistoryPointer = currentState.historyPointer;

    emit(
      currentState.copyWith(
        result: currentState.initialResult!,
        participants:
            currentState.initialParticipants ?? currentState.participants,
        historyPointer: -1,
        isReplayInProgress: true,
        errorMessage: null,
      ),
    );

    _replayTimer = Timer.periodic(_replayStepDuration, (_) {
      add(const BracketEvent.replayStepAdvanced());
    });
  }

  void handleReplayStepAdvanced(
    BracketReplayStepAdvanced event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (!currentState.isReplayInProgress) {
      cancelReplayTimer();
      return;
    }

    final nextPointer = currentState.historyPointer + 1;
    if (nextPointer >= currentState.actionHistory.length) {
      cancelReplayTimer();
      emit(currentState.copyWith(isReplayInProgress: false));
      return;
    }

    final entry = currentState.actionHistory[nextPointer];

    emit(
      currentState.copyWith(
        result: entry.resultSnapshot,
        participants: entry.participantsSnapshot,
        historyPointer: nextPointer,
      ),
    );
  }

  void handleReplayCancelled(
    BracketReplayCancelled event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;

    cancelReplayTimer();

    final restoredPointer = _preReplayHistoryPointer;
    final restoredResult = restoredPointer >= 0
        ? currentState.actionHistory[restoredPointer].resultSnapshot
        : currentState.initialResult!;
    final restoredParticipants = restoredPointer >= 0
        ? currentState.actionHistory[restoredPointer].participantsSnapshot
        : currentState.initialParticipants ?? currentState.participants;

    emit(
      currentState.copyWith(
        result: restoredResult,
        participants: restoredParticipants,
        historyPointer: restoredPointer,
        isReplayInProgress: false,
        errorMessage: null,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // History Jump
  // ─────────────────────────────────────────────────────────────

  void handleHistoryJumpRequested(
    BracketHistoryJumpRequested event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.isReplayInProgress) return;

    final targetIndex = event.targetHistoryIndex;
    if (targetIndex < -1 || targetIndex >= currentState.actionHistory.length) {
      return;
    }

    final restoredResult = targetIndex >= 0
        ? currentState.actionHistory[targetIndex].resultSnapshot
        : currentState.initialResult!;
    final restoredParticipants = targetIndex >= 0
        ? currentState.actionHistory[targetIndex].participantsSnapshot
        : currentState.initialParticipants ?? currentState.participants;

    emit(
      currentState.copyWith(
        result: restoredResult,
        participants: restoredParticipants,
        historyPointer: targetIndex,
        errorMessage: null,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // History Entry Construction
  // ─────────────────────────────────────────────────────────────

  /// Truncates history at the current pointer and appends a new entry.
  ///
  /// Returns `(newHistory, newPointer)` as a record for the caller to emit.
  ({List<BracketHistoryEntry> history, int pointer}) appendHistoryEntry({
    required BracketLoadSuccess currentState,
    required BracketHistoryEntry entry,
  }) {
    final truncatedHistory = currentState.historyPointer >= 0
        ? currentState.actionHistory.sublist(
            0,
            currentState.historyPointer + 1,
          )
        : <BracketHistoryEntry>[];

    final newHistory = [...truncatedHistory, entry];
    final newPointer = newHistory.length - 1;

    return (history: newHistory, pointer: newPointer);
  }

  // ─────────────────────────────────────────────────────────────
  // Timer Management
  // ─────────────────────────────────────────────────────────────

  void cancelReplayTimer() {
    _replayTimer?.cancel();
    _replayTimer = null;
  }
}

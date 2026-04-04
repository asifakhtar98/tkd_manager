import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_event.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_state.dart';
import 'package:tkd_saas/features/core/data/demo_data.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/bracket_snapshot_repository.dart';

/// Encapsulates save, load-from-snapshot, and auto-save logic for the
/// bracket BLoC.
///
/// Requires the consuming class to provide a [bracketSnapshotRepository]
/// and mutable [currentSnapshot] via abstract getters/setters.
mixin BracketPersistenceMixin on Bloc<BracketEvent, BracketState> {
  BracketSnapshotRepository get bracketSnapshotRepository;

  BracketSnapshot? get currentSnapshot;
  set currentSnapshot(BracketSnapshot? value);

  // ─────────────────────────────────────────────────────────────
  // Save
  // ─────────────────────────────────────────────────────────────

  Future<void> handleBracketSaveRequested(
    BracketSaveRequested event,
    Emitter<BracketState> emit,
  ) async {
    if (state is! BracketLoadSuccess) return;
    await executeSave(emit);
  }

  Future<void> executeSave(Emitter<BracketState> emit) async {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentSnapshot == null) {
      log('BracketBloc: Cannot save — snapshot metadata not set.');
      return;
    }

    if (currentSnapshot!.tournamentId == DemoData.demoTournament.id) {
      emit(
        currentState.copyWith(
          isSaving: false,
          hasUnsavedChanges: false,
          lastSaveTimestamp: DateTime.now(),
          saveError: null,
        ),
      );
      return;
    }

    emit(currentState.copyWith(isSaving: true, saveError: null));

    final snapshotToSave = currentSnapshot!.copyWith(
      format: currentState.format,
      participantCount: currentState.participants.length,
      includeThirdPlaceMatch: currentState.includeThirdPlaceMatch,
      participants: currentState.participants,
      result: currentState.result,
      updatedAt: DateTime.now(),
      actionHistory: currentState.actionHistory,
    );

    final saveResult =
        await bracketSnapshotRepository.updateBracketSnapshot(snapshotToSave);

    if (state is! BracketLoadSuccess) return;
    final postAwaitState = state as BracketLoadSuccess;

    saveResult.fold(
      (failure) {
        log('BracketBloc: Save failed — ${failure.message}');
        emit(
          postAwaitState.copyWith(isSaving: false, saveError: failure.message),
        );
      },
      (persistedSnapshot) {
        emit(
          postAwaitState.copyWith(
            isSaving: false,
            hasUnsavedChanges: false,
            lastSaveTimestamp: DateTime.now(),
            saveError: null,
          ),
        );
      },
    );
  }

  Future<void> triggerAutoSave(Emitter<BracketState> emit) async {
    await executeSave(emit);
  }

  // ─────────────────────────────────────────────────────────────
  // Load from Snapshot
  // ─────────────────────────────────────────────────────────────

  void handleLoadFromSnapshotRequested(
    BracketLoadFromSnapshotRequested event,
    Emitter<BracketState> emit,
  ) {
    currentSnapshot = event.snapshot;

    // Allow the main bloc to rebuild its cached generation request
    onSnapshotLoaded(event.snapshot);

    final restoredActionHistory = event.snapshot.actionHistory;
    final hasRestoredHistory = restoredActionHistory.isNotEmpty;

    final restoredResult = hasRestoredHistory
        ? restoredActionHistory.last.resultSnapshot
        : event.snapshot.result;
    final restoredParticipants = hasRestoredHistory
        ? restoredActionHistory.last.participantsSnapshot
        : event.snapshot.participants;
    final restoredHistoryPointer =
        hasRestoredHistory ? restoredActionHistory.length - 1 : -1;

    emit(
      BracketState.loadSuccess(
        result: restoredResult,
        participants: restoredParticipants,
        format: event.snapshot.format,
        includeThirdPlaceMatch: event.snapshot.includeThirdPlaceMatch,
        initialResult: event.snapshot.result,
        initialParticipants: event.snapshot.participants,
        actionHistory: restoredActionHistory,
        historyPointer: restoredHistoryPointer,
        isReplayInProgress: false,
        isSaving: false,
        hasUnsavedChanges: false,
      ),
    );
  }

  /// Hook for the main bloc to update its cached generation request
  /// when a snapshot is loaded.
  void onSnapshotLoaded(BracketSnapshot snapshot);
}

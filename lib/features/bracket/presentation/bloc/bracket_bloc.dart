import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_edit_action.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_match_action.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/match_progression_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/participant_shuffle_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_event.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_state.dart';
import 'package:tkd_saas/features/core/data/demo_data.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/bracket_snapshot_repository.dart';
import 'package:uuid/uuid.dart';

export 'bracket_event.dart';
export 'bracket_state.dart';

@injectable
class BracketBloc extends Bloc<BracketEvent, BracketState> {
  BracketBloc(
    this._singleEliminationGenerator,
    this._doubleEliminationGenerator,
    this._matchProgressionService,
    this._participantShuffleService,
    this._uuid,
    this._bracketSnapshotRepository,
  ) : super(const BracketState.initial()) {
    on<BracketGenerateRequested>(_handleBracketGenerationRequested);
    on<BracketRegenerateRequested>(_handleBracketRegenerationRequested);
    on<BracketMatchResultRecorded>(_handleMatchResultRecorded);
    on<BracketErrorDismissed>(_handleErrorDismissed);
    on<BracketUndoRequested>(_handleUndoRequested);
    on<BracketRedoRequested>(_handleRedoRequested);
    on<BracketReplayRequested>(_handleReplayRequested);
    on<BracketReplayStepAdvanced>(_handleReplayStepAdvanced);
    on<BracketReplayCancelled>(_handleReplayCancelled);
    on<BracketHistoryJumpRequested>(_handleHistoryJumpRequested);
    on<BracketEditModeToggled>(_handleEditModeToggled);
    on<BracketParticipantSlotSwapped>(_handleParticipantSlotSwapped);
    on<BracketParticipantDetailsUpdated>(_handleParticipantDetailsUpdated);
    on<BracketSaveRequested>(_handleBracketSaveRequested);
    on<BracketLoadFromSnapshotRequested>(_handleLoadFromSnapshotRequested);
  }

  final SingleEliminationBracketGeneratorService _singleEliminationGenerator;
  final DoubleEliminationBracketGeneratorService _doubleEliminationGenerator;
  final MatchProgressionService _matchProgressionService;
  final ParticipantShuffleService _participantShuffleService;
  final Uuid _uuid;
  final BracketSnapshotRepository _bracketSnapshotRepository;

  BracketSnapshot? _currentSnapshot;

  /// Caches the last generation request so [BracketRegenerateRequested] can
  /// replay it without the UI re-supplying all parameters.
  BracketGenerateRequested? _cachedGenerationRequest;

  Timer? _replayTimer;

  /// The history pointer position saved before replay started, so we can
  /// restore it if replay is cancelled.
  int _preReplayHistoryPointer = -1;

  static const _replayStepDuration = Duration(milliseconds: 800);

  Future<void> _handleBracketGenerationRequested(
    BracketGenerateRequested event,
    Emitter<BracketState> emit,
  ) async {
    _cachedGenerationRequest = event;
    await _executeBracketGeneration(event, emit);
  }

  Future<void> _handleBracketRegenerationRequested(
    BracketRegenerateRequested event,
    Emitter<BracketState> emit,
  ) async {
    final cachedRequest = _cachedGenerationRequest;
    if (cachedRequest == null) return;
    _cancelReplayTimer();

    final shuffledParticipants = _participantShuffleService
        .shuffleParticipantsForBracketGeneration(
          participants: cachedRequest.participants,
          dojangSeparation: cachedRequest.dojangSeparation,
        );
    final shuffledRequest = cachedRequest.copyWith(
      participants: shuffledParticipants,
    );
    _cachedGenerationRequest = shuffledRequest;
    await _executeBracketGeneration(shuffledRequest, emit);
  }

  Future<void> _handleMatchResultRecorded(
    BracketMatchResultRecorded event,
    Emitter<BracketState> emit,
  ) async {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.isReplayInProgress) return;
    if (currentState.isEditModeEnabled) return;

    try {
      final updatedResult = _applyMatchResult(currentState.result, event);

      final displayLabel = _buildActionDisplayLabel(
        event,
        currentState.result,
        currentState.participants,
      );

      final newAction = BracketMatchAction(
        matchId: event.matchId,
        winnerId: event.winnerId,
        resultType: event.resultType,
        blueScore: event.blueScore,
        redScore: event.redScore,
        recordedAt: DateTime.now(),
        displayLabel: displayLabel,
      );

      final newEntry = BracketHistoryEntry(
        action: BracketAction.matchResult(newAction),
        resultSnapshot: updatedResult,
        participantsSnapshot: currentState.participants,
      );

      final truncatedHistory = currentState.historyPointer >= 0
          ? currentState.actionHistory.sublist(
              0,
              currentState.historyPointer + 1,
            )
          : <BracketHistoryEntry>[];

      final newHistory = [...truncatedHistory, newEntry];
      final newPointer = newHistory.length - 1;

      emit(
        currentState.copyWith(
          result: updatedResult,
          errorMessage: null,
          actionHistory: newHistory,
          historyPointer: newPointer,
          hasUnsavedChanges: true,
        ),
      );

      await _triggerAutoSave(emit);
    } on ArgumentError catch (e) {
      emit(currentState.copyWith(errorMessage: e.message.toString()));
    } catch (e) {
      emit(currentState.copyWith(errorMessage: e.toString()));
    }
  }

  void _handleUndoRequested(
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

  void _handleRedoRequested(
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

  void _handleReplayRequested(
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
        isEditModeEnabled: false,
        errorMessage: null,
      ),
    );

    _replayTimer = Timer.periodic(_replayStepDuration, (_) {
      add(const BracketEvent.replayStepAdvanced());
    });
  }

  void _handleReplayStepAdvanced(
    BracketReplayStepAdvanced event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (!currentState.isReplayInProgress) {
      _cancelReplayTimer();
      return;
    }

    final nextPointer = currentState.historyPointer + 1;
    if (nextPointer >= currentState.actionHistory.length) {
      _cancelReplayTimer();
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

  void _handleReplayCancelled(
    BracketReplayCancelled event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;

    _cancelReplayTimer();

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

  void _handleHistoryJumpRequested(
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

  void _handleEditModeToggled(
    BracketEditModeToggled event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.isReplayInProgress) return;

    final enabling = !currentState.isEditModeEnabled;

    if (enabling && _hasCompletedMatches(currentState)) {
      emit(
        currentState.copyWith(
          errorMessage:
              'Reset all match results before enabling edit mode. '
              'Use "Regenerate" to start fresh.',
        ),
      );
      return;
    }

    emit(currentState.copyWith(isEditModeEnabled: enabling));
  }

  Future<void> _handleParticipantSlotSwapped(
    BracketParticipantSlotSwapped event,
    Emitter<BracketState> emit,
  ) async {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (!currentState.isEditModeEnabled) return;
    if (currentState.isReplayInProgress) return;

    if (event.sourceMatchId == event.targetMatchId &&
        event.sourceSlotPosition == event.targetSlotPosition) {
      return;
    }

    final sourceParticipantIdForGuard = _getParticipantIdForSlot(
      currentState.result,
      event.sourceMatchId,
      event.sourceSlotPosition,
    );
    final targetParticipantIdForGuard = _getParticipantIdForSlot(
      currentState.result,
      event.targetMatchId,
      event.targetSlotPosition,
    );
    if (sourceParticipantIdForGuard != null &&
        sourceParticipantIdForGuard == targetParticipantIdForGuard) {
      return;
    }

    if (_hasCompletedMatches(currentState)) {
      emit(
        currentState.copyWith(
          errorMessage:
              'Cannot swap participants after matches have been scored.',
        ),
      );
      return;
    }

    try {
      final updatedResult = _applyParticipantSlotSwap(
        currentState.result,
        sourceMatchId: event.sourceMatchId,
        sourceSlotPosition: event.sourceSlotPosition,
        targetMatchId: event.targetMatchId,
        targetSlotPosition: event.targetSlotPosition,
      );

      final sourceParticipantId = _getParticipantIdForSlot(
        currentState.result,
        event.sourceMatchId,
        event.sourceSlotPosition,
      );
      final targetParticipantId = _getParticipantIdForSlot(
        currentState.result,
        event.targetMatchId,
        event.targetSlotPosition,
      );
      final sourceName = _findParticipantName(
        sourceParticipantId,
        currentState.participants,
      );
      final targetName = _findParticipantName(
        targetParticipantId,
        currentState.participants,
      );

      final editAction = BracketEditAction.participantSlotSwapped(
        sourceMatchId: event.sourceMatchId,
        sourceSlotPosition: event.sourceSlotPosition,
        targetMatchId: event.targetMatchId,
        targetSlotPosition: event.targetSlotPosition,
        displayLabel: 'Swapped $sourceName ↔ $targetName',
        recordedAt: DateTime.now(),
      );

      final newEntry = BracketHistoryEntry(
        action: BracketAction.editAction(editAction),
        resultSnapshot: updatedResult,
        participantsSnapshot: currentState.participants,
      );

      final truncatedHistory = currentState.historyPointer >= 0
          ? currentState.actionHistory.sublist(
              0,
              currentState.historyPointer + 1,
            )
          : <BracketHistoryEntry>[];

      final newHistory = [...truncatedHistory, newEntry];
      final newPointer = newHistory.length - 1;

      emit(
        currentState.copyWith(
          result: updatedResult,
          errorMessage: null,
          actionHistory: newHistory,
          historyPointer: newPointer,
          hasUnsavedChanges: true,
        ),
      );

      await _triggerAutoSave(emit);
    } on ArgumentError catch (e) {
      emit(currentState.copyWith(errorMessage: e.message.toString()));
    } catch (e) {
      emit(currentState.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _handleParticipantDetailsUpdated(
    BracketParticipantDetailsUpdated event,
    Emitter<BracketState> emit,
  ) async {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (!currentState.isEditModeEnabled) return; // Bug 2: guard edit-mode.
    if (currentState.isReplayInProgress) return;

    final participantIndex = currentState.participants.indexWhere(
      (participant) => participant.id == event.participantId,
    );
    if (participantIndex == -1) {
      emit(
        currentState.copyWith(
          errorMessage: 'Participant not found: ${event.participantId}',
        ),
      );
      return;
    }

    final oldParticipant = currentState.participants[participantIndex];
    // Bug 3: Normalize empty registrationId to null instead of storing "".
    final resolvedRegistrationId = event.updatedRegistrationId == null
        ? oldParticipant.registrationId
        : (event.updatedRegistrationId!.isEmpty
              ? null
              : event.updatedRegistrationId);

    final updatedParticipant = oldParticipant.copyWith(
      fullName: event.updatedFullName,
      registrationId: resolvedRegistrationId,
    );

    final updatedParticipants = List<ParticipantEntity>.from(
      currentState.participants,
    );
    updatedParticipants[participantIndex] = updatedParticipant;

    final editAction = BracketEditAction.participantDetailsUpdated(
      participantId: event.participantId,
      updatedFullName: event.updatedFullName,
      updatedRegistrationId: event.updatedRegistrationId,
      displayLabel:
          'Edited: ${oldParticipant.fullName} → ${event.updatedFullName}',
      recordedAt: DateTime.now(),
    );

    final newEntry = BracketHistoryEntry(
      action: BracketAction.editAction(editAction),
      resultSnapshot: currentState.result,
      participantsSnapshot: updatedParticipants,
    );

    final truncatedHistory = currentState.historyPointer >= 0
        ? currentState.actionHistory.sublist(0, currentState.historyPointer + 1)
        : <BracketHistoryEntry>[];

    final newHistory = [...truncatedHistory, newEntry];
    final newPointer = newHistory.length - 1;

    emit(
      currentState.copyWith(
        participants: updatedParticipants,
        errorMessage: null,
        actionHistory: newHistory,
        historyPointer: newPointer,
        hasUnsavedChanges: true,
      ),
    );

    // Auto-save after participant detail edits.
    await _triggerAutoSave(emit);
  }

  void _handleErrorDismissed(
    BracketErrorDismissed event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    emit(currentState.copyWith(errorMessage: null));
  }

  Future<void> _executeBracketGeneration(
    BracketGenerateRequested req,
    Emitter<BracketState> emit,
  ) async {
    emit(const BracketState.generating());
    try {
      final participantIds = req.participants
          .map((participant) => participant.id)
          .toList();

      late final BracketResult bracketResult;

      switch (req.bracketFormat) {
        case BracketFormat.doubleElimination:
          final winnersBracketId = _uuid.v4();
          final losersBracketId = _uuid.v4();
          final doubleEliminationResult = _doubleEliminationGenerator.generate(
            genderId: _uuid.v4(),
            participantIds: participantIds,
            winnersBracketId: winnersBracketId,
            losersBracketId: losersBracketId,
          );
          bracketResult = BracketResult.doubleElimination(
            doubleEliminationResult,
          );
        case BracketFormat.singleElimination:
          final singleEliminationResult = _singleEliminationGenerator.generate(
            genderId: _uuid.v4(),
            participantIds: participantIds,
            bracketId: _uuid.v4(),
            includeThirdPlaceMatch: req.includeThirdPlaceMatch,
          );
          bracketResult = BracketResult.singleElimination(
            singleEliminationResult,
          );
      }

      emit(
        BracketState.loadSuccess(
          result: bracketResult,
          participants: req.participants,
          format: req.bracketFormat,
          includeThirdPlaceMatch: req.includeThirdPlaceMatch,
          // Store initial snapshots for undo/replay baseline.
          initialResult: bracketResult,
          initialParticipants: req.participants,
          // Clear history on fresh or re-generation.
          actionHistory: [],
          historyPointer: -1,
          isReplayInProgress: false,
          isEditModeEnabled: false,
        ),
      );

      // Auto-save after regeneration so the new draw is immediately persisted.
      await _triggerAutoSave(emit);
    } on ArgumentError catch (e) {
      emit(BracketState.failure(e.message.toString()));
    } catch (e) {
      emit(BracketState.failure(e.toString()));
    }
  }

  void _handleLoadFromSnapshotRequested(
    BracketLoadFromSnapshotRequested event,
    Emitter<BracketState> emit,
  ) {
    // Cache snapshot metadata for subsequent save operations.
    _currentSnapshot = event.snapshot;

    // Reconstruct the cached generation request from the snapshot so that
    // BracketRegenerateRequested can replay it without the UI re-supplying
    // all parameters. Without this, regenerate silently no-ops.
    _cachedGenerationRequest = BracketGenerateRequested(
      participants: event.snapshot.participants,
      bracketFormat: event.snapshot.format,
      dojangSeparation: event.snapshot.dojangSeparation,
      includeThirdPlaceMatch: event.snapshot.includeThirdPlaceMatch,
    );

    final restoredActionHistory = event.snapshot.actionHistory;
    final hasRestoredHistory = restoredActionHistory.isNotEmpty;

    // When restoring from a snapshot that has persisted action history,
    // the "current" result/participants are the snapshot at the latest
    // history pointer (i.e. the last entry). The initial result is always
    // the snapshot's result field (the generation baseline).
    final restoredResult = hasRestoredHistory
        ? restoredActionHistory.last.resultSnapshot
        : event.snapshot.result;
    final restoredParticipants = hasRestoredHistory
        ? restoredActionHistory.last.participantsSnapshot
        : event.snapshot.participants;
    final restoredHistoryPointer = hasRestoredHistory
        ? restoredActionHistory.length - 1
        : -1;

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
        isEditModeEnabled: false,
        isSaving: false,
        hasUnsavedChanges: false,
      ),
    );
  }

  /// Applies a match result to the given [BracketResult] and returns a new one.
  BracketResult _applyMatchResult(
    BracketResult currentResult,
    BracketMatchResultRecorded event,
  ) {
    return currentResult.map(
      singleElimination: (singleEliminationResult) {
        final updated = _matchProgressionService.recordResult(
          matches: singleEliminationResult.data.matches,
          matchId: event.matchId,
          winnerId: event.winnerId,
          resultType: event.resultType,
          blueScore: event.blueScore,
          redScore: event.redScore,
        );
        return BracketResult.singleElimination(
          singleEliminationResult.data.copyWith(matches: updated),
        );
      },
      doubleElimination: (doubleEliminationResult) {
        final updated = _matchProgressionService.recordResult(
          matches: doubleEliminationResult.data.allMatches,
          matchId: event.matchId,
          winnerId: event.winnerId,
          resultType: event.resultType,
          blueScore: event.blueScore,
          redScore: event.redScore,
        );
        return BracketResult.doubleElimination(
          doubleEliminationResult.data.copyWith(allMatches: updated),
        );
      },
    );
  }

  /// Swaps two participant slots in the bracket match list and returns a new
  /// [BracketResult] with the updated match entities.
  BracketResult _applyParticipantSlotSwap(
    BracketResult currentResult, {
    required String sourceMatchId,
    required String sourceSlotPosition,
    required String targetMatchId,
    required String targetSlotPosition,
  }) {
    final allMatches = switch (currentResult) {
      SingleEliminationResult(:final data) => data.matches,
      DoubleEliminationResult(:final data) => data.allMatches,
    };

    final sourceMatch = allMatches.firstWhere(
      (matchEntity) => matchEntity.id == sourceMatchId,
      orElse: () =>
          throw ArgumentError('Source match not found: $sourceMatchId'),
    );
    final targetMatch = allMatches.firstWhere(
      (matchEntity) => matchEntity.id == targetMatchId,
      orElse: () =>
          throw ArgumentError('Target match not found: $targetMatchId'),
    );

    final sourceParticipantId = sourceSlotPosition == 'blue'
        ? sourceMatch.participantBlueId
        : sourceMatch.participantRedId;
    final targetParticipantId = targetSlotPosition == 'blue'
        ? targetMatch.participantBlueId
        : targetMatch.participantRedId;

    // Apply the swap to the match list.
    final updatedMatches = allMatches.map((matchEntity) {
      if (matchEntity.id == sourceMatchId && matchEntity.id == targetMatchId) {
        // Bug 5: Same match — unconditional blue ↔ red swap.
        return matchEntity.copyWith(
          participantBlueId: matchEntity.participantRedId,
          participantRedId: matchEntity.participantBlueId,
        );
      } else if (matchEntity.id == sourceMatchId) {
        return sourceSlotPosition == 'blue'
            ? matchEntity.copyWith(participantBlueId: targetParticipantId)
            : matchEntity.copyWith(participantRedId: targetParticipantId);
      } else if (matchEntity.id == targetMatchId) {
        return targetSlotPosition == 'blue'
            ? matchEntity.copyWith(participantBlueId: sourceParticipantId)
            : matchEntity.copyWith(participantRedId: sourceParticipantId);
      }
      return matchEntity;
    }).toList();

    return switch (currentResult) {
      SingleEliminationResult(:final data) => BracketResult.singleElimination(
        data.copyWith(matches: updatedMatches),
      ),
      DoubleEliminationResult(:final data) => BracketResult.doubleElimination(
        data.copyWith(allMatches: updatedMatches),
      ),
    };
  }

  /// Returns the participant ID in the given slot of the given match.
  String? _getParticipantIdForSlot(
    BracketResult result,
    String matchId,
    String slotPosition,
  ) {
    final allMatches = switch (result) {
      SingleEliminationResult(:final data) => data.matches,
      DoubleEliminationResult(:final data) => data.allMatches,
    };
    final match = allMatches
        .where((matchEntity) => matchEntity.id == matchId)
        .firstOrNull;
    if (match == null) return null;
    return slotPosition == 'blue'
        ? match.participantBlueId
        : match.participantRedId;
  }

  /// Returns a human-readable participant name, or 'TBD' if not found.
  String _findParticipantName(
    String? participantId,
    List<ParticipantEntity> participants,
  ) {
    if (participantId == null) return 'TBD';
    return participants
            .where((participant) => participant.id == participantId)
            .firstOrNull
            ?.fullName ??
        'Unknown';
  }

  /// Checks whether any match in the current bracket has been completed.
  bool _hasCompletedMatches(BracketLoadSuccess currentState) {
    final allMatches = switch (currentState.result) {
      SingleEliminationResult(:final data) => data.matches,
      DoubleEliminationResult(:final data) => data.allMatches,
    };
    return allMatches.any(
      (matchEntity) =>
          matchEntity.isCompleted &&
          matchEntity.resultType != MatchResultType.bye,
    );
  }

  /// Builds a human-readable label like "R1-M2: John Doe won by Points (3-1)".
  String _buildActionDisplayLabel(
    BracketMatchResultRecorded event,
    BracketResult currentResult,
    List<ParticipantEntity> participants,
  ) {
    final allMatches = switch (currentResult) {
      SingleEliminationResult(:final data) => data.matches,
      DoubleEliminationResult(:final data) => data.allMatches,
    };

    final match = allMatches
        .where((matchEntity) => matchEntity.id == event.matchId)
        .firstOrNull;

    final roundLabel = match != null
        ? 'R${match.roundNumber}-M${match.matchNumberInRound}'
        : event.matchId.length > 8
        ? event.matchId.substring(0, 8)
        : event.matchId;

    final winnerName =
        participants
            .where((participant) => participant.id == event.winnerId)
            .firstOrNull
            ?.fullName ??
        'Unknown';

    final resultLabel = event.resultType.displayName;

    final scoreLabel = (event.blueScore != null && event.redScore != null)
        ? ' (${event.blueScore}-${event.redScore})'
        : '';

    return '$roundLabel: $winnerName won by $resultLabel$scoreLabel';
  }

  void _cancelReplayTimer() {
    _replayTimer?.cancel();
    _replayTimer = null;
  }

  @override
  Future<void> close() {
    _cancelReplayTimer();
    return super.close();
  }

  Future<void> _handleBracketSaveRequested(
    BracketSaveRequested event,
    Emitter<BracketState> emit,
  ) async {
    if (state is! BracketLoadSuccess) return;
    await _executeSave(emit);
  }

  /// Performs the actual snapshot update to the database.
  ///
  /// Builds a [BracketSnapshot] from the current BLoC state, including
  /// persisted [actionHistory], then delegates to [BracketSnapshotRepository].
  /// For demo tournament snapshots, saves are kept in-memory only.
  Future<void> _executeSave(Emitter<BracketState> emit) async {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (_currentSnapshot == null) {
      log('BracketBloc: Cannot save — snapshot metadata not set.');
      return;
    }

    // Skip DB persistence for demo tournament data.
    if (_currentSnapshot!.tournamentId == DemoData.demoTournament.id) {
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

    final snapshotToSave = _currentSnapshot!.copyWith(
      format: currentState.format,
      participantCount: currentState.participants.length,
      includeThirdPlaceMatch: currentState.includeThirdPlaceMatch,
      participants: currentState.participants,
      result: currentState.result,
      updatedAt: DateTime.now(),
      actionHistory: currentState.actionHistory,
    );

    final saveResult = await _bracketSnapshotRepository.updateBracketSnapshot(
      snapshotToSave,
    );

    // Re-check state after async gap — the bloc might have been closed or
    // state could have transitioned away from BracketLoadSuccess.
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

  /// Triggers an auto-save for the current bracket state.
  ///
  /// Called after major mutation events (match results, slot swaps,
  /// participant edits). Fire-and-forget — does not block the UI.
  Future<void> _triggerAutoSave(Emitter<BracketState> emit) async {
    await _executeSave(emit);
  }
}

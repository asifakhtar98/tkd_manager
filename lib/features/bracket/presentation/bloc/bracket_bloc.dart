import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_match_action.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';

import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/match_progression_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/participant_shuffle_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_event.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_history_manager_mixin.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_persistence_mixin.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_state.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/bracket_snapshot_repository.dart';
import 'package:uuid/uuid.dart';

export 'bracket_event.dart';
export 'bracket_state.dart';

@injectable
class BracketBloc extends Bloc<BracketEvent, BracketState>
    with BracketHistoryManagerMixin, BracketPersistenceMixin {
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
    on<BracketUndoRequested>(handleUndoRequested);
    on<BracketRedoRequested>(handleRedoRequested);
    on<BracketReplayRequested>(handleReplayRequested);
    on<BracketReplayStepAdvanced>(handleReplayStepAdvanced);
    on<BracketReplayCancelled>(handleReplayCancelled);
    on<BracketHistoryJumpRequested>(handleHistoryJumpRequested);
    on<BracketSaveRequested>(handleBracketSaveRequested);
    on<BracketLoadFromSnapshotRequested>(handleLoadFromSnapshotRequested);
  }

  final SingleEliminationBracketGeneratorService _singleEliminationGenerator;
  final DoubleEliminationBracketGeneratorService _doubleEliminationGenerator;
  final MatchProgressionService _matchProgressionService;
  final ParticipantShuffleService _participantShuffleService;
  final Uuid _uuid;
  final BracketSnapshotRepository _bracketSnapshotRepository;

  BracketGenerateRequested? _cachedGenerationRequest;

  // ─────────────────────────────────────────────────────────────
  // BracketPersistenceMixin abstract members
  // ─────────────────────────────────────────────────────────────

  @override
  BracketSnapshotRepository get bracketSnapshotRepository =>
      _bracketSnapshotRepository;

  BracketSnapshot? _currentSnapshot;

  @override
  BracketSnapshot? get currentSnapshot => _currentSnapshot;

  @override
  set currentSnapshot(BracketSnapshot? value) => _currentSnapshot = value;

  @override
  void onSnapshotLoaded(BracketSnapshot snapshot) {
    _cachedGenerationRequest = BracketGenerateRequested(
      participants: snapshot.participants,
      bracketFormat: snapshot.format,
      dojangSeparation: snapshot.dojangSeparation,
      includeThirdPlaceMatch: snapshot.includeThirdPlaceMatch,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Generation
  // ─────────────────────────────────────────────────────────────

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
    cancelReplayTimer();

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
        case BracketFormat.singleElimination:
          final seResult = _singleEliminationGenerator.generate(
            genderId: _uuid.v4(),
            participantIds: participantIds,
            bracketId: _uuid.v4(),
            includeThirdPlaceMatch: req.includeThirdPlaceMatch,
          );
          bracketResult = BracketResult.singleElimination(seResult);

        case BracketFormat.doubleElimination:
          final deResult = _doubleEliminationGenerator.generate(
            genderId: _uuid.v4(),
            participantIds: participantIds,
            winnersBracketId: _uuid.v4(),
            losersBracketId: _uuid.v4(),
          );
          bracketResult = BracketResult.doubleElimination(deResult);
      }

      emit(
        BracketState.loadSuccess(
          result: bracketResult,
          participants: req.participants,
          format: req.bracketFormat,
          includeThirdPlaceMatch: req.includeThirdPlaceMatch,
          initialResult: bracketResult,
          initialParticipants: req.participants,
          actionHistory: [],
          historyPointer: -1,
          isReplayInProgress: false,
        ),
      );

      await triggerAutoSave(emit);
    } on ArgumentError catch (e) {
      emit(BracketState.failure(e.message.toString()));
    } catch (e) {
      emit(BracketState.failure(e.toString()));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Match Result Recording
  // ─────────────────────────────────────────────────────────────

  Future<void> _handleMatchResultRecorded(
    BracketMatchResultRecorded event,
    Emitter<BracketState> emit,
  ) async {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.isReplayInProgress) return;

    try {
      final updatedResult = _applyMatchResult(currentState.result, event);

      final displayLabel = _buildActionDisplayLabel(
        event,
        currentState.result,
        currentState.participants,
      );

      final matchAction = BracketMatchAction(
        matchId: event.matchId,
        winnerId: event.winnerId,
        resultType: event.resultType,
        blueScore: event.blueScore,
        redScore: event.redScore,
        recordedAt: DateTime.now(),
        displayLabel: displayLabel,
      );

      final newEntry = BracketHistoryEntry(
        action: BracketAction.matchResult(matchAction),
        resultSnapshot: updatedResult,
        participantsSnapshot: currentState.participants,
      );

      final historyUpdate = appendHistoryEntry(
        currentState: currentState,
        entry: newEntry,
      );

      emit(
        currentState.copyWith(
          result: updatedResult,
          errorMessage: null,
          actionHistory: historyUpdate.history,
          historyPointer: historyUpdate.pointer,
          hasUnsavedChanges: true,
        ),
      );

      await triggerAutoSave(emit);
    } on ArgumentError catch (e) {
      emit(currentState.copyWith(errorMessage: e.message.toString()));
    } catch (e) {
      emit(currentState.copyWith(errorMessage: e.toString()));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Error Dismissal
  // ─────────────────────────────────────────────────────────────

  void _handleErrorDismissed(
    BracketErrorDismissed event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    emit(currentState.copyWith(errorMessage: null));
  }

  // ─────────────────────────────────────────────────────────────
  // Private helpers
  // ─────────────────────────────────────────────────────────────

  BracketResult _applyMatchResult(
    BracketResult currentResult,
    BracketMatchResultRecorded event,
  ) {
    final updatedMatches = _matchProgressionService.recordResult(
      matches: currentResult.allMatches,
      matchId: event.matchId,
      winnerId: event.winnerId,
      resultType: event.resultType,
      blueScore: event.blueScore,
      redScore: event.redScore,
    );
    return currentResult.replaceMatches(updatedMatches);
  }

  String _buildActionDisplayLabel(
    BracketMatchResultRecorded event,
    BracketResult currentResult,
    List<ParticipantEntity> participants,
  ) {
    final match = currentResult.allMatches
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

  @override
  Future<void> close() {
    cancelReplayTimer();
    return super.close();
  }
}

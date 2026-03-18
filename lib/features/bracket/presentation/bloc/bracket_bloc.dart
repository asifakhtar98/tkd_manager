import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_match_action.dart';
import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/match_progression_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_event.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_state.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:uuid/uuid.dart';

export 'bracket_event.dart';
export 'bracket_state.dart';

@injectable
class BracketBloc extends Bloc<BracketEvent, BracketState> {
  BracketBloc(
    this._singleEliminationGenerator,
    this._doubleEliminationGenerator,
    this._matchProgressionService,
    this._uuid,
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
  }

  final SingleEliminationBracketGeneratorService _singleEliminationGenerator;
  final DoubleEliminationBracketGeneratorService _doubleEliminationGenerator;
  final MatchProgressionService _matchProgressionService;
  final Uuid _uuid;

  /// Caches the last generation request so [BracketRegenerateRequested] can
  /// replay it without the UI re-supplying all parameters.
  BracketGenerateRequested? _cachedGenerationRequest;

  /// Timer driving animated replay playback.
  Timer? _replayTimer;

  /// The history pointer position saved before replay started, so we can
  /// restore it if replay is cancelled.
  int _preReplayHistoryPointer = -1;

  /// Interval between replay steps.
  static const _replayStepDuration = Duration(milliseconds: 800);

  // ── Generation ──────────────────────────────────────────────────────────────

  void _handleBracketGenerationRequested(
    BracketGenerateRequested event,
    Emitter<BracketState> emit,
  ) {
    _cachedGenerationRequest = event;
    _executeBracketGeneration(event, emit);
  }

  void _handleBracketRegenerationRequested(
    BracketRegenerateRequested event,
    Emitter<BracketState> emit,
  ) {
    final cachedRequest = _cachedGenerationRequest;
    if (cachedRequest == null) return;
    _cancelReplayTimer();
    _executeBracketGeneration(cachedRequest, emit);
  }

  // ── Match result recording (with history push) ─────────────────────────────

  void _handleMatchResultRecorded(
    BracketMatchResultRecorded event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.isReplayInProgress) return; // Block during replay.

    try {
      final updatedResult = _applyMatchResult(currentState.result, event);

      // Build human-readable display label.
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
        action: newAction,
        resultSnapshot: updatedResult,
      );

      // Truncate any redo entries beyond the current pointer, then push.
      final truncatedHistory = currentState.historyPointer >= 0
          ? currentState.actionHistory
                .sublist(0, currentState.historyPointer + 1)
          : <BracketHistoryEntry>[];

      final newHistory = [...truncatedHistory, newEntry];
      final newPointer = newHistory.length - 1;

      emit(currentState.copyWith(
        result: updatedResult,
        errorMessage: null,
        actionHistory: newHistory,
        historyPointer: newPointer,
      ));
    } on ArgumentError catch (e) {
      emit(currentState.copyWith(errorMessage: e.message.toString()));
    } catch (e) {
      emit(currentState.copyWith(errorMessage: e.toString()));
    }
  }

  // ── Undo ───────────────────────────────────────────────────────────────────

  void _handleUndoRequested(
    BracketUndoRequested event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.isReplayInProgress) return;
    if (currentState.historyPointer < 0) return; // Already at initial state.

    final newPointer = currentState.historyPointer - 1;
    assert(
      currentState.initialResult != null,
      'initialResult must be set before undo can operate',
    );
    final restoredResult = newPointer >= 0
        ? currentState.actionHistory[newPointer].resultSnapshot
        : currentState.initialResult!;

    emit(currentState.copyWith(
      result: restoredResult,
      historyPointer: newPointer,
      errorMessage: null,
    ));
  }

  // ── Redo ───────────────────────────────────────────────────────────────────

  void _handleRedoRequested(
    BracketRedoRequested event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.isReplayInProgress) return;
    if (currentState.historyPointer >= currentState.actionHistory.length - 1) {
      return; // Already at latest action.
    }

    final newPointer = currentState.historyPointer + 1;
    final restoredResult =
        currentState.actionHistory[newPointer].resultSnapshot;

    emit(currentState.copyWith(
      result: restoredResult,
      historyPointer: newPointer,
      errorMessage: null,
    ));
  }

  // ── Replay ─────────────────────────────────────────────────────────────────

  void _handleReplayRequested(
    BracketReplayRequested event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.actionHistory.isEmpty) return;
    if (currentState.isReplayInProgress) return;

    _preReplayHistoryPointer = currentState.historyPointer;

    // Reset to initial state and mark replay in progress.
    emit(currentState.copyWith(
      result: currentState.initialResult!,
      historyPointer: -1,
      isReplayInProgress: true,
      errorMessage: null,
    ));

    // Start stepping through the history.
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
      // Replay finished — stop at the last action.
      _cancelReplayTimer();
      emit(currentState.copyWith(isReplayInProgress: false));
      return;
    }

    final nextResult =
        currentState.actionHistory[nextPointer].resultSnapshot;

    emit(currentState.copyWith(
      result: nextResult,
      historyPointer: nextPointer,
    ));
  }

  void _handleReplayCancelled(
    BracketReplayCancelled event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;

    _cancelReplayTimer();

    // Restore to the position before replay started.
    final restoredPointer = _preReplayHistoryPointer;
    final restoredResult = restoredPointer >= 0
        ? currentState.actionHistory[restoredPointer].resultSnapshot
        : currentState.initialResult!;

    emit(currentState.copyWith(
      result: restoredResult,
      historyPointer: restoredPointer,
      isReplayInProgress: false,
      errorMessage: null,
    ));
  }

  // ── History jump ───────────────────────────────────────────────────────────

  void _handleHistoryJumpRequested(
    BracketHistoryJumpRequested event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    if (currentState.isReplayInProgress) return;

    final targetIndex = event.targetHistoryIndex;
    if (targetIndex < -1 ||
        targetIndex >= currentState.actionHistory.length) {
      return;
    }

    final restoredResult = targetIndex >= 0
        ? currentState.actionHistory[targetIndex].resultSnapshot
        : currentState.initialResult!;

    emit(currentState.copyWith(
      result: restoredResult,
      historyPointer: targetIndex,
      errorMessage: null,
    ));
  }

  // ── Error dismiss ──────────────────────────────────────────────────────────

  void _handleErrorDismissed(
    BracketErrorDismissed event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    emit(currentState.copyWith(errorMessage: null));
  }

  // ── Generation execution ───────────────────────────────────────────────────

  void _executeBracketGeneration(
    BracketGenerateRequested req,
    Emitter<BracketState> emit,
  ) {
    emit(const BracketState.generating());
    try {
      final participantIds =
          req.participants.map((participant) => participant.id).toList();

      late final BracketResult bracketResult;

      switch (req.bracketFormat) {
        case BracketFormat.doubleElimination:
          final winnersBracketId = _uuid.v4();
          final losersBracketId = _uuid.v4();
          final doubleEliminationResult = _doubleEliminationGenerator.generate(
            divisionId: _uuid.v4(),
            participantIds: participantIds,
            winnersBracketId: winnersBracketId,
            losersBracketId: losersBracketId,
          );
          bracketResult = BracketResult.doubleElimination(
            doubleEliminationResult,
          );
        case BracketFormat.singleElimination:
          final singleEliminationResult = _singleEliminationGenerator.generate(
            divisionId: _uuid.v4(),
            participantIds: participantIds,
            bracketId: _uuid.v4(),
            includeThirdPlaceMatch: req.includeThirdPlaceMatch,
          );
          bracketResult = BracketResult.singleElimination(
            singleEliminationResult,
          );
      }

      emit(BracketState.loadSuccess(
        result: bracketResult,
        participants: req.participants,
        format: req.bracketFormat,
        includeThirdPlaceMatch: req.includeThirdPlaceMatch,
        // Store initial result for undo/replay baseline.
        initialResult: bracketResult,
        // Clear history on fresh or re-generation.
        actionHistory: [],
        historyPointer: -1,
        isReplayInProgress: false,
      ));
    } on ArgumentError catch (e) {
      emit(BracketState.failure(e.message.toString()));
    } catch (e) {
      emit(BracketState.failure(e.toString()));
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

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

    final winnerName = participants
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
}

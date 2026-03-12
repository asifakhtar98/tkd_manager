import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/match_progression_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_event.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_state.dart';
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
  }

  final SingleEliminationBracketGeneratorService _singleEliminationGenerator;
  final DoubleEliminationBracketGeneratorService _doubleEliminationGenerator;
  final MatchProgressionService _matchProgressionService;
  final Uuid _uuid;

  /// Caches the last generation request so [BracketRegenerateRequested] can
  /// replay it without the UI re-supplying all parameters.
  BracketGenerateRequested? _cachedGenerationRequest;

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
    _executeBracketGeneration(cachedRequest, emit);
  }

  void _handleMatchResultRecorded(
    BracketMatchResultRecorded event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;

    try {
      final updatedResult = currentState.result.map(
        singleElimination: (se) {
          final updated = _matchProgressionService.recordResult(
            matches: se.data.matches,
            matchId: event.matchId,
            winnerId: event.winnerId,
            resultType: event.resultType,
            blueScore: event.blueScore,
            redScore: event.redScore,
          );
          return BracketResult.singleElimination(
            se.data.copyWith(matches: updated),
          );
        },
        doubleElimination: (de) {
          final updated = _matchProgressionService.recordResult(
            matches: de.data.allMatches,
            matchId: event.matchId,
            winnerId: event.winnerId,
            resultType: event.resultType,
            blueScore: event.blueScore,
            redScore: event.redScore,
          );
          return BracketResult.doubleElimination(
            de.data.copyWith(allMatches: updated),
          );
        },
      );

      emit(currentState.copyWith(result: updatedResult, errorMessage: null));
    } on ArgumentError catch (e) {
      emit(currentState.copyWith(errorMessage: e.message.toString()));
    } catch (e) {
      emit(currentState.copyWith(errorMessage: e.toString()));
    }
  }

  void _handleErrorDismissed(
    BracketErrorDismissed event,
    Emitter<BracketState> emit,
  ) {
    final currentState = state;
    if (currentState is! BracketLoadSuccess) return;
    emit(currentState.copyWith(errorMessage: null));
  }

  void _executeBracketGeneration(BracketGenerateRequested req, Emitter<BracketState> emit) {
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
      ));
    } on ArgumentError catch (e) {
      emit(BracketState.failure(e.message.toString()));
    } catch (e) {
      emit(BracketState.failure(e.toString()));
    }
  }
}

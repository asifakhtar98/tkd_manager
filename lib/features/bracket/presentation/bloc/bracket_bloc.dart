import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_event.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_state.dart';
import 'package:uuid/uuid.dart';

export 'bracket_event.dart';
export 'bracket_state.dart';

@injectable
class BracketBloc extends Bloc<BracketEvent, BracketState> {
  BracketBloc({
    required SingleEliminationBracketGeneratorService singleElimService,
    required DoubleEliminationBracketGeneratorService doubleElimService,
    required Uuid uuid,
  })  : _singleElimService = singleElimService,
        _doubleElimService = doubleElimService,
        _uuid = uuid,
        super(const BracketState.initial()) {
    on<BracketGenerateRequested>(_onGenerate);
    on<BracketRegenerateRequested>(_onRegenerate);
  }

  final SingleEliminationBracketGeneratorService _singleElimService;
  final DoubleEliminationBracketGeneratorService _doubleElimService;
  final Uuid _uuid;

  /// Cached params for re-generation support.
  BracketGenerateRequested? _lastRequest;

  void _onGenerate(
    BracketGenerateRequested event,
    Emitter<BracketState> emit,
  ) {
    _lastRequest = event;
    emit(const BracketState.generating());
    _generate(event, emit);
  }

  void _onRegenerate(
    BracketRegenerateRequested _,
    Emitter<BracketState> emit,
  ) {
    final req = _lastRequest;
    if (req == null) return;
    emit(const BracketState.generating());
    _generate(req, emit);
  }

  void _generate(BracketGenerateRequested req, Emitter<BracketState> emit) {
    try {
      final ids = req.participants.map((p) => p.id).toList();
      final divisionId = ids.isNotEmpty
          ? req.participants.first.divisionId
          : 'default_division';

      final BracketResult result;
      if (req.format == 'Double Elimination') {
        result = BracketResult.doubleElimination(
          _doubleElimService.generate(
            divisionId: divisionId,
            participantIds: ids,
            winnersBracketId: _uuid.v4(),
            losersBracketId: _uuid.v4(),
          ),
        );
      } else {
        result = BracketResult.singleElimination(
          _singleElimService.generate(
            divisionId: divisionId,
            participantIds: ids,
            bracketId: _uuid.v4(),
            includeThirdPlaceMatch: req.includeThirdPlaceMatch,
          ),
        );
      }

      emit(BracketState.loadSuccess(
        result: result,
        participants: req.participants,
        format: req.format,
        includeThirdPlaceMatch: req.includeThirdPlaceMatch,
      ));
    } on ArgumentError catch (e) {
      emit(BracketState.failure(e.message.toString()));
    } catch (e) {
      emit(BracketState.failure(e.toString()));
    }
  }
}

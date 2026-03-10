import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_event.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_state.dart';
import 'package:uuid/uuid.dart';

export 'bracket_event.dart';
export 'bracket_state.dart';

class BracketBloc extends Bloc<BracketEvent, BracketState> {
  BracketBloc({
    required SingleEliminationBracketGeneratorService singleElimService,
    required DoubleEliminationBracketGeneratorService doubleElimService,
  })  : _singleElimService = singleElimService,
        _doubleElimService = doubleElimService,
        super(const BracketInitial()) {
    on<BracketGenerateRequested>(_onGenerate);
    on<BracketRegenerateRequested>(_onRegenerate);
  }

  final SingleEliminationBracketGeneratorService _singleElimService;
  final DoubleEliminationBracketGeneratorService _doubleElimService;
  final _uuid = const Uuid();

  /// Cached params for re-generation support.
  BracketGenerateRequested? _lastRequest;

  void _onGenerate(
    BracketGenerateRequested event,
    Emitter<BracketState> emit,
  ) {
    _lastRequest = event;
    emit(const BracketGenerating());
    _generate(event, emit);
  }

  void _onRegenerate(
    BracketRegenerateRequested _,
    Emitter<BracketState> emit,
  ) {
    final req = _lastRequest;
    if (req == null) return;
    emit(const BracketGenerating());
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
        result = DoubleEliminationResult(
          _doubleElimService.generate(
            divisionId: divisionId,
            participantIds: ids,
            winnersBracketId: _uuid.v4(),
            losersBracketId: _uuid.v4(),
          ),
        );
      } else {
        result = SingleEliminationResult(
          _singleElimService.generate(
            divisionId: divisionId,
            participantIds: ids,
            bracketId: _uuid.v4(),
            includeThirdPlaceMatch: req.includeThirdPlaceMatch,
          ),
        );
      }

      emit(BracketLoadSuccess(
        result: result,
        participants: req.participants,
        format: req.format,
        includeThirdPlaceMatch: req.includeThirdPlaceMatch,
      ));
    } on ArgumentError catch (e) {
      emit(BracketFailure(e.message.toString()));
    } catch (e) {
      emit(BracketFailure(e.toString()));
    }
  }
}

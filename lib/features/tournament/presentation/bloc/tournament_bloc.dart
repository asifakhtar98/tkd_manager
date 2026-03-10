import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_event.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_state.dart';

export 'tournament_event.dart';
export 'tournament_state.dart';

/// Global BLoC that maintains all in-memory tournament records and their
/// associated bracket generation history. Registered as a lazy singleton so
/// the same instance is shared across the dashboard, setup, and detail screens.
@lazySingleton
class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  TournamentBloc() : super(const TournamentState()) {
    on<TournamentCreated>(_onCreate);
    on<TournamentBracketSnapshotAdded>(_onBracketAdded);
    on<TournamentBracketSnapshotRemoved>(_onBracketRemoved);
    on<TournamentDeleted>(_onDelete);
  }

  void _onCreate(TournamentCreated event, Emitter<TournamentState> emit) {
    final updated = [event.tournament, ...state.tournaments];
    emit(state.copyWith(tournaments: updated));
  }

  void _onBracketAdded(
    TournamentBracketSnapshotAdded event,
    Emitter<TournamentState> emit,
  ) {
    final existing = state.bracketsByTournamentId[event.tournamentId] ?? [];
    final updated = Map<String, List<BracketSnapshot>>.from(
      state.bracketsByTournamentId,
    )..[event.tournamentId] = [event.snapshot, ...existing];
    emit(state.copyWith(bracketsByTournamentId: updated));
  }

  void _onBracketRemoved(
    TournamentBracketSnapshotRemoved event,
    Emitter<TournamentState> emit,
  ) {
    final existing = state.bracketsByTournamentId[event.tournamentId] ?? [];
    final filtered = existing
        .where((s) => s.id != event.snapshotId)
        .toList();
    final updated = Map<String, List<BracketSnapshot>>.from(
      state.bracketsByTournamentId,
    )..[event.tournamentId] = filtered;
    emit(state.copyWith(bracketsByTournamentId: updated));
  }

  void _onDelete(TournamentDeleted event, Emitter<TournamentState> emit) {
    final updatedTournaments = state.tournaments
        .where((t) => t.id != event.tournamentId)
        .toList();
    final updatedBrackets = Map<String, List<BracketSnapshot>>.from(
      state.bracketsByTournamentId,
    )..remove(event.tournamentId);
    emit(state.copyWith(
      tournaments: updatedTournaments,
      bracketsByTournamentId: updatedBrackets,
    ));
  }

  /// Convenience: look up a tournament by ID.
  TournamentEntity? findById(String id) {
    try {
      return state.tournaments.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}

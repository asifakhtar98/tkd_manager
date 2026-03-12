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
    on<TournamentCreated>(_handleTournamentCreated);
    on<TournamentBracketSnapshotAdded>(_handleBracketSnapshotAdded);
    on<TournamentBracketSnapshotRemoved>(_handleBracketSnapshotRemoved);
    on<TournamentDeleted>(_handleTournamentDeleted);
    on<TournamentUpdated>(_handleTournamentUpdated);
  }

  void _handleTournamentCreated(
    TournamentCreated event,
    Emitter<TournamentState> emit,
  ) {
    final updatedTournamentList = [event.tournament, ...state.tournaments];
    emit(state.copyWith(tournaments: updatedTournamentList));
  }

  void _handleBracketSnapshotAdded(
    TournamentBracketSnapshotAdded event,
    Emitter<TournamentState> emit,
  ) {
    final existingSnapshots =
        state.bracketsByTournamentId[event.tournamentId] ?? [];
    final updatedBracketsMap = Map<String, List<BracketSnapshot>>.from(
      state.bracketsByTournamentId,
    )..[event.tournamentId] = [event.snapshot, ...existingSnapshots];
    emit(state.copyWith(bracketsByTournamentId: updatedBracketsMap));
  }

  void _handleBracketSnapshotRemoved(
    TournamentBracketSnapshotRemoved event,
    Emitter<TournamentState> emit,
  ) {
    final existingSnapshots =
        state.bracketsByTournamentId[event.tournamentId] ?? [];
    final filteredSnapshots = existingSnapshots
        .where((snapshot) => snapshot.id != event.snapshotId)
        .toList();
    final updatedBracketsMap = Map<String, List<BracketSnapshot>>.from(
      state.bracketsByTournamentId,
    )..[event.tournamentId] = filteredSnapshots;
    emit(state.copyWith(bracketsByTournamentId: updatedBracketsMap));
  }

  void _handleTournamentDeleted(
    TournamentDeleted event,
    Emitter<TournamentState> emit,
  ) {
    final updatedTournamentList = state.tournaments
        .where((tournament) => tournament.id != event.tournamentId)
        .toList();
    final updatedBracketsMap = Map<String, List<BracketSnapshot>>.from(
      state.bracketsByTournamentId,
    )..remove(event.tournamentId);
    emit(state.copyWith(
      tournaments: updatedTournamentList,
      bracketsByTournamentId: updatedBracketsMap,
    ));
  }

  void _handleTournamentUpdated(
    TournamentUpdated event,
    Emitter<TournamentState> emit,
  ) {
    final updatedTournamentList = state.tournaments.map((tournament) {
      return tournament.id == event.tournament.id ? event.tournament : tournament;
    }).toList();
    emit(state.copyWith(tournaments: updatedTournamentList));
  }

  /// Convenience: look up a tournament by its unique identifier.
  ///
  /// Returns `null` if no tournament with the given [tournamentId] exists.
  TournamentEntity? findById(String tournamentId) {
    return state.tournaments
        .where((tournament) => tournament.id == tournamentId)
        .firstOrNull;
  }
}

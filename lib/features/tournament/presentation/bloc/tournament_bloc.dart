import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/core/data/demo_bracket_snapshot_factory.dart';
import 'package:tkd_saas/features/core/data/demo_data.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/bracket_snapshot_repository.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_event.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_state.dart';

export 'tournament_event.dart';
export 'tournament_state.dart';

/// Global BLoC that maintains all remote tournament records and their
/// associated bracket generation history. Registered as a lazy singleton so
/// the same instance is shared across the dashboard, setup, and detail screens.
@lazySingleton
class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  TournamentBloc(
    this._tournamentRepository,
    this._bracketSnapshotRepository,
  ) : super(
          TournamentState(
            tournaments: [DemoData.demoTournament],
            bracketsByTournamentId: {
              DemoData.demoTournament.id:
                  DemoBracketSnapshotFactory
                      .generateAllDemoBracketSnapshots(),
            },
            isLoading: false,
          ),
        ) {
    on<TournamentLoadRequested>(_handleLoadRequested);
    on<TournamentLoadMoreRequested>(_handleLoadMoreRequested);
    on<TournamentCreated>(_handleTournamentCreated);
    on<TournamentBracketSnapshotAdded>(_handleBracketSnapshotAdded);
    on<TournamentBracketSnapshotRemoved>(_handleBracketSnapshotRemoved);
    on<TournamentDeleted>(_handleTournamentDeleted);
    on<TournamentUpdated>(_handleTournamentUpdated);
    on<TournamentBracketSnapshotUpdated>(_handleTournamentBracketSnapshotUpdated);
    on<TournamentClearRequested>(_handleClearRequested);
  }

  final TournamentRepository _tournamentRepository;
  final BracketSnapshotRepository _bracketSnapshotRepository;

  Future<void> _handleLoadRequested(
    TournamentLoadRequested event,
    Emitter<TournamentState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true, 
      errorMessage: null,
      isFetchingMore: false,
      hasReachedMax: false,
    ));
    try {
      final remoteTournamentsResult = await _tournamentRepository.getTournaments();
      
      await remoteTournamentsResult.fold(
        (failure) async {
          log('Failed to load remote tournaments: ${failure.message}');
          emit(state.copyWith(isLoading: false, errorMessage: failure.message));
        },
        (remoteTournaments) async {
          final Map<String, List<BracketSnapshot>> remoteBrackets = {};
          
          for (final t in remoteTournaments) {
            final snapshotsResult = await _bracketSnapshotRepository.getBracketSnapshots(t.id);
            snapshotsResult.fold(
              (failure) {
                log('Failed to load brackets for tournament ${t.id}: ${failure.message}');
                remoteBrackets[t.id] = [];
              },
              (snapshots) {
                remoteBrackets[t.id] = snapshots;
              }
            );
          }

          // Preserve demo data
          final allTournaments = [DemoData.demoTournament, ...remoteTournaments];
          final allBrackets = {
            ...state.bracketsByTournamentId,
            ...remoteBrackets,
          };

          emit(
            state.copyWith(
              tournaments: allTournaments,
              bracketsByTournamentId: allBrackets,
              isLoading: false,
              hasReachedMax: remoteTournaments.length < 20,
            ),
          );
        }
      );
    } catch (e) {
      log('Unexpected error loading remote tournaments: $e');
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to load tournaments.'));
    }
  }

  Future<void> _handleLoadMoreRequested(
    TournamentLoadMoreRequested event,
    Emitter<TournamentState> emit,
  ) async {
    if (state.hasReachedMax || state.isFetchingMore || state.isLoading) return;

    emit(state.copyWith(isFetchingMore: true, errorMessage: null));

    try {
      final int offset = state.tournaments.where((t) => t.id != DemoData.demoTournament.id).length;
      final remoteTournamentsResult = await _tournamentRepository.getTournaments(
        limit: 20,
        offset: offset,
      );

      await remoteTournamentsResult.fold(
        (failure) async {
          log('Failed to load more tournaments: ${failure.message}');
          emit(state.copyWith(
            isFetchingMore: false,
            errorMessage: failure.message,
          ));
        },
        (remoteTournaments) async {
          if (remoteTournaments.isEmpty) {
            emit(state.copyWith(isFetchingMore: false, hasReachedMax: true));
            return;
          }

          final Map<String, List<BracketSnapshot>> remoteBrackets = {};
          for (final t in remoteTournaments) {
            final snapshotsResult = await _bracketSnapshotRepository.getBracketSnapshots(t.id);
            snapshotsResult.fold(
              (failure) {
                log('Failed to load brackets for tournament ${t.id}: ${failure.message}');
              },
              (snapshots) {
                remoteBrackets[t.id] = snapshots;
              }
            );
          }

          final allTournaments = [...state.tournaments, ...remoteTournaments];
          final allBrackets = {
            ...state.bracketsByTournamentId,
            ...remoteBrackets,
          };

          emit(
            state.copyWith(
              tournaments: allTournaments,
              bracketsByTournamentId: allBrackets,
              isFetchingMore: false,
              hasReachedMax: remoteTournaments.length < 20,
            ),
          );
        }
      );
    } catch (e, st) {
      log('Failed to load more tournaments', error: e, stackTrace: st);
      emit(state.copyWith(
        isFetchingMore: false,
        errorMessage: 'Failed to load more tournaments.',
      ));
    }
  }

  Future<void> _handleTournamentCreated(
    TournamentCreated event,
    Emitter<TournamentState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, lastMutationError: null));
    try {
      final persistedResult = await _tournamentRepository.createTournament(event.tournament);
      
      persistedResult.fold(
        (failure) {
          log('Failed to create tournament: ${failure.message}');
          emit(state.copyWith(
            isSaving: false,
            lastMutationError: failure.message,
          ));
        },
        (persisted) {
          final updatedTournamentList = [persisted, ...state.tournaments];
          emit(state.copyWith(
            tournaments: updatedTournamentList,
            isSaving: false,
          ));
        }
      );
    } catch (e) {
      log('Unexpected error creating tournament: $e');
      emit(state.copyWith(
        isSaving: false,
        lastMutationError: 'Failed to create tournament.',
      ));
    }
  }

  Future<void> _handleBracketSnapshotAdded(
    TournamentBracketSnapshotAdded event,
    Emitter<TournamentState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, lastMutationError: null));
    
    if (event.tournamentId == DemoData.demoTournament.id) {
      final existingSnapshots = state.bracketsByTournamentId[event.tournamentId] ?? [];
      final updatedBracketsMap = Map<String, List<BracketSnapshot>>.from(
        state.bracketsByTournamentId,
      )..[event.tournamentId] = [event.snapshot, ...existingSnapshots];
      emit(state.copyWith(
        bracketsByTournamentId: updatedBracketsMap,
        isSaving: false,
      ));
      return;
    }

    try {
      final persistedResult = await _bracketSnapshotRepository.createBracketSnapshot(event.snapshot, event.tournamentId);
      
      persistedResult.fold(
        (failure) {
          log('Failed to add bracket snapshot: ${failure.message}');
          emit(state.copyWith(
            isSaving: false,
            lastMutationError: failure.message,
          ));
        },
        (persisted) {
          final existingSnapshots = state.bracketsByTournamentId[event.tournamentId] ?? [];
          final updatedBracketsMap = Map<String, List<BracketSnapshot>>.from(
            state.bracketsByTournamentId,
          )..[event.tournamentId] = [persisted, ...existingSnapshots];
          
          emit(state.copyWith(
            bracketsByTournamentId: updatedBracketsMap,
            isSaving: false,
          ));
        }
      );
    } catch (e) {
      log('Unexpected error adding bracket snapshot: $e');
      emit(state.copyWith(
        isSaving: false,
        lastMutationError: 'Failed to save bracket snapshot.',
      ));
    }
  }

  Future<void> _handleBracketSnapshotRemoved(
    TournamentBracketSnapshotRemoved event,
    Emitter<TournamentState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, lastMutationError: null));

    if (event.tournamentId == DemoData.demoTournament.id) {
      final existingSnapshots = state.bracketsByTournamentId[event.tournamentId] ?? [];
      final filteredSnapshots = existingSnapshots
          .where((snapshot) => snapshot.id != event.snapshotId)
          .toList();
      final updatedBracketsMap = Map<String, List<BracketSnapshot>>.from(
        state.bracketsByTournamentId,
      )..[event.tournamentId] = filteredSnapshots;
      emit(state.copyWith(
        bracketsByTournamentId: updatedBracketsMap,
        isSaving: false,
      ));
      return;
    }

    try {
      final result = await _bracketSnapshotRepository.deleteBracketSnapshot(event.snapshotId);
      
      result.fold(
        (failure) {
          log('Failed to remove bracket snapshot: ${failure.message}');
          emit(state.copyWith(
            isSaving: false,
            lastMutationError: failure.message,
          ));
        },
        (_) {
          final existingSnapshots = state.bracketsByTournamentId[event.tournamentId] ?? [];
          final filteredSnapshots = existingSnapshots
              .where((snapshot) => snapshot.id != event.snapshotId)
              .toList();
          final updatedBracketsMap = Map<String, List<BracketSnapshot>>.from(
            state.bracketsByTournamentId,
          )..[event.tournamentId] = filteredSnapshots;
          
          emit(state.copyWith(
            bracketsByTournamentId: updatedBracketsMap,
            isSaving: false,
          ));
        }
      );
    } catch (e) {
      log('Unexpected error removing bracket snapshot: $e');
      emit(state.copyWith(
        isSaving: false,
        lastMutationError: 'Failed to remove bracket snapshot.',
      ));
    }
  }

  Future<void> _handleTournamentDeleted(
    TournamentDeleted event,
    Emitter<TournamentState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, lastMutationError: null));

    if (event.tournamentId == DemoData.demoTournament.id) {
      final updatedTournamentList = state.tournaments
          .where((tournament) => tournament.id != event.tournamentId)
          .toList();
      final updatedBracketsMap = Map<String, List<BracketSnapshot>>.from(
        state.bracketsByTournamentId,
      )..remove(event.tournamentId);
      emit(
        state.copyWith(
          tournaments: updatedTournamentList,
          bracketsByTournamentId: updatedBracketsMap,
          isSaving: false,
        ),
      );
      return;
    }

    try {
      final result = await _tournamentRepository.deleteTournament(event.tournamentId);
      
      result.fold(
        (failure) {
          log('Failed to delete tournament: ${failure.message}');
          emit(state.copyWith(
            isSaving: false,
            lastMutationError: failure.message,
          ));
        },
        (_) {
          final updatedTournamentList = state.tournaments
              .where((tournament) => tournament.id != event.tournamentId)
              .toList();
          final updatedBracketsMap = Map<String, List<BracketSnapshot>>.from(
            state.bracketsByTournamentId,
          )..remove(event.tournamentId);
          
          emit(
            state.copyWith(
              tournaments: updatedTournamentList,
              bracketsByTournamentId: updatedBracketsMap,
              isSaving: false,
            ),
          );
        }
      );
    } catch (e) {
      log('Unexpected error deleting tournament: $e');
      emit(state.copyWith(
        isSaving: false,
        lastMutationError: 'Failed to delete tournament.',
      ));
    }
  }

  Future<void> _handleTournamentUpdated(
    TournamentUpdated event,
    Emitter<TournamentState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, lastMutationError: null));

    if (event.tournament.id == DemoData.demoTournament.id) {
      final updatedTournamentList = state.tournaments.map((tournament) {
        return tournament.id == event.tournament.id
            ? event.tournament
            : tournament;
      }).toList();
      emit(state.copyWith(
        tournaments: updatedTournamentList,
        isSaving: false,
      ));
      return;
    }

    try {
      final persistedResult = await _tournamentRepository.updateTournament(event.tournament);
      
      persistedResult.fold(
        (failure) {
          log('Failed to update tournament: ${failure.message}');
          emit(state.copyWith(
            isSaving: false,
            lastMutationError: failure.message,
          ));
        },
        (persisted) {
          final updatedTournamentList = state.tournaments.map((tournament) {
            return tournament.id == persisted.id
                ? persisted
                : tournament;
          }).toList();
          emit(state.copyWith(
            tournaments: updatedTournamentList,
            isSaving: false,
          ));
        }
      );
    } catch (e) {
      log('Unexpected error updating tournament: $e');
      emit(state.copyWith(
        isSaving: false,
        lastMutationError: 'Failed to update tournament.',
      ));
    }
  }

  Future<void> _handleTournamentBracketSnapshotUpdated(
    TournamentBracketSnapshotUpdated event,
    Emitter<TournamentState> emit,
  ) async {
    final tournamentId = event.snapshot.tournamentId;
    
    emit(state.copyWith(isSaving: true, lastMutationError: null));

    if (tournamentId == DemoData.demoTournament.id) {
       final existingSnapshots = state.bracketsByTournamentId[tournamentId] ?? [];
      final updatedSnapshots = existingSnapshots.map((snapshot) {
        return snapshot.id == event.snapshot.id ? event.snapshot : snapshot;
      }).toList();
      final updatedBracketsMap = Map<String, List<BracketSnapshot>>.from(
        state.bracketsByTournamentId,
      )..[tournamentId] = updatedSnapshots;
      emit(state.copyWith(
        bracketsByTournamentId: updatedBracketsMap,
        isSaving: false,
      ));
      return;
    }

    try {
      final persistedResult = await _bracketSnapshotRepository.updateBracketSnapshot(event.snapshot);
      
      persistedResult.fold(
        (failure) {
          log('Failed to update bracket snapshot: ${failure.message}');
          emit(state.copyWith(
            isSaving: false,
            lastMutationError: failure.message,
          ));
        },
        (persisted) {
          final existingSnapshots = state.bracketsByTournamentId[tournamentId] ?? [];
          
          final updatedSnapshots = existingSnapshots.map((snapshot) {
            return snapshot.id == persisted.id ? persisted : snapshot;
          }).toList();

          final updatedBracketsMap = Map<String, List<BracketSnapshot>>.from(
            state.bracketsByTournamentId,
          )..[tournamentId] = updatedSnapshots;
          
          emit(state.copyWith(
            bracketsByTournamentId: updatedBracketsMap,
            isSaving: false,
          ));
        }
      );
    } catch (e) {
      log('Unexpected error updating bracket snapshot: $e');
      emit(state.copyWith(
        isSaving: false,
        lastMutationError: 'Failed to update bracket snapshot.',
      ));
    }
  }

  Future<void> _handleClearRequested(
    TournamentClearRequested event,
    Emitter<TournamentState> emit,
  ) async {
    emit(
      TournamentState(
        tournaments: [DemoData.demoTournament],
        bracketsByTournamentId: {
          DemoData.demoTournament.id:
              DemoBracketSnapshotFactory.generateAllDemoBracketSnapshots(),
        },
        isLoading: false,
        isFetchingMore: false,
        hasReachedMax: false,
        isSaving: false,
        errorMessage: null,
        lastMutationError: null,
      ),
    );
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

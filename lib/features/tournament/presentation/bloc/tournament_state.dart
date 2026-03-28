import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';

part 'tournament_state.freezed.dart';

/// Immutable state for [TournamentBloc].
///
/// [tournaments] — ordered list of all in-memory tournaments (newest first).
/// [bracketsByTournamentId] — each tournament's bracket generation history.
@freezed
abstract class TournamentState with _$TournamentState {
  const TournamentState._();

  const factory TournamentState({
    @Default([]) List<TournamentEntity> tournaments,
    @Default({}) Map<String, List<BracketSnapshot>> bracketsByTournamentId,
    @Default(true) bool isLoading,
    @Default(false) bool isSaving,
    @Default(false) bool isFetchingMore,
    @Default(false) bool hasReachedMax,
    String? errorMessage,
    String? lastMutationError,
  }) = _TournamentState;

  /// Convenience: brackets for a given tournament ID (empty list if none yet).
  List<BracketSnapshot> bracketsFor(String tournamentId) =>
      bracketsByTournamentId[tournamentId] ?? const [];
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

part 'bracket_event.freezed.dart';

/// Base class for all bracket BLoC events.
@freezed
sealed class BracketEvent with _$BracketEvent {
  /// Trigger initial generation. Carries all params required by the engine.
  const factory BracketEvent.generateRequested({
    required List<ParticipantEntity> participants,
    /// 'Single Elimination' | 'Double Elimination'
    required String format,
    required bool dojangSeparation,
    required bool includeThirdPlaceMatch,
  }) = BracketGenerateRequested;

  /// Re-generate using the same params stored from the last [BracketGenerateRequested].
  const factory BracketEvent.regenerateRequested() = BracketRegenerateRequested;

  /// Record a match result (winner, optional scores).
  const factory BracketEvent.matchResultRecorded({
    required String matchId,
    required String winnerId,
    required MatchResultType resultType,
    int? blueScore,
    int? redScore,
  }) = BracketMatchResultRecorded;

  /// Clear the [BracketLoadSuccess.errorMessage] after the UI has shown it.
  const factory BracketEvent.errorDismissed() = BracketErrorDismissed;
}

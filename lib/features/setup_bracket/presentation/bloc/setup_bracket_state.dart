import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';

part 'setup_bracket_state.freezed.dart';
part 'setup_bracket_state.g.dart';

/// Immutable state for [SetupBracketBloc].
///
/// Fully JSON-serializable so that [HydratedBloc] can persist and restore it
/// across page reloads and long tournament sessions.
///
/// Scoped to a single [tournamentId] — each tournament maintains its own
/// independent persisted session.
@freezed
abstract class SetupBracketState with _$SetupBracketState {
  const SetupBracketState._();

  const factory SetupBracketState({
    /// The owning tournament — used as the hydration storage key.
    required String tournamentId,

    /// The participant roster being built for this bracket.
    @Default([]) List<ParticipantEntity> participants,

    /// The elimination format selected for bracket generation.
    @Default(BracketFormat.singleElimination) BracketFormat selectedBracketFormat,

    /// Whether participants from the same dojang/school are auto-separated
    /// in the bracket seeding order.
    @Default(true) bool isDojangSeparationEnabled,

    /// Whether a 3rd-place bronze medal match is included.
    /// Only applies to single-elimination brackets.
    @Default(false) bool isThirdPlaceMatchIncluded,

    /// Bracket classification: age category label (e.g. "Junior", "Senior").
    @Default('') String bracketAgeCategoryLabel,

    /// Bracket classification: gender label (e.g. "Male", "Female").
    @Default('') String bracketGenderLabel,

    /// Bracket classification: weight division label (e.g. "-58kg").
    @Default('') String bracketWeightDivisionLabel,

    /// True while waiting for [TournamentBloc] to confirm snapshot persistence.
    @Default(false) bool isAwaitingBracketGeneration,

    /// The snapshot ID currently being persisted. Non-null only during the
    /// brief window between dispatch and confirmation.
    String? pendingSnapshotId,
  }) = _SetupBracketState;

  factory SetupBracketState.fromJson(Map<String, dynamic> json) =>
      _$SetupBracketStateFromJson(json);

  // ── Convenience getters ──────────────────────────────────────────────────

  static const int minimumParticipantsRequiredForGeneration = 2;

  bool get hasEnoughParticipantsToGenerate =>
      participants.length >= minimumParticipantsRequiredForGeneration;

  /// Returns `true` when a participant with the same name (case-insensitive)
  /// already exists in the roster.
  bool isDuplicateParticipantName(String fullName) {
    final normalizedName = fullName.trim().toLowerCase();
    return participants.any(
      (participant) => participant.fullName.toLowerCase() == normalizedName,
    );
  }
}

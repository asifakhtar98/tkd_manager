import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';

part 'setup_bracket_event.freezed.dart';

/// All events handled by [SetupBracketBloc].
@freezed
sealed class SetupBracketEvent with _$SetupBracketEvent {
  // ── Participant roster management ─────────────────────────────────────────

  /// Add a single participant to the roster from the quick-add form.
  const factory SetupBracketEvent.participantAdded({
    required String fullName,
    String? registrationId,
    String? schoolOrDojangName,
  }) = SetupBracketParticipantAdded;

  /// Bulk-import participants from pasted CSV text.
  ///
  /// CSV format: Name, RegistrationId, Dojang (one participant per line).
  const factory SetupBracketEvent.participantsImportedFromCsv({
    required String csvRawText,
  }) = SetupBracketParticipantsImportedFromCsv;

  /// Remove the participant at [rosterIndex] from the roster.
  const factory SetupBracketEvent.participantRemoved({
    required int rosterIndex,
  }) = SetupBracketParticipantRemoved;

  /// Clear the entire participant roster.
  const factory SetupBracketEvent.participantsCleared() =
      SetupBracketParticipantsCleared;

  /// Reorder the roster after a drag-and-drop operation.
  ///
  /// [oldIndex] and [newIndex] are the raw indices reported by
  /// [ReorderableListView.onReorder].
  const factory SetupBracketEvent.participantsReordered({
    required int oldIndex,
    required int newIndex,
  }) = SetupBracketParticipantsReordered;

  // ── Bracket configuration ─────────────────────────────────────────────────

  /// Change the elimination format (single / double).
  const factory SetupBracketEvent.bracketFormatChanged({
    required BracketFormat newFormat,
  }) = SetupBracketFormatChanged;

  /// Toggle dojang/school separation on or off.
  const factory SetupBracketEvent.dojangSeparationToggled({
    required bool isEnabled,
  }) = SetupBracketDojangSeparationToggled;

  /// Toggle the 3rd-place bronze match on or off.
  const factory SetupBracketEvent.thirdPlaceMatchToggled({
    required bool isEnabled,
  }) = SetupBracketThirdPlaceMatchToggled;

  /// Update classification metadata (age category, gender, weight division).
  const factory SetupBracketEvent.classificationUpdated({
    required String ageCategoryLabel,
    required String genderLabel,
    required String weightDivisionLabel,
  }) = SetupBracketClassificationUpdated;

  // ── Bracket generation lifecycle ──────────────────────────────────────────

  /// Mark that bracket generation has been dispatched to [TournamentBloc].
  /// Stores the [pendingSnapshotId] so the bloc can track completion.
  const factory SetupBracketEvent.bracketGenerationDispatched({
    required String pendingSnapshotId,
  }) = SetupBracketGenerationDispatched;

  /// Confirm that bracket generation succeeded — clears transient generation
  /// state (pending snapshot) and resets the roster and config.
  const factory SetupBracketEvent.bracketGenerationSucceeded() =
      SetupBracketGenerationSucceeded;

  /// Clear the pending snapshot reference when generation aborted or failed.
  const factory SetupBracketEvent.bracketGenerationFailed() =
      SetupBracketGenerationFailed;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';

part 'setup_bracket_event.freezed.dart';

/// All events handled by [SetupBracketBloc].
@freezed
sealed class SetupBracketEvent with _$SetupBracketEvent {
  const factory SetupBracketEvent.participantAdded({
    required String fullName,
    String? registrationId,
    String? schoolOrDojangName,
  }) = SetupBracketParticipantAdded;

  const factory SetupBracketEvent.participantsImportedFromCsv({
    required String csvRawText,
  }) = SetupBracketParticipantsImportedFromCsv;

  const factory SetupBracketEvent.participantRemoved({
    required int rosterIndex,
  }) = SetupBracketParticipantRemoved;

  const factory SetupBracketEvent.participantsCleared() =
      SetupBracketParticipantsCleared;

  const factory SetupBracketEvent.participantsReordered({
    required int oldIndex,
    required int newIndex,
  }) = SetupBracketParticipantsReordered;

  const factory SetupBracketEvent.bracketFormatChanged({
    required BracketFormat newFormat,
  }) = SetupBracketFormatChanged;

  const factory SetupBracketEvent.dojangSeparationToggled({
    required bool isEnabled,
  }) = SetupBracketDojangSeparationToggled;

  const factory SetupBracketEvent.thirdPlaceMatchToggled({
    required bool isEnabled,
  }) = SetupBracketThirdPlaceMatchToggled;

  const factory SetupBracketEvent.classificationUpdated({
    required String ageCategoryLabel,
    required String genderLabel,
    required String weightDivisionLabel,
  }) = SetupBracketClassificationUpdated;

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

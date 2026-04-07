import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/bracket_setup_seed_data.dart';

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

  /// Pre-populates the setup form with data from an existing bracket.
  ///
  /// Used by the "Copy & Start Over" flow from [BracketViewerScreen].
  /// The handler assigns fresh UUIDs to all participants and resequences
  /// seed numbers to avoid referential identity collision with the
  /// co-existing original bracket.
  const factory SetupBracketEvent.existingBracketDataImported({
    required BracketSetupSeedData seedData,
  }) = SetupBracketExistingBracketDataImported;
}

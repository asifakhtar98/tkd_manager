import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';

part 'bracket_setup_seed_data.freezed.dart';

/// Transient, immutable value object carrying bracket configuration data
/// from an existing [BracketSnapshot] to the [SetupBracketScreen].
///
/// Used exclusively by the "Copy & Start Over" flow. **Not JSON-serializable**
/// — this object lives only in memory during an imperative navigation action
/// and is discarded once the [SetupBracketBloc] consumes it.
///
/// Participants should be pre-filtered to exclude BYE entries before
/// constructing this object.
@freezed
abstract class BracketSetupSeedData with _$BracketSetupSeedData {
  const factory BracketSetupSeedData({
    /// The participant roster from the source bracket, with BYE entries
    /// already excluded by the caller.
    required List<ParticipantEntity> participants,

    /// The elimination format used in the source bracket.
    required BracketFormat selectedBracketFormat,

    /// Whether dojang/school separation was enabled in the source bracket.
    required bool isDojangSeparationEnabled,

    /// Whether a 3rd-place match was included in the source bracket.
    required bool isThirdPlaceMatchIncluded,

    /// Classification: age category label (e.g. "Junior", "Senior").
    required String bracketAgeCategoryLabel,

    /// Classification: gender label (e.g. "Male", "Female").
    required String bracketGenderLabel,

    /// Classification: weight division label (e.g. "-58kg").
    required String bracketWeightDivisionLabel,
  }) = _BracketSetupSeedData;
}

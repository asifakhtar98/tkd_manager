import 'package:freezed_annotation/freezed_annotation.dart';

part 'bracket_edit_action.freezed.dart';
part 'bracket_edit_action.g.dart';

/// Describes a single bracket edit-mode action (participant swap or detail
/// update). Used by the undo/redo history stack alongside [BracketMatchAction].
@freezed
sealed class BracketEditAction with _$BracketEditAction {
  /// Two participant slots were swapped in the bracket.
  const factory BracketEditAction.participantSlotSwapped({
    required String sourceMatchId,
    required String sourceSlotPosition,
    required String targetMatchId,
    required String targetSlotPosition,
    required String displayLabel,
    required DateTime recordedAt,
  }) = BracketEditActionParticipantSlotSwapped;

  /// A participant's name or registration ID was edited.
  const factory BracketEditAction.participantDetailsUpdated({
    required String participantId,
    required String updatedFullName,
    String? updatedRegistrationId,
    required String displayLabel,
    required DateTime recordedAt,
  }) = BracketEditActionParticipantDetailsUpdated;

  factory BracketEditAction.fromJson(Map<String, dynamic> json) =>
      _$BracketEditActionFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/bracket_theme_selection.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';

part 'bracket_theme_selection_state.freezed.dart';
part 'bracket_theme_selection_state.g.dart';

@freezed
abstract class BracketThemeSelectionState with _$BracketThemeSelectionState {
  @JsonSerializable(explicitToJson: true)
  const factory BracketThemeSelectionState({
    required BracketThemeSelection activeThemeSelection,

    /// Populated when the user is in custom editing mode. This holds
    /// the live-editing config that updates on every slider/picker change.
    /// Separated from the selection union so we can hydrate the "which mode"
    /// question independently of the 80+ token config.
    @Default(null) TieSheetThemeConfig? liveCustomThemeConfiguration,

    /// Non-null when the last-applied cloud preset could not be resolved
    /// (e.g. it was deleted from another device). Triggers a one-time
    /// "Theme expired" SnackBar in the UI.
    @Default(null) String? themeExpiredMessage,
  }) = _BracketThemeSelectionState;

  factory BracketThemeSelectionState.fromJson(Map<String, dynamic> json) =>
      _$BracketThemeSelectionStateFromJson(json);
}

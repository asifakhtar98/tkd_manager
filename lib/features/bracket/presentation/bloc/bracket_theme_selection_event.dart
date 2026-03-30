import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_theme_preset_entity.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';

part 'bracket_theme_selection_event.freezed.dart';

@freezed
sealed class BracketThemeSelectionEvent with _$BracketThemeSelectionEvent {
  /// User toggled the SegmentedButton to Screen / Print / Custom.
  const factory BracketThemeSelectionEvent.themeModeToggled({
    required TieSheetThemeMode selectedMode,
  }) = BracketThemeSelectionModeToggled;

  /// User tapped a cloud preset from the sidebar list.
  const factory BracketThemeSelectionEvent.cloudPresetApplied({
    required String presetId,
    required TieSheetThemeConfig resolvedThemeConfiguration,
  }) = BracketThemeSelectionCloudPresetApplied;

  /// User changed a token in the custom theme editor panel (slider, colour, toggle).
  const factory BracketThemeSelectionEvent.customThemeConfigurationUpdated({
    required TieSheetThemeConfig updatedThemeConfiguration,
  }) = BracketThemeSelectionCustomConfigUpdated;

  /// Fired by the UI on init to resolve a hydrated cloudPresetSelected state.
  /// Checks whether the preset ID still exists in the loaded presets list.
  const factory BracketThemeSelectionEvent.hydratedSelectionResolved({
    required List<BracketThemePresetEntity> availableCloudPresets,
  }) = BracketThemeSelectionHydratedResolved;

  /// Clears the themeExpiredMessage after the SnackBar has been shown.
  const factory BracketThemeSelectionEvent.themeExpiredMessageDismissed() =
      BracketThemeSelectionExpiredDismissed;
}

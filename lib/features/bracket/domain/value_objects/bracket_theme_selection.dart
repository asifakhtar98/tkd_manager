import 'package:freezed_annotation/freezed_annotation.dart';

part 'bracket_theme_selection.freezed.dart';
part 'bracket_theme_selection.g.dart';

@freezed
sealed class BracketThemeSelection with _$BracketThemeSelection {
  const BracketThemeSelection._();

  /// User is using the built-in Colourful preset.
  const factory BracketThemeSelection.colourfulModeSelected() =
      BracketThemeSelectionColourfulMode;

  /// User is using the built-in High Contrast preset.
  const factory BracketThemeSelection.highContrastModeSelected() =
      BracketThemeSelectionHighContrastMode;

  /// User is using a cloud preset (identified by its ID).
  /// The full config is resolved at runtime from BracketThemePresetBloc.
  const factory BracketThemeSelection.cloudPresetSelected({
    required String presetId,
  }) = BracketThemeSelectionCloudPreset;

  /// User is in custom editing mode with a freeform config.
  /// The actual config is stored in
  /// [BracketThemeSelectionState.liveCustomThemeConfiguration].
  const factory BracketThemeSelection.customModeSelected() =
      BracketThemeSelectionCustomMode;

  factory BracketThemeSelection.fromJson(Map<String, dynamic> json) =>
      _$BracketThemeSelectionFromJson(json);
}

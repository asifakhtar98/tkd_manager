import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';

part 'bracket_theme_preset_event.freezed.dart';

@freezed
sealed class BracketThemePresetEvent with _$BracketThemePresetEvent {
  const factory BracketThemePresetEvent.loadRequested() = BracketThemePresetLoadRequested;

  const factory BracketThemePresetEvent.saveRequested({
    required TieSheetThemeConfig themeConfiguration,
  }) = BracketThemePresetSaveRequested;

  const factory BracketThemePresetEvent.deleteRequested({
    required String presetId,
  }) = BracketThemePresetDeleteRequested;
}

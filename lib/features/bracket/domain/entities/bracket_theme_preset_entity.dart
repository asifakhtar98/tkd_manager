import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';

part 'bracket_theme_preset_entity.freezed.dart';

/// Represents a saved custom theme preset in the cloud.
@freezed
abstract class BracketThemePresetEntity with _$BracketThemePresetEntity {
  const factory BracketThemePresetEntity({
    /// Unique identifier for the preset record.
    required String id,

    /// ID of the user who owns this preset.
    required String userId,

    /// The entire theme configuration snapshot.
    required TieSheetThemeConfig themeConfiguration,

    /// When the preset was created. Also serves as the UI label.
    required DateTime createdAt,
  }) = _BracketThemePresetEntity;
}

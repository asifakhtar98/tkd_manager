import 'package:fpdart/fpdart.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_theme_preset_entity.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';

/// Repository interface for saving, loading, and deleting custom bracket theme presets.
abstract class BracketThemePresetRepository {
  /// Fetches all custom theme presets for the currently authenticated user.
  /// Ordered by creation date descending.
  Future<Either<Failure, List<BracketThemePresetEntity>>> getThemePresetsForUser();

  /// Creates a new preset saving the given [themeConfiguration].
  Future<Either<Failure, BracketThemePresetEntity>> createThemePreset(
    TieSheetThemeConfig themeConfiguration,
  );

  /// Deletes a preset by its [presetId].
  Future<Either<Failure, void>> deleteThemePreset(String presetId);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_theme_preset_entity.dart';

part 'bracket_theme_preset_state.freezed.dart';

@freezed
sealed class BracketThemePresetState with _$BracketThemePresetState {
  const factory BracketThemePresetState.initial() = BracketThemePresetInitial;

  const factory BracketThemePresetState.loading() = BracketThemePresetLoading;

  const factory BracketThemePresetState.loaded({
    required List<BracketThemePresetEntity> presets,
  }) = BracketThemePresetLoaded;

  const factory BracketThemePresetState.error({
    required String message,
    @Default([]) List<BracketThemePresetEntity> previousPresets,
  }) = BracketThemePresetError;
}

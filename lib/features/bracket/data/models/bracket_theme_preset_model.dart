import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_theme_preset_entity.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';

part 'bracket_theme_preset_model.freezed.dart';
part 'bracket_theme_preset_model.g.dart';

@freezed
abstract class BracketThemePresetModel with _$BracketThemePresetModel {
  const BracketThemePresetModel._();

  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory BracketThemePresetModel({
    required String id,
    required String userId,
    required TieSheetThemeConfig themeConfig,
    required DateTime createdAt,
  }) = _BracketThemePresetModel;

  factory BracketThemePresetModel.fromJson(Map<String, dynamic> json) =>
      _$BracketThemePresetModelFromJson(json);

  factory BracketThemePresetModel.fromEntity(BracketThemePresetEntity entity) {
    return BracketThemePresetModel(
      id: entity.id,
      userId: entity.userId,
      themeConfig: entity.themeConfiguration,
      createdAt: entity.createdAt,
    );
  }
}

extension BracketThemePresetModelToEntity on BracketThemePresetModel {
  BracketThemePresetEntity toEntity() {
    return BracketThemePresetEntity(
      id: id,
      userId: userId,
      themeConfiguration: themeConfig,
      createdAt: createdAt,
    );
  }
}

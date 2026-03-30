// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bracket_theme_selection_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BracketThemeSelectionState _$BracketThemeSelectionStateFromJson(
  Map<String, dynamic> json,
) => _BracketThemeSelectionState(
  activeThemeSelection: BracketThemeSelection.fromJson(
    json['activeThemeSelection'] as Map<String, dynamic>,
  ),
  liveCustomThemeConfiguration: json['liveCustomThemeConfiguration'] == null
      ? null
      : TieSheetThemeConfig.fromJson(
          json['liveCustomThemeConfiguration'] as Map<String, dynamic>,
        ),
  themeExpiredMessage: json['themeExpiredMessage'] as String? ?? null,
);

Map<String, dynamic> _$BracketThemeSelectionStateToJson(
  _BracketThemeSelectionState instance,
) => <String, dynamic>{
  'activeThemeSelection': instance.activeThemeSelection.toJson(),
  'liveCustomThemeConfiguration': instance.liveCustomThemeConfiguration
      ?.toJson(),
  'themeExpiredMessage': instance.themeExpiredMessage,
};

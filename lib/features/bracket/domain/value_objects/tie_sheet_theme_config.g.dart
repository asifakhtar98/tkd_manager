// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tie_sheet_theme_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TieSheetThemeConfig _$TieSheetThemeConfigFromJson(
  Map<String, dynamic> json,
) => _TieSheetThemeConfig(
  mutedColor: const ColorJsonConverter().fromJson(
    (json['mutedColor'] as num).toInt(),
  ),
  connectorWonColor: const ColorJsonConverter().fromJson(
    (json['connectorWonColor'] as num).toInt(),
  ),
  canvasBackgroundColor: const ColorJsonConverter().fromJson(
    (json['canvasBackgroundColor'] as num).toInt(),
  ),
  borderColor: const ColorJsonConverter().fromJson(
    (json['borderColor'] as num).toInt(),
  ),
  connectorStrokeWidth: (json['connectorStrokeWidth'] as num).toDouble(),
  isInteractivityDisabled: json['isInteractivityDisabled'] as bool,
  primaryTextColor: const ColorJsonConverter().fromJson(
    (json['primaryTextColor'] as num).toInt(),
  ),
  secondaryTextColor: const ColorJsonConverter().fromJson(
    (json['secondaryTextColor'] as num).toInt(),
  ),
  isTextForceBold: json['isTextForceBold'] as bool,
  fontSizeDelta: (json['fontSizeDelta'] as num).toDouble(),
  rowFillColor: const ColorJsonConverter().fromJson(
    (json['rowFillColor'] as num).toInt(),
  ),
  headerFillColor: const ColorJsonConverter().fromJson(
    (json['headerFillColor'] as num).toInt(),
  ),
  tbdFillColor: const ColorJsonConverter().fromJson(
    (json['tbdFillColor'] as num).toInt(),
  ),
  headerBannerBackgroundColor: const ColorJsonConverter().fromJson(
    (json['headerBannerBackgroundColor'] as num).toInt(),
  ),
  headerBannerTextColor: const ColorJsonConverter().fromJson(
    (json['headerBannerTextColor'] as num).toInt(),
  ),
  participantAccentStripColor: const ColorJsonConverter().fromJson(
    (json['participantAccentStripColor'] as num).toInt(),
  ),
  blueCornerColor: const ColorJsonConverter().fromJson(
    (json['blueCornerColor'] as num).toInt(),
  ),
  redCornerColor: const ColorJsonConverter().fromJson(
    (json['redCornerColor'] as num).toInt(),
  ),
  winnersLabelColor: const ColorJsonConverter().fromJson(
    (json['winnersLabelColor'] as num).toInt(),
  ),
  losersLabelColor: const ColorJsonConverter().fromJson(
    (json['losersLabelColor'] as num).toInt(),
  ),
  medalGoldFillColor: const ColorJsonConverter().fromJson(
    (json['medalGoldFillColor'] as num).toInt(),
  ),
  medalSilverFillColor: const ColorJsonConverter().fromJson(
    (json['medalSilverFillColor'] as num).toInt(),
  ),
  medalBronzeFillColor: const ColorJsonConverter().fromJson(
    (json['medalBronzeFillColor'] as num).toInt(),
  ),
  medalGoldTextColor: const ColorJsonConverter().fromJson(
    (json['medalGoldTextColor'] as num).toInt(),
  ),
  medalSilverTextColor: const ColorJsonConverter().fromJson(
    (json['medalSilverTextColor'] as num).toInt(),
  ),
  medalBronzeTextColor: const ColorJsonConverter().fromJson(
    (json['medalBronzeTextColor'] as num).toInt(),
  ),
  medalGoldAccentColor: const ColorJsonConverter().fromJson(
    (json['medalGoldAccentColor'] as num).toInt(),
  ),
  medalSilverAccentColor: const ColorJsonConverter().fromJson(
    (json['medalSilverAccentColor'] as num).toInt(),
  ),
  medalBronzeAccentColor: const ColorJsonConverter().fromJson(
    (json['medalBronzeAccentColor'] as num).toInt(),
  ),
  borderStrokeWidth: (json['borderStrokeWidth'] as num).toDouble(),
  subtleStrokeWidth: (json['subtleStrokeWidth'] as num).toDouble(),
  wonConnectorStrokeWidth: (json['wonConnectorStrokeWidth'] as num).toDouble(),
  canvasMargin: (json['canvasMargin'] as num).toDouble(),
  sectionGapHeight: (json['sectionGapHeight'] as num).toDouble(),
  accentStripWidth: (json['accentStripWidth'] as num).toDouble(),
  badgeMinHalfSize: (json['badgeMinHalfSize'] as num).toDouble(),
  badgePadding: (json['badgePadding'] as num).toDouble(),
  matchPillMinHalfWidth: (json['matchPillMinHalfWidth'] as num).toDouble(),
  matchPillHorizontalPadding: (json['matchPillHorizontalPadding'] as num)
      .toDouble(),
  matchPillMinHalfHeight: (json['matchPillMinHalfHeight'] as num).toDouble(),
  matchPillVerticalPadding: (json['matchPillVerticalPadding'] as num)
      .toDouble(),
  dashedLineDashWidth: (json['dashedLineDashWidth'] as num).toDouble(),
  dashedLineGapWidth: (json['dashedLineGapWidth'] as num).toDouble(),
  fontFamily: json['fontFamily'] as String,
  headerLetterSpacing: (json['headerLetterSpacing'] as num).toDouble(),
  subHeaderLetterSpacing: (json['subHeaderLetterSpacing'] as num).toDouble(),
  rowHeight: (json['rowHeight'] as num).toDouble(),
  intraMatchGapHeight: (json['intraMatchGapHeight'] as num).toDouble(),
  interMatchGapHeight: (json['interMatchGapHeight'] as num).toDouble(),
  numberColumnWidth: (json['numberColumnWidth'] as num).toDouble(),
  nameColumnWidth: (json['nameColumnWidth'] as num).toDouble(),
  registrationIdColumnWidth: (json['registrationIdColumnWidth'] as num)
      .toDouble(),
  roundColumnWidth: (json['roundColumnWidth'] as num).toDouble(),
  headerTotalHeight: (json['headerTotalHeight'] as num).toDouble(),
  subHeaderRowHeight: (json['subHeaderRowHeight'] as num).toDouble(),
  centerGapWidth: (json['centerGapWidth'] as num).toDouble(),
  sectionLabelHeight: (json['sectionLabelHeight'] as num).toDouble(),
  medalTableWidth: (json['medalTableWidth'] as num).toDouble(),
  medalRowHeight: (json['medalRowHeight'] as num).toDouble(),
  medalNameColumnWidth: (json['medalNameColumnWidth'] as num).toDouble(),
  medalLabelColumnWidth: (json['medalLabelColumnWidth'] as num).toDouble(),
  medalRowGap: (json['medalRowGap'] as num).toDouble(),
  centerFinalMinimumSpan: (json['centerFinalMinimumSpan'] as num).toDouble(),
  grandFinalOutputArmLength: (json['grandFinalOutputArmLength'] as num)
      .toDouble(),
  badgeHorizontalOffset: (json['badgeHorizontalOffset'] as num).toDouble(),
  badgeBlueVerticalOffset: (json['badgeBlueVerticalOffset'] as num).toDouble(),
  badgeRedVerticalOffset: (json['badgeRedVerticalOffset'] as num).toDouble(),
  missingInputVerticalOffset: (json['missingInputVerticalOffset'] as num)
      .toDouble(),
  thirdPlaceToMedalGap: (json['thirdPlaceToMedalGap'] as num).toDouble(),
  matchPillHorizontalOffset: (json['matchPillHorizontalOffset'] as num)
      .toDouble(),
  headerBannerHeight: (json['headerBannerHeight'] as num).toDouble(),
  logoMaxHeight: (json['logoMaxHeight'] as num).toDouble(),
  logoPadding: (json['logoPadding'] as num).toDouble(),
  matchPillFillColor: const ColorJsonConverter().fromJson(
    (json['matchPillFillColor'] as num).toInt(),
  ),
  badgeTextColor: const ColorJsonConverter().fromJson(
    (json['badgeTextColor'] as num).toInt(),
  ),
  sectionLabelBackgroundOpacity: (json['sectionLabelBackgroundOpacity'] as num)
      .toDouble(),
  headerSecondaryTextOpacity: (json['headerSecondaryTextOpacity'] as num)
      .toDouble(),
  badgeOutlineOpacity: (json['badgeOutlineOpacity'] as num).toDouble(),
  canvasMinimumWidth: (json['canvasMinimumWidth'] as num).toDouble(),
  canvasMinimumHeight: (json['canvasMinimumHeight'] as num).toDouble(),
  headerTitleTopPadding: (json['headerTitleTopPadding'] as num).toDouble(),
  headerSubtitleTopOffset: (json['headerSubtitleTopOffset'] as num).toDouble(),
  headerOrganizerTopOffset: (json['headerOrganizerTopOffset'] as num)
      .toDouble(),
  headerBannerBottomGap: (json['headerBannerBottomGap'] as num).toDouble(),
  headerToTableGap: (json['headerToTableGap'] as num).toDouble(),
  sectionLabelToTableGap: (json['sectionLabelToTableGap'] as num).toDouble(),
  deCanvasBracketToMedalGap: (json['deCanvasBracketToMedalGap'] as num)
      .toDouble(),
  medalTableTopPadding: (json['medalTableTopPadding'] as num).toDouble(),
  deCanvasExtraWidthPadding: (json['deCanvasExtraWidthPadding'] as num)
      .toDouble(),
  classificationDividerInset: (json['classificationDividerInset'] as num)
      .toDouble(),
  headerTitleBaseFontSize: (json['headerTitleBaseFontSize'] as num).toDouble(),
  headerSubtitleBaseFontSize: (json['headerSubtitleBaseFontSize'] as num)
      .toDouble(),
  headerOrganizerBaseFontSize: (json['headerOrganizerBaseFontSize'] as num)
      .toDouble(),
  matchPillBaseFontSize: (json['matchPillBaseFontSize'] as num).toDouble(),
);

Map<String, dynamic> _$TieSheetThemeConfigToJson(
  _TieSheetThemeConfig instance,
) => <String, dynamic>{
  'mutedColor': const ColorJsonConverter().toJson(instance.mutedColor),
  'connectorWonColor': const ColorJsonConverter().toJson(
    instance.connectorWonColor,
  ),
  'canvasBackgroundColor': const ColorJsonConverter().toJson(
    instance.canvasBackgroundColor,
  ),
  'borderColor': const ColorJsonConverter().toJson(instance.borderColor),
  'connectorStrokeWidth': instance.connectorStrokeWidth,
  'isInteractivityDisabled': instance.isInteractivityDisabled,
  'primaryTextColor': const ColorJsonConverter().toJson(
    instance.primaryTextColor,
  ),
  'secondaryTextColor': const ColorJsonConverter().toJson(
    instance.secondaryTextColor,
  ),
  'isTextForceBold': instance.isTextForceBold,
  'fontSizeDelta': instance.fontSizeDelta,
  'rowFillColor': const ColorJsonConverter().toJson(instance.rowFillColor),
  'headerFillColor': const ColorJsonConverter().toJson(
    instance.headerFillColor,
  ),
  'tbdFillColor': const ColorJsonConverter().toJson(instance.tbdFillColor),
  'headerBannerBackgroundColor': const ColorJsonConverter().toJson(
    instance.headerBannerBackgroundColor,
  ),
  'headerBannerTextColor': const ColorJsonConverter().toJson(
    instance.headerBannerTextColor,
  ),
  'participantAccentStripColor': const ColorJsonConverter().toJson(
    instance.participantAccentStripColor,
  ),
  'blueCornerColor': const ColorJsonConverter().toJson(
    instance.blueCornerColor,
  ),
  'redCornerColor': const ColorJsonConverter().toJson(instance.redCornerColor),
  'winnersLabelColor': const ColorJsonConverter().toJson(
    instance.winnersLabelColor,
  ),
  'losersLabelColor': const ColorJsonConverter().toJson(
    instance.losersLabelColor,
  ),
  'medalGoldFillColor': const ColorJsonConverter().toJson(
    instance.medalGoldFillColor,
  ),
  'medalSilverFillColor': const ColorJsonConverter().toJson(
    instance.medalSilverFillColor,
  ),
  'medalBronzeFillColor': const ColorJsonConverter().toJson(
    instance.medalBronzeFillColor,
  ),
  'medalGoldTextColor': const ColorJsonConverter().toJson(
    instance.medalGoldTextColor,
  ),
  'medalSilverTextColor': const ColorJsonConverter().toJson(
    instance.medalSilverTextColor,
  ),
  'medalBronzeTextColor': const ColorJsonConverter().toJson(
    instance.medalBronzeTextColor,
  ),
  'medalGoldAccentColor': const ColorJsonConverter().toJson(
    instance.medalGoldAccentColor,
  ),
  'medalSilverAccentColor': const ColorJsonConverter().toJson(
    instance.medalSilverAccentColor,
  ),
  'medalBronzeAccentColor': const ColorJsonConverter().toJson(
    instance.medalBronzeAccentColor,
  ),
  'borderStrokeWidth': instance.borderStrokeWidth,
  'subtleStrokeWidth': instance.subtleStrokeWidth,
  'wonConnectorStrokeWidth': instance.wonConnectorStrokeWidth,
  'canvasMargin': instance.canvasMargin,
  'sectionGapHeight': instance.sectionGapHeight,
  'accentStripWidth': instance.accentStripWidth,
  'badgeMinHalfSize': instance.badgeMinHalfSize,
  'badgePadding': instance.badgePadding,
  'matchPillMinHalfWidth': instance.matchPillMinHalfWidth,
  'matchPillHorizontalPadding': instance.matchPillHorizontalPadding,
  'matchPillMinHalfHeight': instance.matchPillMinHalfHeight,
  'matchPillVerticalPadding': instance.matchPillVerticalPadding,
  'dashedLineDashWidth': instance.dashedLineDashWidth,
  'dashedLineGapWidth': instance.dashedLineGapWidth,
  'fontFamily': instance.fontFamily,
  'headerLetterSpacing': instance.headerLetterSpacing,
  'subHeaderLetterSpacing': instance.subHeaderLetterSpacing,
  'rowHeight': instance.rowHeight,
  'intraMatchGapHeight': instance.intraMatchGapHeight,
  'interMatchGapHeight': instance.interMatchGapHeight,
  'numberColumnWidth': instance.numberColumnWidth,
  'nameColumnWidth': instance.nameColumnWidth,
  'registrationIdColumnWidth': instance.registrationIdColumnWidth,
  'roundColumnWidth': instance.roundColumnWidth,
  'headerTotalHeight': instance.headerTotalHeight,
  'subHeaderRowHeight': instance.subHeaderRowHeight,
  'centerGapWidth': instance.centerGapWidth,
  'sectionLabelHeight': instance.sectionLabelHeight,
  'medalTableWidth': instance.medalTableWidth,
  'medalRowHeight': instance.medalRowHeight,
  'medalNameColumnWidth': instance.medalNameColumnWidth,
  'medalLabelColumnWidth': instance.medalLabelColumnWidth,
  'medalRowGap': instance.medalRowGap,
  'centerFinalMinimumSpan': instance.centerFinalMinimumSpan,
  'grandFinalOutputArmLength': instance.grandFinalOutputArmLength,
  'badgeHorizontalOffset': instance.badgeHorizontalOffset,
  'badgeBlueVerticalOffset': instance.badgeBlueVerticalOffset,
  'badgeRedVerticalOffset': instance.badgeRedVerticalOffset,
  'missingInputVerticalOffset': instance.missingInputVerticalOffset,
  'thirdPlaceToMedalGap': instance.thirdPlaceToMedalGap,
  'matchPillHorizontalOffset': instance.matchPillHorizontalOffset,
  'headerBannerHeight': instance.headerBannerHeight,
  'logoMaxHeight': instance.logoMaxHeight,
  'logoPadding': instance.logoPadding,
  'matchPillFillColor': const ColorJsonConverter().toJson(
    instance.matchPillFillColor,
  ),
  'badgeTextColor': const ColorJsonConverter().toJson(instance.badgeTextColor),
  'sectionLabelBackgroundOpacity': instance.sectionLabelBackgroundOpacity,
  'headerSecondaryTextOpacity': instance.headerSecondaryTextOpacity,
  'badgeOutlineOpacity': instance.badgeOutlineOpacity,
  'canvasMinimumWidth': instance.canvasMinimumWidth,
  'canvasMinimumHeight': instance.canvasMinimumHeight,
  'headerTitleTopPadding': instance.headerTitleTopPadding,
  'headerSubtitleTopOffset': instance.headerSubtitleTopOffset,
  'headerOrganizerTopOffset': instance.headerOrganizerTopOffset,
  'headerBannerBottomGap': instance.headerBannerBottomGap,
  'headerToTableGap': instance.headerToTableGap,
  'sectionLabelToTableGap': instance.sectionLabelToTableGap,
  'deCanvasBracketToMedalGap': instance.deCanvasBracketToMedalGap,
  'medalTableTopPadding': instance.medalTableTopPadding,
  'deCanvasExtraWidthPadding': instance.deCanvasExtraWidthPadding,
  'classificationDividerInset': instance.classificationDividerInset,
  'headerTitleBaseFontSize': instance.headerTitleBaseFontSize,
  'headerSubtitleBaseFontSize': instance.headerSubtitleBaseFontSize,
  'headerOrganizerBaseFontSize': instance.headerOrganizerBaseFontSize,
  'matchPillBaseFontSize': instance.matchPillBaseFontSize,
};

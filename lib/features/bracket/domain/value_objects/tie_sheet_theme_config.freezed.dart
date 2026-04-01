// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tie_sheet_theme_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TieSheetThemeConfig {

// ── Connector / junction tokens ─────────────────────────────────────────
/// Muted colour used for generic connectors, BYE dashed lines,
/// TBD placeholder text, and unresolved junction lines.
@ColorJsonConverter() Color get mutedColor;/// Resolved connector stroke colour (winner advancement lines).
@ColorJsonConverter() Color get connectorWonColor;// ── Canvas & card tokens ────────────────────────────────────────────────
/// Canvas background fill.
@ColorJsonConverter() Color get canvasBackgroundColor;/// Unified border stroke colour for cards, TBD outlines, and pending
/// dashed connectors.
@ColorJsonConverter() Color get borderColor;/// Uniform stroke width for all connector / junction lines.
/// In default mode each pen chooses its own width.
/// In print mode a single uniform value is used for all connectors.
 double get connectorStrokeWidth;/// When `true`, all interactive overlays (match taps, drag-swap,
/// participant slot taps) are suppressed on the canvas widget.
 bool get isInteractivityDisabled;// ── Text tokens ─────────────────────────────────────────────────────────
/// Primary text colour (headings, names, numbers).
@ColorJsonConverter() Color get primaryTextColor;/// Secondary text colour (subtle / supporting text).
@ColorJsonConverter() Color get secondaryTextColor;/// When `true`, **every** text span is rendered bold regardless of
/// the font-weight specified by the painter.
 bool get isTextForceBold;/// Additive font-size adjustment applied to **every** text span.
 double get fontSizeDelta;// ── Fill tokens ─────────────────────────────────────────────────────────
/// Participant card background fill.
@ColorJsonConverter() Color get rowFillColor;/// Info-row / sub-header background fill.
@ColorJsonConverter() Color get headerFillColor;/// TBD placeholder card background fill.
@ColorJsonConverter() Color get tbdFillColor;// ── Header banner ───────────────────────────────────────────────────────
/// Top banner background colour.
@ColorJsonConverter() Color get headerBannerBackgroundColor;/// Top banner text colour.
@ColorJsonConverter() Color get headerBannerTextColor;// ── Accent & badge tokens ───────────────────────────────────────────────
/// Participant row accent strip colour (left/right edge coloured strip).
@ColorJsonConverter() Color get participantAccentStripColor;/// Blue-corner badge colour.
@ColorJsonConverter() Color get blueCornerColor;/// Red-corner badge colour.
@ColorJsonConverter() Color get redCornerColor;// ── Section label tokens (DE brackets) ──────────────────────────────────
/// Winners bracket section-label colour.
@ColorJsonConverter() Color get winnersLabelColor;/// Losers bracket section-label colour.
@ColorJsonConverter() Color get losersLabelColor;// ── Medal table tokens ──────────────────────────────────────────────────
@ColorJsonConverter() Color get medalGoldFillColor;@ColorJsonConverter() Color get medalSilverFillColor;@ColorJsonConverter() Color get medalBronzeFillColor;@ColorJsonConverter() Color get medalGoldTextColor;@ColorJsonConverter() Color get medalSilverTextColor;@ColorJsonConverter() Color get medalBronzeTextColor;@ColorJsonConverter() Color get medalGoldAccentColor;@ColorJsonConverter() Color get medalSilverAccentColor;@ColorJsonConverter() Color get medalBronzeAccentColor;// ── Shape / radius tokens ───────────────────────────────────────────────
/// Unified border radius applied to all rectangular UI elements.
 double get elementBorderRadius;/// Corner radius for the Bezier curve arms on bracket junctions.
 double get junctionCornerRadius;// ── Stroke width tokens ─────────────────────────────────────────────────
/// Primary stroke width for borders, outlines, dividers, and pending
/// connector lines.
 double get borderStrokeWidth;/// Subtle stroke width for secondary borders.
 double get subtleStrokeWidth;/// Stroke width for resolved / won connector lines.
 double get wonConnectorStrokeWidth;// ── Spacing tokens ──────────────────────────────────────────────────────
/// Canvas margin (padding around all edges of the canvas).
 double get canvasMargin;/// Vertical gap between Winners and Losers bracket sections (DE only).
 double get sectionGapHeight;/// Width of the coloured accent strip on participant card edges.
 double get accentStripWidth;// ── Badge & pill sizing tokens ──────────────────────────────────────────
/// Minimum radius for corner badges (B / R).
 double get badgeMinRadius;/// Padding added around badge text to compute dynamic radius.
 double get badgePadding;/// Minimum half-width for match number pills.
 double get matchPillMinHalfWidth;/// Horizontal padding for match number pill text.
 double get matchPillHorizontalPadding;/// Minimum half-height for match number pills.
 double get matchPillMinHalfHeight;/// Vertical padding for match number pill text.
 double get matchPillVerticalPadding;// ── Dashed line tokens ──────────────────────────────────────────────────
/// Width of each dash segment in dashed connector lines.
 double get dashedLineDashWidth;/// Gap between dash segments in dashed connector lines.
 double get dashedLineGapWidth;// ── Typography tokens ───────────────────────────────────────────────────
/// Font family applied to all text rendered on the canvas.
 String get fontFamily;/// Letter spacing for the main tournament title in the header banner.
 double get headerLetterSpacing;/// Letter spacing for sub-header text (date, venue) in the header banner.
 double get subHeaderLetterSpacing;// ── Layout dimension base tokens ────────────────────────────────────────
/// Base height of a single participant row (px).
 double get rowHeight;/// Vertical gap between blue & red rows within a single match (px).
 double get intraMatchGapHeight;/// Vertical gap between consecutive match pairs (px).
 double get interMatchGapHeight;/// Width of the serial-number column (px).
 double get numberColumnWidth;/// Width of the participant name column (px).
 double get nameColumnWidth;/// Width of the registration-ID column (px).
 double get registrationIdColumnWidth;/// Width of each bracket round column (px).
 double get roundColumnWidth;/// Total height of the full header area (banner + info row, px).
 double get headerTotalHeight;/// Height of the tournament info sub-header row (px).
 double get subHeaderRowHeight;/// Horizontal gap between left and right bracket halves (SE only, px).
 double get centerGapWidth;/// Height of the Winners/Losers section label bar (px).
 double get sectionLabelHeight;// ── Medal table layout tokens ───────────────────────────────────────────
/// Total width of the medal table (px).
 double get medalTableWidth;/// Height of each medal row (px).
 double get medalRowHeight;/// Width of the name column inside the medal table (px).
 double get medalNameColumnWidth;/// Width of the label column inside the medal table (px).
 double get medalLabelColumnWidth;/// Vertical gap between medal rows (px).
 double get medalRowGap;// ── Junction geometry tokens ────────────────────────────────────────────
/// Minimum vertical span for center-final junction arms (px).
 double get centerFinalMinimumSpan;/// Horizontal arm length for grand-final output connector (px).
 double get grandFinalOutputArmLength;/// Horizontal offset for corner badges relative to junction center (px).
 double get badgeHorizontalOffset;/// Vertical offset for blue corner badge from junction arm (px).
 double get badgeBlueVerticalOffset;/// Vertical offset for red corner badge from junction arm (px).
 double get badgeRedVerticalOffset;/// Vertical offset for missing input placeholder from junction center (px).
 double get missingInputVerticalOffset;/// Vertical gap between 3rd place match and medal table (px).
 double get thirdPlaceToMedalGap;/// Horizontal offset for match number pill relative to junction center (px).
 double get matchPillHorizontalOffset;// ── Banner & logo layout tokens ─────────────────────────────────────────
/// Base height of the dark header banner (before fontSizeDelta scaling, px).
 double get headerBannerHeight;/// Maximum display height for logo images (px).
 double get logoMaxHeight;/// Padding below the logo row before the header banner starts (px).
 double get logoPadding;// ── Color tokens (additional) ───────────────────────────────────────────
/// Fill colour for match number pills.
@ColorJsonConverter() Color get matchPillFillColor;/// Text colour inside corner badges (B / R).
@ColorJsonConverter() Color get badgeTextColor;// ── Opacity tokens ──────────────────────────────────────────────────────
/// Background opacity for section label fill (0.0–1.0).
 double get sectionLabelBackgroundOpacity;/// Text opacity for secondary header text (subtitle + organizer, 0.0–1.0).
 double get headerSecondaryTextOpacity;/// Outline opacity for corner badges B/R (0.0–1.0).
 double get badgeOutlineOpacity;// ── Canvas constraint tokens ────────────────────────────────────────────
/// Minimum canvas width in logical pixels.
 double get canvasMinimumWidth;/// Minimum canvas height in logical pixels.
 double get canvasMinimumHeight;
/// Create a copy of TieSheetThemeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TieSheetThemeConfigCopyWith<TieSheetThemeConfig> get copyWith => _$TieSheetThemeConfigCopyWithImpl<TieSheetThemeConfig>(this as TieSheetThemeConfig, _$identity);

  /// Serializes this TieSheetThemeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TieSheetThemeConfig&&(identical(other.mutedColor, mutedColor) || other.mutedColor == mutedColor)&&(identical(other.connectorWonColor, connectorWonColor) || other.connectorWonColor == connectorWonColor)&&(identical(other.canvasBackgroundColor, canvasBackgroundColor) || other.canvasBackgroundColor == canvasBackgroundColor)&&(identical(other.borderColor, borderColor) || other.borderColor == borderColor)&&(identical(other.connectorStrokeWidth, connectorStrokeWidth) || other.connectorStrokeWidth == connectorStrokeWidth)&&(identical(other.isInteractivityDisabled, isInteractivityDisabled) || other.isInteractivityDisabled == isInteractivityDisabled)&&(identical(other.primaryTextColor, primaryTextColor) || other.primaryTextColor == primaryTextColor)&&(identical(other.secondaryTextColor, secondaryTextColor) || other.secondaryTextColor == secondaryTextColor)&&(identical(other.isTextForceBold, isTextForceBold) || other.isTextForceBold == isTextForceBold)&&(identical(other.fontSizeDelta, fontSizeDelta) || other.fontSizeDelta == fontSizeDelta)&&(identical(other.rowFillColor, rowFillColor) || other.rowFillColor == rowFillColor)&&(identical(other.headerFillColor, headerFillColor) || other.headerFillColor == headerFillColor)&&(identical(other.tbdFillColor, tbdFillColor) || other.tbdFillColor == tbdFillColor)&&(identical(other.headerBannerBackgroundColor, headerBannerBackgroundColor) || other.headerBannerBackgroundColor == headerBannerBackgroundColor)&&(identical(other.headerBannerTextColor, headerBannerTextColor) || other.headerBannerTextColor == headerBannerTextColor)&&(identical(other.participantAccentStripColor, participantAccentStripColor) || other.participantAccentStripColor == participantAccentStripColor)&&(identical(other.blueCornerColor, blueCornerColor) || other.blueCornerColor == blueCornerColor)&&(identical(other.redCornerColor, redCornerColor) || other.redCornerColor == redCornerColor)&&(identical(other.winnersLabelColor, winnersLabelColor) || other.winnersLabelColor == winnersLabelColor)&&(identical(other.losersLabelColor, losersLabelColor) || other.losersLabelColor == losersLabelColor)&&(identical(other.medalGoldFillColor, medalGoldFillColor) || other.medalGoldFillColor == medalGoldFillColor)&&(identical(other.medalSilverFillColor, medalSilverFillColor) || other.medalSilverFillColor == medalSilverFillColor)&&(identical(other.medalBronzeFillColor, medalBronzeFillColor) || other.medalBronzeFillColor == medalBronzeFillColor)&&(identical(other.medalGoldTextColor, medalGoldTextColor) || other.medalGoldTextColor == medalGoldTextColor)&&(identical(other.medalSilverTextColor, medalSilverTextColor) || other.medalSilverTextColor == medalSilverTextColor)&&(identical(other.medalBronzeTextColor, medalBronzeTextColor) || other.medalBronzeTextColor == medalBronzeTextColor)&&(identical(other.medalGoldAccentColor, medalGoldAccentColor) || other.medalGoldAccentColor == medalGoldAccentColor)&&(identical(other.medalSilverAccentColor, medalSilverAccentColor) || other.medalSilverAccentColor == medalSilverAccentColor)&&(identical(other.medalBronzeAccentColor, medalBronzeAccentColor) || other.medalBronzeAccentColor == medalBronzeAccentColor)&&(identical(other.elementBorderRadius, elementBorderRadius) || other.elementBorderRadius == elementBorderRadius)&&(identical(other.junctionCornerRadius, junctionCornerRadius) || other.junctionCornerRadius == junctionCornerRadius)&&(identical(other.borderStrokeWidth, borderStrokeWidth) || other.borderStrokeWidth == borderStrokeWidth)&&(identical(other.subtleStrokeWidth, subtleStrokeWidth) || other.subtleStrokeWidth == subtleStrokeWidth)&&(identical(other.wonConnectorStrokeWidth, wonConnectorStrokeWidth) || other.wonConnectorStrokeWidth == wonConnectorStrokeWidth)&&(identical(other.canvasMargin, canvasMargin) || other.canvasMargin == canvasMargin)&&(identical(other.sectionGapHeight, sectionGapHeight) || other.sectionGapHeight == sectionGapHeight)&&(identical(other.accentStripWidth, accentStripWidth) || other.accentStripWidth == accentStripWidth)&&(identical(other.badgeMinRadius, badgeMinRadius) || other.badgeMinRadius == badgeMinRadius)&&(identical(other.badgePadding, badgePadding) || other.badgePadding == badgePadding)&&(identical(other.matchPillMinHalfWidth, matchPillMinHalfWidth) || other.matchPillMinHalfWidth == matchPillMinHalfWidth)&&(identical(other.matchPillHorizontalPadding, matchPillHorizontalPadding) || other.matchPillHorizontalPadding == matchPillHorizontalPadding)&&(identical(other.matchPillMinHalfHeight, matchPillMinHalfHeight) || other.matchPillMinHalfHeight == matchPillMinHalfHeight)&&(identical(other.matchPillVerticalPadding, matchPillVerticalPadding) || other.matchPillVerticalPadding == matchPillVerticalPadding)&&(identical(other.dashedLineDashWidth, dashedLineDashWidth) || other.dashedLineDashWidth == dashedLineDashWidth)&&(identical(other.dashedLineGapWidth, dashedLineGapWidth) || other.dashedLineGapWidth == dashedLineGapWidth)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.headerLetterSpacing, headerLetterSpacing) || other.headerLetterSpacing == headerLetterSpacing)&&(identical(other.subHeaderLetterSpacing, subHeaderLetterSpacing) || other.subHeaderLetterSpacing == subHeaderLetterSpacing)&&(identical(other.rowHeight, rowHeight) || other.rowHeight == rowHeight)&&(identical(other.intraMatchGapHeight, intraMatchGapHeight) || other.intraMatchGapHeight == intraMatchGapHeight)&&(identical(other.interMatchGapHeight, interMatchGapHeight) || other.interMatchGapHeight == interMatchGapHeight)&&(identical(other.numberColumnWidth, numberColumnWidth) || other.numberColumnWidth == numberColumnWidth)&&(identical(other.nameColumnWidth, nameColumnWidth) || other.nameColumnWidth == nameColumnWidth)&&(identical(other.registrationIdColumnWidth, registrationIdColumnWidth) || other.registrationIdColumnWidth == registrationIdColumnWidth)&&(identical(other.roundColumnWidth, roundColumnWidth) || other.roundColumnWidth == roundColumnWidth)&&(identical(other.headerTotalHeight, headerTotalHeight) || other.headerTotalHeight == headerTotalHeight)&&(identical(other.subHeaderRowHeight, subHeaderRowHeight) || other.subHeaderRowHeight == subHeaderRowHeight)&&(identical(other.centerGapWidth, centerGapWidth) || other.centerGapWidth == centerGapWidth)&&(identical(other.sectionLabelHeight, sectionLabelHeight) || other.sectionLabelHeight == sectionLabelHeight)&&(identical(other.medalTableWidth, medalTableWidth) || other.medalTableWidth == medalTableWidth)&&(identical(other.medalRowHeight, medalRowHeight) || other.medalRowHeight == medalRowHeight)&&(identical(other.medalNameColumnWidth, medalNameColumnWidth) || other.medalNameColumnWidth == medalNameColumnWidth)&&(identical(other.medalLabelColumnWidth, medalLabelColumnWidth) || other.medalLabelColumnWidth == medalLabelColumnWidth)&&(identical(other.medalRowGap, medalRowGap) || other.medalRowGap == medalRowGap)&&(identical(other.centerFinalMinimumSpan, centerFinalMinimumSpan) || other.centerFinalMinimumSpan == centerFinalMinimumSpan)&&(identical(other.grandFinalOutputArmLength, grandFinalOutputArmLength) || other.grandFinalOutputArmLength == grandFinalOutputArmLength)&&(identical(other.badgeHorizontalOffset, badgeHorizontalOffset) || other.badgeHorizontalOffset == badgeHorizontalOffset)&&(identical(other.badgeBlueVerticalOffset, badgeBlueVerticalOffset) || other.badgeBlueVerticalOffset == badgeBlueVerticalOffset)&&(identical(other.badgeRedVerticalOffset, badgeRedVerticalOffset) || other.badgeRedVerticalOffset == badgeRedVerticalOffset)&&(identical(other.missingInputVerticalOffset, missingInputVerticalOffset) || other.missingInputVerticalOffset == missingInputVerticalOffset)&&(identical(other.thirdPlaceToMedalGap, thirdPlaceToMedalGap) || other.thirdPlaceToMedalGap == thirdPlaceToMedalGap)&&(identical(other.matchPillHorizontalOffset, matchPillHorizontalOffset) || other.matchPillHorizontalOffset == matchPillHorizontalOffset)&&(identical(other.headerBannerHeight, headerBannerHeight) || other.headerBannerHeight == headerBannerHeight)&&(identical(other.logoMaxHeight, logoMaxHeight) || other.logoMaxHeight == logoMaxHeight)&&(identical(other.logoPadding, logoPadding) || other.logoPadding == logoPadding)&&(identical(other.matchPillFillColor, matchPillFillColor) || other.matchPillFillColor == matchPillFillColor)&&(identical(other.badgeTextColor, badgeTextColor) || other.badgeTextColor == badgeTextColor)&&(identical(other.sectionLabelBackgroundOpacity, sectionLabelBackgroundOpacity) || other.sectionLabelBackgroundOpacity == sectionLabelBackgroundOpacity)&&(identical(other.headerSecondaryTextOpacity, headerSecondaryTextOpacity) || other.headerSecondaryTextOpacity == headerSecondaryTextOpacity)&&(identical(other.badgeOutlineOpacity, badgeOutlineOpacity) || other.badgeOutlineOpacity == badgeOutlineOpacity)&&(identical(other.canvasMinimumWidth, canvasMinimumWidth) || other.canvasMinimumWidth == canvasMinimumWidth)&&(identical(other.canvasMinimumHeight, canvasMinimumHeight) || other.canvasMinimumHeight == canvasMinimumHeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,mutedColor,connectorWonColor,canvasBackgroundColor,borderColor,connectorStrokeWidth,isInteractivityDisabled,primaryTextColor,secondaryTextColor,isTextForceBold,fontSizeDelta,rowFillColor,headerFillColor,tbdFillColor,headerBannerBackgroundColor,headerBannerTextColor,participantAccentStripColor,blueCornerColor,redCornerColor,winnersLabelColor,losersLabelColor,medalGoldFillColor,medalSilverFillColor,medalBronzeFillColor,medalGoldTextColor,medalSilverTextColor,medalBronzeTextColor,medalGoldAccentColor,medalSilverAccentColor,medalBronzeAccentColor,elementBorderRadius,junctionCornerRadius,borderStrokeWidth,subtleStrokeWidth,wonConnectorStrokeWidth,canvasMargin,sectionGapHeight,accentStripWidth,badgeMinRadius,badgePadding,matchPillMinHalfWidth,matchPillHorizontalPadding,matchPillMinHalfHeight,matchPillVerticalPadding,dashedLineDashWidth,dashedLineGapWidth,fontFamily,headerLetterSpacing,subHeaderLetterSpacing,rowHeight,intraMatchGapHeight,interMatchGapHeight,numberColumnWidth,nameColumnWidth,registrationIdColumnWidth,roundColumnWidth,headerTotalHeight,subHeaderRowHeight,centerGapWidth,sectionLabelHeight,medalTableWidth,medalRowHeight,medalNameColumnWidth,medalLabelColumnWidth,medalRowGap,centerFinalMinimumSpan,grandFinalOutputArmLength,badgeHorizontalOffset,badgeBlueVerticalOffset,badgeRedVerticalOffset,missingInputVerticalOffset,thirdPlaceToMedalGap,matchPillHorizontalOffset,headerBannerHeight,logoMaxHeight,logoPadding,matchPillFillColor,badgeTextColor,sectionLabelBackgroundOpacity,headerSecondaryTextOpacity,badgeOutlineOpacity,canvasMinimumWidth,canvasMinimumHeight]);



}

/// @nodoc
abstract mixin class $TieSheetThemeConfigCopyWith<$Res>  {
  factory $TieSheetThemeConfigCopyWith(TieSheetThemeConfig value, $Res Function(TieSheetThemeConfig) _then) = _$TieSheetThemeConfigCopyWithImpl;
@useResult
$Res call({
@ColorJsonConverter() Color mutedColor,@ColorJsonConverter() Color connectorWonColor,@ColorJsonConverter() Color canvasBackgroundColor,@ColorJsonConverter() Color borderColor, double connectorStrokeWidth, bool isInteractivityDisabled,@ColorJsonConverter() Color primaryTextColor,@ColorJsonConverter() Color secondaryTextColor, bool isTextForceBold, double fontSizeDelta,@ColorJsonConverter() Color rowFillColor,@ColorJsonConverter() Color headerFillColor,@ColorJsonConverter() Color tbdFillColor,@ColorJsonConverter() Color headerBannerBackgroundColor,@ColorJsonConverter() Color headerBannerTextColor,@ColorJsonConverter() Color participantAccentStripColor,@ColorJsonConverter() Color blueCornerColor,@ColorJsonConverter() Color redCornerColor,@ColorJsonConverter() Color winnersLabelColor,@ColorJsonConverter() Color losersLabelColor,@ColorJsonConverter() Color medalGoldFillColor,@ColorJsonConverter() Color medalSilverFillColor,@ColorJsonConverter() Color medalBronzeFillColor,@ColorJsonConverter() Color medalGoldTextColor,@ColorJsonConverter() Color medalSilverTextColor,@ColorJsonConverter() Color medalBronzeTextColor,@ColorJsonConverter() Color medalGoldAccentColor,@ColorJsonConverter() Color medalSilverAccentColor,@ColorJsonConverter() Color medalBronzeAccentColor, double elementBorderRadius, double junctionCornerRadius, double borderStrokeWidth, double subtleStrokeWidth, double wonConnectorStrokeWidth, double canvasMargin, double sectionGapHeight, double accentStripWidth, double badgeMinRadius, double badgePadding, double matchPillMinHalfWidth, double matchPillHorizontalPadding, double matchPillMinHalfHeight, double matchPillVerticalPadding, double dashedLineDashWidth, double dashedLineGapWidth, String fontFamily, double headerLetterSpacing, double subHeaderLetterSpacing, double rowHeight, double intraMatchGapHeight, double interMatchGapHeight, double numberColumnWidth, double nameColumnWidth, double registrationIdColumnWidth, double roundColumnWidth, double headerTotalHeight, double subHeaderRowHeight, double centerGapWidth, double sectionLabelHeight, double medalTableWidth, double medalRowHeight, double medalNameColumnWidth, double medalLabelColumnWidth, double medalRowGap, double centerFinalMinimumSpan, double grandFinalOutputArmLength, double badgeHorizontalOffset, double badgeBlueVerticalOffset, double badgeRedVerticalOffset, double missingInputVerticalOffset, double thirdPlaceToMedalGap, double matchPillHorizontalOffset, double headerBannerHeight, double logoMaxHeight, double logoPadding,@ColorJsonConverter() Color matchPillFillColor,@ColorJsonConverter() Color badgeTextColor, double sectionLabelBackgroundOpacity, double headerSecondaryTextOpacity, double badgeOutlineOpacity, double canvasMinimumWidth, double canvasMinimumHeight
});




}
/// @nodoc
class _$TieSheetThemeConfigCopyWithImpl<$Res>
    implements $TieSheetThemeConfigCopyWith<$Res> {
  _$TieSheetThemeConfigCopyWithImpl(this._self, this._then);

  final TieSheetThemeConfig _self;
  final $Res Function(TieSheetThemeConfig) _then;

/// Create a copy of TieSheetThemeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mutedColor = null,Object? connectorWonColor = null,Object? canvasBackgroundColor = null,Object? borderColor = null,Object? connectorStrokeWidth = null,Object? isInteractivityDisabled = null,Object? primaryTextColor = null,Object? secondaryTextColor = null,Object? isTextForceBold = null,Object? fontSizeDelta = null,Object? rowFillColor = null,Object? headerFillColor = null,Object? tbdFillColor = null,Object? headerBannerBackgroundColor = null,Object? headerBannerTextColor = null,Object? participantAccentStripColor = null,Object? blueCornerColor = null,Object? redCornerColor = null,Object? winnersLabelColor = null,Object? losersLabelColor = null,Object? medalGoldFillColor = null,Object? medalSilverFillColor = null,Object? medalBronzeFillColor = null,Object? medalGoldTextColor = null,Object? medalSilverTextColor = null,Object? medalBronzeTextColor = null,Object? medalGoldAccentColor = null,Object? medalSilverAccentColor = null,Object? medalBronzeAccentColor = null,Object? elementBorderRadius = null,Object? junctionCornerRadius = null,Object? borderStrokeWidth = null,Object? subtleStrokeWidth = null,Object? wonConnectorStrokeWidth = null,Object? canvasMargin = null,Object? sectionGapHeight = null,Object? accentStripWidth = null,Object? badgeMinRadius = null,Object? badgePadding = null,Object? matchPillMinHalfWidth = null,Object? matchPillHorizontalPadding = null,Object? matchPillMinHalfHeight = null,Object? matchPillVerticalPadding = null,Object? dashedLineDashWidth = null,Object? dashedLineGapWidth = null,Object? fontFamily = null,Object? headerLetterSpacing = null,Object? subHeaderLetterSpacing = null,Object? rowHeight = null,Object? intraMatchGapHeight = null,Object? interMatchGapHeight = null,Object? numberColumnWidth = null,Object? nameColumnWidth = null,Object? registrationIdColumnWidth = null,Object? roundColumnWidth = null,Object? headerTotalHeight = null,Object? subHeaderRowHeight = null,Object? centerGapWidth = null,Object? sectionLabelHeight = null,Object? medalTableWidth = null,Object? medalRowHeight = null,Object? medalNameColumnWidth = null,Object? medalLabelColumnWidth = null,Object? medalRowGap = null,Object? centerFinalMinimumSpan = null,Object? grandFinalOutputArmLength = null,Object? badgeHorizontalOffset = null,Object? badgeBlueVerticalOffset = null,Object? badgeRedVerticalOffset = null,Object? missingInputVerticalOffset = null,Object? thirdPlaceToMedalGap = null,Object? matchPillHorizontalOffset = null,Object? headerBannerHeight = null,Object? logoMaxHeight = null,Object? logoPadding = null,Object? matchPillFillColor = null,Object? badgeTextColor = null,Object? sectionLabelBackgroundOpacity = null,Object? headerSecondaryTextOpacity = null,Object? badgeOutlineOpacity = null,Object? canvasMinimumWidth = null,Object? canvasMinimumHeight = null,}) {
  return _then(_self.copyWith(
mutedColor: null == mutedColor ? _self.mutedColor : mutedColor // ignore: cast_nullable_to_non_nullable
as Color,connectorWonColor: null == connectorWonColor ? _self.connectorWonColor : connectorWonColor // ignore: cast_nullable_to_non_nullable
as Color,canvasBackgroundColor: null == canvasBackgroundColor ? _self.canvasBackgroundColor : canvasBackgroundColor // ignore: cast_nullable_to_non_nullable
as Color,borderColor: null == borderColor ? _self.borderColor : borderColor // ignore: cast_nullable_to_non_nullable
as Color,connectorStrokeWidth: null == connectorStrokeWidth ? _self.connectorStrokeWidth : connectorStrokeWidth // ignore: cast_nullable_to_non_nullable
as double,isInteractivityDisabled: null == isInteractivityDisabled ? _self.isInteractivityDisabled : isInteractivityDisabled // ignore: cast_nullable_to_non_nullable
as bool,primaryTextColor: null == primaryTextColor ? _self.primaryTextColor : primaryTextColor // ignore: cast_nullable_to_non_nullable
as Color,secondaryTextColor: null == secondaryTextColor ? _self.secondaryTextColor : secondaryTextColor // ignore: cast_nullable_to_non_nullable
as Color,isTextForceBold: null == isTextForceBold ? _self.isTextForceBold : isTextForceBold // ignore: cast_nullable_to_non_nullable
as bool,fontSizeDelta: null == fontSizeDelta ? _self.fontSizeDelta : fontSizeDelta // ignore: cast_nullable_to_non_nullable
as double,rowFillColor: null == rowFillColor ? _self.rowFillColor : rowFillColor // ignore: cast_nullable_to_non_nullable
as Color,headerFillColor: null == headerFillColor ? _self.headerFillColor : headerFillColor // ignore: cast_nullable_to_non_nullable
as Color,tbdFillColor: null == tbdFillColor ? _self.tbdFillColor : tbdFillColor // ignore: cast_nullable_to_non_nullable
as Color,headerBannerBackgroundColor: null == headerBannerBackgroundColor ? _self.headerBannerBackgroundColor : headerBannerBackgroundColor // ignore: cast_nullable_to_non_nullable
as Color,headerBannerTextColor: null == headerBannerTextColor ? _self.headerBannerTextColor : headerBannerTextColor // ignore: cast_nullable_to_non_nullable
as Color,participantAccentStripColor: null == participantAccentStripColor ? _self.participantAccentStripColor : participantAccentStripColor // ignore: cast_nullable_to_non_nullable
as Color,blueCornerColor: null == blueCornerColor ? _self.blueCornerColor : blueCornerColor // ignore: cast_nullable_to_non_nullable
as Color,redCornerColor: null == redCornerColor ? _self.redCornerColor : redCornerColor // ignore: cast_nullable_to_non_nullable
as Color,winnersLabelColor: null == winnersLabelColor ? _self.winnersLabelColor : winnersLabelColor // ignore: cast_nullable_to_non_nullable
as Color,losersLabelColor: null == losersLabelColor ? _self.losersLabelColor : losersLabelColor // ignore: cast_nullable_to_non_nullable
as Color,medalGoldFillColor: null == medalGoldFillColor ? _self.medalGoldFillColor : medalGoldFillColor // ignore: cast_nullable_to_non_nullable
as Color,medalSilverFillColor: null == medalSilverFillColor ? _self.medalSilverFillColor : medalSilverFillColor // ignore: cast_nullable_to_non_nullable
as Color,medalBronzeFillColor: null == medalBronzeFillColor ? _self.medalBronzeFillColor : medalBronzeFillColor // ignore: cast_nullable_to_non_nullable
as Color,medalGoldTextColor: null == medalGoldTextColor ? _self.medalGoldTextColor : medalGoldTextColor // ignore: cast_nullable_to_non_nullable
as Color,medalSilverTextColor: null == medalSilverTextColor ? _self.medalSilverTextColor : medalSilverTextColor // ignore: cast_nullable_to_non_nullable
as Color,medalBronzeTextColor: null == medalBronzeTextColor ? _self.medalBronzeTextColor : medalBronzeTextColor // ignore: cast_nullable_to_non_nullable
as Color,medalGoldAccentColor: null == medalGoldAccentColor ? _self.medalGoldAccentColor : medalGoldAccentColor // ignore: cast_nullable_to_non_nullable
as Color,medalSilverAccentColor: null == medalSilverAccentColor ? _self.medalSilverAccentColor : medalSilverAccentColor // ignore: cast_nullable_to_non_nullable
as Color,medalBronzeAccentColor: null == medalBronzeAccentColor ? _self.medalBronzeAccentColor : medalBronzeAccentColor // ignore: cast_nullable_to_non_nullable
as Color,elementBorderRadius: null == elementBorderRadius ? _self.elementBorderRadius : elementBorderRadius // ignore: cast_nullable_to_non_nullable
as double,junctionCornerRadius: null == junctionCornerRadius ? _self.junctionCornerRadius : junctionCornerRadius // ignore: cast_nullable_to_non_nullable
as double,borderStrokeWidth: null == borderStrokeWidth ? _self.borderStrokeWidth : borderStrokeWidth // ignore: cast_nullable_to_non_nullable
as double,subtleStrokeWidth: null == subtleStrokeWidth ? _self.subtleStrokeWidth : subtleStrokeWidth // ignore: cast_nullable_to_non_nullable
as double,wonConnectorStrokeWidth: null == wonConnectorStrokeWidth ? _self.wonConnectorStrokeWidth : wonConnectorStrokeWidth // ignore: cast_nullable_to_non_nullable
as double,canvasMargin: null == canvasMargin ? _self.canvasMargin : canvasMargin // ignore: cast_nullable_to_non_nullable
as double,sectionGapHeight: null == sectionGapHeight ? _self.sectionGapHeight : sectionGapHeight // ignore: cast_nullable_to_non_nullable
as double,accentStripWidth: null == accentStripWidth ? _self.accentStripWidth : accentStripWidth // ignore: cast_nullable_to_non_nullable
as double,badgeMinRadius: null == badgeMinRadius ? _self.badgeMinRadius : badgeMinRadius // ignore: cast_nullable_to_non_nullable
as double,badgePadding: null == badgePadding ? _self.badgePadding : badgePadding // ignore: cast_nullable_to_non_nullable
as double,matchPillMinHalfWidth: null == matchPillMinHalfWidth ? _self.matchPillMinHalfWidth : matchPillMinHalfWidth // ignore: cast_nullable_to_non_nullable
as double,matchPillHorizontalPadding: null == matchPillHorizontalPadding ? _self.matchPillHorizontalPadding : matchPillHorizontalPadding // ignore: cast_nullable_to_non_nullable
as double,matchPillMinHalfHeight: null == matchPillMinHalfHeight ? _self.matchPillMinHalfHeight : matchPillMinHalfHeight // ignore: cast_nullable_to_non_nullable
as double,matchPillVerticalPadding: null == matchPillVerticalPadding ? _self.matchPillVerticalPadding : matchPillVerticalPadding // ignore: cast_nullable_to_non_nullable
as double,dashedLineDashWidth: null == dashedLineDashWidth ? _self.dashedLineDashWidth : dashedLineDashWidth // ignore: cast_nullable_to_non_nullable
as double,dashedLineGapWidth: null == dashedLineGapWidth ? _self.dashedLineGapWidth : dashedLineGapWidth // ignore: cast_nullable_to_non_nullable
as double,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,headerLetterSpacing: null == headerLetterSpacing ? _self.headerLetterSpacing : headerLetterSpacing // ignore: cast_nullable_to_non_nullable
as double,subHeaderLetterSpacing: null == subHeaderLetterSpacing ? _self.subHeaderLetterSpacing : subHeaderLetterSpacing // ignore: cast_nullable_to_non_nullable
as double,rowHeight: null == rowHeight ? _self.rowHeight : rowHeight // ignore: cast_nullable_to_non_nullable
as double,intraMatchGapHeight: null == intraMatchGapHeight ? _self.intraMatchGapHeight : intraMatchGapHeight // ignore: cast_nullable_to_non_nullable
as double,interMatchGapHeight: null == interMatchGapHeight ? _self.interMatchGapHeight : interMatchGapHeight // ignore: cast_nullable_to_non_nullable
as double,numberColumnWidth: null == numberColumnWidth ? _self.numberColumnWidth : numberColumnWidth // ignore: cast_nullable_to_non_nullable
as double,nameColumnWidth: null == nameColumnWidth ? _self.nameColumnWidth : nameColumnWidth // ignore: cast_nullable_to_non_nullable
as double,registrationIdColumnWidth: null == registrationIdColumnWidth ? _self.registrationIdColumnWidth : registrationIdColumnWidth // ignore: cast_nullable_to_non_nullable
as double,roundColumnWidth: null == roundColumnWidth ? _self.roundColumnWidth : roundColumnWidth // ignore: cast_nullable_to_non_nullable
as double,headerTotalHeight: null == headerTotalHeight ? _self.headerTotalHeight : headerTotalHeight // ignore: cast_nullable_to_non_nullable
as double,subHeaderRowHeight: null == subHeaderRowHeight ? _self.subHeaderRowHeight : subHeaderRowHeight // ignore: cast_nullable_to_non_nullable
as double,centerGapWidth: null == centerGapWidth ? _self.centerGapWidth : centerGapWidth // ignore: cast_nullable_to_non_nullable
as double,sectionLabelHeight: null == sectionLabelHeight ? _self.sectionLabelHeight : sectionLabelHeight // ignore: cast_nullable_to_non_nullable
as double,medalTableWidth: null == medalTableWidth ? _self.medalTableWidth : medalTableWidth // ignore: cast_nullable_to_non_nullable
as double,medalRowHeight: null == medalRowHeight ? _self.medalRowHeight : medalRowHeight // ignore: cast_nullable_to_non_nullable
as double,medalNameColumnWidth: null == medalNameColumnWidth ? _self.medalNameColumnWidth : medalNameColumnWidth // ignore: cast_nullable_to_non_nullable
as double,medalLabelColumnWidth: null == medalLabelColumnWidth ? _self.medalLabelColumnWidth : medalLabelColumnWidth // ignore: cast_nullable_to_non_nullable
as double,medalRowGap: null == medalRowGap ? _self.medalRowGap : medalRowGap // ignore: cast_nullable_to_non_nullable
as double,centerFinalMinimumSpan: null == centerFinalMinimumSpan ? _self.centerFinalMinimumSpan : centerFinalMinimumSpan // ignore: cast_nullable_to_non_nullable
as double,grandFinalOutputArmLength: null == grandFinalOutputArmLength ? _self.grandFinalOutputArmLength : grandFinalOutputArmLength // ignore: cast_nullable_to_non_nullable
as double,badgeHorizontalOffset: null == badgeHorizontalOffset ? _self.badgeHorizontalOffset : badgeHorizontalOffset // ignore: cast_nullable_to_non_nullable
as double,badgeBlueVerticalOffset: null == badgeBlueVerticalOffset ? _self.badgeBlueVerticalOffset : badgeBlueVerticalOffset // ignore: cast_nullable_to_non_nullable
as double,badgeRedVerticalOffset: null == badgeRedVerticalOffset ? _self.badgeRedVerticalOffset : badgeRedVerticalOffset // ignore: cast_nullable_to_non_nullable
as double,missingInputVerticalOffset: null == missingInputVerticalOffset ? _self.missingInputVerticalOffset : missingInputVerticalOffset // ignore: cast_nullable_to_non_nullable
as double,thirdPlaceToMedalGap: null == thirdPlaceToMedalGap ? _self.thirdPlaceToMedalGap : thirdPlaceToMedalGap // ignore: cast_nullable_to_non_nullable
as double,matchPillHorizontalOffset: null == matchPillHorizontalOffset ? _self.matchPillHorizontalOffset : matchPillHorizontalOffset // ignore: cast_nullable_to_non_nullable
as double,headerBannerHeight: null == headerBannerHeight ? _self.headerBannerHeight : headerBannerHeight // ignore: cast_nullable_to_non_nullable
as double,logoMaxHeight: null == logoMaxHeight ? _self.logoMaxHeight : logoMaxHeight // ignore: cast_nullable_to_non_nullable
as double,logoPadding: null == logoPadding ? _self.logoPadding : logoPadding // ignore: cast_nullable_to_non_nullable
as double,matchPillFillColor: null == matchPillFillColor ? _self.matchPillFillColor : matchPillFillColor // ignore: cast_nullable_to_non_nullable
as Color,badgeTextColor: null == badgeTextColor ? _self.badgeTextColor : badgeTextColor // ignore: cast_nullable_to_non_nullable
as Color,sectionLabelBackgroundOpacity: null == sectionLabelBackgroundOpacity ? _self.sectionLabelBackgroundOpacity : sectionLabelBackgroundOpacity // ignore: cast_nullable_to_non_nullable
as double,headerSecondaryTextOpacity: null == headerSecondaryTextOpacity ? _self.headerSecondaryTextOpacity : headerSecondaryTextOpacity // ignore: cast_nullable_to_non_nullable
as double,badgeOutlineOpacity: null == badgeOutlineOpacity ? _self.badgeOutlineOpacity : badgeOutlineOpacity // ignore: cast_nullable_to_non_nullable
as double,canvasMinimumWidth: null == canvasMinimumWidth ? _self.canvasMinimumWidth : canvasMinimumWidth // ignore: cast_nullable_to_non_nullable
as double,canvasMinimumHeight: null == canvasMinimumHeight ? _self.canvasMinimumHeight : canvasMinimumHeight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TieSheetThemeConfig].
extension TieSheetThemeConfigPatterns on TieSheetThemeConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TieSheetThemeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TieSheetThemeConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TieSheetThemeConfig value)  $default,){
final _that = this;
switch (_that) {
case _TieSheetThemeConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TieSheetThemeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _TieSheetThemeConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ColorJsonConverter()  Color mutedColor, @ColorJsonConverter()  Color connectorWonColor, @ColorJsonConverter()  Color canvasBackgroundColor, @ColorJsonConverter()  Color borderColor,  double connectorStrokeWidth,  bool isInteractivityDisabled, @ColorJsonConverter()  Color primaryTextColor, @ColorJsonConverter()  Color secondaryTextColor,  bool isTextForceBold,  double fontSizeDelta, @ColorJsonConverter()  Color rowFillColor, @ColorJsonConverter()  Color headerFillColor, @ColorJsonConverter()  Color tbdFillColor, @ColorJsonConverter()  Color headerBannerBackgroundColor, @ColorJsonConverter()  Color headerBannerTextColor, @ColorJsonConverter()  Color participantAccentStripColor, @ColorJsonConverter()  Color blueCornerColor, @ColorJsonConverter()  Color redCornerColor, @ColorJsonConverter()  Color winnersLabelColor, @ColorJsonConverter()  Color losersLabelColor, @ColorJsonConverter()  Color medalGoldFillColor, @ColorJsonConverter()  Color medalSilverFillColor, @ColorJsonConverter()  Color medalBronzeFillColor, @ColorJsonConverter()  Color medalGoldTextColor, @ColorJsonConverter()  Color medalSilverTextColor, @ColorJsonConverter()  Color medalBronzeTextColor, @ColorJsonConverter()  Color medalGoldAccentColor, @ColorJsonConverter()  Color medalSilverAccentColor, @ColorJsonConverter()  Color medalBronzeAccentColor,  double elementBorderRadius,  double junctionCornerRadius,  double borderStrokeWidth,  double subtleStrokeWidth,  double wonConnectorStrokeWidth,  double canvasMargin,  double sectionGapHeight,  double accentStripWidth,  double badgeMinRadius,  double badgePadding,  double matchPillMinHalfWidth,  double matchPillHorizontalPadding,  double matchPillMinHalfHeight,  double matchPillVerticalPadding,  double dashedLineDashWidth,  double dashedLineGapWidth,  String fontFamily,  double headerLetterSpacing,  double subHeaderLetterSpacing,  double rowHeight,  double intraMatchGapHeight,  double interMatchGapHeight,  double numberColumnWidth,  double nameColumnWidth,  double registrationIdColumnWidth,  double roundColumnWidth,  double headerTotalHeight,  double subHeaderRowHeight,  double centerGapWidth,  double sectionLabelHeight,  double medalTableWidth,  double medalRowHeight,  double medalNameColumnWidth,  double medalLabelColumnWidth,  double medalRowGap,  double centerFinalMinimumSpan,  double grandFinalOutputArmLength,  double badgeHorizontalOffset,  double badgeBlueVerticalOffset,  double badgeRedVerticalOffset,  double missingInputVerticalOffset,  double thirdPlaceToMedalGap,  double matchPillHorizontalOffset,  double headerBannerHeight,  double logoMaxHeight,  double logoPadding, @ColorJsonConverter()  Color matchPillFillColor, @ColorJsonConverter()  Color badgeTextColor,  double sectionLabelBackgroundOpacity,  double headerSecondaryTextOpacity,  double badgeOutlineOpacity,  double canvasMinimumWidth,  double canvasMinimumHeight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TieSheetThemeConfig() when $default != null:
return $default(_that.mutedColor,_that.connectorWonColor,_that.canvasBackgroundColor,_that.borderColor,_that.connectorStrokeWidth,_that.isInteractivityDisabled,_that.primaryTextColor,_that.secondaryTextColor,_that.isTextForceBold,_that.fontSizeDelta,_that.rowFillColor,_that.headerFillColor,_that.tbdFillColor,_that.headerBannerBackgroundColor,_that.headerBannerTextColor,_that.participantAccentStripColor,_that.blueCornerColor,_that.redCornerColor,_that.winnersLabelColor,_that.losersLabelColor,_that.medalGoldFillColor,_that.medalSilverFillColor,_that.medalBronzeFillColor,_that.medalGoldTextColor,_that.medalSilverTextColor,_that.medalBronzeTextColor,_that.medalGoldAccentColor,_that.medalSilverAccentColor,_that.medalBronzeAccentColor,_that.elementBorderRadius,_that.junctionCornerRadius,_that.borderStrokeWidth,_that.subtleStrokeWidth,_that.wonConnectorStrokeWidth,_that.canvasMargin,_that.sectionGapHeight,_that.accentStripWidth,_that.badgeMinRadius,_that.badgePadding,_that.matchPillMinHalfWidth,_that.matchPillHorizontalPadding,_that.matchPillMinHalfHeight,_that.matchPillVerticalPadding,_that.dashedLineDashWidth,_that.dashedLineGapWidth,_that.fontFamily,_that.headerLetterSpacing,_that.subHeaderLetterSpacing,_that.rowHeight,_that.intraMatchGapHeight,_that.interMatchGapHeight,_that.numberColumnWidth,_that.nameColumnWidth,_that.registrationIdColumnWidth,_that.roundColumnWidth,_that.headerTotalHeight,_that.subHeaderRowHeight,_that.centerGapWidth,_that.sectionLabelHeight,_that.medalTableWidth,_that.medalRowHeight,_that.medalNameColumnWidth,_that.medalLabelColumnWidth,_that.medalRowGap,_that.centerFinalMinimumSpan,_that.grandFinalOutputArmLength,_that.badgeHorizontalOffset,_that.badgeBlueVerticalOffset,_that.badgeRedVerticalOffset,_that.missingInputVerticalOffset,_that.thirdPlaceToMedalGap,_that.matchPillHorizontalOffset,_that.headerBannerHeight,_that.logoMaxHeight,_that.logoPadding,_that.matchPillFillColor,_that.badgeTextColor,_that.sectionLabelBackgroundOpacity,_that.headerSecondaryTextOpacity,_that.badgeOutlineOpacity,_that.canvasMinimumWidth,_that.canvasMinimumHeight);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ColorJsonConverter()  Color mutedColor, @ColorJsonConverter()  Color connectorWonColor, @ColorJsonConverter()  Color canvasBackgroundColor, @ColorJsonConverter()  Color borderColor,  double connectorStrokeWidth,  bool isInteractivityDisabled, @ColorJsonConverter()  Color primaryTextColor, @ColorJsonConverter()  Color secondaryTextColor,  bool isTextForceBold,  double fontSizeDelta, @ColorJsonConverter()  Color rowFillColor, @ColorJsonConverter()  Color headerFillColor, @ColorJsonConverter()  Color tbdFillColor, @ColorJsonConverter()  Color headerBannerBackgroundColor, @ColorJsonConverter()  Color headerBannerTextColor, @ColorJsonConverter()  Color participantAccentStripColor, @ColorJsonConverter()  Color blueCornerColor, @ColorJsonConverter()  Color redCornerColor, @ColorJsonConverter()  Color winnersLabelColor, @ColorJsonConverter()  Color losersLabelColor, @ColorJsonConverter()  Color medalGoldFillColor, @ColorJsonConverter()  Color medalSilverFillColor, @ColorJsonConverter()  Color medalBronzeFillColor, @ColorJsonConverter()  Color medalGoldTextColor, @ColorJsonConverter()  Color medalSilverTextColor, @ColorJsonConverter()  Color medalBronzeTextColor, @ColorJsonConverter()  Color medalGoldAccentColor, @ColorJsonConverter()  Color medalSilverAccentColor, @ColorJsonConverter()  Color medalBronzeAccentColor,  double elementBorderRadius,  double junctionCornerRadius,  double borderStrokeWidth,  double subtleStrokeWidth,  double wonConnectorStrokeWidth,  double canvasMargin,  double sectionGapHeight,  double accentStripWidth,  double badgeMinRadius,  double badgePadding,  double matchPillMinHalfWidth,  double matchPillHorizontalPadding,  double matchPillMinHalfHeight,  double matchPillVerticalPadding,  double dashedLineDashWidth,  double dashedLineGapWidth,  String fontFamily,  double headerLetterSpacing,  double subHeaderLetterSpacing,  double rowHeight,  double intraMatchGapHeight,  double interMatchGapHeight,  double numberColumnWidth,  double nameColumnWidth,  double registrationIdColumnWidth,  double roundColumnWidth,  double headerTotalHeight,  double subHeaderRowHeight,  double centerGapWidth,  double sectionLabelHeight,  double medalTableWidth,  double medalRowHeight,  double medalNameColumnWidth,  double medalLabelColumnWidth,  double medalRowGap,  double centerFinalMinimumSpan,  double grandFinalOutputArmLength,  double badgeHorizontalOffset,  double badgeBlueVerticalOffset,  double badgeRedVerticalOffset,  double missingInputVerticalOffset,  double thirdPlaceToMedalGap,  double matchPillHorizontalOffset,  double headerBannerHeight,  double logoMaxHeight,  double logoPadding, @ColorJsonConverter()  Color matchPillFillColor, @ColorJsonConverter()  Color badgeTextColor,  double sectionLabelBackgroundOpacity,  double headerSecondaryTextOpacity,  double badgeOutlineOpacity,  double canvasMinimumWidth,  double canvasMinimumHeight)  $default,) {final _that = this;
switch (_that) {
case _TieSheetThemeConfig():
return $default(_that.mutedColor,_that.connectorWonColor,_that.canvasBackgroundColor,_that.borderColor,_that.connectorStrokeWidth,_that.isInteractivityDisabled,_that.primaryTextColor,_that.secondaryTextColor,_that.isTextForceBold,_that.fontSizeDelta,_that.rowFillColor,_that.headerFillColor,_that.tbdFillColor,_that.headerBannerBackgroundColor,_that.headerBannerTextColor,_that.participantAccentStripColor,_that.blueCornerColor,_that.redCornerColor,_that.winnersLabelColor,_that.losersLabelColor,_that.medalGoldFillColor,_that.medalSilverFillColor,_that.medalBronzeFillColor,_that.medalGoldTextColor,_that.medalSilverTextColor,_that.medalBronzeTextColor,_that.medalGoldAccentColor,_that.medalSilverAccentColor,_that.medalBronzeAccentColor,_that.elementBorderRadius,_that.junctionCornerRadius,_that.borderStrokeWidth,_that.subtleStrokeWidth,_that.wonConnectorStrokeWidth,_that.canvasMargin,_that.sectionGapHeight,_that.accentStripWidth,_that.badgeMinRadius,_that.badgePadding,_that.matchPillMinHalfWidth,_that.matchPillHorizontalPadding,_that.matchPillMinHalfHeight,_that.matchPillVerticalPadding,_that.dashedLineDashWidth,_that.dashedLineGapWidth,_that.fontFamily,_that.headerLetterSpacing,_that.subHeaderLetterSpacing,_that.rowHeight,_that.intraMatchGapHeight,_that.interMatchGapHeight,_that.numberColumnWidth,_that.nameColumnWidth,_that.registrationIdColumnWidth,_that.roundColumnWidth,_that.headerTotalHeight,_that.subHeaderRowHeight,_that.centerGapWidth,_that.sectionLabelHeight,_that.medalTableWidth,_that.medalRowHeight,_that.medalNameColumnWidth,_that.medalLabelColumnWidth,_that.medalRowGap,_that.centerFinalMinimumSpan,_that.grandFinalOutputArmLength,_that.badgeHorizontalOffset,_that.badgeBlueVerticalOffset,_that.badgeRedVerticalOffset,_that.missingInputVerticalOffset,_that.thirdPlaceToMedalGap,_that.matchPillHorizontalOffset,_that.headerBannerHeight,_that.logoMaxHeight,_that.logoPadding,_that.matchPillFillColor,_that.badgeTextColor,_that.sectionLabelBackgroundOpacity,_that.headerSecondaryTextOpacity,_that.badgeOutlineOpacity,_that.canvasMinimumWidth,_that.canvasMinimumHeight);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ColorJsonConverter()  Color mutedColor, @ColorJsonConverter()  Color connectorWonColor, @ColorJsonConverter()  Color canvasBackgroundColor, @ColorJsonConverter()  Color borderColor,  double connectorStrokeWidth,  bool isInteractivityDisabled, @ColorJsonConverter()  Color primaryTextColor, @ColorJsonConverter()  Color secondaryTextColor,  bool isTextForceBold,  double fontSizeDelta, @ColorJsonConverter()  Color rowFillColor, @ColorJsonConverter()  Color headerFillColor, @ColorJsonConverter()  Color tbdFillColor, @ColorJsonConverter()  Color headerBannerBackgroundColor, @ColorJsonConverter()  Color headerBannerTextColor, @ColorJsonConverter()  Color participantAccentStripColor, @ColorJsonConverter()  Color blueCornerColor, @ColorJsonConverter()  Color redCornerColor, @ColorJsonConverter()  Color winnersLabelColor, @ColorJsonConverter()  Color losersLabelColor, @ColorJsonConverter()  Color medalGoldFillColor, @ColorJsonConverter()  Color medalSilverFillColor, @ColorJsonConverter()  Color medalBronzeFillColor, @ColorJsonConverter()  Color medalGoldTextColor, @ColorJsonConverter()  Color medalSilverTextColor, @ColorJsonConverter()  Color medalBronzeTextColor, @ColorJsonConverter()  Color medalGoldAccentColor, @ColorJsonConverter()  Color medalSilverAccentColor, @ColorJsonConverter()  Color medalBronzeAccentColor,  double elementBorderRadius,  double junctionCornerRadius,  double borderStrokeWidth,  double subtleStrokeWidth,  double wonConnectorStrokeWidth,  double canvasMargin,  double sectionGapHeight,  double accentStripWidth,  double badgeMinRadius,  double badgePadding,  double matchPillMinHalfWidth,  double matchPillHorizontalPadding,  double matchPillMinHalfHeight,  double matchPillVerticalPadding,  double dashedLineDashWidth,  double dashedLineGapWidth,  String fontFamily,  double headerLetterSpacing,  double subHeaderLetterSpacing,  double rowHeight,  double intraMatchGapHeight,  double interMatchGapHeight,  double numberColumnWidth,  double nameColumnWidth,  double registrationIdColumnWidth,  double roundColumnWidth,  double headerTotalHeight,  double subHeaderRowHeight,  double centerGapWidth,  double sectionLabelHeight,  double medalTableWidth,  double medalRowHeight,  double medalNameColumnWidth,  double medalLabelColumnWidth,  double medalRowGap,  double centerFinalMinimumSpan,  double grandFinalOutputArmLength,  double badgeHorizontalOffset,  double badgeBlueVerticalOffset,  double badgeRedVerticalOffset,  double missingInputVerticalOffset,  double thirdPlaceToMedalGap,  double matchPillHorizontalOffset,  double headerBannerHeight,  double logoMaxHeight,  double logoPadding, @ColorJsonConverter()  Color matchPillFillColor, @ColorJsonConverter()  Color badgeTextColor,  double sectionLabelBackgroundOpacity,  double headerSecondaryTextOpacity,  double badgeOutlineOpacity,  double canvasMinimumWidth,  double canvasMinimumHeight)?  $default,) {final _that = this;
switch (_that) {
case _TieSheetThemeConfig() when $default != null:
return $default(_that.mutedColor,_that.connectorWonColor,_that.canvasBackgroundColor,_that.borderColor,_that.connectorStrokeWidth,_that.isInteractivityDisabled,_that.primaryTextColor,_that.secondaryTextColor,_that.isTextForceBold,_that.fontSizeDelta,_that.rowFillColor,_that.headerFillColor,_that.tbdFillColor,_that.headerBannerBackgroundColor,_that.headerBannerTextColor,_that.participantAccentStripColor,_that.blueCornerColor,_that.redCornerColor,_that.winnersLabelColor,_that.losersLabelColor,_that.medalGoldFillColor,_that.medalSilverFillColor,_that.medalBronzeFillColor,_that.medalGoldTextColor,_that.medalSilverTextColor,_that.medalBronzeTextColor,_that.medalGoldAccentColor,_that.medalSilverAccentColor,_that.medalBronzeAccentColor,_that.elementBorderRadius,_that.junctionCornerRadius,_that.borderStrokeWidth,_that.subtleStrokeWidth,_that.wonConnectorStrokeWidth,_that.canvasMargin,_that.sectionGapHeight,_that.accentStripWidth,_that.badgeMinRadius,_that.badgePadding,_that.matchPillMinHalfWidth,_that.matchPillHorizontalPadding,_that.matchPillMinHalfHeight,_that.matchPillVerticalPadding,_that.dashedLineDashWidth,_that.dashedLineGapWidth,_that.fontFamily,_that.headerLetterSpacing,_that.subHeaderLetterSpacing,_that.rowHeight,_that.intraMatchGapHeight,_that.interMatchGapHeight,_that.numberColumnWidth,_that.nameColumnWidth,_that.registrationIdColumnWidth,_that.roundColumnWidth,_that.headerTotalHeight,_that.subHeaderRowHeight,_that.centerGapWidth,_that.sectionLabelHeight,_that.medalTableWidth,_that.medalRowHeight,_that.medalNameColumnWidth,_that.medalLabelColumnWidth,_that.medalRowGap,_that.centerFinalMinimumSpan,_that.grandFinalOutputArmLength,_that.badgeHorizontalOffset,_that.badgeBlueVerticalOffset,_that.badgeRedVerticalOffset,_that.missingInputVerticalOffset,_that.thirdPlaceToMedalGap,_that.matchPillHorizontalOffset,_that.headerBannerHeight,_that.logoMaxHeight,_that.logoPadding,_that.matchPillFillColor,_that.badgeTextColor,_that.sectionLabelBackgroundOpacity,_that.headerSecondaryTextOpacity,_that.badgeOutlineOpacity,_that.canvasMinimumWidth,_that.canvasMinimumHeight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TieSheetThemeConfig extends TieSheetThemeConfig {
  const _TieSheetThemeConfig({@ColorJsonConverter() required this.mutedColor, @ColorJsonConverter() required this.connectorWonColor, @ColorJsonConverter() required this.canvasBackgroundColor, @ColorJsonConverter() required this.borderColor, required this.connectorStrokeWidth, required this.isInteractivityDisabled, @ColorJsonConverter() required this.primaryTextColor, @ColorJsonConverter() required this.secondaryTextColor, required this.isTextForceBold, required this.fontSizeDelta, @ColorJsonConverter() required this.rowFillColor, @ColorJsonConverter() required this.headerFillColor, @ColorJsonConverter() required this.tbdFillColor, @ColorJsonConverter() required this.headerBannerBackgroundColor, @ColorJsonConverter() required this.headerBannerTextColor, @ColorJsonConverter() required this.participantAccentStripColor, @ColorJsonConverter() required this.blueCornerColor, @ColorJsonConverter() required this.redCornerColor, @ColorJsonConverter() required this.winnersLabelColor, @ColorJsonConverter() required this.losersLabelColor, @ColorJsonConverter() required this.medalGoldFillColor, @ColorJsonConverter() required this.medalSilverFillColor, @ColorJsonConverter() required this.medalBronzeFillColor, @ColorJsonConverter() required this.medalGoldTextColor, @ColorJsonConverter() required this.medalSilverTextColor, @ColorJsonConverter() required this.medalBronzeTextColor, @ColorJsonConverter() required this.medalGoldAccentColor, @ColorJsonConverter() required this.medalSilverAccentColor, @ColorJsonConverter() required this.medalBronzeAccentColor, required this.elementBorderRadius, required this.junctionCornerRadius, required this.borderStrokeWidth, required this.subtleStrokeWidth, required this.wonConnectorStrokeWidth, required this.canvasMargin, required this.sectionGapHeight, required this.accentStripWidth, required this.badgeMinRadius, required this.badgePadding, required this.matchPillMinHalfWidth, required this.matchPillHorizontalPadding, required this.matchPillMinHalfHeight, required this.matchPillVerticalPadding, required this.dashedLineDashWidth, required this.dashedLineGapWidth, required this.fontFamily, required this.headerLetterSpacing, required this.subHeaderLetterSpacing, required this.rowHeight, required this.intraMatchGapHeight, required this.interMatchGapHeight, required this.numberColumnWidth, required this.nameColumnWidth, required this.registrationIdColumnWidth, required this.roundColumnWidth, required this.headerTotalHeight, required this.subHeaderRowHeight, required this.centerGapWidth, required this.sectionLabelHeight, required this.medalTableWidth, required this.medalRowHeight, required this.medalNameColumnWidth, required this.medalLabelColumnWidth, required this.medalRowGap, required this.centerFinalMinimumSpan, required this.grandFinalOutputArmLength, required this.badgeHorizontalOffset, required this.badgeBlueVerticalOffset, required this.badgeRedVerticalOffset, required this.missingInputVerticalOffset, required this.thirdPlaceToMedalGap, required this.matchPillHorizontalOffset, required this.headerBannerHeight, required this.logoMaxHeight, required this.logoPadding, @ColorJsonConverter() required this.matchPillFillColor, @ColorJsonConverter() required this.badgeTextColor, required this.sectionLabelBackgroundOpacity, required this.headerSecondaryTextOpacity, required this.badgeOutlineOpacity, required this.canvasMinimumWidth, required this.canvasMinimumHeight}): super._();
  factory _TieSheetThemeConfig.fromJson(Map<String, dynamic> json) => _$TieSheetThemeConfigFromJson(json);

// ── Connector / junction tokens ─────────────────────────────────────────
/// Muted colour used for generic connectors, BYE dashed lines,
/// TBD placeholder text, and unresolved junction lines.
@override@ColorJsonConverter() final  Color mutedColor;
/// Resolved connector stroke colour (winner advancement lines).
@override@ColorJsonConverter() final  Color connectorWonColor;
// ── Canvas & card tokens ────────────────────────────────────────────────
/// Canvas background fill.
@override@ColorJsonConverter() final  Color canvasBackgroundColor;
/// Unified border stroke colour for cards, TBD outlines, and pending
/// dashed connectors.
@override@ColorJsonConverter() final  Color borderColor;
/// Uniform stroke width for all connector / junction lines.
/// In default mode each pen chooses its own width.
/// In print mode a single uniform value is used for all connectors.
@override final  double connectorStrokeWidth;
/// When `true`, all interactive overlays (match taps, drag-swap,
/// participant slot taps) are suppressed on the canvas widget.
@override final  bool isInteractivityDisabled;
// ── Text tokens ─────────────────────────────────────────────────────────
/// Primary text colour (headings, names, numbers).
@override@ColorJsonConverter() final  Color primaryTextColor;
/// Secondary text colour (subtle / supporting text).
@override@ColorJsonConverter() final  Color secondaryTextColor;
/// When `true`, **every** text span is rendered bold regardless of
/// the font-weight specified by the painter.
@override final  bool isTextForceBold;
/// Additive font-size adjustment applied to **every** text span.
@override final  double fontSizeDelta;
// ── Fill tokens ─────────────────────────────────────────────────────────
/// Participant card background fill.
@override@ColorJsonConverter() final  Color rowFillColor;
/// Info-row / sub-header background fill.
@override@ColorJsonConverter() final  Color headerFillColor;
/// TBD placeholder card background fill.
@override@ColorJsonConverter() final  Color tbdFillColor;
// ── Header banner ───────────────────────────────────────────────────────
/// Top banner background colour.
@override@ColorJsonConverter() final  Color headerBannerBackgroundColor;
/// Top banner text colour.
@override@ColorJsonConverter() final  Color headerBannerTextColor;
// ── Accent & badge tokens ───────────────────────────────────────────────
/// Participant row accent strip colour (left/right edge coloured strip).
@override@ColorJsonConverter() final  Color participantAccentStripColor;
/// Blue-corner badge colour.
@override@ColorJsonConverter() final  Color blueCornerColor;
/// Red-corner badge colour.
@override@ColorJsonConverter() final  Color redCornerColor;
// ── Section label tokens (DE brackets) ──────────────────────────────────
/// Winners bracket section-label colour.
@override@ColorJsonConverter() final  Color winnersLabelColor;
/// Losers bracket section-label colour.
@override@ColorJsonConverter() final  Color losersLabelColor;
// ── Medal table tokens ──────────────────────────────────────────────────
@override@ColorJsonConverter() final  Color medalGoldFillColor;
@override@ColorJsonConverter() final  Color medalSilverFillColor;
@override@ColorJsonConverter() final  Color medalBronzeFillColor;
@override@ColorJsonConverter() final  Color medalGoldTextColor;
@override@ColorJsonConverter() final  Color medalSilverTextColor;
@override@ColorJsonConverter() final  Color medalBronzeTextColor;
@override@ColorJsonConverter() final  Color medalGoldAccentColor;
@override@ColorJsonConverter() final  Color medalSilverAccentColor;
@override@ColorJsonConverter() final  Color medalBronzeAccentColor;
// ── Shape / radius tokens ───────────────────────────────────────────────
/// Unified border radius applied to all rectangular UI elements.
@override final  double elementBorderRadius;
/// Corner radius for the Bezier curve arms on bracket junctions.
@override final  double junctionCornerRadius;
// ── Stroke width tokens ─────────────────────────────────────────────────
/// Primary stroke width for borders, outlines, dividers, and pending
/// connector lines.
@override final  double borderStrokeWidth;
/// Subtle stroke width for secondary borders.
@override final  double subtleStrokeWidth;
/// Stroke width for resolved / won connector lines.
@override final  double wonConnectorStrokeWidth;
// ── Spacing tokens ──────────────────────────────────────────────────────
/// Canvas margin (padding around all edges of the canvas).
@override final  double canvasMargin;
/// Vertical gap between Winners and Losers bracket sections (DE only).
@override final  double sectionGapHeight;
/// Width of the coloured accent strip on participant card edges.
@override final  double accentStripWidth;
// ── Badge & pill sizing tokens ──────────────────────────────────────────
/// Minimum radius for corner badges (B / R).
@override final  double badgeMinRadius;
/// Padding added around badge text to compute dynamic radius.
@override final  double badgePadding;
/// Minimum half-width for match number pills.
@override final  double matchPillMinHalfWidth;
/// Horizontal padding for match number pill text.
@override final  double matchPillHorizontalPadding;
/// Minimum half-height for match number pills.
@override final  double matchPillMinHalfHeight;
/// Vertical padding for match number pill text.
@override final  double matchPillVerticalPadding;
// ── Dashed line tokens ──────────────────────────────────────────────────
/// Width of each dash segment in dashed connector lines.
@override final  double dashedLineDashWidth;
/// Gap between dash segments in dashed connector lines.
@override final  double dashedLineGapWidth;
// ── Typography tokens ───────────────────────────────────────────────────
/// Font family applied to all text rendered on the canvas.
@override final  String fontFamily;
/// Letter spacing for the main tournament title in the header banner.
@override final  double headerLetterSpacing;
/// Letter spacing for sub-header text (date, venue) in the header banner.
@override final  double subHeaderLetterSpacing;
// ── Layout dimension base tokens ────────────────────────────────────────
/// Base height of a single participant row (px).
@override final  double rowHeight;
/// Vertical gap between blue & red rows within a single match (px).
@override final  double intraMatchGapHeight;
/// Vertical gap between consecutive match pairs (px).
@override final  double interMatchGapHeight;
/// Width of the serial-number column (px).
@override final  double numberColumnWidth;
/// Width of the participant name column (px).
@override final  double nameColumnWidth;
/// Width of the registration-ID column (px).
@override final  double registrationIdColumnWidth;
/// Width of each bracket round column (px).
@override final  double roundColumnWidth;
/// Total height of the full header area (banner + info row, px).
@override final  double headerTotalHeight;
/// Height of the tournament info sub-header row (px).
@override final  double subHeaderRowHeight;
/// Horizontal gap between left and right bracket halves (SE only, px).
@override final  double centerGapWidth;
/// Height of the Winners/Losers section label bar (px).
@override final  double sectionLabelHeight;
// ── Medal table layout tokens ───────────────────────────────────────────
/// Total width of the medal table (px).
@override final  double medalTableWidth;
/// Height of each medal row (px).
@override final  double medalRowHeight;
/// Width of the name column inside the medal table (px).
@override final  double medalNameColumnWidth;
/// Width of the label column inside the medal table (px).
@override final  double medalLabelColumnWidth;
/// Vertical gap between medal rows (px).
@override final  double medalRowGap;
// ── Junction geometry tokens ────────────────────────────────────────────
/// Minimum vertical span for center-final junction arms (px).
@override final  double centerFinalMinimumSpan;
/// Horizontal arm length for grand-final output connector (px).
@override final  double grandFinalOutputArmLength;
/// Horizontal offset for corner badges relative to junction center (px).
@override final  double badgeHorizontalOffset;
/// Vertical offset for blue corner badge from junction arm (px).
@override final  double badgeBlueVerticalOffset;
/// Vertical offset for red corner badge from junction arm (px).
@override final  double badgeRedVerticalOffset;
/// Vertical offset for missing input placeholder from junction center (px).
@override final  double missingInputVerticalOffset;
/// Vertical gap between 3rd place match and medal table (px).
@override final  double thirdPlaceToMedalGap;
/// Horizontal offset for match number pill relative to junction center (px).
@override final  double matchPillHorizontalOffset;
// ── Banner & logo layout tokens ─────────────────────────────────────────
/// Base height of the dark header banner (before fontSizeDelta scaling, px).
@override final  double headerBannerHeight;
/// Maximum display height for logo images (px).
@override final  double logoMaxHeight;
/// Padding below the logo row before the header banner starts (px).
@override final  double logoPadding;
// ── Color tokens (additional) ───────────────────────────────────────────
/// Fill colour for match number pills.
@override@ColorJsonConverter() final  Color matchPillFillColor;
/// Text colour inside corner badges (B / R).
@override@ColorJsonConverter() final  Color badgeTextColor;
// ── Opacity tokens ──────────────────────────────────────────────────────
/// Background opacity for section label fill (0.0–1.0).
@override final  double sectionLabelBackgroundOpacity;
/// Text opacity for secondary header text (subtitle + organizer, 0.0–1.0).
@override final  double headerSecondaryTextOpacity;
/// Outline opacity for corner badges B/R (0.0–1.0).
@override final  double badgeOutlineOpacity;
// ── Canvas constraint tokens ────────────────────────────────────────────
/// Minimum canvas width in logical pixels.
@override final  double canvasMinimumWidth;
/// Minimum canvas height in logical pixels.
@override final  double canvasMinimumHeight;

/// Create a copy of TieSheetThemeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TieSheetThemeConfigCopyWith<_TieSheetThemeConfig> get copyWith => __$TieSheetThemeConfigCopyWithImpl<_TieSheetThemeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TieSheetThemeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TieSheetThemeConfig&&(identical(other.mutedColor, mutedColor) || other.mutedColor == mutedColor)&&(identical(other.connectorWonColor, connectorWonColor) || other.connectorWonColor == connectorWonColor)&&(identical(other.canvasBackgroundColor, canvasBackgroundColor) || other.canvasBackgroundColor == canvasBackgroundColor)&&(identical(other.borderColor, borderColor) || other.borderColor == borderColor)&&(identical(other.connectorStrokeWidth, connectorStrokeWidth) || other.connectorStrokeWidth == connectorStrokeWidth)&&(identical(other.isInteractivityDisabled, isInteractivityDisabled) || other.isInteractivityDisabled == isInteractivityDisabled)&&(identical(other.primaryTextColor, primaryTextColor) || other.primaryTextColor == primaryTextColor)&&(identical(other.secondaryTextColor, secondaryTextColor) || other.secondaryTextColor == secondaryTextColor)&&(identical(other.isTextForceBold, isTextForceBold) || other.isTextForceBold == isTextForceBold)&&(identical(other.fontSizeDelta, fontSizeDelta) || other.fontSizeDelta == fontSizeDelta)&&(identical(other.rowFillColor, rowFillColor) || other.rowFillColor == rowFillColor)&&(identical(other.headerFillColor, headerFillColor) || other.headerFillColor == headerFillColor)&&(identical(other.tbdFillColor, tbdFillColor) || other.tbdFillColor == tbdFillColor)&&(identical(other.headerBannerBackgroundColor, headerBannerBackgroundColor) || other.headerBannerBackgroundColor == headerBannerBackgroundColor)&&(identical(other.headerBannerTextColor, headerBannerTextColor) || other.headerBannerTextColor == headerBannerTextColor)&&(identical(other.participantAccentStripColor, participantAccentStripColor) || other.participantAccentStripColor == participantAccentStripColor)&&(identical(other.blueCornerColor, blueCornerColor) || other.blueCornerColor == blueCornerColor)&&(identical(other.redCornerColor, redCornerColor) || other.redCornerColor == redCornerColor)&&(identical(other.winnersLabelColor, winnersLabelColor) || other.winnersLabelColor == winnersLabelColor)&&(identical(other.losersLabelColor, losersLabelColor) || other.losersLabelColor == losersLabelColor)&&(identical(other.medalGoldFillColor, medalGoldFillColor) || other.medalGoldFillColor == medalGoldFillColor)&&(identical(other.medalSilverFillColor, medalSilverFillColor) || other.medalSilverFillColor == medalSilverFillColor)&&(identical(other.medalBronzeFillColor, medalBronzeFillColor) || other.medalBronzeFillColor == medalBronzeFillColor)&&(identical(other.medalGoldTextColor, medalGoldTextColor) || other.medalGoldTextColor == medalGoldTextColor)&&(identical(other.medalSilverTextColor, medalSilverTextColor) || other.medalSilverTextColor == medalSilverTextColor)&&(identical(other.medalBronzeTextColor, medalBronzeTextColor) || other.medalBronzeTextColor == medalBronzeTextColor)&&(identical(other.medalGoldAccentColor, medalGoldAccentColor) || other.medalGoldAccentColor == medalGoldAccentColor)&&(identical(other.medalSilverAccentColor, medalSilverAccentColor) || other.medalSilverAccentColor == medalSilverAccentColor)&&(identical(other.medalBronzeAccentColor, medalBronzeAccentColor) || other.medalBronzeAccentColor == medalBronzeAccentColor)&&(identical(other.elementBorderRadius, elementBorderRadius) || other.elementBorderRadius == elementBorderRadius)&&(identical(other.junctionCornerRadius, junctionCornerRadius) || other.junctionCornerRadius == junctionCornerRadius)&&(identical(other.borderStrokeWidth, borderStrokeWidth) || other.borderStrokeWidth == borderStrokeWidth)&&(identical(other.subtleStrokeWidth, subtleStrokeWidth) || other.subtleStrokeWidth == subtleStrokeWidth)&&(identical(other.wonConnectorStrokeWidth, wonConnectorStrokeWidth) || other.wonConnectorStrokeWidth == wonConnectorStrokeWidth)&&(identical(other.canvasMargin, canvasMargin) || other.canvasMargin == canvasMargin)&&(identical(other.sectionGapHeight, sectionGapHeight) || other.sectionGapHeight == sectionGapHeight)&&(identical(other.accentStripWidth, accentStripWidth) || other.accentStripWidth == accentStripWidth)&&(identical(other.badgeMinRadius, badgeMinRadius) || other.badgeMinRadius == badgeMinRadius)&&(identical(other.badgePadding, badgePadding) || other.badgePadding == badgePadding)&&(identical(other.matchPillMinHalfWidth, matchPillMinHalfWidth) || other.matchPillMinHalfWidth == matchPillMinHalfWidth)&&(identical(other.matchPillHorizontalPadding, matchPillHorizontalPadding) || other.matchPillHorizontalPadding == matchPillHorizontalPadding)&&(identical(other.matchPillMinHalfHeight, matchPillMinHalfHeight) || other.matchPillMinHalfHeight == matchPillMinHalfHeight)&&(identical(other.matchPillVerticalPadding, matchPillVerticalPadding) || other.matchPillVerticalPadding == matchPillVerticalPadding)&&(identical(other.dashedLineDashWidth, dashedLineDashWidth) || other.dashedLineDashWidth == dashedLineDashWidth)&&(identical(other.dashedLineGapWidth, dashedLineGapWidth) || other.dashedLineGapWidth == dashedLineGapWidth)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.headerLetterSpacing, headerLetterSpacing) || other.headerLetterSpacing == headerLetterSpacing)&&(identical(other.subHeaderLetterSpacing, subHeaderLetterSpacing) || other.subHeaderLetterSpacing == subHeaderLetterSpacing)&&(identical(other.rowHeight, rowHeight) || other.rowHeight == rowHeight)&&(identical(other.intraMatchGapHeight, intraMatchGapHeight) || other.intraMatchGapHeight == intraMatchGapHeight)&&(identical(other.interMatchGapHeight, interMatchGapHeight) || other.interMatchGapHeight == interMatchGapHeight)&&(identical(other.numberColumnWidth, numberColumnWidth) || other.numberColumnWidth == numberColumnWidth)&&(identical(other.nameColumnWidth, nameColumnWidth) || other.nameColumnWidth == nameColumnWidth)&&(identical(other.registrationIdColumnWidth, registrationIdColumnWidth) || other.registrationIdColumnWidth == registrationIdColumnWidth)&&(identical(other.roundColumnWidth, roundColumnWidth) || other.roundColumnWidth == roundColumnWidth)&&(identical(other.headerTotalHeight, headerTotalHeight) || other.headerTotalHeight == headerTotalHeight)&&(identical(other.subHeaderRowHeight, subHeaderRowHeight) || other.subHeaderRowHeight == subHeaderRowHeight)&&(identical(other.centerGapWidth, centerGapWidth) || other.centerGapWidth == centerGapWidth)&&(identical(other.sectionLabelHeight, sectionLabelHeight) || other.sectionLabelHeight == sectionLabelHeight)&&(identical(other.medalTableWidth, medalTableWidth) || other.medalTableWidth == medalTableWidth)&&(identical(other.medalRowHeight, medalRowHeight) || other.medalRowHeight == medalRowHeight)&&(identical(other.medalNameColumnWidth, medalNameColumnWidth) || other.medalNameColumnWidth == medalNameColumnWidth)&&(identical(other.medalLabelColumnWidth, medalLabelColumnWidth) || other.medalLabelColumnWidth == medalLabelColumnWidth)&&(identical(other.medalRowGap, medalRowGap) || other.medalRowGap == medalRowGap)&&(identical(other.centerFinalMinimumSpan, centerFinalMinimumSpan) || other.centerFinalMinimumSpan == centerFinalMinimumSpan)&&(identical(other.grandFinalOutputArmLength, grandFinalOutputArmLength) || other.grandFinalOutputArmLength == grandFinalOutputArmLength)&&(identical(other.badgeHorizontalOffset, badgeHorizontalOffset) || other.badgeHorizontalOffset == badgeHorizontalOffset)&&(identical(other.badgeBlueVerticalOffset, badgeBlueVerticalOffset) || other.badgeBlueVerticalOffset == badgeBlueVerticalOffset)&&(identical(other.badgeRedVerticalOffset, badgeRedVerticalOffset) || other.badgeRedVerticalOffset == badgeRedVerticalOffset)&&(identical(other.missingInputVerticalOffset, missingInputVerticalOffset) || other.missingInputVerticalOffset == missingInputVerticalOffset)&&(identical(other.thirdPlaceToMedalGap, thirdPlaceToMedalGap) || other.thirdPlaceToMedalGap == thirdPlaceToMedalGap)&&(identical(other.matchPillHorizontalOffset, matchPillHorizontalOffset) || other.matchPillHorizontalOffset == matchPillHorizontalOffset)&&(identical(other.headerBannerHeight, headerBannerHeight) || other.headerBannerHeight == headerBannerHeight)&&(identical(other.logoMaxHeight, logoMaxHeight) || other.logoMaxHeight == logoMaxHeight)&&(identical(other.logoPadding, logoPadding) || other.logoPadding == logoPadding)&&(identical(other.matchPillFillColor, matchPillFillColor) || other.matchPillFillColor == matchPillFillColor)&&(identical(other.badgeTextColor, badgeTextColor) || other.badgeTextColor == badgeTextColor)&&(identical(other.sectionLabelBackgroundOpacity, sectionLabelBackgroundOpacity) || other.sectionLabelBackgroundOpacity == sectionLabelBackgroundOpacity)&&(identical(other.headerSecondaryTextOpacity, headerSecondaryTextOpacity) || other.headerSecondaryTextOpacity == headerSecondaryTextOpacity)&&(identical(other.badgeOutlineOpacity, badgeOutlineOpacity) || other.badgeOutlineOpacity == badgeOutlineOpacity)&&(identical(other.canvasMinimumWidth, canvasMinimumWidth) || other.canvasMinimumWidth == canvasMinimumWidth)&&(identical(other.canvasMinimumHeight, canvasMinimumHeight) || other.canvasMinimumHeight == canvasMinimumHeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,mutedColor,connectorWonColor,canvasBackgroundColor,borderColor,connectorStrokeWidth,isInteractivityDisabled,primaryTextColor,secondaryTextColor,isTextForceBold,fontSizeDelta,rowFillColor,headerFillColor,tbdFillColor,headerBannerBackgroundColor,headerBannerTextColor,participantAccentStripColor,blueCornerColor,redCornerColor,winnersLabelColor,losersLabelColor,medalGoldFillColor,medalSilverFillColor,medalBronzeFillColor,medalGoldTextColor,medalSilverTextColor,medalBronzeTextColor,medalGoldAccentColor,medalSilverAccentColor,medalBronzeAccentColor,elementBorderRadius,junctionCornerRadius,borderStrokeWidth,subtleStrokeWidth,wonConnectorStrokeWidth,canvasMargin,sectionGapHeight,accentStripWidth,badgeMinRadius,badgePadding,matchPillMinHalfWidth,matchPillHorizontalPadding,matchPillMinHalfHeight,matchPillVerticalPadding,dashedLineDashWidth,dashedLineGapWidth,fontFamily,headerLetterSpacing,subHeaderLetterSpacing,rowHeight,intraMatchGapHeight,interMatchGapHeight,numberColumnWidth,nameColumnWidth,registrationIdColumnWidth,roundColumnWidth,headerTotalHeight,subHeaderRowHeight,centerGapWidth,sectionLabelHeight,medalTableWidth,medalRowHeight,medalNameColumnWidth,medalLabelColumnWidth,medalRowGap,centerFinalMinimumSpan,grandFinalOutputArmLength,badgeHorizontalOffset,badgeBlueVerticalOffset,badgeRedVerticalOffset,missingInputVerticalOffset,thirdPlaceToMedalGap,matchPillHorizontalOffset,headerBannerHeight,logoMaxHeight,logoPadding,matchPillFillColor,badgeTextColor,sectionLabelBackgroundOpacity,headerSecondaryTextOpacity,badgeOutlineOpacity,canvasMinimumWidth,canvasMinimumHeight]);



}

/// @nodoc
abstract mixin class _$TieSheetThemeConfigCopyWith<$Res> implements $TieSheetThemeConfigCopyWith<$Res> {
  factory _$TieSheetThemeConfigCopyWith(_TieSheetThemeConfig value, $Res Function(_TieSheetThemeConfig) _then) = __$TieSheetThemeConfigCopyWithImpl;
@override @useResult
$Res call({
@ColorJsonConverter() Color mutedColor,@ColorJsonConverter() Color connectorWonColor,@ColorJsonConverter() Color canvasBackgroundColor,@ColorJsonConverter() Color borderColor, double connectorStrokeWidth, bool isInteractivityDisabled,@ColorJsonConverter() Color primaryTextColor,@ColorJsonConverter() Color secondaryTextColor, bool isTextForceBold, double fontSizeDelta,@ColorJsonConverter() Color rowFillColor,@ColorJsonConverter() Color headerFillColor,@ColorJsonConverter() Color tbdFillColor,@ColorJsonConverter() Color headerBannerBackgroundColor,@ColorJsonConverter() Color headerBannerTextColor,@ColorJsonConverter() Color participantAccentStripColor,@ColorJsonConverter() Color blueCornerColor,@ColorJsonConverter() Color redCornerColor,@ColorJsonConverter() Color winnersLabelColor,@ColorJsonConverter() Color losersLabelColor,@ColorJsonConverter() Color medalGoldFillColor,@ColorJsonConverter() Color medalSilverFillColor,@ColorJsonConverter() Color medalBronzeFillColor,@ColorJsonConverter() Color medalGoldTextColor,@ColorJsonConverter() Color medalSilverTextColor,@ColorJsonConverter() Color medalBronzeTextColor,@ColorJsonConverter() Color medalGoldAccentColor,@ColorJsonConverter() Color medalSilverAccentColor,@ColorJsonConverter() Color medalBronzeAccentColor, double elementBorderRadius, double junctionCornerRadius, double borderStrokeWidth, double subtleStrokeWidth, double wonConnectorStrokeWidth, double canvasMargin, double sectionGapHeight, double accentStripWidth, double badgeMinRadius, double badgePadding, double matchPillMinHalfWidth, double matchPillHorizontalPadding, double matchPillMinHalfHeight, double matchPillVerticalPadding, double dashedLineDashWidth, double dashedLineGapWidth, String fontFamily, double headerLetterSpacing, double subHeaderLetterSpacing, double rowHeight, double intraMatchGapHeight, double interMatchGapHeight, double numberColumnWidth, double nameColumnWidth, double registrationIdColumnWidth, double roundColumnWidth, double headerTotalHeight, double subHeaderRowHeight, double centerGapWidth, double sectionLabelHeight, double medalTableWidth, double medalRowHeight, double medalNameColumnWidth, double medalLabelColumnWidth, double medalRowGap, double centerFinalMinimumSpan, double grandFinalOutputArmLength, double badgeHorizontalOffset, double badgeBlueVerticalOffset, double badgeRedVerticalOffset, double missingInputVerticalOffset, double thirdPlaceToMedalGap, double matchPillHorizontalOffset, double headerBannerHeight, double logoMaxHeight, double logoPadding,@ColorJsonConverter() Color matchPillFillColor,@ColorJsonConverter() Color badgeTextColor, double sectionLabelBackgroundOpacity, double headerSecondaryTextOpacity, double badgeOutlineOpacity, double canvasMinimumWidth, double canvasMinimumHeight
});




}
/// @nodoc
class __$TieSheetThemeConfigCopyWithImpl<$Res>
    implements _$TieSheetThemeConfigCopyWith<$Res> {
  __$TieSheetThemeConfigCopyWithImpl(this._self, this._then);

  final _TieSheetThemeConfig _self;
  final $Res Function(_TieSheetThemeConfig) _then;

/// Create a copy of TieSheetThemeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mutedColor = null,Object? connectorWonColor = null,Object? canvasBackgroundColor = null,Object? borderColor = null,Object? connectorStrokeWidth = null,Object? isInteractivityDisabled = null,Object? primaryTextColor = null,Object? secondaryTextColor = null,Object? isTextForceBold = null,Object? fontSizeDelta = null,Object? rowFillColor = null,Object? headerFillColor = null,Object? tbdFillColor = null,Object? headerBannerBackgroundColor = null,Object? headerBannerTextColor = null,Object? participantAccentStripColor = null,Object? blueCornerColor = null,Object? redCornerColor = null,Object? winnersLabelColor = null,Object? losersLabelColor = null,Object? medalGoldFillColor = null,Object? medalSilverFillColor = null,Object? medalBronzeFillColor = null,Object? medalGoldTextColor = null,Object? medalSilverTextColor = null,Object? medalBronzeTextColor = null,Object? medalGoldAccentColor = null,Object? medalSilverAccentColor = null,Object? medalBronzeAccentColor = null,Object? elementBorderRadius = null,Object? junctionCornerRadius = null,Object? borderStrokeWidth = null,Object? subtleStrokeWidth = null,Object? wonConnectorStrokeWidth = null,Object? canvasMargin = null,Object? sectionGapHeight = null,Object? accentStripWidth = null,Object? badgeMinRadius = null,Object? badgePadding = null,Object? matchPillMinHalfWidth = null,Object? matchPillHorizontalPadding = null,Object? matchPillMinHalfHeight = null,Object? matchPillVerticalPadding = null,Object? dashedLineDashWidth = null,Object? dashedLineGapWidth = null,Object? fontFamily = null,Object? headerLetterSpacing = null,Object? subHeaderLetterSpacing = null,Object? rowHeight = null,Object? intraMatchGapHeight = null,Object? interMatchGapHeight = null,Object? numberColumnWidth = null,Object? nameColumnWidth = null,Object? registrationIdColumnWidth = null,Object? roundColumnWidth = null,Object? headerTotalHeight = null,Object? subHeaderRowHeight = null,Object? centerGapWidth = null,Object? sectionLabelHeight = null,Object? medalTableWidth = null,Object? medalRowHeight = null,Object? medalNameColumnWidth = null,Object? medalLabelColumnWidth = null,Object? medalRowGap = null,Object? centerFinalMinimumSpan = null,Object? grandFinalOutputArmLength = null,Object? badgeHorizontalOffset = null,Object? badgeBlueVerticalOffset = null,Object? badgeRedVerticalOffset = null,Object? missingInputVerticalOffset = null,Object? thirdPlaceToMedalGap = null,Object? matchPillHorizontalOffset = null,Object? headerBannerHeight = null,Object? logoMaxHeight = null,Object? logoPadding = null,Object? matchPillFillColor = null,Object? badgeTextColor = null,Object? sectionLabelBackgroundOpacity = null,Object? headerSecondaryTextOpacity = null,Object? badgeOutlineOpacity = null,Object? canvasMinimumWidth = null,Object? canvasMinimumHeight = null,}) {
  return _then(_TieSheetThemeConfig(
mutedColor: null == mutedColor ? _self.mutedColor : mutedColor // ignore: cast_nullable_to_non_nullable
as Color,connectorWonColor: null == connectorWonColor ? _self.connectorWonColor : connectorWonColor // ignore: cast_nullable_to_non_nullable
as Color,canvasBackgroundColor: null == canvasBackgroundColor ? _self.canvasBackgroundColor : canvasBackgroundColor // ignore: cast_nullable_to_non_nullable
as Color,borderColor: null == borderColor ? _self.borderColor : borderColor // ignore: cast_nullable_to_non_nullable
as Color,connectorStrokeWidth: null == connectorStrokeWidth ? _self.connectorStrokeWidth : connectorStrokeWidth // ignore: cast_nullable_to_non_nullable
as double,isInteractivityDisabled: null == isInteractivityDisabled ? _self.isInteractivityDisabled : isInteractivityDisabled // ignore: cast_nullable_to_non_nullable
as bool,primaryTextColor: null == primaryTextColor ? _self.primaryTextColor : primaryTextColor // ignore: cast_nullable_to_non_nullable
as Color,secondaryTextColor: null == secondaryTextColor ? _self.secondaryTextColor : secondaryTextColor // ignore: cast_nullable_to_non_nullable
as Color,isTextForceBold: null == isTextForceBold ? _self.isTextForceBold : isTextForceBold // ignore: cast_nullable_to_non_nullable
as bool,fontSizeDelta: null == fontSizeDelta ? _self.fontSizeDelta : fontSizeDelta // ignore: cast_nullable_to_non_nullable
as double,rowFillColor: null == rowFillColor ? _self.rowFillColor : rowFillColor // ignore: cast_nullable_to_non_nullable
as Color,headerFillColor: null == headerFillColor ? _self.headerFillColor : headerFillColor // ignore: cast_nullable_to_non_nullable
as Color,tbdFillColor: null == tbdFillColor ? _self.tbdFillColor : tbdFillColor // ignore: cast_nullable_to_non_nullable
as Color,headerBannerBackgroundColor: null == headerBannerBackgroundColor ? _self.headerBannerBackgroundColor : headerBannerBackgroundColor // ignore: cast_nullable_to_non_nullable
as Color,headerBannerTextColor: null == headerBannerTextColor ? _self.headerBannerTextColor : headerBannerTextColor // ignore: cast_nullable_to_non_nullable
as Color,participantAccentStripColor: null == participantAccentStripColor ? _self.participantAccentStripColor : participantAccentStripColor // ignore: cast_nullable_to_non_nullable
as Color,blueCornerColor: null == blueCornerColor ? _self.blueCornerColor : blueCornerColor // ignore: cast_nullable_to_non_nullable
as Color,redCornerColor: null == redCornerColor ? _self.redCornerColor : redCornerColor // ignore: cast_nullable_to_non_nullable
as Color,winnersLabelColor: null == winnersLabelColor ? _self.winnersLabelColor : winnersLabelColor // ignore: cast_nullable_to_non_nullable
as Color,losersLabelColor: null == losersLabelColor ? _self.losersLabelColor : losersLabelColor // ignore: cast_nullable_to_non_nullable
as Color,medalGoldFillColor: null == medalGoldFillColor ? _self.medalGoldFillColor : medalGoldFillColor // ignore: cast_nullable_to_non_nullable
as Color,medalSilverFillColor: null == medalSilverFillColor ? _self.medalSilverFillColor : medalSilverFillColor // ignore: cast_nullable_to_non_nullable
as Color,medalBronzeFillColor: null == medalBronzeFillColor ? _self.medalBronzeFillColor : medalBronzeFillColor // ignore: cast_nullable_to_non_nullable
as Color,medalGoldTextColor: null == medalGoldTextColor ? _self.medalGoldTextColor : medalGoldTextColor // ignore: cast_nullable_to_non_nullable
as Color,medalSilverTextColor: null == medalSilverTextColor ? _self.medalSilverTextColor : medalSilverTextColor // ignore: cast_nullable_to_non_nullable
as Color,medalBronzeTextColor: null == medalBronzeTextColor ? _self.medalBronzeTextColor : medalBronzeTextColor // ignore: cast_nullable_to_non_nullable
as Color,medalGoldAccentColor: null == medalGoldAccentColor ? _self.medalGoldAccentColor : medalGoldAccentColor // ignore: cast_nullable_to_non_nullable
as Color,medalSilverAccentColor: null == medalSilverAccentColor ? _self.medalSilverAccentColor : medalSilverAccentColor // ignore: cast_nullable_to_non_nullable
as Color,medalBronzeAccentColor: null == medalBronzeAccentColor ? _self.medalBronzeAccentColor : medalBronzeAccentColor // ignore: cast_nullable_to_non_nullable
as Color,elementBorderRadius: null == elementBorderRadius ? _self.elementBorderRadius : elementBorderRadius // ignore: cast_nullable_to_non_nullable
as double,junctionCornerRadius: null == junctionCornerRadius ? _self.junctionCornerRadius : junctionCornerRadius // ignore: cast_nullable_to_non_nullable
as double,borderStrokeWidth: null == borderStrokeWidth ? _self.borderStrokeWidth : borderStrokeWidth // ignore: cast_nullable_to_non_nullable
as double,subtleStrokeWidth: null == subtleStrokeWidth ? _self.subtleStrokeWidth : subtleStrokeWidth // ignore: cast_nullable_to_non_nullable
as double,wonConnectorStrokeWidth: null == wonConnectorStrokeWidth ? _self.wonConnectorStrokeWidth : wonConnectorStrokeWidth // ignore: cast_nullable_to_non_nullable
as double,canvasMargin: null == canvasMargin ? _self.canvasMargin : canvasMargin // ignore: cast_nullable_to_non_nullable
as double,sectionGapHeight: null == sectionGapHeight ? _self.sectionGapHeight : sectionGapHeight // ignore: cast_nullable_to_non_nullable
as double,accentStripWidth: null == accentStripWidth ? _self.accentStripWidth : accentStripWidth // ignore: cast_nullable_to_non_nullable
as double,badgeMinRadius: null == badgeMinRadius ? _self.badgeMinRadius : badgeMinRadius // ignore: cast_nullable_to_non_nullable
as double,badgePadding: null == badgePadding ? _self.badgePadding : badgePadding // ignore: cast_nullable_to_non_nullable
as double,matchPillMinHalfWidth: null == matchPillMinHalfWidth ? _self.matchPillMinHalfWidth : matchPillMinHalfWidth // ignore: cast_nullable_to_non_nullable
as double,matchPillHorizontalPadding: null == matchPillHorizontalPadding ? _self.matchPillHorizontalPadding : matchPillHorizontalPadding // ignore: cast_nullable_to_non_nullable
as double,matchPillMinHalfHeight: null == matchPillMinHalfHeight ? _self.matchPillMinHalfHeight : matchPillMinHalfHeight // ignore: cast_nullable_to_non_nullable
as double,matchPillVerticalPadding: null == matchPillVerticalPadding ? _self.matchPillVerticalPadding : matchPillVerticalPadding // ignore: cast_nullable_to_non_nullable
as double,dashedLineDashWidth: null == dashedLineDashWidth ? _self.dashedLineDashWidth : dashedLineDashWidth // ignore: cast_nullable_to_non_nullable
as double,dashedLineGapWidth: null == dashedLineGapWidth ? _self.dashedLineGapWidth : dashedLineGapWidth // ignore: cast_nullable_to_non_nullable
as double,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,headerLetterSpacing: null == headerLetterSpacing ? _self.headerLetterSpacing : headerLetterSpacing // ignore: cast_nullable_to_non_nullable
as double,subHeaderLetterSpacing: null == subHeaderLetterSpacing ? _self.subHeaderLetterSpacing : subHeaderLetterSpacing // ignore: cast_nullable_to_non_nullable
as double,rowHeight: null == rowHeight ? _self.rowHeight : rowHeight // ignore: cast_nullable_to_non_nullable
as double,intraMatchGapHeight: null == intraMatchGapHeight ? _self.intraMatchGapHeight : intraMatchGapHeight // ignore: cast_nullable_to_non_nullable
as double,interMatchGapHeight: null == interMatchGapHeight ? _self.interMatchGapHeight : interMatchGapHeight // ignore: cast_nullable_to_non_nullable
as double,numberColumnWidth: null == numberColumnWidth ? _self.numberColumnWidth : numberColumnWidth // ignore: cast_nullable_to_non_nullable
as double,nameColumnWidth: null == nameColumnWidth ? _self.nameColumnWidth : nameColumnWidth // ignore: cast_nullable_to_non_nullable
as double,registrationIdColumnWidth: null == registrationIdColumnWidth ? _self.registrationIdColumnWidth : registrationIdColumnWidth // ignore: cast_nullable_to_non_nullable
as double,roundColumnWidth: null == roundColumnWidth ? _self.roundColumnWidth : roundColumnWidth // ignore: cast_nullable_to_non_nullable
as double,headerTotalHeight: null == headerTotalHeight ? _self.headerTotalHeight : headerTotalHeight // ignore: cast_nullable_to_non_nullable
as double,subHeaderRowHeight: null == subHeaderRowHeight ? _self.subHeaderRowHeight : subHeaderRowHeight // ignore: cast_nullable_to_non_nullable
as double,centerGapWidth: null == centerGapWidth ? _self.centerGapWidth : centerGapWidth // ignore: cast_nullable_to_non_nullable
as double,sectionLabelHeight: null == sectionLabelHeight ? _self.sectionLabelHeight : sectionLabelHeight // ignore: cast_nullable_to_non_nullable
as double,medalTableWidth: null == medalTableWidth ? _self.medalTableWidth : medalTableWidth // ignore: cast_nullable_to_non_nullable
as double,medalRowHeight: null == medalRowHeight ? _self.medalRowHeight : medalRowHeight // ignore: cast_nullable_to_non_nullable
as double,medalNameColumnWidth: null == medalNameColumnWidth ? _self.medalNameColumnWidth : medalNameColumnWidth // ignore: cast_nullable_to_non_nullable
as double,medalLabelColumnWidth: null == medalLabelColumnWidth ? _self.medalLabelColumnWidth : medalLabelColumnWidth // ignore: cast_nullable_to_non_nullable
as double,medalRowGap: null == medalRowGap ? _self.medalRowGap : medalRowGap // ignore: cast_nullable_to_non_nullable
as double,centerFinalMinimumSpan: null == centerFinalMinimumSpan ? _self.centerFinalMinimumSpan : centerFinalMinimumSpan // ignore: cast_nullable_to_non_nullable
as double,grandFinalOutputArmLength: null == grandFinalOutputArmLength ? _self.grandFinalOutputArmLength : grandFinalOutputArmLength // ignore: cast_nullable_to_non_nullable
as double,badgeHorizontalOffset: null == badgeHorizontalOffset ? _self.badgeHorizontalOffset : badgeHorizontalOffset // ignore: cast_nullable_to_non_nullable
as double,badgeBlueVerticalOffset: null == badgeBlueVerticalOffset ? _self.badgeBlueVerticalOffset : badgeBlueVerticalOffset // ignore: cast_nullable_to_non_nullable
as double,badgeRedVerticalOffset: null == badgeRedVerticalOffset ? _self.badgeRedVerticalOffset : badgeRedVerticalOffset // ignore: cast_nullable_to_non_nullable
as double,missingInputVerticalOffset: null == missingInputVerticalOffset ? _self.missingInputVerticalOffset : missingInputVerticalOffset // ignore: cast_nullable_to_non_nullable
as double,thirdPlaceToMedalGap: null == thirdPlaceToMedalGap ? _self.thirdPlaceToMedalGap : thirdPlaceToMedalGap // ignore: cast_nullable_to_non_nullable
as double,matchPillHorizontalOffset: null == matchPillHorizontalOffset ? _self.matchPillHorizontalOffset : matchPillHorizontalOffset // ignore: cast_nullable_to_non_nullable
as double,headerBannerHeight: null == headerBannerHeight ? _self.headerBannerHeight : headerBannerHeight // ignore: cast_nullable_to_non_nullable
as double,logoMaxHeight: null == logoMaxHeight ? _self.logoMaxHeight : logoMaxHeight // ignore: cast_nullable_to_non_nullable
as double,logoPadding: null == logoPadding ? _self.logoPadding : logoPadding // ignore: cast_nullable_to_non_nullable
as double,matchPillFillColor: null == matchPillFillColor ? _self.matchPillFillColor : matchPillFillColor // ignore: cast_nullable_to_non_nullable
as Color,badgeTextColor: null == badgeTextColor ? _self.badgeTextColor : badgeTextColor // ignore: cast_nullable_to_non_nullable
as Color,sectionLabelBackgroundOpacity: null == sectionLabelBackgroundOpacity ? _self.sectionLabelBackgroundOpacity : sectionLabelBackgroundOpacity // ignore: cast_nullable_to_non_nullable
as double,headerSecondaryTextOpacity: null == headerSecondaryTextOpacity ? _self.headerSecondaryTextOpacity : headerSecondaryTextOpacity // ignore: cast_nullable_to_non_nullable
as double,badgeOutlineOpacity: null == badgeOutlineOpacity ? _self.badgeOutlineOpacity : badgeOutlineOpacity // ignore: cast_nullable_to_non_nullable
as double,canvasMinimumWidth: null == canvasMinimumWidth ? _self.canvasMinimumWidth : canvasMinimumWidth // ignore: cast_nullable_to_non_nullable
as double,canvasMinimumHeight: null == canvasMinimumHeight ? _self.canvasMinimumHeight : canvasMinimumHeight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

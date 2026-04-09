import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/core/utils/color_json_converter.dart';

part 'tie_sheet_theme_config.freezed.dart';
part 'tie_sheet_theme_config.g.dart';

/// The visual mode applied to the bracket canvas.
///
/// [colourful] uses the colourful palette.
/// [highContrast] switches to a high-contrast all-black-on-white appearance
/// so the bracket reproduces cleanly on paper or PDF.
enum TieSheetThemeMode {
  colourful('Colourful'),
  highContrast('High Contrast'),
  customMode('Custom');

  const TieSheetThemeMode(this.label);

  /// Human-readable label shown in the app bar toggle.
  final String label;
}

/// Immutable set of **all** colour / style / geometry tokens consumed by
/// [TieSheetLayoutEngine] and [TieSheetSyncfusionPdfRendererService].
///
/// Use the static preset factories ([colourfulPreset], [highContrastPreset]) to pick
/// a preset, or supply custom values via [copyWith].
@Freezed(toStringOverride: false)
abstract class TieSheetThemeConfig with _$TieSheetThemeConfig {
  const TieSheetThemeConfig._();

  const factory TieSheetThemeConfig({
    /// Muted colour used for generic connectors, BYE dashed lines,
    /// TBD placeholder text, and unresolved junction lines.
    @ColorJsonConverter() required Color mutedColor,

    /// Resolved connector stroke colour (winner advancement lines).
    @ColorJsonConverter() required Color connectorWonColor,

    /// Canvas background fill.
    @ColorJsonConverter() required Color canvasBackgroundColor,

    /// Unified border stroke colour for cards, TBD outlines, and pending
    /// dashed connectors.
    @ColorJsonConverter() required Color borderColor,

    /// Uniform stroke width for all connector / junction lines.
    /// In default mode each pen chooses its own width.
    /// In print mode a single uniform value is used for all connectors.
    required double connectorStrokeWidth,

    /// When `true`, all interactive overlays (match taps, drag-swap,
    /// participant slot taps) are suppressed on the canvas widget.
    required bool isInteractivityDisabled,

    /// Primary text colour (headings, names, numbers).
    @ColorJsonConverter() required Color primaryTextColor,

    /// Secondary text colour (subtle / supporting text).
    @ColorJsonConverter() required Color secondaryTextColor,

    /// When `true`, **every** text span is rendered bold regardless of
    /// the font-weight specified by the painter.
    required bool isTextForceBold,

    /// Additive font-size adjustment applied to **every** text span.
    required double fontSizeDelta,

    /// Participant card background fill.
    @ColorJsonConverter() required Color rowFillColor,

    /// Info-row / sub-header background fill.
    @ColorJsonConverter() required Color headerFillColor,

    /// TBD placeholder card background fill.
    @ColorJsonConverter() required Color tbdFillColor,

    /// Top banner background colour.
    @ColorJsonConverter() required Color headerBannerBackgroundColor,

    /// Top banner text colour.
    @ColorJsonConverter() required Color headerBannerTextColor,

    /// Participant row accent strip colour (left/right edge coloured strip).
    @ColorJsonConverter() required Color participantAccentStripColor,

    /// Blue-corner badge colour.
    @ColorJsonConverter() required Color blueCornerColor,

    /// Red-corner badge colour.
    @ColorJsonConverter() required Color redCornerColor,

    /// Winners bracket section-label colour.
    @ColorJsonConverter() required Color winnersLabelColor,

    /// Losers bracket section-label colour.
    @ColorJsonConverter() required Color losersLabelColor,

    @ColorJsonConverter() required Color medalGoldFillColor,
    @ColorJsonConverter() required Color medalSilverFillColor,
    @ColorJsonConverter() required Color medalBronzeFillColor,
    @ColorJsonConverter() required Color medalGoldTextColor,
    @ColorJsonConverter() required Color medalSilverTextColor,
    @ColorJsonConverter() required Color medalBronzeTextColor,
    @ColorJsonConverter() required Color medalGoldAccentColor,
    @ColorJsonConverter() required Color medalSilverAccentColor,
    @ColorJsonConverter() required Color medalBronzeAccentColor,


    /// Primary stroke width for borders, outlines, dividers, and pending
    /// connector lines.
    required double borderStrokeWidth,

    /// Subtle stroke width for secondary borders.
    required double subtleStrokeWidth,

    /// Stroke width for resolved / won connector lines.
    required double wonConnectorStrokeWidth,

    /// Canvas margin (padding around all edges of the canvas).
    required double canvasMargin,

    /// Vertical gap between Winners and Losers bracket sections (DE only).
    required double sectionGapHeight,

    /// Width of the coloured accent strip on participant card edges.
    required double accentStripWidth,

    /// Minimum half-size for square corner badges (B / R).
    required double badgeMinHalfSize,

    /// Padding added around badge text to compute dynamic radius.
    required double badgePadding,

    /// Minimum half-width for match number pills.
    required double matchPillMinHalfWidth,

    /// Horizontal padding for match number pill text.
    required double matchPillHorizontalPadding,

    /// Minimum half-height for match number pills.
    required double matchPillMinHalfHeight,

    /// Vertical padding for match number pill text.
    required double matchPillVerticalPadding,

    /// Width of each dash segment in dashed connector lines.
    required double dashedLineDashWidth,

    /// Gap between dash segments in dashed connector lines.
    required double dashedLineGapWidth,

    /// Font family applied to all text rendered on the canvas.
    required String fontFamily,

    /// Letter spacing for the main tournament title in the header banner.
    required double headerLetterSpacing,

    /// Letter spacing for sub-header text (date, venue) in the header banner.
    required double subHeaderLetterSpacing,

    /// Base height of a single participant row (px).
    required double rowHeight,

    /// Vertical gap between blue & red rows within a single match (px).
    required double intraMatchGapHeight,

    /// Vertical gap between consecutive match pairs (px).
    required double interMatchGapHeight,

    /// Width of the serial-number column (px).
    required double numberColumnWidth,

    /// Width of the participant name column (px).
    required double nameColumnWidth,

    /// Width of the registration-ID column (px).
    required double registrationIdColumnWidth,

    /// Width of each bracket round column (px).
    required double roundColumnWidth,

    /// Total height of the full header area (banner + info row, px).
    required double headerTotalHeight,

    /// Height of the tournament info sub-header row (px).
    required double subHeaderRowHeight,

    /// Horizontal gap between left and right bracket halves (SE only, px).
    required double centerGapWidth,

    /// Height of the Winners/Losers section label bar (px).
    required double sectionLabelHeight,

    /// Total width of the medal table (px).
    required double medalTableWidth,

    /// Height of each medal row (px).
    required double medalRowHeight,

    /// Width of the name column inside the medal table (px).
    required double medalNameColumnWidth,

    /// Width of the label column inside the medal table (px).
    required double medalLabelColumnWidth,

    /// Vertical gap between medal rows (px).
    required double medalRowGap,

    /// Minimum vertical span for center-final junction arms (px).
    required double centerFinalMinimumSpan,

    /// Horizontal arm length for grand-final output connector (px).
    required double grandFinalOutputArmLength,

    /// Horizontal offset for corner badges relative to junction center (px).
    required double badgeHorizontalOffset,

    /// Vertical offset for blue corner badge from junction arm (px).
    required double badgeBlueVerticalOffset,

    /// Vertical offset for red corner badge from junction arm (px).
    required double badgeRedVerticalOffset,

    /// Vertical offset for missing input placeholder from junction center (px).
    required double missingInputVerticalOffset,

    /// Vertical gap between 3rd place match and medal table (px).
    required double thirdPlaceToMedalGap,

    /// Horizontal offset for match number pill relative to junction center (px).
    required double matchPillHorizontalOffset,

    /// Base height of the dark header banner (before fontSizeDelta scaling, px).
    required double headerBannerHeight,

    /// Maximum display height for logo images (px).
    required double logoMaxHeight,

    /// Padding below the logo row before the header banner starts (px).
    required double logoPadding,

    /// Fill colour for match number pills.
    @ColorJsonConverter() required Color matchPillFillColor,

    /// Text colour inside corner badges (B / R).
    @ColorJsonConverter() required Color badgeTextColor,

    /// Background opacity for section label fill (0.0–1.0).
    required double sectionLabelBackgroundOpacity,

    /// Text opacity for secondary header text (subtitle + organizer, 0.0–1.0).
    required double headerSecondaryTextOpacity,

    /// Outline opacity for corner badges B/R (0.0–1.0).
    required double badgeOutlineOpacity,

    /// Minimum canvas width in logical pixels.
    required double canvasMinimumWidth,

    /// Minimum canvas height in logical pixels.
    required double canvasMinimumHeight,

    // ── Header text positioning (inside banner) ────────────────────────────

    /// Top padding of the tournament title text inside the header banner (px).
    required double headerTitleTopPadding,

    /// Vertical offset of the subtitle (date/venue) line from the banner top (px).
    required double headerSubtitleTopOffset,

    /// Vertical offset of the organiser line from the banner top (px).
    required double headerOrganizerTopOffset,

    /// Gap between the header banner bottom edge and the info row (px).
    required double headerBannerBottomGap,

    // ── Layout gaps & spacers ──────────────────────────────────────────────

    /// Gap between the sub-header info row and the bracket table (px).
    required double headerToTableGap,

    /// Gap between a section label bar and the R1 rows beneath it (DE, px).
    required double sectionLabelToTableGap,

    /// Gap between losers bracket bottom and the medal table (DE only, px).
    required double deCanvasBracketToMedalGap,

    /// Fine-tune vertical offset for the medal table position (px).
    required double medalTableTopPadding,

    /// Extra horizontal padding added to the DE canvas width calculation (px).
    required double deCanvasExtraWidthPadding,

    // ── Info row sizing ────────────────────────────────────────────────────

    /// Vertical inset for column dividers inside the classification info row (px).
    required double classificationDividerInset,

    // ── Base font sizes ────────────────────────────────────────────────────

    /// Base font size for the tournament title (before fontSizeDelta scaling).
    required double headerTitleBaseFontSize,

    /// Base font size for the subtitle line (date/venue, before fontSizeDelta).
    required double headerSubtitleBaseFontSize,

    /// Base font size for the organiser line (before fontSizeDelta scaling).
    required double headerOrganizerBaseFontSize,

    /// Base font size for match number pill text (before fontSizeDelta scaling).
    required double matchPillBaseFontSize,
  }) = _TieSheetThemeConfig;

  factory TieSheetThemeConfig.fromJson(Map<String, dynamic> json) =>
      _$TieSheetThemeConfigFromJson(json);

  /// Computed height of the logo row (logoMaxHeight + 2 × logoPadding).
  double get logoRowHeight => logoMaxHeight + logoPadding * 2;

  /// Colourful palette — matches the original hardcoded values.
  static const TieSheetThemeConfig colourfulPreset = TieSheetThemeConfig(
    // Connector / junction
    mutedColor: Color(0xFF64748B),
    connectorWonColor: Color(0xFF334155),
    // Canvas & card
    canvasBackgroundColor: Color(0xFFFFFEFC),
    borderColor: Color(0xFF94A3B8),
    connectorStrokeWidth: 4.0,
    isInteractivityDisabled: false,
    // Text
    primaryTextColor: Color(0xFF1E293B),
    secondaryTextColor: Color(0xFF64748B),
    isTextForceBold: true,
    fontSizeDelta: 5.5,
    // Fill
    rowFillColor: Color(0xFFF8FAFC),
    headerFillColor: Color(0xFFE2E8F0),
    tbdFillColor: Color(0xFFF1F5F9),
    // Header banner
    headerBannerBackgroundColor: Color(0xFF1E293B),
    headerBannerTextColor: Color(0xFFFFFFFF),
    // Accent & badge
    participantAccentStripColor: Color(0xFF2563EB),
    blueCornerColor: Color(0xFF2563EB),
    redCornerColor: Color(0xFFDC2626),
    // Section labels
    winnersLabelColor: Color(0xFF2563EB),
    losersLabelColor: Color(0xFFDC2626),
    // Medal table
    medalGoldFillColor: Color(0xFFFEF9C3),
    medalSilverFillColor: Color(0xFFF1F5F9),
    medalBronzeFillColor: Color(0xFFFED7AA),
    medalGoldTextColor: Color(0xFF92400E),
    medalSilverTextColor: Color(0xFF475569),
    medalBronzeTextColor: Color(0xFF9A3412),
    medalGoldAccentColor: Color(0xFFF59E0B),
    medalSilverAccentColor: Color(0xFF94A3B8),
    medalBronzeAccentColor: Color(0xFFF97316),
    // Stroke widths
    borderStrokeWidth: 4.0,
    subtleStrokeWidth: 4.0,
    wonConnectorStrokeWidth: 4.0,
    // Spacing
    canvasMargin: 36.0,
    sectionGapHeight: 50.0,
    accentStripWidth: 4.0,
    // Badge & pill sizing
    badgeMinHalfSize: 10.0,
    badgePadding: 4.0,
    matchPillMinHalfWidth: 16.0,
    matchPillHorizontalPadding: 8.0,
    matchPillMinHalfHeight: 11.0,
    matchPillVerticalPadding: 4.0,
    // Dashed line
    dashedLineDashWidth: 6.0,
    dashedLineGapWidth: 4.0,
    // Typography
    fontFamily: 'Roboto',
    headerLetterSpacing: 1.2,
    subHeaderLetterSpacing: 0.5,
    // Layout dimensions
    rowHeight: 42.0,
    intraMatchGapHeight: 60.0,
    interMatchGapHeight: 100.0,
    numberColumnWidth: 32.0,
    nameColumnWidth: 200.0,
    registrationIdColumnWidth: 150.0,
    roundColumnWidth: 170.0,
    headerTotalHeight: 100.0,
    subHeaderRowHeight: 28.0,
    centerGapWidth: 340.0,
    sectionLabelHeight: 32.0,
    // Medal table layout
    medalTableWidth: 590.0,
    medalRowHeight: 54.0,
    medalNameColumnWidth: 455.0,
    medalLabelColumnWidth: 120.0,
    medalRowGap: 7.0,
    // Junction geometry
    centerFinalMinimumSpan: 60.0,
    grandFinalOutputArmLength: 40.0,
    badgeHorizontalOffset: 16.0,
    badgeBlueVerticalOffset: -6.0,
    badgeRedVerticalOffset: 14.0,
    missingInputVerticalOffset: 40.0,
    thirdPlaceToMedalGap: 60.0,
    matchPillHorizontalOffset: 0.0,
    // Banner & logo
    headerBannerHeight: 90.0,
    logoMaxHeight: 105.0,
    logoPadding: 18.0,
    // Additional colours
    matchPillFillColor: Color(0xFFFFFFFF),
    badgeTextColor: Color(0xFFFFFFFF),
    // Opacity
    sectionLabelBackgroundOpacity: 0.1,
    headerSecondaryTextOpacity: 0.65,
    badgeOutlineOpacity: 0.3,
    // Canvas constraints
    canvasMinimumWidth: 800.0,
    canvasMinimumHeight: 1150.0,
    // Header text positioning
    headerTitleTopPadding: 8.0,
    headerSubtitleTopOffset: 30.0,
    headerOrganizerTopOffset: 46.0,
    headerBannerBottomGap: 12.0,
    // Layout gaps
    headerToTableGap: 12.0,
    sectionLabelToTableGap: 8.0,
    deCanvasBracketToMedalGap: 60.0,
    medalTableTopPadding: 10.0,
    deCanvasExtraWidthPadding: 100.0,
    // Info row sizing
    classificationDividerInset: 3.0,
    // Base font sizes
    headerTitleBaseFontSize: 18.0,
    headerSubtitleBaseFontSize: 11.0,
    headerOrganizerBaseFontSize: 10.0,
    matchPillBaseFontSize: 10.0,
  );

  /// High-contrast print palette — pure black text, no background fills,
  /// borders-only elements, zero shadows. Optimised for monochrome printing.
  static const TieSheetThemeConfig highContrastPreset = TieSheetThemeConfig(
    // Connector / junction
    mutedColor: Color(0xFF000000),
    connectorWonColor: Color(0xFF000000),
    // Canvas & card
    canvasBackgroundColor: Color(0xFFFFFFFF),
    borderColor: Color(0xFF000000),
    connectorStrokeWidth: 4.0,
    isInteractivityDisabled: true,
    // Text
    primaryTextColor: Color(0xFF000000),
    secondaryTextColor: Color(0xFF000000),
    isTextForceBold: true,
    fontSizeDelta: 5.5,
    // Fill
    rowFillColor: Color(0xFFFFFFFF),
    headerFillColor: Color(0xFFFFFFFF),
    tbdFillColor: Color(0xFFFFFFFF),
    // Header banner
    headerBannerBackgroundColor: Color(0xFFFFFFFF),
    headerBannerTextColor: Color(0xFF000000),
    // Accent & badge
    participantAccentStripColor: Color(0xFF000000),
    blueCornerColor: Color(0xFF2563EB),
    redCornerColor: Color(0xFFDC2626),
    // Section labels
    winnersLabelColor: Color(0xFF000000),
    losersLabelColor: Color(0xFF000000),
    // Medal table
    medalGoldFillColor: Color(0xFFFFFFFF),
    medalSilverFillColor: Color(0xFFFFFFFF),
    medalBronzeFillColor: Color(0xFFFFFFFF),
    medalGoldTextColor: Color(0xFF000000),
    medalSilverTextColor: Color(0xFF000000),
    medalBronzeTextColor: Color(0xFF000000),
    medalGoldAccentColor: Color(0xFF000000),
    medalSilverAccentColor: Color(0xFF000000),
    medalBronzeAccentColor: Color(0xFF000000),
    // Stroke widths
    borderStrokeWidth: 4.0,
    subtleStrokeWidth: 4.0,
    wonConnectorStrokeWidth: 4.0,
    // Spacing
    canvasMargin: 36.0,
    sectionGapHeight: 50.0,
    accentStripWidth: 4.0,
    // Badge & pill sizing
    badgeMinHalfSize: 10.0,
    badgePadding: 4.0,
    matchPillMinHalfWidth: 16.0,
    matchPillHorizontalPadding: 8.0,
    matchPillMinHalfHeight: 11.0,
    matchPillVerticalPadding: 4.0,
    // Dashed line
    dashedLineDashWidth: 6.0,
    dashedLineGapWidth: 4.0,
    // Typography
    fontFamily: 'Roboto',
    headerLetterSpacing: 1.2,
    subHeaderLetterSpacing: 0.5,
    // Layout dimensions
    rowHeight: 42.0,
    intraMatchGapHeight: 60.0,
    interMatchGapHeight: 100.0,
    numberColumnWidth: 32.0,
    nameColumnWidth: 200.0,
    registrationIdColumnWidth: 150.0,
    roundColumnWidth: 170.0,
    headerTotalHeight: 100.0,
    subHeaderRowHeight: 28.0,
    centerGapWidth: 340.0,
    sectionLabelHeight: 32.0,
    // Medal table layout
    medalTableWidth: 590.0,
    medalRowHeight: 54.0,
    medalNameColumnWidth: 455.0,
    medalLabelColumnWidth: 120.0,
    medalRowGap: 7.0,
    // Junction geometry
    centerFinalMinimumSpan: 60.0,
    grandFinalOutputArmLength: 40.0,
    badgeHorizontalOffset: 16.0,
    badgeBlueVerticalOffset: -6.0,
    badgeRedVerticalOffset: 14.0,
    missingInputVerticalOffset: 40.0,
    thirdPlaceToMedalGap: 60.0,
    matchPillHorizontalOffset: 0.0,
    // Banner & logo
    headerBannerHeight: 90.0,
    logoMaxHeight: 105.0,
    logoPadding: 18.0,
    // Additional colours
    matchPillFillColor: Color(0xFFFFFFFF),
    badgeTextColor: Color(0xFFFFFFFF),
    // Opacity
    sectionLabelBackgroundOpacity: 0.0,
    headerSecondaryTextOpacity: 0.8,
    badgeOutlineOpacity: 1.0,
    // Canvas constraints
    canvasMinimumWidth: 800.0,
    canvasMinimumHeight: 1150.0,
    // Header text positioning
    headerTitleTopPadding: 8.0,
    headerSubtitleTopOffset: 30.0,
    headerOrganizerTopOffset: 46.0,
    headerBannerBottomGap: 12.0,
    // Layout gaps
    headerToTableGap: 12.0,
    sectionLabelToTableGap: 8.0,
    deCanvasBracketToMedalGap: 60.0,
    medalTableTopPadding: 10.0,
    deCanvasExtraWidthPadding: 100.0,
    // Info row sizing
    classificationDividerInset: 3.0,
    // Base font sizes
    headerTitleBaseFontSize: 18.0,
    headerSubtitleBaseFontSize: 11.0,
    headerOrganizerBaseFontSize: 10.0,
    matchPillBaseFontSize: 10.0,
  );

  // ── Factory helper ────────────────────────────────────────────────────────

  /// Returns the preset config for the given [mode].
  factory TieSheetThemeConfig.fromMode(TieSheetThemeMode mode) {
    return switch (mode) {
      TieSheetThemeMode.colourful => colourfulPreset,
      TieSheetThemeMode.highContrast => highContrastPreset,
      // Custom mode starts from the colourful preset; the caller overrides
      // individual tokens via [copyWith].
      TieSheetThemeMode.customMode => colourfulPreset,
    };
  }
}

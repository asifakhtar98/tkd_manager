import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tie_sheet_theme_config.freezed.dart';

// ══════════════════════════════════════════════════════════════════════════════
// TIE SHEET THEME MODE
// ══════════════════════════════════════════════════════════════════════════════

/// The visual mode applied to the bracket canvas.
///
/// [defaultMode] uses the standard on-screen palette.
/// [printMode] switches to a high-contrast all-black-on-white appearance
/// so the bracket reproduces cleanly on paper or PDF.
enum TieSheetThemeMode {
  defaultMode('Screen'),
  printMode('Print'),
  customMode('Custom');

  const TieSheetThemeMode(this.label);

  /// Human-readable label shown in the app bar toggle.
  final String label;
}

// ══════════════════════════════════════════════════════════════════════════════
// TIE SHEET THEME CONFIG
// ══════════════════════════════════════════════════════════════════════════════

/// Immutable set of **all** colour / style / geometry tokens consumed by
/// [TieSheetPainter].
///
/// Use the static preset factories ([defaultPreset], [printPreset]) to pick
/// a preset, or supply custom values via [copyWith].
@Freezed(toStringOverride: false)
abstract class TieSheetThemeConfig with _$TieSheetThemeConfig {
  const TieSheetThemeConfig._();

  const factory TieSheetThemeConfig({
    // ── Connector / junction tokens ─────────────────────────────────────────

    /// Muted colour used for generic connectors, BYE dashed lines,
    /// TBD placeholder text, and unresolved junction lines.
    required Color mutedColor,

    /// Resolved connector stroke colour (winner advancement lines).
    required Color connectorWonColor,

    // ── Canvas & card tokens ────────────────────────────────────────────────

    /// Canvas background fill.
    required Color canvasBackgroundColor,

    /// Unified border stroke colour for cards, TBD outlines, and pending
    /// dashed connectors.
    required Color borderColor,

    /// Shadow paint opacity multiplier (0.0 = no shadow, 1.0 = full shadow).
    required double shadowOpacityMultiplier,

    /// Uniform stroke width for all connector / junction lines.
    /// In default mode each pen chooses its own width.
    /// In print mode a single uniform value is used for all connectors.
    required double connectorStrokeWidth,

    /// When `true`, all interactive overlays (match taps, drag-swap,
    /// participant slot taps) are suppressed on the canvas widget.
    required bool isInteractivityDisabled,

    // ── Text tokens ─────────────────────────────────────────────────────────

    /// Primary text colour (headings, names, numbers).
    required Color primaryTextColor,

    /// Secondary text colour (subtle / supporting text).
    required Color secondaryTextColor,

    /// When `true`, **every** text span is rendered bold regardless of
    /// the font-weight specified by the painter.
    required bool isTextForceBold,

    /// Additive font-size adjustment applied to **every** text span.
    required double fontSizeDelta,

    // ── Fill tokens ─────────────────────────────────────────────────────────

    /// Participant card background fill.
    required Color rowFillColor,

    /// Info-row / sub-header background fill.
    required Color headerFillColor,

    /// TBD placeholder card background fill.
    required Color tbdFillColor,

    // ── Header banner ───────────────────────────────────────────────────────

    /// Top banner background colour.
    required Color headerBannerBackgroundColor,

    /// Top banner text colour.
    required Color headerBannerTextColor,

    // ── Accent & badge tokens ───────────────────────────────────────────────

    /// Participant row accent strip colour (left/right edge coloured strip).
    required Color participantAccentStripColor,

    /// Blue-corner badge colour.
    required Color blueCornerColor,

    /// Red-corner badge colour.
    required Color redCornerColor,

    // ── Section label tokens (DE brackets) ──────────────────────────────────

    /// Winners bracket section-label colour.
    required Color winnersLabelColor,

    /// Losers bracket section-label colour.
    required Color losersLabelColor,

    // ── Medal table tokens ──────────────────────────────────────────────────

    required Color medalGoldFillColor,
    required Color medalSilverFillColor,
    required Color medalBronzeFillColor,
    required Color medalGoldTextColor,
    required Color medalSilverTextColor,
    required Color medalBronzeTextColor,
    required Color medalGoldAccentColor,
    required Color medalSilverAccentColor,
    required Color medalBronzeAccentColor,

    // ── Shape / radius tokens ───────────────────────────────────────────────

    /// Unified border radius applied to all rectangular UI elements.
    required double elementBorderRadius,

    /// Corner radius for the Bezier curve arms on bracket junctions.
    required double junctionCornerRadius,

    // ── Stroke width tokens ─────────────────────────────────────────────────

    /// Primary stroke width for borders, outlines, dividers, and pending
    /// connector lines.
    required double borderStrokeWidth,

    /// Subtle stroke width for secondary borders.
    required double subtleStrokeWidth,

    /// Stroke width for resolved / won connector lines.
    required double wonConnectorStrokeWidth,

    // ── Spacing tokens ──────────────────────────────────────────────────────

    /// Canvas margin (padding around all edges of the canvas).
    required double canvasMargin,

    /// Vertical gap between Winners and Losers bracket sections (DE only).
    required double sectionGapHeight,

    /// Width of the coloured accent strip on participant card edges.
    required double accentStripWidth,

    // ── Badge & pill sizing tokens ──────────────────────────────────────────

    /// Minimum radius for corner badges (B / R).
    required double badgeMinRadius,

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

    // ── Dashed line tokens ──────────────────────────────────────────────────

    /// Width of each dash segment in dashed connector lines.
    required double dashedLineDashWidth,

    /// Gap between dash segments in dashed connector lines.
    required double dashedLineGapWidth,

    // ── Shadow tokens ───────────────────────────────────────────────────────

    /// Default blur radius for card elevation shadows.
    required double shadowBlurRadius,

    /// Base colour for card elevation shadows (before opacity scaling).
    required Color shadowColor,

    /// Horizontal offset for card elevation shadows (px).
    required double shadowOffsetX,

    /// Vertical offset for card elevation shadows (px).
    required double shadowOffsetY,

    // ── Typography tokens ───────────────────────────────────────────────────

    /// Font family applied to all text rendered on the canvas.
    required String fontFamily,

    /// Letter spacing for the main tournament title in the header banner.
    required double headerLetterSpacing,

    /// Letter spacing for sub-header text (date, venue) in the header banner.
    required double subHeaderLetterSpacing,

    // ── Layout dimension base tokens ────────────────────────────────────────

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

    // ── Medal table layout tokens ───────────────────────────────────────────

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

    // ── Junction geometry tokens ────────────────────────────────────────────

    /// Minimum vertical span for center-final junction arms (px).
    required double centerFinalMinimumSpan,

    /// Horizontal arm length for grand-final output connector (px).
    required double grandFinalOutputArmLength,

    // ── Banner & logo layout tokens ─────────────────────────────────────────

    /// Base height of the dark header banner (before fontSizeDelta scaling, px).
    required double headerBannerHeight,

    /// Maximum display height for logo images (px).
    required double logoMaxHeight,

    /// Padding below the logo row before the header banner starts (px).
    required double logoPadding,

    // ── Color tokens (additional) ───────────────────────────────────────────

    /// Fill colour for match number pills.
    required Color matchPillFillColor,

    /// Text colour inside corner badges (B / R).
    required Color badgeTextColor,

    // ── Opacity tokens ──────────────────────────────────────────────────────

    /// Background opacity for section label fill (0.0–1.0).
    required double sectionLabelBackgroundOpacity,

    /// Text opacity for secondary header text (subtitle + organizer, 0.0–1.0).
    required double headerSecondaryTextOpacity,

    /// Outline opacity for corner badges B/R (0.0–1.0).
    required double badgeOutlineOpacity,

    // ── Canvas constraint tokens ────────────────────────────────────────────

    /// Minimum canvas width in logical pixels.
    required double canvasMinimumWidth,

    /// Minimum canvas height in logical pixels.
    required double canvasMinimumHeight,
  }) = _TieSheetThemeConfig;

  // ── Computed getters ────────────────────────────────────────────────────────

  /// Computed height of the logo row (logoMaxHeight + 2 × logoPadding).
  double get logoRowHeight => logoMaxHeight + logoPadding * 2;

  // ── Named Presets ─────────────────────────────────────────────────────────

  /// Standard on-screen palette — matches the original hardcoded values.
  static const TieSheetThemeConfig defaultPreset = TieSheetThemeConfig(
    // Connector / junction
    mutedColor: Color(0xFF64748B),
    connectorWonColor: Color(0xFF334155),
    // Canvas & card
    canvasBackgroundColor: Color(0xFFFFFEFC),
    borderColor: Color(0xFF94A3B8),
    shadowOpacityMultiplier: 1.0,
    connectorStrokeWidth: 0.0,
    isInteractivityDisabled: false,
    // Text
    primaryTextColor: Color(0xFF1E293B),
    secondaryTextColor: Color(0xFF64748B),
    isTextForceBold: false,
    fontSizeDelta: 4.0,
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
    // Shape / radius
    elementBorderRadius: 6.0,
    junctionCornerRadius: 10.0,
    // Stroke widths
    borderStrokeWidth: 3.5,
    subtleStrokeWidth: 1.5,
    wonConnectorStrokeWidth: 4.0,
    // Spacing
    canvasMargin: 36.0,
    sectionGapHeight: 50.0,
    accentStripWidth: 4.0,
    // Badge & pill sizing
    badgeMinRadius: 10.0,
    badgePadding: 4.0,
    matchPillMinHalfWidth: 16.0,
    matchPillHorizontalPadding: 8.0,
    matchPillMinHalfHeight: 11.0,
    matchPillVerticalPadding: 4.0,
    // Dashed line
    dashedLineDashWidth: 6.0,
    dashedLineGapWidth: 4.0,
    // Shadow
    shadowBlurRadius: 6.0,
    shadowColor: Color(0x1A000000),
    shadowOffsetX: 1.0,
    shadowOffsetY: 2.0,
    // Typography
    fontFamily: 'Roboto',
    headerLetterSpacing: 1.2,
    subHeaderLetterSpacing: 0.5,
    // Layout dimensions
    rowHeight: 42.0,
    intraMatchGapHeight: 35.0,
    interMatchGapHeight: 100.0,
    numberColumnWidth: 32.0,
    nameColumnWidth: 200.0,
    registrationIdColumnWidth: 120.0,
    roundColumnWidth: 170.0,
    headerTotalHeight: 100.0,
    subHeaderRowHeight: 28.0,
    centerGapWidth: 340.0,
    sectionLabelHeight: 32.0,
    // Medal table layout
    medalTableWidth: 440.0,
    medalRowHeight: 36.0,
    medalNameColumnWidth: 250.0,
    medalLabelColumnWidth: 100.0,
    medalRowGap: 4.0,
    // Junction geometry
    centerFinalMinimumSpan: 60.0,
    grandFinalOutputArmLength: 40.0,
    // Banner & logo
    headerBannerHeight: 64.0,
    logoMaxHeight: 60.0,
    logoPadding: 12.0,
    // Additional colours
    matchPillFillColor: Color(0xFFFFFFFF),
    badgeTextColor: Color(0xFFFFFFFF),
    // Opacity
    sectionLabelBackgroundOpacity: 0.1,
    headerSecondaryTextOpacity: 0.65,
    badgeOutlineOpacity: 0.3,
    // Canvas constraints
    canvasMinimumWidth: 700.0,
    canvasMinimumHeight: 500.0,
  );

  /// High-contrast print palette — pure black text, no background fills,
  /// borders-only elements, zero shadows. Optimised for monochrome printing.
  static const TieSheetThemeConfig printPreset = TieSheetThemeConfig(
    // Connector / junction
    mutedColor: Color(0xFF000000),
    connectorWonColor: Color(0xFF000000),
    // Canvas & card
    canvasBackgroundColor: Color(0xFFFFFFFF),
    borderColor: Color(0xFF000000),
    shadowOpacityMultiplier: 0.0,
    connectorStrokeWidth: 3.0,
    isInteractivityDisabled: true,
    // Text
    primaryTextColor: Color(0xFF000000),
    secondaryTextColor: Color(0xFF000000),
    isTextForceBold: true,
    fontSizeDelta: 8.0,
    // Fill
    rowFillColor: Color(0xFFFFFFFF),
    headerFillColor: Color(0xFFFFFFFF),
    tbdFillColor: Color(0xFFFFFFFF),
    // Header banner
    headerBannerBackgroundColor: Color(0xFFFFFFFF),
    headerBannerTextColor: Color(0xFF000000),
    // Accent & badge
    participantAccentStripColor: Color(0xFF000000),
    blueCornerColor: Color(0xFF000000),
    redCornerColor: Color(0xFF000000),
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
    // Shape / radius (same as default — geometry stays consistent)
    elementBorderRadius: 6.0,
    junctionCornerRadius: 10.0,
    // Stroke widths
    borderStrokeWidth: 3.5,
    subtleStrokeWidth: 1.5,
    wonConnectorStrokeWidth: 4.0,
    // Spacing
    canvasMargin: 36.0,
    sectionGapHeight: 50.0,
    accentStripWidth: 4.0,
    // Badge & pill sizing
    badgeMinRadius: 10.0,
    badgePadding: 4.0,
    matchPillMinHalfWidth: 16.0,
    matchPillHorizontalPadding: 8.0,
    matchPillMinHalfHeight: 11.0,
    matchPillVerticalPadding: 4.0,
    // Dashed line
    dashedLineDashWidth: 6.0,
    dashedLineGapWidth: 4.0,
    // Shadow
    shadowBlurRadius: 6.0,
    shadowColor: Color(0x1A000000),
    shadowOffsetX: 1.0,
    shadowOffsetY: 2.0,
    // Typography
    fontFamily: 'Roboto',
    headerLetterSpacing: 1.2,
    subHeaderLetterSpacing: 0.5,
    // Layout dimensions
    rowHeight: 42.0,
    intraMatchGapHeight: 35.0,
    interMatchGapHeight: 100.0,
    numberColumnWidth: 32.0,
    nameColumnWidth: 200.0,
    registrationIdColumnWidth: 120.0,
    roundColumnWidth: 170.0,
    headerTotalHeight: 100.0,
    subHeaderRowHeight: 28.0,
    centerGapWidth: 340.0,
    sectionLabelHeight: 32.0,
    // Medal table layout
    medalTableWidth: 440.0,
    medalRowHeight: 36.0,
    medalNameColumnWidth: 250.0,
    medalLabelColumnWidth: 100.0,
    medalRowGap: 4.0,
    // Junction geometry
    centerFinalMinimumSpan: 60.0,
    grandFinalOutputArmLength: 40.0,
    // Banner & logo
    headerBannerHeight: 64.0,
    logoMaxHeight: 60.0,
    logoPadding: 12.0,
    // Additional colours
    matchPillFillColor: Color(0xFFFFFFFF),
    badgeTextColor: Color(0xFFFFFFFF),
    // Opacity
    sectionLabelBackgroundOpacity: 0.1,
    headerSecondaryTextOpacity: 0.65,
    badgeOutlineOpacity: 0.3,
    // Canvas constraints
    canvasMinimumWidth: 700.0,
    canvasMinimumHeight: 500.0,
  );

  // ── Factory helper ────────────────────────────────────────────────────────

  /// Returns the preset config for the given [mode].
  factory TieSheetThemeConfig.fromMode(TieSheetThemeMode mode) {
    return switch (mode) {
      TieSheetThemeMode.defaultMode => defaultPreset,
      TieSheetThemeMode.printMode => printPreset,
      // Custom mode starts from the default preset; the caller overrides
      // individual tokens via [copyWith].
      TieSheetThemeMode.customMode => defaultPreset,
    };
  }
}

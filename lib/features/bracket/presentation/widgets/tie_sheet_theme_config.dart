import 'dart:ui';

import 'package:flutter/foundation.dart';

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
/// Use one of the named constructors to pick a preset, or supply custom
/// values for testing.
@immutable
class TieSheetThemeConfig {
  // ── Connector / junction tokens ───────────────────────────────────────────

  /// Default connector stroke colour (unresolved junction lines).
  final Color connectorColor;

  /// Resolved connector stroke colour (winner advancement lines).
  final Color connectorWonColor;

  /// Pending / unresolved indicator colour (dashed outlines, TBD borders).
  final Color pendingColor;

  /// Muted colour for BYE dashed lines and TBD placeholder text.
  final Color mutedColor;

  // ── Canvas & card tokens ──────────────────────────────────────────────────

  /// Canvas background fill.
  final Color canvasBackgroundColor;

  /// Card / element border stroke colour.
  final Color cardBorderColor;

  /// Shadow paint opacity multiplier (0.0 = no shadow, 1.0 = full shadow).
  final double shadowOpacityMultiplier;

  /// Uniform stroke width for all connector / junction lines.
  /// In default mode each pen chooses its own width.
  /// In print mode a single uniform value is used for all connectors.
  final double connectorStrokeWidth;

  /// When `true`, all interactive overlays (match taps, drag-swap,
  /// participant slot taps) are suppressed on the canvas widget.
  final bool isInteractivityDisabled;

  // ── Text tokens ───────────────────────────────────────────────────────────

  /// Primary text colour (headings, names, numbers).
  final Color primaryTextColor;

  /// Secondary text colour (subtle / supporting text).
  final Color secondaryTextColor;

  /// When `true`, **every** text span is rendered bold regardless of
  /// the font-weight specified by the painter.
  final bool isTextForceBold;

  /// Additive font-size adjustment applied to **every** text span.
  ///
  /// A positive value increases all rendered text sizes by this many
  /// logical pixels while preserving the relative hierarchy between
  /// headings, body text, and badges.
  final double fontSizeDelta;

  // ── Fill tokens ───────────────────────────────────────────────────────────

  /// Participant card background fill.
  final Color rowFillColor;

  /// Info-row / sub-header background fill.
  final Color headerFillColor;

  /// TBD placeholder card background fill.
  final Color tbdFillColor;

  // ── Header banner ─────────────────────────────────────────────────────────

  /// Top banner background colour.
  final Color headerBannerBackgroundColor;

  /// Top banner text colour.
  final Color headerBannerTextColor;

  // ── Accent & badge tokens ─────────────────────────────────────────────────

  /// Participant row accent strip colour (left/right edge coloured strip).
  final Color participantAccentStripColor;

  /// Blue-corner badge colour.
  final Color blueCornerColor;

  /// Red-corner badge colour.
  final Color redCornerColor;

  // ── Section label tokens (DE brackets) ────────────────────────────────────

  /// Winners bracket section-label colour.
  final Color winnersLabelColor;

  /// Losers bracket section-label colour.
  final Color losersLabelColor;

  // ── Medal table tokens ────────────────────────────────────────────────────

  final Color medalGoldFillColor;
  final Color medalSilverFillColor;
  final Color medalBronzeFillColor;
  final Color medalGoldTextColor;
  final Color medalSilverTextColor;
  final Color medalBronzeTextColor;
  final Color medalGoldAccentColor;
  final Color medalSilverAccentColor;
  final Color medalBronzeAccentColor;

  // ── Shape / radius tokens ─────────────────────────────────────────────────

  /// Border radius applied to participant cards, medal rows, and info rows.
  final double cardBorderRadius;

  /// Border radius applied to the section labels (Winners/Losers Bracket).
  final double sectionLabelBorderRadius;

  /// Border radius applied to the dark header banner.
  final double headerBannerBorderRadius;

  /// Corner radius for the Bezier curve arms on bracket junctions.
  final double junctionCornerRadius;

  // ── Stroke width tokens ───────────────────────────────────────────────────

  /// Default stroke width for thick pens (borders and outlines).
  final double thickStrokeWidth;

  /// Default stroke width for thin pens (dividers and pending lines).
  final double thinStrokeWidth;

  /// Stroke width for resolved / won connector lines.
  final double wonConnectorStrokeWidth;

  /// Stroke width for BYE advancement dashed lines.
  final double byeConnectorStrokeWidth;

  // ── Spacing tokens ────────────────────────────────────────────────────────

  /// Canvas margin (padding around all edges of the canvas).
  final double canvasMargin;

  /// Vertical gap between Winners and Losers bracket sections (DE only).
  final double sectionGapHeight;

  /// Width of the coloured accent strip on participant card edges.
  final double accentStripWidth;

  /// Total height reserved for the logo row above the header banner.
  /// Includes the image height + bottom padding (e.g. 60px + 12px).
  final double logoRowHeight;

  // ── Badge & pill sizing tokens ────────────────────────────────────────────

  /// Minimum radius for corner badges (B / R).
  final double badgeMinRadius;

  /// Padding added around badge text to compute dynamic radius.
  final double badgePadding;

  /// Minimum half-width for match number pills.
  final double matchPillMinHalfWidth;

  /// Horizontal padding for match number pill text.
  final double matchPillHorizontalPadding;

  /// Minimum half-height for match number pills.
  final double matchPillMinHalfHeight;

  /// Vertical padding for match number pill text.
  final double matchPillVerticalPadding;

  // ── Dashed line tokens ────────────────────────────────────────────────────

  /// Width of each dash segment in dashed connector lines.
  final double dashedLineDashWidth;

  /// Gap between dash segments in dashed connector lines.
  final double dashedLineGapWidth;

  // ── Shadow tokens ─────────────────────────────────────────────────────────

  /// Default blur radius for card elevation shadows.
  final double shadowBlurRadius;

  /// Base colour for card elevation shadows (before opacity scaling).
  final Color shadowColor;

  // ── Typography tokens ─────────────────────────────────────────────────────

  /// Font family applied to all text rendered on the canvas.
  final String fontFamily;

  /// Letter spacing for the main tournament title in the header banner.
  final double headerLetterSpacing;

  /// Letter spacing for sub-header text (date, venue) in the header banner.
  final double subHeaderLetterSpacing;

  // ── Layout dimension base tokens ──────────────────────────────────────────
  //
  // These control the base pixel values for the bracket's structural layout.
  // Each is scaled additively by [fontSizeDelta] in the painter.

  /// Base height of a single participant row (px).
  final double rowHeight;

  /// Vertical gap between blue & red rows within a single match (px).
  final double intraMatchGapHeight;

  /// Vertical gap between consecutive match pairs (px).
  final double interMatchGapHeight;

  /// Width of the serial-number column (px).
  final double numberColumnWidth;

  /// Width of the participant name column (px).
  final double nameColumnWidth;

  /// Width of the registration-ID column (px).
  final double registrationIdColumnWidth;

  /// Width of each bracket round column (px).
  final double roundColumnWidth;

  /// Total height of the full header area (banner + info row, px).
  final double headerTotalHeight;

  /// Height of the tournament info sub-header row (px).
  final double subHeaderRowHeight;

  /// Horizontal gap between left and right bracket halves (SE only, px).
  final double centerGapWidth;

  /// Height of the Winners/Losers section label bar (px).
  final double sectionLabelHeight;

  // ── Medal table layout tokens ─────────────────────────────────────────────

  /// Total width of the medal table (px).
  final double medalTableWidth;

  /// Height of each medal row (px).
  final double medalRowHeight;

  /// Width of the name column inside the medal table (px).
  final double medalNameColumnWidth;

  /// Width of the label column inside the medal table (px).
  final double medalLabelColumnWidth;

  /// Vertical gap between medal rows (px).
  final double medalRowGap;

  // ── Banner & logo layout tokens ───────────────────────────────────────────

  /// Base height of the dark header banner (before fontSizeDelta scaling, px).
  final double headerBannerHeight;

  /// Maximum display height for logo images (px).
  final double logoMaxHeight;

  /// Padding below the logo row before the header banner starts (px).
  final double logoPadding;

  // ── Color tokens (additional) ─────────────────────────────────────────────

  /// Fill colour for match number pills.
  final Color matchPillFillColor;

  /// Text colour inside corner badges (B / R).
  final Color badgeTextColor;

  // ── Opacity tokens ────────────────────────────────────────────────────────

  /// Background opacity for section label fill (0.0–1.0).
  final double sectionLabelBackgroundOpacity;

  /// Text opacity for subtitle line in the header banner (0.0–1.0).
  final double headerSubtitleOpacity;

  /// Text opacity for organizer line in the header banner (0.0–1.0).
  final double headerOrganizerOpacity;

  // ── Canvas constraint tokens ──────────────────────────────────────────────

  /// Minimum canvas width in logical pixels.
  final double canvasMinimumWidth;

  /// Minimum canvas height in logical pixels.
  final double canvasMinimumHeight;

  const TieSheetThemeConfig({
    required this.connectorColor,
    required this.connectorWonColor,
    required this.pendingColor,
    required this.mutedColor,
    required this.canvasBackgroundColor,
    required this.cardBorderColor,
    required this.shadowOpacityMultiplier,
    required this.connectorStrokeWidth,
    required this.isInteractivityDisabled,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.isTextForceBold,
    required this.fontSizeDelta,
    required this.rowFillColor,
    required this.headerFillColor,
    required this.tbdFillColor,
    required this.headerBannerBackgroundColor,
    required this.headerBannerTextColor,
    required this.participantAccentStripColor,
    required this.blueCornerColor,
    required this.redCornerColor,
    required this.winnersLabelColor,
    required this.losersLabelColor,
    required this.medalGoldFillColor,
    required this.medalSilverFillColor,
    required this.medalBronzeFillColor,
    required this.medalGoldTextColor,
    required this.medalSilverTextColor,
    required this.medalBronzeTextColor,
    required this.medalGoldAccentColor,
    required this.medalSilverAccentColor,
    required this.medalBronzeAccentColor,
    required this.cardBorderRadius,
    required this.sectionLabelBorderRadius,
    required this.headerBannerBorderRadius,
    required this.junctionCornerRadius,
    required this.thickStrokeWidth,
    required this.thinStrokeWidth,
    required this.wonConnectorStrokeWidth,
    required this.byeConnectorStrokeWidth,
    required this.canvasMargin,
    required this.sectionGapHeight,
    required this.accentStripWidth,
    required this.logoRowHeight,
    required this.badgeMinRadius,
    required this.badgePadding,
    required this.matchPillMinHalfWidth,
    required this.matchPillHorizontalPadding,
    required this.matchPillMinHalfHeight,
    required this.matchPillVerticalPadding,
    required this.dashedLineDashWidth,
    required this.dashedLineGapWidth,
    required this.shadowBlurRadius,
    required this.shadowColor,
    required this.fontFamily,
    required this.headerLetterSpacing,
    required this.subHeaderLetterSpacing,
    // New tokens
    required this.rowHeight,
    required this.intraMatchGapHeight,
    required this.interMatchGapHeight,
    required this.numberColumnWidth,
    required this.nameColumnWidth,
    required this.registrationIdColumnWidth,
    required this.roundColumnWidth,
    required this.headerTotalHeight,
    required this.subHeaderRowHeight,
    required this.centerGapWidth,
    required this.sectionLabelHeight,
    required this.medalTableWidth,
    required this.medalRowHeight,
    required this.medalNameColumnWidth,
    required this.medalLabelColumnWidth,
    required this.medalRowGap,
    required this.headerBannerHeight,
    required this.logoMaxHeight,
    required this.logoPadding,
    required this.matchPillFillColor,
    required this.badgeTextColor,
    required this.sectionLabelBackgroundOpacity,
    required this.headerSubtitleOpacity,
    required this.headerOrganizerOpacity,
    required this.canvasMinimumWidth,
    required this.canvasMinimumHeight,
  });

  // ── Named Presets ─────────────────────────────────────────────────────────

  /// Standard on-screen palette — matches the original hardcoded values.
  const TieSheetThemeConfig.defaultMode()
    : connectorColor = const Color(0xFF64748B),
      connectorWonColor = const Color(0xFF334155),
      pendingColor = const Color(0xFF94A3B8),
      mutedColor = const Color(0xFF64748B),
      canvasBackgroundColor = const Color(0xFFFFFEFC),
      cardBorderColor = const Color(0xFF94A3B8),
      shadowOpacityMultiplier = 1.0,
      connectorStrokeWidth = 0.0,
      isInteractivityDisabled = false,
      primaryTextColor = const Color(0xFF1E293B),
      secondaryTextColor = const Color(0xFF64748B),
      isTextForceBold = false,
      fontSizeDelta = 4.0,
      rowFillColor = const Color(0xFFF8FAFC),
      headerFillColor = const Color(0xFFE2E8F0),
      tbdFillColor = const Color(0xFFF1F5F9),
      headerBannerBackgroundColor = const Color(0xFF1E293B),
      headerBannerTextColor = const Color(0xFFFFFFFF),
      participantAccentStripColor = const Color(0xFF2563EB),
      blueCornerColor = const Color(0xFF2563EB),
      redCornerColor = const Color(0xFFDC2626),
      winnersLabelColor = const Color(0xFF2563EB),
      losersLabelColor = const Color(0xFFDC2626),
      medalGoldFillColor = const Color(0xFFFEF9C3),
      medalSilverFillColor = const Color(0xFFF1F5F9),
      medalBronzeFillColor = const Color(0xFFFED7AA),
      medalGoldTextColor = const Color(0xFF92400E),
      medalSilverTextColor = const Color(0xFF475569),
      medalBronzeTextColor = const Color(0xFF9A3412),
      medalGoldAccentColor = const Color(0xFFF59E0B),
      medalSilverAccentColor = const Color(0xFF94A3B8),
      medalBronzeAccentColor = const Color(0xFFF97316),
      // Shape / radius
      cardBorderRadius = 6.0,
      sectionLabelBorderRadius = 6.0,
      headerBannerBorderRadius = 8.0,
      junctionCornerRadius = 10.0,
      // Stroke widths
      thickStrokeWidth = 3.5,
      thinStrokeWidth = 3.0,
      wonConnectorStrokeWidth = 4.0,
      byeConnectorStrokeWidth = 1.5,
      // Spacing
      canvasMargin = 36.0,
      sectionGapHeight = 50.0,
      accentStripWidth = 4.0,
      logoRowHeight = 72.0,
      // Badge & pill sizing
      badgeMinRadius = 10.0,
      badgePadding = 4.0,
      matchPillMinHalfWidth = 16.0,
      matchPillHorizontalPadding = 8.0,
      matchPillMinHalfHeight = 11.0,
      matchPillVerticalPadding = 4.0,
      // Dashed line
      dashedLineDashWidth = 6.0,
      dashedLineGapWidth = 4.0,
      // Shadow
      shadowBlurRadius = 6.0,
      shadowColor = const Color(0x1A000000),
      // Typography
      fontFamily = 'Roboto',
      headerLetterSpacing = 1.2,
      subHeaderLetterSpacing = 0.5,
      // Layout dimensions
      rowHeight = 42.0,
      intraMatchGapHeight = 35.0,
      interMatchGapHeight = 100.0,
      numberColumnWidth = 32.0,
      nameColumnWidth = 200.0,
      registrationIdColumnWidth = 120.0,
      roundColumnWidth = 170.0,
      headerTotalHeight = 100.0,
      subHeaderRowHeight = 28.0,
      centerGapWidth = 340.0,
      sectionLabelHeight = 32.0,
      // Medal table layout
      medalTableWidth = 440.0,
      medalRowHeight = 36.0,
      medalNameColumnWidth = 250.0,
      medalLabelColumnWidth = 100.0,
      medalRowGap = 4.0,
      // Banner & logo
      headerBannerHeight = 64.0,
      logoMaxHeight = 60.0,
      logoPadding = 12.0,
      // Additional colours
      matchPillFillColor = const Color(0xFFFFFFFF),
      badgeTextColor = const Color(0xFFFFFFFF),
      // Opacity
      sectionLabelBackgroundOpacity = 0.1,
      headerSubtitleOpacity = 0.7,
      headerOrganizerOpacity = 0.55,
      // Canvas constraints
      canvasMinimumWidth = 700.0,
      canvasMinimumHeight = 500.0;

  /// High-contrast print palette — pure black text, no background fills,
  /// borders-only elements, zero shadows. Optimised for monochrome printing.
  const TieSheetThemeConfig.printMode()
    : connectorColor = const Color(0xFF000000),
      connectorWonColor = const Color(0xFF000000),
      pendingColor = const Color(0xFF000000),
      mutedColor = const Color(0xFF000000),
      canvasBackgroundColor = const Color(0xFFFFFFFF),
      cardBorderColor = const Color(0xFF000000),
      shadowOpacityMultiplier = 0.0,
      connectorStrokeWidth = 3.0,
      isInteractivityDisabled = true,
      primaryTextColor = const Color(0xFF000000),
      secondaryTextColor = const Color(0xFF000000),
      isTextForceBold = true,
      fontSizeDelta = 8.0,
      rowFillColor = const Color(0xFFFFFFFF),
      headerFillColor = const Color(0xFFFFFFFF),
      tbdFillColor = const Color(0xFFFFFFFF),
      headerBannerBackgroundColor = const Color(0xFFFFFFFF),
      headerBannerTextColor = const Color(0xFF000000),
      participantAccentStripColor = const Color(0xFF000000),
      blueCornerColor = const Color(0xFF000000),
      redCornerColor = const Color(0xFF000000),
      winnersLabelColor = const Color(0xFF000000),
      losersLabelColor = const Color(0xFF000000),
      medalGoldFillColor = const Color(0xFFFFFFFF),
      medalSilverFillColor = const Color(0xFFFFFFFF),
      medalBronzeFillColor = const Color(0xFFFFFFFF),
      medalGoldTextColor = const Color(0xFF000000),
      medalSilverTextColor = const Color(0xFF000000),
      medalBronzeTextColor = const Color(0xFF000000),
      medalGoldAccentColor = const Color(0xFF000000),
      medalSilverAccentColor = const Color(0xFF000000),
      medalBronzeAccentColor = const Color(0xFF000000),
      // Shape / radius (same as default — geometry stays consistent)
      cardBorderRadius = 6.0,
      sectionLabelBorderRadius = 6.0,
      headerBannerBorderRadius = 8.0,
      junctionCornerRadius = 10.0,
      // Stroke widths (same as default — uniform override via connectorStrokeWidth)
      thickStrokeWidth = 3.5,
      thinStrokeWidth = 3.0,
      wonConnectorStrokeWidth = 4.0,
      byeConnectorStrokeWidth = 1.5,
      // Spacing
      canvasMargin = 36.0,
      sectionGapHeight = 50.0,
      accentStripWidth = 4.0,
      logoRowHeight = 72.0,
      // Badge & pill sizing
      badgeMinRadius = 10.0,
      badgePadding = 4.0,
      matchPillMinHalfWidth = 16.0,
      matchPillHorizontalPadding = 8.0,
      matchPillMinHalfHeight = 11.0,
      matchPillVerticalPadding = 4.0,
      // Dashed line
      dashedLineDashWidth = 6.0,
      dashedLineGapWidth = 4.0,
      // Shadow
      shadowBlurRadius = 6.0,
      shadowColor = const Color(0x1A000000),
      // Typography
      fontFamily = 'Roboto',
      headerLetterSpacing = 1.2,
      subHeaderLetterSpacing = 0.5,
      // Layout dimensions
      rowHeight = 42.0,
      intraMatchGapHeight = 35.0,
      interMatchGapHeight = 100.0,
      numberColumnWidth = 32.0,
      nameColumnWidth = 200.0,
      registrationIdColumnWidth = 120.0,
      roundColumnWidth = 170.0,
      headerTotalHeight = 100.0,
      subHeaderRowHeight = 28.0,
      centerGapWidth = 340.0,
      sectionLabelHeight = 32.0,
      // Medal table layout
      medalTableWidth = 440.0,
      medalRowHeight = 36.0,
      medalNameColumnWidth = 250.0,
      medalLabelColumnWidth = 100.0,
      medalRowGap = 4.0,
      // Banner & logo
      headerBannerHeight = 64.0,
      logoMaxHeight = 60.0,
      logoPadding = 12.0,
      // Additional colours
      matchPillFillColor = const Color(0xFFFFFFFF),
      badgeTextColor = const Color(0xFFFFFFFF),
      // Opacity
      sectionLabelBackgroundOpacity = 0.1,
      headerSubtitleOpacity = 0.7,
      headerOrganizerOpacity = 0.55,
      // Canvas constraints
      canvasMinimumWidth = 700.0,
      canvasMinimumHeight = 500.0;

  // ── Factory helper ────────────────────────────────────────────────────────

  /// Returns the preset config for the given [mode].
  factory TieSheetThemeConfig.fromMode(TieSheetThemeMode mode) {
    return switch (mode) {
      TieSheetThemeMode.defaultMode => const TieSheetThemeConfig.defaultMode(),
      TieSheetThemeMode.printMode => const TieSheetThemeConfig.printMode(),
      // Custom mode starts from the default preset; the caller overrides
      // individual tokens via [copyWith].
      TieSheetThemeMode.customMode => const TieSheetThemeConfig.defaultMode(),
    };
  }

  // ── Copy-with helper ───────────────────────────────────────────────────────

  /// Returns a new [TieSheetThemeConfig] with only the specified fields
  /// overridden. Unspecified fields retain their current values.
  TieSheetThemeConfig copyWith({
    Color? connectorColor,
    Color? connectorWonColor,
    Color? pendingColor,
    Color? mutedColor,
    Color? canvasBackgroundColor,
    Color? cardBorderColor,
    double? shadowOpacityMultiplier,
    double? connectorStrokeWidth,
    bool? isInteractivityDisabled,
    Color? primaryTextColor,
    Color? secondaryTextColor,
    bool? isTextForceBold,
    double? fontSizeDelta,
    Color? rowFillColor,
    Color? headerFillColor,
    Color? tbdFillColor,
    Color? headerBannerBackgroundColor,
    Color? headerBannerTextColor,
    Color? participantAccentStripColor,
    Color? blueCornerColor,
    Color? redCornerColor,
    Color? winnersLabelColor,
    Color? losersLabelColor,
    Color? medalGoldFillColor,
    Color? medalSilverFillColor,
    Color? medalBronzeFillColor,
    Color? medalGoldTextColor,
    Color? medalSilverTextColor,
    Color? medalBronzeTextColor,
    Color? medalGoldAccentColor,
    Color? medalSilverAccentColor,
    Color? medalBronzeAccentColor,
    double? cardBorderRadius,
    double? sectionLabelBorderRadius,
    double? headerBannerBorderRadius,
    double? junctionCornerRadius,
    double? thickStrokeWidth,
    double? thinStrokeWidth,
    double? wonConnectorStrokeWidth,
    double? byeConnectorStrokeWidth,
    double? canvasMargin,
    double? sectionGapHeight,
    double? accentStripWidth,
    double? logoRowHeight,
    double? badgeMinRadius,
    double? badgePadding,
    double? matchPillMinHalfWidth,
    double? matchPillHorizontalPadding,
    double? matchPillMinHalfHeight,
    double? matchPillVerticalPadding,
    double? dashedLineDashWidth,
    double? dashedLineGapWidth,
    double? shadowBlurRadius,
    Color? shadowColor,
    String? fontFamily,
    double? headerLetterSpacing,
    double? subHeaderLetterSpacing,
    // New tokens
    double? rowHeight,
    double? intraMatchGapHeight,
    double? interMatchGapHeight,
    double? numberColumnWidth,
    double? nameColumnWidth,
    double? registrationIdColumnWidth,
    double? roundColumnWidth,
    double? headerTotalHeight,
    double? subHeaderRowHeight,
    double? centerGapWidth,
    double? sectionLabelHeight,
    double? medalTableWidth,
    double? medalRowHeight,
    double? medalNameColumnWidth,
    double? medalLabelColumnWidth,
    double? medalRowGap,
    double? headerBannerHeight,
    double? logoMaxHeight,
    double? logoPadding,
    Color? matchPillFillColor,
    Color? badgeTextColor,
    double? sectionLabelBackgroundOpacity,
    double? headerSubtitleOpacity,
    double? headerOrganizerOpacity,
    double? canvasMinimumWidth,
    double? canvasMinimumHeight,
  }) {
    return TieSheetThemeConfig(
      connectorColor: connectorColor ?? this.connectorColor,
      connectorWonColor: connectorWonColor ?? this.connectorWonColor,
      pendingColor: pendingColor ?? this.pendingColor,
      mutedColor: mutedColor ?? this.mutedColor,
      canvasBackgroundColor:
          canvasBackgroundColor ?? this.canvasBackgroundColor,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      shadowOpacityMultiplier:
          shadowOpacityMultiplier ?? this.shadowOpacityMultiplier,
      connectorStrokeWidth: connectorStrokeWidth ?? this.connectorStrokeWidth,
      isInteractivityDisabled:
          isInteractivityDisabled ?? this.isInteractivityDisabled,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      isTextForceBold: isTextForceBold ?? this.isTextForceBold,
      fontSizeDelta: fontSizeDelta ?? this.fontSizeDelta,
      rowFillColor: rowFillColor ?? this.rowFillColor,
      headerFillColor: headerFillColor ?? this.headerFillColor,
      tbdFillColor: tbdFillColor ?? this.tbdFillColor,
      headerBannerBackgroundColor:
          headerBannerBackgroundColor ?? this.headerBannerBackgroundColor,
      headerBannerTextColor:
          headerBannerTextColor ?? this.headerBannerTextColor,
      participantAccentStripColor:
          participantAccentStripColor ?? this.participantAccentStripColor,
      blueCornerColor: blueCornerColor ?? this.blueCornerColor,
      redCornerColor: redCornerColor ?? this.redCornerColor,
      winnersLabelColor: winnersLabelColor ?? this.winnersLabelColor,
      losersLabelColor: losersLabelColor ?? this.losersLabelColor,
      medalGoldFillColor: medalGoldFillColor ?? this.medalGoldFillColor,
      medalSilverFillColor: medalSilverFillColor ?? this.medalSilverFillColor,
      medalBronzeFillColor: medalBronzeFillColor ?? this.medalBronzeFillColor,
      medalGoldTextColor: medalGoldTextColor ?? this.medalGoldTextColor,
      medalSilverTextColor: medalSilverTextColor ?? this.medalSilverTextColor,
      medalBronzeTextColor: medalBronzeTextColor ?? this.medalBronzeTextColor,
      medalGoldAccentColor: medalGoldAccentColor ?? this.medalGoldAccentColor,
      medalSilverAccentColor:
          medalSilverAccentColor ?? this.medalSilverAccentColor,
      medalBronzeAccentColor:
          medalBronzeAccentColor ?? this.medalBronzeAccentColor,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      sectionLabelBorderRadius:
          sectionLabelBorderRadius ?? this.sectionLabelBorderRadius,
      headerBannerBorderRadius:
          headerBannerBorderRadius ?? this.headerBannerBorderRadius,
      junctionCornerRadius: junctionCornerRadius ?? this.junctionCornerRadius,
      thickStrokeWidth: thickStrokeWidth ?? this.thickStrokeWidth,
      thinStrokeWidth: thinStrokeWidth ?? this.thinStrokeWidth,
      wonConnectorStrokeWidth:
          wonConnectorStrokeWidth ?? this.wonConnectorStrokeWidth,
      byeConnectorStrokeWidth:
          byeConnectorStrokeWidth ?? this.byeConnectorStrokeWidth,
      canvasMargin: canvasMargin ?? this.canvasMargin,
      sectionGapHeight: sectionGapHeight ?? this.sectionGapHeight,
      accentStripWidth: accentStripWidth ?? this.accentStripWidth,
      logoRowHeight: logoRowHeight ?? this.logoRowHeight,
      badgeMinRadius: badgeMinRadius ?? this.badgeMinRadius,
      badgePadding: badgePadding ?? this.badgePadding,
      matchPillMinHalfWidth:
          matchPillMinHalfWidth ?? this.matchPillMinHalfWidth,
      matchPillHorizontalPadding:
          matchPillHorizontalPadding ?? this.matchPillHorizontalPadding,
      matchPillMinHalfHeight:
          matchPillMinHalfHeight ?? this.matchPillMinHalfHeight,
      matchPillVerticalPadding:
          matchPillVerticalPadding ?? this.matchPillVerticalPadding,
      dashedLineDashWidth: dashedLineDashWidth ?? this.dashedLineDashWidth,
      dashedLineGapWidth: dashedLineGapWidth ?? this.dashedLineGapWidth,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowColor: shadowColor ?? this.shadowColor,
      fontFamily: fontFamily ?? this.fontFamily,
      headerLetterSpacing: headerLetterSpacing ?? this.headerLetterSpacing,
      subHeaderLetterSpacing:
          subHeaderLetterSpacing ?? this.subHeaderLetterSpacing,
      // New tokens
      rowHeight: rowHeight ?? this.rowHeight,
      intraMatchGapHeight: intraMatchGapHeight ?? this.intraMatchGapHeight,
      interMatchGapHeight: interMatchGapHeight ?? this.interMatchGapHeight,
      numberColumnWidth: numberColumnWidth ?? this.numberColumnWidth,
      nameColumnWidth: nameColumnWidth ?? this.nameColumnWidth,
      registrationIdColumnWidth:
          registrationIdColumnWidth ?? this.registrationIdColumnWidth,
      roundColumnWidth: roundColumnWidth ?? this.roundColumnWidth,
      headerTotalHeight: headerTotalHeight ?? this.headerTotalHeight,
      subHeaderRowHeight: subHeaderRowHeight ?? this.subHeaderRowHeight,
      centerGapWidth: centerGapWidth ?? this.centerGapWidth,
      sectionLabelHeight: sectionLabelHeight ?? this.sectionLabelHeight,
      medalTableWidth: medalTableWidth ?? this.medalTableWidth,
      medalRowHeight: medalRowHeight ?? this.medalRowHeight,
      medalNameColumnWidth: medalNameColumnWidth ?? this.medalNameColumnWidth,
      medalLabelColumnWidth:
          medalLabelColumnWidth ?? this.medalLabelColumnWidth,
      medalRowGap: medalRowGap ?? this.medalRowGap,
      headerBannerHeight: headerBannerHeight ?? this.headerBannerHeight,
      logoMaxHeight: logoMaxHeight ?? this.logoMaxHeight,
      logoPadding: logoPadding ?? this.logoPadding,
      matchPillFillColor: matchPillFillColor ?? this.matchPillFillColor,
      badgeTextColor: badgeTextColor ?? this.badgeTextColor,
      sectionLabelBackgroundOpacity:
          sectionLabelBackgroundOpacity ?? this.sectionLabelBackgroundOpacity,
      headerSubtitleOpacity:
          headerSubtitleOpacity ?? this.headerSubtitleOpacity,
      headerOrganizerOpacity:
          headerOrganizerOpacity ?? this.headerOrganizerOpacity,
      canvasMinimumWidth: canvasMinimumWidth ?? this.canvasMinimumWidth,
      canvasMinimumHeight: canvasMinimumHeight ?? this.canvasMinimumHeight,
    );
  }

  // ── Equality ──────────────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TieSheetThemeConfig &&
          runtimeType == other.runtimeType &&
          connectorColor == other.connectorColor &&
          connectorWonColor == other.connectorWonColor &&
          pendingColor == other.pendingColor &&
          mutedColor == other.mutedColor &&
          canvasBackgroundColor == other.canvasBackgroundColor &&
          cardBorderColor == other.cardBorderColor &&
          shadowOpacityMultiplier == other.shadowOpacityMultiplier &&
          connectorStrokeWidth == other.connectorStrokeWidth &&
          isInteractivityDisabled == other.isInteractivityDisabled &&
          primaryTextColor == other.primaryTextColor &&
          secondaryTextColor == other.secondaryTextColor &&
          isTextForceBold == other.isTextForceBold &&
          fontSizeDelta == other.fontSizeDelta &&
          rowFillColor == other.rowFillColor &&
          headerFillColor == other.headerFillColor &&
          tbdFillColor == other.tbdFillColor &&
          headerBannerBackgroundColor == other.headerBannerBackgroundColor &&
          headerBannerTextColor == other.headerBannerTextColor &&
          participantAccentStripColor == other.participantAccentStripColor &&
          blueCornerColor == other.blueCornerColor &&
          redCornerColor == other.redCornerColor &&
          winnersLabelColor == other.winnersLabelColor &&
          losersLabelColor == other.losersLabelColor &&
          medalGoldFillColor == other.medalGoldFillColor &&
          medalSilverFillColor == other.medalSilverFillColor &&
          medalBronzeFillColor == other.medalBronzeFillColor &&
          medalGoldTextColor == other.medalGoldTextColor &&
          medalSilverTextColor == other.medalSilverTextColor &&
          medalBronzeTextColor == other.medalBronzeTextColor &&
          medalGoldAccentColor == other.medalGoldAccentColor &&
          medalSilverAccentColor == other.medalSilverAccentColor &&
          medalBronzeAccentColor == other.medalBronzeAccentColor &&
          cardBorderRadius == other.cardBorderRadius &&
          sectionLabelBorderRadius == other.sectionLabelBorderRadius &&
          headerBannerBorderRadius == other.headerBannerBorderRadius &&
          junctionCornerRadius == other.junctionCornerRadius &&
          thickStrokeWidth == other.thickStrokeWidth &&
          thinStrokeWidth == other.thinStrokeWidth &&
          wonConnectorStrokeWidth == other.wonConnectorStrokeWidth &&
          byeConnectorStrokeWidth == other.byeConnectorStrokeWidth &&
          canvasMargin == other.canvasMargin &&
          sectionGapHeight == other.sectionGapHeight &&
          accentStripWidth == other.accentStripWidth &&
          logoRowHeight == other.logoRowHeight &&
          badgeMinRadius == other.badgeMinRadius &&
          badgePadding == other.badgePadding &&
          matchPillMinHalfWidth == other.matchPillMinHalfWidth &&
          matchPillHorizontalPadding == other.matchPillHorizontalPadding &&
          matchPillMinHalfHeight == other.matchPillMinHalfHeight &&
          matchPillVerticalPadding == other.matchPillVerticalPadding &&
          dashedLineDashWidth == other.dashedLineDashWidth &&
          dashedLineGapWidth == other.dashedLineGapWidth &&
          shadowBlurRadius == other.shadowBlurRadius &&
          shadowColor == other.shadowColor &&
          fontFamily == other.fontFamily &&
          headerLetterSpacing == other.headerLetterSpacing &&
          subHeaderLetterSpacing == other.subHeaderLetterSpacing &&
          // New tokens
          rowHeight == other.rowHeight &&
          intraMatchGapHeight == other.intraMatchGapHeight &&
          interMatchGapHeight == other.interMatchGapHeight &&
          numberColumnWidth == other.numberColumnWidth &&
          nameColumnWidth == other.nameColumnWidth &&
          registrationIdColumnWidth == other.registrationIdColumnWidth &&
          roundColumnWidth == other.roundColumnWidth &&
          headerTotalHeight == other.headerTotalHeight &&
          subHeaderRowHeight == other.subHeaderRowHeight &&
          centerGapWidth == other.centerGapWidth &&
          sectionLabelHeight == other.sectionLabelHeight &&
          medalTableWidth == other.medalTableWidth &&
          medalRowHeight == other.medalRowHeight &&
          medalNameColumnWidth == other.medalNameColumnWidth &&
          medalLabelColumnWidth == other.medalLabelColumnWidth &&
          medalRowGap == other.medalRowGap &&
          headerBannerHeight == other.headerBannerHeight &&
          logoMaxHeight == other.logoMaxHeight &&
          logoPadding == other.logoPadding &&
          matchPillFillColor == other.matchPillFillColor &&
          badgeTextColor == other.badgeTextColor &&
          sectionLabelBackgroundOpacity ==
              other.sectionLabelBackgroundOpacity &&
          headerSubtitleOpacity == other.headerSubtitleOpacity &&
          headerOrganizerOpacity == other.headerOrganizerOpacity &&
          canvasMinimumWidth == other.canvasMinimumWidth &&
          canvasMinimumHeight == other.canvasMinimumHeight;

  @override
  int get hashCode => Object.hashAll([
    connectorColor,
    connectorWonColor,
    pendingColor,
    mutedColor,
    canvasBackgroundColor,
    cardBorderColor,
    shadowOpacityMultiplier,
    connectorStrokeWidth,
    isInteractivityDisabled,
    primaryTextColor,
    secondaryTextColor,
    isTextForceBold,
    fontSizeDelta,
    rowFillColor,
    headerFillColor,
    tbdFillColor,
    headerBannerBackgroundColor,
    headerBannerTextColor,
    participantAccentStripColor,
    blueCornerColor,
    redCornerColor,
    winnersLabelColor,
    losersLabelColor,
    medalGoldFillColor,
    medalSilverFillColor,
    medalBronzeFillColor,
    medalGoldTextColor,
    medalSilverTextColor,
    medalBronzeTextColor,
    medalGoldAccentColor,
    medalSilverAccentColor,
    medalBronzeAccentColor,
    cardBorderRadius,
    sectionLabelBorderRadius,
    headerBannerBorderRadius,
    junctionCornerRadius,
    thickStrokeWidth,
    thinStrokeWidth,
    wonConnectorStrokeWidth,
    byeConnectorStrokeWidth,
    canvasMargin,
    sectionGapHeight,
    accentStripWidth,
    logoRowHeight,
    badgeMinRadius,
    badgePadding,
    matchPillMinHalfWidth,
    matchPillHorizontalPadding,
    matchPillMinHalfHeight,
    matchPillVerticalPadding,
    dashedLineDashWidth,
    dashedLineGapWidth,
    shadowBlurRadius,
    shadowColor,
    fontFamily,
    headerLetterSpacing,
    subHeaderLetterSpacing,
    // New tokens
    rowHeight,
    intraMatchGapHeight,
    interMatchGapHeight,
    numberColumnWidth,
    nameColumnWidth,
    registrationIdColumnWidth,
    roundColumnWidth,
    headerTotalHeight,
    subHeaderRowHeight,
    centerGapWidth,
    sectionLabelHeight,
    medalTableWidth,
    medalRowHeight,
    medalNameColumnWidth,
    medalLabelColumnWidth,
    medalRowGap,
    headerBannerHeight,
    logoMaxHeight,
    logoPadding,
    matchPillFillColor,
    badgeTextColor,
    sectionLabelBackgroundOpacity,
    headerSubtitleOpacity,
    headerOrganizerOpacity,
    canvasMinimumWidth,
    canvasMinimumHeight,
  ]);
}

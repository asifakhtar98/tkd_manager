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
  printMode('Print');

  const TieSheetThemeMode(this.label);

  /// Human-readable label shown in the app bar toggle.
  final String label;
}

// ══════════════════════════════════════════════════════════════════════════════
// TIE SHEET THEME CONFIG
// ══════════════════════════════════════════════════════════════════════════════

/// Immutable set of **all** colour / style tokens consumed by
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

  /// When greater than `0`, **every** text span is rendered at this
  /// fixed font size instead of the painter-specified size.
  final double uniformFontSize;

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
    required this.uniformFontSize,
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
  });

  // ── Named Presets ─────────────────────────────────────────────────────────

  /// Standard on-screen palette — matches the original hardcoded values.
  const TieSheetThemeConfig.defaultMode()
      : connectorColor = const Color(0xFF94A3B8),
        connectorWonColor = const Color(0xFF475569),
        pendingColor = const Color(0xFFCBD5E1),
        mutedColor = const Color(0xFF94A3B8),
        canvasBackgroundColor = const Color(0xFFFFFEFC),
        cardBorderColor = const Color(0xFFCBD5E1),
        shadowOpacityMultiplier = 1.0,
        connectorStrokeWidth = 0.0,
        isInteractivityDisabled = false,
        primaryTextColor = const Color(0xFF1E293B),
        secondaryTextColor = const Color(0xFF64748B),
        isTextForceBold = false,
        uniformFontSize = 0.0,
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
        medalBronzeAccentColor = const Color(0xFFF97316);

  /// High-contrast print palette — pure black text, no background fills,
  /// borders-only elements, zero shadows. Optimised for monochrome printing.
  const TieSheetThemeConfig.printMode()
      : connectorColor = const Color(0xFF000000),
        connectorWonColor = const Color(0xFF000000),
        pendingColor = const Color(0xFF4B5563),
        mutedColor = const Color(0xFF374151),
        canvasBackgroundColor = const Color(0xFFFFFFFF),
        cardBorderColor = const Color(0xFF000000),
        shadowOpacityMultiplier = 0.0,
        connectorStrokeWidth = 1.5,
        isInteractivityDisabled = true,
        primaryTextColor = const Color(0xFF000000),
        secondaryTextColor = const Color(0xFF000000),
        isTextForceBold = true,
        uniformFontSize = 10.0,
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
        medalBronzeAccentColor = const Color(0xFF000000);

  // ── Factory helper ────────────────────────────────────────────────────────

  /// Returns the preset config for the given [mode].
  factory TieSheetThemeConfig.fromMode(TieSheetThemeMode mode) {
    return switch (mode) {
      TieSheetThemeMode.defaultMode => const TieSheetThemeConfig.defaultMode(),
      TieSheetThemeMode.printMode => const TieSheetThemeConfig.printMode(),
    };
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
          uniformFontSize == other.uniformFontSize &&
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
          medalBronzeAccentColor == other.medalBronzeAccentColor;

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
        uniformFontSize,
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
      ]);
}

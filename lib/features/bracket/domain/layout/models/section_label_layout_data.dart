import 'dart:ui' show Rect;

import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';

// ══════════════════════════════════════════════════════════════════════════════
// SECTION LABEL LAYOUT DATA
// ══════════════════════════════════════════════════════════════════════════════

/// Precomputed layout data for a double-elimination section label.
///
/// Section labels are the horizontal banner bars separating the Winners
/// and Losers brackets in a DE tournament display. They render as a
/// semi-transparent filled rounded rectangle with centered uppercase text.
class SectionLabelLayoutData {
  /// Creates layout data for a DE section label.
  const SectionLabelLayoutData({
    required this.boundingRect,
    required this.labelTextLayout,
    required this.sectionLabelType,
  });

  /// Bounding rectangle for the label background fill.
  ///
  /// The renderer draws a rounded rectangle with a type-specific color
  /// at [TieSheetThemeConfig.sectionLabelBackgroundOpacity] opacity,
  /// and a thin border stroke in the same color.
  final Rect boundingRect;

  /// Centered label text (e.g., "WINNERS BRACKET", "LOSERS BRACKET").
  final PositionedTextLayoutData labelTextLayout;

  /// Type of section label — determines the color used from the theme.
  final SectionLabelType sectionLabelType;
}

// ══════════════════════════════════════════════════════════════════════════════
// SECTION LABEL TYPE
// ══════════════════════════════════════════════════════════════════════════════

/// Identifies the DE bracket section for theme color resolution.
enum SectionLabelType {
  /// Winners bracket — uses [TieSheetThemeConfig.winnersLabelColor].
  winnersBracket,

  /// Losers bracket — uses [TieSheetThemeConfig.losersLabelColor].
  losersBracket,
}

import 'dart:ui' show Rect;

import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';

// ══════════════════════════════════════════════════════════════════════════════
// MEDAL TABLE LAYOUT DATA
// ══════════════════════════════════════════════════════════════════════════════

/// Precomputed layout data for the 4-row medal placement table.
///
/// The medal table always has exactly four rows:
/// - Row 0: Gold
/// - Row 1: Silver
/// - Row 2: 1st Bronze
/// - Row 3: 2nd Bronze
///
/// Each row is a horizontally split card with:
/// - A name area on the left showing the winner's name (if resolved)
/// - A colored label area on the right showing the medal rank
/// - An accent strip on the leading edge
class MedalTableLayoutData {
  /// Creates the complete medal table layout data.
  const MedalTableLayoutData({
    required this.medalRowLayoutDataList,
  });

  /// Layout data for each medal row (always 4 entries, index 0–3).
  final List<MedalRowLayoutData> medalRowLayoutDataList;
}

// ══════════════════════════════════════════════════════════════════════════════
// MEDAL ROW LAYOUT DATA
// ══════════════════════════════════════════════════════════════════════════════

/// Precomputed layout data for a single medal table row.
class MedalRowLayoutData {
  /// Creates layout data for a medal row.
  const MedalRowLayoutData({
    required this.medalRowIndex,
    required this.fullCardBoundingRect,
    required this.nameAreaBoundingRect,
    required this.labelAreaBoundingRect,
    required this.accentStripBoundingRect,
    required this.columnDividerLine,
    required this.medalLabelTextLayout,
    this.winnerNameTextLayout,
    required this.medalType,
  });

  /// Zero-based row index (0=Gold, 1=Silver, 2=1st Bronze, 3=2nd Bronze).
  final int medalRowIndex;

  /// Full bounding rectangle for the entire card (name + label areas).
  final Rect fullCardBoundingRect;

  /// Bounding rectangle for the name area (left portion).
  ///
  /// The renderer should fill this with
  /// [TieSheetThemeConfig.rowFillColor].
  final Rect nameAreaBoundingRect;

  /// Bounding rectangle for the colored label area (right portion).
  ///
  /// The renderer should fill this using the medal-specific fill color
  /// from the theme (gold, silver, or bronze).
  final Rect labelAreaBoundingRect;

  /// Accent strip rectangle on the left edge of the name area.
  ///
  /// The renderer should fill this using the medal-specific accent color
  /// from the theme.
  final Rect accentStripBoundingRect;

  /// Vertical column divider between name and label areas.
  final LineSegmentLayoutData columnDividerLine;

  /// Medal label text (e.g., "Gold", "Silver", "1st Bronze", "2nd Bronze").
  ///
  /// Centered within the label area.
  final PositionedTextLayoutData medalLabelTextLayout;

  /// Winner name text — `null` when no winner has been determined.
  final PositionedTextLayoutData? winnerNameTextLayout;

  /// Semantic medal type for color resolution by the renderer.
  final MedalType medalType;
}

// ══════════════════════════════════════════════════════════════════════════════
// MEDAL TYPE
// ══════════════════════════════════════════════════════════════════════════════

/// Semantic medal type for theme color resolution.
///
/// The renderer uses this to pick the correct fill, accent, and text colors
/// from [TieSheetThemeConfig].
enum MedalType {
  /// Gold medal — row index 0.
  gold,

  /// Silver medal — row index 1.
  silver,

  /// Bronze medal — row indices 2 and 3.
  bronze,
}

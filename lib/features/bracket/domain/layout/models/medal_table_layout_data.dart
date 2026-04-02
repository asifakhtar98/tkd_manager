import 'dart:ui' show Rect;

import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';

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
  const MedalTableLayoutData({required this.medalRowLayoutDataList});

  /// Always 4 entries, index 0–3.
  final List<MedalRowLayoutData> medalRowLayoutDataList;
}

/// Precomputed layout data for a single medal table row.
class MedalRowLayoutData {
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

  final Rect fullCardBoundingRect;

  /// The renderer should fill this with [TieSheetThemeConfig.rowFillColor].
  final Rect nameAreaBoundingRect;

  /// The renderer should fill this using the medal-specific fill color
  /// from the theme (gold, silver, or bronze).
  final Rect labelAreaBoundingRect;

  /// The renderer should fill this using the medal-specific accent color
  /// from the theme.
  final Rect accentStripBoundingRect;

  final LineSegmentLayoutData columnDividerLine;

  /// Centered within the label area.
  final PositionedTextLayoutData medalLabelTextLayout;

  final PositionedTextLayoutData? winnerNameTextLayout;

  final MedalType medalType;
}

/// Semantic medal type for theme color resolution.
///
/// The renderer uses this to pick the correct fill, accent, and text colors
/// from [TieSheetThemeConfig].
enum MedalType {
  /// Row index 0.
  gold,

  /// Row index 1.
  silver,

  /// Row indices 2 and 3.
  bronze,
}

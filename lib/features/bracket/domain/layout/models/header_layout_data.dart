import 'dart:ui' show Rect;

import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';

// ══════════════════════════════════════════════════════════════════════════════
// HEADER LAYOUT DATA
// ══════════════════════════════════════════════════════════════════════════════

/// Precomputed layout coordinates for the tournament header section.
///
/// The header section consists of three visual bands stacked vertically:
///
/// 1. **Logo Row** (optional) — left and right logo images above the banner.
/// 2. **Dark Banner** — tournament name, subtitle (date + venue), organizer.
/// 3. **Classification Info Row** — four-column table showing
///    No., Age Category, Gender, Weight Division.
///
/// All coordinates are absolute canvas positions. The renderer simply
/// draws at the specified locations without any layout computation.
class HeaderLayoutData {
  /// Creates the complete header layout data.
  const HeaderLayoutData({
    required this.headerBannerBoundingRect,
    required this.tournamentTitleTextLayout,
    this.tournamentSubtitleTextLayout,
    this.tournamentOrganizerTextLayout,
    this.leftLogoBoundingRect,
    this.rightLogoBoundingRect,
    required this.classificationInfoRowBoundingRect,
    required this.classificationInfoRowDividerLines,
    required this.classificationCellTextLayoutList,
  });

  /// Bounding rectangle for the dark header banner background fill.
  ///
  /// The renderer should draw a filled rounded rectangle using
  /// [TieSheetThemeConfig.headerBannerBackgroundColor].
  final Rect headerBannerBoundingRect;

  /// Tournament title text (centered within the banner).
  ///
  /// Always present — defaults to "TOURNAMENT NAME" if the tournament
  /// entity has an empty name.
  final PositionedTextLayoutData tournamentTitleTextLayout;

  /// Date + venue subtitle line — `null` when both fields are empty.
  final PositionedTextLayoutData? tournamentSubtitleTextLayout;

  /// "Organised by …" line — `null` when the organizer field is empty.
  final PositionedTextLayoutData? tournamentOrganizerTextLayout;

  /// Bounding rectangle for the left logo image — `null` when no left logo.
  ///
  /// The renderer should draw the logo image (from bytes) fitted within
  /// this rectangle, preserving aspect ratio.
  final Rect? leftLogoBoundingRect;

  /// Bounding rectangle for the right logo image — `null` when no right logo.
  final Rect? rightLogoBoundingRect;

  /// Bounding rectangle for the classification info row background.
  ///
  /// The renderer should draw a filled rounded rectangle using
  /// [TieSheetThemeConfig.headerFillColor].
  final Rect classificationInfoRowBoundingRect;

  /// Vertical column divider lines within the info row.
  ///
  /// Typically three dividers separating the four columns:
  /// `[No. | Age Category | Gender | Weight Division]`.
  final List<LineSegmentLayoutData> classificationInfoRowDividerLines;

  /// Text elements for each classification cell.
  ///
  /// Order: `[No., Age Category, Gender, Weight Division]`.
  /// Each is center-aligned within its column.
  final List<PositionedTextLayoutData> classificationCellTextLayoutList;
}

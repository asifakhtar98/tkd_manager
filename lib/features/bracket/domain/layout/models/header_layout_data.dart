import 'dart:ui' show Rect;

import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';

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

  /// The renderer should draw a filled rounded rectangle using
  /// [TieSheetThemeConfig.headerBannerBackgroundColor].
  final Rect headerBannerBoundingRect;

  /// Always present — defaults to "TOURNAMENT NAME" if the tournament
  /// entity has an empty name.
  final PositionedTextLayoutData tournamentTitleTextLayout;

  final PositionedTextLayoutData? tournamentSubtitleTextLayout;

  final PositionedTextLayoutData? tournamentOrganizerTextLayout;

  /// The renderer should draw the logo image (from bytes) fitted within
  /// this rectangle, preserving aspect ratio.
  final Rect? leftLogoBoundingRect;

  final Rect? rightLogoBoundingRect;

  /// The renderer should draw a filled rounded rectangle using
  /// [TieSheetThemeConfig.headerFillColor].
  final Rect classificationInfoRowBoundingRect;

  /// Typically three dividers separating the four columns:
  /// `[No. | Age Category | Gender | Weight Division]`.
  final List<LineSegmentLayoutData> classificationInfoRowDividerLines;

  /// Order: `[No., Age Category, Gender, Weight Division]`.
  /// Each is center-aligned within its column.
  final List<PositionedTextLayoutData> classificationCellTextLayoutList;
}

import 'dart:ui' show Size;

import 'package:tkd_saas/features/bracket/domain/layout/models/connector_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/header_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/match_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/medal_table_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/participant_row_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/section_label_layout_data.dart';

// ══════════════════════════════════════════════════════════════════════════════
// TIE SHEET LAYOUT RESULT
// ══════════════════════════════════════════════════════════════════════════════

/// Immutable, renderer-agnostic layout result produced by [TieSheetLayoutEngine].
///
/// This is the **single source of truth** for bracket geometry. Both the
/// `SfPdfViewer` on-screen display path and the `Printing.layoutPdf` export
/// path consume the same [TieSheetLayoutResult] — guaranteeing zero visual
/// divergence between screen and paper.
///
/// The result contains:
/// - A computed canvas size that fits the entire bracket
/// - Precomputed dimensional tokens cached from the theme
/// - All visual elements as positioned data objects:
///   header, participant rows, match junctions, connectors, medal table,
///   and DE section labels
///
/// Renderers iterate through these lists and draw each element at its
/// precomputed position without any layout logic.
class TieSheetLayoutResult {
  /// Creates a complete tie-sheet layout result.
  const TieSheetLayoutResult({
    required this.computedCanvasSize,
    required this.computedDimensions,
    required this.headerLayoutData,
    required this.participantRowLayoutDataList,
    required this.matchLayoutDataList,
    required this.connectorLayoutDataList,
    this.medalTableLayoutData,
    required this.sectionLabelLayoutDataList,
  });

  /// The total canvas size required to render the entire bracket.
  ///
  /// Determines the PDF page dimensions for single-page output and the
  /// tile grid dimensions for multi-page tiled output.
  final Size computedCanvasSize;

  /// Precomputed dimensional tokens derived from the theme configuration.
  ///
  /// Cached here so renderers can reference dimensions (e.g., for stroke
  /// widths, corner radii) without recomputing from the raw theme config.
  final TieSheetLayoutDimensions computedDimensions;

  /// Layout data for the header section (banner, logos, classification row).
  final HeaderLayoutData headerLayoutData;

  /// Layout data for every participant row card.
  ///
  /// Includes both real participant rows and TBD placeholder rows.
  /// Ordered by serial number (draw order).
  final List<ParticipantRowLayoutData> participantRowLayoutDataList;

  /// Layout data for every match junction node.
  ///
  /// Includes standard junctions, center final, GF, GF reset, and
  /// third-place match nodes.
  final List<MatchLayoutData> matchLayoutDataList;

  /// Layout data for every connector line and curve.
  ///
  /// Includes junction arms (bezier arcs), feeder lines, vertical trunks,
  /// BYE dashed lines, and GF output arms.
  final List<ConnectorLayoutData> connectorLayoutDataList;

  /// Layout data for the medal table — `null` when no medals are shown.
  ///
  /// Always present for completed or in-progress brackets.
  final MedalTableLayoutData? medalTableLayoutData;

  /// Layout data for DE section labels.
  ///
  /// Empty list for SE brackets; typically 2 entries (Winners, Losers)
  /// for DE brackets.
  final List<SectionLabelLayoutData> sectionLabelLayoutDataList;
}

// ══════════════════════════════════════════════════════════════════════════════
// TIE SHEET LAYOUT DIMENSIONS
// ══════════════════════════════════════════════════════════════════════════════

/// Precomputed and cached dimensional tokens derived from
/// [TieSheetThemeConfig] and its `fontSizeDelta`.
///
/// The layout engine computes these once during `computeLayout()` and
/// stores them here. This eliminates redundant `config.X + delta * N`
/// calculations throughout both the layout and rendering phases.
///
/// All values are in logical pixels (canvas coordinates).
class TieSheetLayoutDimensions {
  /// Creates precomputed layout dimensions.
  const TieSheetLayoutDimensions({
    required this.participantRowHeight,
    required this.intraMatchGapHeight,
    required this.interMatchGapHeight,
    required this.serialNumberColumnWidth,
    required this.participantNameColumnWidth,
    required this.registrationIdColumnWidth,
    required this.roundColumnWidth,
    required this.headerTotalHeight,
    required this.headerBannerHeight,
    required this.subHeaderRowHeight,
    required this.medalTableTotalHeight,
    required this.centerGapWidth,
    required this.sectionLabelHeight,
    required this.participantListTotalWidth,
    required this.canvasMargin,
    required this.sectionGapHeight,
    required this.logoRowHeight,
    required this.medalTableWidth,
    required this.medalRowHeight,
    required this.medalNameColumnWidth,
    required this.medalLabelColumnWidth,
    required this.medalBlankColumnWidth,
    required this.fontSizeDelta,
  });

  /// Height of a single participant row card.
  final double participantRowHeight;

  /// Vertical gap between blue and red rows within the same match.
  final double intraMatchGapHeight;

  /// Vertical gap between consecutive match pairs.
  final double interMatchGapHeight;

  /// Width of the serial number column.
  final double serialNumberColumnWidth;

  /// Width of the participant name column.
  final double participantNameColumnWidth;

  /// Width of the registration ID column.
  final double registrationIdColumnWidth;

  /// Width of each bracket round column (horizontal spacing between junctions).
  final double roundColumnWidth;

  /// Total height consumed by the header section (logo row + banner + info row).
  final double headerTotalHeight;

  /// Height of the dark tournament banner within the header.
  final double headerBannerHeight;

  /// Height of the classification info sub-header row.
  final double subHeaderRowHeight;

  /// Total height of the medal table (4 rows + gaps + padding).
  final double medalTableTotalHeight;

  /// Horizontal gap between left and right bracket halves (SE only).
  final double centerGapWidth;

  /// Height of a DE section label bar.
  final double sectionLabelHeight;

  /// Sum of the three participant column widths (serial + name + reg-id).
  final double participantListTotalWidth;

  /// Canvas margin (padding from canvas edges).
  final double canvasMargin;

  /// Vertical gap between WB and LB sections in DE.
  final double sectionGapHeight;

  /// Height of the logo row (0 when no logos present).
  final double logoRowHeight;

  // Medal table dimensional breakdown.
  final double medalTableWidth;
  final double medalRowHeight;
  final double medalNameColumnWidth;
  final double medalLabelColumnWidth;
  final double medalBlankColumnWidth;

  /// The font size delta from the theme (for renderers that need it).
  final double fontSizeDelta;
}

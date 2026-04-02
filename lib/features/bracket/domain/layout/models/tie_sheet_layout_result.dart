import 'dart:ui' show Size;

import 'package:tkd_saas/features/bracket/domain/layout/models/connector_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/header_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/match_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/medal_table_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/participant_row_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/section_label_layout_data.dart';

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

  final HeaderLayoutData headerLayoutData;

  /// Includes both real participant rows and TBD placeholder rows.
  /// Ordered by serial number (draw order).
  final List<ParticipantRowLayoutData> participantRowLayoutDataList;

  /// Includes standard junctions, center final, GF, GF reset, and
  /// third-place match nodes.
  final List<MatchLayoutData> matchLayoutDataList;

  /// Includes junction arms (bezier arcs), feeder lines, vertical trunks,
  /// BYE dashed lines, and GF output arms.
  final List<ConnectorLayoutData> connectorLayoutDataList;

  /// Always present for completed or in-progress brackets.
  final MedalTableLayoutData? medalTableLayoutData;

  /// Empty list for SE brackets; typically 2 entries (Winners, Losers)
  /// for DE brackets.
  final List<SectionLabelLayoutData> sectionLabelLayoutDataList;
}

/// Precomputed and cached dimensional tokens derived from
/// [TieSheetThemeConfig] and its `fontSizeDelta`.
///
/// The layout engine computes these once during `computeLayout()` and
/// stores them here. This eliminates redundant `config.X + delta * N`
/// calculations throughout both the layout and rendering phases.
///
/// All values are in logical pixels (canvas coordinates).
class TieSheetLayoutDimensions {
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

  final double participantRowHeight;

  final double intraMatchGapHeight;

  final double interMatchGapHeight;

  final double serialNumberColumnWidth;

  final double participantNameColumnWidth;

  final double registrationIdColumnWidth;

  final double roundColumnWidth;

  final double headerTotalHeight;

  final double headerBannerHeight;

  final double subHeaderRowHeight;

  final double medalTableTotalHeight;

  final double centerGapWidth;

  final double sectionLabelHeight;

  /// Sum of the three participant column widths (serial + name + reg-id).
  final double participantListTotalWidth;

  final double canvasMargin;

  final double sectionGapHeight;

  /// Height of the logo row (0 when no logos present).
  final double logoRowHeight;

  final double medalTableWidth;
  final double medalRowHeight;
  final double medalNameColumnWidth;
  final double medalLabelColumnWidth;
  final double medalBlankColumnWidth;

  final double fontSizeDelta;
}

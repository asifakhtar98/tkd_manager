import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'print_export_settings.freezed.dart';

// ── Paper Size ──────────────────────────────────────────────────────────────

/// Standard paper sizes supported for bracket PDF export.
enum PaperSize {
  a4('A4', 595.28, 841.89),
  letter('Letter', 612.0, 792.0),
  a3('A3', 841.89, 1190.55),
  legal('Legal', 612.0, 1008.0);

  const PaperSize(this.label, this.widthPoints, this.heightPoints);

  /// Human-readable label for the UI dropdown.
  final String label;

  /// Page width in PDF points (1 pt = 1/72 inch) in portrait orientation.
  final double widthPoints;

  /// Page height in PDF points (1 pt = 1/72 inch) in portrait orientation.
  final double heightPoints;
}

// ── Page Orientation ────────────────────────────────────────────────────────

/// Orientation for printed pages.
enum PageOrientation {
  portrait('Portrait'),
  landscape('Landscape');

  const PageOrientation(this.label);
  final String label;
}

// ── Fit Mode ────────────────────────────────────────────────────────────────

/// How the bracket image is mapped onto PDF pages.
enum PrintFitMode {
  /// Shrink the entire bracket to fit within a single page.
  fitToPage('Fit to Page'),

  /// Tile the bracket across multiple pages at the chosen scale,
  /// with optional overlap strips for physical reassembly.
  tileAcrossPages('Tile Across Pages');

  const PrintFitMode(this.label);
  final String label;
}

// ── Print Export Settings ───────────────────────────────────────────────────

/// Immutable configuration for bracket PDF export.
///
/// Encapsulates paper size, orientation, fit mode, scale factor, and tile
/// overlap. Provides computed helpers for printable area, tile grid
/// dimensions, and total page count.
@freezed
abstract class PrintExportSettings with _$PrintExportSettings {
  const PrintExportSettings._();

  const factory PrintExportSettings({
    @Default(PaperSize.a4) PaperSize paperSize,
    @Default(PageOrientation.landscape) PageOrientation orientation,
    @Default(PrintFitMode.tileAcrossPages) PrintFitMode fitMode,

    /// Scale applied to the bracket when tiling ([minScaleFactor]–[maxScaleFactor]).
    /// 1.0 = 1 logical pixel → 1 PDF point.
    /// Only used in [PrintFitMode.tileAcrossPages].
    @Default(1.0) double scaleFactor,

    /// Overlap between adjacent tiles in millimeters (0–30).
    /// Converted to PDF points internally (1 mm ≈ 2.835 pt).
    @Default(10.0) double tileOverlapMillimeters,

    /// Margin around each page in PDF points.
    @Default(24.0) double marginPoints,

    /// Whether to show assembly aid hints (registration marks and edge
    /// neighbor labels) on each tile page. Only used in tile mode.
    @Default(true) bool showTileAssemblyHints,
  }) = _PrintExportSettings;

  // ── Millimeter ↔ point conversion ──

  /// Millimeters to PDF points.
  static double mmToPoints(double mm) => mm * (72.0 / 25.4);

  /// Tile overlap in PDF points.
  double get tileOverlapPoints => mmToPoints(tileOverlapMillimeters);

  // ── Computed page dimensions ──

  /// Full page size in PDF points, accounting for orientation.
  ({double width, double height}) get pageSize {
    if (orientation == PageOrientation.landscape) {
      return (width: paperSize.heightPoints, height: paperSize.widthPoints);
    }
    return (width: paperSize.widthPoints, height: paperSize.heightPoints);
  }

  /// Printable area per page after subtracting margins, in PDF points.
  ({double width, double height}) get printableAreaPoints {
    final page = pageSize;
    return (
      width: page.width - marginPoints * 2,
      height: page.height - marginPoints * 2,
    );
  }

  // ── Tiling calculations ──

  /// The effective area each tile covers on the bracket canvas
  /// (printable area divided by scale, minus overlap contribution).
  ({double width, double height}) tileCanvasCoverage() {
    final printable = printableAreaPoints;
    return (
      width: printable.width / scaleFactor,
      height: printable.height / scaleFactor,
    );
  }

  /// The overlap in canvas-space (overlap points divided by scale).
  double get tileOverlapCanvasPixels => tileOverlapPoints / scaleFactor;

  /// How many columns and rows of tiles are needed to cover [canvasSize].
  ({int columns, int rows}) tileGridDimensions({
    required double canvasWidth,
    required double canvasHeight,
  }) {
    if (fitMode == PrintFitMode.fitToPage) {
      return (columns: 1, rows: 1);
    }

    final tileCoverage = tileCanvasCoverage();
    final overlapCanvas = tileOverlapCanvasPixels;

    // The first tile covers `tileCoverage.width`.
    // Each subsequent tile covers `tileCoverage.width - overlapCanvas` of NEW area.
    final effectiveStepWidth = tileCoverage.width - overlapCanvas;
    final effectiveStepHeight = tileCoverage.height - overlapCanvas;

    int columns = 1;
    if (canvasWidth > tileCoverage.width && effectiveStepWidth > 0) {
      final remainingWidth = canvasWidth - tileCoverage.width;
      columns = 1 + (remainingWidth / effectiveStepWidth).ceil();
    }

    int rows = 1;
    if (canvasHeight > tileCoverage.height && effectiveStepHeight > 0) {
      final remainingHeight = canvasHeight - tileCoverage.height;
      rows = 1 + (remainingHeight / effectiveStepHeight).ceil();
    }

    return (columns: columns, rows: rows);
  }

  /// Total number of pages the bracket will occupy.
  int totalPageCount({
    required double canvasWidth,
    required double canvasHeight,
  }) {
    final grid = tileGridDimensions(
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
    );
    return grid.columns * grid.rows;
  }

  // ── Scale factor range ──

  /// Minimum allowed scale factor for the tile mode slider.
  static const double minScaleFactor = 0.1;

  /// Maximum allowed scale factor for the tile mode slider.
  static const double maxScaleFactor = 2.0;

  /// Preset page-count targets shown as quick-action chips in the UI.
  static const List<int> pageTargetPresets = [1, 2, 4, 6, 9];

  // ── Smart-fit: compute optimal scale for a target page count ──

  /// Computes the **largest** scale factor (highest print quality) that
  /// produces at most [targetPageCount] pages when tiling the given canvas.
  ///
  /// **Algorithm**: iterates over every valid `(cols, rows)` grid where
  /// `cols × rows ≤ targetPageCount` and algebraically solves for the
  /// maximum scale that fits the canvas within that grid:
  ///
  /// ```
  /// scaleForCols = (printableW + (cols - 1) × netPrintableW) / canvasW
  /// scaleForRows = (printableH + (rows - 1) × netPrintableH) / canvasH
  /// scale = min(scaleForCols, scaleForRows)
  /// ```
  ///
  /// where `netPrintableW = printableW - overlapPts` accounts for the
  /// overlap strip that adjacent tiles share.
  ///
  /// Returns the scale clamped to
  /// [[minScaleFactor], [maxScaleFactor]].
  double computeScaleFactorForTargetPageCount({
    required double canvasWidth,
    required double canvasHeight,
    required int targetPageCount,
  }) {
    if (targetPageCount <= 0 || canvasWidth <= 0 || canvasHeight <= 0) {
      return 1.0;
    }

    final printable = printableAreaPoints;
    final overlapPts = tileOverlapPoints;

    // Net printable area per additional tile (after overlap deduction).
    final netPrintableWidth = printable.width - overlapPts;
    final netPrintableHeight = printable.height - overlapPts;

    // Guard against degenerate overlap ≥ printable area.
    if (netPrintableWidth <= 0 || netPrintableHeight <= 0) return 1.0;

    double bestScale = minScaleFactor;

    // Iterate all valid (cols, rows) grids where cols × rows ≤ target.
    for (int cols = 1; cols <= targetPageCount; cols++) {
      final int maxRows = targetPageCount ~/ cols;
      if (maxRows < 1) continue;

      // Scale that makes `cols` columns cover canvasWidth:
      // First tile covers printableW/scale, each subsequent covers
      // netPrintableW/scale. Total ≥ canvasWidth.
      // → scale ≤ (printableW + (cols-1) × netPrintableW) / canvasWidth
      final double scaleForColumns =
          (printable.width + (cols - 1) * netPrintableWidth) / canvasWidth;

      final double scaleForRows =
          (printable.height + (maxRows - 1) * netPrintableHeight) /
          canvasHeight;

      // Must satisfy both axes — take the smaller of the two.
      final double candidateScale = min(scaleForColumns, scaleForRows);

      // Prefer the largest scale (best quality) across all grids.
      if (candidateScale > bestScale) {
        bestScale = candidateScale;
      }
    }

    return bestScale.clamp(minScaleFactor, maxScaleFactor);
  }
}

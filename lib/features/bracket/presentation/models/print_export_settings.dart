import 'package:pdf/pdf.dart';

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

// ── Resolution Quality ──────────────────────────────────────────────────────

/// Maximum GPU texture dimension used when rasterising the bracket for PDF.
///
/// Higher values produce sharper prints but require more GPU memory.
enum PrintResolutionQuality {
  /// 4 000 px — faster, lower memory, sufficient for most screens.
  standard('Standard', 4000.0),

  /// 8 192 px — maximum sharpness for high-DPI / large-format prints.
  high('High', 8192.0);

  const PrintResolutionQuality(this.label, this.maxTextureDimension);

  /// Human-readable label for the UI toggle.
  final String label;

  /// The maximum pixel dimension passed to the rasteriser.
  final double maxTextureDimension;
}

// ── Print Export Settings ───────────────────────────────────────────────────

/// Immutable configuration for bracket PDF export.
///
/// Encapsulates paper size, orientation, fit mode, scale factor, and tile
/// overlap. Provides computed helpers for printable area, tile grid
/// dimensions, and total page count.
class PrintExportSettings {
  const PrintExportSettings({
    this.paperSize = PaperSize.a4,
    this.orientation = PageOrientation.landscape,
    this.fitMode = PrintFitMode.fitToPage,
    this.scaleFactor = 1.0,
    this.tileOverlapMillimeters = 10.0,
    this.marginPoints = 24.0,
    this.resolutionQuality = PrintResolutionQuality.standard,
  });

  final PaperSize paperSize;
  final PageOrientation orientation;
  final PrintFitMode fitMode;

  /// Scale applied to the bracket when tiling (0.5–2.0).
  /// 1.0 = 1 logical pixel → 1 PDF point.
  /// Only used in [PrintFitMode.tileAcrossPages].
  final double scaleFactor;

  /// Overlap between adjacent tiles in millimeters (0–30).
  /// Converted to PDF points internally (1 mm ≈ 2.835 pt).
  final double tileOverlapMillimeters;

  /// Margin around each page in PDF points.
  final double marginPoints;

  /// The rasterisation quality / max GPU texture dimension.
  final PrintResolutionQuality resolutionQuality;

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

  /// The [PdfPageFormat] for use with the `pdf` package.
  PdfPageFormat get pdfPageFormat {
    final page = pageSize;
    return PdfPageFormat(page.width, page.height, marginAll: marginPoints);
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

  // ── Copy-with ──

  PrintExportSettings copyWith({
    PaperSize? paperSize,
    PageOrientation? orientation,
    PrintFitMode? fitMode,
    double? scaleFactor,
    double? tileOverlapMillimeters,
    double? marginPoints,
    PrintResolutionQuality? resolutionQuality,
  }) {
    return PrintExportSettings(
      paperSize: paperSize ?? this.paperSize,
      orientation: orientation ?? this.orientation,
      fitMode: fitMode ?? this.fitMode,
      scaleFactor: scaleFactor ?? this.scaleFactor,
      tileOverlapMillimeters:
          tileOverlapMillimeters ?? this.tileOverlapMillimeters,
      marginPoints: marginPoints ?? this.marginPoints,
      resolutionQuality: resolutionQuality ?? this.resolutionQuality,
    );
  }

  // ── Equality ──

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrintExportSettings &&
          runtimeType == other.runtimeType &&
          paperSize == other.paperSize &&
          orientation == other.orientation &&
          fitMode == other.fitMode &&
          scaleFactor == other.scaleFactor &&
          tileOverlapMillimeters == other.tileOverlapMillimeters &&
          marginPoints == other.marginPoints &&
          resolutionQuality == other.resolutionQuality;

  @override
  int get hashCode => Object.hash(
    paperSize,
    orientation,
    fitMode,
    scaleFactor,
    tileOverlapMillimeters,
    marginPoints,
    resolutionQuality,
  );

  @override
  String toString() =>
      'PrintExportSettings(paperSize: $paperSize, orientation: $orientation, '
      'fitMode: $fitMode, scaleFactor: $scaleFactor, '
      'overlap: ${tileOverlapMillimeters}mm, margin: ${marginPoints}pt, '
      'resolution: $resolutionQuality)';
}

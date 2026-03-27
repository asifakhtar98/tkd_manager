import 'dart:math';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tkd_saas/features/bracket/presentation/models/print_export_settings.dart';

/// Renders assembly aids for tiled bracket PDF export.
///
/// Provides three aids that help users reassemble printed tiles on a wall:
/// 1. **Assembly Index Page** — miniature bracket with numbered grid overlay
/// 2. **Registration Marks** — crosshair marks at overlap zone boundaries
/// 3. **Edge Neighbor Labels** — directional labels showing which page connects
///
/// All drawing uses pdf-native vector primitives for crispness at any zoom.
class TileAssemblyAidRenderer {
  const TileAssemblyAidRenderer();

  // ── Styling constants ──────────────────────────────────────────────────

  static const double _registrationMarkArmLength = 8.0;
  static const double _registrationMarkStrokeWidth = 0.5;
  static const double _registrationMarkInset = 12.0;
  static const PdfColor _registrationMarkColor = PdfColor.fromInt(0xFF888888);

  static const double _neighborLabelFontSize = 7.0;
  static const PdfColor _neighborLabelColor = PdfColor.fromInt(0xFF999999);

  static const double _indexPageGridStrokeWidth = 1.0;
  static const PdfColor _indexPageGridColor = PdfColor.fromInt(0xFF2196F3);
  static const PdfColor _indexPageGridFillEven = PdfColor.fromInt(0x152196F3);
  static const double _indexPageLabelFontSize = 14.0;
  static const PdfColor _indexPageLabelColor = PdfColor.fromInt(0xFF1565C0);

  /// Vertical space reserved for the title and subtitle above the index map.
  static const double _indexPageHeaderHeight = 50.0;

  // ── 1. Assembly Index Page ─────────────────────────────────────────────

  /// Builds the assembly index page — a miniature bracket image overlaid
  /// with a numbered grid showing the tile layout.
  ///
  /// [bracketImageBytes] must be the full bracket rendered as a PNG.
  pw.Page buildAssemblyIndexPage({
    required Uint8List bracketImageBytes,
    required PrintExportSettings settings,
    required double canvasWidth,
    required double canvasHeight,
  }) {
    final grid = settings.tileGridDimensions(
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
    );
    final totalPages = grid.columns * grid.rows;

    return pw.Page(
      pageFormat: settings.pdfPageFormat,
      margin: pw.EdgeInsets.all(settings.marginPoints),
      build: (pw.Context context) {
        final printable = settings.printableAreaPoints;
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Title
            pw.Text(
              'ASSEMBLY GUIDE',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: const PdfColor.fromInt(0xFF333333),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              '${grid.columns} × ${grid.rows} grid  ·  '
              '$totalPages pages  ·  '
              '${settings.paperSize.label} ${settings.orientation.label}',
              style: const pw.TextStyle(
                fontSize: 9,
                color: PdfColor.fromInt(0xFF777777),
              ),
            ),
            pw.SizedBox(height: 12),
            // Bracket image with grid overlay
            pw.Expanded(
              child: _buildIndexMapWidget(
                bracketImageBytes: bracketImageBytes,
                settings: settings,
                canvasWidth: canvasWidth,
                canvasHeight: canvasHeight,
                maxWidth: printable.width,
                maxHeight: printable.height - _indexPageHeaderHeight,
              ),
            ),
          ],
        );
      },
    );
  }

  pw.Widget _buildIndexMapWidget({
    required Uint8List bracketImageBytes,
    required PrintExportSettings settings,
    required double canvasWidth,
    required double canvasHeight,
    required double maxWidth,
    required double maxHeight,
  }) {
    // Scale bracket image to fit available space.
    final aspectRatio = canvasWidth / canvasHeight;
    double displayWidth = maxWidth;
    double displayHeight = displayWidth / aspectRatio;

    if (displayHeight > maxHeight) {
      displayHeight = maxHeight;
      displayWidth = displayHeight * aspectRatio;
    }

    return pw.Center(
      child: pw.SizedBox(
        width: displayWidth,
        height: displayHeight,
        child: pw.Stack(
          children: [
            // Bracket raster image
            pw.Positioned.fill(
              child: pw.Image(
                pw.MemoryImage(bracketImageBytes),
                fit: pw.BoxFit.contain,
              ),
            ),
            // Grid overlay
            pw.Positioned.fill(
              child: pw.CustomPaint(
                size: PdfPoint(displayWidth, displayHeight),
                painter: (PdfGraphics canvas, PdfPoint size) {
                  _paintIndexGrid(
                    canvas: canvas,
                    size: size,
                    settings: settings,
                    canvasWidth: canvasWidth,
                    canvasHeight: canvasHeight,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _paintIndexGrid({
    required PdfGraphics canvas,
    required PdfPoint size,
    required PrintExportSettings settings,
    required double canvasWidth,
    required double canvasHeight,
  }) {
    final grid = settings.tileGridDimensions(
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
    );

    final tileCoverage = settings.tileCanvasCoverage();
    final overlapCanvas = settings.tileOverlapCanvasPixels;
    final effectiveStepWidth = tileCoverage.width - overlapCanvas;
    final effectiveStepHeight = tileCoverage.height - overlapCanvas;

    // Scale from canvas coords to display coords.
    final scaleX = size.x / canvasWidth;
    final scaleY = size.y / canvasHeight;

    int pageNumber = 0;
    for (int row = 0; row < grid.rows; row++) {
      for (int col = 0; col < grid.columns; col++) {
        pageNumber++;

        final canvasX = col * effectiveStepWidth;
        final canvasY = row * effectiveStepHeight;
        final canvasW = min(tileCoverage.width, canvasWidth - canvasX);
        final canvasH = min(tileCoverage.height, canvasHeight - canvasY);

        // PDF y-axis is bottom-up, so flip the y coordinate.
        final displayX = canvasX * scaleX;
        final displayY = size.y - (canvasY * scaleY) - (canvasH * scaleY);
        final displayW = canvasW * scaleX;
        final displayH = canvasH * scaleY;

        // Alternating fill
        if ((row + col) % 2 == 0) {
          canvas
            ..setFillColor(_indexPageGridFillEven)
            ..drawRect(displayX, displayY, displayW, displayH)
            ..fillPath();
        }

        // Grid border
        canvas
          ..setStrokeColor(_indexPageGridColor)
          ..setLineWidth(_indexPageGridStrokeWidth)
          ..drawRect(displayX, displayY, displayW, displayH)
          ..strokePath();

        // Page number label — centered in the cell.
        final labelText = 'P$pageNumber';
        final fontSize = min(
          _indexPageLabelFontSize,
          min(displayW * 0.3, displayH * 0.3),
        );
        if (fontSize >= 5) {
          final centerX = displayX + displayW / 2;
          final centerY = displayY + displayH / 2;
          canvas
            ..setFillColor(_indexPageLabelColor)
            ..drawString(
              canvas.defaultFont!,
              fontSize,
              labelText,
              centerX - (fontSize * labelText.length * 0.25),
              centerY - fontSize / 3,
            );
        }
      }
    }
  }

  // ── 2. Registration Marks ──────────────────────────────────────────────

  /// Builds registration crosshair marks for a tile at the given [row], [col]
  /// position in the grid.
  ///
  /// Returns a list of [pw.Positioned] widgets to be added to the tile's
  /// [pw.Stack]. Marks appear at the boundaries of overlap zones, which are
  /// the regions shared with adjacent tiles.
  List<pw.Widget> buildRegistrationMarks({
    required int row,
    required int col,
    required int totalColumns,
    required int totalRows,
    required PrintExportSettings settings,
  }) {
    // No marks needed for a 1×1 grid.
    if (totalColumns <= 1 && totalRows <= 1) return const [];

    final printable = settings.printableAreaPoints;
    final overlapPoints = settings.tileOverlapPoints;
    if (overlapPoints <= 0) return const [];

    final marks = <pw.Widget>[];
    final double armLength = _registrationMarkArmLength;
    final double inset = _registrationMarkInset;

    final bool hasLeftNeighbor = col > 0;
    final bool hasRightNeighbor = col < totalColumns - 1;
    final bool hasTopNeighbor = row > 0;
    final bool hasBottomNeighbor = row < totalRows - 1;

    // The overlap zones are strips along the edges where this tile shares
    // content with its neighbor. Registration marks go at the inner boundary
    // of each overlap strip (the edge where the overlap zone ends).

    // Right overlap boundary (vertical line at `printableW - overlapPts`)
    if (hasRightNeighbor) {
      final double markX = printable.width - overlapPoints;
      marks.addAll([
        _buildCrosshairMark(left: markX, top: inset, armLength: armLength),
        _buildCrosshairMark(
          left: markX,
          top: printable.height - inset,
          armLength: armLength,
        ),
      ]);
      if (printable.height > 200) {
        marks.add(
          _buildCrosshairMark(
            left: markX,
            top: printable.height / 2,
            armLength: armLength,
          ),
        );
      }
    }

    // Left overlap boundary (vertical line at `overlapPts`)
    if (hasLeftNeighbor) {
      final double markX = overlapPoints;
      marks.addAll([
        _buildCrosshairMark(left: markX, top: inset, armLength: armLength),
        _buildCrosshairMark(
          left: markX,
          top: printable.height - inset,
          armLength: armLength,
        ),
      ]);
      if (printable.height > 200) {
        marks.add(
          _buildCrosshairMark(
            left: markX,
            top: printable.height / 2,
            armLength: armLength,
          ),
        );
      }
    }

    // Bottom overlap boundary (horizontal line at `printableH - overlapPts`)
    if (hasBottomNeighbor) {
      final double markY = printable.height - overlapPoints;
      marks.addAll([
        _buildCrosshairMark(left: inset, top: markY, armLength: armLength),
        _buildCrosshairMark(
          left: printable.width - inset,
          top: markY,
          armLength: armLength,
        ),
      ]);
      if (printable.width > 200) {
        marks.add(
          _buildCrosshairMark(
            left: printable.width / 2,
            top: markY,
            armLength: armLength,
          ),
        );
      }
    }

    // Top overlap boundary (horizontal line at `overlapPts`)
    if (hasTopNeighbor) {
      final double markY = overlapPoints;
      marks.addAll([
        _buildCrosshairMark(left: inset, top: markY, armLength: armLength),
        _buildCrosshairMark(
          left: printable.width - inset,
          top: markY,
          armLength: armLength,
        ),
      ]);
      if (printable.width > 200) {
        marks.add(
          _buildCrosshairMark(
            left: printable.width / 2,
            top: markY,
            armLength: armLength,
          ),
        );
      }
    }

    return marks;
  }

  pw.Widget _buildCrosshairMark({
    required double left,
    required double top,
    required double armLength,
  }) {
    final double size = armLength * 2;
    return pw.Positioned(
      left: left - armLength,
      top: top - armLength,
      child: pw.CustomPaint(
        size: PdfPoint(size, size),
        painter: (PdfGraphics canvas, PdfPoint pdfSize) {
          final cx = pdfSize.x / 2;
          final cy = pdfSize.y / 2;
          canvas
            ..setStrokeColor(_registrationMarkColor)
            ..setLineWidth(_registrationMarkStrokeWidth)
            // Horizontal arm
            ..drawLine(0, cy, pdfSize.x, cy)
            ..strokePath()
            // Vertical arm
            ..drawLine(cx, 0, cx, pdfSize.y)
            ..strokePath();
        },
      ),
    );
  }

  // ── 3. Edge Neighbor Labels ────────────────────────────────────────────

  /// Builds directional labels (e.g. `→P3`) on each edge that has an
  /// adjacent tile, centered on that edge.
  ///
  /// Returns a list of [pw.Positioned] widgets to add to the tile's
  /// [pw.Stack].
  List<pw.Widget> buildEdgeNeighborLabels({
    required int row,
    required int col,
    required int totalColumns,
    required int totalRows,
    required PrintExportSettings settings,
  }) {
    if (totalColumns <= 1 && totalRows <= 1) return const [];

    final printable = settings.printableAreaPoints;
    final labels = <pw.Widget>[];

    int pageNumberOf(int neighborRow, int neighborCol) =>
        neighborRow * totalColumns + neighborCol + 1;

    final labelStyle = pw.TextStyle(
      fontSize: _neighborLabelFontSize,
      color: _neighborLabelColor,
    );

    // Right edge → neighbor at (row, col+1)
    if (col < totalColumns - 1) {
      final neighborPageNumber = pageNumberOf(row, col + 1);
      labels.add(
        pw.Positioned(
          right: 2,
          top: printable.height / 2 - _neighborLabelFontSize,
          child: pw.Transform.rotateBox(
            angle: -pi / 2,
            child: pw.Text('P$neighborPageNumber →', style: labelStyle),
          ),
        ),
      );
    }

    // Left edge ← neighbor at (row, col-1)
    if (col > 0) {
      final neighborPageNumber = pageNumberOf(row, col - 1);
      labels.add(
        pw.Positioned(
          left: 2,
          top: printable.height / 2 - _neighborLabelFontSize,
          child: pw.Transform.rotateBox(
            angle: pi / 2,
            child: pw.Text('← P$neighborPageNumber', style: labelStyle),
          ),
        ),
      );
    }

    // Top edge ↑ neighbor at (row-1, col)
    if (row > 0) {
      final neighborPageNumber = pageNumberOf(row - 1, col);
      final labelText = '↑ P$neighborPageNumber';
      final estimatedLabelWidth = labelText.length * _neighborLabelFontSize * 0.5;
      labels.add(
        pw.Positioned(
          left: printable.width / 2 - estimatedLabelWidth / 2,
          top: 2,
          child: pw.Text(labelText, style: labelStyle),
        ),
      );
    }

    // Bottom edge ↓ neighbor at (row+1, col)
    if (row < totalRows - 1) {
      final neighborPageNumber = pageNumberOf(row + 1, col);
      final labelText = '↓ P$neighborPageNumber';
      final estimatedLabelWidth = labelText.length * _neighborLabelFontSize * 0.5;
      labels.add(
        pw.Positioned(
          left: printable.width / 2 - estimatedLabelWidth / 2,
          bottom: 2,
          child: pw.Text(labelText, style: labelStyle),
        ),
      );
    }

    return labels;
  }
}

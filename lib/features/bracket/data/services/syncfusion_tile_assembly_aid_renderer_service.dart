import 'dart:math';

import 'dart:ui' show Color, Offset, Rect, Size;

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tkd_saas/features/bracket/data/services/pdf_color_converter.dart';
import 'package:tkd_saas/features/bracket/presentation/models/print_export_settings.dart';

/// Renders assembly aids for tiled bracket PDF export using Syncfusion's
/// [PdfGraphics] vector API.
///
/// Provides three types of assembly aids to help users reassemble printed
/// tiles on a wall:
///
/// 1. **Assembly Index Page** — miniature bracket grid with numbered cells
/// 2. **Registration Marks** — crosshair marks at overlap zone boundaries
/// 3. **Edge Neighbor Labels** — directional labels (e.g. `→P3`) showing
///    which page connects to each edge
///
/// All drawing is pure vector — no rasterization — for crispness at any DPI.
class SyncfusionTileAssemblyAidRendererService {
  const SyncfusionTileAssemblyAidRendererService();

  // ── Styling constants ──────────────────────────────────────────────────

  static const double _registrationMarkArmLength = 8.0;
  static const double _registrationMarkStrokeWidth = 0.5;
  static const Color _registrationMarkColor = Color(0xFF888888);

  static const double _neighborLabelFontSize = 7.0;
  static const Color _neighborLabelColor = Color(0xFF999999);

  static const double _indexPageGridStrokeWidth = 1.0;
  static const Color _indexPageGridColor = Color(0xFF2196F3);
  static const Color _indexPageGridFillEvenColor = Color(0x152196F3);
  static const double _indexPageLabelFontSize = 14.0;
  static const Color _indexPageLabelColor = Color(0xFF1565C0);

  /// Vertical space reserved for title and subtitle on the index page.
  static const double _indexPageHeaderHeight = 50.0;

  // ── 1. Assembly Index Page ─────────────────────────────────────────────

  /// Adds an assembly index page to the [document] — a miniature bracket
  /// grid showing numbered tile positions.
  ///
  /// The bracket area is represented as a rectangle with the tile grid
  /// drawn on top, showing page numbers in each cell.
  void renderAssemblyIndexPage({
    required PdfDocument document,
    required PrintExportSettings exportSettings,
    required double canvasWidth,
    required double canvasHeight,
  }) {
    final tileGridDimensions = exportSettings.tileGridDimensions(
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
    );
    final totalTilePageCount = tileGridDimensions.columns * tileGridDimensions.rows;

    final pageWidth = exportSettings.pageSize.width;
    final pageHeight = exportSettings.pageSize.height;
    document.pageSettings.size = Size(pageWidth, pageHeight);
    document.pageSettings.margins.all = exportSettings.marginPoints;

    final page = document.pages.add();
    final graphics = page.graphics;

    final printableWidth = exportSettings.printableAreaPoints.width;
    final printableHeight = exportSettings.printableAreaPoints.height;

    // ── Title ──
    final titleFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    graphics.drawString(
      'ASSEMBLY GUIDE',
      titleFont,
      bounds: Rect.fromLTWH(0, 0, printableWidth, 20),
      brush: PdfSolidBrush(const Color(0xFF333333).toPdfColor()),
    );

    final subtitleFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    final subtitleText = '${tileGridDimensions.columns} × ${tileGridDimensions.rows} grid  ·  '
        '$totalTilePageCount pages  ·  '
        '${exportSettings.paperSize.label} ${exportSettings.orientation.label}';
    graphics.drawString(
      subtitleText,
      subtitleFont,
      bounds: Rect.fromLTWH(0, 22, printableWidth, 16),
      brush: PdfSolidBrush(const Color(0xFF777777).toPdfColor()),
    );

    // ── Bracket miniature with grid overlay ──
    final availableWidth = printableWidth;
    final availableHeight = printableHeight - _indexPageHeaderHeight;
    final aspectRatio = canvasWidth / canvasHeight;
    double displayWidth = availableWidth;
    double displayHeight = displayWidth / aspectRatio;

    if (displayHeight > availableHeight) {
      displayHeight = availableHeight;
      displayWidth = displayHeight * aspectRatio;
    }

    // Center the miniature
    final displayOriginX = (availableWidth - displayWidth) / 2;
    final displayOriginY = _indexPageHeaderHeight + (availableHeight - displayHeight) / 2;

    // Draw bracket outline
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(displayOriginX, displayOriginY, displayWidth, displayHeight),
      pen: PdfPen(const Color(0xFFCCCCCC).toPdfColor(), width: 0.5),
      brush: PdfSolidBrush(const Color(0xFFF8F8F8).toPdfColor()),
    );

    // Draw tile grid
    _paintAssemblyIndexGrid(
      graphics: graphics,
      displayOriginX: displayOriginX,
      displayOriginY: displayOriginY,
      displayWidth: displayWidth,
      displayHeight: displayHeight,
      exportSettings: exportSettings,
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
    );
  }

  void _paintAssemblyIndexGrid({
    required PdfGraphics graphics,
    required double displayOriginX,
    required double displayOriginY,
    required double displayWidth,
    required double displayHeight,
    required PrintExportSettings exportSettings,
    required double canvasWidth,
    required double canvasHeight,
  }) {
    final tileGridDimensions = exportSettings.tileGridDimensions(
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
    );

    final tileCoverageArea = exportSettings.tileCanvasCoverage();
    final overlapCanvasPixels = exportSettings.tileOverlapCanvasPixels;
    final effectiveStepWidth = tileCoverageArea.width - overlapCanvasPixels;
    final effectiveStepHeight = tileCoverageArea.height - overlapCanvasPixels;

    final scaleToDisplayX = displayWidth / canvasWidth;
    final scaleToDisplayY = displayHeight / canvasHeight;

    final gridPen = PdfPen(_indexPageGridColor.toPdfColor(), width: _indexPageGridStrokeWidth);
    final evenFillBrush = PdfSolidBrush(_indexPageGridFillEvenColor.toPdfColor());

    int pageNumber = 0;
    for (int row = 0; row < tileGridDimensions.rows; row++) {
      for (int col = 0; col < tileGridDimensions.columns; col++) {
        pageNumber++;

        final canvasX = col * effectiveStepWidth;
        final canvasY = row * effectiveStepHeight;
        final canvasW = min(tileCoverageArea.width, canvasWidth - canvasX);
        final canvasH = min(tileCoverageArea.height, canvasHeight - canvasY);

        final displayX = displayOriginX + canvasX * scaleToDisplayX;
        final displayY = displayOriginY + canvasY * scaleToDisplayY;
        final displayW = canvasW * scaleToDisplayX;
        final displayH = canvasH * scaleToDisplayY;

        final cellRect = Rect.fromLTWH(displayX, displayY, displayW, displayH);

        // Alternating fill for visual distinction
        if ((row + col) % 2 == 0) {
          graphics.drawRectangle(bounds: cellRect, brush: evenFillBrush);
        }

        // Grid border
        graphics.drawRectangle(bounds: cellRect, pen: gridPen);

        // Page number label — centered in the cell
        final labelText = 'P$pageNumber';
        final fontSize = min(
          _indexPageLabelFontSize,
          min(displayW * 0.3, displayH * 0.3),
        );
        if (fontSize >= 5) {
          final pageLabelFont = PdfStandardFont(
            PdfFontFamily.helvetica,
            fontSize,
            style: PdfFontStyle.bold,
          );
          final measuredLabelSize = pageLabelFont.measureString(labelText);
          graphics.drawString(
            labelText,
            pageLabelFont,
            bounds: Rect.fromLTWH(
              displayX + (displayW - measuredLabelSize.width) / 2,
              displayY + (displayH - measuredLabelSize.height) / 2,
              measuredLabelSize.width + 4,
              measuredLabelSize.height + 2,
            ),
            brush: PdfSolidBrush(_indexPageLabelColor.toPdfColor()),
          );
        }
      }
    }
  }

  // ── 2. Registration Marks ──────────────────────────────────────────────

  /// Draws registration crosshair marks onto the [tilePageGraphics] for
  /// a tile at the given [tileRow], [tileColumn] position in the grid.
  ///
  /// Marks appear at overlap zone boundaries to help with physical alignment
  /// when assembling printed tiles.
  void renderRegistrationMarks({
    required PdfGraphics tilePageGraphics,
    required int tileRow,
    required int tileColumn,
    required int totalColumnCount,
    required int totalRowCount,
    required PrintExportSettings exportSettings,
  }) {
    if (totalColumnCount <= 1 && totalRowCount <= 1) return;

    final printableArea = exportSettings.printableAreaPoints;
    final overlapPoints = exportSettings.tileOverlapPoints;
    if (overlapPoints <= 0) return;

    final markPen = PdfPen(
      _registrationMarkColor.toPdfColor(),
      width: _registrationMarkStrokeWidth,
    );
    const double armLength = _registrationMarkArmLength;
    const double inset = 12.0;

    final bool hasLeftNeighbor = tileColumn > 0;
    final bool hasRightNeighbor = tileColumn < totalColumnCount - 1;
    final bool hasTopNeighbor = tileRow > 0;
    final bool hasBottomNeighbor = tileRow < totalRowCount - 1;

    // Right overlap boundary
    if (hasRightNeighbor) {
      final double markX = printableArea.width - overlapPoints;
      _drawCrosshairMark(tilePageGraphics, markX, inset, armLength, markPen);
      _drawCrosshairMark(tilePageGraphics, markX, printableArea.height - inset, armLength, markPen);
      if (printableArea.height > 200) {
        _drawCrosshairMark(tilePageGraphics, markX, printableArea.height / 2, armLength, markPen);
      }
    }

    // Left overlap boundary
    if (hasLeftNeighbor) {
      final double markX = overlapPoints;
      _drawCrosshairMark(tilePageGraphics, markX, inset, armLength, markPen);
      _drawCrosshairMark(tilePageGraphics, markX, printableArea.height - inset, armLength, markPen);
      if (printableArea.height > 200) {
        _drawCrosshairMark(tilePageGraphics, markX, printableArea.height / 2, armLength, markPen);
      }
    }

    // Bottom overlap boundary
    if (hasBottomNeighbor) {
      final double markY = printableArea.height - overlapPoints;
      _drawCrosshairMark(tilePageGraphics, inset, markY, armLength, markPen);
      _drawCrosshairMark(tilePageGraphics, printableArea.width - inset, markY, armLength, markPen);
      if (printableArea.width > 200) {
        _drawCrosshairMark(tilePageGraphics, printableArea.width / 2, markY, armLength, markPen);
      }
    }

    // Top overlap boundary
    if (hasTopNeighbor) {
      final double markY = overlapPoints;
      _drawCrosshairMark(tilePageGraphics, inset, markY, armLength, markPen);
      _drawCrosshairMark(tilePageGraphics, printableArea.width - inset, markY, armLength, markPen);
      if (printableArea.width > 200) {
        _drawCrosshairMark(tilePageGraphics, printableArea.width / 2, markY, armLength, markPen);
      }
    }
  }

  void _drawCrosshairMark(
    PdfGraphics graphics,
    double centerX,
    double centerY,
    double armLength,
    PdfPen pen,
  ) {
    // Horizontal arm
    graphics.drawLine(
      pen,
      Offset(centerX - armLength, centerY),
      Offset(centerX + armLength, centerY),
    );
    // Vertical arm
    graphics.drawLine(
      pen,
      Offset(centerX, centerY - armLength),
      Offset(centerX, centerY + armLength),
    );
  }

  // ── 3. Edge Neighbor Labels ────────────────────────────────────────────

  /// Draws directional labels (e.g. `→P3`) on each edge of the tile that
  /// has an adjacent neighbor. Labels help users identify how tiles connect
  /// during physical assembly.
  void renderEdgeNeighborLabels({
    required PdfGraphics tilePageGraphics,
    required int tileRow,
    required int tileColumn,
    required int totalColumnCount,
    required int totalRowCount,
    required PrintExportSettings exportSettings,
  }) {
    if (totalColumnCount <= 1 && totalRowCount <= 1) return;

    final printableArea = exportSettings.printableAreaPoints;
    final labelFont = PdfStandardFont(PdfFontFamily.helvetica, _neighborLabelFontSize);
    final labelBrush = PdfSolidBrush(_neighborLabelColor.toPdfColor());

    int pageNumberOf(int neighborRow, int neighborCol) =>
        neighborRow * totalColumnCount + neighborCol + 1;

    // Right edge → neighbor at (row, col+1)
    if (tileColumn < totalColumnCount - 1) {
      final neighborPageNumber = pageNumberOf(tileRow, tileColumn + 1);
      final labelText = 'P$neighborPageNumber →';
      final measuredSize = labelFont.measureString(labelText);
      tilePageGraphics.drawString(
        labelText,
        labelFont,
        bounds: Rect.fromLTWH(
          printableArea.width - measuredSize.width - 4,
          (printableArea.height - measuredSize.height) / 2,
          measuredSize.width + 4,
          measuredSize.height + 2,
        ),
        brush: labelBrush,
      );
    }

    // Left edge ← neighbor at (row, col-1)
    if (tileColumn > 0) {
      final neighborPageNumber = pageNumberOf(tileRow, tileColumn - 1);
      final labelText = '← P$neighborPageNumber';
      final measuredSize = labelFont.measureString(labelText);
      tilePageGraphics.drawString(
        labelText,
        labelFont,
        bounds: Rect.fromLTWH(
          4,
          (printableArea.height - measuredSize.height) / 2,
          measuredSize.width + 4,
          measuredSize.height + 2,
        ),
        brush: labelBrush,
      );
    }

    // Top edge ↑ neighbor at (row-1, col)
    if (tileRow > 0) {
      final neighborPageNumber = pageNumberOf(tileRow - 1, tileColumn);
      final labelText = 'P$neighborPageNumber above';
      final measuredSize = labelFont.measureString(labelText);
      tilePageGraphics.drawString(
        labelText,
        labelFont,
        bounds: Rect.fromLTWH(
          (printableArea.width - measuredSize.width) / 2,
          4,
          measuredSize.width + 4,
          measuredSize.height + 2,
        ),
        brush: labelBrush,
      );
    }

    // Bottom edge ↓ neighbor at (row+1, col)
    if (tileRow < totalRowCount - 1) {
      final neighborPageNumber = pageNumberOf(tileRow + 1, tileColumn);
      final labelText = 'P$neighborPageNumber below';
      final measuredSize = labelFont.measureString(labelText);
      tilePageGraphics.drawString(
        labelText,
        labelFont,
        bounds: Rect.fromLTWH(
          (printableArea.width - measuredSize.width) / 2,
          printableArea.height - measuredSize.height - 4,
          measuredSize.width + 4,
          measuredSize.height + 2,
        ),
        brush: labelBrush,
      );
    }
  }

}

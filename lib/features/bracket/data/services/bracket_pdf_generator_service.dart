import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tkd_saas/features/bracket/presentation/models/print_export_settings.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart';

/// Service responsible for rendering a [TieSheetPainter] into a PDF document.
///
/// Supports two modes:
/// - **Fit to page**: the entire bracket is scaled to fit on a single page.
/// - **Tile across pages**: the bracket is sliced into a grid of pages at the
///   configured scale and overlap, suitable for physical reassembly.
///
/// All rendering uses [ui.PictureRecorder] with safe scaling to avoid WebGL
/// `MAX_TEXTURE_SIZE` limits on Flutter Web.
class BracketPdfGeneratorService {
  const BracketPdfGeneratorService();

  /// Default maximum safe texture dimension to avoid WebGL silent clipping.
  /// Used as fallback when no explicit quality setting is provided.
  static const double _defaultMaxTextureDimension = 8192.0;

  /// Generates a PDF document from the given [painter] and [canvasSize]
  /// according to [settings].
  ///
  /// Returns the raw PDF bytes ready for printing or saving.
  Future<Uint8List> generatePdf({
    required TieSheetPainter painter,
    required Size canvasSize,
    required PrintExportSettings settings,
    void Function(double progress, String message)? onProgress,
  }) async {
    if (settings.fitMode == PrintFitMode.fitToPage) {
      return _generateFitToPagePdf(
        painter: painter,
        canvasSize: canvasSize,
        settings: settings,
        onProgress: onProgress,
      );
    }
    return _generateTiledPdf(
      painter: painter,
      canvasSize: canvasSize,
      settings: settings,
      onProgress: onProgress,
    );
  }

  // ── Fit-to-page mode ────────────────────────────────────────────────────

  Future<Uint8List> _generateFitToPagePdf({
    required TieSheetPainter painter,
    required Size canvasSize,
    required PrintExportSettings settings,
    void Function(double progress, String message)? onProgress,
  }) async {
    onProgress?.call(0.1, 'Rendering bracket…');
    await _yieldToEventLoop();

    // Render at full canvas resolution for maximum sharpness.
    // _renderCanvasRegionToImage clamps to the user-selected GPU texture
    // limit automatically, producing the highest quality raster possible.
    final double outputWidth = canvasSize.width;
    final double outputHeight = canvasSize.height;

    final double maxTexture = settings.resolutionQuality.maxTextureDimension;

    final imageBytes = await _renderCanvasRegionToImage(
      painter: painter,
      canvasSize: canvasSize,
      regionOffset: Offset.zero,
      regionSize: canvasSize,
      outputWidth: outputWidth,
      outputHeight: outputHeight,
      maxTextureDimension: maxTexture,
    );

    onProgress?.call(0.5, 'Building PDF…');
    await _yieldToEventLoop();

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: settings.pdfPageFormat,
        margin: pw.EdgeInsets.all(settings.marginPoints),
        build: (pw.Context ctx) {
          if (imageBytes != null) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(imageBytes),
                fit: pw.BoxFit.contain,
              ),
            );
          }
          return pw.Center(
            child: pw.Text(
              'Bracket image could not be captured.\n'
              'Please try again after the bracket has fully rendered.',
              textAlign: pw.TextAlign.center,
            ),
          );
        },
      ),
    );

    onProgress?.call(0.8, 'Generating PDF bytes…');
    await _yieldToEventLoop();

    return doc.save();
  }

  // ── Tiled mode ──────────────────────────────────────────────────────────

  Future<Uint8List> _generateTiledPdf({
    required TieSheetPainter painter,
    required Size canvasSize,
    required PrintExportSettings settings,
    void Function(double progress, String message)? onProgress,
  }) async {
    final grid = settings.tileGridDimensions(
      canvasWidth: canvasSize.width,
      canvasHeight: canvasSize.height,
    );
    final totalPages = grid.columns * grid.rows;

    final tileCoverage = settings.tileCanvasCoverage();
    final overlapCanvas = settings.tileOverlapCanvasPixels;
    final effectiveStepWidth = tileCoverage.width - overlapCanvas;
    final effectiveStepHeight = tileCoverage.height - overlapCanvas;

    final doc = pw.Document();
    final double maxTexture = settings.resolutionQuality.maxTextureDimension;

    int pageIndex = 0;
    for (int row = 0; row < grid.rows; row++) {
      for (int col = 0; col < grid.columns; col++) {
        pageIndex++;
        final progressFraction = pageIndex / totalPages;
        onProgress?.call(
          progressFraction * 0.8,
          'Rendering page $pageIndex of $totalPages…',
        );
        await _yieldToEventLoop();

        final regionOffsetX = col * effectiveStepWidth;
        final regionOffsetY = row * effectiveStepHeight;

        // Clamp region to not exceed canvas bounds.
        final regionWidth = min(
          tileCoverage.width,
          canvasSize.width - regionOffsetX,
        );
        final regionHeight = min(
          tileCoverage.height,
          canvasSize.height - regionOffsetY,
        );

        if (regionWidth <= 0 || regionHeight <= 0) continue;

        // Render each tile at the highest resolution that fits within the
        // user-selected GPU texture limit. The base output
        // (regionSize × scaleFactor) equals the printable area (~800px),
        // which is too low. We multiply by a high-DPI factor so each tile
        // rasterises at up to the chosen quality limit.
        final double baseOutputWidth = regionWidth * settings.scaleFactor;
        final double baseOutputHeight = regionHeight * settings.scaleFactor;
        final double highDpiMultiplier = min(
          maxTexture / baseOutputWidth,
          maxTexture / baseOutputHeight,
        ).clamp(1.0, double.infinity);

        final imageBytes = await _renderCanvasRegionToImage(
          painter: painter,
          canvasSize: canvasSize,
          regionOffset: Offset(regionOffsetX, regionOffsetY),
          regionSize: Size(regionWidth, regionHeight),
          outputWidth: baseOutputWidth * highDpiMultiplier,
          outputHeight: baseOutputHeight * highDpiMultiplier,
          maxTextureDimension: maxTexture,
        );

        if (imageBytes != null) {
          doc.addPage(
            pw.Page(
              pageFormat: settings.pdfPageFormat,
              margin: pw.EdgeInsets.all(settings.marginPoints),
              build: (pw.Context ctx) {
                final printable = settings.printableAreaPoints;
                return pw.Stack(
                  children: [
                    pw.Positioned(
                      left: 0,
                      top: 0,
                      child: pw.Image(
                        pw.MemoryImage(imageBytes),
                        width: printable.width,
                        height: printable.height,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                    // Page label for assembly reference.
                    pw.Positioned(
                      right: 0,
                      bottom: 0,
                      child: pw.Text(
                        'Page $pageIndex of $totalPages  (R${row + 1} C${col + 1})',
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: PdfColor.fromInt(0xFF999999),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
      }
    }

    onProgress?.call(0.9, 'Generating PDF bytes…');
    await _yieldToEventLoop();

    return doc.save();
  }

  // ── Shared rendering helper ─────────────────────────────────────────────

  /// Renders a specific rectangular region of the bracket canvas to a PNG
  /// image. Uses [ui.PictureRecorder] with safe GPU texture scaling.
  ///
  /// - [regionOffset]: top-left corner of the viewport into the canvas.
  /// - [regionSize]: how much of the canvas to capture (in canvas pixels).
  /// - [outputWidth]/[outputHeight]: desired rasterised image dimensions
  ///   (in pixels). These are clamped to [maxTextureDimension].
  /// - [maxTextureDimension]: the maximum allowed pixel dimension, defaults
  ///   to [_defaultMaxTextureDimension].
  Future<Uint8List?> _renderCanvasRegionToImage({
    required TieSheetPainter painter,
    required Size canvasSize,
    required Offset regionOffset,
    required Size regionSize,
    required double outputWidth,
    required double outputHeight,
    double maxTextureDimension = _defaultMaxTextureDimension,
  }) async {
    // Clamp output dimensions to safe GPU texture limit.
    final double safeScale = min(
      1.0,
      min(
        maxTextureDimension / outputWidth,
        maxTextureDimension / outputHeight,
      ),
    );
    final int imageWidth = (outputWidth * safeScale).ceil();
    final int imageHeight = (outputHeight * safeScale).ceil();
    if (imageWidth <= 0 || imageHeight <= 0) return null;

    // The scale from canvas-space to image-space.
    final double scaleX = imageWidth / regionSize.width;
    final double scaleY = imageHeight / regionSize.height;
    // Use uniform scale (preserve aspect ratio).
    final double uniformScale = min(scaleX, scaleY);

    final recorder = ui.PictureRecorder();
    final recordingCanvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, imageWidth.toDouble(), imageHeight.toDouble()),
    );

    // Translate so the region of interest starts at (0, 0), then scale.
    recordingCanvas.scale(uniformScale);
    recordingCanvas.translate(-regionOffset.dx, -regionOffset.dy);

    painter.paint(recordingCanvas, canvasSize);

    final ui.Picture picture = recorder.endRecording();

    try {
      final ui.Image image = await picture.toImage(imageWidth, imageHeight);
      try {
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        return byteData?.buffer.asUint8List();
      } finally {
        image.dispose();
      }
    } finally {
      picture.dispose();
    }
  }

  /// Yields to the event loop so progress updates and UI repaints can happen.
  Future<void> _yieldToEventLoop() => Future<void>.delayed(Duration.zero);
}

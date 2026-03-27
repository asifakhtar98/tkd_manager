import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tkd_saas/features/bracket/data/services/tile_assembly_aid_renderer.dart';
import 'package:tkd_saas/features/bracket/presentation/models/print_export_settings.dart';

void main() {
  const renderer = TileAssemblyAidRenderer();

  // Shared settings used across tests — A4 landscape, tiled, 10mm overlap.
  const tiledSettings = PrintExportSettings(
    fitMode: PrintFitMode.tileAcrossPages,
    paperSize: PaperSize.a4,
    orientation: PageOrientation.landscape,
    scaleFactor: 1.0,
    tileOverlapMillimeters: 10,
  );

  group('TileAssemblyAidRenderer', () {
    // ── Assembly Index Page ──────────────────────────────────────────────

    group('buildAssemblyIndexPage', () {
      test('returns a valid pw.Page', () {
        // Create a minimal 1×1 white PNG for the bracket image.
        // (Transparent PNG header + minimal IDAT)
        final fakePngBytes = _createMinimalPng();

        final page = renderer.buildAssemblyIndexPage(
          bracketImageBytes: fakePngBytes,
          settings: tiledSettings,
          canvasWidth: 2960,
          canvasHeight: 4284,
        );

        expect(page, isA<pw.Page>());
      });
    });

    // ── Registration Marks ──────────────────────────────────────────────

    group('buildRegistrationMarks', () {
      test('returns empty list for 1×1 grid', () {
        final marks = renderer.buildRegistrationMarks(
          row: 0,
          col: 0,
          totalColumns: 1,
          totalRows: 1,
          settings: tiledSettings,
        );

        expect(marks, isEmpty);
      });

      test('returns empty list when overlap is zero', () {
        const noOverlapSettings = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          paperSize: PaperSize.a4,
          orientation: PageOrientation.landscape,
          tileOverlapMillimeters: 0,
        );

        final marks = renderer.buildRegistrationMarks(
          row: 0,
          col: 0,
          totalColumns: 2,
          totalRows: 2,
          settings: noOverlapSettings,
        );

        expect(marks, isEmpty);
      });

      test('corner tile (0,0) has marks on right and bottom edges only', () {
        final marks = renderer.buildRegistrationMarks(
          row: 0,
          col: 0,
          totalColumns: 3,
          totalRows: 3,
          settings: tiledSettings,
        );

        // Right edge: top, bottom, mid = 3; Bottom edge: left, right, mid = 3
        // Total = 6 marks for a corner tile with large printable area.
        expect(marks, isNotEmpty);
        expect(marks.length, greaterThanOrEqualTo(4));
      });

      test(
        'interior tile has marks on all four edges',
        () {
          final marks = renderer.buildRegistrationMarks(
            row: 1,
            col: 1,
            totalColumns: 3,
            totalRows: 3,
            settings: tiledSettings,
          );

          // All 4 edges × (top+bottom+mid or left+right+mid) = up to 12 marks
          expect(marks, isNotEmpty);
          expect(marks.length, greaterThan(8));
        },
      );

      test(
        'edge tile (0, middle) has marks on left, right, and bottom',
        () {
          final marks = renderer.buildRegistrationMarks(
            row: 0,
            col: 1,
            totalColumns: 3,
            totalRows: 3,
            settings: tiledSettings,
          );

          // 3 edges with marks (left, right, bottom) — no top.
          expect(marks, isNotEmpty);
          expect(marks.length, greaterThanOrEqualTo(6));
        },
      );
    });

    // ── Edge Neighbor Labels ────────────────────────────────────────────

    group('buildEdgeNeighborLabels', () {
      test('returns empty list for 1×1 grid', () {
        final labels = renderer.buildEdgeNeighborLabels(
          row: 0,
          col: 0,
          totalColumns: 1,
          totalRows: 1,
          settings: tiledSettings,
        );

        expect(labels, isEmpty);
      });

      test('top-left corner tile has right and bottom labels', () {
        final labels = renderer.buildEdgeNeighborLabels(
          row: 0,
          col: 0,
          totalColumns: 3,
          totalRows: 3,
          settings: tiledSettings,
        );

        // Should have 2 labels: right → P2, bottom → P4
        expect(labels.length, 2);
      });

      test('interior tile has labels on all four edges', () {
        final labels = renderer.buildEdgeNeighborLabels(
          row: 1,
          col: 1,
          totalColumns: 3,
          totalRows: 3,
          settings: tiledSettings,
        );

        // Should have 4 labels: left, right, top, bottom
        expect(labels.length, 4);
      });

      test('bottom-right corner tile has left and top labels', () {
        final labels = renderer.buildEdgeNeighborLabels(
          row: 2,
          col: 2,
          totalColumns: 3,
          totalRows: 3,
          settings: tiledSettings,
        );

        // Should have 2 labels: left ← P8, top ↑ P6
        expect(labels.length, 2);
      });

      test('single-column grid has top and bottom labels only', () {
        final labels = renderer.buildEdgeNeighborLabels(
          row: 1,
          col: 0,
          totalColumns: 1,
          totalRows: 3,
          settings: tiledSettings,
        );

        // Middle row in a 1-column grid: top and bottom only
        expect(labels.length, 2);
      });

      test('single-row grid has left and right labels only', () {
        final labels = renderer.buildEdgeNeighborLabels(
          row: 0,
          col: 1,
          totalColumns: 3,
          totalRows: 1,
          settings: tiledSettings,
        );

        // Middle col in a 1-row grid: left and right only
        expect(labels.length, 2);
      });
    });
  });
}

/// Creates a minimal valid 1×1 white PNG for testing.
///
/// This is the smallest valid PNG file — used as a stand-in for the bracket
/// image when testing the assembly index page builder.
Uint8List _createMinimalPng() {
  // Minimal 1×1 white PNG (67 bytes)
  return Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
    0x00, 0x00, 0x00, 0x0D, // IHDR length
    0x49, 0x48, 0x44, 0x52, // IHDR
    0x00, 0x00, 0x00, 0x01, // width = 1
    0x00, 0x00, 0x00, 0x01, // height = 1
    0x08, 0x02, // bit depth = 8, color type = 2 (RGB)
    0x00, 0x00, 0x00, // compression, filter, interlace
    0x90, 0x77, 0x53, 0xDE, // CRC
    0x00, 0x00, 0x00, 0x0C, // IDAT length
    0x49, 0x44, 0x41, 0x54, // IDAT
    0x08, 0xD7, 0x63, 0xF8, 0xCF, 0xC0, 0x00, 0x00,
    0x01, 0x01, 0x01, 0x00, // compressed data
    0x18, 0xDD, 0x8D, 0xB4, // CRC
    0x00, 0x00, 0x00, 0x00, // IEND length
    0x49, 0x45, 0x4E, 0x44, // IEND
    0xAE, 0x42, 0x60, 0x82, // CRC
  ]);
}

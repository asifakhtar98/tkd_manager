import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/presentation/models/print_export_settings.dart';

void main() {
  group('PrintExportSettings', () {
    // Default values
    test('default settings use A4 landscape fitToPage', () {
      const settings = PrintExportSettings();

      expect(settings.paperSize, PaperSize.a4);
      expect(settings.orientation, PageOrientation.landscape);
      expect(settings.fitMode, PrintFitMode.tileAcrossPages);
      expect(settings.scaleFactor, 1.0);
      expect(settings.tileOverlapMillimeters, 10.0);
      expect(settings.marginPoints, 24.0);
    });

    group('pageSize', () {
      test('A4 portrait returns portrait dimensions', () {
        const settings = PrintExportSettings(
          paperSize: PaperSize.a4,
          orientation: PageOrientation.portrait,
        );
        final page = settings.pageSize;

        expect(page.width, PaperSize.a4.widthPoints);
        expect(page.height, PaperSize.a4.heightPoints);
      });

      test('A4 landscape swaps width and height', () {
        const settings = PrintExportSettings(
          paperSize: PaperSize.a4,
          orientation: PageOrientation.landscape,
        );
        final page = settings.pageSize;

        expect(page.width, PaperSize.a4.heightPoints);
        expect(page.height, PaperSize.a4.widthPoints);
      });

      test('Letter portrait returns letter dimensions', () {
        const settings = PrintExportSettings(
          paperSize: PaperSize.letter,
          orientation: PageOrientation.portrait,
        );
        final page = settings.pageSize;

        expect(page.width, 612.0);
        expect(page.height, 792.0);
      });
    });

    group('printableAreaPoints', () {
      test('subtracts margins from page size', () {
        const settings = PrintExportSettings(
          paperSize: PaperSize.a4,
          orientation: PageOrientation.landscape,
          marginPoints: 24.0,
        );
        final page = settings.pageSize;
        final printable = settings.printableAreaPoints;

        expect(printable.width, page.width - 48);
        expect(printable.height, page.height - 48);
      });

      test('zero margins gives full page size', () {
        const settings = PrintExportSettings(
          paperSize: PaperSize.a4,
          orientation: PageOrientation.portrait,
          marginPoints: 0,
        );
        final page = settings.pageSize;
        final printable = settings.printableAreaPoints;

        expect(printable.width, page.width);
        expect(printable.height, page.height);
      });
    });

    test('mmToPoints converts 25.4mm to 72pt', () {
      // 1 inch = 25.4mm = 72pt
      expect(PrintExportSettings.mmToPoints(25.4), closeTo(72.0, 0.01));
    });

    test('tileOverlapPoints converts mm to points correctly', () {
      const settings = PrintExportSettings(tileOverlapMillimeters: 10.0);
      // 10mm ≈ 28.35pt
      expect(settings.tileOverlapPoints, closeTo(28.35, 0.1));
    });

    group('tileGridDimensions', () {
      test('fitToPage always returns 1×1 regardless of canvas size', () {
        const settings = PrintExportSettings(fitMode: PrintFitMode.fitToPage);
        final grid = settings.tileGridDimensions(
          canvasWidth: 10000,
          canvasHeight: 10000,
        );

        expect(grid.columns, 1);
        expect(grid.rows, 1);
      });

      test('small canvas fits in one tile', () {
        const settings = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          paperSize: PaperSize.a4,
          orientation: PageOrientation.landscape,
          scaleFactor: 1.0,
          tileOverlapMillimeters: 0,
        );
        // A4 landscape printable area ≈ 793.89 × 547.28 pt
        final grid = settings.tileGridDimensions(
          canvasWidth: 500,
          canvasHeight: 400,
        );

        expect(grid.columns, 1);
        expect(grid.rows, 1);
      });

      test(
        'canvas exactly double the printable area needs 2 tiles per axis',
        () {
          const settings = PrintExportSettings(
            fitMode: PrintFitMode.tileAcrossPages,
            paperSize: PaperSize.a4,
            orientation: PageOrientation.landscape,
            scaleFactor: 1.0,
            tileOverlapMillimeters: 0,
          );
          final printable = settings.printableAreaPoints;

          // Canvas is exactly 2x the printable area
          final grid = settings.tileGridDimensions(
            canvasWidth: printable.width * 2,
            canvasHeight: printable.height * 2,
          );

          expect(grid.columns, 2);
          expect(grid.rows, 2);
        },
      );

      test('overlap reduces effective coverage requiring more tiles', () {
        const settingsWithoutOverlap = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          scaleFactor: 1.0,
          tileOverlapMillimeters: 0,
        );
        const settingsWithOverlap = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          scaleFactor: 1.0,
          tileOverlapMillimeters: 30.0,
        );

        const canvasWidth = 3000.0;
        const canvasHeight = 3000.0;

        final gridWithout = settingsWithoutOverlap.tileGridDimensions(
          canvasWidth: canvasWidth,
          canvasHeight: canvasHeight,
        );
        final gridWith = settingsWithOverlap.tileGridDimensions(
          canvasWidth: canvasWidth,
          canvasHeight: canvasHeight,
        );

        // With overlap, we need at least as many tiles as without.
        expect(
          gridWith.columns * gridWith.rows,
          greaterThanOrEqualTo(gridWithout.columns * gridWithout.rows),
        );
      });

      test('higher scale factor means more tiles', () {
        const settingsLowScale = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          scaleFactor: 0.5,
          tileOverlapMillimeters: 0,
        );
        const settingsHighScale = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          scaleFactor: 2.0,
          tileOverlapMillimeters: 0,
        );

        const canvasWidth = 3000.0;
        const canvasHeight = 3000.0;

        final pagesLow = settingsLowScale.totalPageCount(
          canvasWidth: canvasWidth,
          canvasHeight: canvasHeight,
        );
        final pagesHigh = settingsHighScale.totalPageCount(
          canvasWidth: canvasWidth,
          canvasHeight: canvasHeight,
        );

        expect(pagesHigh, greaterThan(pagesLow));
      });
    });

    group('totalPageCount', () {
      test('equals columns × rows', () {
        const settings = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          scaleFactor: 1.0,
          tileOverlapMillimeters: 0,
        );
        final grid = settings.tileGridDimensions(
          canvasWidth: 3000,
          canvasHeight: 3000,
        );
        final total = settings.totalPageCount(
          canvasWidth: 3000,
          canvasHeight: 3000,
        );

        expect(total, grid.columns * grid.rows);
      });

      test('fitToPage is always 1', () {
        const settings = PrintExportSettings(fitMode: PrintFitMode.fitToPage);

        expect(
          settings.totalPageCount(canvasWidth: 9999, canvasHeight: 9999),
          1,
        );
      });
    });

    group('copyWith', () {
      test('copies with changed paper size', () {
        const original = PrintExportSettings(paperSize: PaperSize.a4);
        final copied = original.copyWith(paperSize: PaperSize.a3);

        expect(copied.paperSize, PaperSize.a3);
        expect(copied.orientation, original.orientation);
        expect(copied.fitMode, original.fitMode);
        expect(copied.scaleFactor, original.scaleFactor);
      });

      test('copies with changed fit mode preserves other fields', () {
        const original = PrintExportSettings(
          paperSize: PaperSize.letter,
          orientation: PageOrientation.portrait,
          scaleFactor: 1.5,
        );
        final copied = original.copyWith(fitMode: PrintFitMode.tileAcrossPages);

        expect(copied.fitMode, PrintFitMode.tileAcrossPages);
        expect(copied.paperSize, PaperSize.letter);
        expect(copied.orientation, PageOrientation.portrait);
        expect(copied.scaleFactor, 1.5);
      });
    });

    group('equality', () {
      test('identical settings are equal', () {
        const a = PrintExportSettings();
        const b = PrintExportSettings();

        expect(a, equals(b));
        expect(a.hashCode, b.hashCode);
      });

      test('different paper sizes are not equal', () {
        const a = PrintExportSettings(paperSize: PaperSize.a4);
        const b = PrintExportSettings(paperSize: PaperSize.a3);

        expect(a, isNot(equals(b)));
      });

      test('different scale factors are not equal', () {
        const a = PrintExportSettings(scaleFactor: 1.0);
        const b = PrintExportSettings(scaleFactor: 1.5);

        expect(a, isNot(equals(b)));
      });

      test('toString includes all field values', () {
        const settings = PrintExportSettings(
          paperSize: PaperSize.letter,
          scaleFactor: 1.5,
        );
        final str = settings.toString();

        expect(str, contains('letter'));
        expect(str, contains('1.5'));
      });
    });

    test('64-player bracket canvas produces multiple tiles at scale 1.0', () {
      // A 64-player SE bracket has approximate canvas size of ~2960 × 4284
      const settings = PrintExportSettings(
        fitMode: PrintFitMode.tileAcrossPages,
        paperSize: PaperSize.a4,
        orientation: PageOrientation.landscape,
        scaleFactor: 1.0,
        tileOverlapMillimeters: 10,
      );

      final total = settings.totalPageCount(
        canvasWidth: 2960,
        canvasHeight: 4284,
      );

      // Should require more than 1 page to tile a bracket this large.
      expect(total, greaterThan(1));
    });

    test('minScaleFactor is 0.1 and maxScaleFactor is 2.0', () {
      expect(PrintExportSettings.minScaleFactor, 0.1);
      expect(PrintExportSettings.maxScaleFactor, 2.0);
    });

    test('pageTargetPresets contains expected values', () {
      expect(PrintExportSettings.pageTargetPresets, [1, 2, 4, 6, 9]);
    });

    group('computeScaleFactorForTargetPageCount', () {
      test('small canvas already fits in 1 page returns high scale', () {
        const settings = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          paperSize: PaperSize.a4,
          orientation: PageOrientation.landscape,
          tileOverlapMillimeters: 0,
        );
        final printable = settings.printableAreaPoints;

        // Canvas smaller than the printable area should easily fit.
        final scale = settings.computeScaleFactorForTargetPageCount(
          canvasWidth: printable.width * 0.5,
          canvasHeight: printable.height * 0.5,
          targetPageCount: 1,
        );

        // The computed scale should be at the maximum (clamped to 2.0).
        expect(scale, PrintExportSettings.maxScaleFactor);
      });

      test('large canvas with target=1 produces valid scale for 1 page', () {
        const settings = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          paperSize: PaperSize.a4,
          orientation: PageOrientation.landscape,
          tileOverlapMillimeters: 10,
        );

        final scale = settings.computeScaleFactorForTargetPageCount(
          canvasWidth: 2960,
          canvasHeight: 4284,
          targetPageCount: 1,
        );

        // Verify it actually produces 1 page (or at most 1).
        final adjusted = settings.copyWith(scaleFactor: scale);
        final pages = adjusted.totalPageCount(
          canvasWidth: 2960,
          canvasHeight: 4284,
        );

        expect(pages, lessThanOrEqualTo(1));
        expect(scale, greaterThanOrEqualTo(PrintExportSettings.minScaleFactor));
      });

      test('large canvas with target=4 produces ≤4 pages', () {
        const settings = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          paperSize: PaperSize.a4,
          orientation: PageOrientation.landscape,
          tileOverlapMillimeters: 10,
        );

        final scale = settings.computeScaleFactorForTargetPageCount(
          canvasWidth: 2960,
          canvasHeight: 4284,
          targetPageCount: 4,
        );

        final adjusted = settings.copyWith(scaleFactor: scale);
        final pages = adjusted.totalPageCount(
          canvasWidth: 2960,
          canvasHeight: 4284,
        );

        expect(pages, lessThanOrEqualTo(4));
        expect(scale, greaterThan(PrintExportSettings.minScaleFactor));
      });

      test('higher target allows larger (better quality) scale', () {
        const settings = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          paperSize: PaperSize.a4,
          orientation: PageOrientation.landscape,
          tileOverlapMillimeters: 10,
        );

        final scaleFor2 = settings.computeScaleFactorForTargetPageCount(
          canvasWidth: 2960,
          canvasHeight: 4284,
          targetPageCount: 2,
        );
        final scaleFor9 = settings.computeScaleFactorForTargetPageCount(
          canvasWidth: 2960,
          canvasHeight: 4284,
          targetPageCount: 9,
        );

        expect(scaleFor9, greaterThanOrEqualTo(scaleFor2));
      });

      test('result is clamped between min and max scale', () {
        const settings = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          paperSize: PaperSize.a4,
          orientation: PageOrientation.landscape,
          tileOverlapMillimeters: 10,
        );

        final scale = settings.computeScaleFactorForTargetPageCount(
          canvasWidth: 2960,
          canvasHeight: 4284,
          targetPageCount: 1,
        );

        expect(scale, greaterThanOrEqualTo(PrintExportSettings.minScaleFactor));
        expect(scale, lessThanOrEqualTo(PrintExportSettings.maxScaleFactor));
      });

      test('degenerate inputs return 1.0', () {
        const settings = PrintExportSettings();

        expect(
          settings.computeScaleFactorForTargetPageCount(
            canvasWidth: 0,
            canvasHeight: 100,
            targetPageCount: 4,
          ),
          1.0,
        );
        expect(
          settings.computeScaleFactorForTargetPageCount(
            canvasWidth: 100,
            canvasHeight: 0,
            targetPageCount: 4,
          ),
          1.0,
        );
        expect(
          settings.computeScaleFactorForTargetPageCount(
            canvasWidth: 100,
            canvasHeight: 100,
            targetPageCount: 0,
          ),
          1.0,
        );
      });

      test('overlap-heavy settings still produce valid results', () {
        const settings = PrintExportSettings(
          fitMode: PrintFitMode.tileAcrossPages,
          paperSize: PaperSize.a4,
          orientation: PageOrientation.landscape,
          tileOverlapMillimeters: 30,
        );

        final scale = settings.computeScaleFactorForTargetPageCount(
          canvasWidth: 2960,
          canvasHeight: 4284,
          targetPageCount: 6,
        );

        final adjusted = settings.copyWith(scaleFactor: scale);
        final pages = adjusted.totalPageCount(
          canvasWidth: 2960,
          canvasHeight: 4284,
        );

        expect(pages, lessThanOrEqualTo(6));
      });
    });
  });
}

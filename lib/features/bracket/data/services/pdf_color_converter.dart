import 'dart:ui' show Color;

import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Extension on [Color] to convert Flutter colours to Syncfusion [PdfColor].
///
/// Used by both [TieSheetSyncfusionPdfRendererService] and
/// [SyncfusionTileAssemblyAidRendererService] to avoid duplicate conversion
/// logic.
extension PdfColorConverter on Color {
  /// Converts this [Color] to a Syncfusion [PdfColor].
  ///
  /// Handles the `0.0–1.0` channel range used by Flutter's `Color` API,
  /// mapping each channel to the `0–255` integer range expected by
  /// [PdfColor].
  PdfColor toPdfColor() => PdfColor(
        (r * 255.0).round().clamp(0, 255),
        (g * 255.0).round().clamp(0, 255),
        (b * 255.0).round().clamp(0, 255),
        (a * 255.0).round().clamp(0, 255),
      );
}

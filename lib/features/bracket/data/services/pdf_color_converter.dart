import 'dart:ui' show Color;

import 'package:syncfusion_flutter_pdf/pdf.dart';

extension PdfColorConverter on Color {
  PdfColor toPdfColor() => PdfColor(
    (r * 255.0).round().clamp(0, 255),
    (g * 255.0).round().clamp(0, 255),
    (b * 255.0).round().clamp(0, 255),
    (a * 255.0).round().clamp(0, 255),
  );
}

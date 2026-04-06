import 'package:flutter/material.dart';

/// Paper size options available for single-page bracket PDF export.
///
/// Dimensions are expressed in PDF points (1 point = 1/72 inch).
enum ExportPaperSize {
  a4('A4 (210 × 297 mm)', 595.28, 841.89),
  a3('A3 (297 × 420 mm)', 841.89, 1190.55);

  const ExportPaperSize(
    this.displayLabel,
    this.widthInPoints,
    this.heightInPoints,
  );

  /// Human-readable label shown in the paper size selector.
  final String displayLabel;

  /// Portrait-oriented page width in PDF points.
  final double widthInPoints;

  /// Portrait-oriented page height in PDF points.
  final double heightInPoints;

  /// Short label used for file naming (e.g., "A4", "A3").
  String get shortLabel => name.toUpperCase();
}

/// Resolved export configuration returned by [BracketExportSettingsDialog].
///
/// Encapsulates the user's paper size and margin preferences, and provides
/// computed printable area dimensions ready for the PDF renderer.
class BracketExportSettings {
  const BracketExportSettings({
    required this.paperSize,
    required this.includePrinterMargins,
  });

  final ExportPaperSize paperSize;
  final bool includePrinterMargins;

  /// Standard safe printer margin of 15 mm expressed in PDF points (72 dpi).
  ///
  /// 15 mm × (72 pt / 25.4 mm) ≈ 42.52 pt.
  /// This value covers the unprintable hardware margin of most inkjet and
  /// laser printers.
  static const double printerMarginInPoints = 42.52;

  /// Full page width in points (no margins subtracted).
  double get effectivePageWidth => paperSize.widthInPoints;

  /// Full page height in points (no margins subtracted).
  double get effectivePageHeight => paperSize.heightInPoints;

  /// Horizontal space available for bracket content after applying margins.
  double get printableAreaWidth => includePrinterMargins
      ? paperSize.widthInPoints - (2 * printerMarginInPoints)
      : paperSize.widthInPoints;

  /// Vertical space available for bracket content after applying margins.
  double get printableAreaHeight => includePrinterMargins
      ? paperSize.heightInPoints - (2 * printerMarginInPoints)
      : paperSize.heightInPoints;
}

/// A simple dialog that collects export settings before generating the
/// single-page bracket PDF.
///
/// Presents:
/// 1. A toggle for including standard 15 mm printer-safe margins.
/// 2. A segmented selector for A4 or A3 paper size.
/// 3. An "Export PDF" action button.
///
/// Returns a [BracketExportSettings] on confirmation, or `null` on cancel.
class BracketExportSettingsDialog extends StatefulWidget {
  const BracketExportSettingsDialog({super.key});

  /// Convenience method to show the dialog and return the selected settings.
  static Future<BracketExportSettings?> show(BuildContext context) {
    return showDialog<BracketExportSettings>(
      context: context,
      builder: (_) => const BracketExportSettingsDialog(),
    );
  }

  @override
  State<BracketExportSettingsDialog> createState() =>
      _BracketExportSettingsDialogState();
}

class _BracketExportSettingsDialogState
    extends State<BracketExportSettingsDialog> {
  ExportPaperSize _selectedPaperSize = ExportPaperSize.a4;
  bool _includePrinterMargins = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Export Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile.adaptive(
            title: const Text('Printer Margins'),
            subtitle: const Text('Adds 15 mm safe area on each edge'),
            value: _includePrinterMargins,
            onChanged: (value) =>
                setState(() => _includePrinterMargins = value),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 20),
          Text(
            'Paper Size',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          SegmentedButton<ExportPaperSize>(
            segments: ExportPaperSize.values
                .map(
                  (size) => ButtonSegment<ExportPaperSize>(
                    value: size,
                    label: Text(size.shortLabel),
                    tooltip: size.displayLabel,
                  ),
                )
                .toList(),
            selected: {_selectedPaperSize},
            onSelectionChanged: (selection) =>
                setState(() => _selectedPaperSize = selection.first),
            showSelectedIcon: false,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(
            context,
            BracketExportSettings(
              paperSize: _selectedPaperSize,
              includePrinterMargins: _includePrinterMargins,
            ),
          ),
          icon: const Icon(Icons.picture_as_pdf, size: 18),
          label: const Text('Export PDF'),
        ),
      ],
    );
  }
}

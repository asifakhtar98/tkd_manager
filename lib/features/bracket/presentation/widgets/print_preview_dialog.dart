import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tkd_saas/features/bracket/presentation/models/print_export_settings.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart';

/// A full-screen dialog that provides a print preview with configurable
/// settings (paper size, orientation, fit mode, scale, tile overlap).
///
/// The right panel renders a live bracket miniature via [TieSheetPainter]
/// with an overlay grid showing how pages will tile across the bracket.
///
/// Returns the confirmed [PrintExportSettings] if the user proceeds, or
/// `null` if cancelled.
class PrintPreviewDialog extends StatefulWidget {
  const PrintPreviewDialog({
    required this.painter,
    required this.canvasSize,
    super.key,
  });

  /// The painter that renders the bracket — used for the live preview.
  final TieSheetPainter painter;

  /// The logical canvas size of the bracket.
  final Size canvasSize;

  /// Shows the dialog and returns the confirmed settings, or null if cancelled.
  static Future<PrintExportSettings?> show({
    required BuildContext context,
    required TieSheetPainter painter,
    required Size canvasSize,
  }) {
    return showDialog<PrintExportSettings>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          PrintPreviewDialog(painter: painter, canvasSize: canvasSize),
    );
  }

  @override
  State<PrintPreviewDialog> createState() => _PrintPreviewDialogState();
}

class _PrintPreviewDialogState extends State<PrintPreviewDialog> {
  PrintExportSettings _settings = const PrintExportSettings();

  int get _totalPages => _settings.totalPageCount(
    canvasWidth: widget.canvasSize.width,
    canvasHeight: widget.canvasSize.height,
  );

  bool get _isTileMode => _settings.fitMode == PrintFitMode.tileAcrossPages;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: colorScheme.onPrimary.withAlpha(180),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              Icon(
                Icons.print,
                color: colorScheme.onPrimary.withAlpha(180),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'PRINT PREVIEW',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                backgroundColor: colorScheme.surfaceContainerHighest,
                side: BorderSide.none,
                label: Text(
                  '$_totalPages ${_totalPages == 1 ? 'page' : 'pages'}',
                  style: TextStyle(
                    color: colorScheme.onSurface.withAlpha(180),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                avatar: Icon(
                  Icons.description_outlined,
                  color: colorScheme.onSurface.withAlpha(140),
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
            const SizedBox(width: 4),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(_settings),
              icon: const Icon(Icons.print, size: 18),
              label: const Text('Export PDF'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.onPrimary,
                foregroundColor: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Row(
          children: [
            // ── Settings Sidebar ──
            _buildSettingsSidebar(theme),
            // ── Vertical divider ──
            VerticalDivider(width: 1, thickness: 1, color: theme.dividerColor),
            // ── Preview Area ──
            Expanded(child: _buildPreviewArea(colorScheme)),
          ],
        ),
      ),
    );
  }

  // ── Settings Sidebar ────────────────────────────────────────────────────

  Widget _buildSettingsSidebar(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Container(
      width: 300,
      color: colorScheme.surfaceContainerLow,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSidebarHeader('Print Settings', colorScheme),
          const SizedBox(height: 24),

          // Paper Size
          _buildSettingLabel(Icons.crop_portrait, 'Paper Size', colorScheme),
          const SizedBox(height: 8),
          _buildPaperSizeDropdown(colorScheme),
          const SizedBox(height: 20),

          // Orientation
          _buildSettingLabel(Icons.screen_rotation, 'Orientation', colorScheme),
          const SizedBox(height: 8),
          _buildOrientationToggle(colorScheme),
          const SizedBox(height: 20),

          // Fit Mode
          _buildSettingLabel(Icons.dashboard, 'Fit Mode', colorScheme),
          const SizedBox(height: 8),
          _buildFitModeSelector(colorScheme),
          const SizedBox(height: 20),

          // Scale (tile mode only)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _isTileMode
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSettingLabel(
                  Icons.auto_fix_high,
                  'Page Target',
                  colorScheme,
                ),
                const SizedBox(height: 8),
                _buildPageTargetPresets(colorScheme),
                const SizedBox(height: 20),
                _buildSettingLabel(Icons.zoom_in, 'Scale', colorScheme),
                const SizedBox(height: 8),
                _buildScaleSlider(colorScheme),
                const SizedBox(height: 20),
                _buildSettingLabel(
                  Icons.space_bar,
                  'Tile Overlap',
                  colorScheme,
                ),
                const SizedBox(height: 8),
                _buildOverlapSlider(colorScheme),
                const SizedBox(height: 16),
                _buildAssemblyHintsToggle(colorScheme),
                const SizedBox(height: 20),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),

          // Resolution Quality
          _buildSettingLabel(
            Icons.high_quality,
            'Resolution Quality',
            colorScheme,
          ),
          const SizedBox(height: 8),
          _buildResolutionQualityToggle(colorScheme),
          const SizedBox(height: 20),

          // Page grid info
          _buildPageGridInfo(colorScheme),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader(String text, ColorScheme colorScheme) {
    return Text(
      text,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSettingLabel(
    IconData icon,
    String label,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.onSurface.withAlpha(140), size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface.withAlpha(180),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPaperSizeDropdown(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<PaperSize>(
        initialValue: _settings.paperSize,
        dropdownColor: colorScheme.surfaceContainerHighest,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: InputBorder.none,
        ),
        style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
        items: PaperSize.values
            .map(
              (size) => DropdownMenuItem(value: size, child: Text(size.label)),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _settings = _settings.copyWith(paperSize: value));
          }
        },
      ),
    );
  }

  Widget _buildOrientationToggle(ColorScheme colorScheme) {
    return Row(
      children: [
        for (final orientation in PageOrientation.values)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: orientation == PageOrientation.portrait ? 4 : 0,
                left: orientation == PageOrientation.landscape ? 4 : 0,
              ),
              child: _ToggleChip(
                label: orientation.label,
                icon: orientation == PageOrientation.portrait
                    ? Icons.crop_portrait
                    : Icons.crop_landscape,
                isSelected: _settings.orientation == orientation,
                colorScheme: colorScheme,
                onTap: () => setState(
                  () =>
                      _settings = _settings.copyWith(orientation: orientation),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFitModeSelector(ColorScheme colorScheme) {
    return Row(
      children: [
        for (final mode in PrintFitMode.values)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: mode == PrintFitMode.fitToPage ? 4 : 0,
                left: mode == PrintFitMode.tileAcrossPages ? 4 : 0,
              ),
              child: _ToggleChip(
                label: mode == PrintFitMode.fitToPage ? 'Single' : 'Tiled',
                icon: mode == PrintFitMode.fitToPage
                    ? Icons.fullscreen
                    : Icons.grid_view,
                isSelected: _settings.fitMode == mode,
                colorScheme: colorScheme,
                onTap: () => setState(
                  () => _settings = _settings.copyWith(fitMode: mode),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResolutionQualityToggle(ColorScheme colorScheme) {
    return Row(
      children: [
        for (final quality in PrintResolutionQuality.values)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: quality == PrintResolutionQuality.standard ? 4 : 0,
                left: quality == PrintResolutionQuality.high ? 4 : 0,
              ),
              child: _ToggleChip(
                label: quality.label,
                icon: quality == PrintResolutionQuality.standard
                    ? Icons.sd
                    : Icons.hd,
                isSelected: _settings.resolutionQuality == quality,
                colorScheme: colorScheme,
                onTap: () => setState(
                  () => _settings =
                      _settings.copyWith(resolutionQuality: quality),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPageTargetPresets(ColorScheme colorScheme) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final targetPageCount in PrintExportSettings.pageTargetPresets)
          _PageTargetChip(
            targetPageCount: targetPageCount,
            currentPageCount: _totalPages,
            colorScheme: colorScheme,
            onTap: () {
              final computedScaleFactor =
                  _settings.computeScaleFactorForTargetPageCount(
                    canvasWidth: widget.canvasSize.width,
                    canvasHeight: widget.canvasSize.height,
                    targetPageCount: targetPageCount,
                  );
              setState(
                () => _settings =
                    _settings.copyWith(scaleFactor: computedScaleFactor),
              );
            },
          ),
      ],
    );
  }

  Widget _buildAssemblyHintsToggle(ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(
          Icons.grid_goldenratio,
          color: colorScheme.onSurface.withAlpha(140),
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Assembly Hints',
            style: TextStyle(
              color: colorScheme.onSurface.withAlpha(180),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: 28,
          child: Switch.adaptive(
            value: _settings.showTileAssemblyHints,
            onChanged: (value) => setState(
              () => _settings =
                  _settings.copyWith(showTileAssemblyHints: value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScaleSlider(ColorScheme colorScheme) {
    return _buildLabeledSlider(
      colorScheme: colorScheme,
      minLabel: '${(PrintExportSettings.minScaleFactor * 100).round()}%',
      maxLabel: '${(PrintExportSettings.maxScaleFactor * 100).round()}%',
      currentLabel: '${(_settings.scaleFactor * 100).round()}%',
      value: _settings.scaleFactor.clamp(
        PrintExportSettings.minScaleFactor,
        PrintExportSettings.maxScaleFactor,
      ),
      min: PrintExportSettings.minScaleFactor,
      max: PrintExportSettings.maxScaleFactor,
      divisions: 38,
      onChanged: (value) =>
          setState(() => _settings = _settings.copyWith(scaleFactor: value)),
    );
  }

  Widget _buildOverlapSlider(ColorScheme colorScheme) {
    return _buildLabeledSlider(
      colorScheme: colorScheme,
      minLabel: '0mm',
      maxLabel: '30mm',
      currentLabel: '${_settings.tileOverlapMillimeters.round()}mm',
      value: _settings.tileOverlapMillimeters,
      min: 0,
      max: 30,
      divisions: 30,
      onChanged: (value) => setState(
        () => _settings = _settings.copyWith(tileOverlapMillimeters: value),
      ),
    );
  }

  /// Shared helper for labeled sliders with min/max/current labels.
  Widget _buildLabeledSlider({
    required ColorScheme colorScheme,
    required String minLabel,
    required String maxLabel,
    required String currentLabel,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              minLabel,
              style: TextStyle(
                color: colorScheme.onSurface.withAlpha(100),
                fontSize: 11,
              ),
            ),
            Text(
              currentLabel,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              maxLabel,
              style: TextStyle(
                color: colorScheme.onSurface.withAlpha(100),
                fontSize: 11,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: Theme.of(context).sliderTheme,
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildPageGridInfo(ColorScheme colorScheme) {
    final grid = _settings.tileGridDimensions(
      canvasWidth: widget.canvasSize.width,
      canvasHeight: widget.canvasSize.height,
    );
    final printable = _settings.printableAreaPoints;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(
            'Canvas',
            '${widget.canvasSize.width.round()} × ${widget.canvasSize.height.round()} px',
            colorScheme,
          ),
          const SizedBox(height: 4),
          _infoRow(
            'Printable',
            '${printable.width.round()} × ${printable.height.round()} pt',
            colorScheme,
          ),
          const SizedBox(height: 4),
          _infoRow('Grid', '${grid.columns} × ${grid.rows}', colorScheme),
          const SizedBox(height: 4),
          _infoRow(
            'Total',
            '$_totalPages ${_totalPages == 1 ? 'page' : 'pages'}',
            colorScheme,
          ),
          const SizedBox(height: 4),
          _infoRow(
            'Resolution',
            '${_settings.resolutionQuality.label}'
            ' (${_settings.resolutionQuality.maxTextureDimension.round()} px)',
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface.withAlpha(140),
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ── Preview Area ────────────────────────────────────────────────────────

  Widget _buildPreviewArea(ColorScheme colorScheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: colorScheme.surfaceContainerLowest,
          alignment: Alignment.center,
          child: InteractiveViewer(
            constrained: false,
            boundaryMargin: const EdgeInsets.all(200),
            minScale: 0.1,
            maxScale: 3.0,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: _BracketPreviewWithTileGrid(
                painter: widget.painter,
                canvasSize: widget.canvasSize,
                settings: _settings,
                maxPreviewWidth: constraints.maxWidth - 80,
                maxPreviewHeight: constraints.maxHeight - 80,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Toggle Chip ───────────────────────────────────────────────────────────

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.colorScheme,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? colorScheme.primary.withAlpha(20)
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(140),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withAlpha(140),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bracket Preview with Tile Grid Overlay ────────────────────────────────

class _BracketPreviewWithTileGrid extends StatelessWidget {
  const _BracketPreviewWithTileGrid({
    required this.painter,
    required this.canvasSize,
    required this.settings,
    required this.maxPreviewWidth,
    required this.maxPreviewHeight,
  });

  final TieSheetPainter painter;
  final Size canvasSize;
  final PrintExportSettings settings;
  final double maxPreviewWidth;
  final double maxPreviewHeight;

  @override
  Widget build(BuildContext context) {
    // Scale the preview down to fit within the available space.
    final double previewScale = min(
      maxPreviewWidth / canvasSize.width,
      maxPreviewHeight / canvasSize.height,
    ).clamp(0.05, 1.0);

    final double previewWidth = canvasSize.width * previewScale;
    final double previewHeight = canvasSize.height * previewScale;

    return SizedBox(
      width: previewWidth,
      height: previewHeight,
      child: Stack(
        children: [
          // The bracket miniature.
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CustomPaint(
                size: Size(previewWidth, previewHeight),
                painter: _ScaledBracketPreviewPainter(
                  painter: painter,
                  canvasSize: canvasSize,
                ),
              ),
            ),
          ),
          // Tile grid overlay.
          Positioned.fill(
            child: CustomPaint(
              painter: _TileGridOverlayPainter(
                canvasSize: canvasSize,
                settings: settings,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints the bracket at a scaled size for the preview.
class _ScaledBracketPreviewPainter extends CustomPainter {
  _ScaledBracketPreviewPainter({
    required this.painter,
    required this.canvasSize,
  });

  final TieSheetPainter painter;
  final Size canvasSize;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / canvasSize.width;
    final scaleY = size.height / canvasSize.height;
    final scale = min(scaleX, scaleY);

    canvas.save();
    canvas.scale(scale);
    painter.paint(canvas, canvasSize);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScaledBracketPreviewPainter oldDelegate) =>
      !identical(painter, oldDelegate.painter) ||
      canvasSize != oldDelegate.canvasSize;
}

/// Paints a semi-transparent grid overlay showing page tile boundaries
/// and page numbers.
class _TileGridOverlayPainter extends CustomPainter {
  _TileGridOverlayPainter({required this.canvasSize, required this.settings});

  final Size canvasSize;
  final PrintExportSettings settings;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = settings.tileGridDimensions(
      canvasWidth: canvasSize.width,
      canvasHeight: canvasSize.height,
    );

    if (grid.columns <= 1 && grid.rows <= 1) {
      // Single page — draw a subtle border around the entire preview.
      final borderPaint = Paint()
        ..color = Colors.tealAccent.withAlpha(100)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(Offset.zero & size, borderPaint);
      _drawPageLabel(
        canvas,
        size,
        '1 page',
        Offset(size.width / 2, size.height / 2),
      );
      return;
    }

    // Calculate tile dimensions in preview-space.
    final tileCoverage = settings.tileCanvasCoverage();
    final overlapCanvas = settings.tileOverlapCanvasPixels;
    final effectiveStepWidth = tileCoverage.width - overlapCanvas;
    final effectiveStepHeight = tileCoverage.height - overlapCanvas;

    final scaleToPreviewX = size.width / canvasSize.width;
    final scaleToPreviewY = size.height / canvasSize.height;

    final gridPaint = Paint()
      ..color = Colors.tealAccent.withAlpha(80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final fillPaint = Paint()..color = Colors.tealAccent.withAlpha(15);

    int pageNum = 0;
    for (int row = 0; row < grid.rows; row++) {
      for (int col = 0; col < grid.columns; col++) {
        pageNum++;

        final canvasX = col * effectiveStepWidth;
        final canvasY = row * effectiveStepHeight;
        final canvasW = min(tileCoverage.width, canvasSize.width - canvasX);
        final canvasH = min(tileCoverage.height, canvasSize.height - canvasY);

        final rect = Rect.fromLTWH(
          canvasX * scaleToPreviewX,
          canvasY * scaleToPreviewY,
          canvasW * scaleToPreviewX,
          canvasH * scaleToPreviewY,
        );

        // Alternating fill for visual distinction.
        if ((row + col) % 2 == 0) {
          canvas.drawRect(rect, fillPaint);
        }
        canvas.drawRect(rect, gridPaint);

        // Page label.
        _drawPageLabel(canvas, size, 'Page $pageNum', rect.center);
      }
    }
  }

  void _drawPageLabel(Canvas canvas, Size size, String text, Offset center) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.tealAccent.withAlpha(180),
          fontSize: (min(size.width, size.height) * 0.04).clamp(10.0, 18.0),
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Background pill.
    final pillRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: textPainter.width + 16,
        height: textPainter.height + 8,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(pillRect, Paint()..color = const Color(0xCC1E1E2E));

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _TileGridOverlayPainter oldDelegate) =>
      settings != oldDelegate.settings;
}

// ── Page Target Chip ──────────────────────────────────────────────────────

/// A compact chip that auto-computes the optimal scale to fit a bracket
/// within a target page count. Highlights when the current layout already
/// matches or beats the target.
class _PageTargetChip extends StatelessWidget {
  const _PageTargetChip({
    required this.targetPageCount,
    required this.currentPageCount,
    required this.colorScheme,
    required this.onTap,
  });

  final int targetPageCount;
  final int currentPageCount;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  bool get _isActive => currentPageCount <= targetPageCount;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        _isActive ? colorScheme.primary : Colors.transparent;
    final backgroundColor = _isActive
        ? colorScheme.primary.withAlpha(20)
        : colorScheme.surfaceContainerHighest;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              '≤$targetPageCount',
              style: TextStyle(
                color: _isActive
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(140),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' show Color, FontStyle, FontWeight, Offset, Rect, Size;

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tkd_saas/features/bracket/data/services/pdf_color_converter.dart';

import 'package:tkd_saas/features/bracket/domain/layout/models/connector_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/header_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/match_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/medal_table_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/participant_row_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/section_label_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/tie_sheet_layout_result.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';


/// Groups the common parameters shared across all PDF generation methods
/// on [TieSheetSyncfusionPdfRendererService].
///
/// Eliminates the need to pass [layoutResult], [themeConfig], and optional
/// logo bytes separately to every public renderer method.
class PdfRenderParams {
  const PdfRenderParams({
    required this.layoutResult,
    required this.themeConfig,
    this.leftLogoImageBytes,
    this.rightLogoImageBytes,
  });

  /// The computed layout geometry to render.
  final TieSheetLayoutResult layoutResult;

  /// The theme tokens controlling colours, strokes, and typography.
  final TieSheetThemeConfig themeConfig;

  /// Raw bytes for the left tournament logo image (PNG/JPEG).
  /// `null` when no left logo is configured.
  final Uint8List? leftLogoImageBytes;

  /// Raw bytes for the right tournament logo image (PNG/JPEG).
  /// `null` when no right logo is configured.
  final Uint8List? rightLogoImageBytes;
}

/// Renders a [TieSheetLayoutResult] onto Syncfusion [PdfDocument] pages
/// as vector graphics, producing identical output for both on-screen
/// preview (via [SfPdfViewer.memory]) and print/export.
///
/// All drawing uses [PdfGraphics] vector APIs — no rasterization.
/// Shadow rendering has been intentionally removed for a clean, flat
/// vector aesthetic that reproduces crisply at any DPI.
///
/// ## Architecture
///
/// The renderer consumes a [TieSheetLayoutResult] (computed by
/// [TieSheetLayoutEngine]) and a [PdfRenderParams] bundle. Three public
/// entry points produce different PDF shapes:
///
/// - [renderSinglePagePdfBytes] — 1:1 canvas-sized page (screen preview).
/// - [generateScaledSinglePagePdfBytes] — scaled to fit A4/Letter.
///
/// All three delegate to the private [_renderFullBracket] helper for the
/// actual drawing, eliminating pipeline duplication.
class TieSheetSyncfusionPdfRendererService {
  List<int> renderSinglePagePdfBytes({required PdfRenderParams params}) {
    final document = PdfDocument();
    final canvasWidth = params.layoutResult.computedCanvasSize.width;
    final canvasHeight = params.layoutResult.computedCanvasSize.height;

    document.pageSettings.orientation = canvasWidth > canvasHeight
        ? PdfPageOrientation.landscape
        : PdfPageOrientation.portrait;

    document.pageSettings.size = Size(canvasWidth, canvasHeight);
    document.pageSettings.margins.all = 0;

    final page = document.pages.add();
    _renderFullBracket(page.graphics, params);

    final bytes = document.saveSync();
    document.dispose();
    return bytes;
  }


  /// Generates a single-page PDF document scaled to fit a specific page dimension,
  /// preserving aspect ratio. Ideal for printing the entire bracket on an A4/Letter page.
  ///
  /// The [fullPageWidth] and [fullPageHeight] define the actual PDF page size
  /// (e.g., A4 portrait). The [printableAreaWidth] and [printableAreaHeight]
  /// define the safe drawing area within those margins. The bracket is scaled
  /// to fit the printable area and centered on the full page.
  ///
  /// When [autoRotateWideContent] is `true` and the bracket canvas is wider
  /// than tall, the content is rotated 90° clockwise on the portrait page so
  /// that the long axis of the bracket runs along the long edge of the paper.
  /// The page itself stays portrait — only the drawn content is rotated.
  List<int> generateScaledSinglePagePdfBytes({
    required PdfRenderParams params,
    required double fullPageWidth,
    required double fullPageHeight,
    required double printableAreaWidth,
    required double printableAreaHeight,
    bool autoRotateWideContent = false,
  }) {
    final canvasWidth = params.layoutResult.computedCanvasSize.width;
    final canvasHeight = params.layoutResult.computedCanvasSize.height;

    final bool shouldRotateContent =
        autoRotateWideContent && canvasWidth > canvasHeight;

    final document = PdfDocument();
    document.pageSettings.orientation = PdfPageOrientation.portrait;
    document.pageSettings.size = Size(fullPageWidth, fullPageHeight);
    document.pageSettings.margins.all = 0;

    final page = document.pages.add();
    final graphics = page.graphics;

    final bracketTemplate = PdfTemplate(canvasWidth, canvasHeight);
    _renderFullBracket(bracketTemplate.graphics!, params);

    if (shouldRotateContent) {
      // Rotate content 90° clockwise on the portrait page.
      // After rotation the available drawing space is swapped:
      //   effective width  = pageHeight  (long edge)
      //   effective height = pageWidth   (short edge)
      final double effectiveAvailableWidth = printableAreaHeight;
      final double effectiveAvailableHeight = printableAreaWidth;

      final scaleX = effectiveAvailableWidth / canvasWidth;
      final scaleY = effectiveAvailableHeight / canvasHeight;
      final scaleToFit = min(scaleX, scaleY);

      final scaledWidth = canvasWidth * scaleToFit;
      final scaledHeight = canvasHeight * scaleToFit;

      // Center within the rotated coordinate system.
      final offsetX = (effectiveAvailableWidth - scaledWidth) / 2;
      final offsetY = (effectiveAvailableHeight - scaledHeight) / 2;

      // Apply transforms: translate origin to top-right corner of the page,
      // then rotate 90° clockwise. In the rotated coordinate system,
      // +X runs down the page and +Y runs leftward from the right edge.
      final graphicsState = graphics.save();
      graphics.translateTransform(fullPageWidth, 0);
      graphics.rotateTransform(90);

      graphics.drawPdfTemplate(
        bracketTemplate,
        Offset(offsetX, offsetY),
        Size(scaledWidth, scaledHeight),
      );

      graphics.restore(graphicsState);
    } else {
      // Standard (no rotation) — scale to fit and center.
      final scaleX = printableAreaWidth / canvasWidth;
      final scaleY = printableAreaHeight / canvasHeight;
      final scaleToFit = min(scaleX, scaleY);

      final scaledWidth = canvasWidth * scaleToFit;
      final scaledHeight = canvasHeight * scaleToFit;

      final offsetX = (fullPageWidth - scaledWidth) / 2;
      final offsetY = (fullPageHeight - scaledHeight) / 2;

      graphics.drawPdfTemplate(
        bracketTemplate,
        Offset(offsetX, offsetY),
        Size(scaledWidth, scaledHeight),
      );
    }

    final bytes = document.saveSync();
    document.dispose();
    return bytes;
  }

  void _renderFullBracket(PdfGraphics graphics, PdfRenderParams params) {
    final layoutResult = params.layoutResult;
    final themeConfig = params.themeConfig;

    _renderCanvasBackground(graphics, layoutResult, themeConfig);
    _renderHeader(
      graphics,
      layoutResult.headerLayoutData,
      themeConfig,
      leftLogoImageBytes: params.leftLogoImageBytes,
      rightLogoImageBytes: params.rightLogoImageBytes,
    );
    _renderSectionLabels(
      graphics,
      layoutResult.sectionLabelLayoutDataList,
      themeConfig,
    );
    _renderParticipantRows(
      graphics,
      layoutResult.participantRowLayoutDataList,
      themeConfig,
    );
    _renderConnectors(
      graphics,
      layoutResult.connectorLayoutDataList,
      themeConfig,
    );
    _renderMatchJunctions(
      graphics,
      layoutResult.matchLayoutDataList,
      themeConfig,
    );
    if (layoutResult.medalTableLayoutData != null) {
      _renderMedalTable(
        graphics,
        layoutResult.medalTableLayoutData!,
        themeConfig,
      );
    }
  }

  void _renderCanvasBackground(
    PdfGraphics graphics,
    TieSheetLayoutResult layoutResult,
    TieSheetThemeConfig themeConfig,
  ) {
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(
        0,
        0,
        layoutResult.computedCanvasSize.width,
        layoutResult.computedCanvasSize.height,
      ),
      brush: PdfSolidBrush(themeConfig.canvasBackgroundColor.toPdfColor()),
    );
  }

  void _renderHeader(
    PdfGraphics graphics,
    HeaderLayoutData headerData,
    TieSheetThemeConfig themeConfig, {
    Uint8List? leftLogoImageBytes,
    Uint8List? rightLogoImageBytes,
  }) {
    _renderLogoImage(
      graphics,
      headerData.leftLogoBoundingRect,
      leftLogoImageBytes,
    );
    _renderLogoImage(
      graphics,
      headerData.rightLogoBoundingRect,
      rightLogoImageBytes,
    );

    graphics.drawRectangle(
      bounds: headerData.headerBannerBoundingRect,
      brush: PdfSolidBrush(
        themeConfig.headerBannerBackgroundColor.toPdfColor(),
      ),
      pen: PdfPen(
        themeConfig.borderColor.toPdfColor(),
        width: themeConfig.borderStrokeWidth,
      ),
    );

    _drawPositionedText(
      graphics,
      headerData.tournamentTitleTextLayout,
      themeConfig,
    );
    if (headerData.tournamentSubtitleTextLayout != null) {
      _drawPositionedText(
        graphics,
        headerData.tournamentSubtitleTextLayout!,
        themeConfig,
      );
    }
    if (headerData.tournamentOrganizerTextLayout != null) {
      _drawPositionedText(
        graphics,
        headerData.tournamentOrganizerTextLayout!,
        themeConfig,
      );
    }

    graphics.drawRectangle(
      bounds: headerData.classificationInfoRowBoundingRect,
      brush: PdfSolidBrush(themeConfig.headerFillColor.toPdfColor()),
      pen: PdfPen(
        themeConfig.borderColor.toPdfColor(),
        width: themeConfig.borderStrokeWidth,
      ),
    );

    for (final divider in headerData.classificationInfoRowDividerLines) {
      graphics.drawLine(
        PdfPen(
          themeConfig.borderColor.toPdfColor(),
          width: themeConfig.subtleStrokeWidth,
        ),
        Offset(divider.startOffset.dx, divider.startOffset.dy),
        Offset(divider.endOffset.dx, divider.endOffset.dy),
      );
    }
    for (final cellText in headerData.classificationCellTextLayoutList) {
      _drawPositionedText(graphics, cellText, themeConfig);
    }
  }

  /// Draws a logo image into the specified bounding rectangle.
  ///
  /// Silently no-ops when either the bounding rect or image bytes are null
  /// (tournament has no logo configured, or the image failed to load).
  void _renderLogoImage(
    PdfGraphics graphics,
    Rect? boundingRect,
    Uint8List? imageBytes,
  ) {
    if (boundingRect == null || imageBytes == null) return;
    try {
      final pdfBitmap = PdfBitmap(imageBytes);
      graphics.drawImage(pdfBitmap, boundingRect);
    } catch (_) {
      // Silently skip — a missing logo should never crash PDF generation.
    }
  }

  void _renderSectionLabels(
    PdfGraphics graphics,
    List<SectionLabelLayoutData> labels,
    TieSheetThemeConfig themeConfig,
  ) {
    for (final label in labels) {
      final labelColor =
          label.sectionLabelType == SectionLabelType.winnersBracket
          ? themeConfig.winnersLabelColor
          : themeConfig.losersLabelColor;
      graphics.drawRectangle(
        bounds: label.boundingRect,
        brush: PdfSolidBrush(
          labelColor
              .withValues(alpha: themeConfig.sectionLabelBackgroundOpacity)
              .toPdfColor(),
        ),
        pen: PdfPen(
          labelColor.toPdfColor(),
          width: themeConfig.borderStrokeWidth,
        ),
      );
      _drawPositionedText(
        graphics,
        label.labelTextLayout,
        themeConfig,
        overrideColor: labelColor,
      );
    }
  }

  void _renderParticipantRows(
    PdfGraphics graphics,
    List<ParticipantRowLayoutData> rows,
    TieSheetThemeConfig themeConfig,
  ) {
    for (final row in rows) {
      final fillColor = row.isPlaceholderRow
          ? themeConfig.tbdFillColor
          : themeConfig.rowFillColor;
      graphics.drawRectangle(
        bounds: row.cardBoundingRect,
        brush: PdfSolidBrush(fillColor.toPdfColor()),
        pen: PdfPen(
          themeConfig.borderColor.toPdfColor(),
          width: themeConfig.subtleStrokeWidth,
        ),
      );
      graphics.drawRectangle(
        bounds: row.accentStripBoundingRect,
        brush: PdfSolidBrush(
          themeConfig.participantAccentStripColor.toPdfColor(),
        ),
      );
      for (final divider in row.columnDividerLines) {
        graphics.drawLine(
          PdfPen(
            themeConfig.borderColor.toPdfColor(),
            width: themeConfig.subtleStrokeWidth,
          ),
          Offset(divider.startOffset.dx, divider.startOffset.dy),
          Offset(divider.endOffset.dx, divider.endOffset.dy),
        );
      }
      _drawPositionedText(graphics, row.serialNumberTextLayout, themeConfig);
      _drawPositionedText(graphics, row.participantNameTextLayout, themeConfig);
      if (row.registrationIdTextLayout != null) {
        _drawPositionedText(
          graphics,
          row.registrationIdTextLayout!,
          themeConfig,
        );
      }
    }
  }

  void _renderConnectors(
    PdfGraphics graphics,
    List<ConnectorLayoutData> connectors,
    TieSheetThemeConfig themeConfig,
  ) {
    for (final connector in connectors) {
      final pen = _buildConnectorPen(
        connector.connectorVisualType,
        themeConfig,
      );
      for (final segment in connector.straightLineSegments) {
        graphics.drawLine(
          pen,
          Offset(segment.startOffset.dx, segment.startOffset.dy),
          Offset(segment.endOffset.dx, segment.endOffset.dy),
        );
      }
    }
  }

  PdfPen _buildConnectorPen(
    ConnectorVisualType visualType,
    TieSheetThemeConfig themeConfig,
  ) {
    final uniformStrokeWidth = themeConfig.connectorStrokeWidth;
    switch (visualType) {
      case ConnectorVisualType.wonAdvancement:
        return PdfPen(
          themeConfig.connectorWonColor.toPdfColor(),
          width: uniformStrokeWidth > 0
              ? uniformStrokeWidth
              : themeConfig.wonConnectorStrokeWidth,
        );
      case ConnectorVisualType.pendingAdvancement:
        return PdfPen(
          themeConfig.borderColor.toPdfColor(),
          width: uniformStrokeWidth > 0
              ? uniformStrokeWidth
              : themeConfig.borderStrokeWidth,
        );
      case ConnectorVisualType.byeAdvancement:
        final pen = PdfPen(
          themeConfig.mutedColor.toPdfColor(),
          width: uniformStrokeWidth > 0
              ? uniformStrokeWidth
              : themeConfig.subtleStrokeWidth,
        );
        pen.dashStyle = PdfDashStyle.dash;
        return pen;
      case ConnectorVisualType.genericTrunk:
        return PdfPen(
          themeConfig.mutedColor.toPdfColor(),
          width: uniformStrokeWidth > 0
              ? uniformStrokeWidth
              : themeConfig.borderStrokeWidth,
        );
      case ConnectorVisualType.grandFinalOutputArm:
        return PdfPen(
          themeConfig.connectorWonColor.toPdfColor(),
          width: uniformStrokeWidth > 0
              ? uniformStrokeWidth
              : themeConfig.wonConnectorStrokeWidth,
        );
      case ConnectorVisualType.thickBorder:
        return PdfPen(
          themeConfig.borderColor.toPdfColor(),
          width: uniformStrokeWidth > 0
              ? uniformStrokeWidth
              : themeConfig.wonConnectorStrokeWidth,
        );
    }
  }

  void _renderMatchJunctions(
    PdfGraphics graphics,
    List<MatchLayoutData> matches,
    TieSheetThemeConfig themeConfig,
  ) {
    for (final matchLayout in matches) {
      if (matchLayout.isByeMatch) continue;
      if (matchLayout.blueCornerBadgeLayout != null) {
        _drawCornerBadge(
          graphics,
          matchLayout.blueCornerBadgeLayout!,
          themeConfig,
        );
      }
      if (matchLayout.redCornerBadgeLayout != null) {
        _drawCornerBadge(
          graphics,
          matchLayout.redCornerBadgeLayout!,
          themeConfig,
        );
      }
      if (matchLayout.matchNumberPillLayout != null) {
        _drawMatchPill(
          graphics,
          matchLayout.matchNumberPillLayout!,
          themeConfig,
        );
      }
      if (matchLayout.winnerNameTextLayout != null) {
        _drawPositionedText(
          graphics,
          matchLayout.winnerNameTextLayout!,
          themeConfig,
        );
      }
      if (matchLayout.missingTopInputLabelLayout != null) {
        _drawPositionedText(
          graphics,
          matchLayout.missingTopInputLabelLayout!,
          themeConfig,
        );
      }
      if (matchLayout.missingBottomInputLabelLayout != null) {
        _drawPositionedText(
          graphics,
          matchLayout.missingBottomInputLabelLayout!,
          themeConfig,
        );
      }
      if (matchLayout.thirdPlaceTitleTextLayout != null) {
        _drawPositionedText(
          graphics,
          matchLayout.thirdPlaceTitleTextLayout!,
          themeConfig,
        );
      }
      if (matchLayout.grandFinalLabelTextLayout != null) {
        _drawPositionedText(
          graphics,
          matchLayout.grandFinalLabelTextLayout!,
          themeConfig,
        );
      }
    }
  }

  void _drawCornerBadge(
    PdfGraphics graphics,
    CornerBadgeLayoutData badgeData,
    TieSheetThemeConfig themeConfig,
  ) {
    final badgeColor = badgeData.badgeColorType == CornerBadgeColorType.blue
        ? themeConfig.blueCornerColor
        : themeConfig.redCornerColor;
    final centerX = badgeData.centerOffset.dx;
    final centerY = badgeData.centerOffset.dy;
    final badgeHalfSize = badgeData.computedBadgeHalfSize;
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(
        centerX - badgeHalfSize,
        centerY - badgeHalfSize,
        badgeHalfSize * 2,
        badgeHalfSize * 2,
      ),
      brush: PdfSolidBrush(badgeColor.toPdfColor()),
      pen: PdfPen(
        badgeColor
            .withValues(alpha: themeConfig.badgeOutlineOpacity)
            .toPdfColor(),
        width: themeConfig.subtleStrokeWidth,
      ),
    );
    final badgeFontSize = max(6.0, badgeData.computedBadgeHalfSize * 0.9);
    final badgeFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      badgeFontSize,
      style: PdfFontStyle.bold,
    );
    final badgeTextSize = badgeFont.measureString(badgeData.badgeText);

    graphics.drawString(
      badgeData.badgeText,
      badgeFont,
      bounds: Rect.fromLTWH(
        centerX - badgeTextSize.width / 2,
        centerY - badgeTextSize.height / 2,
        badgeTextSize.width,
        badgeTextSize.height,
      ),
      brush: PdfSolidBrush(themeConfig.badgeTextColor.toPdfColor()),
    );
  }

  void _drawMatchPill(
    PdfGraphics graphics,
    MatchNumberPillLayoutData pillData,
    TieSheetThemeConfig themeConfig,
  ) {
    graphics.drawRectangle(
      bounds: pillData.pillBoundingRect,
      brush: PdfSolidBrush(themeConfig.matchPillFillColor.toPdfColor()),
      pen: PdfPen(
        themeConfig.borderColor.toPdfColor(),
        width: themeConfig.subtleStrokeWidth,
      ),
    );
    final fontSizeDelta = themeConfig.fontSizeDelta;
    final pillFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      10 + fontSizeDelta,
      style: PdfFontStyle.bold,
    );
    final pillTextSize = pillFont.measureString(pillData.matchNumberText);
    graphics.drawString(
      pillData.matchNumberText,
      pillFont,
      bounds: Rect.fromLTWH(
        pillData.centerOffset.dx - pillTextSize.width / 2,
        pillData.centerOffset.dy - pillTextSize.height / 2,
        pillTextSize.width,
        pillTextSize.height,
      ),
      brush: PdfSolidBrush(themeConfig.primaryTextColor.toPdfColor()),
    );
  }

  void _renderMedalTable(
    PdfGraphics graphics,
    MedalTableLayoutData medalTableData,
    TieSheetThemeConfig themeConfig,
  ) {
    for (final medalRow in medalTableData.medalRowLayoutDataList) {
      Color fillColor, accentColor;
      switch (medalRow.medalType) {
        case MedalType.gold:
          fillColor = themeConfig.medalGoldFillColor;
          accentColor = themeConfig.medalGoldAccentColor;
        case MedalType.silver:
          fillColor = themeConfig.medalSilverFillColor;
          accentColor = themeConfig.medalSilverAccentColor;
        case MedalType.bronze:
          fillColor = themeConfig.medalBronzeFillColor;
          accentColor = themeConfig.medalBronzeAccentColor;
      }
      graphics.drawRectangle(
        bounds: medalRow.fullCardBoundingRect,
        brush: PdfSolidBrush(fillColor.toPdfColor()),
        pen: PdfPen(
          themeConfig.borderColor.toPdfColor(),
          width: themeConfig.subtleStrokeWidth,
        ),
      );
      graphics.drawRectangle(
        bounds: medalRow.accentStripBoundingRect,
        brush: PdfSolidBrush(accentColor.toPdfColor()),
      );
      final dividerLine = medalRow.columnDividerLine;
      graphics.drawLine(
        PdfPen(
          themeConfig.borderColor.toPdfColor(),
          width: themeConfig.subtleStrokeWidth,
        ),
        Offset(dividerLine.startOffset.dx, dividerLine.startOffset.dy),
        Offset(dividerLine.endOffset.dx, dividerLine.endOffset.dy),
      );
      _drawPositionedText(graphics, medalRow.medalLabelTextLayout, themeConfig);
      if (medalRow.winnerNameTextLayout != null) {
        _drawPositionedText(
          graphics,
          medalRow.winnerNameTextLayout!,
          themeConfig,
        );
      }
    }
  }

  void _drawPositionedText(
    PdfGraphics graphics,
    PositionedTextLayoutData textData,
    TieSheetThemeConfig themeConfig, {
    Color? overrideColor,
  }) {
    final resolvedTextColor =
        overrideColor ?? _resolveTextColor(textData.textColorType, themeConfig);

    // Determine the required font styles. PdfStandardFont supports combining
    // bold + italic via the `multiStyle` parameter — using the single `style`
    // parameter would silently drop one when both are needed.
    final isBold = textData.fontWeight.value >= FontWeight.w600.value;
    final isItalic = textData.fontStyle == FontStyle.italic;

    final PdfStandardFont font;
    if (isBold && isItalic) {
      font = PdfStandardFont(
        PdfFontFamily.helvetica,
        textData.fontSize,
        multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic],
      );
    } else if (isBold) {
      font = PdfStandardFont(
        PdfFontFamily.helvetica,
        textData.fontSize,
        style: PdfFontStyle.bold,
      );
    } else if (isItalic) {
      font = PdfStandardFont(
        PdfFontFamily.helvetica,
        textData.fontSize,
        style: PdfFontStyle.italic,
      );
    } else {
      font = PdfStandardFont(
        PdfFontFamily.helvetica,
        textData.fontSize,
      );
    }

    // PdfStandardFont (Helvetica) only supports Latin-1 characters.
    // Replace common Unicode symbols used in bracket labels with ASCII
    // equivalents to prevent rendering crashes.
    final sanitizedTextContent = _sanitizeTextForStandardFont(
      textData.textContent,
    );

    final measuredTextSize = font.measureString(sanitizedTextContent);
    double computedX = textData.renderPosition.dx;
    if (textData.isCenterAligned) {
      computedX -= measuredTextSize.width / 2;
    } else if (textData.isRightAligned) {
      computedX -= measuredTextSize.width;
    }
    graphics.drawString(
      sanitizedTextContent,
      font,
      bounds: Rect.fromLTWH(
        computedX,
        textData.renderPosition.dy,
        measuredTextSize.width + 4,
        measuredTextSize.height + 2,
      ),
      brush: PdfSolidBrush(resolvedTextColor.toPdfColor()),
    );
  }

  /// Replaces Unicode characters unsupported by [PdfStandardFont] with
  /// ASCII equivalents.
  ///
  /// PdfStandardFont uses the Helvetica/Times/Courier character set which
  /// is limited to Latin-1 (ISO 8859-1). Characters outside this range
  /// will throw [ArgumentError] during measureString/drawString.
  static String _sanitizeTextForStandardFont(String text) {
    return text.replaceAllMapped(
      RegExp(r'[^\x00-\xFF]'),
      (match) => _unicodeToAsciiReplacements[match.group(0)!] ?? '?',
    );
  }

  /// Mapping of commonly used Unicode characters in bracket labels to
  /// their ASCII visual equivalents.
  static const _unicodeToAsciiReplacements = <String, String>{
    '\u2713': 'v', // ✓ checkmark → v
    '\u2714': 'v', // ✔ heavy checkmark → v
    '\u2191': '^', // ↑ up arrow → ^
    '\u2193': 'v', // ↓ down arrow → v
    '\u2190': '<', // ← left arrow → <
    '\u2192': '>', // → right arrow → >
    '\u2022': '*', // • bullet → *
    '\u2013': '-', // – en dash → -
    '\u2014': '--', // — em dash → --
    '\u2018': "'", // ' left single quote → '
    '\u2019': "'", // ' right single quote → '
    '\u201C': '"', // " left double quote → "
    '\u201D': '"', // " right double quote → "
    '\u2026': '...', // … ellipsis → ...
  };

  Color _resolveTextColor(
    TextColorType colorType,
    TieSheetThemeConfig themeConfig,
  ) {
    switch (colorType) {
      case TextColorType.primary:
        return themeConfig.primaryTextColor;
      case TextColorType.secondary:
        return themeConfig.secondaryTextColor;
      case TextColorType.muted:
        return themeConfig.mutedColor;
      case TextColorType.headerBannerPrimary:
        return themeConfig.headerBannerTextColor;
      case TextColorType.headerBannerSecondary:
        return themeConfig.headerBannerTextColor.withValues(
          alpha: themeConfig.headerSecondaryTextOpacity,
        );
      case TextColorType.badgeText:
        return themeConfig.badgeTextColor;
      case TextColorType.blueCorner:
        return themeConfig.blueCornerColor;
      case TextColorType.redCorner:
        return themeConfig.redCornerColor;
      case TextColorType.sectionLabel:
        return const Color(0xFFFFFFFF);
      case TextColorType.medalGold:
        return themeConfig.medalGoldTextColor;
      case TextColorType.medalSilver:
        return themeConfig.medalSilverTextColor;
      case TextColorType.medalBronze:
        return themeConfig.medalBronzeTextColor;
    }
  }
}

import 'dart:typed_data';

import 'package:tkd_saas/features/bracket/data/services/bracket_medal_computation_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/tie_sheet_syncfusion_pdf_renderer_service.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_medal_placement_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/services/bracket_medal_computation_service.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/tie_sheet_layout_result.dart';
import 'package:tkd_saas/features/bracket/domain/layout/tie_sheet_layout_engine.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';
import 'package:tkd_saas/features/bracket/presentation/models/print_export_settings.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_classification.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';

/// Immutable result of a PDF generation cycle.
///
/// Contains both the rendered [pdfBytes] and the underlying [layoutResult]
/// so callers can reuse the layout for export operations without
/// recomputation.
class BracketPdfGenerationResult {
  const BracketPdfGenerationResult({
    required this.pdfBytes,
    required this.layoutResult,
  });

  /// The rendered PDF bytes, ready for display via `SfPdfViewer.memory`.
  final Uint8List pdfBytes;

  /// The computed layout geometry used to produce the PDF.
  ///
  /// Can be reused for export operations (single-page, tiled) to avoid
  /// redundant layout computation.
  final TieSheetLayoutResult layoutResult;
}

/// Orchestrates the layout → render → cache pipeline for bracket PDFs.
///
/// This coordinator owns the [TieSheetLayoutEngine] and
/// [TieSheetSyncfusionPdfRendererService], managing the full lifecycle from
/// raw domain data to rendered PDF bytes.
///
/// ## Usage
///
/// ```dart
/// final coordinator = BracketPdfCoordinator();
/// final result = coordinator.generatePreviewPdf(
///   tournament: tournament,
///   matches: matches,
///   participants: participants,
///   // ...
/// );
/// // result.pdfBytes  → SfPdfViewer.memory
/// // result.layoutResult → reuse for export
/// ```
///
/// The coordinator also caches the most recent result, exposing
/// [cachedLayoutResult] and [cachedPdfBytes] for immediate reuse by
/// export operations.
class BracketPdfCoordinator {
  BracketPdfCoordinator({
    TieSheetLayoutEngine? layoutEngine,
    TieSheetSyncfusionPdfRendererService? rendererService,
    BracketMedalComputationService? medalComputationService,
  }) : _layoutEngine = layoutEngine ??
           TieSheetLayoutEngine(
             medalComputationService ??
                 const BracketMedalComputationServiceImplementation(),
           ),
       _rendererService =
           rendererService ?? TieSheetSyncfusionPdfRendererService();

  final TieSheetLayoutEngine _layoutEngine;
  final TieSheetSyncfusionPdfRendererService _rendererService;

  /// Most recently generated layout result — `null` before the first
  /// generation or after [clearCache].
  TieSheetLayoutResult? get cachedLayoutResult => _cachedLayoutResult;
  TieSheetLayoutResult? _cachedLayoutResult;

  /// Most recently generated PDF bytes — `null` before the first
  /// generation or after [clearCache].
  Uint8List? get cachedPdfBytes => _cachedPdfBytes;
  Uint8List? _cachedPdfBytes;

  /// Computes the bracket layout and renders a single-page preview PDF.
  ///
  /// This is the primary entry point for on-screen display. Caches both
  /// the layout result and PDF bytes for reuse by export operations.
  BracketPdfGenerationResult generatePreviewPdf({
    required TournamentEntity tournament,
    required List<MatchEntity> matches,
    required List<ParticipantEntity> participants,
    required String bracketType,
    required bool includeThirdPlaceMatch,
    required TieSheetThemeConfig themeConfig,
    required BracketClassification classification,
    String? winnersBracketId,
    String? losersBracketId,
    List<BracketMedalPlacementEntity>? finalMedalPlacements,
    Uint8List? leftLogoImageBytes,
    Uint8List? rightLogoImageBytes,
    double leftLogoAspectRatio = 1.0,
    double rightLogoAspectRatio = 1.0,
  }) {
    final layoutResult = _layoutEngine.computeLayout(
      tournament: tournament,
      matches: matches,
      participants: participants,
      bracketType: bracketType,
      includeThirdPlaceMatch: includeThirdPlaceMatch,
      themeConfig: themeConfig,
      classification: classification,
      winnersBracketId: winnersBracketId,
      losersBracketId: losersBracketId,
      finalMedalPlacements: finalMedalPlacements,
      hasLeftLogo: leftLogoImageBytes != null,
      hasRightLogo: rightLogoImageBytes != null,
      leftLogoAspectRatio: leftLogoAspectRatio,
      rightLogoAspectRatio: rightLogoAspectRatio,
    );

    final params = PdfRenderParams(
      layoutResult: layoutResult,
      themeConfig: themeConfig,
      leftLogoImageBytes: leftLogoImageBytes,
      rightLogoImageBytes: rightLogoImageBytes,
    );

    final pdfBytes = Uint8List.fromList(
      _rendererService.renderSinglePagePdfBytes(params: params),
    );

    _cachedLayoutResult = layoutResult;
    _cachedPdfBytes = pdfBytes;

    return BracketPdfGenerationResult(
      pdfBytes: pdfBytes,
      layoutResult: layoutResult,
    );
  }

  /// Generates a single-page PDF scaled to fit a specific page size.
  ///
  /// Uses the [cachedLayoutResult] from the most recent [generatePreviewPdf]
  /// call. Throws [StateError] if no layout result is cached.
  Uint8List generateScaledSinglePagePdf({
    required TieSheetThemeConfig themeConfig,
    required double fullPageWidth,
    required double fullPageHeight,
    required double printableAreaWidth,
    required double printableAreaHeight,
    Uint8List? leftLogoImageBytes,
    Uint8List? rightLogoImageBytes,
  }) {
    _throwIfNoCachedLayout();

    final params = PdfRenderParams(
      layoutResult: _cachedLayoutResult!,
      themeConfig: themeConfig,
      leftLogoImageBytes: leftLogoImageBytes,
      rightLogoImageBytes: rightLogoImageBytes,
    );

    return Uint8List.fromList(
      _rendererService.generateScaledSinglePagePdfBytes(
        params: params,
        fullPageWidth: fullPageWidth,
        fullPageHeight: fullPageHeight,
        printableAreaWidth: printableAreaWidth,
        printableAreaHeight: printableAreaHeight,
      ),
    );
  }

  /// Generates a multi-page tiled PDF for large-format printing.
  ///
  /// Uses the [cachedLayoutResult] from the most recent [generatePreviewPdf]
  /// call. Throws [StateError] if no layout result is cached.
  Uint8List generateTiledPdf({
    required TieSheetThemeConfig themeConfig,
    required PrintExportSettings exportSettings,
    Uint8List? leftLogoImageBytes,
    Uint8List? rightLogoImageBytes,
  }) {
    _throwIfNoCachedLayout();

    final params = PdfRenderParams(
      layoutResult: _cachedLayoutResult!,
      themeConfig: themeConfig,
      leftLogoImageBytes: leftLogoImageBytes,
      rightLogoImageBytes: rightLogoImageBytes,
    );

    return Uint8List.fromList(
      _rendererService.generateTiledBracketPdfBytes(
        params: params,
        exportSettings: exportSettings,
      ),
    );
  }

  /// Clears cached layout result and PDF bytes.
  ///
  /// Call this when bracket data is invalidated or when the screen is
  /// disposed.
  void clearCache() {
    _cachedLayoutResult = null;
    _cachedPdfBytes = null;
  }

  void _throwIfNoCachedLayout() {
    if (_cachedLayoutResult == null) {
      throw StateError(
        'No cached layout result. Call generatePreviewPdf() before '
        'calling export methods.',
      );
    }
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tkd_saas/features/bracket/data/services/bracket_medal_computation_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/tie_sheet_syncfusion_pdf_renderer_service.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/tie_sheet_layout_result.dart';
import 'package:tkd_saas/features/bracket/domain/layout/tie_sheet_layout_engine.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_classification.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';

/// Immutable snapshot of the inputs required for a PDF regeneration cycle.
///
/// Captures the complete set of data needed by the layout engine and PDF
/// renderer so that the orchestrator can defer execution via debounce
/// without losing context.
class PdfRegenerationInputSnapshot {
  const PdfRegenerationInputSnapshot({
    required this.tournament,
    required this.matches,
    required this.participants,
    required this.bracketFormat,
    required this.includeThirdPlaceMatch,
    required this.classification,
    required this.themeConfig,
    this.winnersBracketId,
    this.losersBracketId,
    this.leftLogoImageBytes,
    this.rightLogoImageBytes,
    required this.leftLogoAspectRatio,
    required this.rightLogoAspectRatio,
  });

  final TournamentEntity tournament;
  final List<MatchEntity> matches;
  final List<ParticipantEntity> participants;
  final BracketFormat bracketFormat;
  final bool includeThirdPlaceMatch;
  final BracketClassification classification;
  final TieSheetThemeConfig themeConfig;
  final String? winnersBracketId;
  final String? losersBracketId;
  final Uint8List? leftLogoImageBytes;
  final Uint8List? rightLogoImageBytes;
  final double leftLogoAspectRatio;
  final double rightLogoAspectRatio;
}

/// Central orchestrator for bracket PDF regeneration with debounce.
///
/// Owns the layout engine, PDF renderer, cached results, and debounce
/// timer. Provides a single entry point ([requestDebouncedRegeneration])
/// that collapses rapid-fire state changes into one PDF generation cycle.
///
/// ## Architecture
///
/// All PDF generation triggers in [BracketViewerScreen] delegate to this
/// orchestrator instead of managing timers and caches inline. The
/// orchestrator calls back via [onPdfGenerationCompleted] after each
/// successful (or failed) generation so the screen can call `setState`.
///
/// ## Debounce Behaviour
///
/// ```
/// Trigger 1 ─┐
///             │ [debounceDuration]
/// Trigger 2 ─┤ (cancels previous timer, captures latest snapshot)
///             │ [debounceDuration]
/// Trigger 3 ─┤ (cancels previous timer, captures latest snapshot)
///             │ [debounceDuration] ──→ EXECUTE once with Trigger 3 snapshot
/// ```
///
/// For the initial load and explicit retry paths, use
/// [executeImmediateRegeneration] which bypasses the debounce entirely.
class BracketPdfRegenerationOrchestrator {
  BracketPdfRegenerationOrchestrator({
    required this.debounceDuration,
    required this.onPdfGenerationCompleted,
    this.onRegenerationScheduled,
  });

  /// The debounce window. Regeneration executes only after this duration
  /// elapses without a new [requestDebouncedRegeneration] call.
  final Duration debounceDuration;

  /// Called after every successful or failed generation attempt.
  ///
  /// The screen should call `setState` inside this callback to refresh
  /// the UI with the latest [cachedPdfBytes] / [pdfGenerationError].
  final VoidCallback onPdfGenerationCompleted;

  /// Called when a debounced regeneration is scheduled (timer starts).
  ///
  /// Allows the UI to show a "processing" indicator immediately when
  /// the debounce window begins, rather than waiting until generation
  /// completes.
  final VoidCallback? onRegenerationScheduled;

  // ── Cached outputs ────────────────────────────────────────────

  /// Most recently generated PDF bytes, ready for `SfPdfViewer.memory`.
  Uint8List? get cachedPdfBytes => _cachedPdfBytes;
  Uint8List? _cachedPdfBytes;

  /// Most recently computed layout result. Reused by the export path to
  /// avoid redundant layout computation.
  TieSheetLayoutResult? get cachedLayoutResult => _cachedLayoutResult;
  TieSheetLayoutResult? _cachedLayoutResult;

  /// Monotonically increasing counter to force [SfPdfViewer.memory]
  /// widget recreation when PDF bytes change.
  int get pdfGenerationCounter => _pdfGenerationCounter;
  int _pdfGenerationCounter = 0;

  /// Non-null when the most recent PDF generation attempt failed.
  String? get pdfGenerationError => _pdfGenerationError;
  String? _pdfGenerationError;

  // ── Internals ─────────────────────────────────────────────────

  Timer? _debounceTimer;

  /// Whether a debounced regeneration is currently pending.
  bool get isRegenerationPending => _debounceTimer?.isActive ?? false;

  // ── Public API ────────────────────────────────────────────────

  /// Schedules a debounced PDF regeneration.
  ///
  /// If called again before the debounce window elapses, the previous
  /// pending execution is cancelled and a new timer starts with the
  /// latest [inputSnapshot]. This guarantees at most one execution per
  /// debounce window, using the most recent data.
  void requestDebouncedRegeneration({
    required PdfRegenerationInputSnapshot inputSnapshot,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, () {
      _executeRegeneration(inputSnapshot: inputSnapshot);
    });
    onRegenerationScheduled?.call();
  }

  /// Executes PDF regeneration immediately, bypassing the debounce.
  ///
  /// Use this for:
  /// - Initial page load (user should not wait for debounce)
  /// - Explicit retry after a generation error
  ///
  /// Any pending debounced regeneration is cancelled first.
  void executeImmediateRegeneration({
    required PdfRegenerationInputSnapshot inputSnapshot,
  }) {
    _debounceTimer?.cancel();
    _executeRegeneration(inputSnapshot: inputSnapshot);
  }

  /// Cancels any pending debounced regeneration and releases resources.
  ///
  /// Must be called from the owning widget's `dispose()`.
  void dispose() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  // ── Private implementation ────────────────────────────────────

  void _executeRegeneration({
    required PdfRegenerationInputSnapshot inputSnapshot,
  }) {
    try {
      final layoutResult = _computeBracketLayout(inputSnapshot: inputSnapshot);

      final renderer = TieSheetSyncfusionPdfRendererService();
      final renderParams = PdfRenderParams(
        layoutResult: layoutResult,
        themeConfig: inputSnapshot.themeConfig,
        leftLogoImageBytes: inputSnapshot.leftLogoImageBytes,
        rightLogoImageBytes: inputSnapshot.rightLogoImageBytes,
      );

      final bytes = renderer.renderSinglePagePdfBytes(params: renderParams);

      _cachedLayoutResult = layoutResult;
      _cachedPdfBytes = Uint8List.fromList(bytes);
      _pdfGenerationCounter++;
      _pdfGenerationError = null;
    } catch (error, stackTrace) {
      debugPrint('PDF generation failed: $error\n$stackTrace');
      _cachedPdfBytes = null;
      _cachedLayoutResult = null;
      _pdfGenerationError = 'Failed to generate bracket PDF: $error';
    }

    onPdfGenerationCompleted();
  }

  TieSheetLayoutResult _computeBracketLayout({
    required PdfRegenerationInputSnapshot inputSnapshot,
  }) {
    final engine = TieSheetLayoutEngine(
      const BracketMedalComputationServiceImplementation(),
    );

    return engine.computeLayout(
      tournament: inputSnapshot.tournament,
      matches: inputSnapshot.matches,
      participants: inputSnapshot.participants,
      bracketType: inputSnapshot.bracketFormat.displayLabel,
      includeThirdPlaceMatch: inputSnapshot.includeThirdPlaceMatch,
      winnersBracketId: inputSnapshot.winnersBracketId,
      losersBracketId: inputSnapshot.losersBracketId,
      themeConfig: inputSnapshot.themeConfig,
      classification: inputSnapshot.classification,
      hasLeftLogo: inputSnapshot.leftLogoImageBytes != null,
      hasRightLogo: inputSnapshot.rightLogoImageBytes != null,
      leftLogoAspectRatio: inputSnapshot.leftLogoAspectRatio,
      rightLogoAspectRatio: inputSnapshot.rightLogoAspectRatio,
    );
  }
}

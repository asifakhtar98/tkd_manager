import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/features/bracket/data/services/bracket_pdf_generator_service.dart';
import 'package:tkd_saas/features/bracket/presentation/models/print_export_settings.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/bracket_history_drawer.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/participant_edit_dialog.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/print_preview_dialog.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/participant_slot_hit_area.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/score_entry_dialog.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_theme_config.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_theme_editor_panel.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_classification.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';

/// Bracket viewer — now URL-driven via `/tournaments/:tId/brackets/:sId`.
///
/// Receives a pre-looked-up [tournament] and [snapshot] from the route
/// builder. The [BracketBloc] is provided by the route layer (see
/// [BracketViewerRoute] in `app_routes.dart`).
class BracketViewerScreen extends StatefulWidget {
  const BracketViewerScreen({
    super.key,
    required this.tournament,
    required this.snapshot,
  });

  final TournamentEntity tournament;
  final BracketSnapshot snapshot;

  @override
  State<BracketViewerScreen> createState() => _BracketViewerScreenState();
}

class _BracketViewerScreenState extends State<BracketViewerScreen> {
  final TransformationController _transformController =
      TransformationController();
  final GlobalKey _printKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Non-null while a PDF export is in progress.
  /// Value ranges from 0.0 (just started) to 1.0 (complete).
  double? _pdfExportProgress;
  String _pdfExportStatusMessage = '';

  /// The currently active tie-sheet visual theme mode.
  TieSheetThemeMode _activeTieSheetThemeMode = TieSheetThemeMode.defaultMode;

  /// The user-customised theme config, mutated via the editor panel.
  /// Starts from the default preset and accumulates per-token overrides.
  TieSheetThemeConfig _customThemeConfig = TieSheetThemeConfig.defaultPreset;

  bool get _isExportingPdf => _pdfExportProgress != null;

  /// Returns the theme config that the canvas should render with.
  /// For Screen / Print modes, uses the preset. For Custom mode,
  /// returns the user-edited [_customThemeConfig].
  TieSheetThemeConfig get _resolvedThemeConfig {
    if (_activeTieSheetThemeMode == TieSheetThemeMode.customMode) {
      return _customThemeConfig;
    }
    return TieSheetThemeConfig.fromMode(_activeTieSheetThemeMode);
  }

  // ── Convenience accessors from snapshot ─────────────────────────────────────
  BracketFormat get _bracketFormat => widget.snapshot.format;
  bool get _includeThirdPlaceMatch => widget.snapshot.includeThirdPlaceMatch;
  BracketClassification get _classification => widget.snapshot.classification;

  /// Extracts the flat match list and optional bracket IDs from a
  /// [BracketResult].  Used by both the on-screen viewer and PDF export.
  ({
    List<MatchEntity> allMatches,
    String? winnersBracketId,
    String? losersBracketId,
  })
  _extractBracketDataFromResult(BracketResult result) {
    final List<MatchEntity> allMatches = switch (result) {
      SingleEliminationResult(:final data) => data.matches,
      DoubleEliminationResult(:final data) => data.allMatches,
    };

    String? winnersBracketId;
    String? losersBracketId;
    if (result case DoubleEliminationResult(:final data)) {
      winnersBracketId = data.winnersBracket.id;
      losersBracketId = data.losersBracket.id;
    }

    return (
      allMatches: allMatches,
      winnersBracketId: winnersBracketId,
      losersBracketId: losersBracketId,
    );
  }

  void _updateExportProgress(double progress, String message) {
    if (!mounted) return;
    setState(() {
      _pdfExportProgress = progress;
      _pdfExportStatusMessage = message;
    });
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  /// Builds a [TieSheetPainter] from the current bloc state for PDF export.
  /// Returns `null` if no bracket data is loaded.
  TieSheetPainter? _buildExportPainter() {
    final blocState = context.read<BracketBloc>().state;
    if (blocState is! BracketLoadSuccess) return null;

    final bracketData = _extractBracketDataFromResult(blocState.result);

    return TieSheetPainter(
      tournament: widget.tournament,
      matches: bracketData.allMatches,
      participants: blocState.participants,
      bracketType: _bracketFormat.displayLabel,
      includeThirdPlaceMatch: _includeThirdPlaceMatch,
      winnersBracketId: bracketData.winnersBracketId,
      losersBracketId: bracketData.losersBracketId,
      isEditModeEnabled: false,
      themeConfig: _resolvedThemeConfig,
      classification: _classification,
    );
  }

  /// Opens the full-screen [PrintPreviewDialog] where the user configures
  /// paper size, orientation, fit mode, scale, and tile overlap.  When the
  /// user confirms, delegates to [_generateAndPrintPdf] to build and print
  /// the document.
  Future<void> _showPrintPreview() async {
    final exportPainter = _buildExportPainter();
    if (exportPainter == null) return;

    final canvasSize = exportPainter.calculateCanvasSize();

    if (!mounted) return;

    final confirmedSettings = await PrintPreviewDialog.show(
      context: context,
      painter: exportPainter,
      canvasSize: canvasSize,
    );

    if (confirmedSettings == null || !mounted) return;

    await _generateAndPrintPdf(
      painter: exportPainter,
      canvasSize: canvasSize,
      settings: confirmedSettings,
    );
  }

  /// Quick single-page export using the original inline PictureRecorder
  /// approach with a dynamic page format that matches the canvas 1:1.
  /// Opens the native print dialog immediately — no preview UI.
  Future<void> _directExportPdf() async {
    final exportPainter = _buildExportPainter();

    _updateExportProgress(0.0, 'Preparing bracket for export…');
    await Future<void>.delayed(Duration.zero);

    try {
      if (exportPainter == null) {
        _updateExportProgress(1.0, 'No bracket data available.');
        return;
      }

      final Size canvasSize = exportPainter.calculateCanvasSize();

      _updateExportProgress(0.15, 'Rendering bracket image…');
      await Future<void>.delayed(Duration.zero);

      // Render off-screen via PictureRecorder with safe GPU texture scaling.
      // Modern browsers with CanvasKit/Skwasm reliably support 8192.
      const double safeMaxTextureDimension = 8192.0;
      final double scaleFactor = min(
        1.0,
        min(
          safeMaxTextureDimension / canvasSize.width,
          safeMaxTextureDimension / canvasSize.height,
        ),
      );

      final int imageWidth = (canvasSize.width * scaleFactor).ceil();
      final int imageHeight = (canvasSize.height * scaleFactor).ceil();

      final recorder = ui.PictureRecorder();
      final recordingCanvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, imageWidth.toDouble(), imageHeight.toDouble()),
      );

      recordingCanvas.scale(scaleFactor);
      exportPainter.paint(recordingCanvas, canvasSize);

      final ui.Picture picture = recorder.endRecording();

      _updateExportProgress(0.35, 'Converting to image…');
      await Future<void>.delayed(Duration.zero);

      Uint8List? capturedImageBytes;
      try {
        final ui.Image image = await picture.toImage(imageWidth, imageHeight);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          capturedImageBytes = byteData.buffer.asUint8List();
        }
        image.dispose();
      } finally {
        picture.dispose();
      }

      // Build PDF with dynamic page format matching canvas 1:1.
      _updateExportProgress(0.55, 'Building PDF layout…');
      await Future<void>.delayed(Duration.zero);

      pw.ImageProvider? bracketImage;
      if (capturedImageBytes != null) {
        bracketImage = pw.MemoryImage(capturedImageBytes);
      }

      final dynamicPageFormat = _computePdfPageFormatFromCanvasSize(canvasSize);

      final doc = pw.Document();
      doc.addPage(
        pw.Page(
          pageFormat: dynamicPageFormat,
          margin: const pw.EdgeInsets.all(24),
          build: (pw.Context ctx) {
            if (bracketImage != null) {
              return pw.Center(
                child: pw.Image(bracketImage, fit: pw.BoxFit.contain),
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

      _updateExportProgress(0.75, 'Generating PDF bytes…');
      await Future<void>.delayed(Duration.zero);

      final pdfBytes = await doc.save();

      _updateExportProgress(0.9, 'Opening print dialog…');
      await Future<void>.delayed(Duration.zero);

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    } finally {
      if (mounted) {
        setState(() {
          _pdfExportProgress = null;
          _pdfExportStatusMessage = '';
        });
      }
    }
  }

  /// Computes a [PdfPageFormat] that fits the full bracket canvas on a single
  /// page — dimensions match the canvas logical pixels 1:1 as PDF points.
  PdfPageFormat _computePdfPageFormatFromCanvasSize(Size canvasSize) {
    if (canvasSize == Size.zero ||
        canvasSize.width <= 0 ||
        canvasSize.height <= 0) {
      return PdfPageFormat.a4.landscape;
    }
    return PdfPageFormat(canvasSize.width, canvasSize.height);
  }

  /// Generates a PDF from the [painter] using the confirmed [settings] and
  /// opens the native print / share dialog.
  Future<void> _generateAndPrintPdf({
    required TieSheetPainter painter,
    required Size canvasSize,
    required PrintExportSettings settings,
  }) async {
    _updateExportProgress(0.0, 'Preparing export…');
    await Future<void>.delayed(Duration.zero);

    try {
      const pdfService = BracketPdfGeneratorService();
      final pdfBytes = await pdfService.generatePdf(
        painter: painter,
        canvasSize: canvasSize,
        settings: settings,
        onProgress: _updateExportProgress,
      );

      _updateExportProgress(0.95, 'Opening print dialog…');
      await Future<void>.delayed(Duration.zero);

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    } finally {
      if (mounted) {
        setState(() {
          _pdfExportProgress = null;
          _pdfExportStatusMessage = '';
        });
      }
    }
  }

  /// Navigates back to the parent tournament detail page using URL
  /// navigation rather than stack-based `pop()`.
  void _navigateBackToTournamentDetail() {
    TournamentDetailRoute(tournamentId: widget.tournament.id).go(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BracketBloc, BracketState>(
      listenWhen: (prev, current) {
        if (current is! BracketLoadSuccess) return false;
        if (prev is! BracketLoadSuccess) return true;

        // Fire when an error message appears.
        final hasNewErrorMessage = current.errorMessage != null &&
            current.errorMessage != prev.errorMessage;

        // Fire when a save cycle completes (isSaving transitions false).
        final saveJustCompleted = prev.isSaving && !current.isSaving;

        return hasNewErrorMessage || saveJustCompleted;
      },
      listener: (context, state) {
        if (state is! BracketLoadSuccess) return;

        // Handle save completion feedback.
        if (!state.isSaving && state.lastSaveTimestamp != null) {
          if (state.saveError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.saveError!),
                backgroundColor: Colors.red.shade800,
                duration: const Duration(seconds: 4),
              ),
            );
          }
          // Successful save is silent (auto-saves shouldn't spam the user).
        }

        // Handle bracket operation errors.
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.grey.shade800,
            ),
          );
          context.read<BracketBloc>().add(
            const BracketEvent.errorDismissed(),
          );
        }
      },
      builder: (context, state) {
        return switch (state) {
          BracketInitial() || BracketGenerating() => Scaffold(
            appBar: AppBar(
              title: Text(
                '${_bracketFormat.displayLabel} — ${widget.snapshot.participantCount} Players',
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          ),
          BracketFailure(:final message) => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _navigateBackToTournamentDetail,
              ),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.grey.shade800,
                  ),
                  const SizedBox(height: 16),
                  Text(message, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          BracketLoadSuccess(
            :final result,
            :final participants,
            :final format,
            :final includeThirdPlaceMatch,
            :final actionHistory,
            :final historyPointer,
            :final isReplayInProgress,
            :final isEditModeEnabled,
            :final isSaving,
            :final hasUnsavedChanges,
            :final lastSaveTimestamp,
            :final saveError,
          ) =>
            _buildViewer(
              context: context,
              result: result,
              participants: participants,
              format: format,
              includeThirdPlaceMatch: includeThirdPlaceMatch,
              actionHistory: actionHistory,
              historyPointer: historyPointer,
              isReplayInProgress: isReplayInProgress,
              isEditModeEnabled: isEditModeEnabled,
              isSaving: isSaving,
              hasUnsavedChanges: hasUnsavedChanges,
              lastSaveTimestamp: lastSaveTimestamp,
              saveError: saveError,
            ),
        };
      },
    );
  }

  Widget _buildViewer({
    required BuildContext context,
    required BracketResult result,
    required List<ParticipantEntity> participants,
    required BracketFormat format,
    required bool includeThirdPlaceMatch,
    required List<BracketHistoryEntry> actionHistory,
    required int historyPointer,
    required bool isReplayInProgress,
    required bool isEditModeEnabled,
    required bool isSaving,
    required bool hasUnsavedChanges,
    required DateTime? lastSaveTimestamp,
    required String? saveError,
  }) {
    final bracketData = _extractBracketDataFromResult(result);

    final view = _buildBracketView(
      bracketData.allMatches,
      participants,
      winnersBracketId: bracketData.winnersBracketId,
      losersBracketId: bracketData.losersBracketId,
      isEditModeEnabled: isEditModeEnabled,
    );

    final bool canUndo = historyPointer >= 0 && !isReplayInProgress;
    final bool canRedo =
        historyPointer < actionHistory.length - 1 && !isReplayInProgress;
    final bool hasHistory = actionHistory.isNotEmpty;

    final actionButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      disabledForegroundColor: Colors.grey,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${format.displayLabel} — ${participants.length} Players'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateBackToTournamentDetail,
        ),
        actions: [
          // ── Canvas Theme Toggle ──
          SegmentedButton<TieSheetThemeMode>(
            segments: TieSheetThemeMode.values
                .map(
                  (mode) => ButtonSegment<TieSheetThemeMode>(
                    value: mode,
                    icon: Icon(switch (mode) {
                      TieSheetThemeMode.defaultMode => Icons.visibility,
                      TieSheetThemeMode.printMode => Icons.print,
                      TieSheetThemeMode.customMode => Icons.tune,
                    }, size: 16),
                    label: Text(
                      mode.label,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                )
                .toList(),
            selected: {_activeTieSheetThemeMode},
            onSelectionChanged: (selected) {
              setState(() => _activeTieSheetThemeMode = selected.first);
            },
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ── Export PDF ──
          PopupMenuButton<String>(
            enabled: !_isExportingPdf,
            onSelected: (value) {
              switch (value) {
                case 'direct':
                  _directExportPdf();
                case 'advanced':
                  _showPrintPreview();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'direct',
                child: ListTile(
                  leading: Icon(Icons.print, size: 20),
                  title: Text('Direct Print'),
                  subtitle: Text('Single page, fit-to-page'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'advanced',
                child: ListTile(
                  leading: Icon(Icons.dashboard_customize, size: 20),
                  title: Text('Advanced Export'),
                  subtitle: Text('Multi-page tiling, custom paper'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            child: TextButton(
              style: actionButtonStyle,
              onPressed: null,
              child: _isExportingPdf
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Export PDF'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down, size: 18),
                      ],
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 48,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Undo ──
              TextButton(
                style: actionButtonStyle,
                onPressed: canUndo
                    ? () => context.read<BracketBloc>().add(
                        const BracketEvent.undoRequested(),
                      )
                    : null,
                child: const Text('Undo'),
              ),

              // ── Redo ──
              TextButton(
                style: actionButtonStyle,
                onPressed: canRedo
                    ? () => context.read<BracketBloc>().add(
                        const BracketEvent.redoRequested(),
                      )
                    : null,
                child: const Text('Redo'),
              ),

              // ── Replay / Stop ──
              if (isReplayInProgress)
                TextButton(
                  style: actionButtonStyle,
                  onPressed: () => context.read<BracketBloc>().add(
                    const BracketEvent.replayCancelled(),
                  ),
                  child: const Text('Stop Replay'),
                )
              else
                TextButton(
                  style: actionButtonStyle,
                  onPressed: hasHistory
                      ? () => context.read<BracketBloc>().add(
                          const BracketEvent.replayRequested(),
                        )
                      : null,
                  child: const Text('Replay All'),
                ),

              // ── History Drawer ──
              TextButton(
                style: actionButtonStyle,
                onPressed: hasHistory
                    ? () => _scaffoldKey.currentState?.openEndDrawer()
                    : null,
                child: const Text('History'),
              ),

              const SizedBox(width: 8),

              // ── Edit Mode Toggle ──
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: isEditModeEnabled
                      ? Colors.grey.shade400
                      : Colors.white,
                  disabledForegroundColor: Colors.grey,
                ),
                onPressed: isReplayInProgress
                    ? null
                    : () => context.read<BracketBloc>().add(
                        const BracketEvent.editModeToggled(),
                      ),
                child: Text(isEditModeEnabled ? 'Exit Edit' : 'Edit Mode'),
              ),

              const SizedBox(width: 8),

              // ── Regenerate ──
              TextButton(
                style: actionButtonStyle,
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Regenerate Bracket?'),
                      content: const Text(
                        'Current match scores and progress will be lost.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(c, true),
                          child: const Text('Regenerate'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    context.read<BracketBloc>().add(
                      const BracketRegenerateRequested(),
                    );
                  }
                },
                child: const Text('Regenerate'),
              ),
              const SizedBox(
                height: 24,
                child: VerticalDivider(width: 16, color: Colors.white24),
              ),
              // ── Save Status Indicator ──
              _buildSaveStatusIndicator(
                isSaving: isSaving,
                hasUnsavedChanges: hasUnsavedChanges,
                lastSaveTimestamp: lastSaveTimestamp,
                saveError: saveError,
              ),
              // ── Save Bracket ──
              Tooltip(
                message: 'Save explicitly to persist the current bracket state',
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: hasUnsavedChanges
                        ? Colors.blueAccent
                        : Colors.white,
                    disabledForegroundColor: Colors.grey,
                  ),
                  onPressed: isSaving || !hasUnsavedChanges
                      ? null
                      : () {
                          context.read<BracketBloc>().add(
                            const BracketSaveRequested(),
                          );
                        },
                  icon: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Save Bracket'),
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: BracketHistoryDrawer(
        actionHistory: actionHistory,
        historyPointer: historyPointer,
        onJumpToHistoryIndex: (targetIndex) {
          context.read<BracketBloc>().add(
            BracketEvent.historyJumpRequested(targetHistoryIndex: targetIndex),
          );
          // Close the drawer after jumping.
          _scaffoldKey.currentState?.closeEndDrawer();
        },
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // ── Edit mode info banner ──
                    if (isEditModeEnabled)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        color: Colors.grey.shade300,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 16,
                              color: Color(0xFF92400E),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Edit Mode — Tap a participant to edit details, '
                                'or long-press and drag to swap positions.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // ── Replay progress indicator ──
                    if (isReplayInProgress && actionHistory.isNotEmpty)
                      LinearProgressIndicator(
                        value: (historyPointer + 1) / actionHistory.length,
                        minHeight: 4,
                      ),
                    // ── Bracket canvas ──
                    Expanded(child: view),
                  ],
                ),
              ),
              // ── Custom theme editor side panel ──
              if (_activeTieSheetThemeMode == TieSheetThemeMode.customMode)
                SizedBox(
                  width: 340,
                  child: TieSheetThemeEditorPanel(
                    currentThemeConfig: _customThemeConfig,
                    onThemeConfigChanged: (newConfig) {
                      setState(() => _customThemeConfig = newConfig);
                    },
                  ),
                ),
            ],
          ),
          // ── PDF export loading overlay ──
          if (_isExportingPdf)
            Container(
              color: Colors.black54,
              child: Center(
                child: SizedBox(
                  width: 280,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _pdfExportProgress ?? 0.0,
                          minHeight: 6,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _pdfExportStatusMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBracketView(
    List<MatchEntity> matches,
    List<ParticipantEntity> participants, {
    String? winnersBracketId,
    String? losersBracketId,
    bool isEditModeEnabled = false,
  }) {
    return InteractiveViewer(
      transformationController: _transformController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(500),
      minScale: 0.1,
      maxScale: 2.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: TieSheetCanvasWidget(
            tournament: widget.tournament,
            matches: matches,
            participants: participants,
            bracketType: _bracketFormat.displayLabel,
            onMatchTap: (matchId) =>
                _handleMatchTap(context, matchId, matches, participants),
            printKey: _printKey,
            includeThirdPlaceMatch: _includeThirdPlaceMatch,
            winnersBracketId: winnersBracketId,
            losersBracketId: losersBracketId,
            isEditModeEnabled: isEditModeEnabled,
            themeConfig: _resolvedThemeConfig,
            classification: _classification,
            onParticipantSlotSwapped: (source, target) {
              _handleParticipantSwap(
                context,
                source,
                target,
                matches,
                participants,
              );
            },
            onParticipantSlotTapped: (slot) {
              _handleParticipantSlotTap(context, slot, participants);
            },
          ),
        ),
      ),
    );
  }

  /// Opens the [ScoreEntryDialog] for the tapped match. If the user confirms
  /// a result, dispatches [BracketMatchResultRecorded] to the BLoC.
  void _handleMatchTap(
    BuildContext context,
    String matchId,
    List<MatchEntity> allMatches,
    List<ParticipantEntity> participants,
  ) {
    final match = allMatches
        .where((matchEntity) => matchEntity.id == matchId)
        .firstOrNull;

    if (match == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Match "$matchId" not found.')));
      return;
    }

    // Don't allow re-scoring a completed match.
    if (match.status == MatchStatus.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This match is already completed.')),
      );
      return;
    }

    // Don't allow scoring cancelled or bye matches.
    if (match.status == MatchStatus.cancelled ||
        match.resultType == MatchResultType.bye) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This match cannot be scored.')),
      );
      return;
    }

    // Both participants must be assigned before scoring.
    if (match.participantBlueId == null || match.participantRedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Both participants must be assigned first.'),
        ),
      );
      return;
    }

    final blueName = _participantName(match.participantBlueId!, participants);
    final redName = _participantName(match.participantRedId!, participants);

    ScoreEntryDialog.show(
      context: context,
      match: match,
      blueParticipantName: blueName,
      redParticipantName: redName,
    ).then((result) {
      if (result != null && context.mounted) {
        context.read<BracketBloc>().add(
          BracketEvent.matchResultRecorded(
            matchId: matchId,
            winnerId: result.winnerId,
            resultType: result.resultType,
            blueScore: result.blueScore,
            redScore: result.redScore,
          ),
        );
      }
    });
  }

  String _participantName(String id, List<ParticipantEntity> participants) {
    return participants
            .where((participant) => participant.id == id)
            .firstOrNull
            ?.fullName ??
        'Unknown';
  }

  /// Handles a participant slot swap triggered by drag-and-drop.
  void _handleParticipantSwap(
    BuildContext context,
    ParticipantSlotHitArea source,
    ParticipantSlotHitArea target,
    List<MatchEntity> allMatches,
    List<ParticipantEntity> participants,
  ) {
    if (source.participantId == null || target.participantId == null) return;

    context.read<BracketBloc>().add(
      BracketEvent.participantSlotSwapped(
        sourceMatchId: source.matchId,
        sourceSlotPosition: source.slotPosition,
        targetMatchId: target.matchId,
        targetSlotPosition: target.slotPosition,
      ),
    );
  }

  /// Handles a participant slot tap in edit mode — opens the edit dialog.
  void _handleParticipantSlotTap(
    BuildContext context,
    ParticipantSlotHitArea slot,
    List<ParticipantEntity> participants,
  ) {
    if (slot.participantId == null) return;

    final participant = participants
        .where((p) => p.id == slot.participantId)
        .firstOrNull;
    if (participant == null) return;

    ParticipantEditDialog.show(context: context, participant: participant).then(
      (result) {
        if (result != null && context.mounted) {
          context.read<BracketBloc>().add(
            BracketEvent.participantDetailsUpdated(
              participantId: participant.id,
              updatedFullName: result.updatedFullName,
              updatedRegistrationId: result.updatedRegistrationId,
            ),
          );
        }
      },
    );
  }

  // ── Save Status Indicator ──────────────────────────────────────────────────

  /// Builds a compact save status widget for the bottom bar.
  ///
  /// Shows:
  /// - "Saving…" with spinner during active save
  /// - "Save failed" with error icon on save error
  /// - "Saved ✓" with relative timestamp on last successful save
  /// - Nothing when there's no save history and no unsaved changes
  Widget _buildSaveStatusIndicator({
    required bool isSaving,
    required bool hasUnsavedChanges,
    required DateTime? lastSaveTimestamp,
    required String? saveError,
  }) {
    if (isSaving) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Colors.white54,
            ),
          ),
          SizedBox(width: 6),
          Text(
            'Saving…',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          SizedBox(width: 8),
        ],
      );
    }

    if (saveError != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 14),
          const SizedBox(width: 4),
          Text(
            'Save failed',
            style: TextStyle(color: Colors.red.shade300, fontSize: 12),
          ),
          const SizedBox(width: 8),
        ],
      );
    }

    if (lastSaveTimestamp != null && !hasUnsavedChanges) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_done_outlined, color: Colors.white38, size: 14),
          const SizedBox(width: 4),
          Text(
            'Saved ${_formatRelativeTimestamp(lastSaveTimestamp)}',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(width: 8),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  /// Formats a [DateTime] as a human-readable relative string.
  String _formatRelativeTimestamp(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inSeconds < 10) return 'just now';
    if (difference.inSeconds < 60) return '${difference.inSeconds}s ago';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}

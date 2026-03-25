import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/bracket_history_drawer.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/participant_edit_dialog.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/participant_slot_hit_area.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/score_entry_dialog.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_theme_config.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_theme_editor_panel.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';

/// Bracket viewer — receives route props, broadcasts [BracketGenerateRequested]
/// via the [BracketBloc] provided by the route (see [BracketRoute]).
class BracketViewerScreen extends StatefulWidget {
  const BracketViewerScreen({
    super.key,
    required this.participants,
    required this.dojangSeparation,
    required this.bracketFormat,
    required this.includeThirdPlaceMatch,
    this.tournament,
    this.isHistoryView = false,
  });

  final List<ParticipantEntity> participants;
  final bool dojangSeparation;

  /// The elimination format used for this bracket.
  final BracketFormat bracketFormat;
  final bool includeThirdPlaceMatch;
  final TournamentEntity? tournament;

  /// When true the bracket is a replay from history — do NOT save a new
  /// [BracketSnapshot] so the history list stays clean.
  final bool isHistoryView;

  @override
  State<BracketViewerScreen> createState() => _BracketViewerScreenState();
}

class _BracketViewerScreenState extends State<BracketViewerScreen> {
  final TransformationController _transformController =
      TransformationController();
  final GlobalKey _printKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Tracks whether we have already committed a snapshot for this generation
  // session, so we don't double-save on rebuilds.
  bool _snapshotSaved = false;

  /// Non-null while a PDF export is in progress.
  /// Value ranges from 0.0 (just started) to 1.0 (complete).
  double? _pdfExportProgress;
  String _pdfExportStatusMessage = '';

  /// The currently active tie-sheet visual theme mode.
  TieSheetThemeMode _activeTieSheetThemeMode = TieSheetThemeMode.defaultMode;

  /// The user-customised theme config, mutated via the editor panel.
  /// Starts from the default preset and accumulates per-token overrides.
  TieSheetThemeConfig _customThemeConfig =
      const TieSheetThemeConfig.defaultMode();

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

  static const _uuid = Uuid();

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

  /// Exports the currently visible bracket as a real PDF.
  ///
  /// Instead of capturing from the render tree (which is subject to WebGL
  /// `MAX_TEXTURE_SIZE` limits and silently crops large brackets), this method
  /// creates a fresh [TieSheetPainter] from the current bloc state, renders it
  /// off-screen via [ui.PictureRecorder] with a scale transform that keeps the
  /// output image within safe GPU texture bounds, and feeds the resulting PNG
  /// into the PDF document.
  ///
  /// Each heavy step is followed by a microtask yield so the event loop can
  /// repaint the progress overlay — critical on web where there is no
  /// background isolate.
  Future<void> _exportPdf() async {
    // Read bloc state synchronously before any awaits to avoid using
    // BuildContext across async gaps.
    final blocState = context.read<BracketBloc>().state;

    _updateExportProgress(0.0, 'Preparing bracket for export…');
    await Future<void>.delayed(Duration.zero);

    try {
      // ── Step 1: Build a TieSheetPainter from current bloc state ──
      if (blocState is! BracketLoadSuccess) {
        _updateExportProgress(1.0, 'No bracket data available.');
        return;
      }

      final List<MatchEntity> allMatches = switch (blocState.result) {
        SingleEliminationResult(:final data) => data.matches,
        DoubleEliminationResult(:final data) => data.allMatches,
      };

      String? winnersBracketId;
      String? losersBracketId;
      if (blocState.result case DoubleEliminationResult(:final data)) {
        winnersBracketId = data.winnersBracket.id;
        losersBracketId = data.losersBracket.id;
      }

      final exportPainter = TieSheetPainter(
        tournament: widget.tournament ??
            TournamentEntity(
              id: 'demo',
              name: 'Demo Tournament',
              createdAt: DateTime(2026),
            ),
        matches: allMatches,
        participants: blocState.participants,
        bracketType: widget.bracketFormat.displayLabel,
        includeThirdPlaceMatch: widget.includeThirdPlaceMatch,
        winnersBracketId: winnersBracketId,
        losersBracketId: losersBracketId,
        isEditModeEnabled: false,
        themeConfig: _resolvedThemeConfig,
        // Logo images are loaded inside TieSheetCanvasWidget state and not
        // accessible here. They are omitted from the PDF export — a minor
        // cosmetic tradeoff for guaranteed full-bracket capture.
      );

      final Size canvasSize = exportPainter.calculateCanvasSize();

      _updateExportProgress(0.15, 'Rendering bracket image…');
      await Future<void>.delayed(Duration.zero);

      // ── Step 2: Render the painter off-screen via PictureRecorder ──
      //
      // WebGL's MAX_TEXTURE_SIZE (often 4096) limits the pixel dimensions of
      // any single GPU texture.  For large brackets the canvas can easily
      // exceed this, causing `toImage` to silently clip.  We apply a scale
      // transform so the rasterised image always fits within a safe bound.
      const double safeMaxTextureDimension = 4000.0;
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

      // Scale the canvas so the full bracket paints inside [imageWidth × imageHeight].
      recordingCanvas.scale(scaleFactor);
      exportPainter.paint(recordingCanvas, canvasSize);

      final ui.Picture picture = recorder.endRecording();

      _updateExportProgress(0.35, 'Converting to image…');
      await Future<void>.delayed(Duration.zero);

      Uint8List? capturedImageBytes;
      try {
        final ui.Image image = await picture.toImage(imageWidth, imageHeight);
        final byteData = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        if (byteData != null) {
          capturedImageBytes = byteData.buffer.asUint8List();
        }
        image.dispose();
      } finally {
        picture.dispose();
      }

      // ── Step 3: Build PDF page layout ──
      _updateExportProgress(0.55, 'Building PDF layout…');
      await Future<void>.delayed(Duration.zero);

      pw.ImageProvider? bracketImage;
      if (capturedImageBytes != null) {
        bracketImage = pw.MemoryImage(capturedImageBytes);
      }

      // Dynamically compute the PDF page format from the bracket canvas
      // dimensions so the entire bracket fits on one page without cropping.
      final dynamicPageFormat = _computePdfPageFormatFromCanvasSize(
        canvasSize,
      );

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

      // ── Step 4: Serialize PDF to bytes ──
      _updateExportProgress(0.75, 'Generating PDF bytes…');
      await Future<void>.delayed(Duration.zero);

      final pdfBytes = await doc.save();

      // ── Step 5: Show native print / share dialog ──
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
  /// page while maintaining its aspect ratio.
  ///
  /// The page dimensions are set to match the canvas logical pixel dimensions
  /// 1:1 as PDF points. When physically printing, the printer's "fit to page"
  /// option will scale down to the paper being used. Falls back to A4
  /// landscape if the canvas size is unavailable.
  PdfPageFormat _computePdfPageFormatFromCanvasSize(Size canvasSize) {
    if (canvasSize == Size.zero ||
        canvasSize.width <= 0 ||
        canvasSize.height <= 0) {
      return PdfPageFormat.a4.landscape;
    }

    return PdfPageFormat(canvasSize.width, canvasSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BracketBloc, BracketState>(
      listenWhen: (prev, current) => current is BracketLoadSuccess,
      listener: (context, state) {
        if (state case BracketLoadSuccess(
          :final result,
          :final participants,
          :final format,
          :final includeThirdPlaceMatch,
          :final errorMessage,
        )) {
          // Show error as SnackBar without destroying bracket state.
          if (errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.grey.shade800,
              ),
            );
            // Clear the error so it doesn't re-fire on rebuild.
            context.read<BracketBloc>().add(
              const BracketEvent.errorDismissed(),
            );
            return;
          }
          _saveSnapshot(
            context: context,
            result: result,
            participants: participants,
            format: format,
            includeThirdPlaceMatch: includeThirdPlaceMatch,
          );
        }
      },
      builder: (context, state) {
        return switch (state) {
          BracketInitial() || BracketGenerating() => Scaffold(
            appBar: AppBar(
              title: Text(
                '${widget.bracketFormat.displayLabel} — ${widget.participants.length} Players',
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          ),
          BracketFailure(:final message) => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
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
            ),
        };
      },
    );
  }

  /// Saves the just-generated bracket as a [BracketSnapshot] under the
  /// owning tournament in [TournamentBloc]. Only fires once per viewer session
  /// (guarded by [_snapshotSaved]) and is skipped for demo brackets that have
  /// no owning tournament.
  void _saveSnapshot({
    required BuildContext context,
    required BracketResult result,
    required List<ParticipantEntity> participants,
    required BracketFormat format,
    required bool includeThirdPlaceMatch,
  }) {
    // Skip if already saved, no owning tournament, or replaying history.
    if (_snapshotSaved || widget.tournament == null || widget.isHistoryView) {
      return;
    }
    _snapshotSaved = true;

    final snapshot = BracketSnapshot(
      id: _uuid.v4(),
      label: '${format.displayLabel} — ${participants.length} Players',
      format: format,
      participantCount: participants.length,
      includeThirdPlaceMatch: includeThirdPlaceMatch,
      dojangSeparation: widget.dojangSeparation,
      generatedAt: DateTime.now(),
      participants: participants,
      result: result,
    );

    context.read<TournamentBloc>().add(
      TournamentEvent.bracketSnapshotAdded(
        tournamentId: widget.tournament!.id,
        snapshot: snapshot,
      ),
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
  }) {
    // Gather all matches for the score entry handler.
    final List<MatchEntity> allMatches = switch (result) {
      SingleEliminationResult(:final data) => data.matches,
      DoubleEliminationResult(:final data) => data.allMatches,
    };

    // Both SE and DE render a single canvas — no tabs.
    String? winnersBracketId;
    String? losersBracketId;
    if (result case DoubleEliminationResult(:final data)) {
      winnersBracketId = data.winnersBracket.id;
      losersBracketId = data.losersBracket.id;
    }

    final view = _buildBracketView(
      allMatches,
      participants,
      winnersBracketId: winnersBracketId,
      losersBracketId: losersBracketId,
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
          onPressed: () => context.pop(),
        ),
        actions: [
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

          const SizedBox(width: 4),

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

          const SizedBox(width: 4),

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
                if (!widget.isHistoryView) {
                  setState(() => _snapshotSaved = false);
                }
                context.read<BracketBloc>().add(
                  const BracketRegenerateRequested(),
                );
              }
            },
            child: const Text('Regenerate'),
          ),

          // ── Canvas Theme Toggle ──
          SegmentedButton<TieSheetThemeMode>(
            segments: TieSheetThemeMode.values
                .map(
                  (mode) => ButtonSegment<TieSheetThemeMode>(
                    value: mode,
                    icon: Icon(
                      switch (mode) {
                        TieSheetThemeMode.defaultMode => Icons.visibility,
                        TieSheetThemeMode.printMode => Icons.print,
                        TieSheetThemeMode.customMode => Icons.tune,
                      },
                      size: 16,
                    ),
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
          TextButton(
            style: actionButtonStyle,
            onPressed: _isExportingPdf
                ? null
                : () => _exportPdf(),
            child: _isExportingPdf
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Export PDF'),
          ),
        ],
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
                            Icon(Icons.edit, size: 16, color: Color(0xFF92400E)),
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
            tournament:
                widget.tournament ??
                TournamentEntity(
                  id: 'demo',
                  name: 'Demo Tournament',
                  createdAt: DateTime(2026),
                ),
            matches: matches,
            participants: participants,
            bracketType: widget.bracketFormat.displayLabel,
            onMatchTap: (matchId) =>
                _handleMatchTap(context, matchId, matches, participants),
            printKey: _printKey,
            includeThirdPlaceMatch: widget.includeThirdPlaceMatch,
            winnersBracketId: winnersBracketId,
            losersBracketId: losersBracketId,
            isEditModeEnabled: isEditModeEnabled,
            themeConfig: _resolvedThemeConfig,
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
    final match = allMatches.firstWhere(
      (matchEntity) => matchEntity.id == matchId,
      orElse: () => throw StateError('Match $matchId not found'),
    );

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
    final matchingParticipants = participants.where(
      (participant) => participant.id == id,
    );
    if (matchingParticipants.isEmpty) return 'Unknown';
    return matchingParticipants.first.fullName;
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

    ParticipantEditDialog.show(
      context: context,
      participant: participant,
    ).then((result) {
      if (result != null && context.mounted) {
        context.read<BracketBloc>().add(
          BracketEvent.participantDetailsUpdated(
            participantId: participant.id,
            updatedFullName: result.updatedFullName,
            updatedRegistrationId: result.updatedRegistrationId,
          ),
        );
      }
    });
  }
}

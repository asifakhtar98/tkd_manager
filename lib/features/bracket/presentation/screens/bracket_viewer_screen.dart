import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tkd_saas/features/bracket/data/services/bracket_medal_computation_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/tie_sheet_syncfusion_pdf_renderer_service.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/layout/tie_sheet_layout_engine.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/tie_sheet_layout_result.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/bracket_theme_selection.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_preset_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_preset_state.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_selection_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_selection_event.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_selection_state.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/bracket_history_drawer.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/bracket_match_list_panel.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/bracket_participant_list_panel.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/score_entry_dialog.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_theme_editor_panel.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/core/router/app_routes.dart' hide BracketFormat;
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Cached PDF bytes for the on-screen viewer.
  Uint8List? _cachedPdfBytes;

  /// Cached layout result to avoid redundant recomputation during export.
  TieSheetLayoutResult? _cachedLayoutResult;

  /// Monotonically increasing counter to force [SfPdfViewer.memory] recreation
  /// when PDF bytes change. Using byte length as a key is fragile since
  /// two different PDFs can share the same length.
  int _pdfGenerationCounter = 0;

  /// Non-null when the most recent PDF generation attempt failed.
  String? _pdfGenerationError;

  Uint8List? _leftLogoImageBytes;
  Uint8List? _rightLogoImageBytes;
  double _leftLogoAspectRatio = 1.0;
  double _rightLogoAspectRatio = 1.0;
  bool _logosLoadingComplete = false;
  int _activeSidePanelTab = 0;
  double? _pdfExportProgress;
  String _pdfExportStatusMessage = '';

  bool get _isExportingPdf => _pdfExportProgress != null;

  TieSheetThemeConfig _resolveThemeConfigFromSelection(
    BracketThemeSelectionState selectionState,
  ) {
    return selectionState.activeThemeSelection.when(
      defaultModeSelected: () => TieSheetThemeConfig.defaultPreset,
      printModeSelected: () => TieSheetThemeConfig.printPreset,
      cloudPresetSelected: (_) =>
          selectionState.liveCustomThemeConfiguration ??
          TieSheetThemeConfig.defaultPreset,
      customModeSelected: () =>
          selectionState.liveCustomThemeConfiguration ??
          TieSheetThemeConfig.defaultPreset,
    );
  }

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
    super.dispose();
  }

  /// Loads tournament logo images from their URLs, decodes them to extract
  /// aspect ratios, and caches raw bytes for PDF rendering.
  ///
  /// Called once on first build. Triggers a PDF regeneration when both logos
  /// have been resolved (even if they fail — missing logos are acceptable).
  Future<void> _loadTournamentLogoImages() async {
    final results = await Future.wait([
      _loadImageBytesAndAspectRatioFromUrl(widget.tournament.leftLogoUrl),
      _loadImageBytesAndAspectRatioFromUrl(widget.tournament.rightLogoUrl),
    ]);

    if (!mounted) return;

    final leftResult = results[0];
    final rightResult = results[1];

    setState(() {
      _leftLogoImageBytes = leftResult?.imageBytes;
      _leftLogoAspectRatio = leftResult?.aspectRatio ?? 1.0;
      _rightLogoImageBytes = rightResult?.imageBytes;
      _rightLogoAspectRatio = rightResult?.aspectRatio ?? 1.0;
      _logosLoadingComplete = true;
    });

    // Regenerate PDF now that logos are available.
    _regeneratePdfFromCurrentState();
  }

  Future<({Uint8List imageBytes, double aspectRatio})?>
  _loadImageBytesAndAspectRatioFromUrl(String url) async {
    if (url.isEmpty) return null;
    try {
      final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load('');
      final Uint8List imageBytes = data.buffer.asUint8List();

      final completer = Completer<ImageInfo>();
      final imageStream = MemoryImage(
        imageBytes,
      ).resolve(ImageConfiguration.empty);
      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (info, _) {
          completer.complete(info);
          imageStream.removeListener(listener);
        },
        onError: (error, _) {
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
          imageStream.removeListener(listener);
        },
      );
      imageStream.addListener(listener);

      final imageInfo = await completer.future;
      final double aspectRatio = imageInfo.image.width / imageInfo.image.height;
      imageInfo.dispose();

      return (imageBytes: imageBytes, aspectRatio: aspectRatio);
    } catch (error) {
      debugPrint('Failed to load logo image from $url: $error');
      return null;
    }
  }

  /// Computes a [TieSheetLayoutResult] from the current bracket state.
  TieSheetLayoutResult _computeBracketLayout({
    required List<MatchEntity> matches,
    required List<ParticipantEntity> participants,
    required TieSheetThemeConfig themeConfig,
    String? winnersBracketId,
    String? losersBracketId,
  }) {
    final engine = TieSheetLayoutEngine(
      const BracketMedalComputationServiceImplementation(),
    );
    return engine.computeLayout(
      tournament: widget.tournament,
      matches: matches,
      participants: participants,
      bracketType: _bracketFormat.displayLabel,
      includeThirdPlaceMatch: _includeThirdPlaceMatch,
      winnersBracketId: winnersBracketId,
      losersBracketId: losersBracketId,
      themeConfig: themeConfig,
      classification: _classification,
      hasLeftLogo: _leftLogoImageBytes != null,
      hasRightLogo: _rightLogoImageBytes != null,
      leftLogoAspectRatio: _leftLogoAspectRatio,
      rightLogoAspectRatio: _rightLogoAspectRatio,
    );
  }

  /// Generates vector PDF bytes and caches both the layout result and the
  /// rendered PDF. Called only when bracket data or theme actually changes
  /// (via [_regeneratePdfIfInputsChanged]), never from a build method.
  void _regeneratePdfAndCacheResult({
    required List<MatchEntity> matches,
    required List<ParticipantEntity> participants,
    required TieSheetThemeConfig themeConfig,
    String? winnersBracketId,
    String? losersBracketId,
  }) {
    try {
      final layoutResult = _computeBracketLayout(
        matches: matches,
        participants: participants,
        themeConfig: themeConfig,
        winnersBracketId: winnersBracketId,
        losersBracketId: losersBracketId,
      );
      final renderer = TieSheetSyncfusionPdfRendererService();
      final renderParams = PdfRenderParams(
        layoutResult: layoutResult,
        themeConfig: themeConfig,
        leftLogoImageBytes: _leftLogoImageBytes,
        rightLogoImageBytes: _rightLogoImageBytes,
      );
      final bytes = renderer.renderSinglePagePdfBytes(params: renderParams);

      setState(() {
        _cachedLayoutResult = layoutResult;
        _cachedPdfBytes = Uint8List.fromList(bytes);
        _pdfGenerationCounter++;
        _pdfGenerationError = null;
      });
    } catch (error, stackTrace) {
      debugPrint('PDF generation failed: $error\n$stackTrace');
      setState(() {
        _pdfGenerationError = 'Failed to generate bracket PDF: $error';
        _cachedPdfBytes = null;
        _cachedLayoutResult = null;
      });
    }
  }

  /// Called from BlocListener callbacks when bracket data or theme changes.
  /// Triggers a full PDF regeneration only when the underlying inputs
  /// have actually changed.
  void _regeneratePdfFromCurrentState() {
    final bracketState = context.read<BracketBloc>().state;
    if (bracketState is! BracketLoadSuccess) return;

    final themeSelectionState = context.read<BracketThemeSelectionBloc>().state;
    final themeConfig = _resolveThemeConfigFromSelection(themeSelectionState);
    final bracketData = _extractBracketDataFromResult(bracketState.result);

    _regeneratePdfAndCacheResult(
      matches: bracketData.allMatches,
      participants: bracketState.participants,
      themeConfig: themeConfig,
      winnersBracketId: bracketData.winnersBracketId,
      losersBracketId: bracketData.losersBracketId,
    );
  }

  Future<void> _exportSinglePagePdf() async {
    _updateExportProgress(0.0, 'Preparing single-page export…');
    await Future<void>.delayed(Duration.zero);

    try {
      if (_cachedLayoutResult == null) {
        _updateExportProgress(1.0, 'No bracket data available.');
        return;
      }

      if (!mounted) return;

      final themeSelectionState = context
          .read<BracketThemeSelectionBloc>()
          .state;
      final themeConfig = _resolveThemeConfigFromSelection(themeSelectionState);

      _updateExportProgress(0.5, 'Generating single-page PDF…');
      await Future<void>.delayed(Duration.zero);

      // Always generate a portrait A4 page. The renderer will auto-rotate
      // wide bracket content 90° so it fills the long edge of the paper.
      const double a4PortraitWidth = 595.28;
      const double a4PortraitHeight = 841.89;

      final renderer = TieSheetSyncfusionPdfRendererService();
      final renderParams = PdfRenderParams(
        layoutResult: _cachedLayoutResult!,
        themeConfig: themeConfig,
        leftLogoImageBytes: _leftLogoImageBytes,
        rightLogoImageBytes: _rightLogoImageBytes,
      );

      // Zero margins — bracket content fills the entire page.
      final bytes = renderer.generateScaledSinglePagePdfBytes(
        params: renderParams,
        fullPageWidth: a4PortraitWidth,
        fullPageHeight: a4PortraitHeight,
        printableAreaWidth: a4PortraitWidth,
        printableAreaHeight: a4PortraitHeight,
        autoRotateWideContent: true,
      );

      final exportPdfBytes = Uint8List.fromList(bytes);

      _updateExportProgress(0.8, 'Opening print dialog…');
      await Future<void>.delayed(Duration.zero);

      await Printing.layoutPdf(
        name: 'Bracket_SinglePage',
        onLayout: (format) async => exportPdfBytes,
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
    return BlocListener<BracketThemePresetBloc, BracketThemePresetState>(
      listenWhen: (prev, current) =>
          prev is! BracketThemePresetLoaded &&
          current is BracketThemePresetLoaded,
      listener: (context, presetState) {
        if (presetState is BracketThemePresetLoaded) {
          context.read<BracketThemeSelectionBloc>().add(
            BracketThemeSelectionEvent.hydratedSelectionResolved(
              availableCloudPresets: presetState.presets,
            ),
          );
        }
      },
      child: BlocConsumer<BracketBloc, BracketState>(
        listenWhen: (prev, current) {
          if (current is! BracketLoadSuccess) return false;
          if (prev is! BracketLoadSuccess) return true;

          final hasNewErrorMessage =
              current.errorMessage != null &&
              current.errorMessage != prev.errorMessage;

          final saveJustCompleted = prev.isSaving && !current.isSaving;

          final hasBracketDataChanged =
              current.result != prev.result ||
              current.participants != prev.participants;

          return hasNewErrorMessage ||
              saveJustCompleted ||
              hasBracketDataChanged;
        },
        listener: (context, state) {
          if (state is! BracketLoadSuccess) return;

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
          }

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

          _regeneratePdfFromCurrentState();
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
                isSaving: isSaving,
                hasUnsavedChanges: hasUnsavedChanges,
                lastSaveTimestamp: lastSaveTimestamp,
                saveError: saveError,
              ),
          };
        },
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
    required bool isSaving,
    required bool hasUnsavedChanges,
    required DateTime? lastSaveTimestamp,
    required String? saveError,
  }) {
    final bracketData = _extractBracketDataFromResult(result);

    // NOTE: _buildBracketView is called inside the BlocConsumer builder
    // (see line with `Expanded(child: ...)` below) so the canvas reacts
    // to theme-selection changes.

    final bool canUndo = historyPointer >= 0 && !isReplayInProgress;
    final bool canRedo =
        historyPointer < actionHistory.length - 1 && !isReplayInProgress;
    final bool hasHistory = actionHistory.isNotEmpty;

    final actionButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      disabledForegroundColor: Colors.grey,
    );

    return BlocConsumer<BracketThemeSelectionBloc, BracketThemeSelectionState>(
      listenWhen: (previous, current) {
        // Fire on theme expired message.
        if (current.themeExpiredMessage != null &&
            current.themeExpiredMessage != previous.themeExpiredMessage) {
          return true;
        }
        // Fire on theme selection or live config change → triggers PDF regen.
        if (current.activeThemeSelection != previous.activeThemeSelection ||
            current.liveCustomThemeConfiguration !=
                previous.liveCustomThemeConfiguration) {
          return true;
        }
        return false;
      },
      listener: (context, selectionState) {
        if (selectionState.themeExpiredMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(selectionState.themeExpiredMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 4),
              ),
            );
          context.read<BracketThemeSelectionBloc>().add(
            const BracketThemeSelectionEvent.themeExpiredMessageDismissed(),
          );
        }

        _regeneratePdfFromCurrentState();
      },
      builder: (context, selectionState) {
        if (_cachedPdfBytes == null && _pdfGenerationError == null) {
          // Schedule generation after frame to avoid setState-in-build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _regeneratePdfFromCurrentState();
              if (!_logosLoadingComplete) {
                _loadTournamentLogoImages();
              }
            }
          });
        }

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              '${format.displayLabel} — ${participants.length} Players',
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _navigateBackToTournamentDetail,
            ),
            actions: [
              TextButton(
                style: actionButtonStyle,
                onPressed: _isExportingPdf ? null : _exportSinglePagePdf,
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
                          Icon(Icons.article_outlined, size: 18),
                          SizedBox(width: 4),
                          Text('Single Export'),
                        ],
                      ),
              ),

              const SizedBox(width: 8),

              IconButton(
                icon: const Icon(Icons.menu_open),
                tooltip: 'Open Side Panel',
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
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
                  TextButton(
                    style: actionButtonStyle,
                    onPressed: canUndo
                        ? () => context.read<BracketBloc>().add(
                            const BracketEvent.undoRequested(),
                          )
                        : null,
                    child: const Text('Undo'),
                  ),

                  TextButton(
                    style: actionButtonStyle,
                    onPressed: canRedo
                        ? () => context.read<BracketBloc>().add(
                            const BracketEvent.redoRequested(),
                          )
                        : null,
                    child: const Text('Redo'),
                  ),

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

                  TextButton(
                    style: actionButtonStyle,
                    onPressed: hasHistory
                        ? () => _scaffoldKey.currentState?.openDrawer()
                        : null,
                    child: const Text('History'),
                  ),

                  const SizedBox(width: 8),

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
                    child: const Text('Regenerate & Shuffle'),
                  ),
                  const SizedBox(
                    height: 24,
                    child: VerticalDivider(width: 16, color: Colors.white24),
                  ),
                  _buildSaveStatusIndicator(
                    isSaving: isSaving,
                    hasUnsavedChanges: hasUnsavedChanges,
                    lastSaveTimestamp: lastSaveTimestamp,
                    saveError: saveError,
                  ),
                  Tooltip(
                    message:
                        'Save explicitly to persist the current bracket state',
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
          drawer: BracketHistoryDrawer(
            actionHistory: actionHistory,
            historyPointer: historyPointer,
            onJumpToHistoryIndex: (targetIndex) {
              context.read<BracketBloc>().add(
                BracketEvent.historyJumpRequested(
                  targetHistoryIndex: targetIndex,
                ),
              );
              _scaffoldKey.currentState?.closeDrawer();
            },
          ),
          endDrawer: Drawer(
            width: 380,
            child: SafeArea(
              child: Column(
                children: [
                  // Tab bar for side panels
                  Material(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSidePanelTab(
                            0,
                            'Matches',
                            Icons.scoreboard,
                          ),
                        ),
                        Expanded(
                          child: _buildSidePanelTab(
                            1,
                            'Participants',
                            Icons.people,
                          ),
                        ),
                        Expanded(
                          child: _buildSidePanelTab(2, 'Theme', Icons.tune),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _activeSidePanelTab,
                      children: [
                        // Tab 0: Match list
                        BracketMatchListPanel(
                          matches: bracketData.allMatches,
                          participants: participants,
                          winnersBracketId: bracketData.winnersBracketId,
                          losersBracketId: bracketData.losersBracketId,
                          onRecordMatchResult: (matchId, winnerId) {
                            _handleMatchResultFromPanel(
                              context,
                              matchId,
                              winnerId,
                              bracketData.allMatches,
                              participants,
                            );
                          },
                        ),
                        // Tab 1: Participant list
                        BracketParticipantListPanel(
                          matches: bracketData.allMatches,
                          participants: participants,
                        ),
                        // Tab 2: Theme editor
                        TieSheetThemeEditorPanel(
                          currentThemeConfig:
                              selectionState.liveCustomThemeConfiguration ??
                              TieSheetThemeConfig.defaultPreset,
                          onCloudPresetApplied: (preset) {
                            context.read<BracketThemeSelectionBloc>().add(
                              BracketThemeSelectionEvent.cloudPresetApplied(
                                presetId: preset.id,
                                resolvedThemeConfiguration:
                                    preset.themeConfiguration,
                              ),
                            );
                          },
                          onThemeConfigChanged: (newConfig) {
                            context.read<BracketThemeSelectionBloc>().add(
                              BracketThemeSelectionEvent.customThemeConfigurationUpdated(
                                updatedThemeConfiguration: newConfig,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        if (isReplayInProgress && actionHistory.isNotEmpty)
                          LinearProgressIndicator(
                            value: (historyPointer + 1) / actionHistory.length,
                            minHeight: 4,
                          ),

                        Expanded(
                          child: _pdfGenerationError != null
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Colors.red.shade300,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        _pdfGenerationError!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.red.shade300,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      OutlinedButton.icon(
                                        onPressed:
                                            _regeneratePdfFromCurrentState,
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                )
                              : _cachedPdfBytes != null &&
                                    _cachedLayoutResult != null
                              ? LayoutBuilder(
                                  builder: (context, constraints) {
                                    // Compute initial zoom to fit the entire
                                    // bracket into the available viewport as
                                    // one cohesive unit — mimics the old
                                    // InteractiveViewer "fit all" behavior.
                                    final canvasSize =
                                        _cachedLayoutResult!.computedCanvasSize;
                                    final viewportWidth = constraints.maxWidth;
                                    final viewportHeight =
                                        constraints.maxHeight;

                                    final fitZoomLevel =
                                        (viewportWidth > 0 &&
                                            viewportHeight > 0 &&
                                            canvasSize.width > 0 &&
                                            canvasSize.height > 0)
                                        ? min(
                                            viewportWidth / canvasSize.width,
                                            viewportHeight / canvasSize.height,
                                          ).clamp(0.01, 5.0)
                                        : 0.5;

                                    return SfPdfViewer.memory(
                                      _cachedPdfBytes!,
                                      key: ValueKey(_pdfGenerationCounter),
                                      canShowScrollHead: false,
                                      canShowPaginationDialog: false,
                                      canShowScrollStatus: false,
                                      enableDoubleTapZooming: true,
                                      enableTextSelection: false,
                                      pageLayoutMode: PdfPageLayoutMode.single,
                                      scrollDirection:
                                          PdfScrollDirection.horizontal,
                                      interactionMode: PdfInteractionMode.pan,
                                      initialZoomLevel: fitZoomLevel,
                                      maxZoomLevel: 5,
                                    );
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
      },
    );
  }

  Widget _buildSidePanelTab(int index, String label, IconData icon) {
    final isActive = _activeSidePanelTab == index;
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() => _activeSidePanelTab = index);
        if (index == 2) {
          context.read<BracketThemeSelectionBloc>().add(
            const BracketThemeSelectionEvent.themeModeToggled(
              selectedMode: TieSheetThemeMode.customMode,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? theme.colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles match result recording from the side panel.
  void _handleMatchResultFromPanel(
    BuildContext context,
    String matchId,
    String winnerId,
    List<MatchEntity> allMatches,
    List<ParticipantEntity> participants,
  ) {
    final match = allMatches.where((m) => m.id == matchId).firstOrNull;
    if (match == null) return;

    if (match.status == MatchStatus.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This match is already completed.')),
      );
      return;
    }

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
          const Icon(
            Icons.cloud_done_outlined,
            color: Colors.white38,
            size: 14,
          ),
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

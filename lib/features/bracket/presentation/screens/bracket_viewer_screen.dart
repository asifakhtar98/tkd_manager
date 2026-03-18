import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:tkd_saas/features/bracket/presentation/widgets/score_entry_dialog.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart';
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
  bool _isExportingPdf = false;
  static const _uuid = Uuid();

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  /// Exports the currently visible bracket tab as a real PDF.
  ///
  /// Captures the [RepaintBoundary] for the active tab (winners or losers),
  /// converts the canvas to a PNG image, and embeds it in a landscape A4 PDF
  /// page with a header showing the tournament name and format.
  Future<void> _exportPdf(String title) async {
    setState(() => _isExportingPdf = true);
    try {
      pw.ImageProvider? bracketImage;
      try {
        final boundary = _printKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
        if (boundary != null) {
          final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
          final byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            bracketImage = pw.MemoryImage(byteData.buffer.asUint8List());
          }
        }
      } catch (_) {
        // Capture failed — fall back to text-only export.
      }

      final doc = pw.Document();
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(24),
          build: (pw.Context ctx) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  widget.bracketFormat.displayLabel,
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 12),
                pw.Divider(),
                pw.SizedBox(height: 12),
                // Bracket image or fallback
                if (bracketImage != null)
                  pw.Expanded(
                    child: pw.Center(
                      child: pw.Image(bracketImage, fit: pw.BoxFit.contain),
                    ),
                  )
                else
                  pw.Expanded(
                    child: pw.Center(
                      child: pw.Text(
                        'Bracket image could not be captured.\n'
                        'Please try again after the bracket has fully rendered.',
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      );
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
      );
    } finally {
      if (mounted) {
        setState(() => _isExportingPdf = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BracketBloc, BracketState>(
      listenWhen: (prev, current) => current is BracketLoadSuccess,
      listener: (context, state) {
        if (state case BracketLoadSuccess(:final result, :final participants,
            :final format, :final includeThirdPlaceMatch, :final errorMessage)) {
          // Show error as SnackBar without destroying bracket state.
          if (errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.redAccent,
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
                      '${widget.bracketFormat.displayLabel} — ${widget.participants.length} Players')),
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
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(message, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          BracketLoadSuccess(:final result,
              :final participants,
              :final format,
              :final includeThirdPlaceMatch,
              :final actionHistory,
              :final historyPointer,
              :final isReplayInProgress) =>
            _buildViewer(
              context: context,
              result: result,
              participants: participants,
              format: format,
              includeThirdPlaceMatch: includeThirdPlaceMatch,
              actionHistory: actionHistory,
              historyPointer: historyPointer,
              isReplayInProgress: isReplayInProgress,
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
    );

    final tournamentTitle = widget.tournament?.name ?? 'Tournament';

    final bool canUndo = historyPointer >= 0 && !isReplayInProgress;
    final bool canRedo = historyPointer < actionHistory.length - 1 &&
        !isReplayInProgress;
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
                ? () => context
                    .read<BracketBloc>()
                    .add(const BracketEvent.undoRequested())
                : null,
            child: const Text('Undo'),
          ),

          // ── Redo ──
          TextButton(
            style: actionButtonStyle,
            onPressed: canRedo
                ? () => context
                    .read<BracketBloc>()
                    .add(const BracketEvent.redoRequested())
                : null,
            child: const Text('Redo'),
          ),

          // ── Replay / Stop ──
          if (isReplayInProgress)
            TextButton(
              style: actionButtonStyle,
              onPressed: () => context
                  .read<BracketBloc>()
                  .add(const BracketEvent.replayCancelled()),
              child: const Text('Stop Replay'),
            )
          else
            TextButton(
              style: actionButtonStyle,
              onPressed: hasHistory
                  ? () => context
                      .read<BracketBloc>()
                      .add(const BracketEvent.replayRequested())
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

          // ── Regenerate ──
          TextButton(
            style: actionButtonStyle,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Regenerate Bracket?'),
                  content: const Text(
                      'Current match scores and progress will be lost.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Regenerate')),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                if (!widget.isHistoryView) {
                  setState(() => _snapshotSaved = false);
                }
                context
                    .read<BracketBloc>()
                    .add(const BracketRegenerateRequested());
              }
            },
            child: const Text('Regenerate'),
          ),

          // ── Export PDF ──
          TextButton(
            style: actionButtonStyle,
            onPressed: _isExportingPdf
                ? null
                : () => _exportPdf(tournamentTitle),
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
                BracketEvent.historyJumpRequested(
                  targetHistoryIndex: targetIndex,
                ),
              );
          // Close the drawer after jumping.
          _scaffoldKey.currentState?.closeEndDrawer();
        },
      ),
      body: Stack(
        children: [
          Column(
            children: [
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
          // ── PDF export loading overlay ──
          if (_isExportingPdf)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Generating PDF…',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
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
            tournament: widget.tournament ??
                TournamentEntity(
                  id: 'demo',
                  name: 'Demo Tournament',
                  createdAt: DateTime(2026),
                ),
            matches: matches,
            participants: widget.participants,
            bracketType: widget.bracketFormat.displayLabel,
            onMatchTap: (matchId) => _handleMatchTap(
              context,
              matchId,
              matches,
              participants,
            ),
            printKey: _printKey,
            includeThirdPlaceMatch: widget.includeThirdPlaceMatch,
            winnersBracketId: winnersBracketId,
            losersBracketId: losersBracketId,
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
            content: Text('Both participants must be assigned first.')),
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
}

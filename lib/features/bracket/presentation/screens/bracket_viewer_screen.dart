import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
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
    required this.format,
    required this.includeThirdPlaceMatch,
    this.tournament,
    this.isHistoryView = false,
  });

  final List<ParticipantEntity> participants;
  final bool dojangSeparation;
  final String format;
  final bool includeThirdPlaceMatch;
  final TournamentEntity? tournament;

  /// When true the bracket is a replay from history — do NOT save a new
  /// [BracketSnapshot] so the history list stays clean.
  final bool isHistoryView;

  @override
  State<BracketViewerScreen> createState() => _BracketViewerScreenState();
}

class _BracketViewerScreenState extends State<BracketViewerScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final TransformationController _transformationController =
      TransformationController();

  final GlobalKey _winnersPrintKey = GlobalKey();
  final GlobalKey _losersPrintKey = GlobalKey();

  // Tracks whether we have already committed a snapshot for this generation
  // session, so we don't double-save on rebuilds.
  bool _snapshotSaved = false;
  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    // Tab count is known from format at construction time — no need to wait
    // for BloC state to initialise the controller.
    final tabCount = widget.format == 'Double Elimination' ? 2 : 1;
    _tabController = TabController(length: tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  /// Exports the currently visible bracket tab as a real PDF.
  ///
  /// Captures the [RepaintBoundary] for the active tab (winners or losers),
  /// converts the canvas to a PNG image, and embeds it in a landscape A4 PDF
  /// page with a header showing the tournament name and format.
  Future<void> _exportPdf(String title) async {
    // Pick the correct print key based on the active tab.
    final printKey =
        _tabController.index == 1 ? _losersPrintKey : _winnersPrintKey;

    pw.ImageProvider? bracketImage;
    try {
      final boundary = printKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary != null) {
        final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
        final byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          bracketImage =
              pw.MemoryImage(byteData.buffer.asUint8List());
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
                widget.format,
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BracketBloc, BracketState>(
      listenWhen: (_, current) => current is BracketLoadSuccess,
      listener: (context, state) {
        if (state case BracketLoadSuccess(:final result, :final participants,
            :final format, :final includeThirdPlaceMatch)) {
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
                      '${widget.format} — ${widget.participants.length} Players')),
              body: const Center(child: CircularProgressIndicator()),
            ),
          BracketFailure(:final message) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(child: Text(message)),
            ),
          BracketLoadSuccess(:final result,
              :final participants,
              :final format,
              :final includeThirdPlaceMatch) =>
            _buildViewer(
              context: context,
              result: result,
              participants: participants,
              format: format,
              includeThirdPlaceMatch: includeThirdPlaceMatch,
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
    required String format,
    required bool includeThirdPlaceMatch,
  }) {
    // Skip if already saved, no owning tournament, or replaying history.
    if (_snapshotSaved || widget.tournament == null || widget.isHistoryView) {
      return;
    }
    _snapshotSaved = true;

    final snapshot = BracketSnapshot(
      id: _uuid.v4(),
      label: '$format — ${participants.length} Players',
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
    required String format,
    required bool includeThirdPlaceMatch,
  }) {

    final List<Tab> tabs = [];
    final List<Widget> views = [];

    switch (result) {
      case SingleEliminationResult(:final data):
        tabs.add(const Tab(text: 'Main Bracket'));
        views.add(
            _buildBracketView(data.bracket, data.matches, _winnersPrintKey));

      case DoubleEliminationResult(:final data):
        final winnersMatches = data.allMatches
            .where((m) => m.bracketId == data.winnersBracket.id)
            .toList();
        final losersMatches = data.allMatches
            .where((m) => m.bracketId == data.losersBracket.id)
            .toList();
        tabs.add(const Tab(text: 'Winners Bracket'));
        tabs.add(const Tab(text: 'Losers Bracket'));
        views.add(_buildBracketView(
            data.winnersBracket, winnersMatches, _winnersPrintKey));
        views.add(_buildBracketView(
            data.losersBracket, losersMatches, _losersPrintKey));
    }

    final tournamentTitle = widget.tournament?.name ?? 'Tournament';

    return Scaffold(
      appBar: AppBar(
        title: Text('$format — ${participants.length} Players'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: tabs.length > 1
            ? TabBar(controller: _tabController, tabs: tabs)
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Regenerate',
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
                setState(() => _snapshotSaved = false);
                context
                    .read<BracketBloc>()
                    .add(const BracketRegenerateRequested());
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: () => _exportPdf(tournamentTitle),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: views,
      ),
    );
  }

  Widget _buildBracketView(
    BracketEntity bracket,
    List<MatchEntity> matches,
    GlobalKey printKey,
  ) {
    return InteractiveViewer(
      transformationController: _transformationController,
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
            bracketType: widget.format,
            onMatchTap: (matchId) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped Match ID: $matchId')),
              );
            },
            printKey: printKey,
            includeThirdPlaceMatch: widget.includeThirdPlaceMatch,
          ),
        ),
      ),
    );
  }
}

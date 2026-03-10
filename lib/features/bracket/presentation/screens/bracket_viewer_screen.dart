import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/tournament_info.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

/// Bracket viewer — receives route props, broadcasts [BracketGenerateRequested]
/// via the [BracketBloc] provided by the route (see [BracketRoute]).
class BracketViewerScreen extends StatefulWidget {
  const BracketViewerScreen({
    super.key,
    required this.participants,
    required this.dojangSeparation,
    required this.format,
    required this.includeThirdPlaceMatch,
    this.tournamentInfo,
  });

  final List<ParticipantEntity> participants;
  final bool dojangSeparation;
  final String format;
  final bool includeThirdPlaceMatch;
  final TournamentInfo? tournamentInfo;

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

  Future<void> _exportPdf(String title) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context ctx) =>
            pw.Center(child: pw.Text('Tie Sheet: $title')),
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BracketBloc, BracketState>(
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

    final tournamentTitle =
        widget.tournamentInfo?.tournamentName ?? 'Tournament';

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
            tournamentInfo: widget.tournamentInfo ??
                const TournamentInfo(tournamentName: 'Demo Tournament'),
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

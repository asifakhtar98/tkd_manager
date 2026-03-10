import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_generation_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/double_elimination_bracket_generation_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/tournament_info.dart';
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BracketViewerScreen extends StatefulWidget {
  final List<ParticipantEntity> participants;
  final bool dojangSeparation;
  final String format;
  final bool includeThirdPlaceMatch;
  final TournamentInfo? tournamentInfo;

  const BracketViewerScreen({
    super.key,
    required this.participants,
    required this.dojangSeparation,
    required this.format,
    required this.includeThirdPlaceMatch,
    this.tournamentInfo,
  });

  @override
  State<BracketViewerScreen> createState() => _BracketViewerScreenState();
}

class _BracketViewerScreenState extends State<BracketViewerScreen> with TickerProviderStateMixin {
  dynamic _generationResult;
  late TabController _tabController;
  final TransformationController _transformationController = TransformationController();
  final Uuid _uuid = const Uuid();

  late final SingleEliminationBracketGeneratorServiceImplementation _singleElimGenerator;
  late final DoubleEliminationBracketGeneratorServiceImplementation _doubleElimGenerator;

  @override
  void initState() {
    super.initState();
    _singleElimGenerator = SingleEliminationBracketGeneratorServiceImplementation(_uuid);
    _doubleElimGenerator = DoubleEliminationBracketGeneratorServiceImplementation(_uuid);
    
    _generate();
    _initializeTabController();
  }

  void _initializeTabController() {
    int length = 1;
    if (_generationResult is DoubleEliminationBracketGenerationResult) {
       length = 2; // Winners and Losers
    }
    _tabController = TabController(length: length, vsync: this);
  }

  void _generate() {
    final participantIds = widget.participants.map((p) => p.id).toList();
    final divisionId = widget.participants.isNotEmpty ? widget.participants.first.divisionId : 'default_division';

    if (widget.format == 'Double Elimination') {
      _generationResult = _doubleElimGenerator.generate(
        divisionId: divisionId,
        participantIds: participantIds,
        winnersBracketId: _uuid.v4(),
        losersBracketId: _uuid.v4(),
      );
    } else {
      _generationResult = _singleElimGenerator.generate(
        divisionId: divisionId,
        participantIds: participantIds,
        bracketId: _uuid.v4(),
        includeThirdPlaceMatch: widget.includeThirdPlaceMatch,
      );
    }
  }

  void _regenerate() {
    setState(() {
      _generate();
      _initializeTabController();
    });
  }

  Future<void> _exportPdf() async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Center(child: pw.Text("Tie Sheet: ${widget.tournamentInfo?.tournamentName ?? 'Tournament'}"));
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  final GlobalKey _winnersPrintKey = GlobalKey();
  final GlobalKey _losersPrintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<Widget> tabViews = [];
    List<Tab> tabs = [];

    if (_generationResult is BracketGenerationResult) {
      final res = _generationResult as BracketGenerationResult;
      tabs.add(const Tab(text: 'Main Bracket'));
      tabViews.add(_buildBracketView(res.bracket, res.matches, _winnersPrintKey));
    } else if (_generationResult is DoubleEliminationBracketGenerationResult) {
      final res = _generationResult as DoubleEliminationBracketGenerationResult;
      tabs.add(const Tab(text: 'Winners Bracket'));
      tabs.add(const Tab(text: 'Losers Bracket'));
      
      final winnersMatches = res.allMatches.where((m) => m.bracketId == res.winnersBracket.id).toList();
      final losersMatches = res.allMatches.where((m) => m.bracketId == res.losersBracket.id).toList();
      
      tabViews.add(_buildBracketView(res.winnersBracket, winnersMatches, _winnersPrintKey));
      tabViews.add(_buildBracketView(res.losersBracket, losersMatches, _losersPrintKey));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.format} - ${widget.participants.length} Players'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: tabs.length > 1
            ? TabBar(
                controller: _tabController,
                tabs: tabs,
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Regenerate',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text("Regenerate Bracket?"),
                  content: const Text("Current match scores and progress will be lost."),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("Cancel")),
                    ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text("Regenerate")),
                  ],
                ),
              );
              if (confirm == true) _regenerate();
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: _exportPdf,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabViews,
      ),
    );
  }

  Widget _buildBracketView(BracketEntity bracket, List<MatchEntity> matches, GlobalKey printKey) {
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
            tournamentInfo: widget.tournamentInfo ?? const TournamentInfo(tournamentName: 'Demo Tournament'),
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


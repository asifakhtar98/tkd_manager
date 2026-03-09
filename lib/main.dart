import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'features/bracket/domain/entities/match_entity.dart';
import 'features/bracket/domain/entities/tournament_info.dart';
import 'features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart';
import 'features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart';
import 'features/participant/domain/entities/participant_entity.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const BracketGeneratorApp());
}

class BracketGeneratorApp extends StatelessWidget {
  const BracketGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TKD Bracket Generator',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.tealAccent,
        ),
      ),
      home: const ParticipantEntryScreen(),
    );
  }
}

class ParticipantEntryScreen extends StatefulWidget {
  const ParticipantEntryScreen({super.key});

  @override
  State<ParticipantEntryScreen> createState() => _ParticipantEntryScreenState();
}

class _ParticipantEntryScreenState extends State<ParticipantEntryScreen> {
  final List<ParticipantEntity> _participants = [];
  final Uuid _uuid = const Uuid();
  bool _dojangSeparation = true;
  bool _includeThirdPlaceMatch = false;
  String _format = 'Single Elimination';

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dojangController = TextEditingController();
  final _registrationIdController = TextEditingController();

  final _tournamentNameController = TextEditingController();
  final _dateRangeController = TextEditingController();
  final _venueController = TextEditingController();
  final _organizerController = TextEditingController();
  final _categoryController = TextEditingController();
  final _divisionLabelController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dojangController.dispose();
    _registrationIdController.dispose();
    _tournamentNameController.dispose();
    _dateRangeController.dispose();
    _venueController.dispose();
    _organizerController.dispose();
    _categoryController.dispose();
    _divisionLabelController.dispose();
    super.dispose();
  }

  void _addParticipant() {
    if (_firstNameController.text.trim().isEmpty) return;

    setState(() {
      _participants.add(
        ParticipantEntity(
          id: _uuid.v4(),
          divisionId: 'manual_division',
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          schoolOrDojangName: _dojangController.text.trim().isNotEmpty ? _dojangController.text.trim() : null,
          registrationId: _registrationIdController.text.trim().isNotEmpty ? _registrationIdController.text.trim() : null,
          seedNumber: _participants.length + 1,
        ),
      );
      _firstNameController.clear();
      _lastNameController.clear();
      _dojangController.clear();
      _registrationIdController.clear();
    });
  }

  void _importCsv(String csvData) {
    if (csvData.trim().isEmpty) return;
    final lines = csvData.trim().split('\n');
    setState(() {
      for (var l in lines) {
        final parts = l.split(',');
        if (parts.isNotEmpty && parts[0].trim().isNotEmpty) {
          _participants.add(
            ParticipantEntity(
              id: _uuid.v4(),
              divisionId: 'manual_division',
              firstName: parts[0].trim(),
              lastName: parts.length > 1 ? parts[1].trim() : '',
              schoolOrDojangName: parts.length > 2 && parts[2].trim().isNotEmpty ? parts[2].trim() : null,
              registrationId: parts.length > 3 && parts[3].trim().isNotEmpty ? parts[3].trim() : null,
              seedNumber: _participants.length + 1,
            ),
          );
        }
      }
    });
  }

  void _removeParticipant(int index) {
    setState(() {
      _participants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Bracket Setup'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Tooltip(
              message: _participants.length < 2 ? 'Add at least 2 players to generate a bracket' : 'Generate Bracket',
              child: ElevatedButton.icon(
                icon: Icon(Icons.bolt, color: _participants.length >= 2 ? Colors.yellow : Colors.grey),
                label: const Text('GENERATE', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _participants.length >= 2 ? Colors.blueAccent : Colors.grey[800],
                  foregroundColor: _participants.length >= 2 ? Colors.white : Colors.grey,
                ),
                onPressed: _participants.length >= 2 ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BracketViewerScreen(
                        participants: List.from(_participants),
                        dojangSeparation: _dojangSeparation,
                        format: _format,
                        includeThirdPlaceMatch: _includeThirdPlaceMatch,
                        tournamentInfo: TournamentInfo(
                          tournamentName: _tournamentNameController.text.trim(),
                          dateRange: _dateRangeController.text.trim(),
                          venue: _venueController.text.trim(),
                          organizer: _organizerController.text.trim(),
                          categoryLabel: _categoryController.text.trim(),
                          divisionLabel: _divisionLabelController.text.trim(),
                        ),
                      ),
                    ),
                  );
                } : null,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tournament Info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextField(controller: _tournamentNameController, decoration: const InputDecoration(labelText: 'Tournament Name'), textInputAction: TextInputAction.next),
                            const SizedBox(height: 8),
                            TextField(controller: _dateRangeController, decoration: const InputDecoration(labelText: 'Date Range'), textInputAction: TextInputAction.next),
                            const SizedBox(height: 8),
                            TextField(controller: _venueController, decoration: const InputDecoration(labelText: 'Venue'), textInputAction: TextInputAction.next),
                            const SizedBox(height: 8),
                            TextField(controller: _organizerController, decoration: const InputDecoration(labelText: 'Organizer'), textInputAction: TextInputAction.next),
                            const SizedBox(height: 8),
                            TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category (e.g., JUNIOR)'), textInputAction: TextInputAction.next),
                            const SizedBox(height: 8),
                            TextField(controller: _divisionLabelController, decoration: const InputDecoration(labelText: 'Division (e.g., BOYS)'), textInputAction: TextInputAction.done),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Configuration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButton<String>(
                              value: _format,
                              isExpanded: true,
                              items: ['Single Elimination', 'Double Elimination']
                                  .map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _format = val);
                              },
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text('Dojang / School Separation'),
                              subtitle: const Text('Auto-distribute teammates'),
                              value: _dojangSeparation,
                              onChanged: (val) => setState(() => _dojangSeparation = val),
                            ),
                            if (_format == 'Single Elimination') SwitchListTile(
                              title: const Text('3rd Place Match'),
                              subtitle: const Text('Bronze medal match for semi losers'),
                              value: _includeThirdPlaceMatch,
                              onChanged: (val) => setState(() => _includeThirdPlaceMatch = val),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Quick Add Player', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(labelText: 'First Name'),
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) => _addParticipant(),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(labelText: 'Last Name'),
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) => _addParticipant(),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _dojangController,
                              decoration: const InputDecoration(labelText: 'Dojang / Club (Optional)'),
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) => _addParticipant(),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _registrationIdController,
                              decoration: const InputDecoration(labelText: 'Registration ID (Optional)'),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _addParticipant(),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('Add Participant'),
                                onPressed: _addParticipant,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.paste),
                                label: const Text('Paste CSV (First,Last,Dojang,RegID)'),
                                onPressed: () async {
                                  final text = await showDialog<String>(context: context, builder: (c) {
                                    final controller = TextEditingController();
                                    return AlertDialog(
                                      title: const Text("Paste CSV"),
                                      content: TextField(controller: controller, maxLines: 5),
                                      actions: [
                                        TextButton(onPressed: ()=>Navigator.pop(c, ""), child: const Text("Cancel")),
                                        ElevatedButton(onPressed: ()=>Navigator.pop(c, controller.text), child: const Text("Import")),
                                      ]
                                    );
                                  });
                                  if (text != null) _importCsv(text);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('Participant Roster (${_participants.length})', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      TextButton.icon(
                        icon: const Icon(Icons.delete_sweep, color: Colors.red),
                        label: const Text('Clear All', style: TextStyle(color: Colors.red)),
                        onPressed: () => setState(() => _participants.clear()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _participants.isEmpty
                        ? const Center(child: Text('Add players to start building your bracket.', style: TextStyle(color: Colors.grey)))
                        : ReorderableListView.builder(
                            itemCount: _participants.length,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) newIndex -= 1;
                                final item = _participants.removeAt(oldIndex);
                                _participants.insert(newIndex, item);
                                for (int i = 0; i < _participants.length; i++) {
                                  _participants[i] = _participants[i].copyWith(seedNumber: i + 1);
                                }
                              });
                            },
                            itemBuilder: (context, index) {
                              final p = _participants[index];
                              return Card(
                                key: ValueKey(p.id),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(backgroundColor: Colors.blueAccent, child: Text('${index + 1}')),
                                  title: Text('${p.firstName.toUpperCase()} ${p.lastName.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text([
                                    if (p.schoolOrDojangName != null && p.schoolOrDojangName!.isNotEmpty) 'Dojang: ${p.schoolOrDojangName}',
                                    if (p.registrationId != null && p.registrationId!.isNotEmpty) 'Reg: ${p.registrationId}',
                                  ].join(' | ')),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.drag_handle, color: Colors.grey),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Colors.redAccent),
                                        onPressed: () => _removeParticipant(index),
                                      ),
                                    ]
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BracketViewerScreen extends StatefulWidget {
  final List<ParticipantEntity> participants;
  final bool dojangSeparation;
  final String format;
  final bool includeThirdPlaceMatch;
  final TournamentInfo tournamentInfo;

  const BracketViewerScreen({
    super.key,
    required this.participants,
    required this.dojangSeparation,
    required this.format,
    required this.includeThirdPlaceMatch,
    required this.tournamentInfo,
  });

  @override
  State<BracketViewerScreen> createState() => _BracketViewerScreenState();
}

class _BracketViewerScreenState extends State<BracketViewerScreen> {
  List<MatchEntity>? _matches;
  final Uuid _uuid = const Uuid();
  final GlobalKey _printKey = GlobalKey();

  final _singleGenerator = SingleEliminationBracketGeneratorServiceImplementation(const Uuid());
  final _doubleGenerator = DoubleEliminationBracketGeneratorServiceImplementation(const Uuid());

  @override
  void initState() {
    super.initState();
    _generateBracket();
  }

  List<String> _seedParticipants() {
    if (!widget.dojangSeparation) return widget.participants.map((e) => e.id).toList();

    final dojangMap = <String, List<ParticipantEntity>>{};
    final noDojang = <ParticipantEntity>[];

    for (var p in widget.participants) {
      if (p.schoolOrDojangName == null || p.schoolOrDojangName!.isEmpty) {
        noDojang.add(p);
      } else {
        dojangMap.putIfAbsent(p.schoolOrDojangName!, () => []).add(p);
      }
    }

    var groups = dojangMap.values.toList()..sort((a, b) => b.length.compareTo(a.length));
    List<ParticipantEntity> balanced = [];
    bool extracted = true;
    while (extracted) {
      extracted = false;
      for (var group in groups) {
        if (group.isNotEmpty) {
          balanced.add(group.removeAt(0));
          extracted = true;
        }
      }
    }
    balanced.addAll(noDojang);

    // Provide the balanced list directly to the generators. 
    // The WT seeding algorithm naturally spaces adjacent seeds apart (e.g. 1 & 2 meet in finals, 1 & 3 in semi-finals).
    // The round-robin extraction creates an interleaved list [A1, B1, C1, A2, B2, ...].
    return balanced.map((p) => p.id).toList();
  }

  void _generateBracket() async {
    final divisionId = _uuid.v4();
    final bracketId = _uuid.v4();
    final participantIds = _seedParticipants();

    List<MatchEntity> generatedMatches;
    if (widget.format.contains('Double')) {
      final res = _doubleGenerator.generate(
        divisionId: divisionId,
        participantIds: participantIds,
        winnersBracketId: bracketId,
        losersBracketId: _uuid.v4(),
        includeResetMatch: true,
      );
      generatedMatches = res.allMatches;
    } else {
      final res = _singleGenerator.generate(
        divisionId: divisionId,
        participantIds: participantIds,
        bracketId: bracketId,
        includeThirdPlaceMatch: widget.includeThirdPlaceMatch, 
      );
      generatedMatches = res.matches;
    }

    setState(() {
      _matches = generatedMatches;
    });
  }

  ParticipantEntity? _getParticipant(String? id) {
    if (id == null) return null;
    try {
      return widget.participants.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void _scoreMatch(MatchEntity match) {
    if (match.status != MatchStatus.completed && match.participantRedId != null && match.participantBlueId != null) {
      showDialog(
        context: context,
        builder: (context) {
          final red = _getParticipant(match.participantRedId);
          final blue = _getParticipant(match.participantBlueId);
          MatchResultType selectedResult = MatchResultType.points;

          return StatefulBuilder(
            builder: (context, setState) {
               return AlertDialog(
                title: const Text('Score Match / Result', style: TextStyle(fontSize: 16)),
                contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<MatchResultType>(
                        value: selectedResult,
                        isExpanded: true,
                        items: MatchResultType.values.where((r) => r != MatchResultType.bye).map((r) {
                          return DropdownMenuItem(value: r, child: Text(r.name.toUpperCase()));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedResult = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                              onPressed: () => _declareWinner(match, match.participantRedId, selectedResult),
                              child: Text('${red?.lastName ?? "Red"}\nWINS', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('VS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                              onPressed: () => _declareWinner(match, match.participantBlueId, selectedResult),
                              child: Text('${blue?.lastName ?? "Blue"}\nWINS', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.warning, color: Colors.orange, size: 18),
                        label: const Text('No-Show', style: TextStyle(fontSize: 12)),
                        onPressed: () {
                           Navigator.pop(context);
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select the winning player via Withdrawal for No-Show')));
                        },
                      )
                    ],
                  ),
                ),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
              );
            }
          );
        }
      );
    } else if (match.status == MatchStatus.completed) {
      if (match.resultType == MatchResultType.bye) return;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Match Completed'),
            content: const Text('Do you want to reset this match?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    _resetMatch(match);
                    Navigator.pop(context);
                  },
                  child: const Text('Reset Score')),
            ],
          )
      );
    }
  }

  void _declareWinner(MatchEntity match, String? winnerId, MatchResultType resultType) {
    Navigator.pop(context);
    _processMatchResult(match, winnerId, resultType);
  }

  void _processMatchResult(MatchEntity match, String? winnerId, MatchResultType resultType) {
    setState(() {
      final matchIndex = _matches!.indexWhere((m) => m.id == match.id);
      if (matchIndex != -1) {
        _matches![matchIndex] = _matches![matchIndex].copyWith(
          winnerId: winnerId,
          status: MatchStatus.completed,
          resultType: resultType,
        );
      }

      if (match.winnerAdvancesToMatchId != null) {
        final nextMatchIndex = _matches!.indexWhere((m) => m.id == match.winnerAdvancesToMatchId);
        if (nextMatchIndex != -1) {
          var nextMatch = _matches![nextMatchIndex];
          if (nextMatch.participantRedId == null) {
            nextMatch = nextMatch.copyWith(participantRedId: winnerId);
          } else if (nextMatch.participantBlueId == null) {
            nextMatch = nextMatch.copyWith(participantBlueId: winnerId);
          } else {
            if (nextMatch.participantRedId == match.participantRedId || nextMatch.participantRedId == match.participantBlueId) {
              nextMatch = nextMatch.copyWith(participantRedId: winnerId);
            } else {
              nextMatch = nextMatch.copyWith(participantBlueId: winnerId);
            }
          }
          _matches![nextMatchIndex] = nextMatch;

          if (nextMatch.notes != null && nextMatch.notes!.startsWith('PHANTOM_BYE_1')) {
            // Auto advance since the other player is a phantom
            WidgetsBinding.instance.addPostFrameCallback((_) {
               _processMatchResult(nextMatch, winnerId, MatchResultType.bye);
            });
          }
        }
      }
      
      if (match.loserAdvancesToMatchId != null) {
         final loserId = (winnerId == match.participantRedId) ? match.participantBlueId : match.participantRedId;
         if (loserId != null) {
           final nextMatchIndex = _matches!.indexWhere((m) => m.id == match.loserAdvancesToMatchId);
           if (nextMatchIndex != -1) {
               var nextMatch = _matches![nextMatchIndex];
               if (nextMatch.participantRedId == null) {
                  nextMatch = nextMatch.copyWith(participantRedId: loserId);
               } else if (nextMatch.participantBlueId == null) {
                  nextMatch = nextMatch.copyWith(participantBlueId: loserId);
               }
               _matches![nextMatchIndex] = nextMatch;

               if (nextMatch.notes != null && nextMatch.notes!.startsWith('PHANTOM_BYE_1')) {
                  // Auto advance since the other player is a phantom
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                     _processMatchResult(nextMatch, loserId, MatchResultType.bye);
                  });
               }
           }
         }
      }
    });
  }

  void _resetMatch(MatchEntity match) {
    if (match.resultType == MatchResultType.bye) return;
    setState(() {
      final matchIndex = _matches!.indexWhere((m) => m.id == match.id);
      if (matchIndex != -1) {
        _matches![matchIndex] = _matches![matchIndex].copyWith(
          winnerId: null,
          status: MatchStatus.pending,
          resultType: null,
        );
      }
      _cascadeRemove(match.winnerAdvancesToMatchId, match.winnerId);
      if (match.loserAdvancesToMatchId != null && match.winnerId != null) {
        final loserId = (match.winnerId == match.participantRedId) ? match.participantBlueId : match.participantRedId;
        _cascadeRemove(match.loserAdvancesToMatchId, loserId);
      }
    });
  }

  void _cascadeRemove(String? nextMatchId, String? idToRemove) {
    while (nextMatchId != null && idToRemove != null) {
      final nextIdx = _matches!.indexWhere((m) => m.id == nextMatchId);
      if (nextIdx == -1) break;
      final nextM = _matches![nextIdx];
      if (nextM.participantRedId == idToRemove) {
          _matches![nextIdx] = nextM.copyWith(participantRedId: null, winnerId: null, status: MatchStatus.pending);
      } else if (nextM.participantBlueId == idToRemove) {
          _matches![nextIdx] = nextM.copyWith(participantBlueId: null, winnerId: null, status: MatchStatus.pending);
      } else {
        break; 
      }
      idToRemove = nextM.winnerId;
      nextMatchId = nextM.winnerAdvancesToMatchId;
    }
  }

  Future<void> _exportPdf() async {
    showDialog(context: context, builder: (ctx) => const Center(child: CircularProgressIndicator()));
    try {
      final boundary = _printKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final doc = pw.Document();
      final pdfImage = pw.MemoryImage(pngBytes);
      doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(16),
          build: (context) => pw.Center(child: pw.Image(pdfImage, fit: pw.BoxFit.contain)),
      ));
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
      if (mounted) Navigator.pop(context);
    } catch(e) {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tournament Bracket (${widget.participants.length} Players)'),
        actions: [
          IconButton(icon: const Icon(Icons.picture_as_pdf), tooltip: 'Export PDF', onPressed: _exportPdf),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Regenerate',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Regenerate Bracket?'),
                  content: const Text('This will reset ALL match results and create a new bracket. Are you sure?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () { Navigator.pop(ctx); _generateBracket(); },
                      child: const Text('Regenerate'),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: _matches == null
          ? const Center(child: CircularProgressIndicator())
          : InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(500),
              minScale: 0.1,
              maxScale: 2.0,
              child: TieSheetCanvasWidget(
                tournamentInfo: widget.tournamentInfo,
                matches: _matches!,
                participants: widget.participants,
                bracketType: widget.format,
                onMatchTap: (matchId) {
                  final match = _matches!.firstWhere((m) => m.id == matchId);
                  _scoreMatch(match);
                },
                printKey: _printKey,
                includeThirdPlaceMatch: widget.includeThirdPlaceMatch,
              ),
            ),
    );
  }
}

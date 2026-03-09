import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/tournament_info.dart';
import '../../../participant/domain/entities/participant_entity.dart';

/// A widget that renders a TKD tie sheet using CustomPainter.
/// Replicates the official World Taekwondo federation bracket format.
class TieSheetCanvasWidget extends StatefulWidget {
  final TournamentInfo tournamentInfo;
  final List<MatchEntity> matches;
  final List<ParticipantEntity> participants;
  final String bracketType;
  final void Function(String matchId) onMatchTap;
  final GlobalKey printKey;
  final bool includeThirdPlaceMatch;

  const TieSheetCanvasWidget({
    super.key,
    required this.tournamentInfo,
    required this.matches,
    required this.participants,
    required this.bracketType,
    required this.onMatchTap,
    required this.printKey,
    required this.includeThirdPlaceMatch,
  });

  @override
  State<TieSheetCanvasWidget> createState() => _TieSheetCanvasWidgetState();
}

class _TieSheetCanvasWidgetState extends State<TieSheetCanvasWidget> {
  List<MapEntry<String, Rect>> _hitAreas = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _rebuildHitAreas());
  }

  @override
  void didUpdateWidget(covariant TieSheetCanvasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _rebuildHitAreas();
    });
  }

  void _rebuildHitAreas() {
    final painter = _createPainter();
    final size = painter.calculateCanvasSize();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size.width, size.height));
    painter.paint(canvas, size);
    recorder.endRecording();
    if (mounted) {
      setState(() => _hitAreas = List.from(painter.matchHitAreas));
    }
  }

  TieSheetPainter _createPainter() => TieSheetPainter(
    tournamentInfo: widget.tournamentInfo,
    matches: widget.matches,
    participants: widget.participants,
    bracketType: widget.bracketType,
    includeThirdPlaceMatch: widget.includeThirdPlaceMatch,
  );

  @override
  Widget build(BuildContext context) {
    final painter = _createPainter();
    final size = painter.calculateCanvasSize();

    return RepaintBoundary(
      key: widget.printKey,
      child: GestureDetector(
        onTapDown: (details) {
          for (final entry in _hitAreas) {
            if (entry.value.contains(details.localPosition)) {
              widget.onMatchTap(entry.key);
              return;
            }
          }
        },
        child: CustomPaint(
          size: size,
          painter: painter,
          willChange: true,
          child: SizedBox(width: size.width, height: size.height),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// TIE SHEET PAINTER — Replicates official WT/federation bracket format
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  Reference image layout (single elimination, 14 players):
//
//  ┌──┬────────────────────┬──────────────┐
//  │No│  NAME (bold, caps) │  REG-ID      │───── horizontal line ──→ ┐
//  ├──┼────────────────────┼──────────────┤                          ├─ junction ─→
//  │No│  NAME              │  REG-ID      │───── horizontal line ──→ ┘
//  ├──┤                    │              │              ↑ pairGap ↑
//  │No│  NAME              │  REG-ID      │─────────────────────── → ┐
//  ├──┼────────────────────┼──────────────┤                          ├─ junction ─→
//  │No│  NAME              │  REG-ID      │─────────────────────── → ┘
//  └──┴────────────────────┴──────────────┘
//
//  Key rules from the reference:
//  - Participants are in PAIRS (1+2, 3+4, 5+6...) feeding into R1 matches
//  - BETWEEN pairs: a visible gap (~12px)
//  - Horizontal line from each participant extends to the junction X position
//  - Junction = vertical bar connecting top+bottom inputs, with output line
//  - B (Blue) label above top input line, R (Red) label below bottom
//  - Match number to the right of the junction vertical bar
//  - Winner name written along the output line (when scored)
//

class TieSheetPainter extends CustomPainter {
  final TournamentInfo tournamentInfo;
  final List<MatchEntity> matches;
  final List<ParticipantEntity> participants;
  final String bracketType;
  final bool includeThirdPlaceMatch;

  /// Populated during paint() — matchId → tappable bounding rect
  final List<MapEntry<String, Rect>> matchHitAreas = [];
  final Map<String, int> _matchGlobalNumbers = {};
  /// Maps participantId or matchId → their output point for line routing
  final Map<String, Offset> _nodeOffsets = {};

  // ─── Layout Constants (tuned to match reference image) ─────
  static const double rowH = 38.0;        // Height per participant row
  static const double pairGap = 14.0;     // Gap BETWEEN pairs
  static const double noColW = 30.0;      // "No." column width
  static const double nameColW = 200.0;   // Name column width
  static const double regIdColW = 130.0;  // Registration ID column
  static const double roundColW = 120.0;  // Width per bracket round column
  static const double headerH = 90.0;     // Tournament header area
  static const double subHeaderH = 22.0;  // "No | JUNIOR | BOYS" bar
  static const double medalH = 120.0;     // Medal table height
  static const double margin = 25.0;      // Page margin
  static const double centerGap = 60.0;   // Gap between left & right (double elim)

  static double get listW => noColW + nameColW + regIdColW;

  TieSheetPainter({
    required this.tournamentInfo,
    required this.matches,
    required this.participants,
    required this.bracketType,
    required this.includeThirdPlaceMatch,
  });

  bool get _isDouble => bracketType.contains('Double');

  // ─── Match classification ──────────────────────────────────
  List<MatchEntity> _getWinnersMatches() {
    if (!_isDouble) {
      return matches.where((m) {
        // Exclude 3rd place match
        final winRounds = matches.map((mm) => mm.roundNumber).reduce(max);
        return !(m.roundNumber == winRounds && m.matchNumberInRound == 2);
      }).toList();
    }
    final losersIds = _traceLosersIds();
    return matches.where((m) => !losersIds.contains(m.id)).toList();
  }

  List<MatchEntity> _getLosersMatches() {
    if (!_isDouble) return [];
    return matches.where((m) => _traceLosersIds().contains(m.id)).toList();
  }

  Set<String> _traceLosersIds() {
    final loserTargetIds = <String>{};
    for (final m in matches) {
      if (m.loserAdvancesToMatchId != null) {
        loserTargetIds.add(m.loserAdvancesToMatchId!);
      }
    }
    final result = <String>{};
    final queue = loserTargetIds.toList();
    while (queue.isNotEmpty) {
      final id = queue.removeLast();
      if (result.add(id)) {
        final m = matches.where((match) => match.id == id).firstOrNull;
        if (m != null && m.winnerAdvancesToMatchId != null) {
          queue.add(m.winnerAdvancesToMatchId!);
        }
      }
    }
    return result;
  }

  int _maxRound(List<MatchEntity> ms) {
    if (ms.isEmpty) return 1;
    return ms.map((m) => m.roundNumber).reduce(max);
  }

  Map<int, List<MatchEntity>> _groupByRound(List<MatchEntity> list) {
    final map = <int, List<MatchEntity>>{};
    for (var m in list) {
      map.putIfAbsent(m.roundNumber, () => []).add(m);
    }
    for (var l in map.values) {
      l.sort((a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound));
    }
    return map;
  }

  // ─── Participant Y-position: PAIR-BASED ────────────────────
  /// Y for participant at index [i] (0-based)
  double _participantY(int i, double tableTop) {
    final pairIdx = i ~/ 2;
    return tableTop + (i * rowH) + (pairIdx * pairGap);
  }

  /// Center-line Y for a participant row
  double _participantCenterY(int i, double tableTop) {
    return _participantY(i, tableTop) + rowH / 2;
  }

  double _tableHeight() {
    final n = max(participants.length, 2);
    return _participantY(n - 1, 0) + rowH;
  }

  // ─── Canvas Size ───────────────────────────────────────────
  Size calculateCanvasSize() {
    final winnersMatches = _getWinnersMatches();
    final winRounds = _maxRound(winnersMatches);

    double width = margin * 2 + listW + (winRounds * roundColW) + 120;
    if (_isDouble) {
      final losersMatches = _getLosersMatches();
      final lRounds = _maxRound(losersMatches);
      width = margin * 2 + listW + (winRounds * roundColW) + centerGap + (lRounds * roundColW) + listW;
    }

    final height = margin + headerH + subHeaderH + _tableHeight() + 60 + medalH + margin;
    return Size(max(width, 700), max(height, 500));
  }

  // ─── Global match numbering (sorted by round, then index) ──
  void _buildGlobalMatchNumbers() {
    _matchGlobalNumbers.clear();
    final sorted = List<MatchEntity>.from(matches)
      ..sort((a, b) {
        if (a.roundNumber != b.roundNumber) return a.roundNumber.compareTo(b.roundNumber);
        return a.matchNumberInRound.compareTo(b.matchNumberInRound);
      });
    for (var i = 0; i < sorted.length; i++) {
      _matchGlobalNumbers[sorted[i].id] = i + 1;
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  PAINT
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  void paint(Canvas canvas, Size size) {
    matchHitAreas.clear();
    _nodeOffsets.clear();
    _buildGlobalMatchNumbers();

    // White background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white);

    final pen = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // ── 1. HEADER ──
    double y = margin;
    y = _paintHeader(canvas, size, y);

    // ── 2. SUB-HEADER BAR ("No. | JUNIOR | BOYS") ──
    final subY = y;
    // Full-width line
    canvas.drawLine(Offset(margin, subY), Offset(size.width - margin, subY), pen);
    // "No." box
    canvas.drawRect(Rect.fromLTWH(margin, subY, noColW, subHeaderH), pen);
    _drawText(canvas, 'No.', margin + noColW / 2, subY + 4, _bold(10), center: true);

    // Category & Division labels
    final bracketAreaLeft = margin + listW;
    final bracketAreaW = size.width - margin * 2 - listW;
    if (tournamentInfo.categoryLabel.isNotEmpty) {
      _drawText(canvas, tournamentInfo.categoryLabel.toUpperCase(),
        bracketAreaLeft + bracketAreaW * 0.3, subY + 4, _bold(12), center: true);
    }
    if (tournamentInfo.divisionLabel.isNotEmpty) {
      _drawText(canvas, tournamentInfo.divisionLabel.toUpperCase(),
        bracketAreaLeft + bracketAreaW * 0.65, subY + 4, _bold(12), center: true);
    }
    // Bottom line
    canvas.drawLine(Offset(margin, subY + subHeaderH), Offset(size.width - margin, subY + subHeaderH), pen);
    y = subY + subHeaderH;

    final tableTop = y;

    // ── 3. LEFT PARTICIPANT TABLE ──
    for (var i = 0; i < participants.length; i++) {
      _paintParticipantRow(canvas, i + 1, participants[i], margin, _participantY(i, tableTop), pen);
      // Register the output point of each participant (right edge of row, center Y)
      _nodeOffsets[participants[i].id] = Offset(
        margin + listW,
        _participantCenterY(i, tableTop),
      );
    }
    // Bottom border of last row
    if (participants.isNotEmpty) {
      final lastBottom = _participantY(participants.length - 1, tableTop) + rowH;
      canvas.drawLine(Offset(margin, lastBottom), Offset(margin + listW, lastBottom), pen);
    }

    // ── 4. WINNERS BRACKET LINES ──
    final wMatches = _getWinnersMatches();
    final winRounds = _maxRound(wMatches);
    final winByRound = _groupByRound(wMatches);

    // Draw rounds 1..N, left to right
    for (var r = 1; r <= winRounds; r++) {
      final roundMatches = winByRound[r] ?? [];
      final junctionX = margin + listW + (r * roundColW);

      for (final match in roundMatches) {
        _paintJunction(canvas, match, junctionX, pen, mirrored: false);
      }
    }

    // ── 5. LOSERS / RIGHT BRACKET (Double Elim) ──
    if (_isDouble) {
      final lMatches = _getLosersMatches();
      final lByRound = _groupByRound(lMatches);
      final lRounds = _maxRound(lMatches);
      final rightEdge = size.width - margin;

      // Right-side participant table
      _paintRightSideLabels(canvas, lByRound, rightEdge, tableTop, pen);

      for (var r = 1; r <= lRounds; r++) {
        final roundMatches = lByRound[r] ?? [];
        final junctionX = rightEdge - (r * roundColW);

        for (final match in roundMatches) {
          _paintJunction(canvas, match, junctionX, pen, mirrored: true);
        }
      }
    }

    // ── 6. 3RD PLACE MATCH ──
    if (includeThirdPlaceMatch && !_isDouble) {
      final allRounds = matches.map((m) => m.roundNumber).reduce(max);
      final thirdMatch = matches.where((m) =>
        m.roundNumber == allRounds && m.matchNumberInRound == 2
      ).firstOrNull;
      if (thirdMatch != null) {
        _paint3rdPlaceMatch(canvas, thirdMatch, pen, tableTop);
      }
    }

    // ── 7. MEDAL TABLE ──
    _paintMedalTable(canvas, size, pen);
  }

  // ─── HEADER ────────────────────────────────────────────────
  double _paintHeader(Canvas canvas, Size size, double startY) {
    var y = startY;
    final title = (tournamentInfo.tournamentName.isNotEmpty
        ? tournamentInfo.tournamentName
        : 'TOURNAMENT NAME').toUpperCase();
    _drawText(canvas, title, size.width / 2, y, _bold(16), center: true);
    y += 22;

    if (tournamentInfo.dateRange.isNotEmpty || tournamentInfo.venue.isNotEmpty) {
      final sub = [tournamentInfo.dateRange, tournamentInfo.venue]
          .where((s) => s.isNotEmpty).join(', ');
      _drawText(canvas, sub, size.width / 2, y, _normal(10), center: true);
      y += 18;
    }
    if (tournamentInfo.organizer.isNotEmpty) {
      _drawText(canvas, 'Organised by : ${tournamentInfo.organizer.toUpperCase()}',
        size.width / 2, y, _bold(13), center: true);
      y += 24;
    } else {
      y += 18;
    }
    return y;
  }

  // ─── PARTICIPANT ROW ───────────────────────────────────────
  //
  //  ┌──┬─────────────────────┬───────────────┐
  //  │No│  NAME (bold/caps)   │  REG-ID       │──── horizontal line ──→
  //  └──┴─────────────────────┴───────────────┘
  //
  void _paintParticipantRow(Canvas canvas, int idx, ParticipantEntity p,
      double x, double y, Paint pen) {
    final right = x + listW;

    // Borders
    canvas.drawLine(Offset(x, y), Offset(right, y), pen);              // top
    canvas.drawLine(Offset(x, y), Offset(x, y + rowH), pen);           // left
    canvas.drawLine(Offset(x + noColW, y), Offset(x + noColW, y + rowH), pen);
    canvas.drawLine(Offset(x + noColW + nameColW, y),
                    Offset(x + noColW + nameColW, y + rowH), pen);
    canvas.drawLine(Offset(right, y), Offset(right, y + rowH), pen);   // right

    // Serial number
    _drawText(canvas, '$idx', x + noColW / 2, y + rowH / 2 - 6, _normal(10), center: true);

    // Name (uppercase, bold)
    final name = '${p.firstName} ${p.lastName}'.toUpperCase();
    _drawText(canvas, name, x + noColW + 6, y + rowH / 2 - 6, _bold(11));

    // Reg ID (right-aligned)
    if (p.registrationId != null && p.registrationId!.isNotEmpty) {
      _drawText(canvas, p.registrationId!, right - 6, y + rowH / 2 - 5,
        _normal(9), alignRight: true);
    }

    // Horizontal line extending RIGHT from the row into bracket area
    // This line goes all the way to where the first round junction will be
    final lineY = y + rowH / 2;
    final lineEnd = margin + listW + roundColW; // extends to first junction X
    canvas.drawLine(Offset(right, lineY), Offset(lineEnd, lineY), pen);
  }

  // ─── JUNCTION (match connector) ────────────────────────────
  //
  //  Reference:
  //     ────────────────┐         B
  //                     │── match# ────→ (output to next round)
  //     ────────────────┘         R
  //
  //  - Vertical bar connects top and bottom input lines
  //  - Match number to the right of vertical bar, centered vertically
  //  - B label above the top input, R below bottom input
  //  - Output line extends right from junction midpoint to the next junction X
  //
  void _paintJunction(Canvas canvas, MatchEntity match, double junctionX,
      Paint pen, {required bool mirrored}) {

    final isBye = match.resultType == MatchResultType.bye;
    
    // ─ BYE MATCH: straight-through line, no junction vertical bar ─
    if (isBye) {
      final topIn = _resolveInputOffset(match, isTopSlot: true);
      if (topIn != null) {
        // Draw horizontal line from participant to junction X
        canvas.drawLine(topIn, Offset(junctionX, topIn.dy), pen);
        // Output: straight through at the same Y
        final nextJunctionX = mirrored
            ? junctionX - roundColW
            : junctionX + roundColW;
        canvas.drawLine(Offset(junctionX, topIn.dy), Offset(nextJunctionX, topIn.dy), pen);
        
        // Register output point at the participant's Y (straight through)
        _nodeOffsets[match.id] = Offset(junctionX, topIn.dy);

        // Winner name along the output line
        if (match.winnerId != null) {
          final winner = participants.where((p) => p.id == match.winnerId).firstOrNull;
          if (winner != null) {
            final wName = '${winner.firstName} ${winner.lastName}'.toUpperCase();
            if (!mirrored) {
              _drawText(canvas, wName, junctionX + roundColW * 0.15, topIn.dy - 14, _bold(9));
            } else {
              _drawText(canvas, wName, junctionX - roundColW * 0.15, topIn.dy - 14, _bold(9),
                alignRight: true);
            }
          }
        }

        // Hit area
        matchHitAreas.add(MapEntry(
          match.id,
          Rect.fromCenter(
            center: Offset(junctionX, topIn.dy),
            width: roundColW * 0.6,
            height: 35,
          ),
        ));
      }
      return;
    }
    
    // ─ NORMAL MATCH: full junction with vertical bar ─
    final topIn = _resolveInputOffset(match, isTopSlot: true);
    final botIn = _resolveInputOffset(match, isTopSlot: false);

    Offset effectiveTop, effectiveBot;
    if (topIn != null && botIn != null) {
      effectiveTop = topIn;
      effectiveBot = botIn;
    } else if (topIn != null) {
      effectiveTop = topIn;
      effectiveBot = Offset(topIn.dx, topIn.dy + rowH + pairGap);
    } else if (botIn != null) {
      effectiveBot = botIn;
      effectiveTop = Offset(botIn.dx, botIn.dy - rowH - pairGap);
    } else {
      // Fallback estimation
      final estY = 100.0 + (match.matchNumberInRound * 2 - 1) * (rowH + pairGap / 2);
      effectiveTop = Offset(junctionX, estY);
      effectiveBot = Offset(junctionX, estY + rowH * 2);
    }

    final midY = (effectiveTop.dy + effectiveBot.dy) / 2;
    final output = Offset(junctionX, midY);
    _nodeOffsets[match.id] = output;

    // ─ Horizontal lines from inputs to vertical bar ─
    canvas.drawLine(effectiveTop, Offset(junctionX, effectiveTop.dy), pen);
    canvas.drawLine(effectiveBot, Offset(junctionX, effectiveBot.dy), pen);

    // ─ Vertical bar ─
    canvas.drawLine(
      Offset(junctionX, effectiveTop.dy),
      Offset(junctionX, effectiveBot.dy), pen);

    // ─ Output horizontal line toward next round ─
    final nextJunctionX = mirrored
        ? junctionX - roundColW
        : junctionX + roundColW;
    canvas.drawLine(output, Offset(nextJunctionX, midY), pen);

    // ─ B / R labels (WT convention: B=Blue/Chong on top, R=Red/Hong on bottom) ─
    final bStyle = const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10);
    final rStyle = const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10);

    if (!mirrored) {
      // B above top input line, just to the right of junction
      _drawText(canvas, 'B', junctionX + 4, effectiveTop.dy - 14, bStyle);
      // R below bottom input line
      _drawText(canvas, 'R', junctionX + 4, effectiveBot.dy + 2, rStyle);
    } else {
      // Mirrored: B right of junction (above), R right of junction (below)
      _drawText(canvas, 'B', junctionX - 14, effectiveTop.dy - 14, bStyle);
      _drawText(canvas, 'R', junctionX - 14, effectiveBot.dy + 2, rStyle);
    }

    // ─ Match number ─
    final gNum = _matchGlobalNumbers[match.id];
    if (gNum != null) {
      if (!mirrored) {
        // Below the output line, to the right of the junction
        _drawText(canvas, '$gNum', junctionX + 4, midY + 2, _bold(9));
      } else {
        _drawText(canvas, '$gNum', junctionX - 14, midY + 2, _bold(9));
      }
    }

    // ─ Winner name along the output line ─
    if (match.winnerId != null) {
      final winner = participants.where((p) => p.id == match.winnerId).firstOrNull;
      if (winner != null) {
        final wName = '${winner.firstName} ${winner.lastName}'.toUpperCase();
        if (!mirrored) {
          _drawText(canvas, wName, junctionX + roundColW * 0.15, midY - 14, _bold(9));
        } else {
          _drawText(canvas, wName, junctionX - roundColW * 0.15, midY - 14, _bold(9),
            alignRight: true);
        }
      }
    }

    // ─ Hit area ─
    matchHitAreas.add(MapEntry(
      match.id,
      Rect.fromCenter(
        center: output,
        width: roundColW * 0.6,
        height: max(35, (effectiveBot.dy - effectiveTop.dy).abs() + 10),
      ),
    ));
  }

  // ─── RIGHT-SIDE PARTICIPANT LABELS (Double Elim) ───────────
  void _paintRightSideLabels(Canvas canvas, Map<int, List<MatchEntity>> losByRound,
      double rightEdge, double tableTop, Paint pen) {
    final r1Matches = losByRound[1] ?? [];
    final seenIds = <String>{};
    var idx = 0;

    for (final m in r1Matches) {
      for (final pId in [m.participantRedId, m.participantBlueId]) {
        if (pId != null && seenIds.add(pId)) {
          final p = participants.where((pp) => pp.id == pId).firstOrNull;
          if (p != null) {
            final rowY = _participantY(idx, tableTop);
            final x = rightEdge - nameColW;
            // Draw row box
            canvas.drawRect(Rect.fromLTWH(x, rowY, nameColW, rowH), pen);
            // Name right-aligned
            _drawText(canvas, '${p.firstName} ${p.lastName}'.toUpperCase(),
              rightEdge - 6, rowY + rowH / 2 - 6, _bold(10), alignRight: true);
            // Line extending left
            final lineY = rowY + rowH / 2;
            canvas.drawLine(Offset(x - roundColW, lineY), Offset(x, lineY), pen);
            _nodeOffsets['right_${p.id}'] = Offset(x - roundColW, lineY);
            idx++;
          }
        }
      }
    }
  }

  // ─── RESOLVE INPUT OFFSET ──────────────────────────────────
  Offset? _resolveInputOffset(MatchEntity match, {required bool isTopSlot}) {
    final pId = isTopSlot ? match.participantRedId : match.participantBlueId;
    if (pId != null) {
      if (_nodeOffsets.containsKey(pId)) return _nodeOffsets[pId];
      if (_nodeOffsets.containsKey('right_$pId')) return _nodeOffsets['right_$pId'];
    }

    // Find feeder matches (winnerAdvancesTo or loserAdvancesTo)
    final feeders = matches.where((m) => m.winnerAdvancesToMatchId == match.id).toList();
    if (feeders.isEmpty) {
      final loserFeeders = matches.where((m) => m.loserAdvancesToMatchId == match.id).toList();
      if (loserFeeders.isEmpty) return null;
      loserFeeders.sort((a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound));
      if (loserFeeders.length == 1) return _nodeOffsets[loserFeeders.first.id];
      return isTopSlot ? _nodeOffsets[loserFeeders.first.id] : _nodeOffsets[loserFeeders.last.id];
    }
    feeders.sort((a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound));
    if (feeders.length == 1) return _nodeOffsets[feeders.first.id];
    return isTopSlot ? _nodeOffsets[feeders.first.id] : _nodeOffsets[feeders.last.id];
  }

  // ─── 3RD PLACE MATCH ──────────────────────────────────────
  void _paint3rdPlaceMatch(Canvas canvas, MatchEntity m, Paint pen, double tableTop) {
    final allRounds = matches.map((mm) => mm.roundNumber).reduce(max);
    final finals = matches.where((mm) =>
      mm.roundNumber == allRounds && mm.matchNumberInRound == 1
    ).firstOrNull;
    if (finals == null || !_nodeOffsets.containsKey(finals.id)) return;

    final fPos = _nodeOffsets[finals.id]!;
    final x = fPos.dx;
    final y = fPos.dy + rowH * 4;

    // Two input lines + vertical bar + output
    canvas.drawLine(Offset(x - 50, y - 20), Offset(x, y - 20), pen);
    canvas.drawLine(Offset(x - 50, y + 20), Offset(x, y + 20), pen);
    canvas.drawLine(Offset(x, y - 20), Offset(x, y + 20), pen);
    canvas.drawLine(Offset(x, y), Offset(x + 30, y), pen);

    _nodeOffsets[m.id] = Offset(x, y);
    matchHitAreas.add(MapEntry(m.id,
      Rect.fromCenter(center: Offset(x, y), width: 60, height: 50)));

    _drawText(canvas, '3rd Place', x - 25, y - 34, _bold(9), center: true);
    _drawText(canvas, 'B', x + 4, y - 34,
      const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 9));
    _drawText(canvas, 'R', x + 4, y + 22,
      const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 9));

    if (m.winnerId != null) {
      final w = participants.where((p) => p.id == m.winnerId).firstOrNull;
      if (w != null) {
        _drawText(canvas, '${w.firstName} ${w.lastName}'.toUpperCase(),
          x + 35, y - 6, _bold(9));
      }
    }
  }

  // ─── MEDAL TABLE ───────────────────────────────────────────
  void _paintMedalTable(Canvas canvas, Size size, Paint pen) {
    const tableW = 420.0;
    const mRowH = 32.0;
    const nameW = 230.0;
    const medalLabelW = 70.0;
    const leftBlank = tableW - nameW - medalLabelW;

    final x = (size.width - tableW) / 2;
    final y = size.height - medalH - margin + 10;

    for (var row = 0; row < 3; row++) {
      final rY = y + row * mRowH;
      canvas.drawRect(Rect.fromLTWH(x, rY, tableW, mRowH), pen);
      canvas.drawLine(Offset(x + leftBlank, rY), Offset(x + leftBlank, rY + mRowH), pen);
      canvas.drawLine(Offset(x + leftBlank + nameW, rY), Offset(x + leftBlank + nameW, rY + mRowH), pen);
    }

    _drawText(canvas, 'Gold',   x + leftBlank + nameW + medalLabelW / 2, y + 9, _bold(12), center: true);
    _drawText(canvas, 'Silver', x + leftBlank + nameW + medalLabelW / 2, y + mRowH + 9, _bold(12), center: true);
    _drawText(canvas, 'Bronze', x + leftBlank + nameW + medalLabelW / 2, y + mRowH * 2 + 9, _bold(12), center: true);

    // Auto-fill results
    final allRounds = matches.map((m) => m.roundNumber).reduce(max);
    final finals = matches.where((m) => m.roundNumber == allRounds && m.matchNumberInRound == 1).firstOrNull;
    if (finals != null && finals.winnerId != null) {
      final gold = _findP(finals.winnerId);
      final silverId = finals.winnerId == finals.participantRedId ? finals.participantBlueId : finals.participantRedId;
      final silver = _findP(silverId);
      if (gold != null) _drawText(canvas, _pName(gold), x + leftBlank + 8, y + 9, _normal(10));
      if (silver != null) _drawText(canvas, _pName(silver), x + leftBlank + 8, y + mRowH + 9, _normal(10));
    }
    final thirdM = matches.where((m) => m.roundNumber == allRounds && m.matchNumberInRound == 2).firstOrNull;
    if (thirdM?.winnerId != null) {
      final bronze = _findP(thirdM!.winnerId);
      if (bronze != null) _drawText(canvas, _pName(bronze), x + leftBlank + 8, y + mRowH * 2 + 9, _normal(10));
    }
  }

  // ─── Helpers ───────────────────────────────────────────────
  ParticipantEntity? _findP(String? id) =>
    id == null ? null : participants.where((p) => p.id == id).firstOrNull;

  String _pName(ParticipantEntity p) => '${p.firstName} ${p.lastName}'.toUpperCase();

  TextStyle _bold(double size) => TextStyle(
    color: Colors.black, fontSize: size, fontWeight: FontWeight.bold, fontFamily: 'Roboto');
  TextStyle _normal(double size) => TextStyle(
    color: Colors.black, fontSize: size, fontFamily: 'Roboto');

  void _drawText(Canvas canvas, String text, double x, double y, TextStyle style,
      {bool center = false, bool alignRight = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    var drawX = x;
    if (center) drawX -= tp.width / 2;
    if (alignRight) drawX -= tp.width;
    tp.paint(canvas, Offset(drawX, y));
  }

  @override
  bool shouldRepaint(covariant TieSheetPainter oldDelegate) => true;
}

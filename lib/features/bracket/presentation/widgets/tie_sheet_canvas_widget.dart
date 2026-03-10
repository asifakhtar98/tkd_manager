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
      child: Stack(
        children: [
          CustomPaint(
            size: size,
            painter: painter,
            willChange: true,
            child: SizedBox(width: size.width, height: size.height),
          ),
          ..._hitAreas.map((entry) {
            final rect = entry.value;
            final matchId = entry.key;
            return Positioned(
              left: rect.left,
              top: rect.top,
              width: rect.width,
              height: rect.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  hoverColor: Colors.blueAccent.withOpacity(0.1),
                  splashColor: Colors.blueAccent.withOpacity(0.2),
                  highlightColor: Colors.blueAccent.withOpacity(0.1),
                  onTap: () => widget.onMatchTap(matchId),
                  child: const Tooltip(
                    message: 'Record Score / Result',
                    child: SizedBox.expand(),
                  ),
                ),
              ),
            );
          }),
        ],
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

  final List<MapEntry<String, Rect>> matchHitAreas = [];
  final Map<String, int> _matchGlobalNumbers = {};
  final Map<String, Offset> _nodeOffsets = {};

  static const double rowH = 34.0;
  static const double pairGap = 20.0;
  static const double noColW = 30.0;
  static const double nameColW = 200.0;
  static const double regIdColW = 120.0;
  static const double roundColW = 120.0;
  static const double headerH = 110.0; // Increased for table header
  static const double subHeaderH = 24.0;
  static const double medalH = 120.0;
  static const double margin = 20.0;
  static const double centerGap = 60.0;

  static double get listW => noColW + nameColW + regIdColW;

  TieSheetPainter({
    required this.tournamentInfo,
    required this.matches,
    required this.participants,
    required this.bracketType,
    required this.includeThirdPlaceMatch,
  });

  bool get _isDouble => bracketType.contains('Double');

  List<MatchEntity> _getWinnersMatches() {
    if (!_isDouble) {
      return matches.where((m) {
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

  double _participantY(int i, double tableTop) {
    final pairIdx = i ~/ 2;
    return tableTop + (i * rowH) + (pairIdx * pairGap);
  }

  double _participantCenterY(int i, double tableTop) {
    return _participantY(i, tableTop) + rowH / 2;
  }


  /// Compute the total height for a side's participant table using match-grouped spacing.
  double _computeMatchGroupedHeight(List<MatchEntity> r1Matches) {
    double h = 0;
    for (var i = 0; i < r1Matches.length; i++) {
      final m = r1Matches[i];
      final hasBlue = m.participantBlueId != null;
      final hasRed = m.participantRedId != null;
      h += ((hasBlue ? 1 : 0) + (hasRed ? 1 : 0)) * rowH;
      if (i < r1Matches.length - 1) h += pairGap;
    }
    return h;
  }

  Size calculateCanvasSize() {
    final winnersMatches = _getWinnersMatches();
    final winRounds = _maxRound(winnersMatches);

    double width = margin * 2 + listW + (max(0, winRounds - 1) * roundColW) * 2 + centerGap + listW;

    if (_isDouble) {
      final losersMatches = _getLosersMatches();
      final lRounds = _maxRound(losersMatches);
      width = margin * 2 + listW + (winRounds * roundColW) + centerGap + (lRounds * roundColW) + listW;
    }

    double tableH;
    if (_isDouble) {
      final nLeft = (participants.length + 1) ~/ 2;
      final maxRows = max(2, nLeft);
      tableH = _participantY(maxRows, 0) + rowH;
    } else {
      // Match-grouped height: each match contributes 1 or 2 rows, with gaps between matches
      final winByRound = _groupByRound(winnersMatches);
      final r1Matches = winByRound[1] ?? [];
      final r1Count = r1Matches.length;
      final leftR1 = r1Matches.where((m) => m.matchNumberInRound <= r1Count / 2).toList();
      final rightR1 = r1Matches.where((m) => m.matchNumberInRound > r1Count / 2).toList();
      final leftH = _computeMatchGroupedHeight(leftR1);
      final rightH = _computeMatchGroupedHeight(rightR1);
      tableH = max(leftH, rightH);
    }

    final height = margin + headerH + tableH + 60 + medalH + margin;
    return Size(max(width, 700), max(height, 500));
  }

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

  @override
  void paint(Canvas canvas, Size size) {
    matchHitAreas.clear();
    _nodeOffsets.clear();
    _buildGlobalMatchNumbers();

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white);

    final thickPen = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    final nameTitleText = tournamentInfo.divisionLabel.toUpperCase();
    final divisionTitleText = tournamentInfo.categoryLabel.toUpperCase();

    double startY = margin;
    startY = _paintHeader(canvas, size, startY, thickPen, divisionTitleText, nameTitleText);

    // Draw a connecting horizontal line below the header
    canvas.drawLine(Offset(margin + listW, startY), Offset(size.width - margin - listW, startY), thickPen);
    final tableTop = startY + 8; // Small gap between header and participant table

    final wMatches = _getWinnersMatches();
    final winRounds = _maxRound(wMatches);
    final winByRound = _groupByRound(wMatches);

    if (_isDouble) {
      // Original Double Elimination logic (Single sided winners)
      for (var i = 0; i < participants.length; i++) {
        _paintParticipantRow(canvas, i + 1, participants[i], margin, _participantY(i, tableTop), thickPen, mirrored: false);
        _nodeOffsets[participants[i].id] = Offset(margin + listW, _participantCenterY(i, tableTop));
      }
      for (var r = 1; r <= winRounds; r++) {
        final roundMatches = winByRound[r] ?? [];
        final junctionX = margin + listW + (r * roundColW);
        for (final match in roundMatches) {
          _paintJunction(canvas, match, junctionX, thickPen, mirrored: false);
        }
      }
      final lMatches = _getLosersMatches();
      final lByRound = _groupByRound(lMatches);
      final lRounds = _maxRound(lMatches);
      final rightEdge = size.width - margin;
      _paintRightSideLabels(canvas, lByRound, rightEdge, tableTop, thickPen, tableTop);
      for (var r = 1; r <= lRounds; r++) {
        final roundMatches = lByRound[r] ?? [];
        final junctionX = rightEdge - (r * roundColW);
        for (final match in roundMatches) {
          _paintJunction(canvas, match, junctionX, thickPen, mirrored: true);
        }
      }
    } else {
      // TWO-SIDED SINGLE ELIMINATION
      // Split R1 matches into left and right halves (match-grouped layout)
      final r1Matches = winByRound[1] ?? [];
      final r1Count = r1Matches.length;
      final leftR1Matches = r1Matches.where((m) => m.matchNumberInRound <= r1Count / 2).toList();
      final rightR1Matches = r1Matches.where((m) => m.matchNumberInRound > r1Count / 2).toList();

      // Draw Left Participant Table — grouped by match, Blue (top) then Red (bottom)
      var leftIdx = 0;
      double leftY = tableTop;
      for (final m in leftR1Matches) {
        final b = _findP(m.participantBlueId);  // Blue = top slot
        final r = _findP(m.participantRedId);    // Red = bottom slot
        if (b != null) {
          leftIdx++;
          _paintParticipantRow(canvas, leftIdx, b, margin, leftY, thickPen, mirrored: false);
          _nodeOffsets[b.id] = Offset(margin + listW, leftY + rowH / 2);
          leftY += rowH;
        }
        if (r != null) {
          leftIdx++;
          _paintParticipantRow(canvas, leftIdx, r, margin, leftY, thickPen, mirrored: false);
          _nodeOffsets[r.id] = Offset(margin + listW, leftY + rowH / 2);
          leftY += rowH;
        }
        leftY += pairGap;
      }

      // Draw Right Participant Table — grouped by match, Blue (top) then Red (bottom)
      final rightEdge = size.width - margin;
      final rightTableLeft = rightEdge - listW;
      var rightIdx = 0;
      double rightY = tableTop;
      for (final m in rightR1Matches) {
        final b = _findP(m.participantBlueId);  // Blue = top slot
        final r = _findP(m.participantRedId);    // Red = bottom slot
        if (b != null) {
          rightIdx++;
          _paintParticipantRow(canvas, rightIdx, b, rightTableLeft, rightY, thickPen, mirrored: true);
          _nodeOffsets[b.id] = Offset(rightTableLeft, rightY + rowH / 2);
          rightY += rowH;
        }
        if (r != null) {
          rightIdx++;
          _paintParticipantRow(canvas, rightIdx, r, rightTableLeft, rightY, thickPen, mirrored: true);
          _nodeOffsets[r.id] = Offset(rightTableLeft, rightY + rowH / 2);
          rightY += rowH;
        }
        rightY += pairGap;
      }

      // Draw Tree
      for (var r = 1; r <= winRounds; r++) {
        final roundMatches = winByRound[r] ?? [];
        final c = roundMatches.length;

        for (final match in roundMatches) {
          if (r == winRounds) {
            // Final Match is in the center
            final junctionX = size.width / 2;
            _paintCenterFinalJunction(canvas, match, junctionX, thickPen);
          } else {
            bool isLeft = match.matchNumberInRound <= c / 2;
            final junctionX = isLeft 
               ? margin + listW + (r * roundColW)
               : rightEdge - listW - (r * roundColW);
            _paintJunction(canvas, match, junctionX, thickPen, mirrored: !isLeft);
          }
        }
      }
      
      if (includeThirdPlaceMatch) {
         final thirdMatch = matches.where((m) => m.roundNumber == winRounds && m.matchNumberInRound == 2).firstOrNull;
         if (thirdMatch != null) _paint3rdPlaceMatch(canvas, thirdMatch, thickPen, tableTop);
      }
    }

    _paintMedalTable(canvas, size, thickPen);
  }
  
  void _paintCenterFinalJunction(Canvas canvas, MatchEntity match, double junctionX, Paint pen) {
    if (match.resultType == MatchResultType.bye) return;

    final topIn = _resolveInputOffset(match, isTopSlot: true);
    final botIn = _resolveInputOffset(match, isTopSlot: false);

    if (topIn != null && botIn != null) {
      // Draw from Left to Center
      canvas.drawLine(topIn, Offset(junctionX, topIn.dy), pen);
      // Draw from Right to Center
      canvas.drawLine(botIn, Offset(junctionX, botIn.dy), pen);
      
      // Vertical bar connecting them at the center
      final minY = min(topIn.dy, botIn.dy);
      final maxY = max(topIn.dy, botIn.dy);
      canvas.drawLine(Offset(junctionX, minY), Offset(junctionX, maxY), pen);
      
      // Output pointing UP or DOWN? WT finals usually just have a box or text in center
      final midY = (minY + maxY) / 2;
      _nodeOffsets[match.id] = Offset(junctionX, midY);

      // Label B / R (Since Left is usually B, Right is usually R)
      final leftIn = topIn.dx < botIn.dx ? topIn : botIn;
      final rightIn = topIn.dx > botIn.dx ? topIn : botIn;
      _drawText(canvas, 'B', junctionX - 10, leftIn.dy - 12, const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10));
      _drawText(canvas, 'R', junctionX + 4, rightIn.dy - 12, const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10));

      final gNum = _matchGlobalNumbers[match.id];
      if (gNum != null) {
        _drawText(canvas, '$gNum', junctionX + 4, midY + 4, _bold(10));
      }

      if (match.winnerId != null) {
        final w = _findP(match.winnerId);
        if (w != null) {
          _drawText(canvas, _pName(w), junctionX, midY - 14, _bold(12), center: true);
        }
      }

      matchHitAreas.add(MapEntry(match.id, Rect.fromCenter(center: Offset(junctionX, midY), width: 60, height: max(35, maxY - minY + 10))));
    }
  }

  double _paintHeader(Canvas canvas, Size size, double startY, Paint thickPen, String divisionTitle, String categoryTitle) {
    var y = startY;
    final title = (tournamentInfo.tournamentName.isNotEmpty ? tournamentInfo.tournamentName : 'TOURNAMENT NAME').toUpperCase();
    _drawText(canvas, title, size.width / 2, y, _bold(18), center: true);
    y += 24;
    if (tournamentInfo.dateRange.isNotEmpty || tournamentInfo.venue.isNotEmpty) {
      final sub = [tournamentInfo.dateRange, tournamentInfo.venue].where((s) => s.isNotEmpty).join(', ');
      _drawText(canvas, sub, size.width / 2, y, _normal(14), center: true);
      y += 22;
    }
    if (tournamentInfo.organizer.isNotEmpty) {
      _drawText(canvas, 'Organised by : ${tournamentInfo.organizer.toUpperCase()}', size.width / 2, y, _bold(16), center: true);
      y += 24;
    } else {
      y += 20;
    }

    // Draw the table header row
    final headerRowTop = y;
    final headerRowBottom = y + subHeaderH;
    
    final normalPen = Paint()
      ..color = thickPen.color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
      
    // Header for the Left Bracket Side
    final leftHeaderX = margin;
    final rRectL = RRect.fromLTRBR(leftHeaderX, headerRowTop, leftHeaderX + listW, headerRowBottom, const Radius.circular(6.0));
    canvas.drawRRect(rRectL, Paint()..color = const Color(0xFFF1F5F9)..style = PaintingStyle.fill);
    canvas.drawRRect(rRectL, thickPen);
    canvas.drawLine(Offset(leftHeaderX + noColW, headerRowTop), Offset(leftHeaderX + noColW, headerRowBottom), normalPen);
    canvas.drawLine(Offset(leftHeaderX + noColW + nameColW, headerRowTop), Offset(leftHeaderX + noColW + nameColW, headerRowBottom), normalPen);

    _drawText(canvas, 'No.', leftHeaderX + noColW / 2, headerRowTop + 14, _normal(13), center: true);
    _drawText(canvas, divisionTitle.isEmpty ? 'JUNIOR' : divisionTitle, leftHeaderX + noColW + nameColW / 2, headerRowTop + 14, _normal(13), center: true);
    _drawText(canvas, categoryTitle.isEmpty ? 'BOYS' : categoryTitle, leftHeaderX + noColW + nameColW + regIdColW / 2, headerRowTop + 14, _normal(13), center: true);

    // If double elimination, we could draw right side header, but currently layout assumes symmetry only if single.
    if (!_isDouble) {
      final rightHeaderX = size.width - margin - listW;
      final rRectR = RRect.fromLTRBR(rightHeaderX, headerRowTop, rightHeaderX + listW, headerRowBottom, const Radius.circular(6.0));
      canvas.drawRRect(rRectR, Paint()..color = const Color(0xFFF1F5F9)..style = PaintingStyle.fill);
      canvas.drawRRect(rRectR, thickPen);
      canvas.drawLine(Offset(rightHeaderX + regIdColW, headerRowTop), Offset(rightHeaderX + regIdColW, headerRowBottom), normalPen);
      canvas.drawLine(Offset(rightHeaderX + regIdColW + nameColW, headerRowTop), Offset(rightHeaderX + regIdColW + nameColW, headerRowBottom), normalPen);

      _drawText(canvas, categoryTitle.isEmpty ? 'BOYS' : categoryTitle, rightHeaderX + regIdColW / 2, headerRowTop + 14, _normal(13), center: true);
      _drawText(canvas, divisionTitle.isEmpty ? 'JUNIOR' : divisionTitle, rightHeaderX + regIdColW + nameColW / 2, headerRowTop + 14, _normal(13), center: true);
      _drawText(canvas, 'No.', rightHeaderX + listW - noColW / 2, headerRowTop + 14, _normal(13), center: true);
    }
    
    y = headerRowBottom + 10;
    return y;
  }

  void _paintParticipantRow(Canvas canvas, int idx, ParticipantEntity p, double x, double y, Paint pen, {required bool mirrored}) {
    final right = x + listW;
    
    final normalPen = Paint()
      ..color = pen.color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // The "No." is positioned without borders, and the Name/RegID have a thick border.
    if (!mirrored) {
      final boxLeft = x + noColW;
      final rectL = RRect.fromLTRBR(boxLeft, y, right, y + rowH, const Radius.circular(6.0));
      canvas.drawRRect(rectL, Paint()..color = const Color(0xFFF9FAFB)..style = PaintingStyle.fill);
      canvas.drawRRect(rectL, pen);
      canvas.drawLine(Offset(boxLeft + nameColW, y), Offset(boxLeft + nameColW, y + rowH), normalPen);

      _drawText(canvas, '$idx', x + noColW / 2, y + rowH / 2 - 6, _bold(12), center: true);
      _drawText(canvas, _pName(p), boxLeft + 6, y + rowH / 2 - 6, _bold(11));
      if (p.registrationId != null && p.registrationId!.isNotEmpty) {
        _drawText(canvas, p.registrationId!, right - 6, y + rowH / 2 - 6, _bold(11), alignRight: true);
      }
      
      final lineY = y + rowH / 2;
      canvas.drawLine(Offset(right, lineY), Offset(right + roundColW, lineY), pen);
    } else {
      // Mirrored layout: [REG ID | NAME | NO] -> No border for NO.
      final boxRight = right - noColW;
      final rectR = RRect.fromLTRBR(x, y, boxRight, y + rowH, const Radius.circular(6.0));
      canvas.drawRRect(rectR, Paint()..color = const Color(0xFFF9FAFB)..style = PaintingStyle.fill);
      canvas.drawRRect(rectR, pen);
      canvas.drawLine(Offset(x + regIdColW, y), Offset(x + regIdColW, y + rowH), normalPen);

      if (p.registrationId != null && p.registrationId!.isNotEmpty) {
        _drawText(canvas, p.registrationId!, x + 6, y + rowH / 2 - 6, _bold(11));
      }
      _drawText(canvas, _pName(p), boxRight - 6, y + rowH / 2 - 6, _bold(11), alignRight: true);
      _drawText(canvas, '$idx', right - noColW / 2, y + rowH / 2 - 6, _bold(12), center: true);

      final lineY = y + rowH / 2;
      canvas.drawLine(Offset(x, lineY), Offset(x - roundColW, lineY), pen);
    }
  }

  void _paintJunction(Canvas canvas, MatchEntity match, double junctionX, Paint pen, {required bool mirrored}) {
    final pendingPen = Paint()..color = const Color(0xFFD1D5DB)..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final winnerPen = Paint()..color = const Color(0xFF1F2937)..strokeWidth = 2.0..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;

    Paint topPen = (match.participantBlueId != null) ? winnerPen : pendingPen;
    Paint botPen = (match.participantRedId != null) ? winnerPen : pendingPen;
    Paint outPen = (match.winnerId != null) ? winnerPen : pendingPen;

    final isBye = match.resultType == MatchResultType.bye;
    
    if (isBye) {
      final topIn = _resolveInputOffset(match, isTopSlot: true);
      if (topIn != null) {
        canvas.drawLine(topIn, Offset(junctionX, topIn.dy), topPen);
        final nextJunctionX = mirrored ? junctionX - roundColW : junctionX + roundColW;
        canvas.drawLine(Offset(junctionX, topIn.dy), Offset(nextJunctionX, topIn.dy), outPen);
        
        _nodeOffsets[match.id] = Offset(junctionX, topIn.dy);

        if (match.winnerId != null) {
          final winner = _findP(match.winnerId);
          if (winner != null) {
            final wName = _pName(winner);
            if (!mirrored) {
              _drawText(canvas, wName, junctionX + roundColW * 0.15, topIn.dy - 14, _bold(9));
            } else {
              _drawText(canvas, wName, junctionX - roundColW * 0.15, topIn.dy - 14, _bold(9), alignRight: true);
            }
          }
        }
        matchHitAreas.add(MapEntry(match.id, Rect.fromCenter(center: Offset(junctionX, topIn.dy), width: roundColW * 0.6, height: 35)));
      }
      return;
    }
    
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
      final estY = 100.0 + (match.matchNumberInRound * 2 - 1) * (rowH + pairGap / 2);
      effectiveTop = Offset(junctionX, estY);
      effectiveBot = Offset(junctionX, estY + rowH * 2);
    }

    final midY = (effectiveTop.dy + effectiveBot.dy) / 2;
    final output = Offset(junctionX, midY);
    _nodeOffsets[match.id] = output;

    final r = 6.0;
    
    // Top arm
    final pathT = Path();
    pathT.moveTo(effectiveTop.dx, effectiveTop.dy);
    pathT.lineTo(junctionX - (mirrored ? -r : r), effectiveTop.dy);
    pathT.quadraticBezierTo(junctionX, effectiveTop.dy, junctionX, effectiveTop.dy + r);
    pathT.lineTo(junctionX, midY);
    canvas.drawPath(pathT, topPen);

    // Bottom arm
    final pathB = Path();
    pathB.moveTo(effectiveBot.dx, effectiveBot.dy);
    pathB.lineTo(junctionX - (mirrored ? -r : r), effectiveBot.dy);
    pathB.quadraticBezierTo(junctionX, effectiveBot.dy, junctionX, effectiveBot.dy - r);
    pathB.lineTo(junctionX, midY);
    canvas.drawPath(pathB, botPen);

    final nextJunctionX = mirrored ? junctionX - roundColW : junctionX + roundColW;
    canvas.drawLine(output, Offset(nextJunctionX, midY), outPen);

    final blueColor = const Color(0xFF3B82F6);
    final redColor = const Color(0xFFEF4444);

    if (!mirrored) {
      _drawBadge(canvas, 'B', blueColor, junctionX + 10, effectiveTop.dy - 8);
      _drawBadge(canvas, 'R', redColor, junctionX + 10, effectiveBot.dy + 8);
    } else {
      _drawBadge(canvas, 'B', blueColor, junctionX - 10, effectiveTop.dy - 8);
      _drawBadge(canvas, 'R', redColor, junctionX - 10, effectiveBot.dy + 8);
    }

    final gNum = _matchGlobalNumbers[match.id];
    if (gNum != null) {
      if (!mirrored) {
        _drawText(canvas, '$gNum', junctionX + 4, midY - 6, _bold(9));
      } else {
        _drawText(canvas, '$gNum', junctionX - 14, midY - 6, _bold(9));
      }
    }

    if (match.winnerId != null) {
      final winner = _findP(match.winnerId);
      if (winner != null) {
        if (!mirrored) {
          _drawText(canvas, _pName(winner), junctionX + roundColW * 0.15, midY - 14, _bold(9));
        } else {
          _drawText(canvas, _pName(winner), junctionX - roundColW * 0.15, midY - 14, _bold(9), alignRight: true);
        }
      }
    }
    matchHitAreas.add(MapEntry(match.id, Rect.fromCenter(center: output, width: roundColW * 0.6, height: max(35, (effectiveBot.dy - effectiveTop.dy).abs() + 10))));
  }

  void _paintRightSideLabels(Canvas canvas, Map<int, List<MatchEntity>> losByRound, double rightEdge, double tableTop, Paint pen, double subY) {
    // Keep double elimination right labels unmodified
    final x = rightEdge - nameColW;
    final bgPaint = Paint()..color = Colors.grey[200]!..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(x, subY, nameColW, subHeaderH), bgPaint);
    canvas.drawRect(Rect.fromLTWH(x, subY, nameColW, subHeaderH), pen);
    _drawText(canvas, 'NAME', x + nameColW / 2, subY + 4, _bold(10), center: true);

    final r1Matches = losByRound[1] ?? [];
    final seenIds = <String>{};
    var idx = 0;

    for (final m in r1Matches) {
      for (final pId in [m.participantRedId, m.participantBlueId]) {
        if (pId != null && seenIds.add(pId)) {
          final p = _findP(pId);
          if (p != null) {
            final rowY = _participantY(idx, tableTop);
            final rx = rightEdge - nameColW;
            canvas.drawRect(Rect.fromLTWH(rx, rowY, nameColW, rowH), pen);
            _drawText(canvas, _pName(p), rightEdge - 6, rowY + rowH / 2 - 6, _bold(11), alignRight: true);
            final lineY = rowY + rowH / 2;
            canvas.drawLine(Offset(rx - roundColW, lineY), Offset(rx, lineY), pen);
            _nodeOffsets['right_${p.id}'] = Offset(rx - roundColW, lineY);
            idx++;
          }
        }
      }
    }
  }

  Offset? _resolveInputOffset(MatchEntity match, {required bool isTopSlot}) {
    // In WT Brackets: Top slot is Chung (Blue) and Bottom slot is Hong (Red).
    final pId = isTopSlot ? match.participantBlueId : match.participantRedId;
    if (pId != null) {
      if (_nodeOffsets.containsKey(pId)) return _nodeOffsets[pId];
      if (_nodeOffsets.containsKey('right_$pId')) return _nodeOffsets['right_$pId'];
    }

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

  void _paint3rdPlaceMatch(Canvas canvas, MatchEntity m, Paint pen, double tableTop) {
    final allRounds = matches.map((mm) => mm.roundNumber).reduce(max);
    final finals = matches.where((mm) => mm.roundNumber == allRounds && mm.matchNumberInRound == 1).firstOrNull;
    if (finals == null || !_nodeOffsets.containsKey(finals.id)) return;

    final fPos = _nodeOffsets[finals.id]!;
    final x = fPos.dx;
    final y = fPos.dy + rowH * 4 + 60; // offset far below

    canvas.drawLine(Offset(x - 50, y - 20), Offset(x, y - 20), pen);
    canvas.drawLine(Offset(x - 50, y + 20), Offset(x, y + 20), pen);
    canvas.drawLine(Offset(x, y - 20), Offset(x, y + 20), pen);
    canvas.drawLine(Offset(x, y), Offset(x + 30, y), pen);

    _nodeOffsets[m.id] = Offset(x, y);
    matchHitAreas.add(MapEntry(m.id, Rect.fromCenter(center: Offset(x, y), width: 60, height: 50)));

    _drawText(canvas, '3rd Place', x - 25, y - 34, _bold(9), center: true);
    _drawText(canvas, 'B', x + 4, y - 34, const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 9));
    _drawText(canvas, 'R', x + 4, y + 22, const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 9));

    if (m.winnerId != null) {
      final w = _findP(m.winnerId);
      if (w != null) _drawText(canvas, _pName(w), x + 35, y - 6, _bold(9));
    }
  }

  void _paintMedalTable(Canvas canvas, Size size, Paint pen) {
    const tableW = 420.0;
    const mRowH = 32.0;
    const nameW = 230.0;
    const medalLabelW = 70.0;
    const leftBlank = tableW - nameW - medalLabelW;

    final x = (size.width - tableW) / 2;
    final y = size.height - medalH - margin + 10;

    final normalPen = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
      
    final goldBg = Paint()..color = const Color(0xFFFEF3C7)..style = PaintingStyle.fill;
    final silverBg = Paint()..color = const Color(0xFFF3F4F6)..style = PaintingStyle.fill;
    final bronzeBg = Paint()..color = const Color(0xFFFFEDD5)..style = PaintingStyle.fill;

    for (var row = 0; row < 3; row++) {
      final rY = y + row * mRowH;
      final fillPaint = row == 0 ? goldBg : (row == 1 ? silverBg : bronzeBg);
      
      final labelRect = Rect.fromLTWH(x + leftBlank + nameW, rY, medalLabelW, mRowH);
      final rLabelRect = RRect.fromRectAndCorners(labelRect, topRight: const Radius.circular(6.0), bottomRight: const Radius.circular(6.0));
      canvas.drawRRect(rLabelRect, fillPaint);
      
      final nameRect = Rect.fromLTWH(x + leftBlank, rY, nameW, mRowH);
      final rNameRect = RRect.fromRectAndCorners(nameRect, topLeft: const Radius.circular(6.0), bottomLeft: const Radius.circular(6.0));
      canvas.drawRRect(rNameRect, Paint()..color = Colors.white..style = PaintingStyle.fill);

      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x + leftBlank, rY, nameW + medalLabelW, mRowH), const Radius.circular(6.0)), normalPen);
      canvas.drawLine(Offset(x + leftBlank + nameW, rY), Offset(x + leftBlank + nameW, rY + mRowH), normalPen);
    }

    _drawText(canvas, '🥇 Gold',   x + leftBlank + nameW + medalLabelW / 2, y + 8, const TextStyle(color: Color(0xFFB45309), fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Roboto'), center: true);
    _drawText(canvas, '🥈 Silver', x + leftBlank + nameW + medalLabelW / 2, y + mRowH + 8, const TextStyle(color: Color(0xFF374151), fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Roboto'), center: true);
    _drawText(canvas, '🥉 Bronze', x + leftBlank + nameW + medalLabelW / 2, y + mRowH * 2 + 8, const TextStyle(color: Color(0xFF9A3412), fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Roboto'), center: true);

    final allRounds = matches.map((m) => m.roundNumber).reduce(max);
    final finals = matches.where((m) => m.roundNumber == allRounds && m.matchNumberInRound == 1).firstOrNull;
    if (finals != null && finals.winnerId != null) {
      final gold = _findP(finals.winnerId);
      final silverId = finals.winnerId == finals.participantRedId ? finals.participantBlueId : finals.participantRedId;
      final silver = _findP(silverId);
      if (gold != null) _drawText(canvas, _pName(gold), x + leftBlank + 12, y + 8, _bold(12));
      if (silver != null) _drawText(canvas, _pName(silver), x + leftBlank + 12, y + mRowH + 8, _bold(12));
    }
    final thirdM = matches.where((m) => m.roundNumber == allRounds && m.matchNumberInRound == 2).firstOrNull;
    if (thirdM?.winnerId != null) {
      final bronze = _findP(thirdM!.winnerId);
      if (bronze != null) _drawText(canvas, _pName(bronze), x + leftBlank + 12, y + mRowH * 2 + 8, _bold(12));
    }
  }

  ParticipantEntity? _findP(String? id) => id == null ? null : participants.where((p) => p.id == id).firstOrNull;

  String _pName(ParticipantEntity p) => '${p.firstName} ${p.lastName}'.toUpperCase();

  TextStyle _bold(double size) => TextStyle(color: const Color(0xFF111827), fontSize: size, fontWeight: FontWeight.bold, fontFamily: 'Roboto');
  TextStyle _normal(double size) => TextStyle(color: const Color(0xFF4B5563), fontSize: size, fontFamily: 'Roboto');

  void _drawBadge(Canvas canvas, String text, Color color, double cx, double cy) {
    final badgePaint = Paint()..color = color..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 8.0, badgePaint);
    _drawText(canvas, text, cx, cy - 6, const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), center: true);
  }

  void _drawText(Canvas canvas, String text, double x, double y, TextStyle style, {bool center = false, bool alignRight = false}) {
    final tp = TextPainter(text: TextSpan(text: text, style: style), textDirection: TextDirection.ltr);
    tp.layout();
    var drawX = x;
    if (center) drawX -= tp.width / 2;
    if (alignRight) drawX -= tp.width;
    tp.paint(canvas, Offset(drawX, y));
  }

  @override
  bool shouldRepaint(covariant TieSheetPainter oldDelegate) => true;
}

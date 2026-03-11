import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../domain/entities/match_entity.dart';
import '../../../tournament/domain/entities/tournament_entity.dart';
import '../../../participant/domain/entities/participant_entity.dart';

/// A widget that renders a TKD tie sheet using CustomPainter.
/// Replicates the official World Taekwondo federation bracket format.
class TieSheetCanvasWidget extends StatefulWidget {
  final TournamentEntity tournament;
  final List<MatchEntity> matches;
  final List<ParticipantEntity> participants;
  final String bracketType;
  final void Function(String matchId) onMatchTap;
  final GlobalKey printKey;
  final bool includeThirdPlaceMatch;
  final String? winnersBracketId;
  final String? losersBracketId;

  const TieSheetCanvasWidget({
    super.key,
    required this.tournament,
    required this.matches,
    required this.participants,
    required this.bracketType,
    required this.onMatchTap,
    required this.printKey,
    required this.includeThirdPlaceMatch,
    this.winnersBracketId,
    this.losersBracketId,
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
    tournament: widget.tournament,
    matches: widget.matches,
    participants: widget.participants,
    bracketType: widget.bracketType,
    includeThirdPlaceMatch: widget.includeThirdPlaceMatch,
    winnersBracketId: widget.winnersBracketId,
    losersBracketId: widget.losersBracketId,
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
                  hoverColor: Colors.blueAccent.withValues(alpha: 0.1),
                  splashColor: Colors.blueAccent.withValues(alpha: 0.2),
                  highlightColor: Colors.blueAccent.withValues(alpha: 0.1),
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
  final TournamentEntity tournament;
  final List<MatchEntity> matches;
  final List<ParticipantEntity> participants;
  final String bracketType;
  final bool includeThirdPlaceMatch;
  final String? winnersBracketId;
  final String? losersBracketId;

  final List<MapEntry<String, Rect>> matchHitAreas = [];
  final Map<String, int> _matchGlobalNumbers = {};
  final Map<String, Offset> _nodeOffsets = {};

  static const double rowH = 48.0;
  static const double pairGap = 50.0;
  static const double noColW = 36.0;
  static const double nameColW = 210.0;
  static const double regIdColW = 130.0;
  static const double roundColW = 160.0;
  static const double headerH = 110.0;
  static const double subHeaderH = 24.0;
  static const double medalH = 120.0;
  static const double margin = 30.0;
  static const double centerGap = 160.0;
  static const double sectionGap = 60.0;
  static const double sectionLabelH = 36.0;

  static double get listW => noColW + nameColW + regIdColW;

  TieSheetPainter({
    required this.tournament,
    required this.matches,
    required this.participants,
    required this.bracketType,
    required this.includeThirdPlaceMatch,
    this.winnersBracketId,
    this.losersBracketId,
  });

  bool get _isDouble => winnersBracketId != null && losersBracketId != null;

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


  /// Compute one-sided height: all R1 matches stacked vertically.
  double _computeOneSidedHeight(List<MatchEntity> r1Matches) {
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
    if (_isDouble) return _calculateDECanvasSize();
    return _calculateSECanvasSize();
  }

  Size _calculateSECanvasSize() {
    // Filter out the 3rd-place match for layout computation
    final mainMatches = matches.where((m) {
      final maxRound = matches.map((mm) => mm.roundNumber).reduce(max);
      return !(m.roundNumber == maxRound && m.matchNumberInRound == 2);
    }).toList();
    final winRounds = _maxRound(mainMatches);

    final width = margin * 2 + listW + (max(0, winRounds - 1) * roundColW) * 2 + centerGap + listW;

    // Match-grouped height
    final byRound = _groupByRound(mainMatches);
    final r1Matches = byRound[1] ?? [];
    final r1Count = r1Matches.length;
    final leftR1 = r1Matches.where((m) => m.matchNumberInRound <= (r1Count + 1) ~/ 2).toList();
    final rightR1 = r1Matches.where((m) => m.matchNumberInRound > (r1Count + 1) ~/ 2).toList();
    final leftH = _computeOneSidedHeight(leftR1);
    final rightH = _computeOneSidedHeight(rightR1);
    final tableH = max(leftH, rightH);

    final height = margin + headerH + tableH + 60 + medalH + margin;
    return Size(max(width, 700), max(height, 500));
  }

  Size _calculateDECanvasSize() {
    final wbMatches = matches.where((m) => m.bracketId == winnersBracketId).toList();
    final lbMatches = matches.where((m) => m.bracketId == losersBracketId).toList();
    final gfMatches = matches.where((m) => m.bracketId != winnersBracketId && m.bracketId != losersBracketId).toList();
    final wbRounds = _maxRound(wbMatches);
    final lbRounds = _maxRound(lbMatches);

    final maxRounds = max(wbRounds, lbRounds);
    // One-sided: participants on left, tree flows right, GF + Reset at far right
    final gfColumns = gfMatches.isEmpty ? 0 : gfMatches.length; // 1 for GF, 2 if Reset
    final width = margin * 2 + listW + (maxRounds * roundColW) + (gfColumns * roundColW) + 100;

    final wbByRound = _groupByRound(wbMatches);
    final lbByRound = _groupByRound(lbMatches);
    final wbR1 = wbByRound[1] ?? [];
    final lbR1 = lbByRound[1] ?? [];
    final wbH = _computeOneSidedHeight(wbR1);
    // LB R1 participants are unknown at generation time (they drop in from WB).
    // Use match count × 2 rows to allocate space for empty slots.
    final lbH = lbR1.isEmpty ? 80 : (lbR1.length * 2 * rowH + (lbR1.length - 1) * pairGap);

    final height = margin + headerH + sectionLabelH + wbH + sectionGap + sectionLabelH + lbH + 60 + medalH + margin;
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

    if (_isDouble) {
      _paintDE(canvas, size, thickPen);
    } else {
      _paintSE(canvas, size, thickPen);
    }

    _paintMedalTable(canvas, size, thickPen);
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // SINGLE ELIMINATION — Two-sided bracket (left/right → center final)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  void _paintSE(Canvas canvas, Size size, Paint thickPen) {
    final nameTitleText = tournament.divisionLabel.toUpperCase();
    final divisionTitleText = tournament.categoryLabel.toUpperCase();

    double startY = margin;
    startY = _paintHeader(canvas, size, startY, thickPen, divisionTitleText, nameTitleText);

    canvas.drawLine(Offset(margin + listW, startY), Offset(size.width - margin - listW, startY), thickPen);
    final tableTop = startY + 16;

    // Filter out 3rd-place match from the main bracket
    final mainMatches = matches.where((m) {
      final maxRound = matches.map((mm) => mm.roundNumber).reduce(max);
      return !(m.roundNumber == maxRound && m.matchNumberInRound == 2);
    }).toList();

    final winRounds = _maxRound(mainMatches);
    final winByRound = _groupByRound(mainMatches);

    final r1Matches = winByRound[1] ?? [];
    final r1Count = r1Matches.length;
    final leftHalfCount = (r1Count + 1) ~/ 2;
    final rightEdge = size.width - margin;
    final rightTableLeft = rightEdge - listW;

    // Special case: 2 players (1 match = direct final)
    if (r1Count == 1 && winRounds == 1) {
      final match = r1Matches.first;
      final b = _findP(match.participantBlueId);
      final r = _findP(match.participantRedId);
      if (b != null) {
        _paintParticipantRow(canvas, 1, b, margin, tableTop, thickPen, mirrored: false);
        _nodeOffsets[b.id] = Offset(margin + listW, tableTop + rowH / 2);
      }
      if (r != null) {
        _paintParticipantRow(canvas, 1, r, rightTableLeft, tableTop, thickPen, mirrored: true);
        _nodeOffsets[r.id] = Offset(rightTableLeft, tableTop + rowH / 2);
      }
    } else {
      final leftR1Matches = r1Matches.where((m) => m.matchNumberInRound <= leftHalfCount).toList();
      final rightR1Matches = r1Matches.where((m) => m.matchNumberInRound > leftHalfCount).toList();

      // Left participant table
      var leftIdx = 0;
      double leftY = tableTop;
      for (final m in leftR1Matches) {
        final b = _findP(m.participantBlueId);
        final r = _findP(m.participantRedId);
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

      // Right participant table
      var rightIdx = 0;
      double rightY = tableTop;
      for (final m in rightR1Matches) {
        final b = _findP(m.participantBlueId);
        final r = _findP(m.participantRedId);
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
    }

    // Draw tree
    for (var r = 1; r <= winRounds; r++) {
      final roundMatches = winByRound[r] ?? [];
      final c = roundMatches.length;
      for (final match in roundMatches) {
        if (r == winRounds) {
          final junctionX = size.width / 2;
          _paintCenterFinalJunction(canvas, match, junctionX, thickPen);
        } else {
          bool isLeft = match.matchNumberInRound <= (c + 1) ~/ 2;
          final junctionX = isLeft
              ? margin + listW + (r * roundColW)
              : rightEdge - listW - (r * roundColW);
          _paintJunction(canvas, match, junctionX, thickPen, mirrored: !isLeft);
        }
      }
    }

    if (includeThirdPlaceMatch) {
      final maxRound = matches.map((mm) => mm.roundNumber).reduce(max);
      final thirdMatch = matches.where((m) => m.roundNumber == maxRound && m.matchNumberInRound == 2).firstOrNull;
      if (thirdMatch != null) _paint3rdPlaceMatch(canvas, thirdMatch, thickPen, tableTop);
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // DOUBLE ELIMINATION — WB on top, LB below, Grand Finals at far right
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  void _paintDE(Canvas canvas, Size size, Paint thickPen) {
    final nameTitleText = tournament.divisionLabel.toUpperCase();
    final divisionTitleText = tournament.categoryLabel.toUpperCase();

    double startY = margin;
    startY = _paintHeader(canvas, size, startY, thickPen, divisionTitleText, nameTitleText, showRightHeader: false);

    final wbMatches = matches.where((m) => m.bracketId == winnersBracketId).toList();
    final lbMatches = matches.where((m) => m.bracketId == losersBracketId).toList();
    // Grand Finals = matches that belong to neither WB nor LB
    final gfMatches = matches.where((m) => m.bracketId != winnersBracketId && m.bracketId != losersBracketId).toList();

    final wbRounds = _maxRound(wbMatches);
    final lbRounds = _maxRound(lbMatches);
    final wbByRound = _groupByRound(wbMatches);
    final lbByRound = _groupByRound(lbMatches);

    // ── WINNERS BRACKET SECTION ──
    _paintSectionLabel(canvas, 'WINNERS BRACKET', margin, startY, size.width - margin * 2, thickPen, const Color(0xFF2563EB));
    var wbTableTop = startY + sectionLabelH + 8;

    // Paint WB participants (one-sided, left to right)
    final wbR1 = wbByRound[1] ?? [];
    var wbIdx = 0;
    double wbY = wbTableTop;
    for (final m in wbR1) {
      final b = _findP(m.participantBlueId);
      final r = _findP(m.participantRedId);
      if (b != null) {
        wbIdx++;
        _paintParticipantRow(canvas, wbIdx, b, margin, wbY, thickPen, mirrored: false);
        _nodeOffsets[b.id] = Offset(margin + listW, wbY + rowH / 2);
        wbY += rowH;
      }
      if (r != null) {
        wbIdx++;
        _paintParticipantRow(canvas, wbIdx, r, margin, wbY, thickPen, mirrored: false);
        _nodeOffsets[r.id] = Offset(margin + listW, wbY + rowH / 2);
        wbY += rowH;
      }
      wbY += pairGap;
    }

    // Paint WB tree
    for (var r = 1; r <= wbRounds; r++) {
      final roundMatches = wbByRound[r] ?? [];
      final junctionX = margin + listW + (r * roundColW);
      for (final match in roundMatches) {
        _paintJunction(canvas, match, junctionX, thickPen, mirrored: false);
      }
    }

    // ── LOSERS BRACKET SECTION ──
    final wbH = _computeOneSidedHeight(wbR1);
    final lbSectionTop = wbTableTop + wbH + sectionGap;
    _paintSectionLabel(canvas, 'LOSERS BRACKET', margin, lbSectionTop, size.width - margin * 2, thickPen, const Color(0xFFDC2626));
    var lbTableTop = lbSectionTop + sectionLabelH + 8;

    // Paint LB participants (one-sided, left to right)
    // LB R1 slots are often empty at generation time (participants drop in from WB).
    // Render TBD placeholder rows for empty slots.
    final lbR1 = lbByRound[1] ?? [];
    var lbIdx = 0;
    double lbY = lbTableTop;
    for (final m in lbR1) {
      final b = _findP(m.participantBlueId);
      final r = _findP(m.participantRedId);

      // Blue slot
      lbIdx++;
      if (b != null) {
        _paintParticipantRow(canvas, lbIdx, b, margin, lbY, thickPen, mirrored: false);
        _nodeOffsets[b.id] = Offset(margin + listW, lbY + rowH / 2);
      } else {
        _paintTbdRow(canvas, lbIdx, margin, lbY, thickPen);
        // Store a node offset keyed by match-blue so junctions can connect
        _nodeOffsets['${m.id}_blue'] = Offset(margin + listW, lbY + rowH / 2);
      }
      lbY += rowH;

      // Red slot
      lbIdx++;
      if (r != null) {
        _paintParticipantRow(canvas, lbIdx, r, margin, lbY, thickPen, mirrored: false);
        _nodeOffsets[r.id] = Offset(margin + listW, lbY + rowH / 2);
      } else {
        _paintTbdRow(canvas, lbIdx, margin, lbY, thickPen);
        _nodeOffsets['${m.id}_red'] = Offset(margin + listW, lbY + rowH / 2);
      }
      lbY += rowH;

      lbY += pairGap;
    }

    // Paint LB tree
    for (var r = 1; r <= lbRounds; r++) {
      final roundMatches = lbByRound[r] ?? [];
      final junctionX = margin + listW + (r * roundColW);
      for (final match in roundMatches) {
        _paintJunction(canvas, match, junctionX, thickPen, mirrored: false);
      }
    }

    // ── GRAND FINALS ──
    if (gfMatches.isNotEmpty) {
      final gfX = margin + listW + (max(wbRounds, lbRounds) * roundColW) + roundColW;
      // Grand Final Game 1
      final gf1 = gfMatches.first;
      final wbChampOffset = _nodeOffsets[gf1.participantBlueId] ?? _nodeOffsets[gf1.id];
      final lbChampOffset = _nodeOffsets[gf1.participantRedId] ?? _nodeOffsets[gf1.id];

      final gfTopY = wbChampOffset?.dy ?? (wbTableTop + wbH / 2);
      final gfBotY = lbChampOffset?.dy ?? (lbTableTop + 50);
      final gfMidY = (gfTopY + gfBotY) / 2;

      _nodeOffsets[gf1.id] = Offset(gfX, gfMidY);
      _paintGrandFinalNode(canvas, gf1, gfX, gfTopY, gfBotY, thickPen, 'GRAND FINAL');

      // Reset Match (Game 2) if present
      if (gfMatches.length > 1) {
        final gf2 = gfMatches[1];
        final resetX = gfX + roundColW;
        final resetMidY = gfMidY;
        _nodeOffsets[gf2.id] = Offset(resetX, resetMidY);
        // Output line from GF1 to reset
        canvas.drawLine(Offset(gfX, gfMidY), Offset(resetX, resetMidY), thickPen);
        _paintGrandFinalNode(canvas, gf2, resetX, gfMidY - 25, gfMidY + 25, thickPen, 'RESET');
      }
    }
  }

  void _paintSectionLabel(Canvas canvas, String label, double x, double y, double width, Paint pen, Color color) {
    final rect = RRect.fromLTRBR(x, y, x + width, y + sectionLabelH, const Radius.circular(6));
    canvas.drawRRect(rect, Paint()..color = color.withValues(alpha: 0.1)..style = PaintingStyle.fill);
    canvas.drawRRect(rect, Paint()..color = color..strokeWidth = 1.5..style = PaintingStyle.stroke);
    _drawText(canvas, label, x + width / 2, y + 8, TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Roboto'), center: true);
  }

  void _paintGrandFinalNode(Canvas canvas, MatchEntity match, double x, double topY, double botY, Paint pen, String label) {
    final pendingPen = Paint()..color = const Color(0xFFD1D5DB)..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final winnerPen = Paint()..color = const Color(0xFF1F2937)..strokeWidth = 2.0..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final midY = (topY + botY) / 2;

    // Vertical connecting bar
    canvas.drawLine(Offset(x, topY), Offset(x, botY), pen);
    // Horizontal arms from tree outputs
    final topIn = _resolveInputOffset(match, isTopSlot: true);
    final botIn = _resolveInputOffset(match, isTopSlot: false);
    if (topIn != null) canvas.drawLine(topIn, Offset(x, topY), (match.participantBlueId != null) ? winnerPen : pendingPen);
    if (botIn != null) canvas.drawLine(botIn, Offset(x, botY), (match.participantRedId != null) ? winnerPen : pendingPen);

    // Output line
    canvas.drawLine(Offset(x, midY), Offset(x + 40, midY), (match.winnerId != null) ? winnerPen : pendingPen);

    // Label
    _drawText(canvas, label, x, topY - 20, _bold(10), center: true);
    _drawBadge(canvas, 'B', const Color(0xFF3B82F6), x + 16, topY - 6);
    _drawBadge(canvas, 'R', const Color(0xFFEF4444), x + 16, botY + 14);

    final gNum = _matchGlobalNumbers[match.id];
    if (gNum != null) {
      _drawText(canvas, '$gNum', x + 18, midY - 7, _bold(11));
    }

    if (match.winnerId != null) {
      final w = _findP(match.winnerId);
      if (w != null) _drawText(canvas, _pName(w), x + 45, midY - 6, _bold(9));
    }

    matchHitAreas.add(MapEntry(match.id, Rect.fromCenter(center: Offset(x, midY), width: roundColW * 0.6, height: max(35, (botY - topY).abs() + 10))));
  }
  
  void _paintCenterFinalJunction(Canvas canvas, MatchEntity match, double junctionX, Paint pen) {
    if (match.resultType == MatchResultType.bye) return;

    final pendingPen = Paint()..color = const Color(0xFFD1D5DB)..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final winnerPen = Paint()..color = const Color(0xFF1F2937)..strokeWidth = 2.0..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;

    final topIn = _resolveInputOffset(match, isTopSlot: true);
    final botIn = _resolveInputOffset(match, isTopSlot: false);

    if (topIn != null && botIn != null) {
      final topPen = (match.participantBlueId != null) ? winnerPen : pendingPen;
      final botPen = (match.participantRedId != null) ? winnerPen : pendingPen;

      // Enforce a minimum vertical span so the junction is visible even when
      // both inputs are at the same Y (e.g. 4-player bracket).
      final rawMidY = (topIn.dy + botIn.dy) / 2;
      const minSpan = 60.0;
      final actualSpan = (botIn.dy - topIn.dy).abs();
      final halfSpan = max(actualSpan, minSpan) / 2;
      final topArmY = rawMidY - halfSpan;
      final botArmY = rawMidY + halfSpan;
      final midY = rawMidY;

      // --- Draw the bracket arms ---
      // Left (Blue/top) input: horizontal → vertical to midpoint
      canvas.drawLine(topIn, Offset(junctionX, topIn.dy), topPen);
      if ((topIn.dy - topArmY).abs() > 1) {
        // Vertical segment from input Y to junction arm Y
        canvas.drawLine(Offset(junctionX, topIn.dy), Offset(junctionX, topArmY), topPen);
      }

      // Right (Red/bottom) input: horizontal → vertical to midpoint
      canvas.drawLine(botIn, Offset(junctionX, botIn.dy), botPen);
      if ((botIn.dy - botArmY).abs() > 1) {
        canvas.drawLine(Offset(junctionX, botIn.dy), Offset(junctionX, botArmY), botPen);
      }

      // Vertical bar connecting top arm to bottom arm
      canvas.drawLine(Offset(junctionX, topArmY), Offset(junctionX, botArmY), pen);

      _nodeOffsets[match.id] = Offset(junctionX, midY);

      // B badge above the top arm
      _drawBadge(canvas, 'B', const Color(0xFF3B82F6), junctionX - 24, topArmY - 16);
      // R badge below the bottom arm
      _drawBadge(canvas, 'R', const Color(0xFFEF4444), junctionX + 24, botArmY + 16);

      // Match number centered at midpoint
      final gNum = _matchGlobalNumbers[match.id];
      if (gNum != null) {
        _drawText(canvas, '$gNum', junctionX + 16, midY - 7, _bold(11));
      }

      // Winner name above the midpoint
      if (match.winnerId != null) {
        final w = _findP(match.winnerId);
        if (w != null) {
          _drawText(canvas, _pName(w), junctionX, midY - 18, _bold(10), center: true);
        }
      }

      matchHitAreas.add(MapEntry(match.id, Rect.fromCenter(center: Offset(junctionX, midY), width: 80, height: max(50, botArmY - topArmY + 30))));
    }
  }

  double _paintHeader(Canvas canvas, Size size, double startY, Paint thickPen, String divisionTitle, String categoryTitle, {bool showRightHeader = true}) {
    var y = startY;
    final title = (tournament.name.isNotEmpty ? tournament.name : 'TOURNAMENT NAME').toUpperCase();
    _drawText(canvas, title, size.width / 2, y, _bold(22), center: true);
    y += 28;
    if (tournament.dateRange.isNotEmpty || tournament.venue.isNotEmpty) {
      final sub = [tournament.dateRange, tournament.venue].where((s) => s.isNotEmpty).join(', ');
      _drawText(canvas, sub.toUpperCase(), size.width / 2, y, _normal(14), center: true);
      y += 20;
    }
    if (tournament.organizer.isNotEmpty) {
      _drawText(canvas, 'Organised by : ${tournament.organizer.toUpperCase()}', size.width / 2, y, _bold(16), center: true);
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

    // Right-side header (mirrored) — only for two-sided SE brackets
    if (showRightHeader) {
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

  /// Paints a placeholder "TBD" row for an unassigned bracket slot.
  void _paintTbdRow(Canvas canvas, int idx, double x, double y, Paint pen) {
    final right = x + listW;
    final tbdPen = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final boxLeft = x + noColW;
    final rect = RRect.fromLTRBR(boxLeft, y, right, y + rowH, const Radius.circular(6.0));
    canvas.drawRRect(rect, Paint()..color = const Color(0xFFF3F4F6)..style = PaintingStyle.fill);
    canvas.drawRRect(rect, tbdPen);

    _drawText(canvas, '$idx', x + noColW / 2, y + rowH / 2 - 6,
        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF)), center: true);
    _drawText(canvas, 'TBD', boxLeft + 6, y + rowH / 2 - 6,
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, color: Color(0xFF9CA3AF)));

    final lineY = y + rowH / 2;
    canvas.drawLine(Offset(right, lineY), Offset(right + roundColW, lineY), tbdPen);
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
        // BYE: straight pass-through line with dashed output
        canvas.drawLine(topIn, Offset(junctionX, topIn.dy), topPen);
        final nextJunctionX = mirrored ? junctionX - roundColW : junctionX + roundColW;
        // Dashed pass-through line to indicate BYE advancement
        final byeLinePen = Paint()..color = const Color(0xFF9CA3AF)..strokeWidth = 1.5..style = PaintingStyle.stroke;
        _drawDashedLine(canvas, Offset(junctionX, topIn.dy), Offset(nextJunctionX, topIn.dy), byeLinePen);
        
        _nodeOffsets[match.id] = Offset(nextJunctionX, topIn.dy);

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

    final r = 10.0;
    
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

    // Place B badge on the input side of the top arm, R badge on input side of bottom arm
    if (!mirrored) {
      _drawBadge(canvas, 'B', blueColor, junctionX - 24, effectiveTop.dy - 16);
      _drawBadge(canvas, 'R', redColor, junctionX - 24, effectiveBot.dy + 16);
    } else {
      _drawBadge(canvas, 'B', blueColor, junctionX + 24, effectiveTop.dy - 16);
      _drawBadge(canvas, 'R', redColor, junctionX + 24, effectiveBot.dy + 16);
    }

    // Match number on the output side of the junction
    final gNum = _matchGlobalNumbers[match.id];
    if (gNum != null) {
      if (!mirrored) {
        _drawText(canvas, '$gNum', junctionX + 14, midY - 7, _bold(11));
      } else {
        _drawText(canvas, '$gNum', junctionX - 14, midY - 7, _bold(11), alignRight: true);
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
    matchHitAreas.add(MapEntry(match.id, Rect.fromCenter(center: output, width: roundColW * 0.6, height: max(40, (effectiveBot.dy - effectiveTop.dy).abs() + 20))));
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

  /// Draws a dashed line between two points using the given paint.
  void _drawDashedLine(Canvas canvas, Offset from, Offset to, Paint paint, {double dashWidth = 6, double gapWidth = 4}) {
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final stepX = dx / distance;
    final stepY = dy / distance;
    var drawn = 0.0;
    var x = from.dx;
    var y = from.dy;
    while (drawn < distance) {
      final end = min(drawn + dashWidth, distance);
      canvas.drawLine(Offset(x, y), Offset(from.dx + stepX * end, from.dy + stepY * end), paint);
      drawn = end + gapWidth;
      x = from.dx + stepX * drawn;
      y = from.dy + stepY * drawn;
    }
  }

  @override
  bool shouldRepaint(covariant TieSheetPainter oldDelegate) => true;
}

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../domain/entities/match_entity.dart';
import '../../../tournament/domain/entities/tournament_entity.dart';
import '../../../participant/domain/entities/participant_entity.dart';

// ══════════════════════════════════════════════════════════════════════════════
// SECTION 1 — WIDGET  (TieSheetCanvasWidget + _TieSheetCanvasWidgetState)
// ══════════════════════════════════════════════════════════════════════════════

/// A widget that renders a TKD tie sheet using [CustomPainter].
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
            willChange: false,
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

// ══════════════════════════════════════════════════════════════════════════════
// SECTION 2 — COLOURS & PAINT UTILITIES
// ══════════════════════════════════════════════════════════════════════════════

/// All design-token colours used across the bracket canvas.
/// Centralising them here means a palette tweak is a one-line edit.
abstract final class _BracketColors {
  static const blue    = Color(0xFF2563EB); // Chung / Blue corner
  static const red     = Color(0xFFDC2626); // Hong  / Red  corner
  static const pending = Color(0xFFCBD5E1); // unresolved lines / TBD outlines
  static const muted   = Color(0xFF94A3B8); // dashed BYE lines, TBD text
  static const ink     = Color(0xFF1E293B); // primary text

  static const subtle  = Color(0xFF64748B); // secondary text
  static const rowFill = Color(0xFFF8FAFC); // participant row background
  static const hdrFill = Color(0xFFE2E8F0); // table-header background
  static const tbdFill = Color(0xFFF1F5F9); // TBD placeholder background
  static const cardBorder   = Color(0xFFCBD5E1); // soft card border
  static const connector    = Color(0xFF94A3B8); // default connector stroke
  static const connectorWon = Color(0xFF475569); // resolved connector stroke
  static const canvasBg     = Color(0xFFFFFEFC); // warm white canvas
  static const gold    = Color(0xFFFEF9C3);
  static const silver  = Color(0xFFF1F5F9);
  static const bronze     = Color(0xFFFED7AA);
  static const goldText   = Color(0xFF92400E);
  static const silverText = Color(0xFF475569);
  static const bronzeText = Color(0xFF9A3412);
  static const goldAccent   = Color(0xFFF59E0B);
  static const silverAccent = Color(0xFF94A3B8);
  static const bronzeAccent = Color(0xFFF97316);
  static const wbLabel = Color(0xFF2563EB);
  static const lbLabel = Color(0xFFDC2626);
  static const headerBg = Color(0xFF1E293B); // dark header banner
}

/// Lightweight [Paint] factories for recurring stroke/fill profiles.
abstract final class _Pens {
  /// Solid stroke, round caps — grid lines and outlines.
  static Paint thick(Color c, {double w = 1.5}) => Paint()
    ..color = c
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  /// 1 px solid stroke — dividers and pending match lines.
  static Paint thin(Color c, {double w = 1.0}) => Paint()
    ..color = c
    ..strokeWidth = w
    ..style = PaintingStyle.stroke;

  /// Stroke with round caps — winner / resolved advancement lines.
  static Paint round(Color c, {double w = 2.0}) => Paint()
    ..color = c
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  /// Filled shape — row backgrounds and badges.
  static Paint fill(Color c) => Paint()
    ..color = c
    ..style = PaintingStyle.fill;

  /// Soft shadow paint for card elevation.
  static Paint shadow({double blur = 6.0, Color color = const Color(0x1A000000)}) => Paint()
    ..color = color
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
}

// ══════════════════════════════════════════════════════════════════════════════
// SECTION 3 — PAINTER  (TieSheetPainter)
// ══════════════════════════════════════════════════════════════════════════════

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

  // ── Layout constants ───────────────────────────────────────────────────────
  static const double rowH        = 42.0;
  static const double rowGap      = 35.0;
  static const double pairGap     = 100.0;
  static const double noColW      = 32.0;
  static const double nameColW    = 200.0;
  static const double regIdColW   = 120.0;
  static const double roundColW   = 170.0;
  static const double headerH     = 100.0;
  static const double subHeaderH  = 28.0;
  static const double medalH      = 170.0;
  static const double margin      = 36.0;
  static const double centerGap   = 170.0;
  static const double sectionGap  = 50.0;
  static const double sectionLabelH = 32.0;
  static const double _cardRadius = 6.0;
  static const double _accentStripW = 4.0;

  static const double listW = noColW + nameColW + regIdColW;

  // Medal-table dimensions.
  static const double _medalTableW = 440.0;
  static const double _medalRowH   = 36.0;
  static const double _medalNameW  = 250.0;
  static const double _medalLabelW = 80.0;
  static const double _medalBlankW = _medalTableW - _medalNameW - _medalLabelW;

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

  // ── 3b  Data helpers ───────────────────────────────────────────────────────

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

  /// Total pixel height consumed by a one-sided R1 participant table.
  double _computeOneSidedHeight(List<MatchEntity> r1Matches) {
    double h = 0;
    for (var i = 0; i < r1Matches.length; i++) {
      final m = r1Matches[i];
      final rowCount = (m.participantBlueId != null ? 1 : 0) + (m.participantRedId != null ? 1 : 0);
      h += rowCount * rowH;
      if (rowCount == 2) h += rowGap; // gap between blue & red within the pair
      if (i < r1Matches.length - 1) h += pairGap;
    }
    return h;
  }

  // ── 3c  Canvas size calculation ────────────────────────────────────────────

  Size calculateCanvasSize() {
    if (_isDouble) return _calculateDECanvasSize();
    return _calculateSECanvasSize();
  }

  Size _calculateSECanvasSize() {
    final seMaxRound  = matches.isNotEmpty ? matches.map((mm) => mm.roundNumber).reduce(max) : 0;
    final mainMatches = matches
        .where((m) => !(m.roundNumber == seMaxRound && m.matchNumberInRound == 2))
        .toList();
    final winRounds = _maxRound(mainMatches);

    final width = margin * 2 + listW + (max(0, winRounds - 1) * roundColW) * 2 + centerGap + listW;

    final byRound = _groupByRound(mainMatches);
    final r1Matches = byRound[1] ?? [];
    final r1Count   = r1Matches.length;
    final leftR1    = r1Matches.where((m) => m.matchNumberInRound <= (r1Count + 1) ~/ 2).toList();
    final rightR1   = r1Matches.where((m) => m.matchNumberInRound >  (r1Count + 1) ~/ 2).toList();
    final tableH    = max(_computeOneSidedHeight(leftR1), _computeOneSidedHeight(rightR1));

    final height = margin + headerH + tableH + 60 + medalH + margin;
    return Size(max(width, 700), max(height, 500));
  }

  Size _calculateDECanvasSize() {
    final wbMatches = matches.where((m) => m.bracketId == winnersBracketId).toList();
    final lbMatches = matches.where((m) => m.bracketId == losersBracketId).toList();
    final gfMatches = matches.where((m) => m.bracketId != winnersBracketId && m.bracketId != losersBracketId).toList();
    final wbRounds  = _maxRound(wbMatches);
    final lbRounds  = _maxRound(lbMatches);

    final maxRounds  = max(wbRounds, lbRounds);
    final gfColumns  = gfMatches.isEmpty ? 0 : gfMatches.length;
    final width      = margin * 2 + listW + (maxRounds * roundColW) + (gfColumns * roundColW) + 100;

    final wbR1 = _groupByRound(wbMatches)[1] ?? [];
    final lbR1 = _groupByRound(lbMatches)[1] ?? [];
    final wbH  = _computeOneSidedHeight(wbR1);
    final lbH  = lbR1.isEmpty ? 80 : (lbR1.length * 2 * rowH + (lbR1.length - 1) * pairGap);

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

  // ── 3d  Paint entry-point ──────────────────────────────────────────────────

  @override
  void paint(Canvas canvas, Size size) {
    matchHitAreas.clear();
    _nodeOffsets.clear();
    _buildGlobalMatchNumbers();

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _Pens.fill(_BracketColors.canvasBg));

    final thickPen = _Pens.thick(_BracketColors.cardBorder);

    if (_isDouble) {
      _paintDE(canvas, size, thickPen);
    } else {
      _paintSE(canvas, size, thickPen);
    }

    _paintMedalTable(canvas, size, thickPen);
  }

  // ── 3e  Single-Elimination layout ─────────────────────────────────────────

  void _paintSE(Canvas canvas, Size size, Paint thickPen) {
    double startY = margin;
    startY = _paintHeader(canvas, size, startY, thickPen,
        tournament.categoryLabel.toUpperCase(),
        tournament.divisionLabel.toUpperCase());

    // Subtle separator line between left and right participant tables.
    _drawDashedLine(canvas, Offset(margin + listW + 20, startY), Offset(size.width - margin - listW - 20, startY), _Pens.thin(_BracketColors.pending), dashWidth: 8, gapWidth: 6);
    final tableTop = startY + 12;

    // Exclude the 3rd-place match from the main bracket tree.
    final seMaxRound  = matches.isNotEmpty ? matches.map((mm) => mm.roundNumber).reduce(max) : 0;
    final mainMatches = matches
        .where((m) => !(m.roundNumber == seMaxRound && m.matchNumberInRound == 2))
        .toList();

    final winRounds    = _maxRound(mainMatches);
    final winByRound   = _groupByRound(mainMatches);
    final r1Matches    = winByRound[1] ?? [];
    final r1Count      = r1Matches.length;
    final leftHalfCount = (r1Count + 1) ~/ 2;
    final rightEdge    = size.width - margin;
    final rightTableLeft = rightEdge - listW;

    if (r1Count == 1 && winRounds == 1) {
      // Special case: 2 players → direct final, no junction tree needed.
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
      final leftR1Matches  = r1Matches.where((m) => m.matchNumberInRound <= leftHalfCount).toList();
      final rightR1Matches = r1Matches.where((m) => m.matchNumberInRound >  leftHalfCount).toList();

      _paintParticipantList(canvas, leftR1Matches,  margin,         tableTop, thickPen, mirrored: false);
      _paintParticipantList(canvas, rightR1Matches, rightTableLeft, tableTop, thickPen, mirrored: true);
    }

    // Draw bracket tree (rounds 1 → final).
    for (var r = 1; r <= winRounds; r++) {
      final roundMatches = winByRound[r] ?? [];
      final c = roundMatches.length;
      for (final match in roundMatches) {
        if (r == winRounds) {
          _paintCenterFinalJunction(canvas, match, size.width / 2, thickPen);
        } else {
          final isLeft    = match.matchNumberInRound <= (c + 1) ~/ 2;
          final junctionX = isLeft
              ? margin + listW + (r * roundColW)
              : rightEdge - listW - (r * roundColW);
          _paintJunction(canvas, match, junctionX, thickPen, mirrored: !isLeft);
        }
      }
    }

    if (includeThirdPlaceMatch) {
      final thirdMaxRound = matches.isNotEmpty ? matches.map((mm) => mm.roundNumber).reduce(max) : 0;
      final thirdMatch    = matches.where((m) => m.roundNumber == thirdMaxRound && m.matchNumberInRound == 2).firstOrNull;
      if (thirdMatch != null) _paint3rdPlaceMatch(canvas, thirdMatch, thickPen, tableTop);
    }
  }

  // ── 3f  Double-Elimination layout ─────────────────────────────────────────

  void _paintDE(Canvas canvas, Size size, Paint thickPen) {
    double startY = margin;
    startY = _paintHeader(canvas, size, startY, thickPen,
        tournament.categoryLabel.toUpperCase(),
        tournament.divisionLabel.toUpperCase(),
        showRightHeader: false);

    final wbMatches = matches.where((m) => m.bracketId == winnersBracketId).toList();
    final lbMatches = matches.where((m) => m.bracketId == losersBracketId).toList();
    // Grand Finals = matches belonging to neither WB nor LB.
    final gfMatches = matches.where((m) => m.bracketId != winnersBracketId && m.bracketId != losersBracketId).toList();

    final wbRounds  = _maxRound(wbMatches);
    final lbRounds  = _maxRound(lbMatches);
    final wbByRound = _groupByRound(wbMatches);
    final lbByRound = _groupByRound(lbMatches);

    // ── Winners Bracket ──
    _paintSectionLabel(canvas, 'WINNERS BRACKET', margin, startY, size.width - margin * 2, _BracketColors.wbLabel);
    final wbTableTop = startY + sectionLabelH + 8;

    final wbR1 = wbByRound[1] ?? [];
    _paintParticipantList(canvas, wbR1, margin, wbTableTop, thickPen, mirrored: false);

    for (var r = 1; r <= wbRounds; r++) {
      final junctionX = margin + listW + (r * roundColW);
      for (final match in wbByRound[r] ?? []) {
        _paintJunction(canvas, match, junctionX, thickPen, mirrored: false);
      }
    }

    // ── Losers Bracket ──
    final wbH         = _computeOneSidedHeight(wbR1);
    final lbSectionTop = wbTableTop + wbH + sectionGap;
    _paintSectionLabel(canvas, 'LOSERS BRACKET', margin, lbSectionTop, size.width - margin * 2, _BracketColors.lbLabel);
    final lbTableTop = lbSectionTop + sectionLabelH + 8;

    // LB R1 slots are often TBD at generation time (participants drop in from
    // WB losses). Always render every slot — real data or TBD placeholder —
    // so junctions always have a valid node offset to connect to.
    final lbR1 = lbByRound[1] ?? [];
    var    lbIdx = 0;
    double lbY   = lbTableTop;
    final  lbNodeX = margin + listW;
    for (final m in lbR1) {
      final b = _findP(m.participantBlueId);
      final r = _findP(m.participantRedId);

      lbIdx++;
      if (b != null) {
        _paintParticipantRow(canvas, lbIdx, b, margin, lbY, thickPen, mirrored: false);
        _nodeOffsets[b.id] = Offset(lbNodeX, lbY + rowH / 2);
      } else {
        _paintTbdRow(canvas, lbIdx, margin, lbY);
        _nodeOffsets['${m.id}_blue'] = Offset(lbNodeX, lbY + rowH / 2);
      }
      lbY += rowH;

      lbIdx++;
      if (r != null) {
        _paintParticipantRow(canvas, lbIdx, r, margin, lbY, thickPen, mirrored: false);
        _nodeOffsets[r.id] = Offset(lbNodeX, lbY + rowH / 2);
      } else {
        _paintTbdRow(canvas, lbIdx, margin, lbY);
        _nodeOffsets['${m.id}_red'] = Offset(lbNodeX, lbY + rowH / 2);
      }
      lbY += rowH;
      lbY += pairGap;
    }

    for (var r = 1; r <= lbRounds; r++) {
      final junctionX = margin + listW + (r * roundColW);
      for (final match in lbByRound[r] ?? []) {
        _paintJunction(canvas, match, junctionX, thickPen, mirrored: false);
      }
    }

    // ── Grand Finals ──
    if (gfMatches.isNotEmpty) {
      final gfX = margin + listW + (max(wbRounds, lbRounds) * roundColW) + roundColW;
      final gf1 = gfMatches.first;

      final wbChampOffset = _nodeOffsets[gf1.participantBlueId] ?? _nodeOffsets[gf1.id];
      final lbChampOffset = _nodeOffsets[gf1.participantRedId]  ?? _nodeOffsets[gf1.id];
      final gfTopY  = wbChampOffset?.dy ?? (wbTableTop + wbH / 2);
      final gfBotY  = lbChampOffset?.dy ?? (lbTableTop + 50);
      final gfMidY  = (gfTopY + gfBotY) / 2;

      _nodeOffsets[gf1.id] = Offset(gfX, gfMidY);
      _paintGrandFinalNode(canvas, gf1, gfX, gfTopY, gfBotY, thickPen, 'GRAND FINAL');

      if (gfMatches.length > 1) {
        final gf2    = gfMatches[1];
        final resetX = gfX + roundColW;
        _nodeOffsets[gf2.id] = Offset(resetX, gfMidY);
        canvas.drawLine(Offset(gfX, gfMidY), Offset(resetX, gfMidY), thickPen);
        _paintGrandFinalNode(canvas, gf2, resetX, gfMidY - 25, gfMidY + 25, thickPen, 'RESET');
      }
    }
  }

  // ── 3g  Shared participant / junction painting ─────────────────────────────

  void _paintSectionLabel(Canvas canvas, String label, double x, double y, double width, Color color) {
    final rect = RRect.fromLTRBR(x, y, x + width, y + sectionLabelH, const Radius.circular(6));
    canvas.drawRRect(rect, _Pens.fill(color.withValues(alpha: 0.1)));
    canvas.drawRRect(rect, _Pens.thin(color, w: 1.5));
    _drawText(canvas, label, x + width / 2, y + 8,
        TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
        center: true);
  }

  void _paintGrandFinalNode(Canvas canvas, MatchEntity match, double x, double topY, double botY, Paint pen, String label) {
    final pendingPen = _Pens.thin(_BracketColors.pending);
    final winnerPen  = _Pens.round(_BracketColors.connectorWon);
    final midY = (topY + botY) / 2;

    canvas.drawLine(Offset(x, topY), Offset(x, botY), pen);

    final topIn = _resolveInputOffset(match, isTopSlot: true);
    final botIn = _resolveInputOffset(match, isTopSlot: false);
    if (topIn != null) canvas.drawLine(topIn, Offset(x, topY), match.participantBlueId != null ? winnerPen : pendingPen);
    if (botIn != null) canvas.drawLine(botIn, Offset(x, botY), match.participantRedId  != null ? winnerPen : pendingPen);

    canvas.drawLine(Offset(x, midY), Offset(x + 40, midY), match.winnerId != null ? winnerPen : pendingPen);

    _drawText(canvas, label, x, topY - 20, _bold(10), center: true);
    _drawBadge(canvas, 'B', _BracketColors.blue, x + 16, topY - 6);
    _drawBadge(canvas, 'R', _BracketColors.red,  x + 16, botY + 14);

    final gNum = _matchGlobalNumbers[match.id];
    if (gNum != null) _drawMatchPill(canvas, '$gNum', x + 18, midY);

    if (match.winnerId != null) {
      final w = _findP(match.winnerId);
      if (w != null) _drawText(canvas, _pName(w), x + 45, midY - 6, _bold(9));
    }

    matchHitAreas.add(MapEntry(match.id,
        Rect.fromCenter(center: Offset(x, midY), width: roundColW * 0.6, height: max(35, (botY - topY).abs() + 10))));
  }

  void _paintCenterFinalJunction(Canvas canvas, MatchEntity match, double junctionX, Paint pen) {
    if (match.resultType == MatchResultType.bye) return;

    final pendingPen = _Pens.thin(_BracketColors.pending);
    final winnerPen  = _Pens.round(_BracketColors.connectorWon);
    final topPen     = match.participantBlueId != null ? winnerPen : pendingPen;
    final botPen     = match.participantRedId  != null ? winnerPen : pendingPen;

    final topIn = _resolveInputOffset(match, isTopSlot: true);
    final botIn = _resolveInputOffset(match, isTopSlot: false);
    if (topIn == null || botIn == null) return;

    final rawMidY    = (topIn.dy + botIn.dy) / 2;
    const minSpan    = 60.0;
    final actualSpan = (botIn.dy - topIn.dy).abs();
    final halfSpan   = max(actualSpan, minSpan) / 2;
    final topArmY    = rawMidY - halfSpan;
    final botArmY    = rawMidY + halfSpan;

    // ── Smooth Bezier arms instead of hard right-angle lines ──
    const curveR = 12.0;
    final topPath = Path()
      ..moveTo(topIn.dx, topIn.dy)
      ..lineTo(junctionX - curveR, topIn.dy)
      ..quadraticBezierTo(junctionX, topIn.dy, junctionX, topIn.dy + curveR)
      ..lineTo(junctionX, rawMidY);
    canvas.drawPath(topPath, topPen);

    final botPath = Path()
      ..moveTo(botIn.dx, botIn.dy)
      ..lineTo(junctionX + curveR, botIn.dy)
      ..quadraticBezierTo(junctionX, botIn.dy, junctionX, botIn.dy - curveR)
      ..lineTo(junctionX, rawMidY);
    canvas.drawPath(botPath, botPen);

    // ── Vertical merge line ──
    canvas.drawLine(Offset(junctionX, topArmY), Offset(junctionX, botArmY), _Pens.thin(_BracketColors.connector));

    _nodeOffsets[match.id] = Offset(junctionX, rawMidY);

    // ── Match number pill ──
    final gNum = _matchGlobalNumbers[match.id];
    if (gNum != null) {
      _drawMatchPill(canvas, '$gNum', junctionX, rawMidY);
    }

    _drawBadge(canvas, 'B', _BracketColors.blue, junctionX - 20, topArmY - 14);
    _drawBadge(canvas, 'R', _BracketColors.red,  junctionX + 20, botArmY + 14);

    if (match.winnerId != null) {
      final w = _findP(match.winnerId);
      if (w != null) _drawText(canvas, _pName(w), junctionX, rawMidY - 20, _bold(9), center: true);
    }

    matchHitAreas.add(MapEntry(match.id,
        Rect.fromCenter(center: Offset(junctionX, rawMidY), width: 80, height: max(50, botArmY - topArmY + 30))));
  }

  double _paintHeader(
    Canvas canvas, Size size, double startY, Paint thickPen,
    String divisionTitle, String categoryTitle, {bool showRightHeader = true}
  ) {
    var y = startY;

    // ── Dark header banner with tournament info ──
    final bannerH = 64.0;
    final bannerRect = RRect.fromLTRBR(margin, y, size.width - margin, y + bannerH, const Radius.circular(8));
    canvas.drawRRect(bannerRect, _Pens.fill(_BracketColors.headerBg));

    final title = (tournament.name.isNotEmpty ? tournament.name : 'TOURNAMENT NAME').toUpperCase();
    _drawText(canvas, title, size.width / 2, y + 12,
        const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Roboto', letterSpacing: 1.2), center: true);

    if (tournament.dateRange.isNotEmpty || tournament.venue.isNotEmpty) {
      final sub = [tournament.dateRange, tournament.venue].where((s) => s.isNotEmpty).join('  •  ');
      _drawText(canvas, sub.toUpperCase(), size.width / 2, y + 34,
          TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11, fontFamily: 'Roboto', letterSpacing: 0.5), center: true);
    }
    if (tournament.organizer.isNotEmpty) {
      _drawText(canvas, 'Organised by ${tournament.organizer.toUpperCase()}', size.width / 2, y + 48,
          TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 10, fontFamily: 'Roboto'), center: true);
    }
    y += bannerH + 12;

    // ── Table column headers ──
    final headerRowTop    = y;
    final headerRowBottom = y + subHeaderH;

    // Left table header.
    final leftHeaderX = margin;
    final rRectL = RRect.fromLTRBR(leftHeaderX, headerRowTop, leftHeaderX + listW, headerRowBottom, const Radius.circular(_cardRadius));
    canvas.drawRRect(rRectL, _Pens.fill(_BracketColors.hdrFill));
    canvas.drawRRect(rRectL, _Pens.thin(_BracketColors.cardBorder));
    canvas.drawLine(Offset(leftHeaderX + noColW, headerRowTop), Offset(leftHeaderX + noColW, headerRowBottom), _Pens.thin(_BracketColors.pending));
    canvas.drawLine(Offset(leftHeaderX + noColW + nameColW, headerRowTop), Offset(leftHeaderX + noColW + nameColW, headerRowBottom), _Pens.thin(_BracketColors.pending));

    final hdrTextY = headerRowTop + subHeaderH / 2 - 6;
    _drawText(canvas, '#', leftHeaderX + noColW / 2, hdrTextY, _normal(11), center: true);
    _drawText(canvas, divisionTitle.isEmpty ? 'DIVISION' : divisionTitle, leftHeaderX + noColW + nameColW / 2, hdrTextY, _normal(11), center: true);
    _drawText(canvas, categoryTitle.isEmpty ? 'CATEGORY' : categoryTitle, leftHeaderX + noColW + nameColW + regIdColW / 2, hdrTextY, _normal(11), center: true);

    // Right table header (mirrored) — only for two-sided SE brackets.
    if (showRightHeader) {
      final rightHeaderX = size.width - margin - listW;
      final rRectR = RRect.fromLTRBR(rightHeaderX, headerRowTop, rightHeaderX + listW, headerRowBottom, const Radius.circular(_cardRadius));
      canvas.drawRRect(rRectR, _Pens.fill(_BracketColors.hdrFill));
      canvas.drawRRect(rRectR, _Pens.thin(_BracketColors.cardBorder));
      canvas.drawLine(Offset(rightHeaderX + regIdColW, headerRowTop), Offset(rightHeaderX + regIdColW, headerRowBottom), _Pens.thin(_BracketColors.pending));
      canvas.drawLine(Offset(rightHeaderX + regIdColW + nameColW, headerRowTop), Offset(rightHeaderX + regIdColW + nameColW, headerRowBottom), _Pens.thin(_BracketColors.pending));

      _drawText(canvas, categoryTitle.isEmpty ? 'CATEGORY' : categoryTitle, rightHeaderX + regIdColW / 2, hdrTextY, _normal(11), center: true);
      _drawText(canvas, divisionTitle.isEmpty ? 'DIVISION' : divisionTitle, rightHeaderX + regIdColW + nameColW / 2, hdrTextY, _normal(11), center: true);
      _drawText(canvas, '#', rightHeaderX + listW - noColW / 2, hdrTextY, _normal(11), center: true);
    }

    return headerRowBottom + 12;
  }

  void _paintParticipantRow(Canvas canvas, int idx, ParticipantEntity p, double x, double y, Paint pen, {required bool mirrored}) {
    final right = x + listW;
    final connectorPen = _Pens.round(_BracketColors.connector, w: 1.5);

    if (!mirrored) {
      // ── Card with shadow ──
      final cardRect = RRect.fromLTRBR(x, y + 1, right, y + rowH - 1, const Radius.circular(_cardRadius));
      canvas.drawRRect(cardRect.shift(const Offset(1, 2)), _Pens.shadow(blur: 4));
      canvas.drawRRect(cardRect, _Pens.fill(_BracketColors.rowFill));
      canvas.drawRRect(cardRect, _Pens.thin(_BracketColors.cardBorder));

      // ── Blue accent strip on left edge ──
      final accentRect = RRect.fromLTRBAndCorners(x, y + 1, x + _accentStripW, y + rowH - 1,
          topLeft: const Radius.circular(_cardRadius), bottomLeft: const Radius.circular(_cardRadius));
      canvas.drawRRect(accentRect, _Pens.fill(_BracketColors.blue));

      // ── Column divider ──
      canvas.drawLine(Offset(x + noColW, y + 4), Offset(x + noColW, y + rowH - 4), _Pens.thin(_BracketColors.pending));
      canvas.drawLine(Offset(x + noColW + nameColW, y + 4), Offset(x + noColW + nameColW, y + rowH - 4), _Pens.thin(_BracketColors.pending));

      // ── Text ──
      final textY = y + rowH / 2 - 6;
      _drawText(canvas, '$idx', x + noColW / 2, textY, _normal(10), center: true);
      _drawText(canvas, _pName(p), x + noColW + 8, textY, _bold(10));
      if (p.registrationId != null && p.registrationId!.isNotEmpty) {
        _drawText(canvas, p.registrationId!, right - 8, textY, _normal(9), alignRight: true);
      }

      // ── Connector arm ──
      canvas.drawLine(Offset(right, y + rowH / 2), Offset(right + roundColW, y + rowH / 2), connectorPen);
    } else {
      // ── Mirrored card with shadow ──
      final cardRect = RRect.fromLTRBR(x, y + 1, right, y + rowH - 1, const Radius.circular(_cardRadius));
      canvas.drawRRect(cardRect.shift(const Offset(-1, 2)), _Pens.shadow(blur: 4));
      canvas.drawRRect(cardRect, _Pens.fill(_BracketColors.rowFill));
      canvas.drawRRect(cardRect, _Pens.thin(_BracketColors.cardBorder));

      // ── Blue accent strip on right edge ──
      final accentRect = RRect.fromLTRBAndCorners(right - _accentStripW, y + 1, right, y + rowH - 1,
          topRight: const Radius.circular(_cardRadius), bottomRight: const Radius.circular(_cardRadius));
      canvas.drawRRect(accentRect, _Pens.fill(_BracketColors.blue));

      // ── Column divider ──
      canvas.drawLine(Offset(x + regIdColW, y + 4), Offset(x + regIdColW, y + rowH - 4), _Pens.thin(_BracketColors.pending));
      canvas.drawLine(Offset(x + regIdColW + nameColW, y + 4), Offset(x + regIdColW + nameColW, y + rowH - 4), _Pens.thin(_BracketColors.pending));

      // ── Text ──
      final textY = y + rowH / 2 - 6;
      if (p.registrationId != null && p.registrationId!.isNotEmpty) {
        _drawText(canvas, p.registrationId!, x + 8, textY, _normal(9));
      }
      _drawText(canvas, _pName(p), x + regIdColW + nameColW - 8, textY, _bold(10), alignRight: true);
      _drawText(canvas, '$idx', right - noColW / 2, textY, _normal(10), center: true);

      // ── Connector arm ──
      canvas.drawLine(Offset(x, y + rowH / 2), Offset(x - roundColW, y + rowH / 2), connectorPen);
    }
  }

  /// Paints a placeholder row for a bracket slot with no assigned participant.
  void _paintTbdRow(Canvas canvas, int idx, double x, double y) {
    final right = x + listW;
    final connectorPen = _Pens.thin(_BracketColors.pending);

    final cardRect = RRect.fromLTRBR(x, y + 1, right, y + rowH - 1, const Radius.circular(_cardRadius));
    canvas.drawRRect(cardRect, _Pens.fill(_BracketColors.tbdFill));
    canvas.drawRRect(cardRect, _Pens.thin(_BracketColors.pending));

    // ── Gray accent strip ──
    final accentRect = RRect.fromLTRBAndCorners(x, y + 1, x + _accentStripW, y + rowH - 1,
        topLeft: const Radius.circular(_cardRadius), bottomLeft: const Radius.circular(_cardRadius));
    canvas.drawRRect(accentRect, _Pens.fill(_BracketColors.muted));

    final textY = y + rowH / 2 - 6;
    _drawText(canvas, '$idx', x + noColW / 2, textY,
        const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _BracketColors.muted), center: true);
    _drawText(canvas, 'TBD', x + noColW + 8, textY,
        const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, color: _BracketColors.muted));

    canvas.drawLine(Offset(right, y + rowH / 2), Offset(right + roundColW, y + rowH / 2), connectorPen);
  }

  /// Renders a flat R1 participant table, writing [_nodeOffsets] for each slot
  /// so that [_paintJunction] can resolve junction input coordinates later.
  ///
  /// [mirrored] flips column order and reverses the direction of the arm that
  /// connects the row to the bracket tree.
  void _paintParticipantList(
    Canvas canvas,
    List<MatchEntity> r1Matches,
    double x,
    double startY,
    Paint pen, {
    required bool mirrored,
    int startIdx = 0,
  }) {
    var idx  = startIdx;
    var y    = startY;
    // Non-mirrored sides connect at the right edge; mirrored sides at the left.
    final nodeX = mirrored ? x : x + listW;

    for (final m in r1Matches) {
      final b = _findP(m.participantBlueId);
      final r = _findP(m.participantRedId);
      if (b != null) {
        idx++;
        _paintParticipantRow(canvas, idx, b, x, y, pen, mirrored: mirrored);
        _nodeOffsets[b.id] = Offset(nodeX, y + rowH / 2);
        y += rowH;
        if (r != null) y += rowGap; // intra-pair gap between blue & red rows
      }
      if (r != null) {
        idx++;
        _paintParticipantRow(canvas, idx, r, x, y, pen, mirrored: mirrored);
        _nodeOffsets[r.id] = Offset(nodeX, y + rowH / 2);
        y += rowH;
      }
      y += pairGap;
    }
  }

  void _paintJunction(Canvas canvas, MatchEntity match, double junctionX, Paint pen, {required bool mirrored}) {
    final pendingPen = _Pens.thin(_BracketColors.pending);
    final winnerPen  = _Pens.round(_BracketColors.connectorWon);

    final topPen = match.participantBlueId != null ? winnerPen : pendingPen;
    final botPen = match.participantRedId  != null ? winnerPen : pendingPen;
    final outPen = match.winnerId          != null ? winnerPen : pendingPen;

    final isBye = match.resultType == MatchResultType.bye;
    if (isBye) {
      final topIn = _resolveInputOffset(match, isTopSlot: true);
      if (topIn != null) {
        canvas.drawLine(topIn, Offset(junctionX, topIn.dy), topPen);
        final nextJunctionX = mirrored ? junctionX - roundColW : junctionX + roundColW;
        // Dashed line signals a BYE advancement (no real match played).
        final byePen = _Pens.thin(_BracketColors.muted, w: 1.5);
        _drawDashedLine(canvas, Offset(junctionX, topIn.dy), Offset(nextJunctionX, topIn.dy), byePen);
        _nodeOffsets[match.id] = Offset(nextJunctionX, topIn.dy);
        matchHitAreas.add(MapEntry(match.id,
            Rect.fromCenter(center: Offset(junctionX, topIn.dy), width: roundColW * 0.6, height: 35)));
      }
      return;
    }

    final topIn = _resolveInputOffset(match, isTopSlot: true);
    final botIn = _resolveInputOffset(match, isTopSlot: false);

    late Offset effectiveTop, effectiveBot;
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
      final estY   = 100.0 + (match.matchNumberInRound * 2 - 1) * (rowH + pairGap / 2);
      effectiveTop = Offset(junctionX, estY);
      effectiveBot = Offset(junctionX, estY + rowH * 2);
    }

    final midY  = (effectiveTop.dy + effectiveBot.dy) / 2;
    final output = Offset(junctionX, midY);
    _nodeOffsets[match.id] = output;

    const r = 10.0; // corner-radius for Bezier arms

    final pathT = Path()
      ..moveTo(effectiveTop.dx, effectiveTop.dy)
      ..lineTo(junctionX - (mirrored ? -r : r), effectiveTop.dy)
      ..quadraticBezierTo(junctionX, effectiveTop.dy, junctionX, effectiveTop.dy + r)
      ..lineTo(junctionX, midY);
    canvas.drawPath(pathT, topPen);

    final pathB = Path()
      ..moveTo(effectiveBot.dx, effectiveBot.dy)
      ..lineTo(junctionX - (mirrored ? -r : r), effectiveBot.dy)
      ..quadraticBezierTo(junctionX, effectiveBot.dy, junctionX, effectiveBot.dy - r)
      ..lineTo(junctionX, midY);
    canvas.drawPath(pathB, botPen);

    final nextJunctionX = mirrored ? junctionX - roundColW : junctionX + roundColW;
    canvas.drawLine(output, Offset(nextJunctionX, midY), outPen);

    if (!mirrored) {
      _drawBadge(canvas, 'B', _BracketColors.blue, junctionX - 20, effectiveTop.dy - 14);
      _drawBadge(canvas, 'R', _BracketColors.red,  junctionX - 20, effectiveBot.dy + 14);
    } else {
      _drawBadge(canvas, 'B', _BracketColors.blue, junctionX + 20, effectiveTop.dy - 14);
      _drawBadge(canvas, 'R', _BracketColors.red,  junctionX + 20, effectiveBot.dy + 14);
    }

    final gNum = _matchGlobalNumbers[match.id];
    if (gNum != null) {
      _drawMatchPill(canvas, '$gNum', junctionX, midY);
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

    matchHitAreas.add(MapEntry(match.id,
        Rect.fromCenter(center: output, width: roundColW * 0.6,
            height: max(40, (effectiveBot.dy - effectiveTop.dy).abs() + 20))));
  }

  Offset? _resolveInputOffset(MatchEntity match, {required bool isTopSlot}) {
    // WT convention: top slot = Chung (Blue), bottom slot = Hong (Red).
    final pId = isTopSlot ? match.participantBlueId : match.participantRedId;
    if (pId != null) {
      if (_nodeOffsets.containsKey(pId)) return _nodeOffsets[pId];
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
    final finals    = matches.where((mm) => mm.roundNumber == allRounds && mm.matchNumberInRound == 1).firstOrNull;
    if (finals == null || !_nodeOffsets.containsKey(finals.id)) return;

    final fPos = _nodeOffsets[finals.id]!;
    final x    = fPos.dx;
    final y    = fPos.dy + rowH * 4 + 60;

    canvas.drawLine(Offset(x - 50, y - 20), Offset(x, y - 20), pen);
    canvas.drawLine(Offset(x - 50, y + 20), Offset(x, y + 20), pen);
    canvas.drawLine(Offset(x, y - 20),      Offset(x, y + 20), pen);
    canvas.drawLine(Offset(x, y),           Offset(x + 30, y), pen);

    _nodeOffsets[m.id] = Offset(x, y);
    matchHitAreas.add(MapEntry(m.id, Rect.fromCenter(center: Offset(x, y), width: 60, height: 50)));

    _drawText(canvas, '3rd Place', x - 25, y - 34, _bold(9), center: true);
    _drawText(canvas, 'B', x + 4, y - 34,
        const TextStyle(color: _BracketColors.blue, fontWeight: FontWeight.bold, fontSize: 9));
    _drawText(canvas, 'R', x + 4, y + 22,
        const TextStyle(color: _BracketColors.red,  fontWeight: FontWeight.bold, fontSize: 9));

    if (m.winnerId != null) {
      final w = _findP(m.winnerId);
      if (w != null) _drawText(canvas, _pName(w), x + 35, y - 6, _bold(9));
    }
  }

  // ── 3h  Medal table ────────────────────────────────────────────────────────

  void _paintMedalTable(Canvas canvas, Size size, Paint pen) {
    final x = (size.width - _medalTableW) / 2;
    final y = size.height - medalH - margin + 10;

    final accentColors = [_BracketColors.goldAccent, _BracketColors.silverAccent, _BracketColors.bronzeAccent, _BracketColors.bronzeAccent];
    final fills = [_Pens.fill(_BracketColors.gold), _Pens.fill(_BracketColors.silver), _Pens.fill(_BracketColors.bronze), _Pens.fill(_BracketColors.bronze)];

    for (var row = 0; row < 4; row++) {
      final rY = y + row * (_medalRowH + 4);

      // ── Shadow + Card ──
      final fullRect = RRect.fromLTRBR(x + _medalBlankW, rY, x + _medalTableW, rY + _medalRowH, const Radius.circular(_cardRadius));
      canvas.drawRRect(fullRect.shift(const Offset(1, 2)), _Pens.shadow(blur: 3));

      // Name area
      final nameRect = RRect.fromLTRBAndCorners(x + _medalBlankW, rY, x + _medalBlankW + _medalNameW, rY + _medalRowH,
          topLeft: const Radius.circular(_cardRadius), bottomLeft: const Radius.circular(_cardRadius));
      canvas.drawRRect(nameRect, _Pens.fill(_BracketColors.rowFill));

      // Label area
      final labelRect = RRect.fromLTRBAndCorners(x + _medalBlankW + _medalNameW, rY, x + _medalTableW, rY + _medalRowH,
          topRight: const Radius.circular(_cardRadius), bottomRight: const Radius.circular(_cardRadius));
      canvas.drawRRect(labelRect, fills[row]);

      // Border
      canvas.drawRRect(fullRect, _Pens.thin(_BracketColors.cardBorder));
      canvas.drawLine(Offset(x + _medalBlankW + _medalNameW, rY), Offset(x + _medalBlankW + _medalNameW, rY + _medalRowH), _Pens.thin(_BracketColors.pending));

      // ── Accent strip ──
      final accentRect = RRect.fromLTRBAndCorners(x + _medalBlankW, rY, x + _medalBlankW + _accentStripW, rY + _medalRowH,
          topLeft: const Radius.circular(_cardRadius), bottomLeft: const Radius.circular(_cardRadius));
      canvas.drawRRect(accentRect, _Pens.fill(accentColors[row]));
    }

    final labelX = x + _medalBlankW + _medalNameW + _medalLabelW / 2;
    final textStyles = [
      const TextStyle(color: _BracketColors.goldText,   fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      const TextStyle(color: _BracketColors.silverText, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      const TextStyle(color: _BracketColors.bronzeText, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      const TextStyle(color: _BracketColors.bronzeText, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
    ];
    final labels = ['Gold', 'Silver', 'Bronze', 'Bronze'];
    for (var row = 0; row < 4; row++) {
      final rY = y + row * (_medalRowH + 4);
      _drawText(canvas, labels[row], labelX, rY + _medalRowH / 2 - 7, textStyles[row], center: true);
    }

    // ── Populate winner names ──
    final allRounds = matches.map((m) => m.roundNumber).reduce(max);
    final finals    = matches.where((m) => m.roundNumber == allRounds && m.matchNumberInRound == 1).firstOrNull;
    if (finals != null && finals.winnerId != null) {
      final gold     = _findP(finals.winnerId);
      final silverId = finals.winnerId == finals.participantRedId ? finals.participantBlueId : finals.participantRedId;
      final silver   = _findP(silverId);
      if (gold   != null) _drawText(canvas, _pName(gold),   x + _medalBlankW + 14, y + _medalRowH / 2 - 7, _bold(11));
      if (silver != null) _drawText(canvas, _pName(silver), x + _medalBlankW + 14, y + (_medalRowH + 4) + _medalRowH / 2 - 7, _bold(11));
    }
    // 3rd-place match: winner = Bronze 1, loser = Bronze 2
    final thirdM = matches.where((m) => m.roundNumber == allRounds && m.matchNumberInRound == 2).firstOrNull;
    if (thirdM != null) {
      if (thirdM.winnerId != null) {
        final bronze1 = _findP(thirdM.winnerId);
        if (bronze1 != null) _drawText(canvas, _pName(bronze1), x + _medalBlankW + 14, y + 2 * (_medalRowH + 4) + _medalRowH / 2 - 7, _bold(11));
      }
      final loserId = thirdM.winnerId == thirdM.participantRedId ? thirdM.participantBlueId : thirdM.participantRedId;
      if (loserId != null) {
        final bronze2 = _findP(loserId);
        if (bronze2 != null) _drawText(canvas, _pName(bronze2), x + _medalBlankW + 14, y + 3 * (_medalRowH + 4) + _medalRowH / 2 - 7, _bold(11));
      }
    }
  }

  // ── 3i  Text & drawing primitives ─────────────────────────────────────────

  ParticipantEntity? _findP(String? id) =>
      id == null ? null : participants.where((p) => p.id == id).firstOrNull;

  String _pName(ParticipantEntity p) => '${p.firstName} ${p.lastName}'.toUpperCase();

  TextStyle _bold(double size)   => TextStyle(color: _BracketColors.ink,    fontSize: size, fontWeight: FontWeight.bold, fontFamily: 'Roboto');
  TextStyle _normal(double size) => TextStyle(color: _BracketColors.subtle, fontSize: size, fontFamily: 'Roboto');

  void _drawBadge(Canvas canvas, String text, Color color, double cx, double cy) {
    canvas.drawCircle(Offset(cx, cy), 10.0, _Pens.fill(color));
    canvas.drawCircle(Offset(cx, cy), 10.0, _Pens.thin(color.withValues(alpha: 0.3)));
    _drawText(canvas, text, cx, cy - 5,
        const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'Roboto'), center: true);
  }

  /// Match number display as a small rounded pill.
  void _drawMatchPill(Canvas canvas, String text, double cx, double cy) {
    final pillRect = RRect.fromLTRBR(cx - 16, cy - 11, cx + 16, cy + 11, const Radius.circular(11));
    canvas.drawRRect(pillRect.shift(const Offset(0.5, 1)), _Pens.shadow(blur: 2));
    canvas.drawRRect(pillRect, _Pens.fill(Colors.white));
    canvas.drawRRect(pillRect, _Pens.thin(_BracketColors.connector));
    _drawText(canvas, text, cx, cy - 6,
        const TextStyle(color: _BracketColors.ink, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Roboto'), center: true);
  }

  void _drawText(Canvas canvas, String text, double x, double y, TextStyle style, {bool center = false, bool alignRight = false}) {
    final tp = TextPainter(text: TextSpan(text: text, style: style), textDirection: TextDirection.ltr);
    tp.layout();
    var drawX = x;
    if (center)     drawX -= tp.width / 2;
    if (alignRight) drawX -= tp.width;
    tp.paint(canvas, Offset(drawX, y));
  }

  void _drawDashedLine(Canvas canvas, Offset from, Offset to, Paint paint, {double dashWidth = 6, double gapWidth = 4}) {
    final dx       = to.dx - from.dx;
    final dy       = to.dy - from.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final stepX    = dx / distance;
    final stepY    = dy / distance;
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
  // Repaint only when the data that drives the visual output actually changes.
  bool shouldRepaint(covariant TieSheetPainter old) =>
      old.matches != matches ||
      old.participants != participants ||
      old.bracketType != bracketType ||
      old.includeThirdPlaceMatch != includeThirdPlaceMatch;
}

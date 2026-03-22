import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/services/match_numbering_utility.dart';
import '../../../tournament/domain/entities/tournament_entity.dart';
import '../../../participant/domain/entities/participant_entity.dart';
import 'participant_slot_hit_area.dart';
import 'tie_sheet_theme_config.dart';

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

  /// Whether bracket edit mode is active (enables drag-swap and tap-edit).
  final bool isEditModeEnabled;

  /// Optional theme configuration for the canvas (default vs print mode).
  final TieSheetThemeConfig themeConfig;

  /// Called when a participant slot swap is completed via drag-and-drop.
  final void Function(
    ParticipantSlotHitArea source,
    ParticipantSlotHitArea target,
  )? onParticipantSlotSwapped;

  /// Called when a participant slot is tapped in edit mode.
  final void Function(ParticipantSlotHitArea slot)? onParticipantSlotTapped;

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
    this.isEditModeEnabled = false,
    this.themeConfig = const TieSheetThemeConfig.defaultMode(),
    this.onParticipantSlotSwapped,
    this.onParticipantSlotTapped,
  });

  @override
  State<TieSheetCanvasWidget> createState() => _TieSheetCanvasWidgetState();
}

class _TieSheetCanvasWidgetState extends State<TieSheetCanvasWidget> {
  List<MapEntry<String, Rect>> _hitAreas = [];
  List<ParticipantSlotHitArea> _participantSlotHitAreas = [];

  /// Pre-decoded logo images for the [TieSheetPainter].
  ui.Image? _leftLogoImage;
  ui.Image? _rightLogoImage;

  @override
  void initState() {
    super.initState();
    _loadLogoImages();
    WidgetsBinding.instance.addPostFrameCallback((_) => _rebuildHitAreas());
  }

  @override
  void didUpdateWidget(covariant TieSheetCanvasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload logos if the tournament URLs changed.
    if (oldWidget.tournament.leftLogoUrl != widget.tournament.leftLogoUrl ||
        oldWidget.tournament.rightLogoUrl != widget.tournament.rightLogoUrl) {
      _loadLogoImages();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _rebuildHitAreas();
    });
  }

  @override
  void dispose() {
    _leftLogoImage?.dispose();
    _rightLogoImage?.dispose();
    super.dispose();
  }

  /// Asynchronously downloads and decodes logo images from network URLs.
  /// On completion triggers a repaint so the painter can draw them.
  ///
  /// Clears existing image references first so stale logos are not
  /// displayed while new ones load.
  void _loadLogoImages() {
    // Dispose previous images to free GPU memory.
    _leftLogoImage?.dispose();
    _rightLogoImage?.dispose();
    _leftLogoImage = null;
    _rightLogoImage = null;

    _loadSingleLogoImage(
      widget.tournament.leftLogoUrl,
      (image) {
        if (mounted) setState(() => _leftLogoImage = image);
      },
    );
    _loadSingleLogoImage(
      widget.tournament.rightLogoUrl,
      (image) {
        if (mounted) setState(() => _rightLogoImage = image);
      },
    );
  }

  /// Loads a single logo image and delivers the decoded [ui.Image] via
  /// [onLoaded]. Supports both HTTP(S) URLs and `data:` base64 URIs.
  /// Silently ignores failures (logo simply won't appear).
  void _loadSingleLogoImage(String url, void Function(ui.Image) onLoaded) {
    if (url.isEmpty) return;

    if (url.startsWith('data:')) {
      _loadDataUriImage(url, onLoaded);
    } else {
      _loadNetworkImage(url, onLoaded);
    }
  }

  /// Decodes a base64 data URI into a [ui.Image].
  void _loadDataUriImage(String dataUri, void Function(ui.Image) onLoaded) {
    try {
      final commaIndex = dataUri.indexOf(',');
      if (commaIndex == -1) return;
      final base64String = dataUri.substring(commaIndex + 1);
      final bytes = base64Decode(base64String);
      ui.decodeImageFromList(bytes, onLoaded);
    } catch (_) {
      // Malformed data URI — silently skip.
    }
  }

  /// Loads a network image via [NetworkImage] and delivers the [ui.Image].
  void _loadNetworkImage(String url, void Function(ui.Image) onLoaded) {
    final imageStream = NetworkImage(url).resolve(ImageConfiguration.empty);
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (imageInfo, _) {
        onLoaded(imageInfo.image);
        imageStream.removeListener(listener);
      },
      onError: (exception, stackTrace) {
        // Logo failed to load — degrade gracefully without the logo.
        imageStream.removeListener(listener);
      },
    );
    imageStream.addListener(listener);
  }

  void _rebuildHitAreas() {
    final painter = _createPainter();
    final size = painter.calculateCanvasSize();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    painter.paint(canvas, size);
    recorder.endRecording();
    if (mounted) {
      setState(() {
        _hitAreas = List.from(painter.matchHitAreas);
        _participantSlotHitAreas = List.from(
          painter.participantSlotHitAreas,
        );
      });
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
    isEditModeEnabled: widget.isEditModeEnabled,
    themeConfig: widget.themeConfig,
    leftLogoImage: _leftLogoImage,
    rightLogoImage: _rightLogoImage,
  );

  @override
  Widget build(BuildContext context) {
    final painter = _createPainter();
    final size = painter.calculateCanvasSize();
    final isEditMode = widget.isEditModeEnabled;

    final isPrintMode = widget.themeConfig.isInteractivityDisabled;

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
          // ── Match hit areas (disabled during edit mode and print mode) ──
          if (!isEditMode && !isPrintMode)
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
          // ── Participant slot hit areas (edit mode only, not in print) ──
          if (isEditMode && !isPrintMode)
            ..._participantSlotHitAreas
                .where((slot) => slot.participantId != null)
                .map((slot) => _buildEditModeSlotOverlay(slot)),
        ],
      ),
    );
  }

  /// Builds a draggable + tappable overlay for a participant slot in edit mode.
  Widget _buildEditModeSlotOverlay(ParticipantSlotHitArea slot) {
    final rect = slot.boundingRect;
    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: LongPressDraggable<ParticipantSlotHitArea>(
        data: slot,
        delay: const Duration(milliseconds: 300),
        feedback: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(6),
          color: Colors.blue.shade50,
          child: Container(
            width: rect.width * 0.8,
            height: rect.height,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              _participantNameForSlot(slot),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
                decoration: TextDecoration.none,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        childWhenDragging: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Colors.blue.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
        ),
        child: DragTarget<ParticipantSlotHitArea>(
          onWillAcceptWithDetails: (details) {
            // Accept drops from different slots only.
            return details.data != slot;
          },
          onAcceptWithDetails: (details) {
            widget.onParticipantSlotSwapped?.call(details.data, slot);
          },
          builder: (context, candidateData, rejectedData) {
            final isHovered = candidateData.isNotEmpty;
            return Material(
              color: isHovered
                  ? Colors.green.withValues(alpha: 0.15)
                  : Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                hoverColor: Colors.amber.withValues(alpha: 0.1),
                onTap: () {
                  widget.onParticipantSlotTapped?.call(slot);
                },
                child: Container(
                  decoration: isHovered
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.6),
                            width: 2,
                          ),
                        )
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Finds the participant name for display in drag feedback.
  String _participantNameForSlot(ParticipantSlotHitArea slot) {
    if (slot.participantId == null) return 'TBD';
    final participant = widget.participants
        .where((p) => p.id == slot.participantId)
        .firstOrNull;
    return participant?.fullName ?? 'Unknown';
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SECTION 2 — PAINT UTILITIES
// ══════════════════════════════════════════════════════════════════════════════
//
// All colour tokens now live in [TieSheetThemeConfig].
// The former `_BracketColors` class has been removed.

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
  static Paint shadow({
    double blur = 6.0,
    Color color = const Color(0x1A000000),
  }) => Paint()
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
  final bool isEditModeEnabled;
  final TieSheetThemeConfig themeConfig;

  /// Pre-decoded logo images rendered above the header banner.
  final ui.Image? leftLogoImage;
  final ui.Image? rightLogoImage;

  final List<MapEntry<String, Rect>> matchHitAreas = [];
  final List<ParticipantSlotHitArea> participantSlotHitAreas = [];
  final Map<String, int> _matchGlobalNumbers = {};
  final Map<String, Offset> _nodeOffsets = {};

  // ── Layout dimensions ──────────────────────────────────────────────────────
  //
  // Text-containing elements scale with [themeConfig.fontSizeDelta] so that
  // larger text fits without overflow. Each getter uses a per-delta multiplier
  // tuned for its content type.

  /// Shorthand for the additive font-size delta from the active theme.
  double get _delta => themeConfig.fontSizeDelta;

  double get rowH => 42.0 + _delta * 2.0;
  double get rowGap => 35.0 + _delta * 1.0;
  double get pairGap => 100.0 + _delta * 2.0;
  double get noColW => 32.0 + _delta * 1.0;
  double get nameColW => 200.0 + _delta * 3.0;
  double get regIdColW => 120.0 + _delta * 2.0;
  double get roundColW => 170.0 + _delta * 2.0;
  double get headerH => 100.0 + _delta * 2.0;
  double get subHeaderH => 28.0 + _delta * 2.0;
  double get medalH => 170.0 + _delta * 2.0;
  double get centerGap => 340.0 + _delta * 4.0;
  double get sectionLabelH => 32.0 + _delta * 1.0;

  // Non-text constants — no scaling required.
  static const double margin = 36.0;
  static const double sectionGap = 50.0;
  static const double _cardRadius = 6.0;
  static const double _accentStripW = 4.0;

  /// Vertical space reserved for the logo row above the header banner.
  /// 60px image + 12px bottom padding.
  static const double logoRowHeight = 72.0;

  /// Sum of the three participant-list column widths.
  double get listW => noColW + nameColW + regIdColW;

  // Medal-table dimensions.
  double get _medalTableW => 440.0 + _delta * 4.0;
  double get _medalRowH => 36.0 + _delta * 2.0;
  double get _medalNameW => 250.0 + _delta * 3.0;
  double get _medalLabelW => 80.0 + _delta * 1.0;
  double get _medalBlankW => _medalTableW - _medalNameW - _medalLabelW;

  TieSheetPainter({
    required this.tournament,
    required this.matches,
    required this.participants,
    required this.bracketType,
    required this.includeThirdPlaceMatch,
    this.winnersBracketId,
    this.losersBracketId,
    this.isEditModeEnabled = false,
    this.themeConfig = const TieSheetThemeConfig.defaultMode(),
    this.leftLogoImage,
    this.rightLogoImage,
  });

  /// Whether at least one logo image has been loaded.
  bool get _hasLogos => leftLogoImage != null || rightLogoImage != null;

  bool get _isDouble => winnersBracketId != null && losersBracketId != null;

  /// Whether `connectorStrokeWidth > 0`, meaning all connector lines use a
  /// single uniform width (print mode).
  bool get _isUniformStroke => themeConfig.connectorStrokeWidth > 0;

  /// Pending / unresolved connector pen. In uniform-stroke mode, width is
  /// overridden to [TieSheetThemeConfig.connectorStrokeWidth].
  Paint get _pendingConnectorPen => _isUniformStroke
      ? _Pens.thick(themeConfig.pendingColor, w: themeConfig.connectorStrokeWidth)
      : _Pens.thin(themeConfig.pendingColor);

  /// Won / resolved connector pen. In uniform-stroke mode, width is
  /// overridden to [TieSheetThemeConfig.connectorStrokeWidth].
  Paint get _wonConnectorPen => _isUniformStroke
      ? _Pens.thick(themeConfig.connectorWonColor, w: themeConfig.connectorStrokeWidth)
      : _Pens.round(themeConfig.connectorWonColor);

  /// BYE advancement dashed-line pen.
  Paint get _byeConnectorPen => _isUniformStroke
      ? _Pens.thick(themeConfig.mutedColor, w: themeConfig.connectorStrokeWidth)
      : _Pens.thin(themeConfig.mutedColor, w: 1.5);

  /// Generic connector pen (vertical trunk between arms).
  Paint get _genericConnectorPen => _isUniformStroke
      ? _Pens.thick(themeConfig.connectorColor, w: themeConfig.connectorStrokeWidth)
      : _Pens.thin(themeConfig.connectorColor);

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
      final rowCount =
          (m.participantBlueId != null ? 1 : 0) +
          (m.participantRedId != null ? 1 : 0);
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
    final seMaxRound = matches.isNotEmpty
        ? matches.map((mm) => mm.roundNumber).reduce(max)
        : 0;
    final mainMatches = matches
        .where(
          (m) => !(m.roundNumber == seMaxRound && m.matchNumberInRound == 2),
        )
        .toList();
    final winRounds = _maxRound(mainMatches);

    final width =
        margin * 2 +
        listW +
        (max(0, winRounds - 1) * roundColW) * 2 +
        centerGap +
        listW;

    final byRound = _groupByRound(mainMatches);
    final r1Matches = byRound[1] ?? [];
    final r1Count = r1Matches.length;
    final leftR1 = r1Matches
        .where((m) => m.matchNumberInRound <= (r1Count + 1) ~/ 2)
        .toList();
    final rightR1 = r1Matches
        .where((m) => m.matchNumberInRound > (r1Count + 1) ~/ 2)
        .toList();
    final tableH = max(
      _computeOneSidedHeight(leftR1),
      _computeOneSidedHeight(rightR1),
    );

    final effectiveLogoRowHeight = _hasLogos ? logoRowHeight : 0.0;
    final height = margin + effectiveLogoRowHeight + headerH + tableH + 60 + medalH + margin;
    return Size(max(width, 700), max(height, 500));
  }

  Size _calculateDECanvasSize() {
    final wbMatches = matches
        .where((m) => m.bracketId == winnersBracketId)
        .toList();
    final lbMatches = matches
        .where((m) => m.bracketId == losersBracketId)
        .toList();
    final gfMatches = matches
        .where(
          (m) =>
              m.bracketId != winnersBracketId && m.bracketId != losersBracketId,
        )
        .toList();
    final wbRounds = _maxRound(wbMatches);
    final lbRounds = _maxRound(lbMatches);

    final maxRounds = max(wbRounds, lbRounds);
    final gfColumns = gfMatches.isEmpty ? 0 : gfMatches.length;
    final width =
        margin * 2 +
        listW +
        (maxRounds * roundColW) +
        (gfColumns * roundColW) +
        100;

    final wbR1 = _groupByRound(wbMatches)[1] ?? [];
    final lbR1 = _groupByRound(lbMatches)[1] ?? [];
    final wbH = _computeOneSidedHeight(wbR1);
    final lbH = lbR1.isEmpty
        ? 80
        : (lbR1.length * 2 * rowH + (lbR1.length - 1) * pairGap);

    final effectiveLogoRowHeight = _hasLogos ? logoRowHeight : 0.0;
    final height =
        margin +
        effectiveLogoRowHeight +
        headerH +
        sectionLabelH +
        wbH +
        sectionGap +
        sectionLabelH +
        lbH +
        60 +
        medalH +
        margin;
    return Size(max(width, 700), max(height, 500));
  }

  /// Delegates global match numbering to [MatchNumberingUtility].
  void _buildGlobalMatchNumbers() {
    _matchGlobalNumbers
      ..clear()
      ..addAll(
        MatchNumberingUtility.buildGlobalMatchNumbers(
          matches: matches,
          isDoubleElimination: _isDouble,
          winnersBracketId: winnersBracketId,
          losersBracketId: losersBracketId,
        ),
      );
  }

  // ── 3d  Paint entry-point ──────────────────────────────────────────────────

  @override
  void paint(Canvas canvas, Size size) {
    matchHitAreas.clear();
    _nodeOffsets.clear();
    _buildGlobalMatchNumbers();

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _Pens.fill(themeConfig.canvasBackgroundColor),
    );

    final thickPen = _isUniformStroke
        ? _Pens.thick(themeConfig.cardBorderColor, w: themeConfig.connectorStrokeWidth)
        : _Pens.thick(themeConfig.cardBorderColor);

    if (_isDouble) {
      _paintDE(canvas, size, thickPen);
    } else {
      _paintSE(canvas, size, thickPen);
    }

    _paintMedalTable(canvas, size, thickPen);
  }

  // ── 3e  Single-Elimination layout ─────────────────────────────────────────

  void _paintSE(Canvas canvas, Size size, Paint thickPen) {
    final List<void Function()> deferredDecorations = [];
    double startY = margin;
    startY = _paintHeader(canvas, size, startY, thickPen);

    final tableTop = startY + 12;

    // Exclude the 3rd-place match from the main bracket tree.
    final seMaxRound = matches.isNotEmpty
        ? matches.map((mm) => mm.roundNumber).reduce(max)
        : 0;
    final mainMatches = matches
        .where(
          (m) => !(m.roundNumber == seMaxRound && m.matchNumberInRound == 2),
        )
        .toList();

    final winRounds = _maxRound(mainMatches);
    final winByRound = _groupByRound(mainMatches);
    final r1Matches = winByRound[1] ?? [];
    final r1Count = r1Matches.length;
    final leftHalfCount = (r1Count + 1) ~/ 2;
    final rightEdge = size.width - margin;
    final rightTableLeft = rightEdge - listW;

    if (r1Count == 1 && winRounds == 1) {
      // Special case: 2 players → direct final, no junction tree needed.
      final match = r1Matches.first;
      final b = _findP(match.participantBlueId);
      final r = _findP(match.participantRedId);
      int idx = 0;
      if (b != null) {
        idx++;
        _paintParticipantRow(
          canvas,
          idx,
          b,
          margin,
          tableTop,
          thickPen,
          mirrored: false,
        );
        _nodeOffsets['${match.id}_top_input'] = Offset(
          margin + listW,
          tableTop + rowH / 2,
        );
        _registerParticipantSlotHitArea(
          matchId: match.id,
          slotPosition: 'blue',
          participantId: match.participantBlueId,
          x: margin,
          y: tableTop,
          serialNumber: idx,
        );
      }
      if (r != null) {
        idx++;
        _paintParticipantRow(
          canvas,
          idx,
          r,
          rightTableLeft,
          tableTop,
          thickPen,
          mirrored: true,
        );
        _nodeOffsets['${match.id}_bot_input'] = Offset(
          rightTableLeft,
          tableTop + rowH / 2,
        );
        _registerParticipantSlotHitArea(
          matchId: match.id,
          slotPosition: 'red',
          participantId: match.participantRedId,
          x: rightTableLeft,
          y: tableTop,
          serialNumber: idx,
        );
      }
    } else {
      final leftR1Matches = r1Matches
          .where((m) => m.matchNumberInRound <= leftHalfCount)
          .toList();
      final rightR1Matches = r1Matches
          .where((m) => m.matchNumberInRound > leftHalfCount)
          .toList();

      final nextIdx = _paintParticipantList(
        canvas,
        leftR1Matches,
        margin,
        tableTop,
        thickPen,
        mirrored: false,
      );
      _paintParticipantList(
        canvas,
        rightR1Matches,
        rightTableLeft,
        tableTop,
        thickPen,
        mirrored: true,
        startIdx: nextIdx,
      );
    }

    // Draw bracket tree (rounds 1 → final).
    for (var r = 1; r <= winRounds; r++) {
      final roundMatches = winByRound[r] ?? [];
      final c = roundMatches.length;
      for (final match in roundMatches) {
        if (r == winRounds) {
          _paintCenterFinalJunction(
            canvas,
            match,
            size.width / 2,
            thickPen,
            deferredDecorations,
          );
        } else {
          final isLeft = match.matchNumberInRound <= (c + 1) ~/ 2;
          final junctionX = isLeft
              ? margin + listW + (r * roundColW)
              : rightEdge - listW - (r * roundColW);
          _paintJunction(
            canvas,
            match,
            junctionX,
            thickPen,
            mirrored: !isLeft,
            deferredDecorations: deferredDecorations,
          );
        }
      }
    }

    if (includeThirdPlaceMatch) {
      final thirdMaxRound = matches.isNotEmpty
          ? matches.map((mm) => mm.roundNumber).reduce(max)
          : 0;
      final thirdMatch = matches
          .where(
            (m) => m.roundNumber == thirdMaxRound && m.matchNumberInRound == 2,
          )
          .firstOrNull;
      if (thirdMatch != null) {
        _paint3rdPlaceMatch(canvas, thirdMatch, thickPen, tableTop);
      }
    }

    for (final deco in deferredDecorations) {
      deco();
    }
  }

  // ── 3f  Double-Elimination layout ─────────────────────────────────────────

  void _paintDE(Canvas canvas, Size size, Paint thickPen) {
    final List<void Function()> deferredDecorations = [];
    double startY = margin;
    startY = _paintHeader(canvas, size, startY, thickPen);

    final wbMatches = matches
        .where((m) => m.bracketId == winnersBracketId)
        .toList();
    final lbMatches = matches
        .where((m) => m.bracketId == losersBracketId)
        .toList();
    // Grand Finals = matches belonging to neither WB nor LB.
    final gfMatches = matches
        .where(
          (m) =>
              m.bracketId != winnersBracketId && m.bracketId != losersBracketId,
        )
        .toList();

    final wbRounds = _maxRound(wbMatches);
    final lbRounds = _maxRound(lbMatches);
    final wbByRound = _groupByRound(wbMatches);
    final lbByRound = _groupByRound(lbMatches);

    // ── Winners Bracket ──
    _paintSectionLabel(
      canvas,
      'WINNERS BRACKET',
      margin,
      startY,
      size.width - margin * 2,
      themeConfig.winnersLabelColor,
    );
    final wbTableTop = startY + sectionLabelH + 8;

    final wbR1 = wbByRound[1] ?? [];
    final int wbNextIdx = _paintParticipantList(
      canvas,
      wbR1,
      margin,
      wbTableTop,
      thickPen,
      mirrored: false,
    );

    for (var r = 1; r <= wbRounds; r++) {
      final junctionX = margin + listW + (r * roundColW);
      for (final match in wbByRound[r] ?? []) {
        _paintJunction(
          canvas,
          match,
          junctionX,
          thickPen,
          mirrored: false,
          deferredDecorations: deferredDecorations,
        );
      }
    }

    // ── Losers Bracket ──
    final wbH = _computeOneSidedHeight(wbR1);
    final lbSectionTop = wbTableTop + wbH + sectionGap;
    _paintSectionLabel(
      canvas,
      'LOSERS BRACKET',
      margin,
      lbSectionTop,
      size.width - margin * 2,
      themeConfig.losersLabelColor,
    );
    final lbTableTop = lbSectionTop + sectionLabelH + 8;

    // LB R1 slots are often TBD at generation time (participants drop in from
    // WB losses). Always render every slot — real data or TBD placeholder —
    // so junctions always have a valid node offset to connect to.
    final lbR1 = lbByRound[1] ?? [];
    var lbIdx = wbNextIdx;
    double lbY = lbTableTop;
    final lbNodeX = margin + listW;
    for (final m in lbR1) {
      final b = _findP(m.participantBlueId);
      final r = _findP(m.participantRedId);

      lbIdx++;
      if (b != null) {
        _paintParticipantRow(
          canvas,
          lbIdx,
          b,
          margin,
          lbY,
          thickPen,
          mirrored: false,
        );
        _registerParticipantSlotHitArea(
          matchId: m.id,
          slotPosition: 'blue',
          participantId: m.participantBlueId,
          x: margin,
          y: lbY,
          serialNumber: lbIdx,
        );
      } else {
        _paintTbdRow(canvas, lbIdx, margin, lbY);
      }
      _nodeOffsets['${m.id}_top_input'] = Offset(lbNodeX, lbY + rowH / 2);
      lbY += rowH;

      lbIdx++;
      if (r != null) {
        _paintParticipantRow(
          canvas,
          lbIdx,
          r,
          margin,
          lbY,
          thickPen,
          mirrored: false,
        );
        _registerParticipantSlotHitArea(
          matchId: m.id,
          slotPosition: 'red',
          participantId: m.participantRedId,
          x: margin,
          y: lbY,
          serialNumber: lbIdx,
        );
      } else {
        _paintTbdRow(canvas, lbIdx, margin, lbY);
      }
      _nodeOffsets['${m.id}_bot_input'] = Offset(lbNodeX, lbY + rowH / 2);
      lbY += rowH;
      lbY += pairGap;
    }

    for (var r = 1; r <= lbRounds; r++) {
      final junctionX = margin + listW + (r * roundColW);
      for (final match in lbByRound[r] ?? []) {
        _paintJunction(
          canvas,
          match,
          junctionX,
          thickPen,
          mirrored: false,
          deferredDecorations: deferredDecorations,
        );
      }
    }

    // ── Grand Finals ──
    if (gfMatches.isNotEmpty) {
      final gfX =
          margin + listW + (max(wbRounds, lbRounds) * roundColW) + roundColW;
      final gf1 = gfMatches.first;

      final wbFinal = wbMatches
          .where((m) => m.roundNumber == wbRounds)
          .firstOrNull;
      final lbFinal = lbMatches
          .where((m) => m.roundNumber == lbRounds)
          .firstOrNull;

      final wbChampOffset = wbFinal != null
          ? _nodeOffsets['${wbFinal.id}_output']
          : null;
      final lbChampOffset = lbFinal != null
          ? _nodeOffsets['${lbFinal.id}_output']
          : null;

      final gfTopY = wbChampOffset?.dy ?? (wbTableTop + wbH / 2);
      // When LB has a champion (standard case), connect to its output.
      // When LB is empty (e.g. 2-player DE), use a compact span below WB output.
      final gfBotY = lbChampOffset?.dy ?? (gfTopY + 80);
      final gfMidY = (gfTopY + gfBotY) / 2;

      _nodeOffsets['${gf1.id}_output'] = Offset(gfX, gfMidY);
      if (wbChampOffset != null) {
        _nodeOffsets['${gf1.id}_top_input'] = wbChampOffset;
      }
      if (lbChampOffset != null) {
        _nodeOffsets['${gf1.id}_bot_input'] = lbChampOffset;
      }

      _paintGrandFinalNode(
        canvas,
        gf1,
        gfX,
        gfTopY,
        gfBotY,
        thickPen,
        'GRAND FINAL',
        deferredDecorations,
      );

      if (gfMatches.length > 1) {
        final gf2 = gfMatches[1];
        final resetX = gfX + roundColW;
        _nodeOffsets['${gf2.id}_output'] = Offset(resetX, gfMidY);
        // Explicit horizontal connector from GF output to Reset input.
        final gfOutputPen = gf1.winnerId != null
            ? _wonConnectorPen
            : _pendingConnectorPen;
        canvas.drawLine(
          Offset(gfX + 40, gfMidY),
          Offset(resetX, gfMidY),
          gfOutputPen,
        );
        _paintGrandFinalNode(
          canvas,
          gf2,
          resetX,
          gfMidY - 25,
          gfMidY + 25,
          thickPen,
          'RESET',
          deferredDecorations,
          drawInputs: false,
        );
      }
    }

    for (final deco in deferredDecorations) {
      deco();
    }
  }

  // ── 3g  Shared participant / junction painting ─────────────────────────────

  void _paintSectionLabel(
    Canvas canvas,
    String label,
    double x,
    double y,
    double width,
    Color color,
  ) {
    final rect = RRect.fromLTRBR(
      x,
      y,
      x + width,
      y + sectionLabelH,
      const Radius.circular(6),
    );
    canvas.drawRRect(rect, _Pens.fill(color.withValues(alpha: 0.1)));
    canvas.drawRRect(rect, _Pens.thin(color, w: 1.5));
    _drawText(
      canvas,
      label,
      x + width / 2,
      _centeredTextY(y, sectionLabelH, _fontSize(14)),
      TextStyle(
        color: color,
        fontSize: _fontSize(14),
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
      center: true,
    );
  }

  void _paintGrandFinalNode(
    Canvas canvas,
    MatchEntity match,
    double x,
    double topY,
    double botY,
    Paint pen,
    String label,
    List<void Function()> deferredDecorations, {
    bool drawInputs = true,
  }) {
    final pendingPen = _pendingConnectorPen;
    final winnerPen = _wonConnectorPen;
    final midY = (topY + botY) / 2;

    canvas.drawLine(Offset(x, topY), Offset(x, botY), pen);

    if (drawInputs) {
      final topIn = _resolveInputOffset(match, isTopSlot: true);
      final botIn = _resolveInputOffset(match, isTopSlot: false);
      if (topIn != null) {
        canvas.drawLine(
          topIn,
          Offset(x, topY),
          match.participantBlueId != null ? winnerPen : pendingPen,
        );
      }
      if (botIn != null) {
        canvas.drawLine(
          botIn,
          Offset(x, botY),
          match.participantRedId != null ? winnerPen : pendingPen,
        );
      }
    }

    canvas.drawLine(
      Offset(x, midY),
      Offset(x + 40, midY),
      match.winnerId != null ? winnerPen : pendingPen,
    );

    final gNum = _matchGlobalNumbers[match.id];
    final w = match.winnerId != null ? _findP(match.winnerId) : null;
    final wName = w != null ? _pName(w) : null;

    deferredDecorations.add(() {
      _drawText(canvas, label, x, topY - 20, _bold(10), center: true);
      _drawBadge(canvas, 'B', themeConfig.blueCornerColor, x + 16, topY - 6);
      _drawBadge(canvas, 'R', themeConfig.redCornerColor, x + 16, botY + 14);

      if (gNum != null) _drawMatchPill(canvas, '$gNum', x + 18, midY);
      if (wName != null) {
        _drawText(canvas, wName, x + 45, midY - 6, _bold(9));
      }
    });

    matchHitAreas.add(
      MapEntry(
        match.id,
        Rect.fromCenter(
          center: Offset(x, midY),
          width: roundColW * 0.6,
          height: max(35, (botY - topY).abs() + 10),
        ),
      ),
    );
  }

  void _paintCenterFinalJunction(
    Canvas canvas,
    MatchEntity match,
    double junctionX,
    Paint pen,
    List<void Function()> deferredDecorations,
  ) {
    if (match.resultType == MatchResultType.bye) return;

    final pendingPen = _pendingConnectorPen;
    final winnerPen = _wonConnectorPen;
    final topPen = match.participantBlueId != null ? winnerPen : pendingPen;
    final botPen = match.participantRedId != null ? winnerPen : pendingPen;

    final topIn = _resolveInputOffset(match, isTopSlot: true);
    final botIn = _resolveInputOffset(match, isTopSlot: false);
    if (topIn == null || botIn == null) return;

    final rawMidY = (topIn.dy + botIn.dy) / 2;
    const minSpan = 60.0;
    final actualSpan = (botIn.dy - topIn.dy).abs();
    final halfSpan = max(actualSpan, minSpan) / 2;
    final topArmY = rawMidY - halfSpan;
    final botArmY = rawMidY + halfSpan;

    canvas.drawLine(topIn, Offset(junctionX, topIn.dy), topPen);
    canvas.drawLine(botIn, Offset(junctionX, botIn.dy), botPen);

    final realTopY = min(topIn.dy, topArmY);
    final realBotY = max(botIn.dy, botArmY);
    canvas.drawLine(
      Offset(junctionX, realTopY),
      Offset(junctionX, realBotY),
      _genericConnectorPen,
    );

    _nodeOffsets['${match.id}_output'] = Offset(junctionX, rawMidY);

    final gNum = _matchGlobalNumbers[match.id];
    final w = match.winnerId != null ? _findP(match.winnerId) : null;
    final wName = w != null ? _pName(w) : null;

    deferredDecorations.add(() {
      if (gNum != null) {
        _drawMatchPill(canvas, '$gNum', junctionX, rawMidY);
      }
      _drawBadge(
        canvas,
        'B',
        themeConfig.blueCornerColor,
        junctionX - 20,
        topArmY - 14,
      );
      _drawBadge(canvas, 'R', themeConfig.redCornerColor, junctionX + 20, botArmY + 14);

      if (wName != null) {
        // Draw centered slightly above the junction
        _drawText(
          canvas,
          wName,
          junctionX,
          rawMidY - 26,
          _bold(9),
          center: true,
        );
      }
    });

    matchHitAreas.add(
      MapEntry(
        match.id,
        Rect.fromCenter(
          center: Offset(junctionX, rawMidY),
          width: 80,
          height: max(50, botArmY - topArmY + 30),
        ),
      ),
    );
  }

  double _paintHeader(Canvas canvas, Size size, double startY, Paint thickPen) {
    var y = startY;

    // ── Logo row (above the banner) ──
    if (_hasLogos) {
      const double logoMaxHeight = 60.0;
      const double logoPadding = 12.0;
      final double headerLeft = margin;
      final double headerRight = size.width - margin;

      if (leftLogoImage != null) {
        _paintLogoImage(
          canvas,
          leftLogoImage!,
          logoMaxHeight,
          headerLeft,
          y,
        );
      }
      if (rightLogoImage != null) {
        final double rightLogoWidth =
            (rightLogoImage!.width / rightLogoImage!.height) * logoMaxHeight;
        _paintLogoImage(
          canvas,
          rightLogoImage!,
          logoMaxHeight,
          headerRight - rightLogoWidth,
          y,
        );
      }
      y += logoMaxHeight + logoPadding;
    }

    // ── Dark header banner with tournament info ──
    final bannerH = 64.0 + _delta * 2.0;
    final bannerRect = RRect.fromLTRBR(
      margin,
      y,
      size.width - margin,
      y + bannerH,
      const Radius.circular(8),
    );
    canvas.drawRRect(bannerRect, _Pens.fill(themeConfig.headerBannerBackgroundColor));
    canvas.drawRRect(bannerRect, _Pens.thin(themeConfig.cardBorderColor));

    final title =
        (tournament.name.isNotEmpty ? tournament.name : 'TOURNAMENT NAME')
            .toUpperCase();
    _drawText(
      canvas,
      title,
      size.width / 2,
      y + 8 + _delta * 0.5,
      TextStyle(
        color: themeConfig.headerBannerTextColor,
        fontSize: _fontSize(18),
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
        letterSpacing: 1.2,
      ),
      center: true,
    );

    if (tournament.dateRange.isNotEmpty || tournament.venue.isNotEmpty) {
      final sub = [
        tournament.dateRange,
        tournament.venue,
      ].where((s) => s.isNotEmpty).join('  •  ');
      _drawText(
        canvas,
        sub.toUpperCase(),
        size.width / 2,
        y + 30 + _delta * 1.0,
        TextStyle(
          color: themeConfig.headerBannerTextColor.withValues(alpha: 0.7),
          fontSize: _fontSize(11),
          fontWeight: themeConfig.isTextForceBold ? FontWeight.w900 : FontWeight.normal,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
        ),
        center: true,
      );
    }
    if (tournament.organizer.isNotEmpty) {
      _drawText(
        canvas,
        'Organised by ${tournament.organizer.toUpperCase()}',
        size.width / 2,
        y + 46 + _delta * 1.5,
        TextStyle(
          color: themeConfig.headerBannerTextColor.withValues(alpha: 0.55),
          fontSize: _fontSize(10),
          fontWeight: themeConfig.isTextForceBold ? FontWeight.w900 : FontWeight.normal,
          fontFamily: 'Roboto',
        ),
        center: true,
      );
    }
    y += bannerH + 12;

    // ── Single full-width tournament info row (table-style) ──
    final infoRowTop = y;
    final infoRowBottom = y + subHeaderH;
    final infoLeft = margin;
    final infoRight = size.width - margin;
    final infoRect = RRect.fromLTRBR(
      infoLeft,
      infoRowTop,
      infoRight,
      infoRowBottom,
      const Radius.circular(_cardRadius),
    );
    canvas.drawRRect(infoRect, _Pens.fill(themeConfig.headerFillColor));
    canvas.drawRRect(infoRect, _Pens.thin(themeConfig.cardBorderColor));

    final ageCategory = tournament.ageCategoryLabel.isNotEmpty
        ? tournament.ageCategoryLabel.toUpperCase()
        : 'AGE CATEGORY';
    final gender = tournament.genderLabel.isNotEmpty
        ? tournament.genderLabel.toUpperCase()
        : 'GENDER';
    final weightDivision = tournament.weightDivisionLabel.isNotEmpty
        ? tournament.weightDivisionLabel.toUpperCase()
        : 'WEIGHT DIVISION';
    final infoTextY = _centeredTextY(infoRowTop, subHeaderH, _fontSize(11));

    // Column layout: No. | Age Category | Gender | Weight Division
    final infoColNoW = noColW;
    final remainingW = (infoRight - infoLeft) - infoColNoW;
    final infoColW = remainingW / 3;

    // Column dividers
    canvas.drawLine(
      Offset(infoLeft + infoColNoW, infoRowTop + 3),
      Offset(infoLeft + infoColNoW, infoRowBottom - 3),
      _Pens.thin(themeConfig.cardBorderColor),
    );
    canvas.drawLine(
      Offset(infoLeft + infoColNoW + infoColW, infoRowTop + 3),
      Offset(infoLeft + infoColNoW + infoColW, infoRowBottom - 3),
      _Pens.thin(themeConfig.cardBorderColor),
    );
    canvas.drawLine(
      Offset(infoLeft + infoColNoW + infoColW * 2, infoRowTop + 3),
      Offset(infoLeft + infoColNoW + infoColW * 2, infoRowBottom - 3),
      _Pens.thin(themeConfig.cardBorderColor),
    );

    // Column text
    _drawText(
      canvas,
      'No.',
      infoLeft + infoColNoW / 2,
      infoTextY,
      _bold(11),
      center: true,
    );
    _drawText(
      canvas,
      ageCategory,
      infoLeft + infoColNoW + infoColW / 2,
      infoTextY,
      _bold(11),
      center: true,
    );
    _drawText(
      canvas,
      gender,
      infoLeft + infoColNoW + infoColW + infoColW / 2,
      infoTextY,
      _bold(11),
      center: true,
    );
    _drawText(
      canvas,
      weightDivision,
      infoLeft + infoColNoW + infoColW * 2 + infoColW / 2,
      infoTextY,
      _bold(11),
      center: true,
    );

    return infoRowBottom + 12;
  }

  /// Draws a [ui.Image] on the canvas scaled to fit within [maxHeight],
  /// preserving the original aspect ratio.
  void _paintLogoImage(
    Canvas canvas,
    ui.Image image,
    double maxHeight,
    double x,
    double y,
  ) {
    // Guard against degenerate images with zero dimensions.
    if (image.width <= 0 || image.height <= 0) return;

    final double aspectRatio = image.width / image.height;
    final double drawHeight = maxHeight;
    final double drawWidth = drawHeight * aspectRatio;

    final srcRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dstRect = Rect.fromLTWH(x, y, drawWidth, drawHeight);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  void _paintParticipantRow(
    Canvas canvas,
    int idx,
    ParticipantEntity p,
    double x,
    double y,
    Paint pen, {
    required bool mirrored,
  }) {
    final right = x + listW;

    if (!mirrored) {
      // ── Card with shadow ──
      final cardRect = RRect.fromLTRBR(
        x,
        y + 1,
        right,
        y + rowH - 1,
        const Radius.circular(_cardRadius),
      );
      canvas.drawRRect(
        cardRect.shift(const Offset(1, 2)),
        _themedShadow(blur: 4),
      );
      canvas.drawRRect(cardRect, _Pens.fill(themeConfig.rowFillColor));
      canvas.drawRRect(cardRect, _Pens.thin(themeConfig.cardBorderColor));

      // ── Blue accent strip on left edge ──
      final accentRect = RRect.fromLTRBAndCorners(
        x,
        y + 1,
        x + _accentStripW,
        y + rowH - 1,
        topLeft: const Radius.circular(_cardRadius),
        bottomLeft: const Radius.circular(_cardRadius),
      );
      canvas.drawRRect(accentRect, _Pens.fill(themeConfig.participantAccentStripColor));

      // ── Column divider ──
      canvas.drawLine(
        Offset(x + noColW, y + 4),
        Offset(x + noColW, y + rowH - 4),
        _Pens.thin(themeConfig.cardBorderColor),
      );
      canvas.drawLine(
        Offset(x + noColW + nameColW, y + 4),
        Offset(x + noColW + nameColW, y + rowH - 4),
        _Pens.thin(themeConfig.cardBorderColor),
      );

      // ── Text ──
      final textY = _centeredTextY(y, rowH, _fontSize(10));
      _drawText(
        canvas,
        '$idx',
        x + noColW / 2,
        textY,
        _normal(10),
        center: true,
      );
      _drawText(canvas, _pName(p), x + noColW + 8, textY, _bold(10));
      if (p.registrationId != null && p.registrationId!.isNotEmpty) {
        _drawText(
          canvas,
          p.registrationId!,
          right - 8,
          textY,
          _normal(9),
          alignRight: true,
        );
      }
    } else {
      // ── Mirrored card with shadow ──
      final cardRect = RRect.fromLTRBR(
        x,
        y + 1,
        right,
        y + rowH - 1,
        const Radius.circular(_cardRadius),
      );
      canvas.drawRRect(
        cardRect.shift(const Offset(-1, 2)),
        _themedShadow(blur: 4),
      );
      canvas.drawRRect(cardRect, _Pens.fill(themeConfig.rowFillColor));
      canvas.drawRRect(cardRect, _Pens.thin(themeConfig.cardBorderColor));

      // ── Blue accent strip on right edge ──
      final accentRect = RRect.fromLTRBAndCorners(
        right - _accentStripW,
        y + 1,
        right,
        y + rowH - 1,
        topRight: const Radius.circular(_cardRadius),
        bottomRight: const Radius.circular(_cardRadius),
      );
      canvas.drawRRect(accentRect, _Pens.fill(themeConfig.participantAccentStripColor));

      // ── Column divider ──
      canvas.drawLine(
        Offset(x + regIdColW, y + 4),
        Offset(x + regIdColW, y + rowH - 4),
        _Pens.thin(themeConfig.cardBorderColor),
      );
      canvas.drawLine(
        Offset(x + regIdColW + nameColW, y + 4),
        Offset(x + regIdColW + nameColW, y + rowH - 4),
        _Pens.thin(themeConfig.cardBorderColor),
      );

      // ── Text ──
      final textY = _centeredTextY(y, rowH, _fontSize(10));
      if (p.registrationId != null && p.registrationId!.isNotEmpty) {
        _drawText(canvas, p.registrationId!, x + 8, textY, _normal(9));
      }
      _drawText(
        canvas,
        _pName(p),
        x + regIdColW + nameColW - 8,
        textY,
        _bold(10),
        alignRight: true,
      );
      _drawText(
        canvas,
        '$idx',
        right - noColW / 2,
        textY,
        _normal(10),
        center: true,
      );
    }
  }

  /// Paints a placeholder row for a bracket slot with no assigned participant.
  void _paintTbdRow(Canvas canvas, int idx, double x, double y) {
    final right = x + listW;

    final cardRect = RRect.fromLTRBR(
      x,
      y + 1,
      right,
      y + rowH - 1,
      const Radius.circular(_cardRadius),
    );
    canvas.drawRRect(cardRect, _Pens.fill(themeConfig.tbdFillColor));
    canvas.drawRRect(cardRect, _Pens.thin(themeConfig.pendingColor));

    // ── Gray accent strip ──
    final accentRect = RRect.fromLTRBAndCorners(
      x,
      y + 1,
      x + _accentStripW,
      y + rowH - 1,
      topLeft: const Radius.circular(_cardRadius),
      bottomLeft: const Radius.circular(_cardRadius),
    );
    canvas.drawRRect(accentRect, _Pens.fill(themeConfig.mutedColor));

    final textY = _centeredTextY(y, rowH, _fontSize(10));
    _drawText(
      canvas,
      '$idx',
      x + noColW / 2,
      textY,
      TextStyle(
        fontSize: _fontSize(10),
        fontWeight: FontWeight.bold,
        color: themeConfig.mutedColor,
      ),
      center: true,
    );
    _drawText(
      canvas,
      'TBD',
      x + noColW + 8,
      textY,
      TextStyle(
        fontSize: _fontSize(10),
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        color: themeConfig.mutedColor,
      ),
    );
  }

  /// Renders a flat R1 participant table, writing [_nodeOffsets] for each slot
  /// so that [_paintJunction] can resolve junction input coordinates later.
  ///
  /// [mirrored] flips column order and reverses the direction of the arm that
  /// connects the row to the bracket tree.
  int _paintParticipantList(
    Canvas canvas,
    List<MatchEntity> r1Matches,
    double x,
    double startY,
    Paint pen, {
    required bool mirrored,
    int startIdx = 0,
  }) {
    var idx = startIdx;
    var y = startY;
    // Non-mirrored sides connect at the right edge; mirrored sides at the left.
    final nodeX = mirrored ? x : x + listW;

    for (final m in r1Matches) {
      final b = _findP(m.participantBlueId);
      final r = _findP(m.participantRedId);
      if (b != null) {
        idx++;
        _paintParticipantRow(canvas, idx, b, x, y, pen, mirrored: mirrored);
        _nodeOffsets['${m.id}_top_input'] = Offset(nodeX, y + rowH / 2);
        _registerParticipantSlotHitArea(
          matchId: m.id,
          slotPosition: 'blue',
          participantId: m.participantBlueId,
          x: x,
          y: y,
          serialNumber: idx,
        );
        y += rowH;
        if (r != null) y += rowGap; // intra-pair gap between blue & red rows
      }
      if (r != null) {
        idx++;
        _paintParticipantRow(canvas, idx, r, x, y, pen, mirrored: mirrored);
        _nodeOffsets['${m.id}_bot_input'] = Offset(nodeX, y + rowH / 2);
        _registerParticipantSlotHitArea(
          matchId: m.id,
          slotPosition: 'red',
          participantId: m.participantRedId,
          x: x,
          y: y,
          serialNumber: idx,
        );
        y += rowH;
      }
      y += pairGap;
    }

    return idx;
  }

  void _paintJunction(
    Canvas canvas,
    MatchEntity match,
    double junctionX,
    Paint pen, {
    required bool mirrored,
    required List<void Function()> deferredDecorations,
  }) {
    final pendingPen = _pendingConnectorPen;
    final winnerPen = _wonConnectorPen;

    final topPen = match.participantBlueId != null ? winnerPen : pendingPen;
    final botPen = match.participantRedId != null ? winnerPen : pendingPen;

    final isBye = match.resultType == MatchResultType.bye;
    if (isBye) {
      final topIn = _resolveInputOffset(match, isTopSlot: true);
      if (topIn != null) {
        canvas.drawLine(topIn, Offset(junctionX, topIn.dy), topPen);
        final nextJunctionX = mirrored
            ? junctionX - roundColW
            : junctionX + roundColW;
        // Dashed line signals a BYE advancement (no real match played).
        // In print mode, draw a solid line instead.
        final byePen = _byeConnectorPen;
        if (_isUniformStroke) {
          canvas.drawLine(
            Offset(junctionX, topIn.dy),
            Offset(nextJunctionX, topIn.dy),
            byePen,
          );
        } else {
          _drawDashedLine(
            canvas,
            Offset(junctionX, topIn.dy),
            Offset(nextJunctionX, topIn.dy),
            byePen,
          );
        }
        _nodeOffsets['${match.id}_output'] = Offset(nextJunctionX, topIn.dy);
        matchHitAreas.add(
          MapEntry(
            match.id,
            Rect.fromCenter(
              center: Offset(junctionX, topIn.dy),
              width: roundColW * 0.6,
              height: 35,
            ),
          ),
        );
      }
      return;
    }

    final topIn = _resolveInputOffset(match, isTopSlot: true);
    final botIn = _resolveInputOffset(match, isTopSlot: false);

    // ── Two-input junction (synthesize a short arm if one is missing) ──
    late Offset effectiveTop, effectiveBot;
    String? missingTopLabel;
    String? missingBotLabel;

    if (topIn != null && botIn != null) {
      effectiveTop = topIn;
      effectiveBot = botIn;
    } else if (topIn != null) {
      effectiveTop = topIn;
      effectiveBot = Offset(
        junctionX - (mirrored ? -30 : 30),
        topIn.dy + 40,
      ); // Short phantom arm for drop-in
      final p = _findP(match.participantRedId);
      missingBotLabel = p != null ? '↑ ${_pName(p)}' : '↑ from WB';
    } else if (botIn != null) {
      effectiveBot = botIn;
      effectiveTop = Offset(
        junctionX - (mirrored ? -30 : 30),
        botIn.dy - 40,
      ); // Short phantom arm for drop-in
      final p = _findP(match.participantBlueId);
      missingTopLabel = p != null ? '↓ ${_pName(p)}' : '↓ from WB';
    } else {
      // Both null — estimate positions (rare fallback).
      final estY =
          100.0 + (match.matchNumberInRound * 2 - 1) * (rowH + pairGap / 2);
      effectiveTop = Offset(junctionX, estY);
      effectiveBot = Offset(junctionX, estY + rowH * 2);
    }

    final midY = (effectiveTop.dy + effectiveBot.dy) / 2;
    final output = Offset(junctionX, midY);
    _nodeOffsets['${match.id}_output'] = output;

    const r = 10.0; // corner-radius for Bezier arms

    final pathT = Path()
      ..moveTo(effectiveTop.dx, effectiveTop.dy)
      ..lineTo(junctionX - (mirrored ? -r : r), effectiveTop.dy)
      ..arcToPoint(
        Offset(junctionX, effectiveTop.dy + r),
        radius: const Radius.circular(r),
        clockwise: !mirrored,
      )
      ..lineTo(junctionX, midY);
    canvas.drawPath(pathT, topPen);

    final pathB = Path()
      ..moveTo(effectiveBot.dx, effectiveBot.dy)
      ..lineTo(junctionX - (mirrored ? -r : r), effectiveBot.dy)
      ..arcToPoint(
        Offset(junctionX, effectiveBot.dy - r),
        radius: const Radius.circular(r),
        clockwise: mirrored,
      )
      ..lineTo(junctionX, midY);
    canvas.drawPath(pathB, botPen);

    final gNum = _matchGlobalNumbers[match.id];
    final w = match.winnerId != null ? _findP(match.winnerId) : null;
    final wName = w != null ? _pName(w) : null;

    deferredDecorations.add(() {
      final badgeX = junctionX + (mirrored ? 20 : -20);
      _drawBadge(
        canvas,
        'B',
        themeConfig.blueCornerColor,
        badgeX,
        effectiveTop.dy - 14,
      );
      _drawBadge(canvas, 'R', themeConfig.redCornerColor, badgeX, effectiveBot.dy + 14);

      final labelDxOffset = mirrored ? 10.0 : -10.0;
      final alignRight = !mirrored;
      final missingLabelStyle = TextStyle(
        color: themeConfig.mutedColor,
        fontSize: 9,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      );

      if (missingTopLabel != null) {
        _drawText(
          canvas,
          missingTopLabel,
          effectiveTop.dx + labelDxOffset,
          effectiveTop.dy - 6,
          missingLabelStyle,
          alignRight: alignRight,
        );
      }
      if (missingBotLabel != null) {
        _drawText(
          canvas,
          missingBotLabel,
          effectiveBot.dx + labelDxOffset,
          effectiveBot.dy - 6,
          missingLabelStyle,
          alignRight: alignRight,
        );
      }

      if (gNum != null) _drawMatchPill(canvas, '$gNum', junctionX, midY);

      if (wName != null) {
        final winnerX = junctionX + (mirrored ? -18 : 18);
        _drawText(
          canvas,
          '✓ $wName',
          winnerX,
          midY - 14,
          _bold(9),
          alignRight: !alignRight,
        );
      }
    });

    matchHitAreas.add(
      MapEntry(
        match.id,
        Rect.fromCenter(
          center: output,
          width: roundColW * 0.6,
          height: max(40, (effectiveBot.dy - effectiveTop.dy).abs() + 20),
        ),
      ),
    );
  }

  Offset? _resolveInputOffset(MatchEntity match, {required bool isTopSlot}) {
    // 1. Explicit input stub (e.g., Round 1 participant cards)
    final explicitKey = isTopSlot
        ? '${match.id}_top_input'
        : '${match.id}_bot_input';
    if (_nodeOffsets.containsKey(explicitKey)) {
      return _nodeOffsets[explicitKey];
    }

    // 2. Identify all feeders
    final wFeeders = matches
        .where((m) => m.winnerAdvancesToMatchId == match.id)
        .toList();
    final lFeeders = matches
        .where((m) => m.loserAdvancesToMatchId == match.id)
        .toList();

    // 3. Determine which feeder belongs to the requested slot
    MatchEntity? targetFeeder;

    if (wFeeders.isNotEmpty && lFeeders.isEmpty) {
      if (wFeeders.length == 1) {
        targetFeeder = wFeeders.first;
      } else {
        wFeeders.sort(
          (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
        );
        if (match.bracketId != winnersBracketId &&
            match.bracketId != losersBracketId) {
          final wbFeeder = wFeeders
              .where((f) => f.bracketId == winnersBracketId)
              .firstOrNull;
          final lbFeeder = wFeeders
              .where((f) => f.bracketId == losersBracketId)
              .firstOrNull;
          targetFeeder = isTopSlot
              ? (wbFeeder ?? wFeeders.first)
              : (lbFeeder ?? wFeeders.last);
        } else {
          targetFeeder = isTopSlot ? wFeeders.first : wFeeders.last;
        }
      }
    } else if (lFeeders.isNotEmpty && wFeeders.isEmpty) {
      if (lFeeders.length == 1) {
        targetFeeder = lFeeders.first;
      } else {
        lFeeders.sort(
          (a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound),
        );
        targetFeeder = isTopSlot ? lFeeders.first : lFeeders.last;
      }
    } else if (wFeeders.isNotEmpty && lFeeders.isNotEmpty) {
      targetFeeder = isTopSlot ? lFeeders.first : wFeeders.first;
    }

    if (targetFeeder != null) {
      bool isCrossBracketDrop =
          (targetFeeder.bracketId == winnersBracketId &&
          match.bracketId == losersBracketId);
      if (isCrossBracketDrop && !_nodeOffsets.containsKey(explicitKey)) {
        return null;
      }
      return _nodeOffsets['${targetFeeder.id}_output'];
    }

    return null;
  }

  void _paint3rdPlaceMatch(
    Canvas canvas,
    MatchEntity m,
    Paint pen,
    double tableTop,
  ) {
    final allRounds = matches.map((mm) => mm.roundNumber).reduce(max);
    final finals = matches
        .where(
          (mm) => mm.roundNumber == allRounds && mm.matchNumberInRound == 1,
        )
        .firstOrNull;
    if (finals == null || !_nodeOffsets.containsKey('${finals.id}_output')) {
      return;
    }

    final fPos = _nodeOffsets['${finals.id}_output']!;
    final x = fPos.dx;
    final y = fPos.dy + rowH * 4 + 60;

    canvas.drawLine(Offset(x - 50, y - 20), Offset(x, y - 20), pen);
    canvas.drawLine(Offset(x - 50, y + 20), Offset(x, y + 20), pen);
    canvas.drawLine(Offset(x, y - 20), Offset(x, y + 20), pen);
    canvas.drawLine(Offset(x, y), Offset(x + 30, y), pen);

    _nodeOffsets[m.id] = Offset(x, y);
    matchHitAreas.add(
      MapEntry(
        m.id,
        Rect.fromCenter(center: Offset(x, y), width: 60, height: 50),
      ),
    );

    _drawText(canvas, '3rd Place', x - 25, y - 34, _bold(9), center: true);
    _drawText(
      canvas,
      'B',
      x + 4,
      y - 34,
      TextStyle(
        color: themeConfig.blueCornerColor,
        fontWeight: FontWeight.bold,
        fontSize: _fontSize(9),
      ),
    );
    _drawText(
      canvas,
      'R',
      x + 4,
      y + 22,
      TextStyle(
        color: themeConfig.redCornerColor,
        fontWeight: FontWeight.bold,
        fontSize: _fontSize(9),
      ),
    );

    if (m.winnerId != null) {
      final w = _findP(m.winnerId);
      if (w != null) _drawText(canvas, _pName(w), x + 35, y - 6, _bold(9));
    }
  }

  // ── 3h  Medal table ────────────────────────────────────────────────────────

  void _paintMedalTable(Canvas canvas, Size size, Paint pen) {
    final x = (size.width - _medalTableW) / 2;
    final y = size.height - medalH - margin + 10;

    final accentColors = [
      themeConfig.medalGoldAccentColor,
      themeConfig.medalSilverAccentColor,
      themeConfig.medalBronzeAccentColor,
      themeConfig.medalBronzeAccentColor,
    ];
    final fills = [
      _Pens.fill(themeConfig.medalGoldFillColor),
      _Pens.fill(themeConfig.medalSilverFillColor),
      _Pens.fill(themeConfig.medalBronzeFillColor),
      _Pens.fill(themeConfig.medalBronzeFillColor),
    ];

    for (var row = 0; row < 4; row++) {
      final rY = y + row * (_medalRowH + 4);

      // ── Shadow + Card ──
      final fullRect = RRect.fromLTRBR(
        x + _medalBlankW,
        rY,
        x + _medalTableW,
        rY + _medalRowH,
        const Radius.circular(_cardRadius),
      );
      canvas.drawRRect(
        fullRect.shift(const Offset(1, 2)),
        _themedShadow(blur: 3),
      );

      // Name area
      final nameRect = RRect.fromLTRBAndCorners(
        x + _medalBlankW,
        rY,
        x + _medalBlankW + _medalNameW,
        rY + _medalRowH,
        topLeft: const Radius.circular(_cardRadius),
        bottomLeft: const Radius.circular(_cardRadius),
      );
      canvas.drawRRect(nameRect, _Pens.fill(themeConfig.rowFillColor));

      // Label area
      final labelRect = RRect.fromLTRBAndCorners(
        x + _medalBlankW + _medalNameW,
        rY,
        x + _medalTableW,
        rY + _medalRowH,
        topRight: const Radius.circular(_cardRadius),
        bottomRight: const Radius.circular(_cardRadius),
      );
      canvas.drawRRect(labelRect, fills[row]);

      // Border
      canvas.drawRRect(fullRect, _Pens.thin(themeConfig.cardBorderColor));
      canvas.drawLine(
        Offset(x + _medalBlankW + _medalNameW, rY),
        Offset(x + _medalBlankW + _medalNameW, rY + _medalRowH),
        _Pens.thin(themeConfig.cardBorderColor),
      );

      // ── Accent strip ──
      final accentRect = RRect.fromLTRBAndCorners(
        x + _medalBlankW,
        rY,
        x + _medalBlankW + _accentStripW,
        rY + _medalRowH,
        topLeft: const Radius.circular(_cardRadius),
        bottomLeft: const Radius.circular(_cardRadius),
      );
      canvas.drawRRect(accentRect, _Pens.fill(accentColors[row]));
    }

    final labelX = x + _medalBlankW + _medalNameW + _medalLabelW / 2;
    final textStyles = [
      TextStyle(
        color: themeConfig.medalGoldTextColor,
        fontSize: _fontSize(12),
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
      TextStyle(
        color: themeConfig.medalSilverTextColor,
        fontSize: _fontSize(12),
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
      TextStyle(
        color: themeConfig.medalBronzeTextColor,
        fontSize: _fontSize(12),
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
      TextStyle(
        color: themeConfig.medalBronzeTextColor,
        fontSize: _fontSize(12),
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
    ];
    final labels = ['Gold', 'Silver', '1st Bronze', '2nd Bronze'];
    for (var row = 0; row < 4; row++) {
      final rY = y + row * (_medalRowH + 4);
      _drawText(
        canvas,
        labels[row],
        labelX,
        _centeredTextY(rY, _medalRowH, _fontSize(12)),
        textStyles[row],
        center: true,
      );
    }

    // ── Populate winner names ──
    final allRounds = matches.map((m) => m.roundNumber).reduce(max);
    final finals = matches
        .where((m) => m.roundNumber == allRounds && m.matchNumberInRound == 1)
        .firstOrNull;
    if (finals != null && finals.winnerId != null) {
      final gold = _findP(finals.winnerId);
      final silverId = finals.winnerId == finals.participantRedId
          ? finals.participantBlueId
          : finals.participantRedId;
      final silver = _findP(silverId);
      if (gold != null) {
        _drawText(
          canvas,
          _pName(gold),
          x + _medalBlankW + 14,
           _centeredTextY(y, _medalRowH, _fontSize(11)),
          _bold(11),
        );
      }
      if (silver != null) {
        _drawText(
          canvas,
          _pName(silver),
          x + _medalBlankW + 14,
           _centeredTextY(y + (_medalRowH + 4), _medalRowH, _fontSize(11)),
          _bold(11),
        );
      }
    }
    // 3rd-place match: winner = Bronze 1, loser = Bronze 2
    final thirdM = matches
        .where((m) => m.roundNumber == allRounds && m.matchNumberInRound == 2)
        .firstOrNull;
    if (thirdM != null) {
      if (thirdM.winnerId != null) {
        final bronze1 = _findP(thirdM.winnerId);
        if (bronze1 != null) {
          _drawText(
            canvas,
            _pName(bronze1),
            x + _medalBlankW + 14,
            _centeredTextY(y + 2 * (_medalRowH + 4), _medalRowH, _fontSize(11)),
            _bold(11),
          );
        }
      }
      final loserId = thirdM.winnerId == thirdM.participantRedId
          ? thirdM.participantBlueId
          : thirdM.participantRedId;
      if (loserId != null) {
        final bronze2 = _findP(loserId);
        if (bronze2 != null) {
          _drawText(
            canvas,
            _pName(bronze2),
            x + _medalBlankW + 14,
            _centeredTextY(y + 3 * (_medalRowH + 4), _medalRowH, _fontSize(11)),
            _bold(11),
          );
        }
      }
    }
  }

  // ── 3i  Text & drawing primitives ─────────────────────────────────────────

  ParticipantEntity? _findP(String? id) =>
      id == null ? null : participants.where((p) => p.id == id).firstOrNull;

  String _pName(ParticipantEntity p) => p.fullName.toUpperCase();

  /// Resolves the effective font size by adding [themeConfig.fontSizeDelta]
  /// to the painter-specified [defaultSize].
  double _fontSize(double defaultSize) => defaultSize + themeConfig.fontSizeDelta;

  /// Y-coordinate for vertically centering text of [fontSize] within a
  /// container that starts at [containerY] with the given [containerHeight].
  double _centeredTextY(
    double containerY,
    double containerHeight,
    double fontSize,
  ) =>
      containerY + (containerHeight - fontSize) / 2;

  TextStyle _bold(double size) => TextStyle(
    color: themeConfig.primaryTextColor,
    fontSize: _fontSize(size),
    fontWeight: themeConfig.isTextForceBold ? FontWeight.w900 : FontWeight.bold,
    fontFamily: 'Roboto',
  );
  TextStyle _normal(double size) => TextStyle(
    color: themeConfig.secondaryTextColor,
    fontSize: _fontSize(size),
    fontWeight: themeConfig.isTextForceBold ? FontWeight.w800 : FontWeight.normal,
    fontFamily: 'Roboto',
  );

  void _drawBadge(
    Canvas canvas,
    String text,
    Color color,
    double cx,
    double cy,
  ) {
    canvas.drawCircle(Offset(cx, cy), 10.0, _Pens.fill(color));
    canvas.drawCircle(
      Offset(cx, cy),
      10.0,
      _Pens.thin(color.withValues(alpha: 0.3)),
    );
    _drawText(
      canvas,
      text,
      cx,
      cy - 5,
      TextStyle(
        color: Colors.white,
        fontSize: _fontSize(9),
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
      center: true,
    );
  }

  /// Match number display as a small rounded pill.
  void _drawMatchPill(Canvas canvas, String text, double cx, double cy) {
    final pillRect = RRect.fromLTRBR(
      cx - 16,
      cy - 11,
      cx + 16,
      cy + 11,
      const Radius.circular(11),
    );
    canvas.drawRRect(
      pillRect.shift(const Offset(0.5, 1)),
      _themedShadow(blur: 2),
    );
    canvas.drawRRect(pillRect, _Pens.fill(Colors.white));
    canvas.drawRRect(pillRect, _genericConnectorPen);
    _drawText(
      canvas,
      text,
      cx,
      cy - 6,
      TextStyle(
        color: themeConfig.primaryTextColor,
        fontSize: _fontSize(10),
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
      center: true,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
    TextStyle style, {
    bool center = false,
    bool alignRight = false,
  }) {
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

  void _drawDashedLine(
    Canvas canvas,
    Offset from,
    Offset to,
    Paint paint, {
    double dashWidth = 6,
    double gapWidth = 4,
  }) {
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
      canvas.drawLine(
        Offset(x, y),
        Offset(from.dx + stepX * end, from.dy + stepY * end),
        paint,
      );
      drawn = end + gapWidth;
      x = from.dx + stepX * drawn;
      y = from.dy + stepY * drawn;
    }
  }

  /// Registers a participant slot hit area for edit-mode interaction.
  void _registerParticipantSlotHitArea({
    required String matchId,
    required String slotPosition,
    required String? participantId,
    required double x,
    required double y,
    required int serialNumber,
  }) {
    participantSlotHitAreas.add(
      ParticipantSlotHitArea(
        matchId: matchId,
        slotPosition: slotPosition,
        participantId: participantId,
        boundingRect: Rect.fromLTWH(x, y, listW, rowH),
        serialNumber: serialNumber,
      ),
    );
  }

  // ── Themed shadow helper ──────────────────────────────────────────────────

  /// Returns a shadow [Paint] whose opacity is scaled by
  /// [themeConfig.shadowOpacityMultiplier].
  Paint _themedShadow({
    double blur = 6.0,
    Color color = const Color(0x1A000000),
  }) {
    final scaledAlpha = (color.a * themeConfig.shadowOpacityMultiplier).clamp(0.0, 1.0);
    return _Pens.shadow(
      blur: blur,
      color: color.withValues(alpha: scaledAlpha),
    );
  }

  @override
  // Repaint only when the data that drives the visual output actually changes.
  bool shouldRepaint(covariant TieSheetPainter old) =>
      old.matches != matches ||
      old.participants != participants ||
      old.bracketType != bracketType ||
      old.includeThirdPlaceMatch != includeThirdPlaceMatch ||
      old.isEditModeEnabled != isEditModeEnabled ||
      old.themeConfig != themeConfig ||
      !identical(old.leftLogoImage, leftLogoImage) ||
      !identical(old.rightLogoImage, rightLogoImage);
}

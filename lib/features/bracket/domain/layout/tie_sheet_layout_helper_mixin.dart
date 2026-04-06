import 'dart:math';
import 'dart:ui' show FontStyle, FontWeight, Offset, Rect;

import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/connector_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/match_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/participant_row_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/tie_sheet_layout_result.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';

/// Shared helper methods for building participant rows, junctions,
/// connectors, and resolving feeder offsets. Used by [TieSheetLayoutEngine].
mixin TieSheetLayoutHelperMixin {
  ParticipantEntity? findParticipantById(
    String? id,
    List<ParticipantEntity> participants,
  ) => id == null ? null : participants.where((p) => p.id == id).firstOrNull;

  String participantDisplayName(ParticipantEntity p) =>
      p.fullName.toUpperCase();

  double computeFontSize(double baseSize, double delta) => baseSize + delta;

  double computeCenteredTextY(
    double containerY,
    double containerHeight,
    double fontSize,
  ) => containerY + (containerHeight - fontSize) / 2;

  /// Computes layout data for a single participant row card.
  ParticipantRowLayoutData computeParticipantRowLayout({
    required String matchId,
    required String slotPosition,
    required String? participantId,
    required int serialNumber,
    required double x,
    required double y,
    required TieSheetLayoutDimensions dims,
    required TieSheetThemeConfig themeConfig,
    required bool isMirrored,
    required bool isPlaceholder,
    required String displayName,
    String? displayRegistrationId,
  }) {
    final right = x + dims.participantListTotalWidth;
    final rowH = dims.participantRowHeight;
    final noColW = dims.serialNumberColumnWidth;
    final nameColW = dims.participantNameColumnWidth;
    final regIdColW = dims.registrationIdColumnWidth;
    final delta = dims.fontSizeDelta;

    final cardRect = Rect.fromLTRB(x, y + 1, right, y + rowH - 1);

    Rect accentRect;
    List<LineSegmentLayoutData> dividers;
    PositionedTextLayoutData serialText;
    PositionedTextLayoutData nameText;
    PositionedTextLayoutData? regIdText;

    final textY = computeCenteredTextY(y, rowH, computeFontSize(10, delta));
    final boldWeight = themeConfig.isTextForceBold
        ? FontWeight.w900
        : FontWeight.bold;
    final normalWeight = themeConfig.isTextForceBold
        ? FontWeight.w800
        : FontWeight.normal;

    if (!isMirrored) {
      accentRect = Rect.fromLTRB(
        x,
        y + 1,
        x + themeConfig.accentStripWidth,
        y + rowH - 1,
      );
      dividers = [
        LineSegmentLayoutData(
          startOffset: Offset(x + noColW, y + 4),
          endOffset: Offset(x + noColW, y + rowH - 4),
        ),
        LineSegmentLayoutData(
          startOffset: Offset(x + noColW + nameColW, y + 4),
          endOffset: Offset(x + noColW + nameColW, y + rowH - 4),
        ),
      ];
      serialText = PositionedTextLayoutData(
        textContent: '$serialNumber',
        renderPosition: Offset(x + noColW / 2, textY),
        fontSize: computeFontSize(10, delta),
        fontWeight: isPlaceholder ? boldWeight : normalWeight,
        isCenterAligned: true,
        textColorType: isPlaceholder
            ? TextColorType.muted
            : TextColorType.secondary,
      );
      nameText = PositionedTextLayoutData(
        textContent: displayName,
        renderPosition: Offset(x + noColW + 8, textY),
        fontSize: computeFontSize(10, delta),
        fontWeight: boldWeight,
        fontStyle: isPlaceholder ? FontStyle.italic : FontStyle.normal,
        textColorType: isPlaceholder
            ? TextColorType.muted
            : TextColorType.primary,
      );
      if (displayRegistrationId != null && displayRegistrationId.isNotEmpty) {
        regIdText = PositionedTextLayoutData(
          textContent: displayRegistrationId,
          renderPosition: Offset(right - 8, textY),
          fontSize: computeFontSize(9, delta),
          fontWeight: normalWeight,
          isRightAligned: true,
          textColorType: TextColorType.secondary,
        );
      }
    } else {
      accentRect = Rect.fromLTRB(
        right - themeConfig.accentStripWidth,
        y + 1,
        right,
        y + rowH - 1,
      );
      dividers = [
        LineSegmentLayoutData(
          startOffset: Offset(x + regIdColW, y + 4),
          endOffset: Offset(x + regIdColW, y + rowH - 4),
        ),
        LineSegmentLayoutData(
          startOffset: Offset(x + regIdColW + nameColW, y + 4),
          endOffset: Offset(x + regIdColW + nameColW, y + rowH - 4),
        ),
      ];
      serialText = PositionedTextLayoutData(
        textContent: '$serialNumber',
        renderPosition: Offset(right - noColW / 2, textY),
        fontSize: computeFontSize(10, delta),
        fontWeight: normalWeight,
        isCenterAligned: true,
        textColorType: TextColorType.secondary,
      );
      nameText = PositionedTextLayoutData(
        textContent: displayName,
        renderPosition: Offset(x + regIdColW + nameColW - 8, textY),
        fontSize: computeFontSize(10, delta),
        fontWeight: boldWeight,
        isRightAligned: true,
        textColorType: TextColorType.primary,
      );
      if (displayRegistrationId != null && displayRegistrationId.isNotEmpty) {
        regIdText = PositionedTextLayoutData(
          textContent: displayRegistrationId,
          renderPosition: Offset(x + 8, textY),
          fontSize: computeFontSize(9, delta),
          fontWeight: normalWeight,
          textColorType: TextColorType.secondary,
        );
      }
    }

    final connectorAnchor = isMirrored
        ? Offset(x, y + rowH / 2)
        : Offset(x + dims.participantListTotalWidth, y + rowH / 2);

    return ParticipantRowLayoutData(
      matchId: matchId,
      slotPosition: slotPosition,
      participantId: participantId,
      serialNumber: serialNumber,
      cardBoundingRect: cardRect,
      accentStripBoundingRect: accentRect,
      columnDividerLines: dividers,
      serialNumberTextLayout: serialText,
      participantNameTextLayout: nameText,
      registrationIdTextLayout: regIdText,
      isMirroredLayout: isMirrored,
      isPlaceholderRow: isPlaceholder,
      connectorAnchorOffset: connectorAnchor,
      displayName: displayName,
      displayRegistrationId: displayRegistrationId,
    );
  }

  /// Lays out participant list for R1 matches. Returns next serial index.
  int computeParticipantListLayout({
    required List<MatchEntity> roundOneMatches,
    required List<ParticipantEntity> participants,
    required double x,
    required double startY,
    required TieSheetLayoutDimensions dims,
    required TieSheetThemeConfig themeConfig,
    required bool isMirrored,
    required Map<String, Offset> nodeOffsets,
    required List<ParticipantRowLayoutData> outputRows,
    int startIndex = 0,
    bool drawTbdSlots = false,
  }) {
    var idx = startIndex;
    var y = startY;
    final nodeX = isMirrored ? x : x + dims.participantListTotalWidth;

    for (final match in roundOneMatches) {
      final blueParticipant = findParticipantById(
        match.participantBlueId,
        participants,
      );
      final redParticipant = findParticipantById(
        match.participantRedId,
        participants,
      );
      final drawBlue = blueParticipant != null || drawTbdSlots;
      final drawRed = redParticipant != null || drawTbdSlots;

      if (drawBlue) {
        idx++;
        final isPlaceholder = blueParticipant == null;
        final name = isPlaceholder
            ? 'TBD'
            : participantDisplayName(blueParticipant);
        outputRows.add(
          computeParticipantRowLayout(
            matchId: match.id,
            slotPosition: 'blue',
            participantId: match.participantBlueId,
            serialNumber: idx,
            x: x,
            y: y,
            dims: dims,
            themeConfig: themeConfig,
            isMirrored: isMirrored,
            isPlaceholder: isPlaceholder,
            displayName: name,
            displayRegistrationId: blueParticipant?.registrationId,
          ),
        );
        nodeOffsets['${match.id}_top_input'] = Offset(
          nodeX,
          y + dims.participantRowHeight / 2,
        );
        y += dims.participantRowHeight;
      }

      if (drawBlue && drawRed) y += dims.intraMatchGapHeight;

      if (drawRed) {
        idx++;
        final isPlaceholder = redParticipant == null;
        final name = isPlaceholder
            ? 'TBD'
            : participantDisplayName(redParticipant);
        outputRows.add(
          computeParticipantRowLayout(
            matchId: match.id,
            slotPosition: 'red',
            participantId: match.participantRedId,
            serialNumber: idx,
            x: x,
            y: y,
            dims: dims,
            themeConfig: themeConfig,
            isMirrored: isMirrored,
            isPlaceholder: isPlaceholder,
            displayName: name,
            displayRegistrationId: redParticipant?.registrationId,
          ),
        );
        nodeOffsets['${match.id}_bot_input'] = Offset(
          nodeX,
          y + dims.participantRowHeight / 2,
        );
        y += dims.participantRowHeight;
      }
      y += dims.interMatchGapHeight;
    }
    return idx;
  }

  Offset? resolveInputOffset({
    required MatchEntity match,
    required bool isTopSlot,
    required List<MatchEntity> allMatches,
    required Map<String, Offset> nodeOffsets,
    String? winnersBracketId,
    String? losersBracketId,
  }) {
    final explicitKey = isTopSlot
        ? '${match.id}_top_input'
        : '${match.id}_bot_input';
    if (nodeOffsets.containsKey(explicitKey)) return nodeOffsets[explicitKey];

    final wFeeders = allMatches
        .where((m) => m.winnerAdvancesToMatchId == match.id)
        .toList();
    final lFeeders = allMatches
        .where((m) => m.loserAdvancesToMatchId == match.id)
        .toList();

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
          final wbF = wFeeders
              .where((f) => f.bracketId == winnersBracketId)
              .firstOrNull;
          final lbF = wFeeders
              .where((f) => f.bracketId == losersBracketId)
              .firstOrNull;
          targetFeeder = isTopSlot
              ? (wbF ?? wFeeders.first)
              : (lbF ?? wFeeders.last);
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
      final isCrossBracket =
          targetFeeder.bracketId == winnersBracketId &&
          match.bracketId == losersBracketId;
      if (isCrossBracket && !nodeOffsets.containsKey(explicitKey)) return null;
      return nodeOffsets['${targetFeeder.id}_output'];
    }
    return null;
  }

  void computeJunctionLayout({
    required MatchEntity match,
    required double junctionX,
    required bool isMirrored,
    required List<MatchEntity> allMatches,
    required List<ParticipantEntity> participants,
    required TieSheetLayoutDimensions dims,
    required TieSheetThemeConfig themeConfig,
    required Map<String, Offset> nodeOffsets,
    required List<MatchLayoutData> matchLayouts,
    required List<ConnectorLayoutData> connectors,
    String? winnersBracketId,
    String? losersBracketId,
  }) {
    final isBye = match.resultType == MatchResultType.bye;

    if (isBye) {
      _computeByeJunction(
        match,
        junctionX,
        isMirrored,
        allMatches,
        dims,
        themeConfig,
        nodeOffsets,
        matchLayouts,
        connectors,
        winnersBracketId,
        losersBracketId,
      );
      return;
    }

    final topIn = resolveInputOffset(
      match: match,
      isTopSlot: true,
      allMatches: allMatches,
      nodeOffsets: nodeOffsets,
      winnersBracketId: winnersBracketId,
      losersBracketId: losersBracketId,
    );
    final botIn = resolveInputOffset(
      match: match,
      isTopSlot: false,
      allMatches: allMatches,
      nodeOffsets: nodeOffsets,
      winnersBracketId: winnersBracketId,
      losersBracketId: losersBracketId,
    );

    late Offset effectiveTop, effectiveBot;
    String? missingTopLabel, missingBotLabel;

    if (topIn != null && botIn != null) {
      effectiveTop = topIn;
      effectiveBot = botIn;
    } else if (topIn != null) {
      effectiveTop = topIn;
      effectiveBot = Offset(junctionX - (isMirrored ? -30 : 30), topIn.dy + 40);
      final p = findParticipantById(match.participantRedId, participants);
      missingBotLabel = p != null
          ? '^ ${participantDisplayName(p)}'
          : '^ from WB';
    } else if (botIn != null) {
      effectiveBot = botIn;
      effectiveTop = Offset(junctionX - (isMirrored ? -30 : 30), botIn.dy - 40);
      final p = findParticipantById(match.participantBlueId, participants);
      missingTopLabel = p != null
          ? 'v ${participantDisplayName(p)}'
          : 'v from WB';
    } else {
      final estY =
          100.0 +
          (match.matchNumberInRound * 2 - 1) *
              (dims.participantRowHeight + dims.interMatchGapHeight / 2);
      effectiveTop = Offset(junctionX, estY);
      effectiveBot = Offset(junctionX, estY + dims.participantRowHeight * 2);
    }

    final midY = (effectiveTop.dy + effectiveBot.dy) / 2;
    nodeOffsets['${match.id}_output'] = Offset(junctionX, midY);

    final topArcType = match.participantBlueId != null
        ? ConnectorVisualType.wonAdvancement
        : ConnectorVisualType.pendingAdvancement;
    final botArcType = match.participantRedId != null
        ? ConnectorVisualType.wonAdvancement
        : ConnectorVisualType.pendingAdvancement;

    // Top arm: horizontal from input → right-angle corner → vertical to midY
    connectors.add(
      ConnectorLayoutData.straightSegments(
        connectorVisualType: topArcType,
        segments: [
          LineSegmentLayoutData(
            startOffset: effectiveTop,
            endOffset: Offset(junctionX, effectiveTop.dy),
          ),
          LineSegmentLayoutData(
            startOffset: Offset(junctionX, effectiveTop.dy),
            endOffset: Offset(junctionX, midY),
          ),
        ],
      ),
    );
    // Bottom arm: horizontal from input → right-angle corner → vertical to midY
    connectors.add(
      ConnectorLayoutData.straightSegments(
        connectorVisualType: botArcType,
        segments: [
          LineSegmentLayoutData(
            startOffset: effectiveBot,
            endOffset: Offset(junctionX, effectiveBot.dy),
          ),
          LineSegmentLayoutData(
            startOffset: Offset(junctionX, effectiveBot.dy),
            endOffset: Offset(junctionX, midY),
          ),
        ],
      ),
    );

    final delta = dims.fontSizeDelta;
    final gNum = match.globalMatchDisplayNumber;
    final winner = match.winnerId != null
        ? findParticipantById(match.winnerId, participants)
        : null;
    final badgeX = junctionX + (isMirrored ? 20 : -20);
    final badgeHalfSize = max(
      themeConfig.badgeMinHalfSize,
      max(computeFontSize(9, delta), computeFontSize(9, delta)) / 2 +
          themeConfig.badgePadding,
    );

    MatchNumberPillLayoutData? pillLayout;
    if (gNum != null) {
      final pillHalfW = max(
        themeConfig.matchPillMinHalfWidth,
        8.0 + themeConfig.matchPillHorizontalPadding,
      );
      final pillHalfH = max(
        themeConfig.matchPillMinHalfHeight,
        8.0 + themeConfig.matchPillVerticalPadding,
      );
      final pillRect = Rect.fromCenter(
        center: Offset(junctionX, midY),
        width: pillHalfW * 2,
        height: pillHalfH * 2,
      );
      pillLayout = MatchNumberPillLayoutData(
        centerOffset: Offset(junctionX, midY),
        matchNumberText: '$gNum',
        pillBoundingRect: pillRect,
      );
    }

    PositionedTextLayoutData? winnerText;
    if (winner != null) {
      final winnerX = junctionX + (isMirrored ? -18 : 18);
      winnerText = PositionedTextLayoutData(
        textContent: participantDisplayName(winner),
        renderPosition: Offset(winnerX, midY - 14),
        fontSize: computeFontSize(9, delta),
        fontWeight: FontWeight.bold,
        isRightAligned: isMirrored,
        textColorType: TextColorType.primary,
      );
    }

    PositionedTextLayoutData? missingTopText, missingBotText;
    if (missingTopLabel != null) {
      final labelDx = isMirrored ? 10.0 : -10.0;
      missingTopText = PositionedTextLayoutData(
        textContent: missingTopLabel,
        renderPosition: Offset(effectiveTop.dx + labelDx, effectiveTop.dy - 6),
        fontSize: computeFontSize(9, delta),
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        isRightAligned: !isMirrored,
        textColorType: TextColorType.muted,
      );
    }
    if (missingBotLabel != null) {
      final labelDx = isMirrored ? 10.0 : -10.0;
      missingBotText = PositionedTextLayoutData(
        textContent: missingBotLabel,
        renderPosition: Offset(effectiveBot.dx + labelDx, effectiveBot.dy - 6),
        fontSize: computeFontSize(9, delta),
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        isRightAligned: !isMirrored,
        textColorType: TextColorType.muted,
      );
    }

    matchLayouts.add(
      MatchLayoutData(
        matchId: match.id,
        matchNodeType: MatchNodeType.standardJunction,
        isByeMatch: false,
        blueCornerBadgeLayout: CornerBadgeLayoutData(
          centerOffset: Offset(badgeX, effectiveTop.dy - 14),
          badgeText: 'B',
          badgeColorType: CornerBadgeColorType.blue,
          computedBadgeHalfSize: badgeHalfSize,
        ),
        redCornerBadgeLayout: CornerBadgeLayoutData(
          centerOffset: Offset(badgeX, effectiveBot.dy + 14),
          badgeText: 'R',
          badgeColorType: CornerBadgeColorType.red,
          computedBadgeHalfSize: badgeHalfSize,
        ),
        matchNumberPillLayout: pillLayout,
        winnerNameTextLayout: winnerText,
        missingTopInputLabelLayout: missingTopText,
        missingBottomInputLabelLayout: missingBotText,
      ),
    );
  }

  void _computeByeJunction(
    MatchEntity match,
    double junctionX,
    bool isMirrored,
    List<MatchEntity> allMatches,
    TieSheetLayoutDimensions dims,
    TieSheetThemeConfig themeConfig,
    Map<String, Offset> nodeOffsets,
    List<MatchLayoutData> matchLayouts,
    List<ConnectorLayoutData> connectors,
    String? winnersBracketId,
    String? losersBracketId,
  ) {
    final topIn = resolveInputOffset(
      match: match,
      isTopSlot: true,
      allMatches: allMatches,
      nodeOffsets: nodeOffsets,
      winnersBracketId: winnersBracketId,
      losersBracketId: losersBracketId,
    );
    if (topIn == null) return;

    final topType = match.participantBlueId != null
        ? ConnectorVisualType.wonAdvancement
        : ConnectorVisualType.pendingAdvancement;
    connectors.add(
      ConnectorLayoutData.singleLine(
        connectorVisualType: topType,
        startOffset: topIn,
        endOffset: Offset(junctionX, topIn.dy),
      ),
    );

    final nextJunctionX = isMirrored
        ? junctionX - dims.roundColumnWidth
        : junctionX + dims.roundColumnWidth;
    connectors.add(
      ConnectorLayoutData.singleLine(
        connectorVisualType: ConnectorVisualType.byeAdvancement,
        startOffset: Offset(junctionX, topIn.dy),
        endOffset: Offset(nextJunctionX, topIn.dy),
      ),
    );
    nodeOffsets['${match.id}_output'] = Offset(nextJunctionX, topIn.dy);

    matchLayouts.add(
      MatchLayoutData(
        matchId: match.id,
        matchNodeType: MatchNodeType.standardJunction,
        isByeMatch: true,
      ),
    );
  }
}

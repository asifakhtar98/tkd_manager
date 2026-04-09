import 'dart:math';
import 'dart:ui' show FontWeight, Offset, Rect, Size;

import 'package:tkd_saas/features/bracket/domain/entities/bracket_medal_placement_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/connector_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/header_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/match_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/medal_table_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/participant_row_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/section_label_layout_data.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/tie_sheet_layout_result.dart';
import 'package:tkd_saas/features/bracket/domain/layout/tie_sheet_layout_dimension_calculator.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_classification.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';

import 'package:tkd_saas/features/bracket/domain/services/bracket_medal_computation_service.dart';
import 'package:tkd_saas/features/bracket/domain/layout/tie_sheet_layout_helper_mixin.dart';

/// Pure-Dart layout engine that computes all bracket geometry.
///
/// Produces a [TieSheetLayoutResult] consumed by both the Syncfusion PDF
/// renderer (on-screen + export) and any future widget renderer.
class TieSheetLayoutEngine with TieSheetLayoutHelperMixin {
  TieSheetLayoutEngine(this._medalComputationService);

  final BracketMedalComputationService _medalComputationService;

  /// Computes the complete bracket layout.
  TieSheetLayoutResult computeLayout({
    required TournamentEntity tournament,
    required List<MatchEntity> matches,
    required List<ParticipantEntity> participants,
    required String bracketType,
    required bool includeThirdPlaceMatch,
    required TieSheetThemeConfig themeConfig,
    required BracketClassification classification,
    String? winnersBracketId,
    String? losersBracketId,
    List<BracketMedalPlacementEntity>? finalMedalPlacements,
    bool hasLeftLogo = false,
    bool hasRightLogo = false,
    double leftLogoAspectRatio = 1.0,
    double rightLogoAspectRatio = 1.0,
  }) {
    final hasLogos = hasLeftLogo || hasRightLogo;
    final isDouble = winnersBracketId != null && losersBracketId != null;
    final dims = TieSheetLayoutDimensionCalculator.computeDimensions(
      themeConfig,
      hasLogos: hasLogos,
    );

    final nodeOffsets = <String, Offset>{};
    final participantRows = <ParticipantRowLayoutData>[];
    final matchLayouts = <MatchLayoutData>[];
    final connectors = <ConnectorLayoutData>[];
    final sectionLabels = <SectionLabelLayoutData>[];

    final canvasSize = isDouble
        ? _computeDeCanvasSize(
            matches,
            dims,
            themeConfig,
            hasLogos,
            winnersBracketId,
            losersBracketId,
            includeThirdPlaceMatch,
          )
        : _computeSeCanvasSize(
            matches,
            dims,
            themeConfig,
            hasLogos,
            includeThirdPlaceMatch,
          );

    final headerData = _computeHeaderLayout(
      tournament: tournament,
      classification: classification,
      canvasSize: canvasSize,
      dims: dims,
      themeConfig: themeConfig,
      hasLogos: hasLogos,
      hasLeftLogo: hasLeftLogo,
      hasRightLogo: hasRightLogo,
      leftLogoAspectRatio: leftLogoAspectRatio,
      rightLogoAspectRatio: rightLogoAspectRatio,
    );

    double headerBottom =
        headerData.classificationInfoRowBoundingRect.bottom + themeConfig.headerBannerBottomGap;

    if (isDouble) {
      _computeDeLayout(
        matches: matches,
        participants: participants,
        dims: dims,
        themeConfig: themeConfig,
        canvasSize: canvasSize,
        startY: headerBottom,
        winnersBracketId: winnersBracketId,
        losersBracketId: losersBracketId,
        nodeOffsets: nodeOffsets,
        participantRows: participantRows,
        matchLayouts: matchLayouts,
        connectors: connectors,
        sectionLabels: sectionLabels,
      );
    } else {
      _computeSeLayout(
        matches: matches,
        participants: participants,
        dims: dims,
        themeConfig: themeConfig,
        canvasSize: canvasSize,
        startY: headerBottom,
        includeThirdPlaceMatch: includeThirdPlaceMatch,
        nodeOffsets: nodeOffsets,
        participantRows: participantRows,
        matchLayouts: matchLayouts,
        connectors: connectors,
      );
    }

    final medalData = _computeMedalTableLayout(
      canvasSize: canvasSize,
      dims: dims,
      themeConfig: themeConfig,
      matches: matches,
      participants: participants,
      isDouble: isDouble,
      winnersBracketId: winnersBracketId,
      losersBracketId: losersBracketId,
      includeThirdPlaceMatch: includeThirdPlaceMatch,
      finalMedalPlacements: finalMedalPlacements,
    );

    return TieSheetLayoutResult(
      computedCanvasSize: canvasSize,
      computedDimensions: dims,
      headerLayoutData: headerData,
      participantRowLayoutDataList: participantRows,
      matchLayoutDataList: matchLayouts,
      connectorLayoutDataList: connectors,
      medalTableLayoutData: medalData,
      sectionLabelLayoutDataList: sectionLabels,
    );
  }

  Size _computeSeCanvasSize(
    List<MatchEntity> matches,
    TieSheetLayoutDimensions dims,
    TieSheetThemeConfig themeConfig,
    bool hasLogos,
    bool includeThirdPlaceMatch,
  ) {
    final seMaxRound = matches.isNotEmpty
        ? matches.map((m) => m.roundNumber).reduce(max)
        : 0;
    final mainMatches = matches
        .where(
          (m) => !(m.roundNumber == seMaxRound && m.matchNumberInRound == 2),
        )
        .toList();
    final winRounds = TieSheetLayoutDimensionCalculator.maxRound(mainMatches);
    final width =
        dims.canvasMargin * 2 +
        dims.participantListTotalWidth +
        (max(0, winRounds - 1) * dims.roundColumnWidth) * 2 +
        dims.centerGapWidth +
        dims.participantListTotalWidth;

    final byRound = TieSheetLayoutDimensionCalculator.groupByRound(mainMatches);
    final r1 = byRound[1] ?? [];
    final r1Count = r1.length;
    final leftR1 = r1
        .where((m) => m.matchNumberInRound <= (r1Count + 1) ~/ 2)
        .toList();
    final rightR1 = r1
        .where((m) => m.matchNumberInRound > (r1Count + 1) ~/ 2)
        .toList();
    final tableH = max(
      TieSheetLayoutDimensionCalculator.computeOneSidedHeight(
        roundOneMatches: leftR1,
        dimensions: dims,
      ),
      TieSheetLayoutDimensionCalculator.computeOneSidedHeight(
        roundOneMatches: rightR1,
        dimensions: dims,
      ),
    );

    final bracketToMedalGap = includeThirdPlaceMatch
        ? max(60.0, tableH / 2 + dims.participantRowHeight * 4 + 150 - tableH)
        : 60.0;

    final height =
        dims.canvasMargin +
        dims.logoRowHeight +
        dims.headerTotalHeight +
        tableH +
        bracketToMedalGap +
        dims.medalTableTotalHeight +
        dims.canvasMargin;

    return Size(
      max(width, themeConfig.canvasMinimumWidth),
      max(height, themeConfig.canvasMinimumHeight),
    );
  }

  Size _computeDeCanvasSize(
    List<MatchEntity> matches,
    TieSheetLayoutDimensions dims,
    TieSheetThemeConfig themeConfig,
    bool hasLogos,
    String? winnersBracketId,
    String? losersBracketId,
    bool includeThirdPlaceMatch,
  ) {
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
    final wbRounds = TieSheetLayoutDimensionCalculator.maxRound(wbMatches);
    final lbRounds = TieSheetLayoutDimensionCalculator.maxRound(lbMatches);
    final maxRounds = max(wbRounds, lbRounds);
    final gfColumns = gfMatches.isEmpty ? 0 : gfMatches.length;

    final width =
        dims.canvasMargin * 2 +
        dims.participantListTotalWidth +
        (maxRounds * dims.roundColumnWidth) +
        (gfColumns * dims.roundColumnWidth) +
        themeConfig.deCanvasExtraWidthPadding;

    final wbR1 =
        TieSheetLayoutDimensionCalculator.groupByRound(wbMatches)[1] ?? [];
    final lbR1 =
        TieSheetLayoutDimensionCalculator.groupByRound(lbMatches)[1] ?? [];
    final wbH = TieSheetLayoutDimensionCalculator.computeOneSidedHeight(
      roundOneMatches: wbR1,
      dimensions: dims,
    );
    final lbH = lbR1.isEmpty
        ? 80.0
        : TieSheetLayoutDimensionCalculator.computeOneSidedHeight(
            roundOneMatches: lbR1,
            dimensions: dims,
            drawTbdSlots: true,
          );

    final height =
        dims.canvasMargin +
        dims.logoRowHeight +
        dims.headerTotalHeight +
        dims.sectionLabelHeight +
        wbH +
        dims.sectionGapHeight +
        dims.sectionLabelHeight +
        lbH +
        themeConfig.deCanvasBracketToMedalGap +
        dims.medalTableTotalHeight +
        dims.canvasMargin;

    return Size(
      max(width, themeConfig.canvasMinimumWidth),
      max(height, themeConfig.canvasMinimumHeight),
    );
  }

  HeaderLayoutData _computeHeaderLayout({
    required TournamentEntity tournament,
    required BracketClassification classification,
    required Size canvasSize,
    required TieSheetLayoutDimensions dims,
    required TieSheetThemeConfig themeConfig,
    required bool hasLogos,
    required bool hasLeftLogo,
    required bool hasRightLogo,
    required double leftLogoAspectRatio,
    required double rightLogoAspectRatio,
  }) {
    var y = dims.canvasMargin;
    final headerLeft = dims.canvasMargin;
    final headerRight = canvasSize.width - dims.canvasMargin;
    final delta = dims.fontSizeDelta;

    Rect? leftLogoBounds;
    Rect? rightLogoBounds;
    if (hasLogos) {
      final logoMaxH = themeConfig.logoMaxHeight;
      if (hasLeftLogo) {
        final w = logoMaxH * leftLogoAspectRatio;
        leftLogoBounds = Rect.fromLTWH(headerLeft, y, w, logoMaxH);
      }
      if (hasRightLogo) {
        final w = logoMaxH * rightLogoAspectRatio;
        rightLogoBounds = Rect.fromLTWH(headerRight - w, y, w, logoMaxH);
      }
      y += themeConfig.logoMaxHeight + themeConfig.logoPadding;
    }

    final bannerH = dims.headerBannerHeight;
    final bannerRect = Rect.fromLTRB(headerLeft, y, headerRight, y + bannerH);

    double fontSize(double base) => base + delta;
    double centeredTextY(double containerY, double containerH, double fs) =>
        containerY + (containerH - fs) / 2;

    final title =
        (tournament.name.isNotEmpty ? tournament.name : 'TOURNAMENT NAME')
            .toUpperCase();
    final titleText = PositionedTextLayoutData(
      textContent: title,
      renderPosition: Offset(canvasSize.width / 2, y + themeConfig.headerTitleTopPadding + delta * 0.5),
      fontSize: fontSize(themeConfig.headerTitleBaseFontSize),
      fontWeight: FontWeight.bold,
      isCenterAligned: true,
      letterSpacing: themeConfig.headerLetterSpacing,
      textColorType: TextColorType.headerBannerPrimary,
    );

    PositionedTextLayoutData? subtitleText;
    if (tournament.dateRange.isNotEmpty || tournament.venue.isNotEmpty) {
      final sub = [
        tournament.dateRange,
        tournament.venue,
      ].where((s) => s.isNotEmpty).join('  •  ');
      subtitleText = PositionedTextLayoutData(
        textContent: sub.toUpperCase(),
        renderPosition: Offset(canvasSize.width / 2, y + themeConfig.headerSubtitleTopOffset + delta * 1.0),
        fontSize: fontSize(themeConfig.headerSubtitleBaseFontSize),
        fontWeight: themeConfig.isTextForceBold
            ? FontWeight.w900
            : FontWeight.normal,
        isCenterAligned: true,
        letterSpacing: themeConfig.subHeaderLetterSpacing,
        textColorType: TextColorType.headerBannerSecondary,
      );
    }

    PositionedTextLayoutData? organizerText;
    if (tournament.organizer.isNotEmpty) {
      organizerText = PositionedTextLayoutData(
        textContent: 'Organised by ${tournament.organizer.toUpperCase()}',
        renderPosition: Offset(canvasSize.width / 2, y + themeConfig.headerOrganizerTopOffset + delta * 1.5),
        fontSize: fontSize(themeConfig.headerOrganizerBaseFontSize),
        fontWeight: themeConfig.isTextForceBold
            ? FontWeight.w900
            : FontWeight.normal,
        isCenterAligned: true,
        textColorType: TextColorType.headerBannerSecondary,
      );
    }
    y += bannerH + themeConfig.headerBannerBottomGap;

    final infoTop = y;
    final infoBottom = y + dims.subHeaderRowHeight;
    final infoRect = Rect.fromLTRB(
      headerLeft,
      infoTop,
      headerRight,
      infoBottom,
    );
    final infoColNoW = dims.serialNumberColumnWidth;
    final remainingW = (headerRight - headerLeft) - infoColNoW;
    final infoColW = remainingW / 3;
    final infoTextY = centeredTextY(
      infoTop,
      dims.subHeaderRowHeight,
      fontSize(11),
    );

    final dividers = <LineSegmentLayoutData>[
      LineSegmentLayoutData(
        startOffset: Offset(headerLeft + infoColNoW, infoTop + themeConfig.classificationDividerInset),
        endOffset: Offset(headerLeft + infoColNoW, infoBottom - themeConfig.classificationDividerInset),
      ),
      LineSegmentLayoutData(
        startOffset: Offset(headerLeft + infoColNoW + infoColW, infoTop + themeConfig.classificationDividerInset),
        endOffset: Offset(headerLeft + infoColNoW + infoColW, infoBottom - themeConfig.classificationDividerInset),
      ),
      LineSegmentLayoutData(
        startOffset: Offset(
          headerLeft + infoColNoW + infoColW * 2,
          infoTop + themeConfig.classificationDividerInset,
        ),
        endOffset: Offset(
          headerLeft + infoColNoW + infoColW * 2,
          infoBottom - themeConfig.classificationDividerInset,
        ),
      ),
    ];

    final ageLabel = classification.ageCategoryLabel.isNotEmpty
        ? classification.ageCategoryLabel.toUpperCase()
        : 'AGE CATEGORY';
    final genderLabel = classification.genderLabel.isNotEmpty
        ? classification.genderLabel.toUpperCase()
        : 'GENDER';
    final weightLabel = classification.weightDivisionLabel.isNotEmpty
        ? classification.weightDivisionLabel.toUpperCase()
        : 'WEIGHT DIVISION';

    PositionedTextLayoutData cellText(String text, double cx) =>
        PositionedTextLayoutData(
          textContent: text,
          renderPosition: Offset(cx, infoTextY),
          fontSize: fontSize(11),
          fontWeight: themeConfig.isTextForceBold
              ? FontWeight.w900
              : FontWeight.bold,
          isCenterAligned: true,
          textColorType: TextColorType.primary,
        );

    final cellTexts = [
      cellText('No.', headerLeft + infoColNoW / 2),
      cellText(ageLabel, headerLeft + infoColNoW + infoColW / 2),
      cellText(genderLabel, headerLeft + infoColNoW + infoColW + infoColW / 2),
      cellText(
        weightLabel,
        headerLeft + infoColNoW + infoColW * 2 + infoColW / 2,
      ),
    ];

    final infoRowFontSize = fontSize(themeConfig.headerSubtitleBaseFontSize);
    // Use the subtitle base font size for info row cells to keep them
    // consistent with the header secondary text scale.

    return HeaderLayoutData(
      headerBannerBoundingRect: bannerRect,
      tournamentTitleTextLayout: titleText,
      tournamentSubtitleTextLayout: subtitleText,
      tournamentOrganizerTextLayout: organizerText,
      leftLogoBoundingRect: leftLogoBounds,
      rightLogoBoundingRect: rightLogoBounds,
      classificationInfoRowBoundingRect: infoRect,
      classificationInfoRowDividerLines: dividers,
      classificationCellTextLayoutList: cellTexts,
    );
  }

  void _computeSeLayout({
    required List<MatchEntity> matches,
    required List<ParticipantEntity> participants,
    required TieSheetLayoutDimensions dims,
    required TieSheetThemeConfig themeConfig,
    required Size canvasSize,
    required double startY,
    required bool includeThirdPlaceMatch,
    required Map<String, Offset> nodeOffsets,
    required List<ParticipantRowLayoutData> participantRows,
    required List<MatchLayoutData> matchLayouts,
    required List<ConnectorLayoutData> connectors,
  }) {
    final tableTop = startY + themeConfig.headerToTableGap;
    final seMaxRound = matches.isNotEmpty
        ? matches.map((m) => m.roundNumber).reduce(max)
        : 0;
    final mainMatches = matches
        .where(
          (m) => !(m.roundNumber == seMaxRound && m.matchNumberInRound == 2),
        )
        .toList();
    final winRounds = TieSheetLayoutDimensionCalculator.maxRound(mainMatches);
    final winByRound = TieSheetLayoutDimensionCalculator.groupByRound(
      mainMatches,
    );
    final r1Matches = winByRound[1] ?? [];
    final r1Count = r1Matches.length;
    final leftHalfCount = (r1Count + 1) ~/ 2;
    final rightEdge = canvasSize.width - dims.canvasMargin;
    final rightTableLeft = rightEdge - dims.participantListTotalWidth;

    if (r1Count == 1 && winRounds == 1) {
      final match = r1Matches.first;
      final b = findParticipantById(match.participantBlueId, participants);
      final r = findParticipantById(match.participantRedId, participants);
      int idx = 0;
      if (b != null) {
        idx++;
        participantRows.add(
          computeParticipantRowLayout(
            matchId: match.id,
            slotPosition: 'blue',
            participantId: match.participantBlueId,
            serialNumber: idx,
            x: dims.canvasMargin,
            y: tableTop,
            dims: dims,
            themeConfig: themeConfig,
            isMirrored: false,
            isPlaceholder: false,
            displayName: participantDisplayName(b),
            displayRegistrationId: b.registrationId,
          ),
        );
        nodeOffsets['${match.id}_top_input'] = Offset(
          dims.canvasMargin + dims.participantListTotalWidth,
          tableTop + dims.participantRowHeight / 2,
        );
      }
      if (r != null) {
        idx++;
        participantRows.add(
          computeParticipantRowLayout(
            matchId: match.id,
            slotPosition: 'red',
            participantId: match.participantRedId,
            serialNumber: idx,
            x: rightTableLeft,
            y: tableTop,
            dims: dims,
            themeConfig: themeConfig,
            isMirrored: true,
            isPlaceholder: false,
            displayName: participantDisplayName(r),
            displayRegistrationId: r.registrationId,
          ),
        );
        nodeOffsets['${match.id}_bot_input'] = Offset(
          rightTableLeft,
          tableTop + dims.participantRowHeight / 2,
        );
      }
    } else {
      final leftR1 = r1Matches
          .where((m) => m.matchNumberInRound <= leftHalfCount)
          .toList();
      final rightR1 = r1Matches
          .where((m) => m.matchNumberInRound > leftHalfCount)
          .toList();
      final nextIdx = computeParticipantListLayout(
        roundOneMatches: leftR1,
        participants: participants,
        x: dims.canvasMargin,
        startY: tableTop,
        dims: dims,
        themeConfig: themeConfig,
        isMirrored: false,
        nodeOffsets: nodeOffsets,
        outputRows: participantRows,
      );
      computeParticipantListLayout(
        roundOneMatches: rightR1,
        participants: participants,
        x: rightTableLeft,
        startY: tableTop,
        dims: dims,
        themeConfig: themeConfig,
        isMirrored: true,
        nodeOffsets: nodeOffsets,
        outputRows: participantRows,
        startIndex: nextIdx,
      );
    }

    for (var r = 1; r <= winRounds; r++) {
      final roundMatches = winByRound[r] ?? [];
      final c = roundMatches.length;
      for (final match in roundMatches) {
        if (r == winRounds) {
          _computeCenterFinalJunction(
            match,
            canvasSize.width / 2,
            matches,
            participants,
            dims,
            themeConfig,
            nodeOffsets,
            matchLayouts,
            connectors,
          );
        } else {
          final isLeft = match.matchNumberInRound <= (c + 1) ~/ 2;
          final junctionX = isLeft
              ? dims.canvasMargin +
                    dims.participantListTotalWidth +
                    (r * dims.roundColumnWidth)
              : rightEdge -
                    dims.participantListTotalWidth -
                    (r * dims.roundColumnWidth);
          computeJunctionLayout(
            match: match,
            junctionX: junctionX,
            isMirrored: !isLeft,
            allMatches: matches,
            participants: participants,
            dims: dims,
            themeConfig: themeConfig,
            nodeOffsets: nodeOffsets,
            matchLayouts: matchLayouts,
            connectors: connectors,
          );
        }
      }
    }

    if (includeThirdPlaceMatch) {
      final thirdMaxRound = matches.isNotEmpty
          ? matches.map((m) => m.roundNumber).reduce(max)
          : 0;
      final thirdMatch = matches
          .where(
            (m) => m.roundNumber == thirdMaxRound && m.matchNumberInRound == 2,
          )
          .firstOrNull;
      if (thirdMatch != null) {
        _compute3rdPlaceMatchLayout(
          thirdMatch,
          matches,
          participants,
          dims,
          themeConfig,
          nodeOffsets,
          matchLayouts,
          connectors,
        );
      }
    }
  }

  void _computeCenterFinalJunction(
    MatchEntity match,
    double junctionX,
    List<MatchEntity> allMatches,
    List<ParticipantEntity> participants,
    TieSheetLayoutDimensions dims,
    TieSheetThemeConfig themeConfig,
    Map<String, Offset> nodeOffsets,
    List<MatchLayoutData> matchLayouts,
    List<ConnectorLayoutData> connectors,
  ) {
    if (match.resultType == MatchResultType.bye) return;
    final topIn = resolveInputOffset(
      match: match,
      isTopSlot: true,
      allMatches: allMatches,
      nodeOffsets: nodeOffsets,
    );
    final botIn = resolveInputOffset(
      match: match,
      isTopSlot: false,
      allMatches: allMatches,
      nodeOffsets: nodeOffsets,
    );
    if (topIn == null || botIn == null) return;

    final rawMidY = (topIn.dy + botIn.dy) / 2;
    final minSpan = themeConfig.centerFinalMinimumSpan;
    final actualSpan = (botIn.dy - topIn.dy).abs();
    final halfSpan = max(actualSpan, minSpan) / 2;
    final topArmY = rawMidY - halfSpan;
    final botArmY = rawMidY + halfSpan;

    final topType = match.participantBlueId != null
        ? ConnectorVisualType.wonAdvancement
        : ConnectorVisualType.pendingAdvancement;
    final botType = match.participantRedId != null
        ? ConnectorVisualType.wonAdvancement
        : ConnectorVisualType.pendingAdvancement;
    connectors.add(
      ConnectorLayoutData.singleLine(
        connectorVisualType: topType,
        startOffset: topIn,
        endOffset: Offset(junctionX, topIn.dy),
      ),
    );
    connectors.add(
      ConnectorLayoutData.singleLine(
        connectorVisualType: botType,
        startOffset: botIn,
        endOffset: Offset(junctionX, botIn.dy),
      ),
    );
    final realTopY = min(topIn.dy, topArmY);
    final realBotY = max(botIn.dy, botArmY);
    connectors.add(
      ConnectorLayoutData.singleLine(
        connectorVisualType: ConnectorVisualType.genericTrunk,
        startOffset: Offset(junctionX, realTopY),
        endOffset: Offset(junctionX, realBotY),
      ),
    );
    nodeOffsets['${match.id}_output'] = Offset(junctionX, rawMidY);

    final delta = dims.fontSizeDelta;
    final gNum = match.globalMatchDisplayNumber;
    final winner = match.winnerId != null
        ? findParticipantById(match.winnerId, participants)
        : null;
    final badgeHalfSize = max(
      themeConfig.badgeMinHalfSize,
      computeFontSize(9, delta) / 2 + themeConfig.badgePadding,
    );

    MatchNumberPillLayoutData? pill;
    if (gNum != null) {
      final hw = max(
        themeConfig.matchPillMinHalfWidth,
        8.0 + themeConfig.matchPillHorizontalPadding,
      );
      final hh = max(
        themeConfig.matchPillMinHalfHeight,
        8.0 + themeConfig.matchPillVerticalPadding,
      );
      final pillX = junctionX + themeConfig.matchPillHorizontalOffset;
      final pr = Rect.fromCenter(
        center: Offset(pillX, rawMidY),
        width: hw * 2,
        height: hh * 2,
      );
      pill = MatchNumberPillLayoutData(
        centerOffset: Offset(pillX, rawMidY),
        matchNumberText: '$gNum',
        pillBoundingRect: pr,
      );
    }

    PositionedTextLayoutData? winnerText;
    if (winner != null) {
      winnerText = PositionedTextLayoutData(
        textContent: participantDisplayName(winner),
        renderPosition: Offset(junctionX, rawMidY - 26),
        fontSize: computeFontSize(9, delta),
        fontWeight: FontWeight.bold,
        isCenterAligned: true,
        textColorType: TextColorType.primary,
      );
    }

    matchLayouts.add(
      MatchLayoutData(
        matchId: match.id,
        matchNodeType: MatchNodeType.centerFinalJunction,
        isByeMatch: false,
        blueCornerBadgeLayout: CornerBadgeLayoutData(
          centerOffset: Offset(junctionX - 20, topArmY - 14),
          badgeText: 'B',
          badgeColorType: CornerBadgeColorType.blue,
          computedBadgeHalfSize: badgeHalfSize,
        ),
        redCornerBadgeLayout: CornerBadgeLayoutData(
          centerOffset: Offset(junctionX + 20, botArmY + 14),
          badgeText: 'R',
          badgeColorType: CornerBadgeColorType.red,
          computedBadgeHalfSize: badgeHalfSize,
        ),
        matchNumberPillLayout: pill,
        winnerNameTextLayout: winnerText,
      ),
    );
  }

  void _compute3rdPlaceMatchLayout(
    MatchEntity match,
    List<MatchEntity> allMatches,
    List<ParticipantEntity> participants,
    TieSheetLayoutDimensions dims,
    TieSheetThemeConfig themeConfig,
    Map<String, Offset> nodeOffsets,
    List<MatchLayoutData> matchLayouts,
    List<ConnectorLayoutData> connectors,
  ) {
    final allRounds = allMatches.map((m) => m.roundNumber).reduce(max);
    final finals = allMatches
        .where((m) => m.roundNumber == allRounds && m.matchNumberInRound == 1)
        .firstOrNull;
    if (finals == null || !nodeOffsets.containsKey('${finals.id}_output')) {
      return;
    }

    final fPos = nodeOffsets['${finals.id}_output']!;
    final x = fPos.dx;
    final y =
        fPos.dy +
        dims.participantRowHeight * 4 +
        themeConfig.thirdPlaceToMedalGap;
    nodeOffsets[match.id] = Offset(x, y);

    connectors.add(
      ConnectorLayoutData.singleLine(
        connectorVisualType: ConnectorVisualType.thickBorder,
        startOffset: Offset(x - 50, y - 20),
        endOffset: Offset(x, y - 20),
      ),
    );
    connectors.add(
      ConnectorLayoutData.singleLine(
        connectorVisualType: ConnectorVisualType.thickBorder,
        startOffset: Offset(x - 50, y + 20),
        endOffset: Offset(x, y + 20),
      ),
    );
    connectors.add(
      ConnectorLayoutData.singleLine(
        connectorVisualType: ConnectorVisualType.thickBorder,
        startOffset: Offset(x, y - 20),
        endOffset: Offset(x, y + 20),
      ),
    );
    connectors.add(
      ConnectorLayoutData.singleLine(
        connectorVisualType: ConnectorVisualType.thickBorder,
        startOffset: Offset(x, y),
        endOffset: Offset(x + 30, y),
      ),
    );

    final delta = dims.fontSizeDelta;
    final gNum = match.globalMatchDisplayNumber;
    MatchNumberPillLayoutData? pill;
    if (gNum != null) {
      final hw = max(
        themeConfig.matchPillMinHalfWidth,
        8.0 + themeConfig.matchPillHorizontalPadding,
      );
      final hh = max(
        themeConfig.matchPillMinHalfHeight,
        8.0 + themeConfig.matchPillVerticalPadding,
      );
      final pr = Rect.fromCenter(
        center: Offset(x - 4, y),
        width: hw * 2,
        height: hh * 2,
      );
      pill = MatchNumberPillLayoutData(
        centerOffset: Offset(x - 4, y),
        matchNumberText: '$gNum',
        pillBoundingRect: pr,
      );
    }

    PositionedTextLayoutData? winnerText;
    final winner = match.winnerId != null
        ? findParticipantById(match.winnerId, participants)
        : null;
    if (winner != null) {
      winnerText = PositionedTextLayoutData(
        textContent: participantDisplayName(winner),
        renderPosition: Offset(x + 35, y - 6),
        fontSize: computeFontSize(9, delta),
        fontWeight: FontWeight.bold,
        textColorType: TextColorType.primary,
      );
    }

    final badgeHalfSize = max(
      themeConfig.badgeMinHalfSize,
      computeFontSize(9, delta) / 2 + themeConfig.badgePadding,
    );
    matchLayouts.add(
      MatchLayoutData(
        matchId: match.id,
        matchNodeType: MatchNodeType.thirdPlaceMatchNode,
        isByeMatch: false,
        blueCornerBadgeLayout: CornerBadgeLayoutData(
          centerOffset: Offset(x + 4, y - 34),
          badgeText: 'B',
          badgeColorType: CornerBadgeColorType.blue,
          computedBadgeHalfSize: badgeHalfSize,
        ),
        redCornerBadgeLayout: CornerBadgeLayoutData(
          centerOffset: Offset(x + 4, y + 28),
          badgeText: 'R',
          badgeColorType: CornerBadgeColorType.red,
          computedBadgeHalfSize: badgeHalfSize,
        ),
        matchNumberPillLayout: pill,
        winnerNameTextLayout: winnerText,
        thirdPlaceTitleTextLayout: PositionedTextLayoutData(
          textContent: '3rd Place',
          renderPosition: Offset(x - 25, y - 34),
          fontSize: computeFontSize(9, delta),
          fontWeight: FontWeight.bold,
          isCenterAligned: true,
          textColorType: TextColorType.primary,
        ),
      ),
    );
  }

  void _computeDeLayout({
    required List<MatchEntity> matches,
    required List<ParticipantEntity> participants,
    required TieSheetLayoutDimensions dims,
    required TieSheetThemeConfig themeConfig,
    required Size canvasSize,
    required double startY,
    required String? winnersBracketId,
    required String? losersBracketId,
    required Map<String, Offset> nodeOffsets,
    required List<ParticipantRowLayoutData> participantRows,
    required List<MatchLayoutData> matchLayouts,
    required List<ConnectorLayoutData> connectors,
    required List<SectionLabelLayoutData> sectionLabels,
  }) {
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
    final wbRounds = TieSheetLayoutDimensionCalculator.maxRound(wbMatches);
    final lbRounds = TieSheetLayoutDimensionCalculator.maxRound(lbMatches);
    final wbByRound = TieSheetLayoutDimensionCalculator.groupByRound(wbMatches);
    final lbByRound = TieSheetLayoutDimensionCalculator.groupByRound(lbMatches);

    sectionLabels.add(
      _computeSectionLabel(
        'WINNERS BRACKET',
        dims.canvasMargin,
        startY,
        canvasSize.width - dims.canvasMargin * 2,
        dims,
        themeConfig,
        SectionLabelType.winnersBracket,
      ),
    );
    final wbTableTop = startY + dims.sectionLabelHeight + themeConfig.sectionLabelToTableGap;
    final wbR1 = wbByRound[1] ?? [];
    final wbNextIdx = computeParticipantListLayout(
      roundOneMatches: wbR1,
      participants: participants,
      x: dims.canvasMargin,
      startY: wbTableTop,
      dims: dims,
      themeConfig: themeConfig,
      isMirrored: false,
      nodeOffsets: nodeOffsets,
      outputRows: participantRows,
    );

    for (var r = 1; r <= wbRounds; r++) {
      final jX =
          dims.canvasMargin +
          dims.participantListTotalWidth +
          (r * dims.roundColumnWidth);
      for (final match in wbByRound[r] ?? []) {
        computeJunctionLayout(
          match: match,
          junctionX: jX,
          isMirrored: false,
          allMatches: matches,
          participants: participants,
          dims: dims,
          themeConfig: themeConfig,
          nodeOffsets: nodeOffsets,
          matchLayouts: matchLayouts,
          connectors: connectors,
          winnersBracketId: winnersBracketId,
          losersBracketId: losersBracketId,
        );
      }
    }

    final wbH = TieSheetLayoutDimensionCalculator.computeOneSidedHeight(
      roundOneMatches: wbR1,
      dimensions: dims,
    );
    final lbSectionTop = wbTableTop + wbH + dims.sectionGapHeight;
    sectionLabels.add(
      _computeSectionLabel(
        'LOSERS BRACKET',
        dims.canvasMargin,
        lbSectionTop,
        canvasSize.width - dims.canvasMargin * 2,
        dims,
        themeConfig,
        SectionLabelType.losersBracket,
      ),
    );
    final lbTableTop = lbSectionTop + dims.sectionLabelHeight + themeConfig.sectionLabelToTableGap;
    final lbR1 = lbByRound[1] ?? [];
    computeParticipantListLayout(
      roundOneMatches: lbR1,
      participants: participants,
      x: dims.canvasMargin,
      startY: lbTableTop,
      dims: dims,
      themeConfig: themeConfig,
      isMirrored: false,
      nodeOffsets: nodeOffsets,
      outputRows: participantRows,
      startIndex: wbNextIdx,
      drawTbdSlots: true,
    );

    for (var r = 1; r <= lbRounds; r++) {
      final jX =
          dims.canvasMargin +
          dims.participantListTotalWidth +
          (r * dims.roundColumnWidth);
      for (final match in lbByRound[r] ?? []) {
        computeJunctionLayout(
          match: match,
          junctionX: jX,
          isMirrored: false,
          allMatches: matches,
          participants: participants,
          dims: dims,
          themeConfig: themeConfig,
          nodeOffsets: nodeOffsets,
          matchLayouts: matchLayouts,
          connectors: connectors,
          winnersBracketId: winnersBracketId,
          losersBracketId: losersBracketId,
        );
      }
    }

    if (gfMatches.isNotEmpty) {
      final gfX =
          dims.canvasMargin +
          dims.participantListTotalWidth +
          (max(wbRounds, lbRounds) * dims.roundColumnWidth) +
          dims.roundColumnWidth;
      _computeGrandFinalLayout(
        gfMatches,
        wbMatches,
        lbMatches,
        wbRounds,
        lbRounds,
        gfX,
        wbTableTop,
        wbH,
        matches,
        participants,
        dims,
        themeConfig,
        nodeOffsets,
        matchLayouts,
        connectors,
      );
    }
  }

  void _computeGrandFinalLayout(
    List<MatchEntity> gfMatches,
    List<MatchEntity> wbMatches,
    List<MatchEntity> lbMatches,
    int wbRounds,
    int lbRounds,
    double gfX,
    double wbTableTop,
    double wbH,
    List<MatchEntity> allMatches,
    List<ParticipantEntity> participants,
    TieSheetLayoutDimensions dims,
    TieSheetThemeConfig themeConfig,
    Map<String, Offset> nodeOffsets,
    List<MatchLayoutData> matchLayouts,
    List<ConnectorLayoutData> connectors,
  ) {
    final gf1 = gfMatches.first;
    final wbFinal = wbMatches
        .where((m) => m.roundNumber == wbRounds)
        .firstOrNull;
    final lbFinal = lbMatches
        .where((m) => m.roundNumber == lbRounds)
        .firstOrNull;
    final wbChampOffset = wbFinal != null
        ? nodeOffsets['${wbFinal.id}_output']
        : null;
    final lbChampOffset = lbFinal != null
        ? nodeOffsets['${lbFinal.id}_output']
        : null;
    final gfTopY = wbChampOffset?.dy ?? (wbTableTop + wbH / 2);
    final gfBotY = lbChampOffset?.dy ?? (gfTopY + 80);
    final gfMidY = (gfTopY + gfBotY) / 2;

    nodeOffsets['${gf1.id}_output'] = Offset(gfX, gfMidY);
    if (wbChampOffset != null) {
      nodeOffsets['${gf1.id}_top_input'] = wbChampOffset;
    }
    if (lbChampOffset != null) {
      nodeOffsets['${gf1.id}_bot_input'] = lbChampOffset;
    }

    _computeGrandFinalNode(
      gf1,
      gfX,
      gfTopY,
      gfBotY,
      'GRAND FINAL',
      true,
      allMatches,
      participants,
      dims,
      themeConfig,
      nodeOffsets,
      matchLayouts,
      connectors,
    );

    if (gfMatches.length > 1) {
      final gf2 = gfMatches[1];
      final resetX = gfX + dims.roundColumnWidth;
      nodeOffsets['${gf2.id}_output'] = Offset(resetX, gfMidY);
      final gfOutType = gf1.winnerId != null
          ? ConnectorVisualType.wonAdvancement
          : ConnectorVisualType.pendingAdvancement;
      connectors.add(
        ConnectorLayoutData.singleLine(
          connectorVisualType: gfOutType,
          startOffset: Offset(gfX + 40, gfMidY),
          endOffset: Offset(resetX, gfMidY),
        ),
      );
      _computeGrandFinalNode(
        gf2,
        resetX,
        gfMidY - 25,
        gfMidY + 25,
        'RESET',
        false,
        allMatches,
        participants,
        dims,
        themeConfig,
        nodeOffsets,
        matchLayouts,
        connectors,
      );
    }
  }

  void _computeGrandFinalNode(
    MatchEntity match,
    double x,
    double topY,
    double botY,
    String label,
    bool drawInputs,
    List<MatchEntity> allMatches,
    List<ParticipantEntity> participants,
    TieSheetLayoutDimensions dims,
    TieSheetThemeConfig themeConfig,
    Map<String, Offset> nodeOffsets,
    List<MatchLayoutData> matchLayouts,
    List<ConnectorLayoutData> connectors,
  ) {
    final midY = (topY + botY) / 2;
    connectors.add(
      ConnectorLayoutData.singleLine(
        connectorVisualType: ConnectorVisualType.thickBorder,
        startOffset: Offset(x, topY),
        endOffset: Offset(x, botY),
      ),
    );

    if (drawInputs) {
      final topIn = resolveInputOffset(
        match: match,
        isTopSlot: true,
        allMatches: allMatches,
        nodeOffsets: nodeOffsets,
      );
      final botIn = resolveInputOffset(
        match: match,
        isTopSlot: false,
        allMatches: allMatches,
        nodeOffsets: nodeOffsets,
      );
      if (topIn != null) {
        final topType = match.participantBlueId != null
            ? ConnectorVisualType.wonAdvancement
            : ConnectorVisualType.pendingAdvancement;
        connectors.add(
          ConnectorLayoutData.singleLine(
            connectorVisualType: topType,
            startOffset: topIn,
            endOffset: Offset(x, topY),
          ),
        );
      }
      if (botIn != null) {
        final botType = match.participantRedId != null
            ? ConnectorVisualType.wonAdvancement
            : ConnectorVisualType.pendingAdvancement;
        connectors.add(
          ConnectorLayoutData.singleLine(
            connectorVisualType: botType,
            startOffset: botIn,
            endOffset: Offset(x, botY),
          ),
        );
      }
    }

    final outType = match.winnerId != null
        ? ConnectorVisualType.wonAdvancement
        : ConnectorVisualType.pendingAdvancement;
    connectors.add(
      ConnectorLayoutData.singleLine(
        connectorVisualType: outType,
        startOffset: Offset(x, midY),
        endOffset: Offset(x + themeConfig.grandFinalOutputArmLength, midY),
      ),
    );

    final delta = dims.fontSizeDelta;
    final gNum = match.globalMatchDisplayNumber;
    final winner = match.winnerId != null
        ? findParticipantById(match.winnerId, participants)
        : null;
    final badgeHalfSize = max(
      themeConfig.badgeMinHalfSize,
      computeFontSize(9, delta) / 2 + themeConfig.badgePadding,
    );

    MatchNumberPillLayoutData? pill;
    if (gNum != null) {
      final hw = max(
        themeConfig.matchPillMinHalfWidth,
        8.0 + themeConfig.matchPillHorizontalPadding,
      );
      final hh = max(
        themeConfig.matchPillMinHalfHeight,
        8.0 + themeConfig.matchPillVerticalPadding,
      );
      final pr = Rect.fromCenter(
        center: Offset(x + 18, midY),
        width: hw * 2,
        height: hh * 2,
      );
      pill = MatchNumberPillLayoutData(
        centerOffset: Offset(x + 18, midY),
        matchNumberText: '$gNum',
        pillBoundingRect: pr,
      );
    }

    PositionedTextLayoutData? winnerText;
    if (winner != null) {
      winnerText = PositionedTextLayoutData(
        textContent: participantDisplayName(winner),
        renderPosition: Offset(x + 45, midY - 6),
        fontSize: computeFontSize(9, delta),
        fontWeight: FontWeight.bold,
        textColorType: TextColorType.primary,
      );
    }

    final nodeType = label == 'RESET'
        ? MatchNodeType.grandFinalResetNode
        : MatchNodeType.grandFinalNode;
    final badgeX = x + themeConfig.badgeHorizontalOffset;
    matchLayouts.add(
      MatchLayoutData(
        matchId: match.id,
        matchNodeType: nodeType,
        isByeMatch: false,
        blueCornerBadgeLayout: CornerBadgeLayoutData(
          centerOffset: Offset(
            badgeX,
            topY + themeConfig.badgeBlueVerticalOffset,
          ),
          badgeText: 'B',
          badgeColorType: CornerBadgeColorType.blue,
          computedBadgeHalfSize: badgeHalfSize,
        ),
        redCornerBadgeLayout: CornerBadgeLayoutData(
          centerOffset: Offset(
            badgeX,
            botY + themeConfig.badgeRedVerticalOffset,
          ),
          badgeText: 'R',
          badgeColorType: CornerBadgeColorType.red,
          computedBadgeHalfSize: badgeHalfSize,
        ),
        matchNumberPillLayout: pill,
        winnerNameTextLayout: winnerText,
        grandFinalLabelTextLayout: PositionedTextLayoutData(
          textContent: label,
          renderPosition: Offset(x, topY - 20),
          fontSize: computeFontSize(10, delta),
          fontWeight: FontWeight.bold,
          isCenterAligned: true,
          textColorType: TextColorType.primary,
        ),
      ),
    );
  }

  SectionLabelLayoutData _computeSectionLabel(
    String label,
    double x,
    double y,
    double width,
    TieSheetLayoutDimensions dims,
    TieSheetThemeConfig themeConfig,
    SectionLabelType type,
  ) {
    final rect = Rect.fromLTWH(x, y, width, dims.sectionLabelHeight);
    final delta = dims.fontSizeDelta;
    return SectionLabelLayoutData(
      boundingRect: rect,
      sectionLabelType: type,
      labelTextLayout: PositionedTextLayoutData(
        textContent: label,
        renderPosition: Offset(
          x + width / 2,
          computeCenteredTextY(
            y,
            dims.sectionLabelHeight,
            computeFontSize(14, delta),
          ),
        ),
        fontSize: computeFontSize(14, delta),
        fontWeight: FontWeight.bold,
        isCenterAligned: true,
        textColorType: TextColorType.sectionLabel,
      ),
    );
  }

  MedalTableLayoutData _computeMedalTableLayout({
    required Size canvasSize,
    required TieSheetLayoutDimensions dims,
    required TieSheetThemeConfig themeConfig,
    required List<MatchEntity> matches,
    required List<ParticipantEntity> participants,
    required bool isDouble,
    String? winnersBracketId,
    String? losersBracketId,
    required bool includeThirdPlaceMatch,
    List<BracketMedalPlacementEntity>? finalMedalPlacements,
  }) {
    final x = (canvasSize.width - dims.medalTableWidth) / 2;
    final y =
        canvasSize.height - dims.medalTableTotalHeight - dims.canvasMargin + themeConfig.medalTableTopPadding;
    final delta = dims.fontSizeDelta;
    final labels = ['Gold', 'Silver', '1st Bronze', '2nd Bronze'];
    final medalTypes = [
      MedalType.gold,
      MedalType.silver,
      MedalType.bronze,
      MedalType.bronze,
    ];
    final textColors = [
      TextColorType.medalGold,
      TextColorType.medalSilver,
      TextColorType.medalBronze,
      TextColorType.medalBronze,
    ];

    final resolvedPlacements =
        finalMedalPlacements ??
        _medalComputationService
            .computeRuntimeMedalPlacements(
              matches: matches,
              isDoubleElimination: isDouble,
              winnersBracketId: winnersBracketId,
              losersBracketId: losersBracketId,
              includeThirdPlaceMatch: includeThirdPlaceMatch,
            );

    final rowWinners = <int, ParticipantEntity>{};
    final usedBronzeRows = <int>{};
    for (final placement in resolvedPlacements) {
      final p = findParticipantById(placement.participantId, participants);
      if (p == null) continue;
      int? rowIndex;
      switch (placement.rankStatus) {
        case 1:
          rowIndex = 0;
        case 2:
          rowIndex = 1;
        case 3:
          if (!usedBronzeRows.contains(2)) {
            rowIndex = 2;
          } else if (!usedBronzeRows.contains(3)) {
            rowIndex = 3;
          } else {
            continue;
          }
          usedBronzeRows.add(rowIndex);
        case 4:
          if (!usedBronzeRows.contains(2)) {
            rowIndex = 2;
          } else if (!usedBronzeRows.contains(3)) {
            rowIndex = 3;
          } else {
            continue;
          }
          usedBronzeRows.add(rowIndex);
      }
      if (rowIndex != null && rowIndex <= 3) rowWinners[rowIndex] = p;
    }

    final rows = <MedalRowLayoutData>[];
    for (var row = 0; row < 4; row++) {
      final rY = y + row * (dims.medalRowHeight + themeConfig.medalRowGap);
      final fullRect = Rect.fromLTRB(
        x + dims.medalBlankColumnWidth,
        rY,
        x + dims.medalTableWidth,
        rY + dims.medalRowHeight,
      );
      final nameRect = Rect.fromLTRB(
        x + dims.medalBlankColumnWidth,
        rY,
        x + dims.medalBlankColumnWidth + dims.medalNameColumnWidth,
        rY + dims.medalRowHeight,
      );
      final labelRect = Rect.fromLTRB(
        x + dims.medalBlankColumnWidth + dims.medalNameColumnWidth,
        rY,
        x + dims.medalTableWidth,
        rY + dims.medalRowHeight,
      );
      final accentRect = Rect.fromLTRB(
        x + dims.medalBlankColumnWidth,
        rY,
        x + dims.medalBlankColumnWidth + themeConfig.accentStripWidth,
        rY + dims.medalRowHeight,
      );
      final divider = LineSegmentLayoutData(
        startOffset: Offset(
          x + dims.medalBlankColumnWidth + dims.medalNameColumnWidth,
          rY,
        ),
        endOffset: Offset(
          x + dims.medalBlankColumnWidth + dims.medalNameColumnWidth,
          rY + dims.medalRowHeight,
        ),
      );
      final labelX =
          x +
          dims.medalBlankColumnWidth +
          dims.medalNameColumnWidth +
          dims.medalLabelColumnWidth / 2;
      final labelText = PositionedTextLayoutData(
        textContent: labels[row],
        renderPosition: Offset(
          labelX,
          computeCenteredTextY(
            rY,
            dims.medalRowHeight,
            computeFontSize(12, delta),
          ),
        ),
        fontSize: computeFontSize(12, delta),
        fontWeight: FontWeight.bold,
        isCenterAligned: true,
        textColorType: textColors[row],
      );

      PositionedTextLayoutData? winnerText;
      if (rowWinners.containsKey(row)) {
        winnerText = PositionedTextLayoutData(
          textContent: participantDisplayName(rowWinners[row]!),
          renderPosition: Offset(
            x + dims.medalBlankColumnWidth + 14,
            computeCenteredTextY(
              rY,
              dims.medalRowHeight,
              computeFontSize(11, delta),
            ),
          ),
          fontSize: computeFontSize(11, delta),
          fontWeight: FontWeight.bold,
          textColorType: TextColorType.primary,
        );
      }

      rows.add(
        MedalRowLayoutData(
          medalRowIndex: row,
          fullCardBoundingRect: fullRect,
          nameAreaBoundingRect: nameRect,
          labelAreaBoundingRect: labelRect,
          accentStripBoundingRect: accentRect,
          columnDividerLine: divider,
          medalLabelTextLayout: labelText,
          winnerNameTextLayout: winnerText,
          medalType: medalTypes[row],
        ),
      );
    }
    return MedalTableLayoutData(medalRowLayoutDataList: rows);
  }
}

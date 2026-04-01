import 'dart:math';

import 'package:tkd_saas/features/bracket/domain/layout/models/tie_sheet_layout_result.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';

/// Computes all cached dimensional tokens and canvas sizes from a
/// [TieSheetThemeConfig] for use by [TieSheetLayoutEngine].
///
/// This is a pure-Dart utility with zero Flutter/UI dependencies.
class TieSheetLayoutDimensionCalculator {
  const TieSheetLayoutDimensionCalculator._();

  /// Builds [TieSheetLayoutDimensions] from the given theme config.
  static TieSheetLayoutDimensions computeDimensions(
    TieSheetThemeConfig themeConfig, {
    required bool hasLogos,
  }) {
    final delta = themeConfig.fontSizeDelta;
    final rowH = themeConfig.rowHeight + delta * 2.0;
    final noColW = themeConfig.numberColumnWidth + delta * 1.0;
    final nameColW = themeConfig.nameColumnWidth + delta * 3.0;
    final regIdColW = themeConfig.registrationIdColumnWidth + delta * 2.0;
    final listW = noColW + nameColW + regIdColW;
    final medalTableW = themeConfig.medalTableWidth + delta * 4.0;
    final medalNameW = themeConfig.medalNameColumnWidth + delta * 2.5;
    final medalLabelW = themeConfig.medalLabelColumnWidth + delta * 1.5;
    final medalRowH = themeConfig.medalRowHeight + delta * 2.0;

    return TieSheetLayoutDimensions(
      participantRowHeight: rowH,
      intraMatchGapHeight: themeConfig.intraMatchGapHeight + delta * 1.0,
      interMatchGapHeight: themeConfig.interMatchGapHeight + delta * 2.0,
      serialNumberColumnWidth: noColW,
      participantNameColumnWidth: nameColW,
      registrationIdColumnWidth: regIdColW,
      roundColumnWidth: themeConfig.roundColumnWidth + delta * 2.0,
      headerTotalHeight: themeConfig.headerTotalHeight + delta * 2.0,
      headerBannerHeight: themeConfig.headerBannerHeight + delta * 2.0,
      subHeaderRowHeight: themeConfig.subHeaderRowHeight + delta * 2.0,
      medalTableTotalHeight: (4 * medalRowH) + 30.0,
      centerGapWidth: themeConfig.centerGapWidth + delta * 4.0,
      sectionLabelHeight: themeConfig.sectionLabelHeight + delta * 1.0,
      participantListTotalWidth: listW,
      canvasMargin: themeConfig.canvasMargin,
      sectionGapHeight: themeConfig.sectionGapHeight,
      logoRowHeight: hasLogos ? themeConfig.logoRowHeight : 0.0,
      medalTableWidth: medalTableW,
      medalRowHeight: medalRowH,
      medalNameColumnWidth: medalNameW,
      medalLabelColumnWidth: medalLabelW,
      medalBlankColumnWidth: medalTableW - medalNameW - medalLabelW,
      fontSizeDelta: delta,
    );
  }

  /// Computes the pixel height consumed by a one-sided R1 participant table.
  static double computeOneSidedHeight({
    required List<MatchEntity> roundOneMatches,
    required TieSheetLayoutDimensions dimensions,
    bool drawTbdSlots = false,
  }) {
    double height = 0;
    for (var i = 0; i < roundOneMatches.length; i++) {
      final match = roundOneMatches[i];
      final hasBlue = match.participantBlueId != null || drawTbdSlots;
      final hasRed = match.participantRedId != null || drawTbdSlots;
      final rowCount = (hasBlue ? 1 : 0) + (hasRed ? 1 : 0);
      height += rowCount * dimensions.participantRowHeight;
      if (rowCount == 2) height += dimensions.intraMatchGapHeight;
      if (i < roundOneMatches.length - 1) height += dimensions.interMatchGapHeight;
    }
    return height;
  }

  /// Returns the maximum round number from a list of matches.
  static int maxRound(List<MatchEntity> matches) {
    if (matches.isEmpty) return 1;
    return matches.map((m) => m.roundNumber).reduce(max);
  }

  /// Groups matches by round number, sorting each group by matchNumberInRound.
  static Map<int, List<MatchEntity>> groupByRound(List<MatchEntity> matches) {
    final map = <int, List<MatchEntity>>{};
    for (var m in matches) {
      map.putIfAbsent(m.roundNumber, () => []).add(m);
    }
    for (var l in map.values) {
      l.sort((a, b) => a.matchNumberInRound.compareTo(b.matchNumberInRound));
    }
    return map;
  }
}

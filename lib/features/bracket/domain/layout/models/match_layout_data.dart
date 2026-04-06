import 'dart:ui' show Offset, Rect;

import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';

/// Precomputed layout data for a match junction node.
///
/// A junction is the visual point where two feeder connector lines meet to
/// produce a winner output. The engine computes all decoration positions so
/// the renderer can draw badges, pills, winner text, and labels without
/// any logic.
///
/// Different [matchNodeType] values produce different visual structures:
/// - [MatchNodeType.standardJunction] — two straight-line arms + vertical trunk
/// - [MatchNodeType.centerFinalJunction] — center-positioned SE final
/// - [MatchNodeType.grandFinalNode] — DE grand final vertical bar
/// - [MatchNodeType.grandFinalResetNode] — DE grand final reset match
/// - [MatchNodeType.thirdPlaceMatchNode] — SE third-place match
class MatchLayoutData {
  const MatchLayoutData({
    required this.matchId,
    required this.matchNodeType,
    required this.isByeMatch,
    this.blueCornerBadgeLayout,
    this.redCornerBadgeLayout,
    this.matchNumberPillLayout,
    this.winnerNameTextLayout,
    this.missingTopInputLabelLayout,
    this.missingBottomInputLabelLayout,
    this.thirdPlaceTitleTextLayout,
    this.grandFinalLabelTextLayout,
  });

  final String matchId;

  final MatchNodeType matchNodeType;

  final bool isByeMatch;

  final CornerBadgeLayoutData? blueCornerBadgeLayout;

  final CornerBadgeLayoutData? redCornerBadgeLayout;

  final MatchNumberPillLayoutData? matchNumberPillLayout;

  final PositionedTextLayoutData? winnerNameTextLayout;

  /// Used in DE losers bracket when a drop-in match slot is pending.
  final PositionedTextLayoutData? missingTopInputLabelLayout;

  final PositionedTextLayoutData? missingBottomInputLabelLayout;

  /// Only for [MatchNodeType.thirdPlaceMatchNode].
  final PositionedTextLayoutData? thirdPlaceTitleTextLayout;

  /// Only for grand final node types.
  final PositionedTextLayoutData? grandFinalLabelTextLayout;
}

/// Classifies the visual structure of a match node for the renderer.
enum MatchNodeType {
  /// Standard two-arm junction with straight lines and a vertical trunk.
  standardJunction,

  /// Center-positioned SE final junction (both arms come from opposite sides).
  centerFinalJunction,

  /// DE Grand Final — vertical bar connecting WB champion and LB champion.
  grandFinalNode,

  /// DE Grand Final Reset — optional second grand final match.
  grandFinalResetNode,

  /// SE third-place match — small junction below the main final.
  thirdPlaceMatchNode,
}

/// Layout data for a small square corner badge ("B" for blue, "R" for red).
///
/// Badges are drawn as filled squares with centered text.
class CornerBadgeLayoutData {
  const CornerBadgeLayoutData({
    required this.centerOffset,
    required this.badgeText,
    required this.badgeColorType,
    required this.computedBadgeHalfSize,
  });

  final Offset centerOffset;

  final String badgeText;

  /// Semantic color type — the renderer resolves this against the theme.
  final CornerBadgeColorType badgeColorType;

  final double computedBadgeHalfSize;
}

enum CornerBadgeColorType {
  /// [TieSheetThemeConfig.blueCornerColor]
  blue,

  /// [TieSheetThemeConfig.redCornerColor]
  red,
}

/// Layout data for the match-number pill displayed at a junction.
///
/// The pill is drawn as a filled rectangle with centered text showing
/// the global match number.
class MatchNumberPillLayoutData {
  const MatchNumberPillLayoutData({
    required this.centerOffset,
    required this.matchNumberText,
    required this.pillBoundingRect,
  });

  final Offset centerOffset;

  final String matchNumberText;

  final Rect pillBoundingRect;
}

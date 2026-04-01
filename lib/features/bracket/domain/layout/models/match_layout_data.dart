import 'dart:ui' show Offset, Rect;

import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';

// ══════════════════════════════════════════════════════════════════════════════
// MATCH LAYOUT DATA
// ══════════════════════════════════════════════════════════════════════════════

/// Precomputed layout data for a match junction node.
///
/// A junction is the visual point where two feeder connector lines meet to
/// produce a winner output. The engine computes all decoration positions so
/// the renderer can draw badges, pills, winner text, and labels without
/// any logic.
///
/// Different [matchNodeType] values produce different visual structures:
/// - [MatchNodeType.standardJunction] — two bezier arms + vertical trunk
/// - [MatchNodeType.centerFinalJunction] — center-positioned SE final
/// - [MatchNodeType.grandFinalNode] — DE grand final vertical bar
/// - [MatchNodeType.grandFinalResetNode] — DE grand final reset match
/// - [MatchNodeType.thirdPlaceMatchNode] — SE third-place match
class MatchLayoutData {
  /// Creates layout data for a match junction node.
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

  /// The unique match ID, used for identification.
  final String matchId;

  /// The visual type of this match node.
  final MatchNodeType matchNodeType;

  /// Whether this match is a BYE (automatic advancement without playing).
  final bool isByeMatch;

  /// Blue corner badge ("B") position and color — `null` for BYE matches.
  final CornerBadgeLayoutData? blueCornerBadgeLayout;

  /// Red corner badge ("R") position and color — `null` for BYE matches.
  final CornerBadgeLayoutData? redCornerBadgeLayout;

  /// Match number pill position — `null` when match has no display number.
  final MatchNumberPillLayoutData? matchNumberPillLayout;

  /// Winner name text position — `null` when no winner yet.
  final PositionedTextLayoutData? winnerNameTextLayout;

  /// "↑ from WB" or "↓ <name>" label for a missing top feeder input.
  ///
  /// Used in DE losers bracket when a drop-in match slot is pending.
  final PositionedTextLayoutData? missingTopInputLabelLayout;

  /// "↑ <name>" or "↑ from WB" label for a missing bottom feeder input.
  final PositionedTextLayoutData? missingBottomInputLabelLayout;

  /// "3rd Place" title label — only for [MatchNodeType.thirdPlaceMatchNode].
  final PositionedTextLayoutData? thirdPlaceTitleTextLayout;

  /// "GRAND FINAL" or "RESET" label — only for grand final node types.
  final PositionedTextLayoutData? grandFinalLabelTextLayout;
}

// ══════════════════════════════════════════════════════════════════════════════
// MATCH NODE TYPE
// ══════════════════════════════════════════════════════════════════════════════

/// Classifies the visual structure of a match node for the renderer.
enum MatchNodeType {
  /// Standard two-arm junction with bezier curves and a vertical trunk.
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

// ══════════════════════════════════════════════════════════════════════════════
// CORNER BADGE LAYOUT DATA
// ══════════════════════════════════════════════════════════════════════════════

/// Layout data for a small circular corner badge ("B" for blue, "R" for red).
///
/// Badges are drawn as filled circles with centered text.
class CornerBadgeLayoutData {
  /// Creates layout data for a corner badge.
  const CornerBadgeLayoutData({
    required this.centerOffset,
    required this.badgeText,
    required this.badgeColorType,
    required this.computedBadgeRadius,
  });

  /// Center position of the badge circle.
  final Offset centerOffset;

  /// Single-character badge label (e.g., "B" or "R").
  final String badgeText;

  /// Semantic color type — the renderer resolves this against the theme.
  final CornerBadgeColorType badgeColorType;

  /// Precomputed badge radius (depends on font size and padding from theme).
  final double computedBadgeRadius;
}

/// Identifies the corner badge color for theme resolution.
enum CornerBadgeColorType {
  /// [TieSheetThemeConfig.blueCornerColor]
  blue,

  /// [TieSheetThemeConfig.redCornerColor]
  red,
}

// ══════════════════════════════════════════════════════════════════════════════
// MATCH NUMBER PILL LAYOUT DATA
// ══════════════════════════════════════════════════════════════════════════════

/// Layout data for the rounded match-number pill displayed at a junction.
///
/// The pill is drawn as a filled rounded rectangle (capsule shape) with
/// centered text showing the global match number.
class MatchNumberPillLayoutData {
  /// Creates layout data for a match number pill.
  const MatchNumberPillLayoutData({
    required this.centerOffset,
    required this.matchNumberText,
    required this.pillBoundingRect,
    required this.pillCornerRadius,
  });

  /// Center position of the pill.
  final Offset centerOffset;

  /// Display text (e.g., "1", "2", "15").
  final String matchNumberText;

  /// Bounding rectangle of the pill shape.
  final Rect pillBoundingRect;

  /// Corner radius for the pill's rounded ends.
  final double pillCornerRadius;
}

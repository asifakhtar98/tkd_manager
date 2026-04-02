import 'dart:ui' show FontStyle, FontWeight, Offset;

/// A renderer-agnostic description of a single text element that has been
/// positioned by the [TieSheetLayoutEngine].
///
/// Both the Syncfusion PDF renderer and any future Flutter-widget renderer
/// consume this identically — the layout engine is the single source of truth
/// for where and how text appears.
///
/// The [renderPosition] semantics depend on the alignment flags:
/// - **Left-aligned** (default): [renderPosition] is the top-left corner.
/// - **Center-aligned**: [renderPosition.dx] is the horizontal center, and
///   the renderer is responsible for centering text around that X.
/// - **Right-aligned**: [renderPosition.dx] is the right edge, and
///   the renderer must draw text ending at that X.
class PositionedTextLayoutData {
  const PositionedTextLayoutData({
    required this.textContent,
    required this.renderPosition,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.isCenterAligned = false,
    this.isRightAligned = false,
    this.letterSpacing,
    this.textColorType = TextColorType.primary,
  }) : assert(
         !(isCenterAligned && isRightAligned),
         'Text cannot be both center-aligned and right-aligned.',
       );

  final String textContent;

  /// Interpretation depends on alignment flags — see class-level docs.
  final Offset renderPosition;

  /// The font size in logical pixels (before any renderer-specific scaling).
  final double fontSize;

  final FontWeight fontWeight;

  final FontStyle fontStyle;

  /// Whether the text should be horizontally centered around [renderPosition.dx].
  final bool isCenterAligned;

  /// Whether the text should be right-aligned to [renderPosition.dx].
  final bool isRightAligned;

  final double? letterSpacing;

  /// Semantic color type — the renderer resolves this against the active theme.
  ///
  /// This avoids storing Flutter [Color] objects in a pure-Dart model.
  final TextColorType textColorType;
}

/// Semantic text color identifiers resolved by the renderer against the
/// active [TieSheetThemeConfig].
///
/// Storing semantic types instead of raw colors keeps the layout models
/// pure Dart (no Flutter dependency on [Color]) and allows the same layout
/// to be rendered with different themes without recomputation.
enum TextColorType {
  /// [TieSheetThemeConfig.primaryTextColor]
  primary,

  /// [TieSheetThemeConfig.secondaryTextColor]
  secondary,

  /// [TieSheetThemeConfig.mutedColor]
  muted,

  /// [TieSheetThemeConfig.headerBannerTextColor]
  headerBannerPrimary,

  /// [TieSheetThemeConfig.headerBannerTextColor] with reduced opacity
  headerBannerSecondary,

  /// [TieSheetThemeConfig.badgeTextColor]
  badgeText,

  /// [TieSheetThemeConfig.blueCornerColor]
  blueCorner,

  /// [TieSheetThemeConfig.redCornerColor]
  redCorner,

  /// [TieSheetThemeConfig.medalGoldTextColor]
  medalGold,

  /// [TieSheetThemeConfig.medalSilverTextColor]
  medalSilver,

  /// [TieSheetThemeConfig.medalBronzeTextColor]
  medalBronze,

  /// Used for DE section labels — the color is stored separately in the
  /// layout data, not derived from the theme.
  sectionLabel,
}

/// A simple geometric line segment defined by start and end [Offset]s.
///
/// Used for column dividers within participant rows, info row dividers,
/// and simple straight connector lines.
class LineSegmentLayoutData {
  const LineSegmentLayoutData({
    required this.startOffset,
    required this.endOffset,
  });

  final Offset startOffset;

  final Offset endOffset;
}

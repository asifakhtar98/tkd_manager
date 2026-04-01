import 'dart:ui' show FontStyle, FontWeight, Offset;

// ══════════════════════════════════════════════════════════════════════════════
// POSITIONED TEXT LAYOUT DATA
// ══════════════════════════════════════════════════════════════════════════════

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
  /// Creates a positioned text layout data element.
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

  /// The text string to render.
  final String textContent;

  /// The position at which this text element should be drawn.
  ///
  /// Interpretation depends on alignment flags — see class-level docs.
  final Offset renderPosition;

  /// The font size in logical pixels (before any renderer-specific scaling).
  final double fontSize;

  /// The font weight (e.g., [FontWeight.bold], [FontWeight.normal]).
  final FontWeight fontWeight;

  /// The font style (e.g., [FontStyle.normal], [FontStyle.italic]).
  final FontStyle fontStyle;

  /// Whether the text should be horizontally centered around [renderPosition.dx].
  final bool isCenterAligned;

  /// Whether the text should be right-aligned to [renderPosition.dx].
  final bool isRightAligned;

  /// Optional letter spacing value for the text.
  final double? letterSpacing;

  /// Semantic color type — the renderer resolves this against the active theme.
  ///
  /// This avoids storing Flutter [Color] objects in a pure-Dart model.
  final TextColorType textColorType;
}

// ══════════════════════════════════════════════════════════════════════════════
// TEXT COLOR TYPE
// ══════════════════════════════════════════════════════════════════════════════

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

// ══════════════════════════════════════════════════════════════════════════════
// LINE SEGMENT LAYOUT DATA
// ══════════════════════════════════════════════════════════════════════════════

/// A simple geometric line segment defined by start and end [Offset]s.
///
/// Used for column dividers within participant rows, info row dividers,
/// and simple straight connector lines.
class LineSegmentLayoutData {
  /// Creates a line segment between [startOffset] and [endOffset].
  const LineSegmentLayoutData({
    required this.startOffset,
    required this.endOffset,
  });

  /// The starting point of the line segment.
  final Offset startOffset;

  /// The ending point of the line segment.
  final Offset endOffset;
}

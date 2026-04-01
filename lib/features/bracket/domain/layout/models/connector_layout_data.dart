import 'dart:ui' show Offset;

import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';

// ══════════════════════════════════════════════════════════════════════════════
// CONNECTOR LAYOUT DATA
// ══════════════════════════════════════════════════════════════════════════════

/// Precomputed layout data for a single connector line or path.
///
/// Connectors are the lines and curves that connect participant rows to
/// junction nodes and junction outputs to downstream junction inputs.
///
/// The [connectorVisualType] determines the stroke style (color, width,
/// dash pattern) — the renderer resolves this against the theme.
///
/// Each connector is either:
/// - A set of straight line segments ([straightLineSegments])
/// - A bezier arc path ([arcPathData])
/// - Or both (rare — e.g., a combined connector).
class ConnectorLayoutData {
  /// Creates layout data for a connector with straight segments.
  const ConnectorLayoutData.straightSegments({
    required this.connectorVisualType,
    required List<LineSegmentLayoutData> segments,
  }) : straightLineSegments = segments,
       arcPathData = null;

  /// Creates layout data for a connector with a single straight line.
  ConnectorLayoutData.singleLine({
    required this.connectorVisualType,
    required Offset startOffset,
    required Offset endOffset,
  }) : straightLineSegments = [
         LineSegmentLayoutData(
           startOffset: startOffset,
           endOffset: endOffset,
         ),
       ],
       arcPathData = null;

  /// Creates layout data for a connector with a bezier arc path.
  const ConnectorLayoutData.arcPath({
    required this.connectorVisualType,
    required ConnectorArcPathData pathData,
  }) : arcPathData = pathData,
       straightLineSegments = null;

  /// Visual type determining stroke style (color, width, dash pattern).
  final ConnectorVisualType connectorVisualType;

  /// Straight line segments for simple connectors.
  ///
  /// Used for horizontal feeder lines, vertical trunk lines, and
  /// GF output arms. Multiple segments can form a polyline.
  final List<LineSegmentLayoutData>? straightLineSegments;

  /// Curved path data for bezier junction arms.
  ///
  /// Used when a feeder line transitions from horizontal to vertical
  /// with a rounded corner (the standard junction arm shape).
  final ConnectorArcPathData? arcPathData;
}

// ══════════════════════════════════════════════════════════════════════════════
// CONNECTOR VISUAL TYPE
// ══════════════════════════════════════════════════════════════════════════════

/// Semantic type determining how a connector is visually rendered.
///
/// The renderer resolves each type against [TieSheetThemeConfig] to
/// determine the pen color, stroke width, and dash pattern.
enum ConnectorVisualType {
  /// Participant won and advanced — solid, bold stroke.
  ///
  /// Uses [TieSheetThemeConfig.connectorWonColor] and
  /// [TieSheetThemeConfig.wonConnectorStrokeWidth] (or uniform width).
  wonAdvancement,

  /// Slot is pending (participant not yet determined) — solid, thin stroke.
  ///
  /// Uses [TieSheetThemeConfig.borderColor] and
  /// [TieSheetThemeConfig.borderStrokeWidth] (or uniform width).
  pendingAdvancement,

  /// BYE advancement — dashed line (or solid thin in print/uniform mode).
  ///
  /// Uses [TieSheetThemeConfig.mutedColor] with
  /// [TieSheetThemeConfig.subtleStrokeWidth].
  byeAdvancement,

  /// Generic vertical trunk connecting top and bottom arms of a junction.
  ///
  /// Uses [TieSheetThemeConfig.mutedColor] and default border width.
  genericTrunk,

  /// Output arm of a grand final node (horizontal line exiting the junction).
  ///
  /// Color depends on winner resolution status.
  grandFinalOutputArm,

  /// Thick border-color pen used for SE 3rd-place match arms, GF vertical
  /// bar, and center final vertical trunk.
  thickBorder,
}

// ══════════════════════════════════════════════════════════════════════════════
// CONNECTOR ARC PATH DATA
// ══════════════════════════════════════════════════════════════════════════════

/// Data describing a curved junction arm path.
///
/// The arm shape is: horizontal line → 90° arc → vertical line, creating
/// the familiar bracket junction curve.
///
/// In Path terms:
/// ```
/// moveTo(moveToOffset)
/// lineTo(lineToBeforeArcOffset)         // horizontal segment
/// arcToPoint(arcEndOffset, ...)          // 90° corner
/// lineTo(lineToAfterArcOffset)          // vertical segment
/// ```
class ConnectorArcPathData {
  /// Creates arc path data for a junction arm.
  const ConnectorArcPathData({
    required this.moveToOffset,
    required this.lineToBeforeArcOffset,
    required this.arcEndOffset,
    required this.arcRadius,
    required this.isArcClockwise,
    required this.lineToAfterArcOffset,
  });

  /// Starting point of the path (the feeder input coordinate).
  final Offset moveToOffset;

  /// End of the horizontal segment where the arc begins.
  final Offset lineToBeforeArcOffset;

  /// Endpoint of the 90° arc.
  final Offset arcEndOffset;

  /// Corner radius of the arc (from [TieSheetThemeConfig.junctionCornerRadius]).
  final double arcRadius;

  /// Whether the arc sweeps clockwise.
  ///
  /// Top arms: clockwise when not mirrored.
  /// Bottom arms: clockwise when mirrored.
  final bool isArcClockwise;

  /// End of the vertical segment after the arc (the junction midpoint).
  final Offset lineToAfterArcOffset;
}

import 'dart:ui' show Offset;

import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';

/// Precomputed layout data for a single connector line or polyline.
///
/// Connectors are the lines that connect participant rows to
/// junction nodes and junction outputs to downstream junction inputs.
///
/// The [connectorVisualType] determines the stroke style (color, width,
/// dash pattern) — the renderer resolves this against the theme.
///
/// Each connector is a list of straight line segments
/// ([straightLineSegments]) that may form a polyline.
class ConnectorLayoutData {
  const ConnectorLayoutData.straightSegments({
    required this.connectorVisualType,
    required List<LineSegmentLayoutData> segments,
  }) : straightLineSegments = segments;

  ConnectorLayoutData.singleLine({
    required this.connectorVisualType,
    required Offset startOffset,
    required Offset endOffset,
  }) : straightLineSegments = [
         LineSegmentLayoutData(startOffset: startOffset, endOffset: endOffset),
       ];

  final ConnectorVisualType connectorVisualType;

  /// Used for horizontal feeder lines, vertical trunk lines, and
  /// GF output arms. Multiple segments can form a polyline.
  final List<LineSegmentLayoutData> straightLineSegments;
}

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

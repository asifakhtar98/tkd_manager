import 'dart:ui' show Offset, Rect;

import 'package:tkd_saas/features/bracket/domain/layout/models/positioned_text_layout_data.dart';

// ══════════════════════════════════════════════════════════════════════════════
// PARTICIPANT ROW LAYOUT DATA
// ══════════════════════════════════════════════════════════════════════════════

/// Precomputed layout data for a single participant row card.
///
/// Each first-round match contributes one or two participant rows (blue corner
/// on top, red corner on bottom). The layout engine produces one of these for
/// every visible participant slot — including TBD placeholder slots in
/// double-elimination losers brackets.
///
/// Layout semantics:
/// - **Non-mirrored rows** (left-side brackets): columns are ordered
///   `[serial# | name | reg-id]` with the accent strip on the left edge
///   and the connector anchor on the right edge.
/// - **Mirrored rows** (right-side brackets in SE): columns are reordered
///   `[reg-id | name | serial#]` with the accent strip on the right edge
///   and the connector anchor on the left edge.
class ParticipantRowLayoutData {
  /// Creates layout data for a single participant row.
  const ParticipantRowLayoutData({
    required this.matchId,
    required this.slotPosition,
    this.participantId,
    required this.serialNumber,
    required this.cardBoundingRect,
    required this.accentStripBoundingRect,
    required this.columnDividerLines,
    required this.serialNumberTextLayout,
    required this.participantNameTextLayout,
    this.registrationIdTextLayout,
    required this.isMirroredLayout,
    required this.isPlaceholderRow,
    required this.connectorAnchorOffset,
    required this.displayName,
    this.displayRegistrationId,
  });

  /// The ID of the match this participant row belongs to.
  final String matchId;

  /// The slot within the match — either `'blue'` (top) or `'red'` (bottom).
  final String slotPosition;

  /// The participant ID occupying this slot, or `null` for TBD placeholders.
  final String? participantId;

  /// 1-based serial number for display (e.g., seed number in the draw).
  final int serialNumber;

  /// Full bounding rectangle for the card background and border.
  ///
  /// The renderer draws a filled rounded rectangle with
  /// [TieSheetThemeConfig.rowFillColor] (or [TieSheetThemeConfig.tbdFillColor]
  /// for placeholder rows).
  final Rect cardBoundingRect;

  /// Accent strip rectangle on the leading edge of the card.
  ///
  /// Non-mirrored: left edge. Mirrored: right edge.
  /// The renderer should draw this using
  /// [TieSheetThemeConfig.participantAccentStripColor] for real participants
  /// or [TieSheetThemeConfig.mutedColor] for TBD placeholders.
  final Rect accentStripBoundingRect;

  /// Column divider line segments within the card.
  ///
  /// Typically two dividers separating serial#, name, and reg-id columns.
  final List<LineSegmentLayoutData> columnDividerLines;

  /// Serial number text element (e.g., "1", "2", "3").
  final PositionedTextLayoutData serialNumberTextLayout;

  /// Participant name text element (e.g., "JOHN DOE" or "TBD").
  final PositionedTextLayoutData participantNameTextLayout;

  /// Registration ID text element — `null` when the participant has no reg ID
  /// or for placeholder rows.
  final PositionedTextLayoutData? registrationIdTextLayout;

  /// Whether this row uses mirrored (right-side) column order.
  final bool isMirroredLayout;

  /// Whether this is a TBD placeholder row (no real participant assigned).
  final bool isPlaceholderRow;

  /// The offset where a connector line attaches to this row.
  ///
  /// Non-mirrored: right edge center. Mirrored: left edge center.
  /// Stored as `'matchId_top_input'` or `'matchId_bot_input'` in the
  /// engine's internal offset map.
  final Offset connectorAnchorOffset;

  /// The display name string (uppercased participant full name, or "TBD").
  final String displayName;

  /// The display registration ID string, or `null`.
  final String? displayRegistrationId;
}

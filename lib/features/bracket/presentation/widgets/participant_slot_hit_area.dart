import 'dart:ui';

/// Identifies a single participant slot on the bracket canvas.
///
/// Used by [TieSheetPainter] to register draggable/tappable participant
/// positions, and by the widget overlay to position drag handles and
/// drop targets in edit mode.
class ParticipantSlotHitArea {
  /// The match this slot belongs to.
  final String matchId;

  /// Which corner of the match: `'blue'` or `'red'`.
  final String slotPosition;

  /// The participant currently occupying this slot, or `null` for TBD/BYE.
  final String? participantId;

  /// The bounding rectangle of this slot on the canvas (in canvas coordinates).
  final Rect boundingRect;

  /// The serial number displayed in this row (1-based).
  final int serialNumber;

  const ParticipantSlotHitArea({
    required this.matchId,
    required this.slotPosition,
    required this.participantId,
    required this.boundingRect,
    required this.serialNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantSlotHitArea &&
          runtimeType == other.runtimeType &&
          matchId == other.matchId &&
          slotPosition == other.slotPosition;

  @override
  int get hashCode => Object.hash(matchId, slotPosition);

  @override
  String toString() =>
      'ParticipantSlotHitArea(match=$matchId, slot=$slotPosition, '
      'participant=$participantId, serial=$serialNumber)';
}

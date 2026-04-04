import 'package:flutter/material.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';

class BracketParticipantListPanel extends StatelessWidget {
  const BracketParticipantListPanel({
    super.key,
    required this.matches,
    required this.participants,
  });

  final List<MatchEntity> matches;
  final List<ParticipantEntity> participants;

  @override
  Widget build(BuildContext context) {
    final slots = _buildSlotList();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: slots.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => _buildSlotTile(context, slots[index]),
    );
  }

  List<_ParticipantSlot> _buildSlotList() {
    final slots = <_ParticipantSlot>[];
    int serial = 0;
    final sortedMatches = List<MatchEntity>.from(matches)
      ..sort((a, b) {
        final rc = a.roundNumber.compareTo(b.roundNumber);
        return rc != 0 ? rc : a.matchNumberInRound.compareTo(b.matchNumberInRound);
      });

    final roundOneMatches = sortedMatches.where((m) => m.roundNumber == 1).toList();
    for (final match in roundOneMatches) {
      if (match.participantBlueId != null) {
        serial++;
        final participant = participants.where((p) => p.id == match.participantBlueId).firstOrNull;
        slots.add(_ParticipantSlot(serial, 'blue', participant));
      }
      if (match.participantRedId != null) {
        serial++;
        final participant = participants.where((p) => p.id == match.participantRedId).firstOrNull;
        slots.add(_ParticipantSlot(serial, 'red', participant));
      }
    }
    return slots;
  }

  Widget _buildSlotTile(BuildContext context, _ParticipantSlot slot) {
    final theme = Theme.of(context);
    final cornerColor = slot.slotPosition == 'blue' ? Colors.blue : Colors.red;
    final name = slot.participant?.fullName ?? 'Empty Slot';

    return ListTile(
      leading: CircleAvatar(
        radius: 14, backgroundColor: cornerColor,
        child: Text('${slot.serialNumber}', style: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ),
      title: Text(name, style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: slot.participant == null ? theme.colorScheme.outline : null,
      )),
      subtitle: slot.participant?.registrationId != null
          ? Text('ID: ${slot.participant!.registrationId}',
              style: theme.textTheme.bodySmall)
          : null,
    );
  }
}

class _ParticipantSlot {
  _ParticipantSlot(this.serialNumber, this.slotPosition, this.participant);
  final int serialNumber;
  final String slotPosition;
  final ParticipantEntity? participant;
}

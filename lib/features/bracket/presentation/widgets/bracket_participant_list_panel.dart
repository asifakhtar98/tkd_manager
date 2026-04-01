import 'package:flutter/material.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';

/// A panel displaying all participants with edit and swap capabilities,
/// replacing the old drag-and-drop canvas interaction.
///
/// Supports inline name/registration-ID editing and participant slot swaps
/// via a tap-to-select-then-tap-to-swap two-step flow.
class BracketParticipantListPanel extends StatefulWidget {
  const BracketParticipantListPanel({
    super.key,
    required this.matches,
    required this.participants,
    required this.onSwapParticipants,
    required this.onUpdateParticipant,
    required this.isEditModeEnabled,
  });

  final List<MatchEntity> matches;
  final List<ParticipantEntity> participants;
  final void Function(String matchIdA, String slotA, String matchIdB, String slotB)
      onSwapParticipants;
  final void Function(ParticipantEntity updatedParticipant) onUpdateParticipant;
  final bool isEditModeEnabled;

  @override
  State<BracketParticipantListPanel> createState() => _BracketParticipantListPanelState();
}

class _BracketParticipantListPanelState extends State<BracketParticipantListPanel> {
  _SelectedSlot? _selectedSwapSource;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slots = _buildSlotList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isEditModeEnabled && _selectedSwapSource != null)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.swap_horiz, color: theme.colorScheme.onPrimaryContainer, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  'Select another slot to swap with "${_selectedSwapSource!.displayName}"',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer),
                )),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => setState(() => _selectedSwapSource = null),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: slots.length,
            separatorBuilder: (_, _2) => const Divider(height: 1),
            itemBuilder: (context, index) => _buildSlotTile(context, slots[index]),
          ),
        ),
      ],
    );
  }

  List<_ParticipantSlot> _buildSlotList() {
    final slots = <_ParticipantSlot>[];
    int serial = 0;
    final sortedMatches = List<MatchEntity>.from(widget.matches)
      ..sort((a, b) {
        final rc = a.roundNumber.compareTo(b.roundNumber);
        return rc != 0 ? rc : a.matchNumberInRound.compareTo(b.matchNumberInRound);
      });

    final r1Matches = sortedMatches.where((m) => m.roundNumber == 1).toList();
    for (final match in r1Matches) {
      if (match.participantBlueId != null) {
        serial++;
        final p = widget.participants.where((p) => p.id == match.participantBlueId).firstOrNull;
        slots.add(_ParticipantSlot(serial, match.id, 'blue', match.participantBlueId, p));
      }
      if (match.participantRedId != null) {
        serial++;
        final p = widget.participants.where((p) => p.id == match.participantRedId).firstOrNull;
        slots.add(_ParticipantSlot(serial, match.id, 'red', match.participantRedId, p));
      }
    }
    return slots;
  }

  Widget _buildSlotTile(BuildContext context, _ParticipantSlot slot) {
    final theme = Theme.of(context);
    final isSource = _selectedSwapSource != null &&
        _selectedSwapSource!.matchId == slot.matchId &&
        _selectedSwapSource!.slotPosition == slot.slotPosition;
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
      tileColor: isSource ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
      trailing: widget.isEditModeEnabled
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (slot.participant != null)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => _showEditDialog(context, slot),
                    tooltip: 'Edit participant',
                  ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz, size: 18),
                  onPressed: () => _handleSwapTap(slot),
                  tooltip: isSource ? 'Cancel swap' : 'Swap slot',
                ),
              ],
            )
          : null,
      onTap: widget.isEditModeEnabled && _selectedSwapSource != null && !isSource
          ? () => _performSwap(slot)
          : null,
    );
  }

  void _handleSwapTap(_ParticipantSlot slot) {
    if (_selectedSwapSource != null &&
        _selectedSwapSource!.matchId == slot.matchId &&
        _selectedSwapSource!.slotPosition == slot.slotPosition) {
      setState(() => _selectedSwapSource = null);
    } else if (_selectedSwapSource != null) {
      _performSwap(slot);
    } else {
      setState(() => _selectedSwapSource = _SelectedSlot(
        slot.matchId, slot.slotPosition,
        slot.participant?.fullName ?? 'Slot ${slot.serialNumber}',
      ));
    }
  }

  void _performSwap(_ParticipantSlot target) {
    if (_selectedSwapSource == null) return;
    widget.onSwapParticipants(
      _selectedSwapSource!.matchId, _selectedSwapSource!.slotPosition,
      target.matchId, target.slotPosition,
    );
    setState(() => _selectedSwapSource = null);
  }

  void _showEditDialog(BuildContext context, _ParticipantSlot slot) {
    if (slot.participant == null) return;
    final nameController = TextEditingController(text: slot.participant!.fullName);
    final regIdController = TextEditingController(text: slot.participant!.registrationId ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Participant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
            const SizedBox(height: 8),
            TextField(controller: regIdController, decoration: const InputDecoration(labelText: 'Registration ID')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final updated = slot.participant!.copyWith(
                fullName: nameController.text.trim(),
                registrationId: regIdController.text.trim().isEmpty ? null : regIdController.text.trim(),
              );
              widget.onUpdateParticipant(updated);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _ParticipantSlot {
  _ParticipantSlot(this.serialNumber, this.matchId, this.slotPosition, this.participantId, this.participant);
  final int serialNumber;
  final String matchId;
  final String slotPosition;
  final String? participantId;
  final ParticipantEntity? participant;
}

class _SelectedSlot {
  _SelectedSlot(this.matchId, this.slotPosition, this.displayName);
  final String matchId;
  final String slotPosition;
  final String displayName;
}

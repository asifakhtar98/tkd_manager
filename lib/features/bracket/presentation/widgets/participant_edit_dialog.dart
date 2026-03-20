import 'package:flutter/material.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

/// Result returned from [ParticipantEditDialog] with updated fields.
class ParticipantEditResult {
  const ParticipantEditResult({
    required this.updatedFullName,
    this.updatedRegistrationId,
  });

  final String updatedFullName;
  final String? updatedRegistrationId;
}

/// A dialog for editing a participant's name and registration ID.
///
/// Shows pre-filled text fields for the current values and returns
/// a [ParticipantEditResult] on confirmation, or null on cancel.
class ParticipantEditDialog extends StatefulWidget {
  const ParticipantEditDialog({
    required this.participant,
    super.key,
  });

  final ParticipantEntity participant;

  /// Shows the dialog and returns a [ParticipantEditResult] if confirmed.
  static Future<ParticipantEditResult?> show({
    required BuildContext context,
    required ParticipantEntity participant,
  }) {
    return showDialog<ParticipantEditResult>(
      context: context,
      builder: (_) => ParticipantEditDialog(participant: participant),
    );
  }

  @override
  State<ParticipantEditDialog> createState() => _ParticipantEditDialogState();
}

class _ParticipantEditDialogState extends State<ParticipantEditDialog> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _registrationIdController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.participant.fullName,
    );
    _registrationIdController = TextEditingController(
      text: widget.participant.registrationId,
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _registrationIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.edit, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Edit Participant',
            style: theme.textTheme.titleLarge,
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Current info summary ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withAlpha(80),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.participant.fullName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Full Name field ──
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.badge),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Registration ID field ──
              TextFormField(
                controller: _registrationIdController,
                decoration: const InputDecoration(
                  labelText: 'Registration ID',
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.tag),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _handleConfirm,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _handleConfirm() {
    if (!_formKey.currentState!.validate()) return;

    final trimmedFullName = _fullNameController.text.trim();
    final trimmedRegistrationId = _registrationIdController.text.trim();

    // Only return non-null registration ID if it changed.
    final registrationIdChanged =
        trimmedRegistrationId != widget.participant.registrationId;

    Navigator.of(context).pop(
      ParticipantEditResult(
        updatedFullName: trimmedFullName,
        updatedRegistrationId:
            registrationIdChanged ? trimmedRegistrationId : null,
      ),
    );
  }
}

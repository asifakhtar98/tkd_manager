import 'package:flutter/material.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:uuid/uuid.dart';

/// Modal dialog to create a new [TournamentEntity].
///
/// Shows all tournament metadata fields. Returns the completed [TournamentEntity]
/// via [Navigator.pop] when the user taps "Create", or null on cancel.
class CreateTournamentDialog extends StatefulWidget {
  const CreateTournamentDialog({super.key});

  @override
  State<CreateTournamentDialog> createState() =>
      _CreateTournamentDialogState();
}

class _CreateTournamentDialogState extends State<CreateTournamentDialog> {
  static const _uuid = Uuid();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateRangeController = TextEditingController();
  final _venueController = TextEditingController();
  final _organizerController = TextEditingController();
  final _categoryController = TextEditingController();
  final _divisionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dateRangeController.dispose();
    _venueController.dispose();
    _organizerController.dispose();
    _categoryController.dispose();
    _divisionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final tournament = TournamentEntity(
      id: _uuid.v4(),
      name: _nameController.text.trim(),
      dateRange: _dateRangeController.text.trim(),
      venue: _venueController.text.trim(),
      organizer: _organizerController.text.trim(),
      categoryLabel: _categoryController.text.trim(),
      divisionLabel: _divisionController.text.trim(),
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, tournament);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Tournament'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Tournament Name *'),
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _dateRangeController,
                  decoration: const InputDecoration(labelText: 'Date Range'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _venueController,
                  decoration: const InputDecoration(labelText: 'Venue'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _organizerController,
                  decoration: const InputDecoration(labelText: 'Organizer'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _categoryController,
                  decoration:
                      const InputDecoration(labelText: 'Category (e.g., JUNIOR)'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _divisionController,
                  decoration:
                      const InputDecoration(labelText: 'Division (e.g., BOYS)'),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Create'),
        ),
      ],
    );
  }
}

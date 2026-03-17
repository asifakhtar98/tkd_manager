import 'package:flutter/material.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:uuid/uuid.dart';

/// Modal dialog to create or edit a [TournamentEntity].
///
/// Pass [existing] to pre-fill all fields and switch the dialog into
/// "edit" mode (title → "Edit Tournament", button → "Save").
/// Returns the completed [TournamentEntity] via [Navigator.pop], or null
/// on cancel.
class CreateTournamentDialog extends StatefulWidget {
  const CreateTournamentDialog({super.key, this.existing});

  /// When non-null the dialog operates in edit mode.
  final TournamentEntity? existing;

  @override
  State<CreateTournamentDialog> createState() =>
      _CreateTournamentDialogState();
}

class _CreateTournamentDialogState extends State<CreateTournamentDialog> {
  static const _uuid = Uuid();

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dateRangeController;
  late final TextEditingController _venueController;
  late final TextEditingController _organizerController;
  late final TextEditingController _categoryController;
  late final TextEditingController _divisionController;
  late final TextEditingController _weightClassController;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existingTournament = widget.existing;
    _nameController = TextEditingController(text: existingTournament?.name ?? '');
    _dateRangeController = TextEditingController(text: existingTournament?.dateRange ?? '');
    _venueController = TextEditingController(text: existingTournament?.venue ?? '');
    _organizerController = TextEditingController(text: existingTournament?.organizer ?? '');
    _categoryController = TextEditingController(text: existingTournament?.categoryLabel ?? '');
    _divisionController = TextEditingController(text: existingTournament?.divisionLabel ?? '');
    _weightClassController = TextEditingController(text: existingTournament?.weightClassLabel ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateRangeController.dispose();
    _venueController.dispose();
    _organizerController.dispose();
    _categoryController.dispose();
    _divisionController.dispose();
    _weightClassController.dispose();
    super.dispose();
  }

  void _submitTournamentForm() {
    if (!_formKey.currentState!.validate()) return;

    final existingTournament = widget.existing;
    final tournament = TournamentEntity(
      // Preserve original id and createdAt when editing.
      id: existingTournament?.id ?? _uuid.v4(),
      name: _nameController.text.trim(),
      dateRange: _dateRangeController.text.trim(),
      venue: _venueController.text.trim(),
      organizer: _organizerController.text.trim(),
      categoryLabel: _categoryController.text.trim(),
      divisionLabel: _divisionController.text.trim(),
      weightClassLabel: _weightClassController.text.trim(),
      createdAt: existingTournament?.createdAt ?? DateTime.now(),
    );

    Navigator.pop(context, tournament);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Tournament' : 'New Tournament'),
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
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Required' : null,
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
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _weightClassController,
                  decoration:
                      const InputDecoration(labelText: 'Weight Class (e.g., UNDER 59)'),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submitTournamentForm(),
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
          onPressed: _submitTournamentForm,
          child: Text(_isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}

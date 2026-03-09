import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/tournament_info.dart';

class ParticipantEntryScreen extends StatefulWidget {
  const ParticipantEntryScreen({super.key});

  @override
  State<ParticipantEntryScreen> createState() => _ParticipantEntryScreenState();
}

class _ParticipantEntryScreenState extends State<ParticipantEntryScreen> {
  final List<ParticipantEntity> _participants = [];
  final Uuid _uuid = const Uuid();
  bool _dojangSeparation = true;
  bool _includeThirdPlaceMatch = false;
  String _format = 'Single Elimination';

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dojangController = TextEditingController();
  final _registrationIdController = TextEditingController();

  final _tournamentNameController = TextEditingController();
  final _dateRangeController = TextEditingController();
  final _venueController = TextEditingController();
  final _organizerController = TextEditingController();
  final _categoryController = TextEditingController();
  final _divisionLabelController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dojangController.dispose();
    _registrationIdController.dispose();
    _tournamentNameController.dispose();
    _dateRangeController.dispose();
    _venueController.dispose();
    _organizerController.dispose();
    _categoryController.dispose();
    _divisionLabelController.dispose();
    super.dispose();
  }

  void _addParticipant() {
    if (_firstNameController.text.trim().isEmpty) return;

    setState(() {
      _participants.add(
        ParticipantEntity(
          id: _uuid.v4(),
          divisionId: 'manual_division',
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          schoolOrDojangName: _dojangController.text.trim().isNotEmpty ? _dojangController.text.trim() : null,
          registrationId: _registrationIdController.text.trim().isNotEmpty ? _registrationIdController.text.trim() : null,
          seedNumber: _participants.length + 1,
        ),
      );
      _firstNameController.clear();
      _lastNameController.clear();
      _dojangController.clear();
      _registrationIdController.clear();
    });
  }

  void _importCsv(String csvData) {
    if (csvData.trim().isEmpty) return;
    final lines = csvData.trim().split('\n');
    setState(() {
      for (var l in lines) {
        final parts = l.split(',');
        if (parts.isNotEmpty && parts[0].trim().isNotEmpty) {
          _participants.add(
            ParticipantEntity(
              id: _uuid.v4(),
              divisionId: 'manual_division',
              firstName: parts[0].trim(),
              lastName: parts.length > 1 ? parts[1].trim() : '',
              schoolOrDojangName: parts.length > 2 && parts[2].trim().isNotEmpty ? parts[2].trim() : null,
              registrationId: parts.length > 3 && parts[3].trim().isNotEmpty ? parts[3].trim() : null,
              seedNumber: _participants.length + 1,
            ),
          );
        }
      }
    });
  }

  void _removeParticipant(int index) {
    setState(() {
      _participants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Bracket Setup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Tooltip(
              message: _participants.length < 2 ? 'Add at least 2 players to generate a bracket' : 'Generate Bracket',
              child: ElevatedButton.icon(
                icon: Icon(Icons.bolt, color: _participants.length >= 2 ? Colors.yellow : Colors.grey),
                label: const Text('GENERATE', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _participants.length >= 2 ? Colors.blueAccent : Colors.grey[800],
                  foregroundColor: _participants.length >= 2 ? Colors.white : Colors.grey,
                ),
                onPressed: _participants.length >= 2 ? () {
                  context.push('/bracket', extra: {
                    'participants': List<ParticipantEntity>.from(_participants),
                    'dojangSeparation': _dojangSeparation,
                    'format': _format,
                    'includeThirdPlaceMatch': _includeThirdPlaceMatch,
                    'tournamentInfo': TournamentInfo(
                      tournamentName: _tournamentNameController.text.trim(),
                      dateRange: _dateRangeController.text.trim(),
                      venue: _venueController.text.trim(),
                      organizer: _organizerController.text.trim(),
                      categoryLabel: _categoryController.text.trim(),
                      divisionLabel: _divisionLabelController.text.trim(),
                    ),
                  });
                } : null,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tournament Info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextField(controller: _tournamentNameController, decoration: const InputDecoration(labelText: 'Tournament Name'), textInputAction: TextInputAction.next),
                            const SizedBox(height: 8),
                            TextField(controller: _dateRangeController, decoration: const InputDecoration(labelText: 'Date Range'), textInputAction: TextInputAction.next),
                            const SizedBox(height: 8),
                            TextField(controller: _venueController, decoration: const InputDecoration(labelText: 'Venue'), textInputAction: TextInputAction.next),
                            const SizedBox(height: 8),
                            TextField(controller: _organizerController, decoration: const InputDecoration(labelText: 'Organizer'), textInputAction: TextInputAction.next),
                            const SizedBox(height: 8),
                            TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category (e.g., JUNIOR)'), textInputAction: TextInputAction.next),
                            const SizedBox(height: 8),
                            TextField(controller: _divisionLabelController, decoration: const InputDecoration(labelText: 'Division (e.g., BOYS)'), textInputAction: TextInputAction.done),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Configuration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButton<String>(
                              value: _format,
                              isExpanded: true,
                              items: ['Single Elimination', 'Double Elimination']
                                  .map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _format = val);
                              },
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text('Dojang / School Separation'),
                              subtitle: const Text('Auto-distribute teammates'),
                              value: _dojangSeparation,
                              onChanged: (val) => setState(() => _dojangSeparation = val),
                            ),
                            if (_format == 'Single Elimination') SwitchListTile(
                              title: const Text('3rd Place Match'),
                              subtitle: const Text('Bronze medal match for semi losers'),
                              value: _includeThirdPlaceMatch,
                              onChanged: (val) => setState(() => _includeThirdPlaceMatch = val),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Quick Add Player', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(labelText: 'First Name'),
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) => _addParticipant(),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(labelText: 'Last Name'),
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) => _addParticipant(),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _dojangController,
                              decoration: const InputDecoration(labelText: 'Dojang / Club (Optional)'),
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) => _addParticipant(),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _registrationIdController,
                              decoration: const InputDecoration(labelText: 'Registration ID (Optional)'),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _addParticipant(),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('Add Participant'),
                                onPressed: _addParticipant,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.paste),
                                label: const Text('Paste CSV (First,Last,Dojang,RegID)'),
                                onPressed: () async {
                                  final text = await showDialog<String>(context: context, builder: (c) {
                                    final controller = TextEditingController();
                                    return AlertDialog(
                                      title: const Text("Paste CSV"),
                                      content: TextField(controller: controller, maxLines: 5),
                                      actions: [
                                        TextButton(onPressed: ()=>Navigator.pop(c, ""), child: const Text("Cancel")),
                                        ElevatedButton(onPressed: ()=>Navigator.pop(c, controller.text), child: const Text("Import")),
                                      ]
                                    );
                                  });
                                  if (text != null && text.isNotEmpty) _importCsv(text);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('Participant Roster (${_participants.length})', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      TextButton.icon(
                        icon: const Icon(Icons.delete_sweep, color: Colors.red),
                        label: const Text('Clear All', style: TextStyle(color: Colors.red)),
                        onPressed: () => setState(() => _participants.clear()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _participants.isEmpty
                        ? const Center(child: Text('Add players to start building your bracket.', style: TextStyle(color: Colors.grey)))
                        : ReorderableListView.builder(
                            itemCount: _participants.length,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) newIndex -= 1;
                                final item = _participants.removeAt(oldIndex);
                                _participants.insert(newIndex, item);
                                for (int i = 0; i < _participants.length; i++) {
                                  _participants[i] = _participants[i].copyWith(seedNumber: i + 1);
                                }
                              });
                            },
                            itemBuilder: (context, index) {
                              final p = _participants[index];
                              return Card(
                                key: ValueKey(p.id),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(backgroundColor: Colors.blueAccent, child: Text('${index + 1}')),
                                  title: Text('${p.firstName.toUpperCase()} ${p.lastName.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text([
                                    if (p.schoolOrDojangName != null && p.schoolOrDojangName!.isNotEmpty) 'Dojang: ${p.schoolOrDojangName}',
                                    if (p.registrationId != null && p.registrationId!.isNotEmpty) 'Reg: ${p.registrationId}',
                                  ].join(' | ')),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.drag_handle, color: Colors.grey),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Colors.redAccent),
                                        onPressed: () => _removeParticipant(index),
                                      ),
                                    ]
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

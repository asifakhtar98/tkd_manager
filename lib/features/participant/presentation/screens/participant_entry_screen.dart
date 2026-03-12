import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';

/// "New Bracket" setup screen.
///
/// The tournament selector at the top lets the user:
///  - Pick any existing tournament from [TournamentBloc] → fields become read-only.
///  - Choose "+ Create New Tournament" → fields become editable.
///
/// On GENERATE, if a new tournament was created it is dispatched to [TournamentBloc],
/// then the generated bracket is saved as a [BracketSnapshot] under that tournament
/// and the user is navigated to the bracket viewer.
class ParticipantEntryScreen extends StatefulWidget {
  const ParticipantEntryScreen({super.key, this.tournamentId});

  /// When provided (e.g., navigating from a TournamentDetailScreen), this
  /// tournament is pre-selected and the fields are read-only.
  final String? tournamentId;

  @override
  State<ParticipantEntryScreen> createState() =>
      _ParticipantEntryScreenState();
}

class _ParticipantEntryScreenState extends State<ParticipantEntryScreen> {
  static const _createNewSentinel = '__CREATE_NEW__';

  final List<ParticipantEntity> _participants = [];
  final Uuid _uuid = const Uuid();
  bool _dojangSeparation = true;
  bool _includeThirdPlaceMatch = false;
  BracketFormat _selectedBracketFormat = BracketFormat.singleElimination;

  // Tournament selector state
  // null = nothing selected yet; _createNewSentinel = user chose "Create New"
  String? _selectedTournamentId;
  // Editable controllers used when creating a new tournament
  final _nameController = TextEditingController();
  final _dateRangeController = TextEditingController();
  final _venueController = TextEditingController();
  final _organizerController = TextEditingController();
  final _categoryController = TextEditingController();
  final _divisionController = TextEditingController();

  // Participant entry controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dojangController = TextEditingController();
  final _registrationIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-select when navigated from a tournament detail screen
    if (widget.tournamentId != null) {
      _selectedTournamentId = widget.tournamentId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateRangeController.dispose();
    _venueController.dispose();
    _organizerController.dispose();
    _categoryController.dispose();
    _divisionController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dojangController.dispose();
    _registrationIdController.dispose();
    super.dispose();
  }

  bool get _isCreatingNew => _selectedTournamentId == _createNewSentinel;

  TournamentEntity? _existingTournament(TournamentState state) {
    if (_selectedTournamentId == null ||
        _selectedTournamentId == _createNewSentinel) {
      return null;
    }
    return state.tournaments
        .where((tournament) => tournament.id == _selectedTournamentId)
        .firstOrNull;
  }

  /// Returns the resolved tournament to use, or null if selection is incomplete.
  TournamentEntity? _resolveTournament(TournamentState state) {
    if (_isCreatingNew) {
      final name = _nameController.text.trim();
      if (name.isEmpty) return null;
      return TournamentEntity(
        id: _uuid.v4(),
        name: name,
        dateRange: _dateRangeController.text.trim(),
        venue: _venueController.text.trim(),
        organizer: _organizerController.text.trim(),
        categoryLabel: _categoryController.text.trim(),
        divisionLabel: _divisionController.text.trim(),
        createdAt: DateTime.now(),
      );
    }
    return _existingTournament(state);
  }

  void _addParticipantFromFormFields() {
    if (_firstNameController.text.trim().isEmpty) return;
    setState(() {
      _participants.add(ParticipantEntity(
        id: _uuid.v4(),
        divisionId: 'manual_division',
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        schoolOrDojangName: _dojangController.text.trim().isNotEmpty
            ? _dojangController.text.trim()
            : null,
        registrationId: _registrationIdController.text.trim().isNotEmpty
            ? _registrationIdController.text.trim()
            : null,
        seedNumber: _participants.length + 1,
      ));
      _firstNameController.clear();
      _lastNameController.clear();
      _dojangController.clear();
      _registrationIdController.clear();
    });
  }

  void _importParticipantsFromCsvData(String csvData) {
    if (csvData.trim().isEmpty) return;
    final lines = csvData.trim().split('\n');
    setState(() {
      for (var csvLine in lines) {
        final parts = csvLine.split(',');
        if (parts.isNotEmpty && parts[0].trim().isNotEmpty) {
          _participants.add(ParticipantEntity(
            id: _uuid.v4(),
            divisionId: 'manual_division',
            firstName: parts[0].trim(),
            lastName: parts.length > 1 ? parts[1].trim() : '',
            schoolOrDojangName:
                parts.length > 2 && parts[2].trim().isNotEmpty
                    ? parts[2].trim()
                    : null,
            registrationId: parts.length > 3 && parts[3].trim().isNotEmpty
                ? parts[3].trim()
                : null,
            seedNumber: _participants.length + 1,
          ));
        }
      }
    });
  }

  void _removeParticipant(int index) =>
      setState(() => _participants.removeAt(index));

  Future<void> _handleGenerateBracketRequested(BuildContext context, TournamentState state) async {
    final bloc = context.read<TournamentBloc>();

    TournamentEntity? tournament = _resolveTournament(state);
    if (tournament == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select or create a tournament first.'),
      ));
      return;
    }

    // If user created a new tournament, persist it to the BLoC
    if (_isCreatingNew) {
      bloc.add(TournamentEvent.created(tournament));
    }

    BracketRoute(
      $extra: BracketRouteExtra(
        participants: List<ParticipantEntity>.from(_participants),
        dojangSeparation: _dojangSeparation,
        bracketFormat: _selectedBracketFormat,
        includeThirdPlaceMatch: _includeThirdPlaceMatch,
        tournament: tournament,
      ),
    ).push(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      builder: (context, state) {
        final canGenerate = _participants.length >= 2 &&
            (_selectedTournamentId != null &&
                _selectedTournamentId != _createNewSentinel
                ? true
                : _nameController.text.trim().isNotEmpty);

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
                  message: _participants.length < 2
                      ? 'Add at least 2 players to generate a bracket'
                      : 'Generate Bracket',
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.bolt,
                      color: canGenerate ? Colors.yellow : Colors.grey,
                    ),
                    label: const Text(
                      'GENERATE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          canGenerate ? Colors.blueAccent : Colors.grey[800],
                      foregroundColor:
                          canGenerate ? Colors.white : Colors.grey,
                    ),
                    onPressed: canGenerate
                        ? () => _handleGenerateBracketRequested(context, state)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          body: Row(
            children: [
              // ── LEFT PANEL: Tournament + Config ──────────────────────────
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTournamentSelector(context, state),
                        const SizedBox(height: 24),
                        _buildConfiguration(),
                        const SizedBox(height: 24),
                        _buildQuickAddPlayer(),
                      ],
                    ),
                  ),
                ),
              ),
              // ── RIGHT PANEL: Participant Roster ───────────────────────────
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildRoster(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Tournament selector section
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildTournamentSelector(
    BuildContext context,
    TournamentState state,
  ) {
    final existing = _existingTournament(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tournament',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Dropdown ────────────────────────────────────────────────
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Select or Create Tournament',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  isEmpty: _selectedTournamentId == null,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedTournamentId,
                      isExpanded: true,
                      isDense: true,
                      items: [
                        const DropdownMenuItem(
                          value: _createNewSentinel,
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline,
                                  size: 18, color: Colors.blueAccent),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  '+ Create New Tournament',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...state.tournaments.map(
                          (t) => DropdownMenuItem(
                            value: t.id,
                            child: Text(
                              t.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (v) {
                        setState(() {
                          _selectedTournamentId = v;
                          // Clear editable fields when switching away from create new
                          if (v != _createNewSentinel) {
                            _nameController.clear();
                            _dateRangeController.clear();
                            _venueController.clear();
                            _organizerController.clear();
                            _categoryController.clear();
                            _divisionController.clear();
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Fields: editable when creating new, read-only otherwise ─
                if (_isCreatingNew) ...[
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tournament Name *',
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}), // recheck canGenerate
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dateRangeController,
                    decoration:
                        const InputDecoration(labelText: 'Date Range'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _venueController,
                    decoration: const InputDecoration(labelText: 'Venue'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _organizerController,
                    decoration: const InputDecoration(labelText: 'Organizer'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category (e.g., JUNIOR)',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _divisionController,
                    decoration: const InputDecoration(
                      labelText: 'Division (e.g., BOYS)',
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ] else if (existing != null) ...[
                  _ReadOnlyField(label: 'Name', value: existing.name),
                  if (existing.dateRange.isNotEmpty)
                    _ReadOnlyField(
                      label: 'Date Range',
                      value: existing.dateRange,
                    ),
                  if (existing.venue.isNotEmpty)
                    _ReadOnlyField(label: 'Venue', value: existing.venue),
                  if (existing.organizer.isNotEmpty)
                    _ReadOnlyField(
                      label: 'Organizer',
                      value: existing.organizer,
                    ),
                  if (existing.categoryLabel.isNotEmpty)
                    _ReadOnlyField(
                      label: 'Category',
                      value: existing.categoryLabel,
                    ),
                  if (existing.divisionLabel.isNotEmpty)
                    _ReadOnlyField(
                      label: 'Division',
                      value: existing.divisionLabel,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Configuration section
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildConfiguration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Configuration',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<BracketFormat>(
                  value: _selectedBracketFormat,
                  isExpanded: true,
                  items: BracketFormat.values
                      .map(
                        (f) => DropdownMenuItem(value: f, child: Text(f.displayLabel)),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedBracketFormat = val);
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Dojang / School Separation'),
                  subtitle: const Text('Auto-distribute teammates'),
                  value: _dojangSeparation,
                  onChanged: (val) =>
                      setState(() => _dojangSeparation = val),
                ),
                if (_selectedBracketFormat == BracketFormat.singleElimination)
                  SwitchListTile(
                    title: const Text('3rd Place Match'),
                    subtitle: const Text('Bronze medal match for semi losers'),
                    value: _includeThirdPlaceMatch,
                    onChanged: (val) =>
                        setState(() => _includeThirdPlaceMatch = val),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Quick Add Player section
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildQuickAddPlayer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Add Player',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                  onSubmitted: (_) => _addParticipantFromFormFields(),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => _addParticipantFromFormFields(),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _dojangController,
                  decoration: const InputDecoration(
                    labelText: 'Dojang / Club (Optional)',
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => _addParticipantFromFormFields(),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _registrationIdController,
                  decoration: const InputDecoration(
                    labelText: 'Registration ID (Optional)',
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addParticipantFromFormFields(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Participant'),
                    onPressed: _addParticipantFromFormFields,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.paste),
                    label: const Text('Paste CSV (First,Last,Dojang,RegID)'),
                    onPressed: () async {
                      final text = await showDialog<String>(
                        context: context,
                        builder: (c) {
                          final ctrl = TextEditingController();
                          return AlertDialog(
                            title: const Text('Paste CSV'),
                            content: TextField(
                              controller: ctrl,
                              maxLines: 5,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(c, ''),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(c, ctrl.text),
                                child: const Text('Import'),
                              ),
                            ],
                          );
                        },
                      );
                      if (text != null && text.isNotEmpty) _importParticipantsFromCsvData(text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Participant roster (right panel)
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildRoster() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Participant Roster (${_participants.length})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              label: const Text(
                'Clear All',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: _participants.isEmpty
                  ? null
                  : () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Clear All Participants?'),
                          content: Text(
                            'This will remove all ${_participants.length} '
                            'participants from the roster.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(c, true),
                              child: const Text('Clear All'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        setState(() => _participants.clear());
                      }
                    },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _participants.isEmpty
              ? const Center(
                  child: Text(
                    'Add players to start building your bracket.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ReorderableListView.builder(
                  itemCount: _participants.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) newIndex -= 1;
                      final item = _participants.removeAt(oldIndex);
                      _participants.insert(newIndex, item);
                      for (int i = 0; i < _participants.length; i++) {
                        _participants[i] =
                            _participants[i].copyWith(seedNumber: i + 1);
                      }
                    });
                  },
                  itemBuilder: (context, index) {
                    final p = _participants[index];
                    return Card(
                      key: ValueKey(p.id),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          '${p.firstName.toUpperCase()} ${p.lastName.toUpperCase()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text([
                          if (p.schoolOrDojangName != null &&
                              p.schoolOrDojangName!.isNotEmpty)
                            'Dojang: ${p.schoolOrDojangName}',
                          if (p.registrationId != null &&
                              p.registrationId!.isNotEmpty)
                            'Reg: ${p.registrationId}',
                        ].join(' | ')),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.drag_handle, color: Colors.grey),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => _removeParticipant(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small helper widget for read-only info display
// ─────────────────────────────────────────────────────────────────────────────

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

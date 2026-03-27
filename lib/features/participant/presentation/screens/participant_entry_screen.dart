import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/participant_shuffle_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_classification.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';

/// "New Bracket" setup screen.
///
/// The tournament is always pre-selected — users navigate here from
/// [TournamentDetailScreen]'s "Add Bracket" FAB with a required
/// [tournamentId]. There is no inline tournament-creation flow.
class ParticipantEntryScreen extends StatefulWidget {
  const ParticipantEntryScreen({super.key, required this.tournamentId});

  /// The owning tournament — always required.
  final String tournamentId;

  @override
  State<ParticipantEntryScreen> createState() => _ParticipantEntryScreenState();
}

class _ParticipantEntryScreenState extends State<ParticipantEntryScreen> {
  // ── Constants ──────────────────────────────────────────────────────────────
  static const int _maximumFullNameLength = 100;
  static const int _maximumRegistrationIdLength = 50;
  static const int _maximumDojangNameLength = 100;
  static const int _maximumClassificationFieldLength = 100;
  static const int _minimumParticipantsForBracket = 2;

  // ── Participant roster ─────────────────────────────────────────────────────
  final List<ParticipantEntity> _participants = [];
  final Uuid _uuid = const Uuid();

  // ── Configuration state ────────────────────────────────────────────────────
  bool _isDojangSeparationEnabled = true;
  bool _isThirdPlaceMatchIncluded = false;
  BracketFormat _selectedBracketFormat = BracketFormat.singleElimination;

  // ── Bracket-level classification controllers ───────────────────────────────
  final _bracketAgeCategoryController = TextEditingController();
  final _bracketGenderController = TextEditingController();
  final _bracketWeightDivisionController = TextEditingController();

  // ── Participant quick-add form ─────────────────────────────────────────────
  final _participantFormKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _registrationIdController = TextEditingController();
  final _dojangController = TextEditingController();

  @override
  void dispose() {
    _bracketAgeCategoryController.dispose();
    _bracketGenderController.dispose();
    _bracketWeightDivisionController.dispose();
    _fullNameController.dispose();
    _registrationIdController.dispose();
    _dojangController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  TournamentEntity? _findOwningTournament(TournamentState state) {
    return state.tournaments
        .where((tournament) => tournament.id == widget.tournamentId)
        .firstOrNull;
  }

  bool get _hasEnoughParticipantsToGenerate =>
      _participants.length >= _minimumParticipantsForBracket;

  /// Returns `true` when a participant with the exact same full name (case-
  /// insensitive) already exists in the roster.
  bool _isDuplicateParticipantName(String fullName) {
    final normalizedName = fullName.trim().toLowerCase();
    return _participants
        .any((p) => p.fullName.toLowerCase() == normalizedName);
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void _addParticipantFromFormFields() {
    if (!_participantFormKey.currentState!.validate()) return;

    final fullName = _fullNameController.text.trim();
    final registrationId = _registrationIdController.text.trim();
    final dojangName = _dojangController.text.trim();

    // Check for duplicates (soft warning — does not block)
    if (_isDuplicateParticipantName(fullName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Warning: A participant named "$fullName" already exists.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange.shade800,
        ),
      );
    }

    setState(() {
      _participants.add(
        ParticipantEntity(
          id: _uuid.v4(),
          genderId: 'manual_division',
          fullName: fullName,
          registrationId:
              registrationId.isNotEmpty ? registrationId : null,
          schoolOrDojangName:
              dojangName.isNotEmpty ? dojangName : null,
          seedNumber: _participants.length + 1,
        ),
      );
      _fullNameController.clear();
      _registrationIdController.clear();
      _dojangController.clear();
    });
  }

  void _importParticipantsFromCsvData(String csvData) {
    if (csvData.trim().isEmpty) return;

    final lines = csvData.trim().split('\n');
    int importedCount = 0;
    int skippedCount = 0;

    setState(() {
      for (final csvLine in lines) {
        final trimmedLine = csvLine.trim();
        if (trimmedLine.isEmpty) {
          skippedCount++;
          continue;
        }

        final parts = trimmedLine.split(',');
        final name = parts.isNotEmpty ? parts[0].trim() : '';

        if (name.isEmpty) {
          skippedCount++;
          continue;
        }

        // CSV column order: Name, RegID, Dojang
        final registrationId =
            parts.length > 1 ? parts[1].trim() : '';
        final dojangName =
            parts.length > 2 ? parts[2].trim() : '';

        _participants.add(
          ParticipantEntity(
            id: _uuid.v4(),
            genderId: 'manual_division',
            fullName: name,
            registrationId:
                registrationId.isNotEmpty ? registrationId : null,
            schoolOrDojangName:
                dojangName.isNotEmpty ? dojangName : null,
            seedNumber: _participants.length + 1,
          ),
        );
        importedCount++;
      }
    });

    if (mounted) {
      final message = skippedCount > 0
          ? 'Imported $importedCount participant${importedCount == 1 ? '' : 's'}, '
              'skipped $skippedCount invalid row${skippedCount == 1 ? '' : 's'}.'
          : 'Imported $importedCount participant${importedCount == 1 ? '' : 's'}.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeParticipant(int index) =>
      setState(() => _participants.removeAt(index));

  Future<void> _handleGenerateBracketRequested(
    BuildContext context,
    TournamentState state,
  ) async {
    final tournament = _findOwningTournament(state);
    if (tournament == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tournament not found. Please go back and try again.'),
        ),
      );
      return;
    }

    final participants = List<ParticipantEntity>.from(_participants);
    final classification = BracketClassification(
      ageCategoryLabel: _bracketAgeCategoryController.text.trim(),
      genderLabel: _bracketGenderController.text.trim(),
      weightDivisionLabel: _bracketWeightDivisionController.text.trim(),
    );

    // ── Shuffle participants if dojang separation is enabled ──────────
    final List<ParticipantEntity> orderedParticipants;
    if (_isDojangSeparationEnabled) {
      final shuffleService = getIt<ParticipantShuffleService>();
      orderedParticipants =
          shuffleService.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: true,
      );
    } else {
      orderedParticipants = participants;
    }

    // ── Generate bracket inline ──────────────────────────────────────
    final participantIds =
        orderedParticipants.map((p) => p.id).toList();

    late final BracketResult bracketResult;
    try {
      switch (_selectedBracketFormat) {
        case BracketFormat.singleElimination:
          final generator = getIt<SingleEliminationBracketGeneratorService>();
          final result = generator.generate(
            genderId: _uuid.v4(),
            participantIds: participantIds,
            bracketId: _uuid.v4(),
            includeThirdPlaceMatch: _isThirdPlaceMatchIncluded,
          );
          bracketResult = BracketResult.singleElimination(result);
        case BracketFormat.doubleElimination:
          final generator = getIt<DoubleEliminationBracketGeneratorService>();
          final result = generator.generate(
            genderId: _uuid.v4(),
            participantIds: participantIds,
            winnersBracketId: _uuid.v4(),
            losersBracketId: _uuid.v4(),
          );
          bracketResult = BracketResult.doubleElimination(result);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bracket generation failed: $e'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
      return;
    }

    // ── Create snapshot and persist to TournamentBloc ────────────────
    final snapshotId = _uuid.v4();
    final thirdPlaceSuffix =
        _isThirdPlaceMatchIncluded ? ' + 3rd Place' : '';
    final snapshot = BracketSnapshot(
      id: snapshotId,
      label:
          '${_selectedBracketFormat.displayLabel} — '
          '${orderedParticipants.length} Players$thirdPlaceSuffix',
      format: _selectedBracketFormat,
      participantCount: orderedParticipants.length,
      includeThirdPlaceMatch: _isThirdPlaceMatchIncluded,
      dojangSeparation: _isDojangSeparationEnabled,
      classification: classification,
      generatedAt: DateTime.now(),
      participants: orderedParticipants,
      result: bracketResult,
    );

    if (!context.mounted) return;
    context.read<TournamentBloc>().add(
      TournamentBracketSnapshotAdded(
        tournamentId: tournament.id,
        snapshot: snapshot,
      ),
    );

    // ── Navigate to bracket viewer by URL ────────────────────────────
    BracketViewerRoute(
      tournamentId: tournament.id,
      snapshotId: snapshotId,
    ).go(context);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      builder: (context, state) {
        final tournament = _findOwningTournament(state);

        return Scaffold(
          appBar: AppBar(
            title: const Text('New Bracket Setup'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => TournamentDetailRoute(
                tournamentId: widget.tournamentId,
              ).go(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Tooltip(
                  message: !_hasEnoughParticipantsToGenerate
                      ? 'Add at least $_minimumParticipantsForBracket players to generate a bracket'
                      : tournament == null
                          ? 'Tournament not found'
                          : 'Generate Bracket',
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.bolt),
                    label: const Text(
                      'GENERATE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                    ),
                    onPressed:
                        _hasEnoughParticipantsToGenerate && tournament != null
                            ? () => _handleGenerateBracketRequested(
                                  context,
                                  state,
                                )
                            : null,
                  ),
                ),
              ),
            ],
          ),
          body: Row(
            children: [
              // ── LEFT PANEL: Tournament Info + Config ─────────────────────
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTournamentInfoHeader(tournament),
                        const SizedBox(height: 24),
                        _buildBracketDetailsSection(),
                        const SizedBox(height: 24),
                        _buildConfigurationSection(),
                        const SizedBox(height: 24),
                        _buildQuickAddPlayerSection(),
                      ],
                    ),
                  ),
                ),
              ),
              // ── RIGHT PANEL: Participant Roster ─────────────────────────
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildParticipantRoster(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Tournament info header (read-only)
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildTournamentInfoHeader(TournamentEntity? tournament) {
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
            child: tournament == null
                ? const Text(
                    'Tournament not found. Go back and select a valid tournament.',
                    style: TextStyle(color: Colors.red),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ReadOnlyField(
                        label: 'Name',
                        value: tournament.name,
                      ),
                      if (tournament.dateRange.isNotEmpty)
                        _ReadOnlyField(
                          label: 'Date Range',
                          value: tournament.dateRange,
                        ),
                      if (tournament.venue.isNotEmpty)
                        _ReadOnlyField(
                          label: 'Venue',
                          value: tournament.venue,
                        ),
                      if (tournament.organizer.isNotEmpty)
                        _ReadOnlyField(
                          label: 'Organizer',
                          value: tournament.organizer,
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Bracket details section (age category, gender, weight division)
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildBracketDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bracket Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _bracketAgeCategoryController,
                  decoration: const InputDecoration(
                    labelText: 'Age Category (e.g., JUNIOR, SENIOR)',
                  ),
                  maxLength: _maximumClassificationFieldLength,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _bracketGenderController,
                  decoration: const InputDecoration(
                    labelText: 'Gender (e.g., BOYS, GIRLS)',
                  ),
                  maxLength: _maximumClassificationFieldLength,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _bracketWeightDivisionController,
                  decoration: const InputDecoration(
                    labelText: 'Weight Division (e.g., UNDER 59 KG)',
                  ),
                  maxLength: _maximumClassificationFieldLength,
                  textInputAction: TextInputAction.done,
                ),
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

  Widget _buildConfigurationSection() {
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
                        (format) => DropdownMenuItem(
                          value: format,
                          child: Text(format.displayLabel),
                        ),
                      )
                      .toList(),
                  onChanged: (selectedFormat) {
                    if (selectedFormat != null) {
                      setState(
                        () => _selectedBracketFormat = selectedFormat,
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Dojang / School Separation'),
                  subtitle: const Text('Auto-distribute teammates'),
                  value: _isDojangSeparationEnabled,
                  onChanged: (isEnabled) =>
                      setState(() => _isDojangSeparationEnabled = isEnabled),
                ),
                if (_selectedBracketFormat ==
                    BracketFormat.singleElimination)
                  SwitchListTile(
                    title: const Text('3rd Place Match'),
                    subtitle:
                        const Text('Bronze medal match for semi losers'),
                    value: _isThirdPlaceMatchIncluded,
                    onChanged: (isEnabled) => setState(
                      () => _isThirdPlaceMatchIncluded = isEnabled,
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
  // Quick Add Player section
  //
  // Field order: Full Name → Registration ID → Dojang / Club
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildQuickAddPlayerSection() {
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
            child: Form(
              key: _participantFormKey,
              child: Column(
                children: [
                  // ── Full Name (required) ────────────────────────────────
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      hintText: 'Enter participant full name',
                    ),
                    maxLength: _maximumFullNameLength,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                        _maximumFullNameLength,
                      ),
                    ],
                    textInputAction: TextInputAction.next,
                    validator: _validateFullName,
                    onFieldSubmitted: (_) =>
                        _addParticipantFromFormFields(),
                  ),
                  const SizedBox(height: 8),

                  // ── Registration ID (optional) ──────────────────────────
                  TextFormField(
                    controller: _registrationIdController,
                    decoration: const InputDecoration(
                      labelText: 'Registration ID (Optional)',
                    ),
                    maxLength: _maximumRegistrationIdLength,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                        _maximumRegistrationIdLength,
                      ),
                    ],
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        _addParticipantFromFormFields(),
                  ),
                  const SizedBox(height: 8),

                  // ── Dojang / Club (optional) ────────────────────────────
                  TextFormField(
                    controller: _dojangController,
                    decoration: const InputDecoration(
                      labelText: 'Dojang / Club (Optional)',
                    ),
                    maxLength: _maximumDojangNameLength,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                        _maximumDojangNameLength,
                      ),
                    ],
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) =>
                        _addParticipantFromFormFields(),
                  ),
                  const SizedBox(height: 16),

                  // ── Add button ──────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Participant'),
                      onPressed: _addParticipantFromFormFields,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── CSV import button ───────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.paste),
                      label: const Text(
                        'Paste CSV (Name, RegID, Dojang)',
                      ),
                      onPressed: () => _showCsvImportDialog(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CSV import dialog
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _showCsvImportDialog() async {
    final csvText = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final csvController = TextEditingController();
        return AlertDialog(
          title: const Text('Paste CSV'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Format: Name, RegID, Dojang (one participant per line)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: csvController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        'John Doe, REG001, Tiger Dojang\nJane Smith, REG002, Dragon Club',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, ''),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, csvController.text),
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
    if (csvText != null && csvText.isNotEmpty) {
      _importParticipantsFromCsvData(csvText);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Validators
  // ─────────────────────────────────────────────────────────────────────────

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required.';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters.';
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Participant roster (right panel)
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildParticipantRoster() {
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
              icon: Icon(Icons.delete_sweep, color: Colors.grey.shade800),
              label: Text(
                'Clear All',
                style: TextStyle(color: Colors.grey.shade800),
              ),
              onPressed: _participants.isEmpty
                  ? null
                  : () => _confirmClearAllParticipants(),
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
                        _participants[i] = _participants[i].copyWith(
                          seedNumber: i + 1,
                        );
                      }
                    });
                  },
                  itemBuilder: (context, index) {
                    final participant = _participants[index];
                    return Card(
                      key: ValueKey(participant.id),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade800,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          participant.fullName.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          [
                            if (participant.registrationId != null &&
                                participant.registrationId!.isNotEmpty)
                              'Reg: ${participant.registrationId}',
                            if (participant.schoolOrDojangName != null &&
                                participant
                                    .schoolOrDojangName!.isNotEmpty)
                              'Dojang: ${participant.schoolOrDojangName}',
                          ].join(' | '),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.drag_handle,
                              color: Colors.grey,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.grey.shade800,
                              ),
                              onPressed: () =>
                                  _removeParticipant(index),
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

  // ─────────────────────────────────────────────────────────────────────────
  // Clear-all confirmation
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _confirmClearAllParticipants() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear All Participants?'),
        content: Text(
          'This will remove all ${_participants.length} '
          'participants from the roster.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _participants.clear());
    }
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

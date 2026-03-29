import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/participant_shuffle_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/setup_bracket/presentation/bloc/setup_bracket_bloc.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_classification.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/core/utils/app_overlays.dart';
import 'package:uuid/uuid.dart';

/// Bracket setup screen — the entry point for configuring and generating
/// a new bracket for a given tournament.
///
/// All session state (participants, format, classification, config) is owned by
/// [SetupBracketBloc], which persists it via [HydratedBloc] so that work is
/// not lost on accidental navigation or page refresh during a long event.
///
/// The screen itself only holds [TextEditingController]s, which are ephemeral
/// UI concerns not worth persisting.
class SetupBracketScreen extends StatefulWidget {
  const SetupBracketScreen({super.key, required this.tournamentId});

  /// The owning tournament — always required and inherited from the route.
  final String tournamentId;

  @override
  State<SetupBracketScreen> createState() => _SetupBracketScreenState();
}

class _SetupBracketScreenState extends State<SetupBracketScreen> {
  // ── Constants ──────────────────────────────────────────────────────────────
  static const int _maximumFullNameLength = 100;
  static const int _maximumRegistrationIdLength = 100;
  static const int _maximumDojangNameLength = 100;
  static const int _maximumClassificationFieldLength = 100;

  // ── Generator services ────────────────────────────────────────────────────
  final Uuid _uuid = const Uuid();

  // ── Bracket-level classification controllers (ephemeral UI) ───────────────
  late final TextEditingController _bracketAgeCategoryController;
  late final TextEditingController _bracketGenderController;
  late final TextEditingController _bracketWeightDivisionController;

  // ── Participant quick-add form ─────────────────────────────────────────────
  final _participantFormKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _registrationIdController = TextEditingController();
  final _dojangController = TextEditingController();

  late final SetupBracketBloc _setupBracketBloc;

  @override
  void initState() {
    super.initState();
    _setupBracketBloc = context.read<SetupBracketBloc>();
    // Seed controllers from persisted bloc state so they show restored values.
    final persistedState = _setupBracketBloc.state;
    _bracketAgeCategoryController = TextEditingController(
      text: persistedState.bracketAgeCategoryLabel,
    );
    _bracketGenderController = TextEditingController(
      text: persistedState.bracketGenderLabel,
    );
    _bracketWeightDivisionController = TextEditingController(
      text: persistedState.bracketWeightDivisionLabel,
    );
  }

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

  TournamentEntity? _findOwningTournament(TournamentState tournamentState) {
    return tournamentState.tournaments
        .where((tournament) => tournament.id == widget.tournamentId)
        .firstOrNull;
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void _submitParticipantFromFormFields(SetupBracketState setupState) {
    if (!_participantFormKey.currentState!.validate()) return;

    final fullName = _fullNameController.text.trim();

    if (setupState.isDuplicateParticipantName(fullName)) {
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

    _setupBracketBloc.add(
      SetupBracketEvent.participantAdded(
        fullName: fullName,
        registrationId: _registrationIdController.text.trim(),
        schoolOrDojangName: _dojangController.text.trim(),
      ),
    );

    _fullNameController.clear();
    _registrationIdController.clear();
    _dojangController.clear();
  }

  void _dispatchClassificationUpdate() {
    _setupBracketBloc.add(
      SetupBracketEvent.classificationUpdated(
        ageCategoryLabel: _bracketAgeCategoryController.text.trim(),
        genderLabel: _bracketGenderController.text.trim(),
        weightDivisionLabel: _bracketWeightDivisionController.text.trim(),
      ),
    );
  }

  Future<void> _handleGenerateBracketRequested(
    BuildContext context,
    TournamentState tournamentState,
    SetupBracketState setupState,
  ) async {
    final owningTournament = _findOwningTournament(tournamentState);
    if (owningTournament == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tournament not found. Please go back and try again.'),
        ),
      );
      return;
    }

    // Sync classification from controllers to bloc state before generation.
    _dispatchClassificationUpdate();

    final participants = List<ParticipantEntity>.from(setupState.participants);
    final classification = BracketClassification(
      ageCategoryLabel: _bracketAgeCategoryController.text.trim(),
      genderLabel: _bracketGenderController.text.trim(),
      weightDivisionLabel: _bracketWeightDivisionController.text.trim(),
    );

    // ── Shuffle participants if dojang separation is enabled ──────────────
    final List<ParticipantEntity> orderedParticipants;
    if (setupState.isDojangSeparationEnabled) {
      final shuffleService = getIt<ParticipantShuffleService>();
      orderedParticipants = shuffleService.shuffleParticipantsForBracketGeneration(
        participants: participants,
        dojangSeparation: true,
      );
    } else {
      orderedParticipants = participants;
    }

    // ── Generate bracket ──────────────────────────────────────────────────
    final participantIds = orderedParticipants.map((p) => p.id).toList();
    late final BracketResult bracketResult;
    try {
      switch (setupState.selectedBracketFormat) {
        case BracketFormat.singleElimination:
          final generator = getIt<SingleEliminationBracketGeneratorService>();
          final result = generator.generate(
            genderId: _uuid.v4(),
            participantIds: participantIds,
            bracketId: _uuid.v4(),
            includeThirdPlaceMatch: setupState.isThirdPlaceMatchIncluded,
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

    // ── Create snapshot and persist to TournamentBloc ─────────────────────
    final snapshotId = _uuid.v4();
    final thirdPlaceSuffix = setupState.isThirdPlaceMatchIncluded ? ' + 3rd Place' : '';
    final snapshot = BracketSnapshot(
      id: snapshotId,
      userId: owningTournament.userId,
      tournamentId: widget.tournamentId,
      label:
          '${setupState.selectedBracketFormat.displayLabel} — '
          '${orderedParticipants.length} Players$thirdPlaceSuffix',
      format: setupState.selectedBracketFormat,
      participantCount: orderedParticipants.length,
      includeThirdPlaceMatch: setupState.isThirdPlaceMatchIncluded,
      dojangSeparation: setupState.isDojangSeparationEnabled,
      classification: classification,
      generatedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      participants: orderedParticipants,
      result: bracketResult,
    );

    if (!context.mounted) return;

    _setupBracketBloc.add(
      SetupBracketEvent.bracketGenerationDispatched(
        pendingSnapshotId: snapshotId,
      ),
    );

    AppOverlays.showLoading(context, message: 'Generating Bracket...');

    context.read<TournamentBloc>().add(
      TournamentBracketSnapshotAdded(
        tournamentId: owningTournament.id,
        snapshot: snapshot,
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TournamentBloc, TournamentState>(
      listenWhen: (previousTournamentState, currentTournamentState) {
        final pendingSnapshotId =
            context.read<SetupBracketBloc>().state.pendingSnapshotId;
        if (pendingSnapshotId == null) return false;

        final wasSnapshotAdded = currentTournamentState
            .bracketsFor(widget.tournamentId)
            .any((snapshot) => snapshot.id == pendingSnapshotId);
        if (wasSnapshotAdded) return true;
        if (previousTournamentState.isSaving && !currentTournamentState.isSaving) {
          return true;
        }
        return false;
      },
      listener: (context, tournamentState) {
        final setupBracketBloc = context.read<SetupBracketBloc>();
        final pendingSnapshotId = setupBracketBloc.state.pendingSnapshotId;
        if (pendingSnapshotId == null) return;

        final wasSnapshotAdded = tournamentState
            .bracketsFor(widget.tournamentId)
            .any((snapshot) => snapshot.id == pendingSnapshotId);

        if (wasSnapshotAdded) {
          final snapshotIdToNavigateTo = pendingSnapshotId;
          setupBracketBloc.add(
            const SetupBracketEvent.bracketGenerationSucceeded(),
          );
          AppOverlays.hideLoading(context);
          BracketViewerRoute(
            tournamentId: widget.tournamentId,
            snapshotId: snapshotIdToNavigateTo,
          ).go(context);
        } else if (!tournamentState.isSaving) {
          setupBracketBloc.add(
            const SetupBracketEvent.bracketGenerationFailed(),
          );
          AppOverlays.hideLoading(context);
          if (tournamentState.lastMutationError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Generation failed: ${tournamentState.lastMutationError}',
                ),
                backgroundColor: Colors.red.shade800,
              ),
            );
          }
        }
      },
      builder: (context, tournamentState) {
        if (tournamentState.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final owningTournament = _findOwningTournament(tournamentState);

        return BlocBuilder<SetupBracketBloc, SetupBracketState>(
          builder: (context, setupState) {
            final bool isGenerating = setupState.isAwaitingBracketGeneration ||
                tournamentState.isSaving;

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
                      message: !setupState.hasEnoughParticipantsToGenerate
                          ? 'Add at least '
                                '${SetupBracketState.minimumParticipantsRequiredForGeneration} '
                                'players to generate a bracket'
                          : owningTournament == null
                          ? 'Tournament not found'
                          : 'Generate Bracket',
                      child: ElevatedButton.icon(
                        icon: isGenerating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.bolt),
                        label: Text(
                          isGenerating ? 'GENERATING...' : 'GENERATE',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          disabledForegroundColor: Colors.grey.shade600,
                        ),
                        onPressed: setupState.hasEnoughParticipantsToGenerate &&
                                owningTournament != null &&
                                !isGenerating
                            ? () => _handleGenerateBracketRequested(
                                context,
                                tournamentState,
                                setupState,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              body: Row(
                children: [
                  // ── LEFT PANEL: Tournament Info + Configuration ───────────
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTournamentInfoHeader(owningTournament),
                            const SizedBox(height: 24),
                            _buildBracketDetailsSection(setupState),
                            const SizedBox(height: 24),
                            _buildConfigurationSection(setupState),
                            const SizedBox(height: 24),
                            _buildQuickAddPlayerSection(setupState),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ── RIGHT PANEL: Participant Roster ───────────────────────
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildParticipantRoster(setupState),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Tournament info header (read-only)
  // ──────────────────────────────────────────────────────────────────────────

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
                      if (tournament.leftLogoUrl.isNotEmpty ||
                          tournament.rightLogoUrl.isNotEmpty) ...[
                        Row(
                          children: [
                            if (tournament.leftLogoUrl.isNotEmpty)
                              _buildLogoImage(tournament.leftLogoUrl),
                            if (tournament.leftLogoUrl.isNotEmpty &&
                                tournament.rightLogoUrl.isNotEmpty)
                              const SizedBox(width: 16),
                            if (tournament.rightLogoUrl.isNotEmpty)
                              _buildLogoImage(tournament.rightLogoUrl),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      _ReadOnlyField(label: 'Name', value: tournament.name),
                      if (tournament.dateRange.isNotEmpty)
                        _ReadOnlyField(
                          label: 'Date Range',
                          value: tournament.dateRange,
                        ),
                      if (tournament.venue.isNotEmpty)
                        _ReadOnlyField(label: 'Venue', value: tournament.venue),
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

  Widget _buildLogoImage(String url) {
    return Image.network(
      url,
      width: 64,
      height: 64,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const SizedBox(
        width: 64,
        height: 64,
        child: Icon(Icons.broken_image, color: Colors.grey, size: 32),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Bracket details section (age category, gender, weight division)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildBracketDetailsSection(SetupBracketState setupState) {
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
                  decoration: const InputDecoration(labelText: 'Age Category'),
                  maxLength: _maximumClassificationFieldLength,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _dispatchClassificationUpdate(),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _bracketGenderController,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  maxLength: _maximumClassificationFieldLength,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _dispatchClassificationUpdate(),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _bracketWeightDivisionController,
                  decoration: const InputDecoration(
                    labelText: 'Weight Division',
                  ),
                  maxLength: _maximumClassificationFieldLength,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => _dispatchClassificationUpdate(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Configuration section
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildConfigurationSection(SetupBracketState setupState) {
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
                  value: setupState.selectedBracketFormat,
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
                      _setupBracketBloc.add(
                        SetupBracketEvent.bracketFormatChanged(
                          newFormat: selectedFormat,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Dojang / School Separation'),
                  subtitle: const Text('Auto-distribute teammates'),
                  value: setupState.isDojangSeparationEnabled,
                  onChanged: (isEnabled) => _setupBracketBloc.add(
                    SetupBracketEvent.dojangSeparationToggled(
                      isEnabled: isEnabled,
                    ),
                  ),
                ),
                if (setupState.selectedBracketFormat ==
                    BracketFormat.singleElimination)
                  SwitchListTile(
                    title: const Text('3rd Place Match'),
                    subtitle: const Text('Bronze medal match for semi losers'),
                    value: setupState.isThirdPlaceMatchIncluded,
                    onChanged: (isEnabled) => _setupBracketBloc.add(
                      SetupBracketEvent.thirdPlaceMatchToggled(
                        isEnabled: isEnabled,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Quick Add Player section
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildQuickAddPlayerSection(SetupBracketState setupState) {
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
                  // ── Full Name (required) ──────────────────────────────────
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      hintText: 'Enter participant full name',
                    ),
                    maxLength: _maximumFullNameLength,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(_maximumFullNameLength),
                    ],
                    textInputAction: TextInputAction.next,
                    validator: _validateFullName,
                    onFieldSubmitted: (_) =>
                        _submitParticipantFromFormFields(setupState),
                  ),
                  const SizedBox(height: 8),

                  // ── Registration ID (optional) ────────────────────────────
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
                        _submitParticipantFromFormFields(setupState),
                  ),
                  const SizedBox(height: 8),

                  // ── Dojang / Club (optional) ──────────────────────────────
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
                        _submitParticipantFromFormFields(setupState),
                  ),
                  const SizedBox(height: 16),

                  // ── Add button ────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Participant'),
                      onPressed: () =>
                          _submitParticipantFromFormFields(setupState),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── CSV import button ─────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.paste),
                      label: const Text('Paste CSV (Name, RegID, Dojang)'),
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

  // ──────────────────────────────────────────────────────────────────────────
  // CSV import dialog
  // ──────────────────────────────────────────────────────────────────────────

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
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
      final importedCountBefore = _setupBracketBloc.state.participants.length;

      _setupBracketBloc.add(
        SetupBracketEvent.participantsImportedFromCsv(csvRawText: csvText),
      );

      // Show feedback after the event propagates on the next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final importedCountAfter =
            _setupBracketBloc.state.participants.length;
        final importedCount = importedCountAfter - importedCountBefore;
        if (importedCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Imported $importedCount '
                'participant${importedCount == 1 ? '' : 's'}.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Validators
  // ──────────────────────────────────────────────────────────────────────────

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required.';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters.';
    }
    return null;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Participant roster (right panel)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildParticipantRoster(SetupBracketState setupState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Participant Roster (${setupState.participants.length})',
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
              onPressed: setupState.participants.isEmpty
                  ? null
                  : () => _confirmClearAllParticipants(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: setupState.participants.isEmpty
              ? const Center(
                  child: Text(
                    'Add players to start building your bracket.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ReorderableListView.builder(
                  itemCount: setupState.participants.length,
                  onReorder: (oldIndex, newIndex) {
                    _setupBracketBloc.add(
                      SetupBracketEvent.participantsReordered(
                        oldIndex: oldIndex,
                        newIndex: newIndex,
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                    final participant = setupState.participants[index];
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          [
                            if (participant.registrationId != null &&
                                participant.registrationId!.isNotEmpty)
                              'Reg: ${participant.registrationId}',
                            if (participant.schoolOrDojangName != null &&
                                participant.schoolOrDojangName!.isNotEmpty)
                              'Dojang: ${participant.schoolOrDojangName}',
                          ].join(' | '),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.drag_handle, color: Colors.grey),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.grey.shade800,
                              ),
                              onPressed: () => _setupBracketBloc.add(
                                SetupBracketEvent.participantRemoved(
                                  rosterIndex: index,
                                ),
                              ),
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

  // ──────────────────────────────────────────────────────────────────────────
  // Clear-all confirmation
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> _confirmClearAllParticipants() async {
    final participantCount = _setupBracketBloc.state.participants.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear All Participants?'),
        content: Text(
          'This will remove all $participantCount '
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
      _setupBracketBloc.add(const SetupBracketEvent.participantsCleared());
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
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';
import 'package:uuid/uuid.dart';

import 'setup_bracket_event.dart';
import 'setup_bracket_state.dart';

export 'setup_bracket_event.dart';
export 'setup_bracket_state.dart';

/// BLoC owning all bracket-setup session state for a single tournament.
///
/// Extends [HydratedBloc] so state is automatically persisted to browser
/// storage between page reloads and across long tournament sessions.
///
/// **Storage scoping**: each tournament gets an independent persisted bucket
/// keyed by `setup_bracket_<tournamentId>`, so concurrent setup sessions for
/// different tournaments do not interfere with each other.
///
/// Registered as a [factory] in the DI container because it is scoped to a
/// specific tournament; a new instance is created each time the bracket-setup
/// route is mounted.
@injectable
class SetupBracketBloc extends HydratedBloc<SetupBracketEvent, SetupBracketState> {
  SetupBracketBloc(
    @factoryParam String tournamentId,
    this._uuid,
  ) : super(SetupBracketState(tournamentId: tournamentId)) {
    on<SetupBracketParticipantAdded>(_onParticipantAdded);
    on<SetupBracketParticipantsImportedFromCsv>(_onParticipantsImportedFromCsv);
    on<SetupBracketParticipantRemoved>(_onParticipantRemoved);
    on<SetupBracketParticipantsCleared>(_onParticipantsCleared);
    on<SetupBracketParticipantsReordered>(_onParticipantsReordered);
    on<SetupBracketFormatChanged>(_onFormatChanged);
    on<SetupBracketDojangSeparationToggled>(_onDojangSeparationToggled);
    on<SetupBracketThirdPlaceMatchToggled>(_onThirdPlaceMatchToggled);
    on<SetupBracketClassificationUpdated>(_onClassificationUpdated);
    on<SetupBracketGenerationDispatched>(_onGenerationDispatched);
    on<SetupBracketGenerationSucceeded>(_onGenerationSucceeded);
    on<SetupBracketGenerationFailed>(_onGenerationFailed);
  }

  final Uuid _uuid;

  /// Fallback genderId used when participants are added manually (as opposed
  /// to being assigned a gender-specific division from an external system).
  static const String _manualDivisionGenderId = 'manual_division';

  // ── HydratedBloc JSON contract ───────────────────────────────────────────

  /// Per-tournament storage key — isolates persisted state per tournament.
  @override
  String get id => 'setup_bracket_${state.tournamentId}';

  @override
  SetupBracketState? fromJson(Map<String, dynamic> json) {
    try {
      return SetupBracketState.fromJson(json);
    } catch (exception, stackTrace) {
      log(
        'SetupBracketBloc: failed to restore persisted state — starting fresh.',
        error: exception,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(SetupBracketState state) {
    try {
      return state.toJson();
    } catch (exception, stackTrace) {
      log(
        'SetupBracketBloc: failed to serialize state for persistence.',
        error: exception,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // ── Event handlers — roster ──────────────────────────────────────────────

  void _onParticipantAdded(
    SetupBracketParticipantAdded event,
    Emitter<SetupBracketState> emit,
  ) {
    final newParticipant = ParticipantEntity(
      id: _uuid.v4(),
      genderId: _manualDivisionGenderId,
      fullName: event.fullName.trim(),
      registrationId: _normalizeOptionalField(event.registrationId),
      schoolOrDojangName: _normalizeOptionalField(event.schoolOrDojangName),
      seedNumber: state.participants.length + 1,
    );

    emit(
      state.copyWith(
        participants: [...state.participants, newParticipant],
      ),
    );
  }

  void _onParticipantsImportedFromCsv(
    SetupBracketParticipantsImportedFromCsv event,
    Emitter<SetupBracketState> emit,
  ) {
    if (event.csvRawText.trim().isEmpty) return;

    final csvLines = event.csvRawText.trim().split('\n');
    final importedParticipants = <ParticipantEntity>[];

    for (final csvLine in csvLines) {
      final trimmedLine = csvLine.trim();
      if (trimmedLine.isEmpty) continue;

      final parts = trimmedLine.split(',');
      final name = parts.isNotEmpty ? parts[0].trim() : '';
      if (name.isEmpty) continue;

      final registrationId = parts.length > 1 ? parts[1].trim() : '';
      final dojangName = parts.length > 2 ? parts[2].trim() : '';

      importedParticipants.add(
        ParticipantEntity(
          id: _uuid.v4(),
          genderId: _manualDivisionGenderId,
          fullName: name,
          registrationId: registrationId.isNotEmpty ? registrationId : null,
          schoolOrDojangName: dojangName.isNotEmpty ? dojangName : null,
          seedNumber: state.participants.length + importedParticipants.length + 1,
        ),
      );
    }

    if (importedParticipants.isEmpty) return;

    emit(
      state.copyWith(
        participants: [...state.participants, ...importedParticipants],
      ),
    );
  }

  void _onParticipantRemoved(
    SetupBracketParticipantRemoved event,
    Emitter<SetupBracketState> emit,
  ) {
    if (event.rosterIndex < 0 ||
        event.rosterIndex >= state.participants.length) {
      return;
    }

    final updatedParticipants = List<ParticipantEntity>.from(state.participants)
      ..removeAt(event.rosterIndex);

    emit(state.copyWith(participants: _reseedParticipants(updatedParticipants)));
  }

  void _onParticipantsCleared(
    SetupBracketParticipantsCleared event,
    Emitter<SetupBracketState> emit,
  ) {
    emit(state.copyWith(participants: []));
  }

  void _onParticipantsReordered(
    SetupBracketParticipantsReordered event,
    Emitter<SetupBracketState> emit,
  ) {
    final participantCount = state.participants.length;
    if (event.oldIndex < 0 || event.oldIndex >= participantCount) return;

    final oldIndex = event.oldIndex;
    int newIndex = event.newIndex;

    // ReorderableListView reports newIndex AFTER removal when moving downward.
    if (oldIndex < newIndex) newIndex -= 1;

    if (newIndex < 0 || newIndex >= participantCount) return;

    final reorderedParticipants = List<ParticipantEntity>.from(state.participants);
    final movedParticipant = reorderedParticipants.removeAt(oldIndex);
    reorderedParticipants.insert(newIndex, movedParticipant);

    emit(state.copyWith(participants: _reseedParticipants(reorderedParticipants)));
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  /// Reassigns sequential seed numbers (1-based) after any roster mutation.
  List<ParticipantEntity> _reseedParticipants(
    List<ParticipantEntity> participants,
  ) {
    return [
      for (var i = 0; i < participants.length; i++)
        participants[i].copyWith(seedNumber: i + 1),
    ];
  }

  /// Returns `null` for blank/whitespace-only optional strings, otherwise
  /// the trimmed value. Centralizes the nullable-field normalization pattern.
  static String? _normalizeOptionalField(String? rawValue) {
    if (rawValue == null) return null;
    final trimmed = rawValue.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  // ── Event handlers — configuration ───────────────────────────────────────

  void _onFormatChanged(
    SetupBracketFormatChanged event,
    Emitter<SetupBracketState> emit,
  ) {
    final updatedState = state.copyWith(
      selectedBracketFormat: event.newFormat,
      // Clear 3rd-place match flag if switching away from single-elimination
      // since it only applies to that format.
      isThirdPlaceMatchIncluded: event.newFormat == BracketFormat.singleElimination
          ? state.isThirdPlaceMatchIncluded
          : false,
    );
    emit(updatedState);
  }

  void _onDojangSeparationToggled(
    SetupBracketDojangSeparationToggled event,
    Emitter<SetupBracketState> emit,
  ) {
    emit(state.copyWith(isDojangSeparationEnabled: event.isEnabled));
  }

  void _onThirdPlaceMatchToggled(
    SetupBracketThirdPlaceMatchToggled event,
    Emitter<SetupBracketState> emit,
  ) {
    emit(state.copyWith(isThirdPlaceMatchIncluded: event.isEnabled));
  }

  void _onClassificationUpdated(
    SetupBracketClassificationUpdated event,
    Emitter<SetupBracketState> emit,
  ) {
    emit(
      state.copyWith(
        bracketAgeCategoryLabel: event.ageCategoryLabel,
        bracketGenderLabel: event.genderLabel,
        bracketWeightDivisionLabel: event.weightDivisionLabel,
      ),
    );
  }

  // ── Event handlers — generation lifecycle ────────────────────────────────

  void _onGenerationDispatched(
    SetupBracketGenerationDispatched event,
    Emitter<SetupBracketState> emit,
  ) {
    emit(
      state.copyWith(
        isAwaitingBracketGeneration: true,
        pendingSnapshotId: event.pendingSnapshotId,
      ),
    );
  }

  void _onGenerationSucceeded(
    SetupBracketGenerationSucceeded event,
    Emitter<SetupBracketState> emit,
  ) {
    // Reset to a fresh setup state for this tournament after a successful
    // generation so the next bracket starts clean.
    emit(
      SetupBracketState(
        tournamentId: state.tournamentId,
      ),
    );
  }

  void _onGenerationFailed(
    SetupBracketGenerationFailed event,
    Emitter<SetupBracketState> emit,
  ) {
    emit(
      state.copyWith(
        isAwaitingBracketGeneration: false,
        pendingSnapshotId: null,
      ),
    );
  }
}

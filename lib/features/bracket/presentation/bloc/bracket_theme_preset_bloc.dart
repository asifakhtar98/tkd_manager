import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_theme_preset_entity.dart';
import 'package:tkd_saas/features/bracket/domain/repositories/bracket_theme_preset_repository.dart';

import 'bracket_theme_preset_event.dart';
import 'bracket_theme_preset_state.dart';

/// Manages the lifecycle of cloud-persisted bracket theme presets.
///
/// Loads, saves, and deletes [BracketThemePresetEntity] records via
/// [BracketThemePresetRepository]. After every mutation (save/delete) the full
/// list is re-fetched to guarantee UI consistency with the server state.
@injectable
class BracketThemePresetBloc
    extends Bloc<BracketThemePresetEvent, BracketThemePresetState> {
  final BracketThemePresetRepository _repository;

  BracketThemePresetBloc(this._repository)
    : super(const BracketThemePresetState.initial()) {
    on<BracketThemePresetLoadRequested>(_onLoadRequested);
    on<BracketThemePresetSaveRequested>(_onSaveRequested);
    on<BracketThemePresetDeleteRequested>(_onDeleteRequested);
  }

  /// Extracts the current preset list from whatever state we're in,
  /// so it can be preserved across loading/error transitions.
  List<BracketThemePresetEntity> get _currentPresetList => state.maybeWhen(
    loaded: (presets) => presets,
    error: (_, previousPresets) => previousPresets,
    orElse: () => const <BracketThemePresetEntity>[],
  );

  /// Fetches all presets for the authenticated user from the cloud.
  Future<void> _onLoadRequested(
    BracketThemePresetLoadRequested event,
    Emitter<BracketThemePresetState> emit,
  ) async {
    emit(const BracketThemePresetState.loading());

    final failureOrPresets = await _repository.getThemePresetsForUser();

    emit(
      failureOrPresets.fold(
        (failure) => BracketThemePresetState.error(message: failure.message),
        (presets) => BracketThemePresetState.loaded(presets: presets),
      ),
    );
  }

  /// Persists the current theme config as a new preset, then re-fetches the
  /// full list so the UI reflects the server state.
  Future<void> _onSaveRequested(
    BracketThemePresetSaveRequested event,
    Emitter<BracketThemePresetState> emit,
  ) async {
    final preservedPresets = _currentPresetList;
    emit(const BracketThemePresetState.loading());

    final failureOrCreated = await _repository.createThemePreset(
      event.themeConfiguration,
    );

    await failureOrCreated.fold(
      (failure) async => emit(
        BracketThemePresetState.error(
          message: failure.message,
          previousPresets: preservedPresets,
        ),
      ),
      (_) async {
        final failureOrPresets = await _repository.getThemePresetsForUser();
        emit(
          failureOrPresets.fold(
            (failure) => BracketThemePresetState.error(
              message: failure.message,
              previousPresets: preservedPresets,
            ),
            (presets) => BracketThemePresetState.loaded(presets: presets),
          ),
        );
      },
    );
  }

  /// Deletes a preset by ID, then re-fetches the full list.
  Future<void> _onDeleteRequested(
    BracketThemePresetDeleteRequested event,
    Emitter<BracketThemePresetState> emit,
  ) async {
    final preservedPresets = _currentPresetList;
    emit(const BracketThemePresetState.loading());

    final failureOrDeleted = await _repository.deleteThemePreset(
      event.presetId,
    );

    await failureOrDeleted.fold(
      (failure) async => emit(
        BracketThemePresetState.error(
          message: failure.message,
          previousPresets: preservedPresets,
        ),
      ),
      (_) async {
        final failureOrPresets = await _repository.getThemePresetsForUser();
        emit(
          failureOrPresets.fold(
            (failure) => BracketThemePresetState.error(
              message: failure.message,
              previousPresets: preservedPresets,
            ),
            (presets) => BracketThemePresetState.loaded(presets: presets),
          ),
        );
      },
    );
  }
}

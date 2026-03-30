import 'dart:developer';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/bracket_theme_selection.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_selection_event.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_selection_state.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';

@injectable
class BracketThemeSelectionBloc
    extends HydratedBloc<BracketThemeSelectionEvent, BracketThemeSelectionState> {
  BracketThemeSelectionBloc()
      : super(const BracketThemeSelectionState(
          activeThemeSelection: BracketThemeSelection.defaultModeSelected(),
        )) {
    on<BracketThemeSelectionModeToggled>(_onThemeModeToggled);
    on<BracketThemeSelectionCloudPresetApplied>(_onCloudPresetApplied);
    on<BracketThemeSelectionCustomConfigUpdated>(_onCustomConfigUpdated);
    on<BracketThemeSelectionHydratedResolved>(_onHydratedSelectionResolved);
    on<BracketThemeSelectionExpiredDismissed>(_onThemeExpiredMessageDismissed);
  }

  @override
  String get id => 'bracket_theme_selection';

  void _onThemeModeToggled(
    BracketThemeSelectionModeToggled event,
    Emitter<BracketThemeSelectionState> emit,
  ) {
    switch (event.selectedMode) {
      case TieSheetThemeMode.defaultMode:
        emit(state.copyWith(
          activeThemeSelection: const BracketThemeSelection.defaultModeSelected(),
        ));
        break;
      case TieSheetThemeMode.printMode:
        emit(state.copyWith(
          activeThemeSelection: const BracketThemeSelection.printModeSelected(),
        ));
        break;
      case TieSheetThemeMode.customMode:
        // When explicitly switching to custom mode, preserve the live config
        // or fall back to default if null.
        emit(state.copyWith(
          activeThemeSelection:
              const BracketThemeSelection.customModeSelected(),
          liveCustomThemeConfiguration:
              state.liveCustomThemeConfiguration ??
                  TieSheetThemeConfig.defaultPreset,
        ));
        break;
    }
  }

  void _onCloudPresetApplied(
    BracketThemeSelectionCloudPresetApplied event,
    Emitter<BracketThemeSelectionState> emit,
  ) {
    emit(state.copyWith(
      activeThemeSelection: BracketThemeSelection.cloudPresetSelected(
        presetId: event.presetId,
      ),
      liveCustomThemeConfiguration: event.resolvedThemeConfiguration,
    ));
  }

  void _onCustomConfigUpdated(
    BracketThemeSelectionCustomConfigUpdated event,
    Emitter<BracketThemeSelectionState> emit,
  ) {
    emit(state.copyWith(
      liveCustomThemeConfiguration: event.updatedThemeConfiguration,
      // If we are modifying a cloud preset, switch to custom mode
      // so we don't accidentally overwrite the cloud preset state.
      activeThemeSelection:
          const BracketThemeSelection.customModeSelected(),
    ));
  }

  void _onHydratedSelectionResolved(
    BracketThemeSelectionHydratedResolved event,
    Emitter<BracketThemeSelectionState> emit,
  ) {
    state.activeThemeSelection.whenOrNull(
      cloudPresetSelected: (presetId) {
        final presetExists = event.availableCloudPresets.any(
          (preset) => preset.id == presetId,
        );

        if (presetExists) {
          // Preset is still available, ensure we have the latest config loaded
          final preset = event.availableCloudPresets.firstWhere(
            (preset) => preset.id == presetId,
          );
          emit(state.copyWith(
            liveCustomThemeConfiguration: preset.themeConfiguration,
          ));
        } else {
          // Preset was deleted from another device/browser.
          // Fallback to default and show expiry message.
          emit(state.copyWith(
            activeThemeSelection: const BracketThemeSelection.defaultModeSelected(),
            themeExpiredMessage:
                'Your saved cloud theme preset is no longer available. Falling back to default theme.',
          ));
        }
      },
    );
  }

  void _onThemeExpiredMessageDismissed(
    BracketThemeSelectionExpiredDismissed event,
    Emitter<BracketThemeSelectionState> emit,
  ) {
    emit(state.copyWith(themeExpiredMessage: null));
  }

  @override
  BracketThemeSelectionState? fromJson(Map<String, dynamic> json) {
    try {
      return BracketThemeSelectionState.fromJson(json);
    } catch (e, st) {
      log(
        'BracketThemeSelectionBloc: failed to restore persisted state — starting fresh.',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(BracketThemeSelectionState state) {
    return state.toJson();
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';

import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';

part 'bracket_state.freezed.dart';

@freezed
sealed class BracketState with _$BracketState {
  const factory BracketState.initial() = BracketInitial;
  const factory BracketState.generating() = BracketGenerating;
  const factory BracketState.loadSuccess({
    required BracketResult result,
    required List<ParticipantEntity> participants,
    required BracketFormat format,
    required bool includeThirdPlaceMatch,
    String? errorMessage,
    @Default([]) List<BracketHistoryEntry> actionHistory,
    @Default(-1) int historyPointer,
    @Default(false) bool isReplayInProgress,
    BracketResult? initialResult,
    List<ParticipantEntity>? initialParticipants,
    @Default(false) bool isSaving,
    @Default(false) bool hasUnsavedChanges,
    DateTime? lastSaveTimestamp,
    String? saveError,
  }) = BracketLoadSuccess;
  const factory BracketState.failure(String message) = BracketFailure;
}

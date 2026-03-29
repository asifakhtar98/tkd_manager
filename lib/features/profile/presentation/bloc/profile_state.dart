import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

/// Possible states emitted by [ProfileBloc].
@freezed
sealed class ProfileState with _$ProfileState {
  /// Initial idle state.
  const factory ProfileState.initial() = ProfileInitial;

  /// A profile update is currently in flight.
  const factory ProfileState.updateInProgress() = ProfileUpdateInProgress;

  /// The most recent profile update attempt failed with [message].
  const factory ProfileState.updateFailure({
    required String message,
  }) = ProfileUpdateFailure;

  /// A profile update was completely successful.
  const factory ProfileState.updateSuccess() = ProfileUpdateSuccess;
}

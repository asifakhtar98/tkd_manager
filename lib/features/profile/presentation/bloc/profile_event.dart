import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_event.freezed.dart';

/// Events consumed by [ProfileBloc].
@freezed
sealed class ProfileEvent with _$ProfileEvent {
  /// Request to update the main profile details (User metadata / email).
  const factory ProfileEvent.updateOrganizationRequested({
    required String newOrganizationName,
  }) = ProfileUpdateOrganizationRequested;
}

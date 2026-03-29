import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tkd_saas/features/auth/domain/repositories/authentication_repository.dart';
import 'package:tkd_saas/features/profile/presentation/bloc/profile_event.dart';
import 'package:tkd_saas/features/profile/presentation/bloc/profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

/// Manages specific profile update requests such as editing the organization name.
/// Not to be confused with [AuthenticationBloc] which handles session lifecycles.
@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(const ProfileState.initial()) {
    on<ProfileUpdateOrganizationRequested>(_onUpdateOrganizationRequested);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onUpdateOrganizationRequested(
    ProfileUpdateOrganizationRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.updateInProgress());

    final result = await _authenticationRepository.updateProfileDetails(
      organizationName: event.newOrganizationName,
    );

    result.fold(
      (failure) => emit(ProfileState.updateFailure(message: failure.message)),
      (_) => emit(const ProfileState.updateSuccess()),
    );
  }
}

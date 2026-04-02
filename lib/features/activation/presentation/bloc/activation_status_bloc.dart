import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/activation_status.dart';
import '../../domain/repositories/i_activation_repository.dart';
import 'activation_status_event.dart';
import 'activation_status_state.dart';

/// Manages the activation status displayed on the dashboard.
///
/// On [ActivationStatusLoadRequested], fetches the current user's activation
/// status AND admin role in parallel, then emits the combined result.
@LazySingleton()
class ActivationStatusBloc
    extends Bloc<ActivationStatusEvent, ActivationStatusState> {
  final IActivationRepository _repository;

  ActivationStatusBloc(this._repository)
    : super(const ActivationStatusState()) {
    on<ActivationStatusLoadRequested>(_onLoadRequested);
    on<ActivationStatusAdminCheckRequested>(_onAdminCheckRequested);
    on<ActivationStatusClearRequested>(_onClearRequested);
  }

  Future<void> _onLoadRequested(
    ActivationStatusLoadRequested event,
    Emitter<ActivationStatusState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final Either<Failure, ActivationStatus> statusResult = await _repository
        .getActivationStatusForCurrentUser();
    final Either<Failure, bool> adminResult = await _repository
        .isCurrentUserAdmin();

    statusResult.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure)),
      (ActivationStatus status) {
        adminResult.fold(
          (failure) => emit(
            state.copyWith(
              isLoading: false,
              activationStatus: status,
              error: failure,
            ),
          ),
          (bool isAdmin) => emit(
            state.copyWith(
              isLoading: false,
              activationStatus: status,
              isAdmin: isAdmin,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAdminCheckRequested(
    ActivationStatusAdminCheckRequested event,
    Emitter<ActivationStatusState> emit,
  ) async {
    final result = await _repository.isCurrentUserAdmin();
    result.fold(
      (failure) => emit(state.copyWith(error: failure)),
      (bool isAdmin) => emit(state.copyWith(isAdmin: isAdmin)),
    );
  }

  void _onClearRequested(
    ActivationStatusClearRequested event,
    Emitter<ActivationStatusState> emit,
  ) {
    emit(const ActivationStatusState());
  }
}

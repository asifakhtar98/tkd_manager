import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_activation_repository.dart';
import 'admin_activation_event.dart';
import 'admin_activation_state.dart';

/// Manages the admin activation panel where pending requests
/// can be approved or rejected.
///
/// Approval triggers the subscription day-extension logic
/// (all in [IActivationRepository.approveActivationRequest]).
@injectable
class AdminActivationBloc
    extends Bloc<AdminActivationEvent, AdminActivationState> {
  final IActivationRepository _repository;

  AdminActivationBloc(this._repository) : super(const AdminActivationState()) {
    on<AdminActivationLoadPendingRequests>(_onLoadPendingRequests);
    on<AdminActivationApproveRequest>(_onApproveRequest);
    on<AdminActivationRejectRequest>(_onRejectRequest);
  }

  Future<void> _onLoadPendingRequests(
    AdminActivationLoadPendingRequests event,
    Emitter<AdminActivationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

    final result = await _repository.getAllPendingActivationRequests();

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure)),
      (requests) =>
          emit(state.copyWith(isLoading: false, pendingRequests: requests)),
    );
  }

  Future<void> _onApproveRequest(
    AdminActivationApproveRequest event,
    Emitter<AdminActivationState> emit,
  ) async {
    final requestId = event.request.id;
    emit(
      state.copyWith(
        processingRequestIds: {...state.processingRequestIds, requestId},
        error: null,
        successMessage: null,
      ),
    );

    final result = await _repository.approveActivationRequest(
      request: event.request,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          processingRequestIds: state.processingRequestIds.difference({
            requestId,
          }),
          error: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          processingRequestIds: state.processingRequestIds.difference({
            requestId,
          }),
          pendingRequests: state.pendingRequests
              .where((request) => request.id != requestId)
              .toList(),
          successMessage:
              'Approved ${event.request.requestedDays} days for ${event.request.contactName}',
        ),
      ),
    );
  }

  Future<void> _onRejectRequest(
    AdminActivationRejectRequest event,
    Emitter<AdminActivationState> emit,
  ) async {
    final requestId = event.requestId;
    emit(
      state.copyWith(
        processingRequestIds: {...state.processingRequestIds, requestId},
        error: null,
        successMessage: null,
      ),
    );

    final result = await _repository.rejectActivationRequest(
      requestId: requestId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          processingRequestIds: state.processingRequestIds.difference({
            requestId,
          }),
          error: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          processingRequestIds: state.processingRequestIds.difference({
            requestId,
          }),
          pendingRequests: state.pendingRequests
              .where((request) => request.id != requestId)
              .toList(),
          successMessage: 'Request rejected',
        ),
      ),
    );
  }
}

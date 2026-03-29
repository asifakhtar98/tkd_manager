import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_activation_repository.dart';
import 'activation_event.dart';
import 'activation_state.dart';

@injectable
class ActivationBloc extends Bloc<ActivationEvent, ActivationState> {
  final IActivationRepository _repository;

  ActivationBloc(this._repository) : super(const ActivationState()) {
    on<ActivationEvent>((event, emit) async {
      await event.map(
        addDays: (addDaysEvent) async => _onAddDays(addDaysEvent.days, emit),
        setDays: (setDaysEvent) async => _onSetDays(setDaysEvent.days, emit),
        clearDays: (_) async => _onClearDays(emit),
        contactNameChanged: (contactEvent) async =>
            _onContactNameChanged(contactEvent.name, emit),
        submitRequested: (_) async => _onSubmitRequested(emit),
      );
    });
  }

  void _onAddDays(int days, Emitter<ActivationState> emit) {
    emit(
      state.copyWith(
        requestedDays: state.requestedDays + days,
        error: null,
        isSuccess: false,
      ),
    );
  }

  void _onSetDays(int days, Emitter<ActivationState> emit) {
    emit(state.copyWith(requestedDays: days, error: null, isSuccess: false));
  }

  void _onClearDays(Emitter<ActivationState> emit) {
    emit(state.copyWith(requestedDays: 0, error: null, isSuccess: false));
  }

  void _onContactNameChanged(String name, Emitter<ActivationState> emit) {
    emit(state.copyWith(contactName: name));
  }

  Future<void> _onSubmitRequested(Emitter<ActivationState> emit) async {
    if (state.requestedDays <= 0) return;
    if (state.contactName.trim().isEmpty) return;

    emit(state.copyWith(isLoading: true, error: null, isSuccess: false));

    final result = await _repository.submitActivationRequest(
      contactName: state.contactName.trim(),
      requestedDays: state.requestedDays,
      totalAmount: state.totalAmount,
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure)),
      (entity) => emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          requestedDays: 0,
          contactName: '',
        ),
      ),
    );
  }
}

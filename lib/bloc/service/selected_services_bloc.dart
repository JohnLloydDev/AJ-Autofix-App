import 'package:flutter_bloc/flutter_bloc.dart';
import 'selected_services_event.dart';
import 'selected_services_state.dart';

class SelectedServicesBloc
    extends Bloc<SelectedServicesEvent, SelectedServicesState> {
  SelectedServicesBloc() : super(const SelectedServicesState()) {
    on<AddSelectedService>((event, emit) {
      final updatedServices = List<String>.from(state.selectedServices)
        ..add(event.service);
      emit(state.copyWith(
        selectedServices: updatedServices,
        selectedServiceCount: updatedServices.length,
      ));
    });

    on<RemoveSelectedService>((event, emit) {
      final updatedServices = List<String>.from(state.selectedServices)
        ..remove(event.service);
      emit(state.copyWith(
        selectedServices: updatedServices,
        selectedServiceCount: updatedServices.length,
      ));
    });
  }
}

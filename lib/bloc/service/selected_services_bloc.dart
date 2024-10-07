// // selected_services_bloc.dart
// import 'package:bloc/bloc.dart';
// import 'selected_services_event.dart';
// import 'selected_services_state.dart';

// class SelectedServicesBloc extends Bloc<SelectedServicesEvent, SelectedServicesState> {
//   SelectedServicesBloc() : super(const SelectedServicesState()) {
//     on<AddService>((event, emit) {
//       if (!state.selectedServices.contains(event.serviceName)) {
//         final updatedServices = List<String>.from(state.selectedServices)
//           ..add(event.serviceName);
//         emit(state.copyWith(
//           selectedServices: updatedServices,
//           selectedServiceCount: updatedServices.length,
//         ));
//       }
//     });

//     on<RemoveService>((event, emit) {
//       if (state.selectedServices.contains(event.serviceName)) {
//         final updatedServices = List<String>.from(state.selectedServices)
//           ..remove(event.serviceName);
//         emit(state.copyWith(
//           selectedServices: updatedServices,
//           selectedServiceCount: updatedServices.length,
//         ));
//       }
//     });

//     on<ClearServices>((event, emit) {
//       emit(const SelectedServicesState());
//     });
//   }
// }

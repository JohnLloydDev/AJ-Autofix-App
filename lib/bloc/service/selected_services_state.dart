// // selected_services_state.dart
// import 'package:equatable/equatable.dart';

// class SelectedServicesState extends Equatable {
//   final List<String> selectedServices;
//   final int selectedServiceCount;

//   const SelectedServicesState({
//     this.selectedServices = const [],
//     this.selectedServiceCount = 0,
//   });

//   SelectedServicesState copyWith({
//     List<String>? selectedServices,
//     int? selectedServiceCount,
//   }) {
//     return SelectedServicesState(
//       selectedServices: selectedServices ?? this.selectedServices,
//       selectedServiceCount: selectedServiceCount ?? this.selectedServiceCount,
//     );
//   }

//   @override
//   List<Object> get props => [selectedServices, selectedServiceCount];
// }

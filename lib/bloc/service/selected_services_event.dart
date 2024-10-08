// selected_services_event.dart
import 'package:equatable/equatable.dart';

abstract class SelectedServicesEvent extends Equatable {
  const SelectedServicesEvent();

  @override
  List<Object> get props => [];
}

class AddSelectedService extends SelectedServicesEvent {
  final String service;

  const AddSelectedService(this.service);

  @override
  List<Object> get props => [service];
}

class RemoveSelectedService extends SelectedServicesEvent {
  final String service;

  const RemoveSelectedService(this.service);

  @override
  List<Object> get props => [service];
}

import 'dart:developer';

import 'package:aj_autofix/models/booking_model.dart';
import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

final class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> bookings;


  const BookingLoaded(this.bookings);

  @override
  List<Object> get props => [bookings ];
}

class BookingLoadedById extends BookingState {
  final Booking booking;

  const BookingLoadedById(this.booking);

  @override
  List<Object> get props => [booking];
}

class BookingSuccess extends BookingState{
  final String message;

  const BookingSuccess({required this.message});

  @override
  List<Object> get props => [message];
  
}


class RequestError extends BookingState {
  final String error;

  const RequestError(this.error);

  @override
  List<Object> get props => [error];
}

class BookingPendingLoaded extends BookingState {
  final List<Booking> pendingBookings;

  const BookingPendingLoaded(this.pendingBookings);

  @override
  List<Object> get props => [pendingBookings];
}

class ServiceSelectionState extends BookingState {
  final List<Service> selectedServices;

  const ServiceSelectionState(this.selectedServices);

  @override
    List<Object> get props => [selectedServices];

}
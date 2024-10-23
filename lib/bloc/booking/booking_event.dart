import 'dart:developer';

import 'package:aj_autofix/models/booking_model.dart';
import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class GetBooking extends BookingEvent {}

class GetUserBooking extends BookingEvent {}

class GetBookingById extends BookingEvent {
  final String bookingId;

  const GetBookingById(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class AcceptBooking extends BookingEvent {
  final String bookingId;

  const AcceptBooking(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class RejectBooking extends BookingEvent {
  final String bookingId;

  const RejectBooking(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class CompletedBooking extends BookingEvent {
  final String bookingId;

  const CompletedBooking(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class GetAllPendingBooking extends BookingEvent {}

class GetAllAcceptedBooking extends BookingEvent {}

class AddService extends BookingEvent {
  final Service service;
  const AddService(this.service);

  @override
  List<Object> get props => [service];
}

class CreateBooking extends BookingEvent {
  final Booking booking;

  const CreateBooking(this.booking);

  @override
  List<Object> get props => [booking];
}

class GetNewBookingCount extends BookingEvent {}

class MarkBookingsAsViewed extends BookingEvent {}

class GetNewUserBookingCount extends BookingEvent {}

class MarkUserBookingsAsViewed extends BookingEvent {}

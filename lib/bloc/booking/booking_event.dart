import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class GetBooking extends BookingEvent {}

class GetBookingById extends BookingEvent {
  final String id;

  const GetBookingById(this.id);

  @override
  List<Object> get props => [id];
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

class GetAllPendingBooking extends BookingEvent {}

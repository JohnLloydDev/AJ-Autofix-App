import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';
import 'package:aj_autofix/repositories/booking_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc(this.bookingRepository) : super(BookingInitial()) {
    on<GetBooking>((event, emit) async {
      try {
        emit(BookingLoading());
        final bookings = await bookingRepository.getAllBooking();
        emit(BookingLoaded(bookings));
      } catch (e) {
        emit(RequestError('Failed to fetch bookings: $e'));
      }
    });

    on<GetBookingById>((event, emit) async {
      emit(BookingLoading());
      try {
        final booking = await bookingRepository.getBookingById(event.id);
        emit(BookingLoadedById(booking));
      } catch (e) {
        emit(RequestError('Failed to fetch booking by ID: $e'));
      }
    });

    on<AcceptBooking>((event, emit) async {
      emit(BookingLoading());
      try {
        await bookingRepository.acceptBooking(event.bookingId);
        final pendingBookings = await bookingRepository.getAllPendingBooking();
        emit(BookingPendingLoaded(pendingBookings));
      } catch (e) {
        emit(RequestError('Failed to accept booking: $e'));
      }
    });

    on<RejectBooking>((event, emit) async {
      emit(BookingLoading());
      try {
        await bookingRepository.rejectBooking(event.bookingId);
        final pendingBookings = await bookingRepository.getAllPendingBooking();
        emit(BookingPendingLoaded(pendingBookings));
      } catch (e) {
        emit(RequestError('Failed to reject booking: $e'));
      }
    });

    on<GetAllPendingBooking>((event, emit) async {
      try {
        emit(BookingLoading());
        final pendingBookings = await bookingRepository.getAllPendingBooking();
        emit(BookingPendingLoaded(pendingBookings));
      } catch (e) {
        emit(RequestError('Failed to fetch pending bookings: $e'));
      }
    });

     on<AddService>((event, emit) {
    });


    on<CreateBooking>((event, emit) async {
      emit(BookingLoading());

      try {
        await bookingRepository.createBooking(event.booking);
        emit(const BookingSuccess(message: 'Booking created successfully!'));
      } catch (e) {
        emit(RequestError('Failed to create booking: $e'));
      }
    });

    
  }
}

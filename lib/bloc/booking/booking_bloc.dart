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
        final booking = await bookingRepository.getBookingById(event.bookingId);

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

    on<CompletedBooking>((event, emit) async {
      emit(BookingLoading());
      try {
        await bookingRepository.completeBooking(event.bookingId);
        final acceptedBookings =
            await bookingRepository.getAllAcceptedBooking();
        emit(BookingAcceptedLoaded(acceptedBookings));
      } catch (e) {
        emit(RequestError('Failed to accept booking: $e'));
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

    on<GetAllAcceptedBooking>((event, emit) async {
      try {
        emit(BookingLoading());
        final acceptBooking = await bookingRepository.getAllAcceptedBooking();
        emit(BookingAcceptedLoaded(acceptBooking));
      } catch (e) {
        emit(RequestError('Failed to fetch pending bookings: $e'));
      }
    });

    on<AddService>((event, emit) {});

    on<CreateBooking>((event, emit) async {
      emit(BookingLoading());

      try {
        final userId = event.booking.userId;
        if (userId!.isEmpty) {
          emit(const RequestError('User ID is required to create a booking.'));
          return;
        }
        await bookingRepository.createBooking(userId, event.booking);
        emit(const BookingSuccess(message: 'Booking created successfully!'));
      } catch (e) {
        if (e.toString().contains('The selected time is already occupied. Please choose another time.')) {
          emit(const RequestError('The selected time is already occupied. Please choose another time.'));
        } else {
          emit(RequestError('Failed to create booking: $e'));
        }
      }
    });

    on<GetUserBooking>((event, emit) async {
      try {
        emit(BookingLoading());
        final booking = await bookingRepository.getUserBooking();
        emit(BookingUserLoaded(booking));
      } catch (e) {
        emit(RequestError(e.toString()));
      }
    });
  }
}

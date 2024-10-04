import 'package:aj_autofix/models/booking_model.dart';

abstract class BookingRepository {
  Future<List<Booking>> getAllBooking();
  Future<Booking> getBookingById(String id);
  Future<Booking> acceptBooking(String id);
  Future<Booking> rejectBooking(String id);
    Future<Booking> completeBooking(String id);
  Future<List<Booking>> getAllPendingBooking();
  Future<List<Booking>> getAllAcceptedBooking();
  Future<Booking> createBooking(String id, Booking booking);
  Future<List<Booking>> getUserBooking();
}

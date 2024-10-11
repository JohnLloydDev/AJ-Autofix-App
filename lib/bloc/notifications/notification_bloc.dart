import 'package:aj_autofix/bloc/notifications/notification_state.dart';
import 'package:aj_autofix/repositories/booking_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Cubit<NotificationState> {
  final BookingRepositoryImpl bookingRepository;
  int currentNotificationCount = 0;

  NotificationBloc(this.bookingRepository) : super(NotificationInitial());

  Future<void> fetchNotificationCount() async {
    try {
      emit(NotificationLoading());

      final userBookings = await bookingRepository.getUserBooking();
      final notifications = userBookings
          .where((booking) =>
              booking.status == 'Approved' ||
              booking.status == 'Rejected' ||
              booking.status == 'Completed')
          .toList();

      currentNotificationCount = notifications.length;

      emit(NotificationLoaded(currentNotificationCount));
    } catch (error) {
      emit(const NotificationError('Failed to load notifications.'));
    }
  }

  void resetNotificationCount() {
    currentNotificationCount = 0;
    emit(NotificationLoaded(currentNotificationCount));
  }
}

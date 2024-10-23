import 'package:aj_autofix/repositories/booking_repository_impl.dart';
import 'package:aj_autofix/screens/pending_screen.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:aj_autofix/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _fetchUserBookings();
  }

  void _fetchUserBookings() {
    context.read<BookingBloc>().add(GetUserBooking());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: kAppBar,
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, bookingState) {
          if (bookingState is BookingLoading) {
            return const CustomLoading();
          } else if (bookingState is BookingUserLoaded) {
            final bookings = bookingState.userBookings
                .where((booking) =>
                    booking.status == 'Approved' ||
                    booking.status == 'Rejected' ||
                    booking.status == 'Completed')
                .toList();

            if (bookings.isEmpty) {
              return const Center(
                child: Text("Check back later for updates."),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _fetchUserBookings();
              },
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings.reversed.toList()[index];
                  return NotificationCard(
                    title: booking.user?.fullname ?? 'Unknown User',
                    status: booking.status,
                    statusColor: _getStatusColor(booking.status),
                  );
                },
              ),
            );
          } else if (bookingState is RequestError) {
            return Center(
              child: Text('Error: ${bookingState.error}'),
            );
          } else {
            return Center(
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
              ),
            );
          }
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;

  const NotificationCard({
    super.key,
    required this.title,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        leading: Container(
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            status == 'Approved'
                ? Icons.check_circle
                : status == 'Rejected'
                    ? Icons.cancel
                    : Icons.assignment_turned_in,
            color: Colors.white,
            size: 24.0,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Your booking has been ${status.toLowerCase()}.',
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16.0,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) =>
                    BookingBloc(BookingRepositoryImpl())..add(GetUserBooking()),
                child: const UserPendingRequest(),
              ),
            ),
          );
        },
      ),
    );
  }
}

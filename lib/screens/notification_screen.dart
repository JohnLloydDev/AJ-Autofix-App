import 'package:aj_autofix/bloc/notifications/Notification_bloc.dart';
import 'package:aj_autofix/repositories/booking_repository_impl.dart';
import 'package:aj_autofix/screens/home.dart';
import 'package:aj_autofix/screens/booking_screen.dart';
import 'package:aj_autofix/screens/pending_screen.dart';
import 'package:aj_autofix/screens/shopmap.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';

class NotificationScreen extends StatefulWidget {
  final List<String> selectedServices;
  final int selectedServiceCount;

  const NotificationScreen(
      {super.key,
      required this.selectedServices,
      required this.selectedServiceCount});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _fetchUserBookings();
    _fetchNotifications();
  }

  void _fetchUserBookings() {
    context.read<BookingBloc>().add(GetUserBooking());
  }

  void _fetchNotifications() {
    context.read<NotificationBloc>().fetchNotificationCount();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BookingScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) =>
                  BookingBloc(BookingRepositoryImpl())..add(GetUserBooking()),
              child: ShopMap(
                selectedServices: widget.selectedServices,
                selectedServiceCount: widget.selectedServiceCount,
              ),
            ),
          ),
        );
        break;
      case 3:
        context.read<NotificationBloc>().resetNotificationCount();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: kAppBarGradient,
        ),
        title: const Text('Notifications'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, bookingState) {
          if (bookingState is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6E88A1),
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.receipt),
                if (widget.selectedServiceCount > 0)
                  Positioned(
                    right: 0,
                    top: -1,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Center(
                        child: Text(
                          '${widget.selectedServiceCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Booking',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
        onTap: _onItemTapped,
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
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(0.2),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
        contentPadding: const EdgeInsets.all(16.0),
        leading: Container(
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            status == 'Approved'
                ? Icons.check_circle
                : status == 'Rejected'
                    ? Icons.cancel
                    : Icons.assignment_turned_in,
            color: Colors.white,
            size: 30.0,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Your booking has been ${status.toLowerCase()}.',
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
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

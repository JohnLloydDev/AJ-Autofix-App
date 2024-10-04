import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:aj_autofix/bloc/user/user_state.dart';
import 'package:aj_autofix/repositories/admin_repository_impl.dart';
import 'package:aj_autofix/repositories/booking_repository_impl.dart';
import 'package:aj_autofix/screens/admin_completed_bookings_screen.dart';
import 'package:aj_autofix/screens/admin_services_screen.dart';
import 'package:aj_autofix/screens/admin_user_screen.dart';
import 'package:aj_autofix/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 0;
  int totalApproved = 0;
  int totalPending = 0;
  int totalRejected = 0;
  int totalUsers = 0; 

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookingBloc>(context).add(GetBooking());
    BlocProvider.of<UserBloc>(context).add(GetUsers());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) =>
                  UserBloc(AdminRepositoryImpl())..add(GetUsers()),
              child: const AdminUsersScreen(),
            ),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminServicesScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => BookingBloc(BookingRepositoryImpl())
                ..add(GetAllAcceptedBooking()),
              child: const AdminCompletedBookingsScreen(),
            ),
          ),
        );
        break;
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      BlocProvider.of<AuthBloc>(context).add(LogoutRequest());

      await Future.delayed(const Duration(milliseconds: 300));

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _handleLogout(context);
              },
              icon: const Icon(Icons.logout))
        ],
        automaticallyImplyLeading: false,
        title: const Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RequestError) {
                  return Center(child: Text(state.error));
                } else if (state is BookingLoaded) {
                  final bookings = state.bookings;
                  totalPending = bookings
                      .where((booking) =>
                          booking.status.toLowerCase() == 'pending')
                      .length;
                  totalApproved = bookings
                      .where((booking) =>
                          booking.status.toLowerCase() == 'approved')
                      .length;
                  totalRejected = bookings
                      .where((booking) =>
                          booking.status.toLowerCase() == 'rejected')
                      .length;

                  return BlocBuilder<UserBloc, UserState>(
                    builder: (context, userState) {
                      if (userState is UserDataLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (userState is UserDataLoaded) {
                        totalUsers = userState.userdata.length; 

                        return GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          shrinkWrap: true,
                          children: [
                            _buildDashboardItem('Total\nUsers', '$totalUsers',
                                Colors.purple, Icons.people),
                            _buildDashboardItem(
                                'Total\nRejected',
                                '$totalRejected',
                                Colors.red,
                                Icons.request_page),
                            _buildDashboardItem('Total\nPending',
                                '$totalPending', Colors.orange, Icons.thumb_up),
                            _buildDashboardItem('Total\nApproved',
                                '$totalApproved', Colors.green, Icons.done_all),
                          ],
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Recent Activity",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RequestError) {
                    return Center(child: Text(state.error));
                  } else if (state is BookingLoaded) {
                    final bookings = state.bookings;
                    return ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final reverseIndex = bookings.length - 1 - index;
                        final booking = bookings[reverseIndex];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ]),
                          child: ListTile(
                            title: Text(
                              booking.user?.fullname ?? 'Unknown',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _statusBadge(booking.status),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.check_mark_circled),
            label: 'Complete',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color badgeColor;

    switch (status.toLowerCase()) {
      case 'approved':
        badgeColor = Colors.green;
        break;
      case 'rejected':
        badgeColor = Colors.red;
        break;
      case 'completed':
        badgeColor = Colors.blue;
        break;
      default:
        badgeColor = Colors.orange;
    }

    return IntrinsicWidth(
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
            color: badgeColor, borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: Text(
          status,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDashboardItem(
      String title, String count, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    color: color,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              count,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Divider(
              thickness: 1.5,
              color: color.withOpacity(0.5),
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '$title: $count',
                style: TextStyle(
                  fontSize: 14,
                  color: color.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

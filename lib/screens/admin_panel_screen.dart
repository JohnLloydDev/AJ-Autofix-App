import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:aj_autofix/bloc/user/user_state.dart';
import 'package:aj_autofix/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';
import 'package:go_router/go_router.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
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

  Future<void> handleLogout(BuildContext context) async {
    try {
      BlocProvider.of<AuthBloc>(context).add(LogoutRequest());

      await Future.delayed(const Duration(milliseconds: 300));

      if (context.mounted) {
        (context).push("/login");
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
              handleLogout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        automaticallyImplyLeading: false,
        title: const Text('Admin Panel'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  return const CustomLoading();
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
                        return const CustomLoading();
                      } else if (userState is UserDataLoaded) {
                        totalUsers = userState.userdata.length;

                        return Column(
                          children: [
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                dashboardContainer('Total\nUsers',
                                    '$totalUsers', Colors.purple, Icons.people),
                                dashboardContainer(
                                    'Total\nRejected',
                                    '$totalRejected',
                                    Colors.red,
                                    Icons.request_page),
                                dashboardContainer(
                                    'Total\nPending',
                                    '$totalPending',
                                    Colors.orange,
                                    Icons.thumb_up),
                                dashboardContainer(
                                    'Total\nApproved',
                                    '$totalApproved',
                                    Colors.green,
                                    Icons.done_all),
                              ],
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
                            const SizedBox(height: 10),
                            ListView.builder(
                              itemCount: bookings.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final reverseIndex =
                                    bookings.length - 1 - index;
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
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      booking.user?.fullname ?? 'Unknown',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
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
                            ),
                          ],
                        );
                      } else {
                        return const CustomLoading();
                      }
                    },
                  );
                } else {
                  return const CustomLoading();
                }
              },
            ),
          ],
        ),
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

  Widget dashboardContainer(
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

import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';
import 'package:aj_autofix/screens/admin_completed_bookings_screen.dart';
import 'package:aj_autofix/screens/admin_panel_screen.dart';
import 'package:aj_autofix/screens/admin_services_screen.dart';
import 'package:aj_autofix/screens/admin_user_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;
  int _newBookingCount = 0;

  final List<Widget> _pages = const [
    AdminPanelScreen(),
    AdminUsersScreen(),
    AdminServicesScreen(),
    AdminCompletedBookingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(GetNewBookingCount());
  }

  void _onBottomNavTapped(int index) {
    if (index != _selectedIndex) {
      context.read<BookingBloc>().add(GetNewBookingCount());
    }

    if (index == 2) {
      context.read<BookingBloc>().add(MarkBookingsAsViewed());
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _refreshData() async {
    if (_selectedIndex == 0) {
      context.read<BookingBloc>().add(GetNewBookingCount());
      context.read<UserBloc>().add(GetUsers());
      context.read<BookingBloc>().add(GetBooking());
    } else if (_selectedIndex == 1) {
      context.read<UserBloc>().add(GetUsers());
      context.read<BookingBloc>().add(GetNewBookingCount());
    } else if (_selectedIndex == 2) {
      context.read<BookingBloc>().add(GetAllPendingBooking());
    } else if (_selectedIndex == 3) {
      context.read<BookingBloc>().add(GetAllAcceptedBooking());
      context.read<BookingBloc>().add(GetNewBookingCount());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingCountLoaded) {
            _newBookingCount = state.count;
          }

          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.space_dashboard_outlined),
                label: 'Dashboard',
              ),
              const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_2),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(CupertinoIcons.calendar),
                    if (_newBookingCount > 0)
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Center(
                            child: Text(
                              '$_newBookingCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Bookings',
              ),
              const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.check_mark_circled),
                label: 'Complete',
              ),
            ],
            onTap: _onBottomNavTapped,
            backgroundColor: Colors.white,
          );
        },
      ),
    );
  }
}

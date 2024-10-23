import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/service/selected_services_bloc.dart';
import 'package:aj_autofix/bloc/service/selected_services_state.dart';
import 'package:aj_autofix/screens/booking_screen.dart';
import 'package:aj_autofix/screens/home.dart';
import 'package:aj_autofix/screens/notification_screen.dart';
import 'package:aj_autofix/screens/shopmap.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _newBookingCount = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    BookingScreen(userId: ''),
    ShopMap(),
    NotificationScreen(),
  ];
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(GetNewUserBookingCount());
  }

  void _onBottomNavTapped(int index) {

    if (index == 2) {
      context.read<BookingBloc>().add(MarkUserBookingsAsViewed());
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is NewUserBookingCountLoaded) {
              _newBookingCount = state.count;
            }

            return BlocBuilder<SelectedServicesBloc, SelectedServicesState>(
              builder: (context, servicesState) {
                return BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  selectedItemColor: const Color(0xFF6E88A1),
                  unselectedItemColor: Colors.grey,
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.garage_outlined),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          const Icon(Icons.post_add_outlined),
                          if (servicesState.selectedServiceCount > 0)
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
                                    '${servicesState.selectedServiceCount}',
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
                      icon: Icon(Icons.fmd_good_outlined),
                      label: 'Map',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          const Icon(Icons.notifications_on_outlined),
                          if (_newBookingCount > 0)
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
                                    '$_newBookingCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                      label: 'Notifications',
                    ),
                  ],
                  onTap: _onBottomNavTapped,
                );
              },
            );
          },
        ));
  }
}

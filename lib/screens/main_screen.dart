import 'package:aj_autofix/repositories/booking_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/notifications/notification_bloc.dart';
import 'package:aj_autofix/bloc/notifications/notification_state.dart';
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

  final List<Widget> _pages = const [
    HomeScreen(),
    BookingScreen(userId: ''),
    ShopMap(),
    NotificationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<NotificationBloc>(
            create: (context) => NotificationBloc(BookingRepositoryImpl())
              ..fetchNotificationCount(),
          ),
          BlocProvider(
            create: (_) => SelectedServicesBloc(),
          ),
        ],
        child: Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar:
                BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, notificationState) {
                int notificationCount = 0;
                if (notificationState is NotificationLoaded) {
                  notificationCount = notificationState.notificationCount;
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
                              if (notificationCount > 0)
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
                                        '$notificationCount',
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
                          label: 'Notifications',
                        ),
                      ],
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                        if (index == 3) {
                          BlocProvider.of<NotificationBloc>(context)
                              .resetNotificationCount();
                        }
                      },
                    );
                  },
                );
              },
            )));
  }
}

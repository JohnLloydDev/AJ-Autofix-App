import 'package:aj_autofix/screens/admin_completed_bookings_screen.dart';
import 'package:aj_autofix/screens/admin_panel_screen.dart';
import 'package:aj_autofix/screens/admin_services_screen.dart';
import 'package:aj_autofix/screens/admin_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AdminPanelScreen(),
    AdminUsersScreen(),
    AdminServicesScreen(),
    AdminCompletedBookingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
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
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}

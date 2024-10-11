import 'dart:io';

import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:aj_autofix/bloc/user/user_state.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/repositories/booking_repository_impl.dart';
import 'package:aj_autofix/screens/admin_completed_bookings_screen.dart';
import 'package:aj_autofix/screens/admin_panel_screen.dart';
import 'package:aj_autofix/screens/admin_services_screen.dart';
import 'package:aj_autofix/screens/admin_update_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:aj_autofix/utils/profile_picture_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  int _selectedIndex = 1;
  String _searchQuery = '';
  late List<User> _filteredUsers;
  List<User> _allUsers = [];
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AdminPanelScreen()));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => BookingBloc(BookingRepositoryImpl())
                ..add(GetAllAcceptedBooking()),
              child: const AdminServicesScreen(),
            ),
          ),
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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    BlocProvider.of<UserBloc>(context).add(GetUsers());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = BlocProvider.of<UserBloc>(context).state;
    if (state is UserDataLoaded) {
      _allUsers = state.userdata;
      _filterUsers();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterUsers();
    });
  }

  void _filterUsers() {
    _filteredUsers = _allUsers.where((user) {
      return user.fullname.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Users'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: 'Search users',
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              borderRadius: BorderRadius.circular(8.0),
              backgroundColor: const Color.fromARGB(88, 167, 158, 158),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserDataLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is UserDataLoaded) {
                  _allUsers = state.userdata;
                  _filterUsers();
                  return ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
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
                          contentPadding: const EdgeInsets.all(12.0),
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: _getProfileImage(
                              user.profilePicture,
                              user.fullname,
                            ),
                          ),
                          title: Text(
                            user.fullname,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            user.email,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdminUpdateDetailsScreen(
                                          id: user.id,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue[700],
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDeleteDialog(context, user.id);
                                },
                                icon: const Icon(Icons.delete),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red[700],
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is UserDataError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
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
            label: 'Completed',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void showDeleteDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                final bloc = BlocProvider.of<UserBloc>(context);
                bloc.add(DeleteUser(userId));
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

Widget _getProfileImage(String? profilePicture, String fullname) {
  if (profilePicture == null || profilePicture.isEmpty) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: getRandomBackgroundColor(fullname),
      child: Text(
        fullname.isNotEmpty ? fullname[0].toUpperCase() : 'U',
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  if (profilePicture.startsWith('http') || profilePicture.startsWith('https')) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.transparent,
      backgroundImage: NetworkImage(profilePicture),
      child: null,
    );
  }

  try {
    final file = File(profilePicture);
    if (file.existsSync()) {
      return CircleAvatar(
        radius: 22,
        backgroundColor: Colors.transparent,
        backgroundImage: FileImage(file),
        child: null,
      );
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return CircleAvatar(
    radius: 22,
    backgroundColor: getRandomBackgroundColor(fullname),
    child: Text(
      fullname.isNotEmpty ? fullname[0].toUpperCase() : 'U',
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

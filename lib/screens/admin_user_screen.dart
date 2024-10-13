import 'dart:io';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:aj_autofix/bloc/user/user_state.dart';
import 'package:aj_autofix/models/booking_model.dart';
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
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
    tz.initializeTimeZones();
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
                      return GestureDetector(
                        onTap: () {
                          showUserBookingsBottomSheet(context, user);
                        },
                        child: Container(
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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

void showUserBookingsBottomSheet(BuildContext context, User user) {
  bool showBookingHistory = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderButton(
                      context,
                      'Information',
                      !showBookingHistory,
                      () {
                        setState(() {
                          showBookingHistory = false;
                        });
                      },
                    ),
                    _buildHeaderButton(
                      context,
                      'Booking History',
                      showBookingHistory,
                      () {
                        setState(() {
                          showBookingHistory = true;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(thickness: 2, color: Colors.grey[300]),
                Expanded(
                  child: showBookingHistory
                      ? _buildBookingHistoryList(user.bookings)
                      : _buildUserInfo(user),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildHeaderButton(
    BuildContext context, String title, bool isActive, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: isActive ? Colors.blue : Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    ),
    child: Text(
      title,
      style: TextStyle(
        color: isActive ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _buildUserInfo(User user) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'User Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildInfoTile(Icons.person, 'Full Name: ${user.fullname}'),
        _buildInfoTile(Icons.account_circle, 'Username: ${user.username}'),
        _buildInfoTile(Icons.email, 'Email: ${user.email}'),
        _buildInfoTile(Icons.phone, 'Contact: ${user.contactNumber}'),
        _buildInfoTile(Icons.verified,
            'Verification Status: ${user.isVerified ? "Verified" : "Not Verified"}'),
      ],
    ),
  );
}

Widget _buildInfoTile(IconData icon, String info) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(info, style: const TextStyle(fontSize: 16))),
      ],
    ),
  );
}

Widget _buildBookingHistoryList(List<Booking>? bookings) {
  return ListView.builder(
    itemCount: bookings?.length ?? 0,
    itemBuilder: (context, index) {
      final booking = bookings![index];
      final utcDateTime = DateTime.parse(booking.createdAt).toUtc();
      final manila = tz.getLocation('Asia/Manila');
      final philippinesTime = tz.TZDateTime.from(utcDateTime, manila);
      final formattedDateTime =
          DateFormat('dd MMM yyyy hh:mm a').format(philippinesTime);
          
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.serviceType.join(', '),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: $formattedDateTime',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            Text(
              'Status: ${booking.status}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    },
  );
}

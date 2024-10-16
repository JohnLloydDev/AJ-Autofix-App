import 'dart:io';
import 'package:aj_autofix/utils/custom_loading.dart';
import 'package:aj_autofix/utils/profile_picture_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:aj_autofix/bloc/user/user_state.dart';
import 'package:aj_autofix/screens/profile_update_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUserByAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.angleLeft,
            color: Colors.black,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserDataLoading) {
          return const CustomLoading();
          } else if (state is UserDataLoadedByAuth) {
            final user = state.user;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: _getProfileImage(
                        user.profilePicture,
                        user.fullname,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      user.fullname,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileUpdateScreen(userId: user.id),
                                ),
                              );
                            },
                            icon:
                                const Icon(Icons.settings, color: Colors.white),
                            label: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 10),
                    profileDetail(Icons.person, 'Full Name', user.fullname),
                    const SizedBox(height: 20),
                    profileDetail(
                        Icons.person_outline, 'Username', user.username),
                    const SizedBox(height: 20),
                    profileDetail(Icons.email_outlined, 'Email', user.email),
                    const SizedBox(height: 20),
                    profileDetail(
                        Icons.phone, 'Phone Number', user.contactNumber),
                  ],
                ),
              ),
            );
          } else if (state is UserDataError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No user data available.'));
        },
      ),
    );
  }

  Widget profileDetail(IconData icon, String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  if (profilePicture.startsWith('http') || profilePicture.startsWith('https')) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.transparent,
      backgroundImage: NetworkImage(profilePicture),
      child: null,
    );
  }

  try {
    final file = File(profilePicture);
    if (file.existsSync()) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.transparent,
        backgroundImage: FileImage(file),
        child: null,
      );
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return CircleAvatar(
    radius: 30,
    backgroundColor: getRandomBackgroundColor(fullname),
    child: Text(
      fullname.isNotEmpty ? fullname[0].toUpperCase() : 'U',
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

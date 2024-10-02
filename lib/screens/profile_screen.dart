import 'dart:io';

import 'package:aj_autofix/screens/profile_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:aj_autofix/bloc/user/user_state.dart';

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
    context.read<UserBloc>().add(GetUserByAuthEvent());

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFDCDCDC),
                Color(0xFF6E88A1),
              ],
            ),
          ),
        ),
        title: const Text('Profile'),
      
        actions: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserDataLoadedByAuth) {
                final user = state.user;
                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileUpdateScreen(userId: user.id),
                      ),
                    );
                  },
                  child: const Text(
                    'EDIT',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserDataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserDataLoadedByAuth) {
            final user = state.user;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: _getProfileImage(user.profilePicture),
                    radius: 80,
                    backgroundColor: Colors.grey[300],
                  ),
                  _buildProfileDetail('Full Name', user.fullname),
                  _buildProfileDetail('Username', user.username),
                  _buildProfileDetail('Email', user.email),
                  _buildProfileDetail('Phone Number', user.contactNumber),
                ],
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

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: value,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}

ImageProvider _getProfileImage(String? profilePicture) {
  if (profilePicture == null || profilePicture.isEmpty) {
    return const AssetImage('assets/default_profile.png') as ImageProvider;
  }

  if (profilePicture.startsWith('http') || profilePicture.startsWith('https')) {
    return NetworkImage(profilePicture);
  }

  try {
    final file = File(profilePicture);
    if (file.existsSync()) {
      return FileImage(file);
    } else {
      return const AssetImage('assets/default_profile.png') as ImageProvider;
    }
  } catch (e) {
    return const AssetImage('assets/default_profile.png') as ImageProvider;
  }
}

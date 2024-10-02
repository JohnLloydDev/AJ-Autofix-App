import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:aj_autofix/bloc/user/user_state.dart';
import 'package:aj_autofix/models/user_model.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final String userId;

  const ProfileUpdateScreen({super.key, required this.userId});

  @override
  ProfileUpdateScreenState createState() => ProfileUpdateScreenState();
}

class ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _contactNumberController;
  File? profilePicture; 

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _contactNumberController = TextEditingController();
    context.read<UserBloc>().add(GetUserByAuthEvent());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        profilePicture = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Profile Update'),
        actions: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  if (state is UserDataLoadedByAuth) {
                    final updatedUser = User(
                      id: widget.userId,
                      fullname: _fullNameController.text,
                      username: _usernameController.text,
                      email: _emailController.text,
                      contactNumber: _contactNumberController.text,
                      password: '',
                      profilePicture: profilePicture != null ? profilePicture!.path : state.user.profilePicture,
                    );

                    context
                        .read<UserBloc>()
                        .add(UserUpdate(updatedUser, widget.userId));
                    Navigator.pop(context);
                  }
                },
                child:
                    const Text('SAVE', style: TextStyle(color: Colors.black)),
              );
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
            _fullNameController.text = user.fullname;
            _usernameController.text = user.username;
            _emailController.text = user.email;
            _contactNumberController.text = user.contactNumber;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage, 
                    child: CircleAvatar(
                      backgroundImage: profilePicture != null
                          ? FileImage(profilePicture!) 
                          : _getProfileImage(user.profilePicture), 
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  _buildProfileDetail('Full Name', _fullNameController),
                  _buildProfileDetail('Username', _usernameController),
                  _buildProfileDetail('Email', _emailController),
                  _buildProfileDetail('Phone Number', _contactNumberController),
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

  Widget _buildProfileDetail(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: InputDecoration(
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

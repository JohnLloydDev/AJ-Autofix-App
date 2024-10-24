import 'dart:io';
import 'package:aj_autofix/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Profile Update',
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

            _fullNameController.text = user.fullname;
            _usernameController.text = user.username;
            _emailController.text = user.email;
            _contactNumberController.text = user.contactNumber;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: _getProfileImage(
                              profilePicture?.path ?? user.profilePicture,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 30),
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Divider(color: Colors.grey, thickness: 1),
                    const SizedBox(height: 30),
                    labeledTextField(
                        'Full Name', Icons.person, _fullNameController),
                    const SizedBox(height: 20),
                    labeledTextField(
                        'Username', Icons.person_outline, _usernameController),
                    const SizedBox(height: 20),
                    labeledTextField(
                        'Email', Icons.email_outlined, _emailController),
                    const SizedBox(height: 20),
                    labeledTextField(
                        'Phone Number', Icons.phone, _contactNumberController),
                    const SizedBox(height: 20),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        final updatedUser = User(
                          id: widget.userId,
                          fullname: _fullNameController.text,
                          username: _usernameController.text,
                          email: _emailController.text,
                          contactNumber: _contactNumberController.text,
                          password: '',
                          profilePicture: profilePicture != null
                              ? profilePicture!.path
                              : user.profilePicture,
                          isVerified: true,
                        );

                        context
                            .read<UserBloc>()
                            .add(UserUpdate(updatedUser, widget.userId));
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'SAVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
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

  Widget labeledTextField(
      String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            hintText: 'Enter $label',
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
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

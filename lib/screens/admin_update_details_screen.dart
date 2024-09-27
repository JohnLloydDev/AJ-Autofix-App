import 'dart:io';

import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:aj_autofix/bloc/user/user_state.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUpdateDetailsScreen extends StatefulWidget {
  final String id;

  const AdminUpdateDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  State<AdminUpdateDetailsScreen> createState() =>
      _AdminUpdateDetailsScreenState();
}

class _AdminUpdateDetailsScreenState extends State<AdminUpdateDetailsScreen> {
  late TextEditingController fullnameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController contactNumberController;
  String dropdownValue = 'user';

  ImageProvider? _getProfileImage(String? profilePicture) {
    if (profilePicture == null || profilePicture.isEmpty) {
      return const AssetImage('assets/default_profile.png');
    }

    if (profilePicture.startsWith('http') ||
        profilePicture.startsWith('https')) {
      return NetworkImage(profilePicture);
    }

    try {
      final file = File(profilePicture);
      if (file.existsSync()) {
        return FileImage(file);
      }
    } catch (e) {
      debugPrint('Error loading image file: $e');
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    fullnameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    contactNumberController = TextEditingController();
    BlocProvider.of<UserBloc>(context).add(GetUsersById(widget.id));
  }

  @override
  void dispose() {
    fullnameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Update Info'),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              height: 580,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(width: 1, color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserDataLoadedById) {
                    fullnameController.text = state.user.fullname;
                    usernameController.text = state.user.username;
                    emailController.text = state.user.email;
                    contactNumberController.text = state.user.contactNumber;
                    dropdownValue = state.user.role;
                  } else if (state is UserDataSuccess) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else if (state is UserDataError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UserDataLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is UserDataLoadedById) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        CircleAvatar(
                          backgroundImage: _getProfileImage(
                                  state.user.profilePicture) ??
                              const AssetImage('assets/default_profile.png'),
                          radius: 50,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: TextField(
                                controller: fullnameController,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.person_outline),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                  border: InputBorder.none,
                                  hintText: 'Full Name',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: TextField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.person_outline),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                  border: InputBorder.none,
                                  hintText: 'Username',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.email_outlined),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: TextField(
                                controller: contactNumberController,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.phone_outlined),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                  border: InputBorder.none,
                                  hintText: 'Contact Number',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.menu),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'user',
                                    child: Text('User'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'admin',
                                    child: Text('Admin'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'service manager',
                                    child: Text('Service Manager'),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                hint: const Text('Select a role'),
                                isExpanded: true,
                                underline: const SizedBox(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: ElevatedButton(
                              onPressed: () {
                                final fullname = fullnameController.text;
                                final username = usernameController.text;
                                final email = emailController.text;
                                final contactNumber =
                                    contactNumberController.text;

                                final profilePicture =
                                    state.user.profilePicture;

                                final user = User(
                                  fullname: fullname,
                                  username: username,
                                  email: email,
                                  contactNumber: contactNumber,
                                  password: '',
                                  role: dropdownValue,
                                  profilePicture: profilePicture,
                                );

                                BlocProvider.of<UserBloc>(context).add(
                                  UpdateUser(widget.id, user),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Update Details',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('No data available'),
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}

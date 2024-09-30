import 'dart:convert';
import 'dart:io';
import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:aj_autofix/widgets/custom_auth_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  File? _profilePicture;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePicture = File(image.path);
      });
    }
  }

  Future<String?> _convertFileToBase64(File? file) async {
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    return 'data:image/png;base64,${base64Encode(bytes)}';
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFDCDCDC),
              Color(0xFF6E88A1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: width * 0.2,
                      backgroundImage: _profilePicture != null
                          ? FileImage(_profilePicture!)
                          : const AssetImage('assets/default_profile.png')
                              as ImageProvider,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hello User!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: titleFontSize),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Create your account!',
                      style: TextStyle(fontSize: bodyFontSize),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.only(left: width * 0.05),
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.person_outline),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                                border: InputBorder.none,
                                hintText: 'Full Name'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.only(left: width * 0.05),
                          child: TextField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.person_outlined),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                                border: InputBorder.none,
                                hintText: 'Username'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.only(left: width * 0.05),
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.email_outlined),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                                border: InputBorder.none,
                                hintText: 'Email'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.only(left: width * 0.05),
                          child: TextField(
                            controller: contactNumberController,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.phone_outlined),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                                border: InputBorder.none,
                                hintText: 'Contact Number'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: width * 0.05, vertical: 12),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: _isPasswordVisible
                                  ? const Icon(Icons.visibility_outlined)
                                  : const Icon(Icons.visibility_off_outlined),
                            ),
                            hintText: 'Password',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSucceed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        } else if (state is AuthFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthIsProcessing) {
                          return const CircularProgressIndicator();
                        }
                        return Center(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.05),
                            child: ElevatedButton(
                              onPressed: () async {
                                final fullname = nameController.text;
                                final username = usernameController.text;
                                final email = emailController.text;
                                final contactNumber =
                                    contactNumberController.text;
                                final password = passwordController.text;

            final authBloc = BlocProvider.of<AuthBloc>(context);

            final profilePictureBase64 =
                _profilePicture != null
                    ? await _convertFileToBase64(_profilePicture!)
                    : null;

            final user = User(
              id: '',
              profilePicture: profilePictureBase64,
              fullname: fullname,
              username: username,
              email: email,
              contactNumber: contactNumber,
              password: password,
            );

            if (mounted) {
              authBloc.add(UserRegistration(user, _profilePicture));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Center(
            child: Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 73, 69, 69),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: const Text(
            'Sign In',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ],
    );
  }
}

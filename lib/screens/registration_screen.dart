import 'dart:convert';
import 'dart:io';
import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/screens/login_screen.dart';
import 'package:flutter/material.dart';
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
                    const SizedBox(height: 100), 
                    _buildCardView(context),
                    const SizedBox(height: 20),
                    _buildSignInLink(context),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardView(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 350, 
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 60, 
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
              const Text(
                'Hello User!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Create your account!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(nameController, 'Full Name', Icons.person_outline),
              const SizedBox(height: 10),
              _buildTextField(usernameController, 'Username', Icons.person_outlined),
              const SizedBox(height: 10),
              _buildTextField(emailController, 'Email', Icons.email_outlined),
              const SizedBox(height: 10),
              _buildTextField(contactNumberController, 'Contact Number', Icons.phone_outlined),
              const SizedBox(height: 10),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: Icon(icon),
            contentPadding: const EdgeInsets.symmetric(vertical: 12), 
            border: InputBorder.none,
            hintText: hintText,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
            contentPadding: const EdgeInsets.symmetric(vertical: 12), 
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
    );
  }

  Widget _buildRegisterButton() {
    return BlocConsumer<AuthBloc, AuthState>(
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
        return ElevatedButton(
          onPressed: () async {
            final fullname = nameController.text;
            final username = usernameController.text;
            final email = emailController.text;
            final contactNumber = contactNumberController.text;
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
            color: Color.fromARGB(255, 22, 20, 20),
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

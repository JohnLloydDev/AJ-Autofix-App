import 'dart:convert';
import 'dart:io';
import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/repositories/auth_repository_impl.dart';
import 'package:aj_autofix/screens/login_screen.dart';
import 'package:aj_autofix/screens/verify_email_screen.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:aj_autofix/utils/custom_loading.dart';
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
  String? nameError;
  String? usernameError;
  String? emailError;
  String? contactNumberError;
  String? passwordError;
  String? formErrorMessage;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _profilePicture = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
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
        decoration: kGradientBoxDecoration,
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
              _buildTextField(
                  nameController, 'Full Name', Icons.person_outline, nameError),
              const SizedBox(height: 10),
              _buildTextField(usernameController, 'Username',
                  Icons.person_outlined, usernameError),
              const SizedBox(height: 10),
              _buildTextField(
                  emailController, 'Email', Icons.email_outlined, emailError),
              const SizedBox(height: 10),
              _buildTextField(contactNumberController, 'Contact Number',
                  Icons.phone_outlined, contactNumberError),
              const SizedBox(height: 10),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildRegisterButton(),
              const SizedBox(height: 20),
              _buildSignInLink(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      IconData icon, String? error) {
    return Column(
      children: [
        Padding(
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                border: InputBorder.none,
                hintText: hintText,
              ),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
          final email = state.user.email;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => AuthBloc(AuthRepositoryImpl()),
                child: VerifyEmailScreen(email: email),
              ),
            ),
          );
        } else if (state is AuthFailed) {
          setState(() {
            formErrorMessage = state.error;
          });
        }
      },
      builder: (context, state) {
        bool isLoading = state is AuthIsProcessing;

        return Column(
          children: [
            if (formErrorMessage != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  formErrorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            SizedBox(
              width: 270,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          formErrorMessage = null;
                          nameError = null;
                          usernameError = null;
                          emailError = null;
                          contactNumberError = null;
                          passwordError = null;
                        });

                        final fullname = nameController.text.trim();
                        final username = usernameController.text.trim();
                        final email = emailController.text.trim();
                        final contactNumber = contactNumberController.text;
                        final password = passwordController.text.trim();

                        bool isValid = true;

                        if (fullname.length < 3) {
                          setState(() {
                            nameError =
                                'Fullname must be at least 3 characters long';
                          });
                          isValid = false;
                        }

                        if (username.length < 3) {
                          setState(() {
                            usernameError =
                                'Username must be at least 3 characters long';
                          });
                          isValid = false;
                        }

                        if (email.isEmpty || !email.contains('@')) {
                          setState(() {
                            emailError = 'Valid email is required';
                          });
                          isValid = false;
                        }

                        if (contactNumber.isEmpty ||
                            contactNumber.length < 10) {
                          setState(() {
                            contactNumberError =
                                'Valid contact number is required';
                          });
                          isValid = false;
                        }

                        if (password.isEmpty || password.length < 6) {
                          setState(() {
                            passwordError =
                                'Password must be at least 6 characters';
                          });
                          isValid = false;
                        }

                        if (!isValid) {
                          return;
                        }

                        final authBloc = BlocProvider.of<AuthBloc>(context);

                        final profilePictureBase64 = _profilePicture != null
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
                  backgroundColor: const Color(0xFF6E88A1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CustomLoading()
                    : const Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ),
            ),
          ],
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
              color: Color(0xFF6E88A1),
            ),
          ),
        ),
      ],
    );
  }
}

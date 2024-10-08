import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/screens/admin_panel_screen.dart';
import 'package:aj_autofix/screens/home.dart';
import 'package:aj_autofix/screens/registration_screen.dart';
import 'package:aj_autofix/screens/request_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? emailError;
  String? passwordError;
  String? formErrorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
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
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccessWithRole) {
                    if (state.role == 'user') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    } else if (state.role == 'admin' ||
                        state.role == 'service manager') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminPanelScreen()));
                    }
                  } else if (state is AuthFailed) {
                    setState(() {
                      if (state.error.contains('email')) {
                        emailError = state.error;
                        passwordError = null;
                      } else if (state.error.contains('password')) {
                        passwordError = state.error;
                        emailError = null;
                      } else {
                        emailError = null;
                        passwordError = state.error;
                      }
                      formErrorMessage =
                          state.error.contains('Invalid email or password')
                              ? 'Invalid email or password'
                              : null;
                    });
                  } else if (state is AuthReset) {
                    setState(() {
                      emailError = null;
                      passwordError = null;
                    });
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    Center(
                      child: SizedBox(
                        width: screenWidth * 0.9,
                        child: SingleChildScrollView(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.5,
                                    child: Image.asset(
                                      'assets/logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Welcome',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Login to your Account!',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 25),
                                            child: TextField(
                                              controller: emailController,
                                              decoration: const InputDecoration(
                                                suffixIcon:
                                                    Icon(Icons.email_outlined),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 12),
                                                border: InputBorder.none,
                                                hintText: 'Email',
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (emailError != null)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              emailError!,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: TextField(
                                            controller: passwordController,
                                            obscureText: !_isPasswordVisible,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 23.0,
                                                      vertical: 12.0),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isPasswordVisible =
                                                        !_isPasswordVisible;
                                                  });
                                                },
                                                icon: _isPasswordVisible
                                                    ? const Icon(Icons
                                                        .visibility_outlined)
                                                    : const Icon(Icons
                                                        .visibility_off_outlined),
                                              ),
                                              hintText: 'Password',
                                            ),
                                          ),
                                        ),
                                        if (passwordError != null)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              passwordError!,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const RequestOtpScreen()));
                                            },
                                            child: const Text(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF6E88A1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (formErrorMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        formErrorMessage!,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 12),
                                      ),
                                    ),
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      if (state is AuthIsProcessing) {
                                        return const CircularProgressIndicator();
                                      }
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                emailError = null;
                                                passwordError = null;
                                              });

                                              final email =
                                                  emailController.text.trim();
                                              final password =
                                                  passwordController.text
                                                      .trim();

                                              if (email.isEmpty ||
                                                  !email.contains('@')) {
                                                setState(() {
                                                  emailError =
                                                      'Email is required';
                                                });
                                                return;
                                              }

                                              if (password.isEmpty) {
                                                setState(() {
                                                  passwordError =
                                                      'Password is required';
                                                });
                                                return;
                                              }
                                              final user = User(
                                                id: '',
                                                email: email,
                                                password: password,
                                              );
                                              BlocProvider.of<AuthBloc>(context)
                                                  .add(UserLogin(user));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF6E88A1),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Login',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Don't have an account?",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 73, 69, 69),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegistrationScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Sign up',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800,
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color(0xFF6E88A1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

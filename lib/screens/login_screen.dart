import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/screens/admin_panel_screen.dart';
import 'package:aj_autofix/screens/home.dart';
import 'package:aj_autofix/screens/registration_screen.dart';
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Login Success'),
                          behavior: SnackBarBehavior.floating),
                    );
                    if (state.role == 'user') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    } else if (state.role == 'admin' ||
                        state.role == 'service manager') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminPanelScreen()));
                    }
                  } else if (state is AuthFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                    BlocProvider.of<AuthBloc>(context).add(AuthReset());
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    Center( 
                      child: SizedBox(
                        width: screenWidth * 0.9,
                        height: 550,
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
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
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
                                            const EdgeInsets.symmetric(
                                                horizontal: 23.0, vertical: 12.0),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          },
                                          icon: _isPasswordVisible
                                              ? const Icon(
                                                  Icons.visibility_outlined)
                                              : const Icon(
                                                  Icons.visibility_off_outlined),
                                        ),
                                        hintText: 'Password',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
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
                                            final email = emailController.text;
                                            final password =
                                                passwordController.text;
                                            final user = User(
                                              id: '',
                                              email: email,
                                              password: password,
                                            );
                                            BlocProvider.of<AuthBloc>(context)
                                                .add(UserLogin(user));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            padding: const EdgeInsets.symmetric(
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
                                        color: Color.fromARGB(255, 73, 69, 69),
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
                                          decoration: TextDecoration.underline,
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

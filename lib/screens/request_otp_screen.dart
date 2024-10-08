import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart'; 
import 'package:aj_autofix/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestOtpScreen extends StatefulWidget {
  const RequestOtpScreen({super.key});

  @override
  RequestOtpScreenState createState() => RequestOtpScreenState();
}

class RequestOtpScreenState extends State<RequestOtpScreen> {
  final TextEditingController emailController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpRequestSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ResetPasswordScreen(email: emailController.text.trim()),
              ),
            );
          } else if (state is OtpRequestFailed) {
            setState(() {
              errorMessage = state.error;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lock_reset,
                    size: 120.0,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Reset Your Password',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Please enter your email address to receive an OTP for password reset.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                  const SizedBox(height: 24.0),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.deepPurple),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.deepPurple),
                      ),
                      prefixIcon:
                          const Icon(Icons.email, color: Colors.deepPurple),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        errorMessage = null;
                      });
                    },
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage!,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String email = emailController.text.trim();

                      if (email.isNotEmpty) {
                        setState(() {
                          errorMessage = null;
                        });

                        BlocProvider.of<AuthBloc>(context)
                            .add(RequestOtp(email));
                      } else {
                        setState(() {
                          errorMessage = 'Please enter your email';
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 127.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Request OTP',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

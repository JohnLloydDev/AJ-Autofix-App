import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/screens/login_screen.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final TextEditingController newPasswordController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: kAppBar,
        ),
        title: const Text(
          'OTP Verification',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is PasswordResetSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            } else if (state is PasswordResetFailed) {
              setState(() {
                errorText = state.error;
              });
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Reset Your Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(Icons.lock_reset, size: 120, color: kPrimaryColor),
                const SizedBox(height: 20),
                Text(
                  'Enter the OTP sent to ${widget.email}, and your new password:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: otpControllers
                      .map((controller) => _otpTextField(controller))
                      .toList(),
                ),
                const SizedBox(height: 20),
                _passwordTextField(),
                if (errorText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
                const SizedBox(height: 20),
                _resetButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpTextField(TextEditingController controller) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  Widget _passwordTextField() {
    return TextField(
      controller: newPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'New Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _resetButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          String otp = otpControllers.map((c) => c.text).join('');
          String newPassword = newPasswordController.text.trim();

          if (otp.isEmpty || newPassword.isEmpty || otp.length < 6) {
            setState(() {
              errorText = 'Please enter a valid OTP and a new password';
            });
          } else {
            setState(() {
              errorText = null;
            });

            BlocProvider.of<AuthBloc>(context)
                .add(ResetPassword(widget.email, otp, newPassword));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kMainColor,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Softer corners
          ),
          elevation: 4, // Soft shadow for iPhone-like depth effect
          shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow color
        ),
        child: const Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold, // Slightly bolder text
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    newPasswordController.dispose();
    super.dispose();
  }
}

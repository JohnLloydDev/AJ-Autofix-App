import 'dart:io';

import 'package:aj_autofix/models/user_model.dart';

abstract class AuthRepository {
  Future<User> userRegistration(User user, File? profilePicture);
  Future<User> userLogin(User user);
  Future<void> userLogout(); 
  Future<bool> verifyUserEmail(String token);
  Future<bool> resendVerificationEmail(String email);
  Future<void> requestOtp(String email);
  Future<void> resetPasswordWithOtp(String email, String otp, String newPassword);
}

import 'dart:convert';
import 'dart:io';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/repositories/auth_repository.dart';
import 'package:aj_autofix/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> userLogin(User user) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': user.email, 'password': user.password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data['token'] as String?;
      if (token == null) throw Exception('Access token is missing');

      await SecureStorage.storeToken('access_token', token);
      final userData = data['user'] as Map<String, dynamic>?;
      if (userData == null) throw Exception('User data is missing');

      return User.fromJson(userData);
    } else if (response.statusCode == 401) {
      final errorBody = jsonDecode(response.body);
      if (errorBody['message'] == 'Invalid email or password') {
        throw Exception('Invalid email or password');
      }
    } else if (response.statusCode == 403) {
      final errorBody = jsonDecode(response.body);
      if (errorBody['message'] == 'Email not verified') {
        throw Exception('Email not verified');
      }
    } else {
      final errorData = jsonDecode(response.body) as Map<String, dynamic>;
      final errorMessage = errorData['message'] ?? 'Failed to log in';
      throw Exception(errorMessage);
    }
    throw Exception('Failed to register: ${response.reasonPhrase}');
  }

  @override
  Future<User> userRegistration(User user, File? profilePicture) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiConstants.baseUrl}/auth/registration'));

    request.fields['fullname'] = user.fullname;
    request.fields['username'] = user.username;
    request.fields['email'] = user.email;
    request.fields['contactNumber'] = user.contactNumber;
    request.fields['password'] = user.password;

    if (profilePicture != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'profilePicture', profilePicture.path));
    }

    var response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final data = jsonDecode(responseBody);
      final registeredUser = User.fromJson(data);
      return registeredUser;
    } else if (response.statusCode == 400) {
      final errorBody = jsonDecode(responseBody);
      if (errorBody['message'] == 'Email already exists') {
        throw Exception('Email already exists');
      } else if (errorBody['message'] == 'Username already exists') {
        throw Exception('Username already exists');
      }
    } else if (response.statusCode == 500) {
      throw Exception('Server error: ${response.reasonPhrase}');
    }

    throw Exception('Failed to register: ${response.reasonPhrase}');
  }

  @override
  Future<void> userLogout() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();

    final accessToken = await SecureStorage.readToken('access_token');

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/logout'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      await secureStorage.delete(key: 'access_token');
    } else {
      throw Exception('Failed to log out: ${response.reasonPhrase}');
    }
  }

  @override
  Future<bool> verifyUserEmail(String token) async {
    final encodedToken = Uri.encodeComponent(token);

    final response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}/auth/verify-email?token=$encodedToken'));

    try {
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception('Invalid or expired token');
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Failed to verify email');
      }
    } catch (e) {
      throw Exception('Error during email verification');
    }
  }

  @override
  Future<bool> resendVerificationEmail(String email) async {
    const url = '${ApiConstants.baseUrl}/auth/resend-verification';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> requestOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/request-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        debugPrint("OTP sent to your email.");
      } else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'Email not found') {
          throw Exception(
              'The provided email address was not found. Please check and try again.');
        } else {
          throw Exception(responseData['message']);
        }
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Unexpected error. Please try again.');
      }
    } catch (error) {
      debugPrint("Error in requesting OTP: $error");
      rethrow;
    }
  }

  @override
  Future<void> resetPasswordWithOtp(
      String email, String otp, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/reset-password-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        if (errorBody['message'] == 'Invalid OTP') {
          throw Exception('Invalid OTP. Please check and try again.');
        } else if (errorBody['message'] == 'OTP has expired') {
          throw Exception('OTP has expired. Please request a new OTP.');
        } else if (errorBody['message'] == 'Email not found') {
          throw Exception('Email not found. Please check your email address.');
        } else {
          throw Exception('Failed to reset password: ${errorBody['message']}');
        }
      } else if (response.statusCode == 500) {
        throw Exception(
            'Server error: ${response.reasonPhrase}. Please try again later.');
      } else {
        throw Exception('Unexpected error: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception("Failed to reset password: $error");
    }
  }
}

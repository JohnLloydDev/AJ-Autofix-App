import 'dart:convert';
import 'dart:io';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/repositories/auth_repository.dart';
import 'package:aj_autofix/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl implements AuthRepository {
  static const String baseUrl = "http://10.0.2.2:3000/api/";

  @override
  Future<User> userLogin(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
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
    }
    final errorMessage =
        jsonDecode(response.body).cast<String, dynamic>()['message'] ??
            'Failed to log in';
    throw Exception(errorMessage);
  }

  @override
  Future<User> userRegistration(User user, File? profilePicture) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/registration'));

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

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      final registeredUser = User.fromJson(data);
      return registeredUser;
    } else {
      throw Exception('Failed to register: ${response.reasonPhrase}');
    }
  }
}

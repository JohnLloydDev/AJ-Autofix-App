import 'dart:convert';
import 'dart:io';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/repositories/auth_repository.dart';
import 'package:aj_autofix/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

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
    }
    final errorMessage =
        jsonDecode(response.body).cast<String, dynamic>()['message'] ??
            'Failed to log in';
    throw Exception(errorMessage);
  }

@override
Future<User> userRegistration(User user, File? profilePicture) async {
  var request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.baseUrl}/auth/registration'));

  request.fields['fullname'] = user.fullname;
  request.fields['username'] = user.username;
  request.fields['email'] = user.email;
  request.fields['contactNumber'] = user.contactNumber;
  request.fields['password'] = user.password;

  if (profilePicture != null) {
    request.files.add(await http.MultipartFile.fromPath('profilePicture', profilePicture.path));
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
  }
  throw Exception('Failed to register: ${response.reasonPhrase}');
}


  @override
  Future<void> userLogout() async {
    final accessToken = await SecureStorage.readToken('access_token');

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/logout'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to log out: ${response.reasonPhrase}');
    }

    await SecureStorage.deleteToken('access_token');
  }
}

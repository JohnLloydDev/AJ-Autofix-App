import 'dart:convert';

import 'package:aj_autofix/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/repositories/admin_repository.dart';

class AdminRepositoryImpl extends AdminRepository {
  static const String baseUrl = "https://aj-auto-fix.vercel.app/api";

  @override
  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete student: ${response.reasonPhrase}');
    }
  }

  @override
  Future<List<User>> getUser() async {
    final response = await http.get(Uri.parse("$baseUrl/users/"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Future<User> getUsers(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to load user with ID: $id');
    }
  }

  @override
  Future<void> updateUser(String id, User user) async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final userJson = jsonEncode(user.toJson());

    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: userJson,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.reasonPhrase}');
    }
  }

  @override
  Future<void> userUpdate(User user) async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final userJson = jsonEncode(user.toJson());
    final response = await http.put(
      Uri.parse('$baseUrl/update'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: userJson,
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update user. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<User> getUserByAuth() async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/user/getUser'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return User.fromJson(responseData);
    } else {
      throw Exception(
          'Failed to fetch user. Status code: ${response.statusCode}');
    }
  }
}

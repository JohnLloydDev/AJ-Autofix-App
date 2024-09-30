import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactRepositoryImpl {
  final String baseUrl = 'https://aj-auto-fix.vercel.app/api';

  Future<bool> sendContact(String name, String email, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contacts/contacts'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to send contact message: ${response.body}');
    }
  }
}

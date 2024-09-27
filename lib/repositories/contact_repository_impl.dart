import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactRepository {
  final String baseUrl = 'https://aj-auto-fix.vercel.app/api';

  Future<bool> sendContactEmail(String name, String email, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contact'), // Adjust the endpoint accordingly
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
      // Handle error
      return false;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
class ContactRepositoryImpl {


  Future<bool> sendContact(String name, String email, String message) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/contacts/contacts'),
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

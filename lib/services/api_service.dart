// import 'dart:convert';
// import 'package:aj_autofix/models/user_model.dart';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = 'https://aj-auto-fix-api.vercel.app/api/';

//   Future<User> userRegistration(User user, String username) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/registration'),
//       headers: <String, String>{
//         'Content-type': 'application/json; Charset=UTF-8',
//       },
//       body: jsonEncode(user.toJson()),
//     );
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
//     } else {
//       throw Exception(
//           'Registration Failed, Status Code: ${response.statusCode}');
//     }
//   }

//   Future<User> userLogin(User user, String password) async {
//     final response = await http.post(Uri.parse('$baseUrl/login'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; Charser=UTF-8'
//         },
//         body: jsonEncode(user.toJson()));
//     if (response.statusCode == 200) {
//       return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
//     } else {
//       throw Exception('Login Failed StatusCode:${response.statusCode}');
//     }
//   }
// }

import 'dart:convert';
import 'package:aj_autofix/models/review_model.dart';
import 'package:aj_autofix/repositories/review_repository.dart';
import 'package:aj_autofix/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class ReviewRepositoryImpl extends ReviewRepository {
  static const String baseUrl = "https://aj-auto-fix.vercel.app/api";

  @override
  Future<List<Review>> getAllReviews() async {
    final accessToken = await SecureStorage.readToken('access_token');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse("$baseUrl/reviews/reviews"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Ensure you are accessing the 'reviews' key
      if (jsonResponse['success'] == true) {
        final List<dynamic> jsonData =
            jsonResponse['reviews']; // Accessing the reviews list
        return jsonData.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Reviews: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load Reviews: ${response.body}');
    }
  }

  @override
  Future<void> createReviews(Review review) async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/reviews/reviews'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(review.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create review: ${response.body}');
    }
  }
}

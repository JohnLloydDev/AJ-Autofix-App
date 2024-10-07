import 'dart:convert';
import 'package:aj_autofix/models/review_model.dart';
import 'package:aj_autofix/repositories/review_repository.dart';
import 'package:aj_autofix/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ReviewRepositoryImpl extends ReviewRepository {
  @override
  Future<List<Review>> getAllReviews() async {
    final accessToken = await SecureStorage.readToken('access_token');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/reviews/reviews"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == true) {
        final List<dynamic>? jsonData = jsonResponse['reviews'];

        if (jsonData != null) {
          return jsonData.map((json) => Review.fromJson(json)).toList();
        } else {
          throw Exception('Reviews key is null or not a list');
        }
      } else {
        throw Exception('Failed to load Reviews: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load Reviews: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> createReviews(Review review) async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/reviews/reviews'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw Exception('Invalid JSON response: ${response.body}');
      }
    } else {
      throw Exception('Failed to create review: ${response.body}');
    }
  }
}

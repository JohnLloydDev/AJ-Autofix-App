import 'dart:convert';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'package:aj_autofix/models/booking_model.dart';
import 'package:aj_autofix/repositories/booking_repository.dart';
import 'package:aj_autofix/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class BookingRepositoryImpl extends BookingRepository {
  @override
  Future<List<Booking>> getAllBooking() async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/bookings/bookings/"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  @override
  Future<Booking> acceptBooking(String id) async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/bookings/bookings/$id/accept'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return Booking.fromJson(json.decode(response.body)['booking']);
    } else {
      throw Exception('Failed to accept booking');
    }
  }

  @override
  Future<Booking> cancelBooking(String id) async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/bookings/booking/$id/cancel'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return Booking.fromJson(json.decode(response.body)['booking']);
    } else {
      throw Exception('Failed to cancel booking');
    }
  }

  @override
  Future<Booking> rejectBooking(String id) async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/bookings/bookings/$id/reject'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return Booking.fromJson(json.decode(response.body)['booking']);
    } else {
      throw Exception('Failed to reject booking');
    }
  }

  @override
  Future<Booking> completeBooking(String id) async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/bookings/bookings/$id/complete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return Booking.fromJson(json.decode(response.body)['booking']);
    } else {
      throw Exception('Failed to reject booking');
    }
  }

  @override
  Future<Booking> getBookingById(String id) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}l/bookings/bookings/get/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> booking = json.decode(response.body);
      return Booking.fromJson(booking);
    } else {
      throw Exception('Failed to load booking with ID: $id');
    }
  }

  @override
  Future<List<Booking>> getAllPendingBooking() async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/bookings/admin/bookings/pending"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  @override
  Future<List<Booking>> getAllAcceptedBooking() async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/bookings/admin/bookings/accepted"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  @override
  Future<Booking> createBooking(String id, Booking booking) async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/bookings/bookings/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(booking.toJson()),
    );

    final responseBody = response.body;

    if (response.statusCode == 201) {
      return Booking.fromJson(jsonDecode(responseBody));
    } else if (response.statusCode == 400) {
      final errorBody = jsonDecode(responseBody);
      if (errorBody['message'] ==
          'The selected time is already occupied. Please choose another time.') {
        throw Exception(
            'The selected time is already occupied. Please choose another time.');
      } else {
        throw Exception(
            'Failed to create booking: ${response.statusCode} ${errorBody['message']}');
      }
    } else {
      throw Exception(
          'Failed to create booking: ${response.statusCode} $responseBody');
    }
  }

  @override
  Future<List<Booking>> getUserBooking() async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/bookings/bookings/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Booking.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      final errorBody = jsonDecode(responseBody);
      if (errorBody['message'] == 'No bookings found for this user') {
        return [];
      } else {
        throw Exception('Failed to load bookings');
      }
    } else {
      throw Exception('Unexpected error occurred: ${response.statusCode}');
    }
  }

  @override
  Future<int> getNewBookingCount() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/bookings/new/count'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'];
    } else {
      throw Exception('Failed to fetch new booking count');
    }
  }

  @override
  Future<void> markBookingsAsViewed() async {
    final response = await http.put(
        Uri.parse("${ApiConstants.baseUrl}/bookings/viewed"),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw Exception('Failed to mark bookings as viewed: ${response.body}');
    }
  }

  @override
  Future<int> getNewUserBookingCount() async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    debugPrint('Access token: $accessToken');

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/bookings/bookings/new-count'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as Map<String, dynamic>;

      if (responseBody.containsKey('totalCount')) {
        final count = responseBody['totalCount'] as int;
        debugPrint('New booking count: $count');
        return count;
      } else {
        throw Exception('totalCount not found in the response');
      }
    } else {
      debugPrint('Failed response: ${response.body}');
      throw Exception('Failed to fetch new booking count');
    }
  }

  @override
  Future<void> markUserBookingsAsViewed() async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/bookings/userBooking/user-viewed"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark bookings as viewed: ${response.body}');
    }
  }
}

import 'dart:convert';

import 'package:aj_autofix/models/booking_model.dart';
import 'package:aj_autofix/repositories/booking_repository.dart';
import 'package:aj_autofix/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class BookingRepositoryImpl extends BookingRepository {
  static const String baseUrl = "https://aj-auto-fix.vercel.app/api";
  @override
  Future<List<Booking>> getAllBooking() async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse("$baseUrl/bookings/bookings/"),
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
      Uri.parse('$baseUrl/bookings/bookings/$id/accept'),
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
  Future<Booking> rejectBooking(String id) async {
    final accessToken = await SecureStorage.readToken('access_token');

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    final response = await http.put(
      Uri.parse('$baseUrl/bookings/bookings/$id/reject'),
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
      Uri.parse('$baseUrl/bookings/bookings/$id/complete'),
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
      Uri.parse('$baseUrl/bookings/bookings/get/$id'),
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
      Uri.parse("$baseUrl/bookings/admin/bookings/pending"),
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
      Uri.parse("$baseUrl/bookings/admin/bookings/accepted"),
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
      Uri.parse('$baseUrl/bookings/bookings/'),
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
      if (errorBody['message'] == 'The selected time is already occupied. Please choose another time.') {
        throw Exception('The selected time is already occupied. Please choose another time.');
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
      Uri.parse('$baseUrl/bookings/bookings/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('failed to load bookings');
    }
  }
}

import 'package:aj_autofix/models/user_model.dart';
import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String? id;
  final User? user;
  final List<String> serviceType;
  final String vehicleType;
  final String time;
  final DateTime date;
  final String status;

  const Booking({
    this.id,
    this.user,
    required this.serviceType,
    required this.vehicleType,
    required this.time,
    required this.date,
    this.status = 'pending',
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      user: json['userId'] != null ? User.fromJson(json['userId']) : null,
      serviceType: List<String>.from(json['serviceType'] ?? []),
      vehicleType: json['vehicleType'] ?? '',
      time: json['time'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user?.toJson(),
      'serviceType': serviceType,
      'vehicleType': vehicleType,
      'time': time,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  @override
  List<Object?> get props =>
      [id, user, serviceType, vehicleType, time, date, status];
}

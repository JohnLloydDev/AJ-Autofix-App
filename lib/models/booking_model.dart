import 'package:equatable/equatable.dart';
import 'package:aj_autofix/models/user_model.dart'; 

class Booking extends Equatable {
  final String? id;
  final String? userId;
  final User? user;
  final List<String> serviceType;
  final String vehicleType;
  final String time;
  final DateTime date;
  final String status;

  const Booking({
    this.id,
    this.userId, 
    this.user, 
    required this.serviceType,
    required this.vehicleType,
    required this.time,
    required this.date,
    this.status = 'pending',
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String?,
      userId: json['userId'] is String ? json['userId'] : json['userId']?['id'] as String?, 
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      serviceType: List<String>.from(json['serviceType'] ?? []),
      vehicleType: json['vehicleType'] ?? '',
      time: json['time'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId, 
      'user': user?.toJson(), 
      'serviceType': serviceType,
      'vehicleType': vehicleType,
      'time': time,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, userId, user, serviceType, vehicleType, time, date, status];
}



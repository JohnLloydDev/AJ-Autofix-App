import 'package:equatable/equatable.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:intl/intl.dart';

class Booking extends Equatable {
  final String? id;
  final String? userId;
  final User? user;
  final List<String> serviceType;
  final String vehicleType;
  final String? time;
  final DateTime date;
  final String status;
  final String createdAt;
  final bool viewedByUser;
  final bool viewedByAdmin;

  Booking({
    this.id,
    this.userId,
    this.user,
    required this.serviceType,
    required this.vehicleType,
    this.time,
    required this.date,
    this.status = 'pending',
    this.viewedByUser = false,
    this.viewedByAdmin = false,
    String? createdAt,
  }) : createdAt = createdAt ??
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String?,
      userId: json['userId'] is String
          ? json['userId']
          : json['userId']?['id'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      serviceType: List<String>.from(json['serviceType'] ?? []),
      vehicleType: json['vehicleType'] ?? '',
      time: json['time'] as String?,
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      status: json['status'] ?? 'pending',
      viewedByUser: json['viewedByUser'] ?? false,
      viewedByAdmin: json['viewedByAdmin'] ?? false,
      createdAt: json['createdAt'] as String? ??
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
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
      'viewedByUser': viewedByUser,
      'viewedByAdmin': viewedByAdmin,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        user,
        serviceType,
        vehicleType,
        time,
        date,
        status,
        viewedByUser,
        viewedByAdmin,
        createdAt,
      ];
}

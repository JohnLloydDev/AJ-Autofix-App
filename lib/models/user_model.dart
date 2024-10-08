import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? profilePicture;
  final String fullname;
  final String username;
  final String email;
  final String contactNumber;
  final String password;
  final String role;
  final bool isVerified;
  final String? verificationToken;
  final String? otp;
  final DateTime? otpExpiration;

  const User({
    this.role = 'user',
    required this.id,
    this.profilePicture,
    this.fullname = '',
    this.username = '',
    this.email = '',
    this.contactNumber = '',
    this.password = '',
    this.isVerified = false,
    this.verificationToken,
    this.otp,
    this.otpExpiration,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      profilePicture: json['profilePicture'] as String?,
      fullname: json['fullname'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      contactNumber: json['contactNumber'] as String? ?? '',
      password: json['password'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      isVerified: json['isVerified'] as bool? ?? false,
      verificationToken: json['verificationToken'] as String?,
      otp: json['otp'] as String?,
      otpExpiration: json['otpExpiration'] != null
          ? DateTime.parse(json['otpExpiration'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'profilePicture': profilePicture,
      'fullname': fullname,
      'username': username,
      'email': email,
      'contactNumber': contactNumber,
      'password': password,
      'role': role,
      'isVerified': isVerified,
      'verificationToken': verificationToken,
      'otp': otp,
      'otpExpiration': otpExpiration?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        profilePicture,
        fullname,
        username,
        email,
        contactNumber,
        password,
        role,
        isVerified,
        verificationToken,
        otp,
        otpExpiration,
      ];
}

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

  const User({
    this.role = 'user',
    required this.id,
    this.profilePicture,
    this.fullname = '',
    this.username = '',
    this.email = '',
    this.contactNumber = '',
    this.password = '',
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
        role
      ];
}

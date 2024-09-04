import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String fullname;
  final String username;
  final String email;
  final String contactNumber;
  final String password;

  const User(
      {required this.id,
      required this.fullname,
      required this.username,
      required this.email,
      required this.contactNumber,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        fullname: json['fullname'],
        username: json['username'],
        email: json['email'],
        contactNumber: json['contactNumber'],
        password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'username': username,
      'email': email,
      'contactNumber': contactNumber,
    };
  }

  @override
  List<Object> get props => [fullname, username, email, contactNumber, password];
}

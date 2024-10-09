import 'dart:io';
import 'package:aj_autofix/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class UserRegistration extends AuthEvent {
  final User user;
  final File? profilePicture;

  const UserRegistration(this.user, this.profilePicture);

  @override
  List<Object> get props => [user, profilePicture ?? ''];
}

class VerifyEmail extends AuthEvent {
  final String token;

  const VerifyEmail(this.token);

  @override
  List<Object> get props => [token];
}

class ResendVerification extends AuthEvent {
  final String email;
  const ResendVerification(this.email);

  @override
  List<Object> get props => [email];
}

class UserLogin extends AuthEvent {
  final User user;

  const UserLogin(this.user);

  @override
  List<Object> get props => [user];
}

class RequestOtp extends AuthEvent {
  final String email;

  const RequestOtp(this.email);

  @override
  List<Object> get props => [email];
}

class ResetPassword extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPassword(this.email, this.otp, this.newPassword);

  @override
  List<Object> get props => [email, otp, newPassword];
}

class LogoutRequest extends AuthEvent {}

class AuthReset extends AuthEvent {}

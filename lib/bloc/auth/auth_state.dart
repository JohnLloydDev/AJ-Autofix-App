import 'package:aj_autofix/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthIsProcessing extends AuthState {}

class AuthSucceed extends AuthState {
    final User user;
  final String message;

  const AuthSucceed(this.message, this.user);

  @override
  List<Object> get props => [message, user];
}

class LogoutSucceed extends AuthState {
  final String message;

  const LogoutSucceed(this.message);

  @override
  List<Object> get props => [message];
}

class AuthFailed extends AuthState {
  final String error;

  const AuthFailed(this.error);

  @override
  List<Object> get props => [error];
}

class AuthLoggedOut extends AuthState {}

class AuthSuccessWithRole extends AuthState {
  final User user;
  final String role;

  const AuthSuccessWithRole(this.role, this.user);

  @override
  List<Object> get props => [role, user];
}

class EmailVerificationSuccess extends AuthState {}

class EmailVerificationFailed extends AuthState {
  final String error;

  const EmailVerificationFailed(this.error);

  @override
  List<Object?> get props => [error];
}

class VerificationEmailSent extends AuthState {
  final String message;
  const VerificationEmailSent(this.message);

  @override
  List<Object?> get props => [message];
}

class VerificationEmailError extends AuthState {
  final String error;
  const VerificationEmailError(this.error);

  @override
  List<Object?> get props => [error];
}

class OtpRequestSuccess extends AuthState {
  final String message;

  const OtpRequestSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OtpRequestFailed extends AuthState {
  final String error;

  const OtpRequestFailed(this.error);

  @override
  List<Object?> get props => [error];
}

class PasswordResetSuccess extends AuthState {
  final String message;

  const PasswordResetSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordResetFailed extends AuthState {
  final String error;

  const PasswordResetFailed(this.error);

  @override
  List<Object?> get props => [error];
}

class InvalidOtpState extends AuthState {
  final String error;

  const InvalidOtpState(this.error);

  @override
  List<Object?> get props => [error];
}

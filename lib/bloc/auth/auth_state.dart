import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthIsProcessing extends AuthState {}

class AuthSucceed extends AuthState {
  final String message;

  const AuthSucceed(this.message);

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
  final String role;

  const AuthSuccessWithRole(this.role);

  @override
  List<Object> get props => [role];
}



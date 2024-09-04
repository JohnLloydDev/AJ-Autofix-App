part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthIsProcessing extends AuthState {}

class AuthSucceed extends AuthState {
  final String message;

  AuthSucceed(this.message);

  @override
  List<Object> get props => [message];
}

class AuthFailed extends AuthState {
  final String error;

  AuthFailed(this.error);

  @override
  List<Object> get props => [error];
  }


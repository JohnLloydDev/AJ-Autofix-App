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

class UserLogin extends AuthEvent {
  final User user;

  const UserLogin(this.user);

  @override
  List<Object> get props => [user];
}
class AuthReset extends AuthEvent {}

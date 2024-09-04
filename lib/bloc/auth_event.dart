import 'package:equatable/equatable.dart';
import 'package:aj_autofix/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserRegistration extends AuthEvent {
  final User user;

  UserRegistration(this.user);

  @override
  List<Object> get props => [user];
}

class UserLogin extends AuthEvent {
  final User user;

  UserLogin(this.user);

  @override
  List<Object> get props => [user];
  }


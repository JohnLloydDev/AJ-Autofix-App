import 'package:aj_autofix/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserDataLoading extends UserState {}

class UserDataLoaded extends UserState {
  final List<User> userdata;

  const UserDataLoaded(this.userdata);

  @override
  List<Object> get props => [userdata];
}

class UserDataLoadedById extends UserState {
  final User user;

  const UserDataLoadedById(this.user);

  @override
  List<Object> get props => [user];
}

class UserDataLoadedByAuth extends UserState {
  final User user;

  const UserDataLoadedByAuth(this.user);

  @override
  List<Object> get props => [user];
}

class UserDataSuccess extends UserState {
  final String message;

  const UserDataSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UserDataError extends UserState {
  final String message;

  const UserDataError(this.message);

  @override
  List<Object> get props => [message];
}



import 'package:aj_autofix/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object> get props => [];
}

class GetUsers extends UserEvent {}

class GetUsersById extends UserEvent {
  final String id;

  const GetUsersById(this.id);

  @override
  List<Object> get props => [];
  }


class DeleteUser extends UserEvent {
  final String id;

  const DeleteUser(this.id);
  @override
  List<Object> get props => [id];
}

class UpdateUser extends UserEvent {
  final String id;
  final User user;

  const UpdateUser(this.id, this.user);

  @override
  List<Object> get props => [id, user];
}

class AdminReset extends UserEvent{}


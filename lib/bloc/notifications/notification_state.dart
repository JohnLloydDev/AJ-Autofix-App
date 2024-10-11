
import 'package:equatable/equatable.dart';


abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final int notificationCount;

  const NotificationLoaded(this.notificationCount);

  @override
  List<Object?> get props => [ notificationCount];
}

class NotificationError extends NotificationState {
  final String error;

  const NotificationError(this.error);

  @override
  List<Object?> get props => [error];
}
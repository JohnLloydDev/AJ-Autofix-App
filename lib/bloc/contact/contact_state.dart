// contact_state.dart
abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactSubmitting extends ContactState {}

class ContactSuccess extends ContactState {}

class ContactFailure extends ContactState {
  final String errorMessage;

  ContactFailure(this.errorMessage);
}

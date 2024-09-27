abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactSending extends ContactState {}

class ContactSentSuccess extends ContactState {}

class ContactSentFailure extends ContactState {
  final String error;

  ContactSentFailure(this.error);
}
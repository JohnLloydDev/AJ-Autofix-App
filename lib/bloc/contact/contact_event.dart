abstract class ContactEvent {}

class SendContactEmailEvent extends ContactEvent {
  final String name;
  final String email;
  final String message;

  SendContactEmailEvent({required this.name, required this.email, required this.message});
}
// contact_event.dart
abstract class ContactEvent {}

class SendContactEvent extends ContactEvent {
  final String name;
  final String email;
  final String message;

  SendContactEvent({required this.name, required this.email, required this.message});
}

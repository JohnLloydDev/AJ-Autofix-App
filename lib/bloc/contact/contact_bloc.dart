import 'package:aj_autofix/bloc/contact/contact_event.dart';
import 'package:aj_autofix/bloc/contact/contact_state.dart';
import 'package:aj_autofix/repositories/contact_repository_impl.dart';
import 'package:bloc/bloc.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository contactRepository;

  ContactBloc(this.contactRepository) : super(ContactInitial());

  Stream<ContactState> mapEventToState(ContactEvent event) async* {
    if (event is SendContactEmailEvent) {
      yield ContactSending();
      try {
        bool success = await contactRepository.sendContactEmail(event.name, event.email, event.message);
        if (success) {
          yield ContactSentSuccess();
        } else {
          yield ContactSentFailure('Failed to send message');
        }
      } catch (e) {
        yield ContactSentFailure(e.toString());
      }
    }
  }
}
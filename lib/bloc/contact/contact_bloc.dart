import 'package:aj_autofix/bloc/contact/contact_event.dart';
import 'package:aj_autofix/bloc/contact/contact_state.dart';
import 'package:aj_autofix/repositories/contact_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepositoryImpl contactRepository;

  ContactBloc(this.contactRepository) : super(ContactInitial()) {
    on<SendContactEvent>(_onSendContact);
  }

  Future<void> _onSendContact(SendContactEvent event, Emitter<ContactState> emit) async {
    emit(ContactSubmitting());

    try {
      final isSuccess = await contactRepository.sendContact(event.name, event.email, event.message);
      if (isSuccess) {
        emit(ContactSuccess());
      } else {
        emit(ContactFailure("Failed to send contact message"));
      }
    } catch (e) {
      emit(ContactFailure(e.toString()));
    }
  }
}

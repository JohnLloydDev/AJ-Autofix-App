import 'package:aj_autofix/bloc/contact/contact_bloc.dart';
import 'package:aj_autofix/bloc/contact/contact_event.dart';
import 'package:aj_autofix/bloc/contact/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ContactFormPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  ContactFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state is ContactSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Contact message sent successfully!'),
              backgroundColor: Colors.green,
            ));
          } else if (state is ContactFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to send message: ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          if (state is ContactSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(labelText: 'Message'),
                  maxLines: 5,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ContactBloc>().add(SendContactEvent(
                      name: nameController.text,
                      email: emailController.text,
                      message: messageController.text,
                    ));
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
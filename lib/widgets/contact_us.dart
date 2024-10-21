import 'package:aj_autofix/bloc/contact/contact_bloc.dart';
import 'package:aj_autofix/bloc/contact/contact_event.dart';
import 'package:aj_autofix/bloc/contact/contact_state.dart';
import 'package:aj_autofix/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactFormContainer extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;

  const ContactFormContainer({
    required this.nameController,
    required this.emailController,
    required this.messageController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state is ContactSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Contact message sent successfully!'),
            backgroundColor: Colors.green,
          ));
          nameController.clear();
          emailController.clear();
          messageController.clear();
        } else if (state is ContactFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to send message: ${state.errorMessage}'),
            backgroundColor: Colors.red,
          ));
        }
      },
      builder: (context, state) {
        if (state is ContactSubmitting) {
          return const CustomLoading();
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 15),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLength: 30,
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  } else if (value.length > 30) {
                    return 'Name cannot exceed 30 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 15),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@gmail\.com$').hasMatch(value)) {
                    return 'Please enter a valid Gmail address';
                  }
                  return null;
                },
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: 'Message',
                  labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 15),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 5,
                maxLength: 500,
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  } else if (value.length > 500) {
                    return 'Message cannot exceed 500 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (emailController.text.contains('@gmail.com')) {
                      context.read<ContactBloc>().add(SendContactEvent(
                            name: nameController.text,
                            email: emailController.text,
                            message: messageController.text,
                          ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email must be a Gmail address.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 146, 176, 204),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Send Message',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

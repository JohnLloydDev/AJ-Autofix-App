import 'package:aj_autofix/bloc/contact/contact_bloc.dart';
import 'package:aj_autofix/bloc/contact/contact_event.dart';
import 'package:aj_autofix/bloc/contact/contact_state.dart';
import 'package:aj_autofix/repositories/contact_repository_impl.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFDCDCDC),
                Color(0xFF6E88A1),
              ],
            ),
          ),
        ),
        title: const Text('Contact Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => ContactBloc(ContactRepositoryImpl()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const ContactInfoContainer(),
                const SizedBox(height: 24),
                ContactFormContainer(
                  nameController: nameController,
                  emailController: emailController,
                  messageController: messageController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactInfoContainer extends StatelessWidget {
  const ContactInfoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phone),
              SizedBox(width: 8),
              Text('123-456-789'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.email),
              SizedBox(width: 8),
              Text('ajautofix123@gmail.com'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 8),
              Text('Mangaldan, Pangasinan Road'),
            ],
          ),
        ],
      ),
    );
  }
}

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
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
             
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: 200, 
                child: ElevatedButton(
                  onPressed: () {
                 context.read<ContactBloc>().add(SendContactEvent(
                      name: nameController.text,
                      email: emailController.text,
                      message: messageController.text,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6E88A1),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Send message',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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

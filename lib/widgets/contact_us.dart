import 'package:aj_autofix/utils/constants.dart';
import 'package:aj_autofix/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/contact/contact_bloc.dart';
import 'package:aj_autofix/bloc/contact/contact_state.dart';
import 'package:aj_autofix/bloc/contact/contact_event.dart';

class ContactFormContainer extends StatelessWidget {
  final TextEditingController messageController;

  const ContactFormContainer({
    required this.messageController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state is ContactSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Message sent successfully!'),
            backgroundColor: kGreenColor,
          ));
          messageController.clear();
        } else if (state is ContactFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to send message: ${state.errorMessage}'),
            backgroundColor: kRedColor,
          ));
        }
      },
      builder: (context, state) {
        if (state is ContactSubmitting) {
          return const CustomLoading();
        }

        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),  
                spreadRadius: 4, 
                blurRadius: 15,  
                offset: const Offset(0, 8), 
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Send us a message',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kBlackColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We will get back to you as soon as possible.',
                style: TextStyle(
                  fontSize: 14,
                  color: kBlackColor,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: 'Message',
                  labelStyle: const TextStyle(
                    color: kBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                    context.read<ContactBloc>().add(SendContactEvent(
                      name: 'dummyName',
                      email: 'dummyEmail@gmail.com', 
                      message: messageController.text,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMainColor,
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
                      fontSize: 17,
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

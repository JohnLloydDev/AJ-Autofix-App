import 'package:aj_autofix/bloc/contact/contact_bloc.dart';
import 'package:aj_autofix/repositories/contact_repository_impl.dart';
import 'package:aj_autofix/utils/constants.dart';

import 'package:aj_autofix/widgets/contact_us.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsScreen extends StatelessWidget {
  final TextEditingController messageController = TextEditingController();

  ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: kAppBar,
        ),
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: kBlackColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.angleLeft,
            color: kBlackColor,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => ContactBloc(ContactRepositoryImpl()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                const ContactInfoContainer(),
                const SizedBox(height: 24),
                ContactFormContainer(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.phone_android, color: kdarkColor, size: 30),
            SizedBox(width: 8),
            Text(
              '+639499729777',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.email, color: kdarkColor, size: 30),
            SizedBox(width: 8),
            Text(
              'ajautofix123@gmail.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on, color: kdarkColor, size: 30),
            SizedBox(width: 8),
            Text(
              'Bantayan, Mangaldan, Pangasinan Road',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: Image.asset(
            'assets/email.png',
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

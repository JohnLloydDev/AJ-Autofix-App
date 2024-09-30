// import 'package:aj_autofix/bloc/contact/contact_bloc.dart';
// import 'package:aj_autofix/bloc/contact/contact_event.dart';
// import 'package:aj_autofix/bloc/contact/contact_state.dart';
// import 'package:aj_autofix/repositories/contact_repository_impl.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ContactUsScreen extends StatefulWidget {
//   const ContactUsScreen({super.key});

//   @override
//   State<ContactUsScreen> createState() => _ContactUsScreenState();
// }

// class _ContactUsScreenState extends State<ContactUsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text('Contact Us'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: const Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ContactInfoContainer(),
//               SizedBox(height: 24),
//               ContactFormContainer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ContactInfoContainer extends StatelessWidget {
//   const ContactInfoContainer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: const Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.phone),
//               SizedBox(width: 8),
//               Text('123-456-789'),
//             ],
//           ),
//           SizedBox(height: 16),
//           Row(
//             children: [
//               Icon(Icons.email),
//               SizedBox(width: 8),
//               Text('abc12@gmail.com'), // Fixed the email typo
//             ],
//           ),
//           SizedBox(height: 16),
//           Row(
//             children: [
//               Icon(Icons.location_on),
//               SizedBox(width: 8),
//               Text('Mangaldan Pangasinan Road'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ContactFormContainer extends StatefulWidget {
//   const ContactFormContainer({super.key});

//   @override
//   State<ContactFormContainer> createState() => _ContactFormContainerState();
// }

// class _ContactFormContainerState extends State<ContactFormContainer> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ContactBloc(ContactRepositoryImpl()),
//       child: Container(
//         padding: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.grey.shade300),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: BlocListener<ContactBloc, ContactState>(
//           listener: (context, state) {
//             if (state is ContactSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Message sent successfully')),
//               );
//               nameController.clear();
//               emailController.clear();
//               messageController.clear();
//             } else if (state is ContactFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.error)),
//               );
//             }
//           },
//           child: Column(
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Name',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: messageController,
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   labelText: 'Message',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<ContactBloc>().add(SendContactEmailEvent(
//                     name: nameController.text,
//                     email: emailController.text,
//                     message: messageController.text,
//                   ));
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text('Send Message'),
//               ),
//               BlocBuilder<ContactBloc, ContactState>(
//                 builder: (context, state) {
//                   if (state is ContactLoading) {
//                     return const Padding(
//                       padding: EdgeInsets.only(top: 16.0),
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   return Container();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

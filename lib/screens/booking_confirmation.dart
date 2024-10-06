// import 'package:aj_autofix/screens/booking.dart';
// import 'package:aj_autofix/screens/home.dart';
// import 'package:flutter/material.dart';


// class BookingConfirmationScreen extends StatelessWidget {
//   final List<String> selectedServices;
//   final int selectedServiceCount;

//   const BookingConfirmationScreen({
//     super.key,
//     required this.selectedServices,
//     required this.selectedServiceCount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false, 
        
//         title: const Text('Booking Confirmed'),
//         backgroundColor: kPrimaryColor,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.check_circle, color: Colors.green[700], size: 100),
//             const SizedBox(height: 20),
//             const Text(
//               'Your booking has been successfully placed!',
//               style: TextStyle(fontSize: 18),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Home(
//                       selectedServices: selectedServices,
//                       selectedServiceCount: selectedServiceCount,
//                     ),
//                   ),
//                 );
//               },
//               child: const Text('Go to Home'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

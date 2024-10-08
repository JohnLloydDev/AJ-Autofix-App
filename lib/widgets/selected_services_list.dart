// import 'package:flutter/material.dart';

// class SelectedServicesList extends StatelessWidget {
//   final List<String> services;
//   final Function(int) onRemove;

//   const SelectedServicesList({
//     super.key,
//     required this.services,
//     required this.onRemove,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return services.isNotEmpty
//         ? ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: services.length,
//             itemBuilder: (context, index) {
//               final serviceName = services[index];
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: SizedBox(
//                   width: 350,
//                   height: 50,
//                   child: Card(
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               serviceName,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(
//                               Icons.remove_circle,
//                               color: Colors.red,
//                             ),
//                             onPressed: () => onRemove(index),
//                             tooltip: 'Remove Service',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           )
//         : const Text(
//             'No services selected.',
//             style: TextStyle(color: Colors.grey),
//           );
//   }
// }

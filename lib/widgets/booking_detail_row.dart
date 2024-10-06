// lib/widgets/booking_detail_row.dart

import 'package:flutter/material.dart';
import '../utils/color_extensions.dart';
import '../utils/constants.dart';

class BookingDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const BookingDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: kPrimaryColor,
        ),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kPrimaryColor.darken(0.1),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

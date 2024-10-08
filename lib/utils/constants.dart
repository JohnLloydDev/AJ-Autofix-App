import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = "https://aj-auto-fix.vercel.app/api";
}

// Padding and Spacing
const double kPadding = 16.0;
const double kSpacing = 16.0;

// Colors
const Color kPrimaryColor = Colors.lightBlue;
const Color kAccentColor = Colors.white;
const Color kMainColor = Color(0xFF6E88A1);

// Border Radius
const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(8.0));

// Gradient Decoration
const BoxDecoration kGradientBoxDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color.fromARGB(255, 130, 173, 209),
      Color.fromARGB(255, 255, 255, 255),
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  ),
);

// Gradient for AppBar
const BoxDecoration kAppBarGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFDCDCDC), // Light grey
      Color(0xFF6E88A1), // Main color
    ],
  ),
);

//Button shape
// Button Shape
final OutlinedBorder kButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
);
// Button Style

// Button Text Style

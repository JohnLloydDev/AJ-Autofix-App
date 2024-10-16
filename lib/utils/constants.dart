import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = "https://aj-auto-fix.vercel.app/api";
}

const double kPadding = 16.0;
const double kSpacing = 16.0;

const Color kPrimaryColor = Colors.lightBlue;
const Color kAccentColor = Colors.white;
const Color kMainColor = Color(0xFF6E88A1);
const Color kColor = Color.fromARGB(255, 110, 136, 161);

const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(8.0));

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


const BoxDecoration kAppBarGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFDCDCDC),
      Color(0xFF6E88A1),
    ],
  ),
);

const BoxDecoration kAppBar = BoxDecoration(
  color: Color.fromARGB(255, 146, 176, 204),
  borderRadius: BorderRadius.vertical(
    bottom: Radius.circular(23),
  ),
);

final OutlinedBorder kButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
);


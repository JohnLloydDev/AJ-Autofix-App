import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = "https://aj-auto-fix.vercel.app/api";
}

const double kPadding = 16.0;
const double kSpacing = 16.0;

const Color kPrimaryColor = Colors.lightBlue;
const Color kAccentColor = Colors.white;
const Color kMainColor = Color.fromRGBO(110, 136, 161, 1);
const Color kRedColor = Color.fromARGB(255, 255, 0, 34);
const Color kColor = Color.fromARGB(255, 146, 176, 204);
const Color kGreenColor = Color.fromRGBO(76, 175, 80, 1);
const Color kBlackColor = Color(0xFF000000);
const Color kBlueColor = Color.fromRGBO(0, 122, 255, 1);
const Color kdarkColor = Color.fromRGBO(0, 31, 63, 1);

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


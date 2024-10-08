import 'package:aj_autofix/utils/constants.dart';
import 'package:flutter/material.dart';

class IntroPage4 extends StatefulWidget {
  const IntroPage4({super.key});

  @override
  State<IntroPage4> createState() => _IntroPage4State();
}

class _IntroPage4State extends State<IntroPage4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:kGradientBoxDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/intropage4.png',
              height: 430,
              width: 430,
            ),
            const SizedBox(height: 5),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Select your service, enter your car’s make and model, choose a date and time, and confirm your booking',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(1.0, 1.0),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//'Select your service, enter your car’s make and model, choose a date and time, and confirm your booking',
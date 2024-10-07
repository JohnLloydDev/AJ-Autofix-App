import 'package:flutter/material.dart';

class IntroPage5 extends StatefulWidget {
  const IntroPage5({super.key});

  @override
  State<IntroPage5> createState() => _IntroPage5State();
}

class _IntroPage5State extends State<IntroPage5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 130, 173, 209),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/intropage5.png',
              height: 430,
              width: 430,
            ),
            const SizedBox(height: 5),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Check the Pending section to see if your reservation is pending, accepted, or declined. Once accepted, visit the shop at your scheduled time for your car repair',
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
//'Check the Pending section to see if your reservation is pending, accepted, or declined. Once accepted, visit the shop at your scheduled time for your car repair',
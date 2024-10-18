import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitFadingCube(
        color: Color.fromARGB(255, 146, 176, 204),
        size: 50.0,
      ),
    );
  }
}

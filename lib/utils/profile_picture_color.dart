import 'dart:math';
import 'package:flutter/material.dart';

Color getRandomBackgroundColor(String? name) {
  if (name == null || name.isEmpty) {
    return Colors.grey;
  }

  final random = Random(name.hashCode);
  return Color.fromARGB(
    255,
    random.nextInt(256), 
    random.nextInt(256), 
    random.nextInt(256), 
  );
}

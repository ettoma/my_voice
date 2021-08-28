import 'package:flutter/material.dart';

class AppColours {
  // Colours
  final buttonBackground = Color.fromRGBO(180, 189, 165, 1);
  final titleColour = Color.fromRGBO(48, 50, 52, 1);
  final ringColour = Color.fromRGBO(178, 187, 163, 0.15);
  final fillColour = LinearGradient(colors: [
    Color.fromRGBO(199, 210, 183, 0),
    Color.fromRGBO(199, 210, 183, 1),
  ], stops: [
    0,
    25,
    50,
    75,
    100
  ]);

  // Sizes
  final double titleSize = 46;
}

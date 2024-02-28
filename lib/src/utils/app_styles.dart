import 'package:flutter/material.dart';

class Styles {
  static Color primaryColor = const Color.fromRGBO(56, 56, 76, 1);
  static Color primaryColorGradient = const Color.fromRGBO(0, 150, 136, 1);
  static Color secondaryColorGradient = const Color.fromRGBO(56, 56, 76, 1);
  static Color? secondaryColor = Colors.blueGrey[800];
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color? gray = Colors.grey[400];
  static Color green = Colors.green;
  static Color? red = Colors.red[300];
  static Color redText = Colors.red;
  static Color blue = Colors.blue;
  static Color transparent = Colors.transparent;
  static Color blur = const Color.fromARGB(48, 255, 255, 255);

  static TextStyle textStyleBody = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: white,
  );
  static TextStyle textStyleTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: black,
  );

  static TextStyle textStyleWelcomeTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: black,
  );

  static TextStyle textStyleBottomTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: black,
  );
  static TextStyle textLabel = const TextStyle(
    fontSize: 14,
  );
  static TextStyle textButtonTrackLocation = TextStyle(color: redText);
  static TextStyle textState =
      TextStyle(color: redText, fontWeight: FontWeight.bold);
}

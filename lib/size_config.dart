import 'package:flutter/material.dart';

class SizeConfig {
  MediaQueryData _mediaQueryData;
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double wUnit = 0.0;
  static double hUnit = 0.0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    wUnit = screenWidth / 100;
    hUnit = screenHeight / 100;
  }
}

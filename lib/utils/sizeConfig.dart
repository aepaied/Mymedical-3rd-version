import 'package:flutter/material.dart';

class SizeConfig {
  /*BuildContext context;
  double width = 0.0;
  double height = 0.0;

  SizeConfig(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  double getWidth(double width) {
    return (this.width * 100) / width;
  }

  double getHeight(double height) {
    return (this.height * 100) / height;
  }*/

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double wUnit;
  static double vUnit;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    wUnit = screenWidth / 100;
    vUnit = screenHeight / 100;
  }

 /* static double getWidth(double width) {
    return wUnit * width;
  }

  static double getHeight(double height) {
    return vUnit * height;
  }*/
}

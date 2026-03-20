import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Size {
  xSmall,
  small,
  medium,
  large,
  xLarge,
}

class STheme {
  static Color primary = Color(0xFF000000);
  static Map<Size, double> size = {
    Size.xSmall: 4,
    Size.small: 8,
    Size.medium: 16,
    Size.large: 24,
    Size.xLarge: 32,
  };

  static Color red = Color(0xFF000000);
  static Color green = Color(0xFF000000);
  static Color blue = Color(0xFF000000);
  static Color gray = Color(0xFF000000);

  static List<Color> gradientRed = [
    Color(0xFF000000),
    Color(0xFF000000),
  ];

  static List<Color> gradientGreen = [
    Color(0xFF000000),
    Color(0xFF000000),
  ];

  static List<Color> gradientBlue = [
    Color(0xFF000000),
    Color(0xFF000000),
  ];

  static List<Color> gradientGray = [
    Color(0xFF000000),
    Color(0xFF000000),
  ];

  static Widget iconEmpty = Icon(Icons.hourglass_empty);
  static Widget iconBack = Icon(CupertinoIcons.left_chevron);
  
}



extension SThemeExtension on STheme {
  static Color demoColor = Color(0xFF000000);
}
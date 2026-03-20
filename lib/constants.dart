import 'package:flutter/material.dart';

enum SSize {
  small,
  medium,
  large,
}

enum SSpacing {
  xSmall,
  small,
  medium,
  large,
}

// enum SRadius {
//   xSmall,
//   small,
//   medium,
//   large,
// }

enum SColor {
  primary,
  secondary,
  tertiary,
  red,
  grey,
  green,
  orange,
  blue,
  yellow,
}

class Spacing {
  static const double xSmall = 4;
  static const double small = 8;
  static const double mediumSmall = 12;
  static const double medium = 16;
  static const double large = 24;
}

class Constant {
  static const List<Color> gradientColors = [
    Color(0xFFFF416C),
    Color(0xFFFF4B2B)
  ];

  static const List<Color> gradientBlue = [
    Color(0xFF000eff),
    Color(0xFF0f35ff),
  ];

  // static const List<Color> gradientBlue = [
  //   Color(0xFF2948ff),
  //   Color(0xFF396afc)
  // ];

  static const List<Color> gradientRed = [
    Color(0xFFd31027),
    Color(0xFFe9374b),
  ];

  static const List<Color> gradientGreen = [
    Color(0xFF217e22),
    Color(0xFF61a110),
  ];
  static const Color primaryColor = Color(0xFF2948ff);
  static const Color green = Color(0xFF0ca37f);
  static const Color red = Color(0xFFc40108);
  static const Color orange = Color(0xFFf57c00);
  static const Color blue = Color(0xFF0c79fc);
  static const Color bottomSheetColor = Color(0xFF142127);
  static const Color grey = Color(0xFF808080);
}

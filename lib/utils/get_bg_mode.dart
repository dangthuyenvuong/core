import 'package:flutter/material.dart';

Color getBgMode(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return isDarkMode ? Colors.white.withAlpha(15) : Colors.white;
}

Color getColorMode(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return isDarkMode ? Colors.white : Colors.black;
}

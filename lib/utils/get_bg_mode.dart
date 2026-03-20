import 'package:flutter/material.dart';

Color getBgMode(BuildContext context, {int opacity = 20}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return isDarkMode ? Colors.white.withAlpha(opacity) : Colors.white;
}

Color getOnSurface(BuildContext context) {
  return Theme.of(context).colorScheme.onSurface;
}

ThemeMode getThemeMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light;
}

Color getColorMode(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return isDarkMode ? Colors.white : Colors.black;
}

bool getIsDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

Color getBg(BuildContext context) {
  return Theme.of(context).scaffoldBackgroundColor;
}

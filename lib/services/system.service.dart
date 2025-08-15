import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SystemService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    final themeMode = GetStorage().read('themeMode');
    if (themeMode == null) {
      return ThemeMode.system;
    }
    return themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    if (theme == ThemeMode.system) {
      GetStorage().remove('themeMode');
      return;
    }

    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    GetStorage().write('themeMode', theme.name);
  }
}

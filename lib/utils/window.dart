import 'package:flutter/services.dart';

class WindowUtils {
  static const _channel = MethodChannel("app.channel.shared.data");

  static Future<void> setWindowTitle(String title) async {
    try {
      await _channel.invokeMethod('setWindowTitle', {"title": title});
    } catch (e) {
      print("Error setting window title: $e");
    }
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../capture.dart' as ct;

class ReportController extends GetxController {
  final images = <Uint8List>[].obs;
  final enabledCaptureScreen = false.obs;
  final screenshotKey = GlobalKey();
  final content = ''.obs;

  void clearForm() {
    images.clear();
    content.value = '';
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  Future<void> captureScreenshot() async {
    final image = await ct.captureScreenshot(screenshotKey);
    if (image != null) {
      images.add(image);
    }
  }
}

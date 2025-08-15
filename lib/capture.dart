import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Future<Uint8List?> captureScreenshot(GlobalKey _screenshotKey) async {
  try {
    RenderRepaintBoundary boundary = _screenshotKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;

    // Tạo hình ảnh từ boundary
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    // Chuyển đổi thành Uint8List
    return byteData!.buffer.asUint8List();
  } catch (e) {
    print('Error capturing screenshot: $e');
  }
  return null;
}

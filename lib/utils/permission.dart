import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionUtil {
  static Future<void> requestNotification() async {
    if (Platform.isAndroid) {
      // Android 13+ cần xin quyền
      final status = await Permission.notification.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        final result = await Permission.notification.request();
        if (result.isDenied) {
          // mở settings nếu bị từ chối
          openAppSettings();
        }
      }
    } else if (Platform.isIOS) {
      // iOS: không xin permission trực tiếp được nếu user đã từ chối
      final status = await Permission.notification.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        openAppSettings(); // 👉 mở settings để user bật lại
      } else {
        final result = await Permission.notification.request();
        if (result.isDenied) {
          openAppSettings();
        }
      }
    }
  }

  static Future<void> requestLocation() async {
    if (Platform.isAndroid) {
      // Android 13+ cần xin quyền
      final status = await Permission.location.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        final result = await Permission.location.request();
        if (result.isDenied) {
          // mở settings nếu bị từ chối
          openAppSettings();
        }
      }
    } else if (Platform.isIOS) {
      // iOS: không xin permission trực tiếp được nếu user đã từ chối
      final status = await Permission.location.status;
      print("status: $status");
      if (status.isDenied || status.isPermanentlyDenied) {
        openAppSettings(); // 👉 mở settings để user bật lại
      } else {
        final result = await Permission.location.request();
        if (result.isDenied) {
          openAppSettings();
        }
      }
    }
  }
}

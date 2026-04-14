import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension CoreX on CoreBase {
  Future<T?> to<T>(Widget page,
      {bool fullscreenDialog = false,
      double? gestureWidthRatio,
      Transition? transition,
      Duration? duration,
      preventDuplicates = true,
      bool replace = false}) async {
    if (replace) {
      return Get.off(
        page,
        fullscreenDialog: fullscreenDialog,
        transition: transition,
        duration: duration,
        preventDuplicates: preventDuplicates,
        gestureWidth: gestureWidthRatio != null
            ? (context) => gestureWidthRatio * MediaQuery.of(context).size.width
            : null,
      );
    } else {
      return Get.to(page,
          fullscreenDialog: fullscreenDialog,
          transition: transition,
          duration: duration,
          preventDuplicates: preventDuplicates,
          // popGesture: false,
          gestureWidth: gestureWidthRatio != null
              ? (context) =>
                  gestureWidthRatio * MediaQuery.of(context).size.width
              : null);
    }
  }

  Future<T?> toNamed<T>(String name) async {
    return Get.toNamed(
      name,
    );
  }

  T? back<T>({
    T? result,
  }) {
    return Get.back<T?>(result: result) as T?;
  }

  T registerIfNotExist<T>(T Function() register) {
    if (Get.isRegistered<T>()) {
      return Get.find<T>();
    } else {
      return Get.put(register());
    }
  }
}

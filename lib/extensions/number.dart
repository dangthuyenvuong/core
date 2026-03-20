import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension NumberX on num {
  String toNoneDecimalIfCan() {
    if (this % 1 == 0) {
      return toInt().toString();
    }
    return toString();
  }

  bool isInt() {
    return this % 1 == 0;
  }

  String format({String pattern = "#,###.#", bool noneIfZero = false}) {
    if (noneIfZero && this == 0) {
      return "";
    }
    return NumberFormat(pattern).format(this);
  }

  String toStringOrEmpty() {
    if (this != 0) {
      return toString();
    }
    return "";
  }

  double safeParse() {
    String normalized = toString().replaceAll(",", ".");
    return double.tryParse(normalized) ?? 0;
  }

  num defaultZeroValue(num value) {
    if (this == 0) {
      return value;
    }
    return this;
  }
}

class Doubles {
  static double safeParse(String value) {
    String normalized = value.replaceAll(",", ".");
    return double.tryParse(normalized) ?? 0;
  }
}

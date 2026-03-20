import 'package:core/core.dart';
import 'package:flutter/material.dart';

extension DateTime2 on DateTime {
  DateTime addMonths(int months) => DateTime(year, month + months, 1);
  int get numOfDaysInMonth => DateTime(year, month + 1, 0).day;
  int get numOfDayOffset => DateTime(year, month, 1).weekday - 1;

  int get numOfDaysInYear => DateTime(year, 12, 31)
      .difference(DateTime(year, 1, 1).subtract(Duration(days: 1)))
      .inDays;
  int get numOfDayOffsetYear => DateTime(year, 1, 1).weekday - 1;

  // bool isToDayOrAfter(DateTime other) {
  //   return difference(other).inDays >= 0;
  // }

  // bool isToDayOrBefore(DateTime other) {
  //   return difference(other).inDays <= 0;
  // }

  DateTime clone() => DateTime(
      year, month, day, hour, minute, second, millisecond, microsecond);

  // bool betweenDay(DateTime startDate, DateTime endDate) {
  //   return startDate.isToDayOrBefore(this) && isToDayOrBefore(endDate);
  // }
}

extension DateTime3 on DateTime? {
  bool isToDayOrAfter(DateTime other) {
    if (this == null) return false;
    return this!.isAfter(other) || this!.isAtSameDay(other);
    // return this!.difference(other).inDays >= 0;
  }

  bool isToDayOrBefore(DateTime other) {
    if (this == null) return false;
    return this!.isBefore(other) || this!.isAtSameDay(other);
    // return this!.difference(other).inDays <= 0;
  }

  bool betweenDay(DateTime? startDate, DateTime? endDate) {
    if (this == null || startDate == null || endDate == null) return false;
    return startDate.isToDayOrBefore(this!) && isToDayOrBefore(endDate);
  }

  bool isBeforeDay(DateTime other) {
    if (this == null) return false;
    return this!.isBefore(other) && !this!.isAtSameDay(other);
  }

  bool isAfterDay(DateTime other) {
    if (this == null) return false;
    return this!.isAfter(other) && !this!.isAtSameDay(other);
  }

  int get age {
    if (this == null) return 0;
    return DateTime.now().difference(this!).inDays ~/ 365;
  }
}

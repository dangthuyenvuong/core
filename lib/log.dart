import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

// typedef LogFunction = void Function(
//   String message, {
//   DateTime? time,
//   int? sequenceNumber,
//   int level,
//   String name,
//   Zone? zone,
//   Object? error,
//   StackTrace? stackTrace,
// });

class Log {
  static void info(Object object) {
    final prettyJson = JsonEncoder.withIndent('  ').convert(object);

    print(prettyJson);
  }

  static const _green = '\x1B[32m';
  static const _red = '\x1B[31m';
  static const _blue = '\x1B[34m';
  static const _yellow = '\x1B[33m';
  static const _orange = '\x1B[38;5;208m'; //

  static void _log(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final trace = StackTrace.current.toString().split('\n');

    // Dòng thứ 1 là logWithLocation
    // Dòng thứ 2 là nơi gọi nó
    final caller = trace.length > 2 ? trace[2] : 'Unknown';

    // print('$message');
    // print('📍 Called from: $caller');

    developer.log(
      "$message --> $caller",
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      name: name,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void green(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kReleaseMode) {
      _log(
        '$_green$message\x1B[0m',
        // '🟢 $message',
        time: time,
        sequenceNumber: sequenceNumber,
        level: level,
        name: name,
        zone: zone,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void red(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kReleaseMode) {
      _log(
        // '🔴 $message',
        '$_red$message\x1B[0m',
        time: time,
        sequenceNumber: sequenceNumber,
        level: level,
        name: name,
        zone: zone,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void blue(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kReleaseMode) {
      _log(
        // '🔵 $message',
        '$_blue$message\x1B[0m',
        time: time,
        sequenceNumber: sequenceNumber,
        level: level,
        name: name,
        zone: zone,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void yellow(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kReleaseMode) {
      _log(
        // '🟡 $message',
        '$_yellow$message\x1B[0m',
        time: time,
        sequenceNumber: sequenceNumber,
        level: level,
        name: name,
        zone: zone,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void orange(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kReleaseMode) {
      _log(
        // '🟠 $message',
        '$_orange$message\x1B[0m',
        time: time,
        sequenceNumber: sequenceNumber,
        level: level,
        name: name,
        zone: zone,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

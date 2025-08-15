import 'dart:convert';

class Log {
  static void info(Object object) {
    final prettyJson = JsonEncoder.withIndent('  ').convert(object);

    print(prettyJson);
  }
}

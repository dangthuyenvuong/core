import 'dart:async';

class DelayController {
  // int delay;
  // Timer? timer;
  // DelayController({required this.delay});

  // void run(Function() callback) {
  //   timer?.cancel();
  //   timer = Timer(Duration(milliseconds: delay), callback);
  // }

  // void cancel() {
  //   timer?.cancel();
  // }

  static final Map<String, Timer> timers = {};

  static void run(Function() callback, {required String key, delay = 1000}) {
    timers[key]?.cancel();
    timers[key] = Timer(Duration(milliseconds: delay), callback);
  }

  static void cancel(String key) {
    timers[key]?.cancel();
    timers.remove(key);
  }
}

import 'dart:async';

class Time {
  static String format(int seconds) {
    int secondsTemp = seconds % 60;
    int minutes = seconds ~/ 60 % 60;
    int hours = seconds ~/ 60 ~/ 60;

    var timeStr = '';
    if (hours > 0) {
      timeStr += '${hours.toString().padLeft(2, '0')}:';
    }

    timeStr += '${minutes.toString().padLeft(2, '0')}:';

    timeStr += '${secondsTemp.toString().padLeft(2, '0')}';

    return timeStr;
  }

  Duration? duration;
  Timer? _timer;
  void Function(Timer)? callback;
  periodic(Duration duration, void Function(Timer) callback) {
    this.duration = duration;
    this.callback = callback;
    _timer = Timer.periodic(duration, callback);
  }

  pause() {
    _timer?.cancel();
  }

  resume() {
    _timer = Timer.periodic(duration!, callback!);
  }

  cancel() {
    _timer?.cancel();
    duration = null;
    callback = null;
  }
}

extension DurationX on Duration {
  String format() => Time.format(inSeconds);
}

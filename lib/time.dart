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
}

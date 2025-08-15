import 'package:easy_localization/easy_localization.dart';

class SDateUtils {
  static int dayMonthLength(DateTime date) {
    DateTime firstDayNextMonth = DateTime(date.year, date.month + 1, 1);
    return firstDayNextMonth.subtract(Duration(days: 1)).day;
  }

  static String fromNow(DateTime date) {
    Duration difference = DateTime.now().difference(date);
    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} ${tr('seconds ago')}";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} ${tr('minutes ago')}";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} ${tr('hours ago')}";
    } else if (difference.inDays < 30) {
      return "${difference.inDays} ${tr('days ago')}";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} ${tr('months ago')}";
    } else {
      return "${(difference.inDays / 365).floor()} ${tr('years ago')}";
    }
  }
}

import 'dart:io';

import 'package:core/core.dart';
import 'package:core/models/notification/model.dart';

class _NotificationService {
  static Future<NotificationSetting> getNotifications() async {
    try {
      final response = await Http.get('/notification/setting');
      return NotificationSetting.fromJson(response['data']);
    } catch (err) {
      return NotificationSetting(enabled: true, feature: {});
    }
  }

  static Future<NotificationSetting> updateNotification(
      NotificationSetting setting) async {
        print(setting.toJson());
    final response =
        await Http.put('/notification/setting', body: setting.toJson());
    return NotificationSetting.fromJson(response['data']);
  }

  static Future<List<ScheduleItem>> getSchedule() async {
    final response = await Http.get(
      '/notification/schedule',
    );
    return response['data']
        .map<NotificationScheduleItem>(
            (e) => NotificationScheduleItem.fromJson(e))
        .map<ScheduleItem>((NotificationScheduleItem e) => e.toScheduleItem())
        .toList();
  }

  static Future<ScheduleItem> addOrEdit(
      NotificationScheduleItem schedule) async {
    final response = await Http.post(
      '/notification/schedule',
      body: schedule.toJson(),
    );

    return NotificationScheduleItem.fromJson(response['data']).toScheduleItem();
  }
}

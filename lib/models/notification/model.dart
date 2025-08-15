import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

@freezed
class NotificationSetting with _$NotificationSetting {
  const factory NotificationSetting({
    required bool enabled,
    required Map<String, bool> feature,
  }) = _NotificationSetting;

  factory NotificationSetting.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingFromJson(json);

  const NotificationSetting._();
}


@freezed
class NotificationScheduleItem with _$NotificationScheduleItem {
  const factory NotificationScheduleItem({
    required String id,
    required int from,
    required int to,
    required bool monday,
    required bool tuesday,
    required bool wednesday,
    required bool thursday,
    required bool friday,
    required bool saturday,
    required bool sunday,
    required bool is_active,
  }) = _NotificationScheduleItem;

  factory NotificationScheduleItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationScheduleItemFromJson(json);

  const NotificationScheduleItem._();

  Map<int, bool> get repeatToArray =>
      [monday, tuesday, wednesday, thursday, friday, saturday, sunday].asMap();
  ScheduleItem toScheduleItem() => ScheduleItem(
        id: id,
        from: from,
        to: to,
        repeat: repeatToArray,
        isActive: is_active,
      );

  static NotificationScheduleItem fromSchedule(ScheduleItem schedule) {
    return NotificationScheduleItem(
      id: schedule.id,
      from: schedule.from,
      to: schedule.to,
      monday: schedule.repeat[0] ?? false,
      tuesday: schedule.repeat[1] ?? false,
      wednesday: schedule.repeat[2] ?? false,
      thursday: schedule.repeat[3] ?? false,
      friday: schedule.repeat[4] ?? false,
      saturday: schedule.repeat[5] ?? false,
      sunday: schedule.repeat[6] ?? false,
      is_active: schedule.isActive,
    );
  }
}

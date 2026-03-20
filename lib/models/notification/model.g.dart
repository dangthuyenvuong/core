// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingImpl _$$NotificationSettingImplFromJson(Map json) =>
    $checkedCreate(
      r'_$NotificationSettingImpl',
      json,
      ($checkedConvert) {
        final val = _$NotificationSettingImpl(
          enabled: $checkedConvert('enabled', (v) => v as bool),
          feature: $checkedConvert(
              'feature', (v) => Map<String, bool>.from(v as Map)),
        );
        return val;
      },
    );

Map<String, dynamic> _$$NotificationSettingImplToJson(
        _$NotificationSettingImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'feature': instance.feature,
    };

_$NotificationScheduleItemImpl _$$NotificationScheduleItemImplFromJson(
        Map json) =>
    $checkedCreate(
      r'_$NotificationScheduleItemImpl',
      json,
      ($checkedConvert) {
        final val = _$NotificationScheduleItemImpl(
          id: $checkedConvert('id', (v) => v as String),
          from: $checkedConvert('from', (v) => (v as num).toInt()),
          to: $checkedConvert('to', (v) => (v as num).toInt()),
          monday: $checkedConvert('monday', (v) => v as bool),
          tuesday: $checkedConvert('tuesday', (v) => v as bool),
          wednesday: $checkedConvert('wednesday', (v) => v as bool),
          thursday: $checkedConvert('thursday', (v) => v as bool),
          friday: $checkedConvert('friday', (v) => v as bool),
          saturday: $checkedConvert('saturday', (v) => v as bool),
          sunday: $checkedConvert('sunday', (v) => v as bool),
          is_active: $checkedConvert('is_active', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$$NotificationScheduleItemImplToJson(
        _$NotificationScheduleItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from': instance.from,
      'to': instance.to,
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
      'sunday': instance.sunday,
      'is_active': instance.is_active,
    };

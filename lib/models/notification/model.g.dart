// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingImpl _$$NotificationSettingImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingImpl(
      enabled: json['enabled'] as bool,
      feature: Map<String, bool>.from(json['feature'] as Map),
    );

Map<String, dynamic> _$$NotificationSettingImplToJson(
        _$NotificationSettingImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'feature': instance.feature,
    };

_$NotificationScheduleItemImpl _$$NotificationScheduleItemImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationScheduleItemImpl(
      id: json['id'] as String,
      from: (json['from'] as num).toInt(),
      to: (json['to'] as num).toInt(),
      monday: json['monday'] as bool,
      tuesday: json['tuesday'] as bool,
      wednesday: json['wednesday'] as bool,
      thursday: json['thursday'] as bool,
      friday: json['friday'] as bool,
      saturday: json['saturday'] as bool,
      sunday: json['sunday'] as bool,
      is_active: json['is_active'] as bool,
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

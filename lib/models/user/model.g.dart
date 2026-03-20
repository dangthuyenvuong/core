// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map json) => $checkedCreate(
      r'_$UserModelImpl',
      json,
      ($checkedConvert) {
        final val = _$UserModelImpl(
          id: $checkedConvert('id', (v) => v as String),
          full_name: $checkedConvert('full_name', (v) => v as String?),
          avatar: $checkedConvert('avatar', (v) => v as String?),
          account_id: $checkedConvert('account_id', (v) => v as String?),
          email: $checkedConvert('email', (v) => v as String?),
          phone: $checkedConvert('phone', (v) => v as String?),
          gender: $checkedConvert(
              'gender', (v) => $enumDecodeNullable(_$GenderEnumMap, v)),
          birthday: $checkedConvert(
              'birthday',
              (v) => _$JsonConverterFromJson<String, DateTime>(
                  v, const DateTimeConverter().fromJson)),
        );
        return val;
      },
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.full_name,
      'avatar': instance.avatar,
      'account_id': instance.account_id,
      'email': instance.email,
      'phone': instance.phone,
      'gender': _$GenderEnumMap[instance.gender],
      'birthday': _$JsonConverterToJson<String, DateTime>(
          instance.birthday, const DateTimeConverter().toJson),
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

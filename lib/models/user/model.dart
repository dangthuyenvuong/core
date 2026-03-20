import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

enum Gender { male, female, other }


@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    String? full_name,
    String? avatar,
    String? account_id,
    String? email,
    String? phone,
    
    @EnumConverter() Gender? gender,
    @DateTimeConverter() DateTime? birthday,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}


// required String avatar,
//     required String full_name,
//     required String account_id,
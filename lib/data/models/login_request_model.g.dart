// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestModel _$LoginRequestModelFromJson(Map<String, dynamic> json) =>
    LoginRequestModel(
      identifier: json['identifier'] as String,
      password: json['password'] as String,
      device: json['device'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$LoginRequestModelToJson(LoginRequestModel instance) {
  final val = <String, dynamic>{
    'identifier': instance.identifier,
    'password': instance.password,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('device', instance.device);
  return val;
}

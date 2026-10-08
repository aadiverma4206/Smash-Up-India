// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterSendOtpRequestModel _$RegisterSendOtpRequestModelFromJson(
        Map<String, dynamic> json) =>
    RegisterSendOtpRequestModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      city: json['city'] as String? ?? 'Raipur',
    );

Map<String, dynamic> _$RegisterSendOtpRequestModelToJson(
        RegisterSendOtpRequestModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'city': instance.city,
    };

RegisterVerifyOtpRequestModel _$RegisterVerifyOtpRequestModelFromJson(
        Map<String, dynamic> json) =>
    RegisterVerifyOtpRequestModel(
      email: json['email'] as String,
      phone: json['phone'] as String,
      emailOtp: json['emailOtp'] as String,
    );

Map<String, dynamic> _$RegisterVerifyOtpRequestModelToJson(
        RegisterVerifyOtpRequestModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'emailOtp': instance.emailOtp,
    };

RegisterPlayerRequestModel _$RegisterPlayerRequestModelFromJson(
        Map<String, dynamic> json) =>
    RegisterPlayerRequestModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      city: json['city'] as String? ?? 'Raipur',
      verificationToken: json['verificationToken'] as String,
    );

Map<String, dynamic> _$RegisterPlayerRequestModelToJson(
        RegisterPlayerRequestModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'city': instance.city,
      'verificationToken': instance.verificationToken,
    };

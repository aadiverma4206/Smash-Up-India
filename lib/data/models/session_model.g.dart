// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
      id: json['id'] as String,
      deviceInfo: json['deviceInfo'] as String?,
      ipAddress: json['ipAddress'] as String?,
      createdAt: json['createdAt'] as String,
      expiresAt: json['expiresAt'] as String,
    );

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceInfo': instance.deviceInfo,
      'ipAddress': instance.ipAddress,
      'createdAt': instance.createdAt,
      'expiresAt': instance.expiresAt,
    };

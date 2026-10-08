// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      roleId: (json['roleId'] as num).toInt(),
      roleName: json['roleName'] as String?,
      status: json['status'] as String,
      city: json['city'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'roleId': instance.roleId,
      'roleName': instance.roleName,
      'status': instance.status,
      'city': instance.city,
      'profileImageUrl': instance.profileImageUrl,
    };

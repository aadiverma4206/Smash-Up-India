// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerProfileModel _$PlayerProfileModelFromJson(Map<String, dynamic> json) =>
    PlayerProfileModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      city: json['city'] as String,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      position: json['position'] as String? ?? 'ST',
      preferredFoot: json['preferredFoot'] as String? ?? 'RIGHT',
      skillLevel: json['skillLevel'] as String? ?? 'AMATEUR',
      ovr: (json['ovr'] as num?)?.toInt() ?? 75,
    );

Map<String, dynamic> _$PlayerProfileModelToJson(PlayerProfileModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'city': instance.city,
      'bio': instance.bio,
      'avatarUrl': instance.avatarUrl,
      'position': instance.position,
      'preferredFoot': instance.preferredFoot,
      'skillLevel': instance.skillLevel,
      'ovr': instance.ovr,
    };

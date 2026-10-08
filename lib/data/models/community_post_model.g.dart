// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityPostModel _$CommunityPostModelFromJson(Map<String, dynamic> json) =>
    CommunityPostModel(
      id: json['id'] as String,
      authorName: json['authorName'] as String,
      content: json['content'] as String,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      isLikedByMe: json['isLikedByMe'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$CommunityPostModelToJson(CommunityPostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorName': instance.authorName,
      'content': instance.content,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'isLikedByMe': instance.isLikedByMe,
      'createdAt': instance.createdAt,
    };

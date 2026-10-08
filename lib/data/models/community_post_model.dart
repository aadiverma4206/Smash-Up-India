import 'package:json_annotation/json_annotation.dart';

part 'community_post_model.g.dart';

@JsonSerializable()
class CommunityPostModel {
  final String id;
  final String authorName;
  final String content;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByMe;
  final String createdAt;

  CommunityPostModel({
    required this.id,
    required this.authorName,
    required this.content,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByMe = false,
    required this.createdAt,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommunityPostModelToJson(this);
}

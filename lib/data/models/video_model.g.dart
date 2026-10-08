// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoModel _$VideoModelFromJson(Map<String, dynamic> json) => VideoModel(
      id: json['id'] as String,
      gameId: json['gameId'] as String,
      title: json['title'] as String,
      clubName: json['clubName'] as String,
      courtName: json['courtName'] as String,
      matchDate: json['matchDate'] as String,
      playbackUrl: json['playbackUrl'] as String,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 5400,
    );

Map<String, dynamic> _$VideoModelToJson(VideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gameId': instance.gameId,
      'title': instance.title,
      'clubName': instance.clubName,
      'courtName': instance.courtName,
      'matchDate': instance.matchDate,
      'playbackUrl': instance.playbackUrl,
      'durationSeconds': instance.durationSeconds,
    };

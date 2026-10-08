import 'package:json_annotation/json_annotation.dart';

part 'video_model.g.dart';

@JsonSerializable()
class VideoModel {
  final String id;
  final String gameId;
  final String title;
  final String clubName;
  final String courtName;
  final String matchDate;
  final String playbackUrl;
  final int durationSeconds;

  VideoModel({
    required this.id,
    required this.gameId,
    required this.title,
    required this.clubName,
    required this.courtName,
    required this.matchDate,
    required this.playbackUrl,
    this.durationSeconds = 5400,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);
  Map<String, dynamic> toJson() => _$VideoModelToJson(this);
}

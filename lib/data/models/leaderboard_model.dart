import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_model.g.dart';

@JsonSerializable()
class LeaderboardEntryModel {
  final int rank;
  final String userId;
  final String playerName;
  final String city;
  final int ovr;
  final int matchesPlayed;
  final int matchesWon;
  final int goalsScored;

  LeaderboardEntryModel({
    required this.rank,
    required this.userId,
    required this.playerName,
    required this.city,
    required this.ovr,
    required this.matchesPlayed,
    required this.matchesWon,
    required this.goalsScored,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$LeaderboardEntryModelToJson(this);
}

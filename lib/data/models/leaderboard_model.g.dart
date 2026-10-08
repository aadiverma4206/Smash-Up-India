// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardEntryModel _$LeaderboardEntryModelFromJson(
        Map<String, dynamic> json) =>
    LeaderboardEntryModel(
      rank: (json['rank'] as num).toInt(),
      userId: json['userId'] as String,
      playerName: json['playerName'] as String,
      city: json['city'] as String,
      ovr: (json['ovr'] as num).toInt(),
      matchesPlayed: (json['matchesPlayed'] as num).toInt(),
      matchesWon: (json['matchesWon'] as num).toInt(),
      goalsScored: (json['goalsScored'] as num).toInt(),
    );

Map<String, dynamic> _$LeaderboardEntryModelToJson(
        LeaderboardEntryModel instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'userId': instance.userId,
      'playerName': instance.playerName,
      'city': instance.city,
      'ovr': instance.ovr,
      'matchesPlayed': instance.matchesPlayed,
      'matchesWon': instance.matchesWon,
      'goalsScored': instance.goalsScored,
    };

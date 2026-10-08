// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerStatsModel _$PlayerStatsModelFromJson(Map<String, dynamic> json) =>
    PlayerStatsModel(
      matchesPlayed: (json['matchesPlayed'] as num?)?.toInt() ?? 0,
      matchesWon: (json['matchesWon'] as num?)?.toInt() ?? 0,
      matchesLost: (json['matchesLost'] as num?)?.toInt() ?? 0,
      matchesDrawn: (json['matchesDrawn'] as num?)?.toInt() ?? 0,
      goalsScored: (json['goalsScored'] as num?)?.toInt() ?? 0,
      assists: (json['assists'] as num?)?.toInt() ?? 0,
      motmCount: (json['motmCount'] as num?)?.toInt() ?? 0,
      winRatePercentage: (json['winRatePercentage'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PlayerStatsModelToJson(PlayerStatsModel instance) =>
    <String, dynamic>{
      'matchesPlayed': instance.matchesPlayed,
      'matchesWon': instance.matchesWon,
      'matchesLost': instance.matchesLost,
      'matchesDrawn': instance.matchesDrawn,
      'goalsScored': instance.goalsScored,
      'assists': instance.assists,
      'motmCount': instance.motmCount,
      'winRatePercentage': instance.winRatePercentage,
    };

import 'package:json_annotation/json_annotation.dart';

part 'player_stats_model.g.dart';

@JsonSerializable(createFactory: false)
class PlayerStatsModel {
  final int matchesPlayed;
  final int matchesWon;
  final int matchesLost;
  final int matchesDrawn;
  final int goalsScored;
  final int assists;
  final int motmCount; // Man of the Match awards
  final double winRatePercentage;

  PlayerStatsModel({
    this.matchesPlayed = 0,
    this.matchesWon = 0,
    this.matchesLost = 0,
    this.matchesDrawn = 0,
    this.goalsScored = 0,
    this.assists = 0,
    this.motmCount = 0,
    this.winRatePercentage = 0.0,
  });

  factory PlayerStatsModel.fromJson(Map<String, dynamic> json) {
    return PlayerStatsModel(
      matchesPlayed:
          (json['matchesPlayed'] ?? json['matches_played'] as num?)?.toInt() ??
              0,
      matchesWon:
          (json['matchesWon'] ?? json['matches_won'] as num?)?.toInt() ?? 0,
      matchesLost:
          (json['matchesLost'] ?? json['matches_lost'] as num?)?.toInt() ?? 0,
      matchesDrawn:
          (json['matchesDrawn'] ?? json['matches_drawn'] as num?)?.toInt() ?? 0,
      goalsScored:
          (json['goalsScored'] ?? json['goals_scored'] as num?)?.toInt() ?? 0,
      assists: (json['assists'] as num?)?.toInt() ?? 0,
      motmCount:
          (json['motmCount'] ?? json['motm_count'] as num?)?.toInt() ?? 0,
      winRatePercentage:
          (json['winRatePercentage'] ?? json['win_rate_percentage'] as num?)
                  ?.toDouble() ??
              0.0,
    );
  }
  Map<String, dynamic> toJson() => _$PlayerStatsModelToJson(this);
}

import 'player_profile_model.dart';
import 'player_stats_model.dart';
import 'game_model.dart';

class PlayerDashboardSummaryModel {
  final PlayerProfileModel? profile;
  final PlayerStatsModel? stats;
  final GameModel? activeMatch;
  final GameModel? upcomingMatch;
  final GameModel? recentMatch;
  final double walletBalance;

  PlayerDashboardSummaryModel({
    this.profile,
    this.stats,
    this.activeMatch,
    this.upcomingMatch,
    this.recentMatch,
    this.walletBalance = 0.0,
  });

  factory PlayerDashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return PlayerDashboardSummaryModel(
      profile: json['profile'] != null
          ? PlayerProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
      stats: json['stats'] != null
          ? PlayerStatsModel.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
      activeMatch: json['activeMatch'] != null
          ? GameModel.fromJson(json['activeMatch'] as Map<String, dynamic>)
          : null,
      upcomingMatch: json['upcomingMatch'] != null
          ? GameModel.fromJson(json['upcomingMatch'] as Map<String, dynamic>)
          : null,
      recentMatch: json['recentMatch'] != null
          ? GameModel.fromJson(json['recentMatch'] as Map<String, dynamic>)
          : null,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

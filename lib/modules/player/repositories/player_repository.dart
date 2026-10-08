import '../datasources/player_remote_datasource.dart';
import '../../../data/models/player_dashboard_summary_model.dart';
import '../../../data/models/player_profile_model.dart';
import '../../../data/models/player_stats_model.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/slot_request_model.dart';
import '../../../data/models/notification_model.dart';

class PlayerRepository {
  final PlayerRemoteDataSource remoteDataSource;

  PlayerRepository({required this.remoteDataSource});

  Future<PlayerDashboardSummaryModel> getDashboardSummary() async {
    return await remoteDataSource.getDashboardSummary();
  }

  Future<PlayerProfileModel> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  Future<PlayerStatsModel> getStats() async {
    return await remoteDataSource.getStats();
  }

  Future<List<GameModel>> getMyMatches({String? tab}) async {
    return await remoteDataSource.getMyMatches(tab: tab);
  }

  Future<List<SlotRequestModel>> getPlayerRequests({String? statusTab}) async {
    return await remoteDataSource.getPlayerRequests(statusTab: statusTab);
  }

  Future<List<NotificationModel>> getNotifications({required int page}) async {
    return await remoteDataSource.getNotifications(page: page);
  }

  Future<void> markNotificationRead(String id) async {
    return await remoteDataSource.markNotificationRead(id);
  }

  Future<PlayerProfileModel> updateProfile(Map<String, dynamic> data) async {
    return await remoteDataSource.updateProfile(data);
  }

  Future<PlayerProfileModel> uploadAvatar(String path) async {
    return await remoteDataSource.uploadAvatar(path);
  }

  Future<List<GameModel>> getHistory({int limit = 50, int offset = 0}) async {
    return await remoteDataSource.getHistory(limit: limit, offset: offset);
  }
}

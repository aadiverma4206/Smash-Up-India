import '../../../core/network/dio_client.dart';
import '../../../data/models/player_dashboard_summary_model.dart';
import '../../../data/models/player_profile_model.dart';
import '../../../data/models/player_stats_model.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/slot_request_model.dart';
import '../../../data/models/notification_model.dart';

class PlayerRemoteDataSource {
  final DioClient dioClient;

  PlayerRemoteDataSource({required this.dioClient});

  Future<PlayerDashboardSummaryModel> getDashboardSummary() async {
    return PlayerDashboardSummaryModel(
      walletBalance: 5500.0,
    );
  }

  Future<PlayerProfileModel> getProfile() async {
    return PlayerProfileModel(
      userId: 'user_1',
      name: 'Rahul Player',
      email: 'player@gmail.com',
      phone: '9988776655',
      city: 'Raipur',
      bio: 'Passionate cricketer and footballer at Smash Up India',
      avatarUrl: '',
    );
  }

  Future<PlayerStatsModel> getStats() async {
    return PlayerStatsModel();
  }

  Future<List<GameModel>> getMyMatches({String? tab}) async {
    return [];
  }

  Future<List<SlotRequestModel>> getPlayerRequests({String? statusTab}) async {
    return [];
  }

  Future<List<NotificationModel>> getNotifications({required int page}) async {
    return [
      NotificationModel(
        id: 'notif_1',
        title: 'Welcome to Smash Up India!',
        body:
            'Your account has been successfully set up with 5,000 welcome credits.',
        type: 'GENERAL',
        createdAt: DateTime.now().toIso8601String(),
        isRead: false,
      ),
    ];
  }

  Future<void> markNotificationRead(String id) async {}

  Future<PlayerProfileModel> updateProfile(Map<String, dynamic> data) async {
    return await getProfile();
  }

  Future<PlayerProfileModel> uploadAvatar(String path) async {
    return await getProfile();
  }

  Future<List<GameModel>> getHistory({int limit = 50, int offset = 0}) async {
    return [];
  }
}

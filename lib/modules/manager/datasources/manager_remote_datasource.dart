import '../../../core/network/dio_client.dart';
import '../../../data/models/manager_models.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/court_model.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/models/slot_request_model.dart';

class ManagerRemoteDataSource {
  final DioClient dioClient;

  ManagerRemoteDataSource({required this.dioClient});

  Future<ManagerDashboardModel> getDashboard() async {
    return ManagerDashboardModel(
      club: ManagerClubModel(
        id: 'club_1',
        name: 'Smash Arena Sports Club, Raipur',
        city: 'Raipur',
        address: 'VIP Road, Raipur',
        status: 'ACTIVE',
      ),
      totalRevenue: 125000.0,
      totalBookings: 12,
      activeMatches: 2,
      occupancyRatePercentage: 85.0,
      onlineCctvCount: 4,
    );
  }

  Future<List<SlotRequestModel>> getPendingRequests() async {
    return [];
  }

  Future<List<GameModel>> getClubMatches({String? tab}) async {
    return [
      GameModel(
        id: 'match_m1',
        title: 'SMASH UP INDIA Evening Tournament',
        clubId: 'club_1',
        clubName: 'Smash Arena Sports Club',
        courtName: 'Turf 1',
        matchDate: '2025-03-30',
        startTime: '18:00',
        endTime: '20:00',
        status: 'ONGOING',
        format: '7v7',
        perPlayerFee: 250.0,
        maxPlayers: 10,
        currentPlayers: 10,
        skillRequirement: 'Intermediate',
        privacy: 'PUBLIC',
      ),
    ];
  }

  Future<List<CourtModel>> getClubCourts() async {
    return [
      CourtModel(
        id: 'c1',
        clubId: 'club_1',
        clubName: 'Smash Arena Sports Club',
        name: 'Turf 1',
        surfaceType: 'Artificial Turf',
        basePricePerHour: 1000.0,
        status: 'ACTIVE',
        city: 'Raipur',
        address: 'VIP Road',
      ),
    ];
  }

  Future<List<BookingModel>> getClubBookings() async {
    return [];
  }

  Future<List<Map<String, dynamic>>> getCourtSlots(String courtId,
      {required String date}) async {
    return [
      {
        'slotTime': '18:00 - 19:00',
        'status': 'BOOKED',
        'userName': 'Rahul Player'
      },
      {'slotTime': '19:00 - 20:00', 'status': 'AVAILABLE', 'userName': ''},
    ];
  }

  Future<void> approveSlotRequest(String requestId) async {}
  Future<void> rejectSlotRequest(String requestId, String reason) async {}
  Future<void> cancelGameWithRefunds(String gameId, String reason) async {}
  Future<List<GameModel>> getPendingPlayerGames() async {
    return [];
  }

  Future<void> approvePlayerGame(String gameId) async {}
  Future<void> rejectPlayerGame(String gameId, String reason) async {}
  Future<List<Map<String, dynamic>>> getAllPlayers(
      {String? search, String? status}) async {
    return [];
  }

  Future<void> blockPlayer(String playerId, String reason) async {}
  Future<void> unblockPlayer(String playerId) async {}
  Future<void> submitMatchScore(String gameId, int teamAScore, int teamBScore,
      {bool isFinal = false}) async {}
  Future<void> stopMatchRecording(String gameId) async {}
  Future<List<GameModel>> getClubGames() async {
    return getClubMatches();
  }

  Future<Map<String, dynamic>> getMatchRecording(String gameId) async {
    return {};
  }

  Future<GameModel> startGame(String gameId) async {
    return GameModel(
      id: gameId,
      title: 'SMASH UP INDIA Live Match',
      clubId: 'club_1',
      clubName: 'Smash Arena Sports Club',
      courtName: 'Turf 1',
      matchDate: '2025-03-30',
      startTime: '18:00',
      endTime: '20:00',
      status: 'ONGOING',
      format: '7v7',
      perPlayerFee: 250.0,
      maxPlayers: 14,
      currentPlayers: 14,
      skillRequirement: 'Intermediate',
      privacy: 'PUBLIC',
    );
  }

  Future<GameModel> completeGame(
      String gameId, int teamAScore, int teamBScore) async {
    return GameModel(
      id: gameId,
      title: 'SMASH UP INDIA Completed Match',
      clubId: 'club_1',
      clubName: 'Smash Arena Sports Club',
      courtName: 'Turf 1',
      matchDate: '2025-03-30',
      startTime: '18:00',
      endTime: '20:00',
      status: 'COMPLETED',
      format: '7v7',
      perPlayerFee: 250.0,
      maxPlayers: 14,
      currentPlayers: 14,
      skillRequirement: 'Intermediate',
      privacy: 'PUBLIC',
      teamAScore: teamAScore,
      teamBScore: teamBScore,
    );
  }
}

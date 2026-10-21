import '../../../core/network/dio_client.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/court_model.dart';
import '../../../data/models/video_model.dart';

class GamesRemoteDataSource {
  final DioClient dioClient;

  GamesRemoteDataSource({required this.dioClient});

  Future<List<GameModel>> getGames(
      {String? city,
      String? status,
      int page = 1,
      int limit = 20,
      String? format,
      String? skill,
      double? maxEntryFee,
      String? privacy}) async {
    return [
      GameModel(
        id: 'game_1',
        title: 'SMASH UP INDIA Weekend Cricket Clash',
        clubId: 'club_1',
        clubName: 'Smash Arena Sports Club, Raipur',
        courtName: 'Pitch A - Turf 1',
        matchDate: '2025-03-30',
        startTime: '18:00',
        endTime: '20:00',
        status: 'OPEN_FOR_JOINING',
        format: '11v11',
        perPlayerFee: 250.0,
        maxPlayers: 22,
        currentPlayers: 14,
        skillRequirement: 'Intermediate',
        privacy: 'PUBLIC',
      ),
      GameModel(
        id: 'game_2',
        title: 'SMASH UP INDIA Badminton League',
        clubId: 'club_1',
        clubName: 'Smash Indoor Sports Complex',
        courtName: 'Court 2',
        matchDate: '2025-03-31',
        startTime: '07:00',
        endTime: '08:00',
        status: 'OPEN_FOR_JOINING',
        format: 'Singles',
        perPlayerFee: 150.0,
        maxPlayers: 4,
        currentPlayers: 2,
        skillRequirement: 'All',
        privacy: 'PUBLIC',
      ),
    ];
  }

  Future<GameModel> getGameById(String id) async {
    return GameModel(
      id: id,
      title: 'SMASH UP INDIA Championship Match',
      clubId: 'club_1',
      clubName: 'Smash Arena Sports Club, Raipur',
      courtName: 'Main Turf Arena',
      matchDate: '2025-03-30',
      startTime: '18:00',
      endTime: '20:00',
      status: 'OPEN_FOR_JOINING',
      format: '7v7',
      perPlayerFee: 300.0,
      maxPlayers: 14,
      currentPlayers: 10,
      skillRequirement: 'Advanced',
      privacy: 'PUBLIC',
    );
  }

  Future<List<ClubModel>> getClubs({String? city}) async {
    return [
      ClubModel(
        id: 'club_1',
        name: 'Smash Arena Sports Club, Raipur',
        address: 'VIP Road, Raipur, Chhattisgarh',
        city: 'Raipur',
      ),
    ];
  }

  Future<List<CourtModel>> getCourts({required String clubId}) async {
    return [
      CourtModel(
        id: 'court_1',
        clubId: clubId,
        clubName: 'Smash Arena Sports Club',
        name: 'Football Turf 1',
        surfaceType: 'Artificial Turf',
        basePricePerHour: 1200.0,
        status: 'AVAILABLE',
        city: 'Raipur',
        address: 'VIP Road',
      ),
      CourtModel(
        id: 'court_2',
        clubId: clubId,
        clubName: 'Smash Arena Sports Club',
        name: 'Badminton Court A',
        surfaceType: 'Wooden',
        basePricePerHour: 600.0,
        status: 'AVAILABLE',
        city: 'Raipur',
        address: 'VIP Road',
      ),
    ];
  }

  Future<void> joinGame(String gameId, String position,
      {String paymentMethod = 'WALLET',
      String? walletPin,
      String? razorpayOrderId,
      String? razorpayPaymentId,
      String? razorpaySignature}) async {}
  Future<void> leaveGame(String gameId) async {}
  Future<void> switchTeam(String gameId) async {}
  Future<void> cancelPlayerGame(String gameId, String reason) async {}

  Future<Map<String, dynamic>> joinWaitlist(
      String gameId, String position) async {
    return {'queuePosition': 1};
  }

  Future<Map<String, dynamic>> leaveWaitlist(String gameId) async {
    return {'status': 'success'};
  }

  Future<List<VideoModel>> getKeyVideos(String gameId) async {
    return [];
  }

  Future<List<VideoModel>> getGameVideos(String gameId) async {
    return [];
  }

  Future<GameModel> createGame(Map<String, dynamic> data) async {
    return GameModel(
      id: 'game_${DateTime.now().millisecondsSinceEpoch}',
      title: data['title'] ?? 'SMASH UP INDIA Custom Match',
      clubId: 'club_1',
      clubName: 'Smash Arena Sports Club',
      courtName: 'Turf Arena',
      matchDate: '2025-04-01',
      startTime: '18:00',
      endTime: '20:00',
      status: 'OPEN_FOR_JOINING',
      format: '5v5',
      perPlayerFee: double.tryParse(data['pricePerPlayer'].toString()) ?? 200.0,
      maxPlayers: 10,
      currentPlayers: 1,
      skillRequirement: 'All',
      privacy: 'PUBLIC',
    );
  }
}

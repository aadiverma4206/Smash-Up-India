import '../datasources/manager_remote_datasource.dart';
import '../../../data/models/manager_models.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/court_model.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/models/slot_request_model.dart';

class ManagerRepository {
  final ManagerRemoteDataSource remoteDataSource;

  ManagerRepository({required this.remoteDataSource});

  Future<ManagerDashboardModel> getDashboard() async {
    return await remoteDataSource.getDashboard();
  }

  Future<List<SlotRequestModel>> getPendingRequests() async {
    return await remoteDataSource.getPendingRequests();
  }

  Future<List<GameModel>> getClubMatches({String? tab}) async {
    return await remoteDataSource.getClubMatches(tab: tab);
  }

  Future<List<CourtModel>> getClubCourts() async {
    return await remoteDataSource.getClubCourts();
  }

  Future<List<BookingModel>> getClubBookings() async {
    return await remoteDataSource.getClubBookings();
  }

  Future<List<Map<String, dynamic>>> getCourtSlots(String courtId, {required String date}) async {
    return await remoteDataSource.getCourtSlots(courtId, date: date);
  }

  Future<void> approveSlotRequest(String requestId) async {
    return await remoteDataSource.approveSlotRequest(requestId);
  }

  Future<void> rejectSlotRequest(String requestId, String reason) async {
    return await remoteDataSource.rejectSlotRequest(requestId, reason);
  }

  Future<void> cancelGameWithRefunds(String gameId, String reason) async {
    return await remoteDataSource.cancelGameWithRefunds(gameId, reason);
  }

  Future<List<GameModel>> getPendingPlayerGames() async {
    return await remoteDataSource.getPendingPlayerGames();
  }

  Future<void> approvePlayerGame(String gameId) async {
    return await remoteDataSource.approvePlayerGame(gameId);
  }

  Future<void> rejectPlayerGame(String gameId, String reason) async {
    return await remoteDataSource.rejectPlayerGame(gameId, reason);
  }

  Future<List<Map<String, dynamic>>> getAllPlayers({String? search, String? status}) async {
    return await remoteDataSource.getAllPlayers(search: search, status: status);
  }

  Future<void> blockPlayer(String playerId, String reason) async {
    return await remoteDataSource.blockPlayer(playerId, reason);
  }

  Future<void> unblockPlayer(String playerId) async {
    return await remoteDataSource.unblockPlayer(playerId);
  }

  Future<void> submitMatchScore(String gameId, int teamAScore, int teamBScore, {bool isFinal = false}) async {
    return await remoteDataSource.submitMatchScore(gameId, teamAScore, teamBScore, isFinal: isFinal);
  }

  Future<void> stopMatchRecording(String gameId) async {
    return await remoteDataSource.stopMatchRecording(gameId);
  }

  Future<List<GameModel>> getClubGames() async {
    return await remoteDataSource.getClubGames();
  }

  Future<Map<String, dynamic>> getMatchRecording(String gameId) async {
    return await remoteDataSource.getMatchRecording(gameId);
  }

  Future<GameModel> startGame(String gameId) async {
    return await remoteDataSource.startGame(gameId);
  }

  Future<GameModel> completeGame(String gameId, int teamAScore, int teamBScore) async {
    return await remoteDataSource.completeGame(gameId, teamAScore, teamBScore);
  }
}

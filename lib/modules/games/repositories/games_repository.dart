import '../datasources/games_remote_datasource.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/court_model.dart';
import '../../../data/models/video_model.dart';

class GamesRepository {
  final GamesRemoteDataSource remoteDataSource;

  GamesRepository({required this.remoteDataSource});

  Future<List<GameModel>> getGames(
      {String? city,
      String? status,
      int page = 1,
      int limit = 20,
      String? format,
      String? skill,
      double? maxEntryFee,
      String? privacy}) async {
    return await remoteDataSource.getGames(
      city: city,
      status: status,
      page: page,
      limit: limit,
      format: format,
      skill: skill,
      maxEntryFee: maxEntryFee,
      privacy: privacy,
    );
  }

  Future<GameModel> getGameById(String id) async {
    return await remoteDataSource.getGameById(id);
  }

  Future<List<ClubModel>> getClubs({String? city}) async {
    return await remoteDataSource.getClubs(city: city);
  }

  Future<List<CourtModel>> getCourts({required String clubId}) async {
    return await remoteDataSource.getCourts(clubId: clubId);
  }

  Future<void> joinGame(String gameId, String position,
      {String paymentMethod = 'WALLET',
      String? walletPin,
      String? razorpayOrderId,
      String? razorpayPaymentId,
      String? razorpaySignature}) async {
    return await remoteDataSource.joinGame(
      gameId,
      position,
      paymentMethod: paymentMethod,
      walletPin: walletPin,
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
      razorpaySignature: razorpaySignature,
    );
  }

  Future<void> leaveGame(String gameId) async {
    return await remoteDataSource.leaveGame(gameId);
  }

  Future<void> switchTeam(String gameId) async {
    return await remoteDataSource.switchTeam(gameId);
  }

  Future<void> cancelPlayerGame(String gameId, String reason) async {
    return await remoteDataSource.cancelPlayerGame(gameId, reason);
  }

  Future<Map<String, dynamic>> joinWaitlist(
      String gameId, String position) async {
    return await remoteDataSource.joinWaitlist(gameId, position);
  }

  Future<Map<String, dynamic>> leaveWaitlist(String gameId) async {
    return await remoteDataSource.leaveWaitlist(gameId);
  }

  Future<List<VideoModel>> getGameVideos(String gameId) async {
    return await remoteDataSource.getGameVideos(gameId);
  }

  Future<GameModel> createGame(Map<String, dynamic> data) async {
    return await remoteDataSource.createGame(data);
  }
}

import 'package:get/get.dart';
import '../repositories/games_repository.dart';
import '../../../data/models/game_model.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/utils/app_logger.dart';

class GamesController extends GetxController {
  final GamesRepository repository = Get.find<GamesRepository>();

  final RxList<GameModel> games = <GameModel>[].obs;
  final Rxn<GameModel> selectedGame = Rxn<GameModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedCity = 'Raipur'.obs;
  final RxString selectedStatus = 'OPEN_FOR_JOINING'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGames();
  }

  Future<void> fetchGames({bool isRefresh = false}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final list = await repository.getGames(
        city: selectedCity.value,
        status: selectedStatus.value,
      );
      games.assignAll(list);
    } catch (e) {
      AppLogger.warning('Failed to load games: $e');
      errorMessage.value = ErrorHandler.getErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGameDetails(String gameId) async {
    isLoading.value = true;
    try {
      final game = await repository.getGameById(gameId);
      selectedGame.value = game;
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinGame(String gameId, String position) async {
    isLoading.value = true;
    try {
      await repository.joinGame(gameId, position);
      fetchGameDetails(gameId);
      fetchGames();
      ErrorHandler.showSuccessSnackBar('Success', 'Joined match successfully!');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Join Failed', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> leaveGame(String gameId) async {
    isLoading.value = true;
    try {
      await repository.leaveGame(gameId);
      fetchGameDetails(gameId);
      fetchGames();
      ErrorHandler.showSuccessSnackBar(
          'Left Match', 'You have left the match.');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> switchTeam(String gameId) async {
    isLoading.value = true;
    try {
      await repository.switchTeam(gameId);
      fetchGameDetails(gameId);
      ErrorHandler.showSuccessSnackBar(
          'Switched Team', 'You have switched team side');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAndPlayVideo(String gameId) async {
    try {
      final vids = await repository.getGameVideos(gameId);
      if (vids.isNotEmpty && vids.first.playbackUrl.isNotEmpty) {
        Get.toNamed('/videos/player', arguments: vids.first.playbackUrl);
      } else {
        ErrorHandler.showErrorSnackBar(
            'No Video', 'Recording is processing or not available.');
      }
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Playback Error', e);
    }
  }
}

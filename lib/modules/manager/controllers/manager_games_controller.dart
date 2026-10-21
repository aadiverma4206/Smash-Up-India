import 'package:get/get.dart';
import '../repositories/manager_repository.dart';
import '../../../data/models/game_model.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/app_date_utils.dart';

class ManagerGamesController extends GetxController {
  final ManagerRepository repository = Get.find<ManagerRepository>();

  final RxList<GameModel> games = <GameModel>[].obs;
  final Rxn<GameModel> selectedGame = Rxn<GameModel>();
  final RxBool isLoading = false.obs;

  // Search & Filter state
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'ALL'
      .obs; // ALL, TODAY, TOMORROW, SELECT DATE, ONGOING, COMPLETED, CANCELLED
  final Rxn<DateTime> customSelectedDate = Rxn<DateTime>();

  // CCTV playback URL
  final RxnString cctvPlaybackUrl = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchClubGames();
  }

  Future<void> fetchClubGames() async {
    isLoading.value = true;
    try {
      final list = await repository.getClubGames();
      games.assignAll(list);
    } catch (e) {
      ErrorHandler.showErrorSnackBar(
          'Scope Error', 'Forbidden: You can only access assigned club games');
    } finally {
      isLoading.value = false;
    }
  }

  List<GameModel> get filteredGames {
    return games.where((g) {
      // 1. Search Query Filter
      if (searchQuery.value.trim().isNotEmpty) {
        final q = searchQuery.value.trim().toLowerCase();
        final titleMatches = g.title.toLowerCase().contains(q);
        final courtMatches = g.courtName.toLowerCase().contains(q);
        final formatMatches = g.format.toLowerCase().contains(q);
        final statusMatches = g.status.toLowerCase().contains(q);
        if (!titleMatches &&
            !courtMatches &&
            !formatMatches &&
            !statusMatches) {
          return false;
        }
      }

      // 2. Date & Status Filter
      final filter = selectedFilter.value;
      if (filter == 'TODAY') {
        final todayStr = AppDateUtils.formatIsoDate(DateTime.now());
        if (!g.matchDate.startsWith(todayStr)) return false;
      } else if (filter == 'TOMORROW') {
        final tmrwStr = AppDateUtils.formatIsoDate(
            DateTime.now().add(const Duration(days: 1)));
        if (!g.matchDate.startsWith(tmrwStr)) return false;
      } else if (filter == 'SELECT DATE') {
        if (customSelectedDate.value != null) {
          final customStr =
              AppDateUtils.formatIsoDate(customSelectedDate.value!);
          if (!g.matchDate.startsWith(customStr)) return false;
        }
      } else if (filter == 'ONGOING') {
        if (g.status != 'ONGOING' && g.status != 'STARTED') return false;
      } else if (filter == 'COMPLETED') {
        if (g.status != 'COMPLETED') return false;
      } else if (filter == 'CANCELLED') {
        if (g.status != 'CANCELLED') return false;
      }

      return true;
    }).toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void setCustomDate(DateTime date) {
    customSelectedDate.value = date;
    selectedFilter.value = 'SELECT DATE';
  }

  Future<void> fetchMatchRecording(String gameId) async {
    try {
      final res = await repository.getMatchRecording(gameId);
      final url = res['playbackUrl'] ?? res['url'] ?? res['video_playback_url'];
      if (url != null && url.toString().isNotEmpty) {
        cctvPlaybackUrl.value = url.toString();
      }
    } catch (e) {
      AppLogger.warning('Error fetching match CCTV recording: $e');
    }
  }

  /// Manager approves player-created game request
  Future<void> approvePlayerGame(String gameId) async {
    isLoading.value = true;
    try {
      await repository.approvePlayerGame(gameId);
      await fetchClubGames();
      if (selectedGame.value != null && selectedGame.value!.id == gameId) {
        final updated = await repository.getClubGames();
        selectedGame.value = updated.firstWhereOrNull((g) => g.id == gameId);
      }
      ErrorHandler.showSuccessSnackBar(
          'Match Approved!', 'Match has been approved and scheduled on court.');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Approval Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Manager rejects player-created game request
  Future<void> rejectPlayerGame(String gameId, String reason) async {
    isLoading.value = true;
    try {
      await repository.rejectPlayerGame(gameId, reason);
      await fetchClubGames();
      if (selectedGame.value != null && selectedGame.value!.id == gameId) {
        final updated = await repository.getClubGames();
        selectedGame.value = updated.firstWhereOrNull((g) => g.id == gameId);
      }
      ErrorHandler.showSuccessSnackBar(
          'Match Rejected', 'Match rejected and entry fees refunded.');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Rejection Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Manager cancels match & issues atomic wallet refunds
  Future<void> cancelMatchWithRefunds(String gameId, String reason) async {
    isLoading.value = true;
    try {
      await repository.cancelGameWithRefunds(gameId, reason);
      await fetchClubGames();
      if (selectedGame.value != null && selectedGame.value!.id == gameId) {
        final updated = await repository.getClubGames();
        selectedGame.value = updated.firstWhereOrNull((g) => g.id == gameId);
      }
      ErrorHandler.showSuccessSnackBar('Match Cancelled',
          'Match cancelled and refunds processed to player wallets.');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Cancellation Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Manager starts match -> Triggers backend CCTV recording lifecycle automatically
  Future<void> startGame(String gameId) async {
    isLoading.value = true;
    try {
      final updated = await repository.startGame(gameId);
      selectedGame.value = updated;
      fetchClubGames();
      ErrorHandler.showSuccessSnackBar('Match Started',
          'Match is now ONGOING. CCTV recording auto-started!');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Start Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Submit or update Live Score
  Future<void> submitMatchScore(String gameId, int scoreA, int scoreB,
      {bool isFinal = true}) async {
    isLoading.value = true;
    try {
      await repository.submitMatchScore(gameId, scoreA, scoreB,
          isFinal: isFinal);
      await fetchClubGames();
      if (selectedGame.value != null && selectedGame.value!.id == gameId) {
        final updated = await repository.getClubGames();
        selectedGame.value = updated.firstWhereOrNull((g) => g.id == gameId);
      }
      ErrorHandler.showSuccessSnackBar(
          'Score Recorded', 'Live match score updated to $scoreA - $scoreB');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Score Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Manager completes match -> Enters POST_MATCH window (+15m deadline)
  Future<void> completeGame(
      String gameId, int teamAScore, int teamBScore) async {
    isLoading.value = true;
    try {
      final updated =
          await repository.completeGame(gameId, teamAScore, teamBScore);
      selectedGame.value = updated;
      fetchClubGames();
      await fetchMatchRecording(gameId);
      ErrorHandler.showSuccessSnackBar(
          'Match Completed', 'Final Score: $teamAScore - $teamBScore');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Complete Error', e);
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:get/get.dart';
import '../repositories/player_repository.dart';
import '../../../data/models/game_model.dart';

class MatchHistoryController extends GetxController {
  final PlayerRepository repository = Get.find<PlayerRepository>();

  final RxList<GameModel> allHistoryList = <GameModel>[].obs;
  final RxList<GameModel> filteredHistoryList = <GameModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxString selectedResultFilter = 'ALL'.obs; // ALL, WIN, LOSS, DRAW
  final RxString selectedFormatFilter = 'ALL'.obs; // ALL, 5v5, 7v7, 11v11, etc.

  final resultFilters = ['ALL', 'WIN', 'LOSS', 'DRAW'];
  final formatFilters = ['ALL', '5v5', '7v7', '11v11'];

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final list = await repository.getHistory(limit: 50, offset: 0);
      allHistoryList.value = list;
      applyFilters();
    } catch (e) {
      allHistoryList.clear();
      filteredHistoryList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    var result = List<GameModel>.from(allHistoryList);

    if (selectedResultFilter.value != 'ALL') {
      result = result
          .where((g) => (g.winnerTeam ?? 'DRAW') == selectedResultFilter.value)
          .toList();
    }

    if (selectedFormatFilter.value != 'ALL') {
      result = result
          .where((g) =>
              g.format.toUpperCase() ==
              selectedFormatFilter.value.toUpperCase())
          .toList();
    }

    filteredHistoryList.value = result;
  }

  void setResultFilter(String val) {
    selectedResultFilter.value = val;
    applyFilters();
  }

  void setFormatFilter(String val) {
    selectedFormatFilter.value = val;
    applyFilters();
  }
}

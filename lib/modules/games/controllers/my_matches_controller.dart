import 'package:get/get.dart';
import '../../player/repositories/player_repository.dart';
import '../../../data/models/game_model.dart';

class MyMatchesController extends GetxController {
  final PlayerRepository repository = Get.find<PlayerRepository>();

  final RxString selectedTab =
      'UPCOMING'.obs; // UPCOMING, ONGOING, COMPLETED, CANCELLED, WAITLISTED
  final RxList<GameModel> matchesList = <GameModel>[].obs;
  final RxBool isLoading = false.obs;

  final tabs = ['UPCOMING', 'ONGOING', 'COMPLETED', 'CANCELLED', 'WAITLISTED'];

  @override
  void onInit() {
    super.onInit();
    fetchMyMatches(selectedTab.value);
  }

  Future<void> fetchMyMatches(String tab) async {
    selectedTab.value = tab;
    isLoading.value = true;
    try {
      final list = await repository.getMyMatches(tab: tab);
      matchesList.value = list;
    } catch (e) {
      matchesList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

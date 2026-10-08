import 'package:get/get.dart';
import '../repositories/player_repository.dart';
import '../../../data/models/slot_request_model.dart';

class MyRequestsController extends GetxController {
  final PlayerRepository repository = Get.find<PlayerRepository>();

  final RxString selectedTab =
      'ALL'.obs; // ALL, PENDING, APPROVED, REJECTED, WAITLISTED
  final RxList<SlotRequestModel> requestsList = <SlotRequestModel>[].obs;
  final RxBool isLoading = false.obs;

  final tabs = ['ALL', 'PENDING', 'APPROVED', 'REJECTED', 'WAITLISTED'];

  @override
  void onInit() {
    super.onInit();
    fetchRequests(selectedTab.value);
  }

  Future<void> fetchRequests(String tab) async {
    selectedTab.value = tab;
    isLoading.value = true;
    try {
      final list = await repository.getPlayerRequests(statusTab: tab);
      requestsList.value = list;
    } catch (e) {
      requestsList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

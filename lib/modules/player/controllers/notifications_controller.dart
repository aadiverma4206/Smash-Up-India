import 'package:get/get.dart';
import '../repositories/player_repository.dart';
import '../../../data/models/notification_model.dart';
import '../../../core/security/deep_link_service.dart';
import '../../../core/errors/error_handler.dart';

class NotificationsController extends GetxController {
  final PlayerRepository repository = Get.find<PlayerRepository>();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt currentPage = 1.obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
    }
    isLoading.value = true;

    try {
      final list = await repository.getNotifications(page: currentPage.value);
      if (isRefresh) {
        notifications.assignAll(list);
      } else {
        notifications.addAll(list);
      }
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsReadAndNavigate(NotificationModel item) async {
    try {
      await repository.markNotificationRead(item.id);
      final idx = notifications.indexWhere((n) => n.id == item.id);
      if (idx != -1) {
        notifications[idx] = NotificationModel(
          id: item.id,
          title: item.title,
          body: item.body,
          type: item.type,
          data: item.data,
          isRead: true,
          createdAt: item.createdAt,
        );
      }

      // Handle deep links based on notification payload data
      if (item.data != null && item.data!['link'] != null) {
        final uri = Uri.parse(item.data!['link']);
        DeepLinkService.handleUri(uri);
      }
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    }
  }
}

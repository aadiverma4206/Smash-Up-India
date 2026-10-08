import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../player/controllers/notifications_controller.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../app/theme/app_colors.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const AppLoader(message: 'Loading notifications...');
        }

        if (controller.notifications.isEmpty) {
          return const EmptyStateWidget(
            title: 'No Notifications',
            subtitle: 'You are all caught up!',
            icon: Icons.notifications_off_outlined,
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(isRefresh: true),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = controller.notifications[index];
              return ListTile(
                tileColor: item.isRead
                    ? Colors.transparent
                    : AppColors.primary.withValues(alpha: 0.08),
                leading: CircleAvatar(
                  backgroundColor: _getIconColor(item.type),
                  child: Icon(
                    _getNotificationIcon(item.type),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight:
                        item.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  item.body,
                  softWrap: true,
                ),
                trailing: Text(
                  AppDateUtils.formatRelativeTime(item.createdAt),
                  style: TextStyle(fontSize: 10, color: context.textSecondary),
                ),
                onTap: () => controller.markAsReadAndNavigate(item),
              );
            },
          ),
        );
      }),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'MATCH_STARTING':
      case 'MATCH_STARTED':
        return Icons.sports_soccer;
      case 'BOOKING':
        return Icons.stadium;
      case 'WALLET_TOPUP':
      case 'REFUND':
        return Icons.account_balance_wallet;
      case 'CCTV_STARTED':
      case 'CCTV_COMPLETED':
        return Icons.videocam;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'REFUND':
      case 'WALLET_TOPUP':
        return Colors.green;
      case 'MATCH_STARTING':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }
}

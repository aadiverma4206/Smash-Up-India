import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_requests_controller.dart';
import '../../../data/models/slot_request_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/app_date_utils.dart';

class MyRequestsView extends StatelessWidget {
  const MyRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyRequestsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Slot Requests',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Filter Tabs
          _buildTabBar(context, controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const AppLoader(
                    message: 'Loading your slot requests...');
              }
              if (controller.requestsList.isEmpty) {
                return EmptyStateWidget(
                  title: 'No Slot Requests',
                  subtitle:
                      'No ${controller.selectedTab.value.toLowerCase()} slot requests found.',
                );
              }
              return RefreshIndicator(
                onRefresh: () =>
                    controller.fetchRequests(controller.selectedTab.value),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.requestsList.length,
                  itemBuilder: (context, index) {
                    final req = controller.requestsList[index];
                    return _buildRequestCard(context, req);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, MyRequestsController controller) {
    return Container(
      color: context.cardColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: controller.tabs.map((tab) {
            return Obx(() {
              final isSelected = controller.selectedTab.value == tab;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(tab,
                      style: TextStyle(
                          color:
                              isSelected ? Colors.white : context.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: context.cardColor,
                  onSelected: (selected) {
                    if (selected) controller.fetchRequests(tab);
                  },
                ),
              );
            });
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, SlotRequestModel req) {
    Color statusColor = AppColors.primary;
    if (req.status == 'PENDING') statusColor = Colors.amber;
    if (req.status == 'APPROVED') statusColor = Colors.green;
    if (req.status == 'REJECTED') statusColor = Colors.redAccent;
    if (req.status == 'WAITLISTED') statusColor = Colors.purpleAccent;

    return Card(
      color: context.cardColor,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    req.status,
                    style: TextStyle(
                      color:
                          req.status == 'PENDING' ? Colors.black : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Pos: ${req.position}',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              req.gameTitle ?? 'Football Match',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              '${req.clubName ?? "Arena"} • ${req.courtName ?? "Pitch"}',
              style: TextStyle(color: context.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                    '${AppDateUtils.formatDate(req.matchDate)}  ${AppDateUtils.formatTime(req.startTime)}',
                    style:
                        TextStyle(color: context.textSecondary, fontSize: 12)),
              ],
            ),

            // Rejection reason banner if rejected
            if (req.status == 'REJECTED' &&
                req.rejectionReason != null &&
                req.rejectionReason!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: Colors.redAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Rejection Reason: ${req.rejectionReason}',
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: statusColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () =>
                    Get.toNamed('/games/details', arguments: req.gameId),
                child: Text('View Match Details',
                    style: TextStyle(
                        color: statusColor, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/manager_dashboard_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';

class ManagerCourtsView extends GetView<ManagerDashboardController> {
  const ManagerCourtsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Court Pitch & Slot Control'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              if (controller.courts.isNotEmpty) {
                final selectedIndex = controller.selectedCourtIndex.value;
                final courtId = controller.courts[selectedIndex].id;
                controller.fetchCourtSlots(courtId);
              } else {
                controller.loadManagerData();
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.courts.isEmpty) {
          return const AppLoader(message: 'Loading court pitches...');
        }

        if (controller.courts.isEmpty) {
          return const EmptyStateWidget(
            title: 'No Courts Found',
            subtitle: 'No court pitches are registered for this assigned club.',
            icon: Icons.stadium_outlined,
          );
        }

        final selectedIndex = controller.selectedCourtIndex.value
            .clamp(0, controller.courts.length - 1);
        final selectedCourt = controller.courts[selectedIndex];

        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadManagerData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Court Selector Tabs (Court 1, Court 2, etc.)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(controller.courts.length, (index) {
                      final court = controller.courts[index];
                      final isSelected = index == selectedIndex;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          avatar: Icon(
                            Icons.stadium_rounded,
                            size: 16,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                          label: Text(
                            court.name,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.textPrimaryDark
                                      : Colors.black87),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark
                                      ? AppColors.darkBorder
                                      : const Color(0xFFE2E8F0)),
                            ),
                          ),
                          onSelected: (_) => controller.selectCourt(index),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),

                // Selected Court Information Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.primary.withValues(alpha: 0.3),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.stadium_rounded,
                            color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedCourt.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Surface: ${selectedCourt.surfaceType} • Status: ${selectedCourt.status}',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '₹${selectedCourt.basePricePerHour.toStringAsFixed(0)}/hr',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Court Slots Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedCourt.name} Slots Today',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? AppColors.textPrimaryDark : Colors.black87,
                      ),
                    ),
                    Obx(
                      () => Text(
                        '${controller.currentCourtSlots.length} Slots',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Slot List Body
                Obx(() {
                  if (controller.isSlotsLoading.value) {
                    return const AppLoader(message: 'Fetching court slots...');
                  }

                  if (controller.currentCourtSlots.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : const Color(0xFFEEEEEE),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'No slots scheduled for ${selectedCourt.name} today.',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: controller.currentCourtSlots
                        .map((slot) => _buildSlotCard(context, slot))
                        .toList(),
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSlotCard(BuildContext context, Map<String, dynamic> slot) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String timeStr = (slot['time'] ??
            '${slot['startTime'] ?? "18:00"} - ${slot['endTime'] ?? "19:30"}')
        .toString();
    final String status = (slot['status'] ?? slot['slotStatus'] ?? 'SCHEDULED')
        .toString()
        .toUpperCase();
    final String gameTitle =
        (slot['gameTitle'] ?? slot['title'] ?? 'Available Slot').toString();
    final String hostName =
        (slot['hostName'] ?? slot['host'] ?? 'N/A').toString();
    final int currentPlayers =
        int.tryParse(slot['currentPlayers']?.toString() ?? '0') ?? 0;
    final int maxPlayers =
        int.tryParse(slot['maxPlayers']?.toString() ?? '22') ?? 22;
    final String paymentStatus =
        (slot['paymentStatus'] ?? 'PAID').toString().toUpperCase();
    final String recordingStatus =
        (slot['recordingStatus'] ?? 'AVAILABLE').toString().toUpperCase();

    Color statusColor;
    switch (status) {
      case 'STARTED':
      case 'ONGOING':
        statusColor = Colors.orange;
        break;
      case 'COMPLETED':
        statusColor = Colors.green;
        break;
      case 'CANCELLED':
      case 'REJECTED':
        statusColor = Colors.redAccent;
        break;
      case 'PENDING':
        statusColor = Colors.amber;
        break;
      default:
        statusColor = AppColors.primary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_filled_rounded,
                      color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:
                          isDark ? AppColors.textPrimaryDark : Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor, width: 0.8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            gameTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Host: $hostName • Roster: $currentPlayers / $maxPlayers Players',
            style: TextStyle(
              color:
                  isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Payment: $paymentStatus',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'CCTV: $recordingStatus',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

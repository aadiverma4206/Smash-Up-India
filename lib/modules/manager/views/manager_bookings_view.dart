import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/manager_dashboard_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/app_date_utils.dart';

class ManagerBookingsView extends GetView<ManagerDashboardController> {
  const ManagerBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Club Bookings')),
      body: Obx(() {
        if (controller.bookings.isEmpty) {
          return const EmptyStateWidget(
            title: 'No Bookings Found',
            subtitle: 'No pitch bookings recorded for this club yet.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.receipt_long,
                          color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.courtName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: context.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${AppDateUtils.formatDate(booking.bookingDate)} (${AppDateUtils.formatTimeRange(booking.startTime, booking.endTime)})',
                            style: TextStyle(
                                color: context.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹${booking.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

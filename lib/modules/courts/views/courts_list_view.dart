import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/courts_controller.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../app/theme/app_colors.dart';

class CourtsListView extends GetView<CourtsController> {
  const CourtsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Turf Pitches')),
      body: Obx(() {
        if (controller.isLoading.value && controller.courts.isEmpty) {
          return const AppLoader(message: 'Loading courts...');
        }

        if (controller.courts.isEmpty) {
          return const EmptyStateWidget(
            title: 'No Courts Available',
            subtitle: 'Check back later for available turf pitches.',
            icon: Icons.stadium,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.courts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final court = controller.courts[index];
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
                      child: const Icon(Icons.stadium,
                          color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            court.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${court.clubName} • ${court.surfaceType} • ${court.city}',
                            style: TextStyle(
                                color: context.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹${court.basePricePerHour.toStringAsFixed(0)}/hr',
                      style: const TextStyle(
                        color: AppColors.secondary,
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

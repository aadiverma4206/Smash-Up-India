import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cctv_controller.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../app/theme/app_colors.dart';

class CctvListView extends GetView<CctvController> {
  const CctvListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CCTV Cameras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed('/manager/cctv/add'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.cameras.isEmpty) {
          return const AppLoader(message: 'Loading CCTV cameras...');
        }

        if (controller.cameras.isEmpty) {
          return const EmptyStateWidget(
            title: 'No CCTV Cameras',
            subtitle: 'Add an RTSP Dome camera for pitch match recording.',
            icon: Icons.videocam_off_outlined,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.cameras.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final cam = controller.cameras[index];
            final isOnline =
                cam.status == 'ONLINE' && cam.healthStatus == 'ONLINE';

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isOnline ? AppColors.primary : AppColors.error,
                  width: 1.2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.videocam,
                          color: isOnline ? AppColors.primary : AppColors.error,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            cam.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isOnline
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : AppColors.error.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            cam.healthStatus,
                            style: TextStyle(
                              color: isOnline
                                  ? AppColors.primary
                                  : AppColors.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Court: ${cam.courtName ?? "Unassigned"} • Type: ${cam.cameraType}',
                      style:
                          TextStyle(color: context.textSecondary, fontSize: 13),
                    ),
                    Text(
                      'IP: ${cam.ipAddress ?? "Hidden"}',
                      style:
                          TextStyle(color: context.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () => controller.testCamera(cam.id),
                        icon: const Icon(Icons.network_check_rounded, size: 16),
                        label: const Text('Test Connection',
                            style: TextStyle(fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
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

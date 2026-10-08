import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../app/theme/app_colors.dart';

class AdminUsersView extends GetView<AdminController> {
  AdminUsersView({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppTextField(
              label: '',
              hint: 'Search Email, Phone or Name...',
              controller: searchController,
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward_rounded,
                    color: AppColors.primary),
                onPressed: () {
                  controller.searchQuery.value = searchController.text.trim();
                  controller.fetchUsers();
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.users.isEmpty) {
                  return const AppLoader(message: 'Loading users...');
                }

                if (controller.users.isEmpty) {
                  return Center(
                      child: Text('No users found.',
                          style: TextStyle(color: context.textSecondary)));
                }

                return ListView.separated(
                  itemCount: controller.users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final user = controller.users[index];
                    final isSuspended = user.status == 'SUSPENDED';

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: context.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user.email,
                                        style: TextStyle(
                                            color: context.textSecondary,
                                            fontSize: 13),
                                        softWrap: true,
                                      ),
                                      Text(
                                        user.phone,
                                        style: TextStyle(
                                            color: context.textSecondary,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isSuspended
                                        ? AppColors.error
                                            .withValues(alpha: 0.15)
                                        : AppColors.primary
                                            .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    user.status,
                                    style: TextStyle(
                                      color: isSuspended
                                          ? AppColors.error
                                          : AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Role: ${user.roleName}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (isSuspended) {
                                      controller.unsuspendUser(user.id);
                                    } else {
                                      controller.suspendUser(user.id);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSuspended
                                        ? AppColors.primary
                                        : AppColors.error,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    isSuspended ? 'Unsuspend' : 'Suspend',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

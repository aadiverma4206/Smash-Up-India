import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../data/models/session_model.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../app/theme/app_colors.dart';

class SessionsView extends GetView<AuthController> {
  const SessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Sessions')),
      body: FutureBuilder<List<SessionModel>>(
        future: controller.repository.getSessions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader(message: 'Loading active sessions...');
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final sessions = snapshot.data ?? [];
          if (sessions.isEmpty) {
            return const Center(child: Text('No active sessions found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final session = sessions[index];
              return Card(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.devices, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    session.deviceInfo ?? 'Unknown Device',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary),
                  ),
                  subtitle: Text(
                    'IP: ${session.ipAddress ?? "Hidden"}',
                    style: TextStyle(color: context.textSecondary),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.logout_rounded,
                        color: AppColors.error),
                    tooltip: 'Revoke Session',
                    onPressed: () async {
                      await controller.repository.revokeSession(session.id);
                      Get.snackbar(
                        'Session Revoked',
                        'Device session was successfully terminated.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.error,
                        colorText: Colors.white,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/player_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/storage/database_service.dart';
import '../../../core/widgets/app_loader.dart';

class ProfileView extends GetView<PlayerController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Player Passport',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, size: 28),
            tooltip: 'Edit Profile',
            onPressed: () => Get.toNamed('/player/profile/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Data',
            onPressed: controller.loadPlayerData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.profile.value == null) {
          return const AppLoader(message: 'Loading Player Passport...');
        }

        final p = controller.profile.value;
        final s = controller.stats.value;

        if (p == null) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_off_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No player profile data found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: controller.loadPlayerData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry Loading'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadPlayerData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Player Card Header
                _buildHeroHeader(context, p),
                const SizedBox(height: 20),

                // 2. Performance Stats Summary Grid
                _buildStatsSummaryCard(context, s),
                const SizedBox(height: 20),

                // 3. Personal Attributes Card
                _buildSectionHeader(
                    context, 'Player Attributes', Icons.badge_outlined),
                const SizedBox(height: 10),
                _buildAttributesCard(context, p),
                const SizedBox(height: 20),

                // 4. Quick Account & Navigation Settings
                _buildSectionHeader(
                    context, 'Account & Navigation', Icons.tune_rounded),
                const SizedBox(height: 10),
                _buildAccountNavigationCard(context),
                const SizedBox(height: 20),

                // 5. Preferences & Storage Management
                _buildSectionHeader(
                    context, 'Preferences & Cache', Icons.sd_storage_outlined),
                const SizedBox(height: 10),
                _buildPreferencesAndStorageCard(context),
                const SizedBox(height: 24),

                // 6. Prominent Logout Action Button
                _buildLogoutCard(context),
                const SizedBox(height: 32),

                // App Footer
                Center(
                  child: Column(
                    children: const [
                      Text(
                        'SMASH UP INDIA • v1.0.0',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'LIVE. PLAY. CONNECT.',
                        style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  /// 1. Hero Player Banner
  Widget _buildHeroHeader(BuildContext context, dynamic p) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.secondary, width: 2.5),
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          p.name.isNotEmpty ? p.name[0].toUpperCase() : 'P',
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => Get.toNamed('/player/profile/edit'),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                // Name, Email, Position
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.verified,
                              size: 18, color: AppColors.primary),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.email,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _buildBadgeChip(p.position, AppColors.primary),
                          _buildBadgeChip(
                              '${p.preferredFoot} FOOT', Colors.blueGrey),
                          _buildBadgeChip(p.skillLevel, AppColors.secondary,
                              textColor: Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // OVR Rating
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'OVR',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${p.ovr}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeChip(String label, Color color,
      {Color textColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  /// 2. Performance Stats Summary Grid
  Widget _buildStatsSummaryCard(BuildContext context, dynamic s) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Career Performance',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Win Rate: ${s?.winRatePercentage.toStringAsFixed(0) ?? 0}%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                if (width > 360) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                            'Matches',
                            '${s?.matchesPlayed ?? 0}',
                            Icons.sports_soccer,
                            Colors.blue),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatBox('Goals', '${s?.goalsScored ?? 0}',
                            Icons.sports_score, AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatBox('Assists', '${s?.assists ?? 0}',
                            Icons.handshake, AppColors.secondary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatBox('MOTM', '${s?.motmCount ?? 0}',
                            Icons.star_rounded, Colors.orange),
                      ),
                    ],
                  );
                }
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.8,
                  children: [
                    _buildStatBox('Matches', '${s?.matchesPlayed ?? 0}',
                        Icons.sports_soccer, Colors.blue),
                    _buildStatBox('Goals', '${s?.goalsScored ?? 0}',
                        Icons.sports_score, AppColors.primary),
                    _buildStatBox('Assists', '${s?.assists ?? 0}',
                        Icons.handshake, AppColors.secondary),
                    _buildStatBox('MOTM', '${s?.motmCount ?? 0}',
                        Icons.star_rounded, Colors.orange),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 3. Attributes List Card
  Widget _buildAttributesCard(BuildContext context, dynamic p) {
    return Card(
      child: Column(
        children: [
          _buildInfoRow(
              context, 'Home City', p.city, Icons.location_city_rounded),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildInfoRow(context, 'Preferred Foot', p.preferredFoot,
              Icons.sports_football),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildInfoRow(
              context, 'Pitch Position', p.position, Icons.stadium_rounded),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildInfoRow(context, 'Player Bio', p.bio ?? 'No bio set yet',
              Icons.notes_rounded),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Account & Navigation Cards
  Widget _buildAccountNavigationCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: AppColors.primary),
            title: const Text('Edit Player Profile'),
            subtitle: const Text('Update city, position, foot, bio'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed('/player/profile/edit'),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined,
                color: AppColors.secondary),
            title: const Text('Wallet & Payments'),
            subtitle: const Text('Manage coins & transactions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed('/wallet'),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.devices_rounded, color: AppColors.accent),
            title: const Text('Active Device Sessions'),
            subtitle: const Text('View and revoke active login tokens'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed('/sessions'),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined,
                color: Colors.orange),
            title: const Text('Match Notifications'),
            subtitle: const Text('View match alerts & CCTV clip notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed('/notifications'),
          ),
        ],
      ),
    );
  }

  /// 5. Preferences & Cache Management Card
  Widget _buildPreferencesAndStorageCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Obx(() {
            final currentMode = Get.isRegistered<ThemeService>()
                ? ThemeService.to.themeMode.value
                : ThemeMode.dark;
            final isDarkMode = currentMode == ThemeMode.dark;

            return ListTile(
              leading: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDarkMode ? Colors.amber : Colors.orangeAccent,
              ),
              title: const Text('App Visual Theme'),
              subtitle:
                  Text(isDarkMode ? 'Dark Arena Theme' : 'Light Arena Theme'),
              trailing: Switch(
                value: isDarkMode,
                activeThumbColor: AppColors.primary,
                onChanged: (val) {
                  if (Get.isRegistered<ThemeService>()) {
                    ThemeService.to.switchThemeMode(
                        val ? ThemeMode.dark : ThemeMode.light);
                  }
                },
              ),
            );
          }),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading:
                const Icon(Icons.cleaning_services_rounded, color: Colors.cyan),
            title: const Text('Clear Local Database Cache'),
            subtitle: const Text('Remove cached match records'),
            trailing: OutlinedButton(
              onPressed: () async {
                if (Get.isRegistered<DatabaseService>()) {
                  await Get.find<DatabaseService>().clearAllData();
                  Get.snackbar(
                    'Cache Purged',
                    'SQLite local database cache has been successfully cleared.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.primary,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text('Clear DB', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  /// 6. Prominent Logout Action Card
  Widget _buildLogoutCard(BuildContext context) {
    return Card(
      color: AppColors.error.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.error, width: 1.2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showLogoutConfirmationDialog(context),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Log Out & Purge Device Session',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final RxBool isLoggingOut = false.obs;

    Get.dialog(
      AlertDialog(
        backgroundColor: context.cardColor,
        title: Text('Log Out of Arena?',
            style: TextStyle(color: context.textPrimary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.power_settings_new_rounded,
                  color: AppColors.error, size: 48),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to log out? This action will wipe session tokens and purge local match cache.',
                style: TextStyle(
                    fontSize: 13, color: context.textSecondary, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          Obx(() {
            if (isLoggingOut.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.error),
              );
            }
            return Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      isLoggingOut.value = true;
                      await AuthService.to.logout();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error),
                    child: const Text('Log Out'),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      barrierDismissible: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/manager_dashboard_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';

class ManagerPlayersView extends StatefulWidget {
  const ManagerPlayersView({super.key});

  @override
  State<ManagerPlayersView> createState() => _ManagerPlayersViewState();
}

class _ManagerPlayersViewState extends State<ManagerPlayersView> {
  late final ManagerDashboardController controller;
  final TextEditingController searchController = TextEditingController();
  final RxString selectedStatus = 'ALL'.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ManagerDashboardController>();
    controller.fetchAllPlayers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    controller.fetchAllPlayers(
      search: query.trim().isEmpty ? null : query.trim(),
      status: (selectedStatus.value == 'ALL' || selectedStatus.value == 'ALL PLAYERS')
          ? null
          : selectedStatus.value,
    );
  }

  void _onStatusFilter(String status) {
    selectedStatus.value = status;
    controller.fetchAllPlayers(
      search: searchController.text.trim().isEmpty
          ? null
          : searchController.text.trim(),
      status: (status == 'ALL' || status == 'ALL PLAYERS') ? null : status,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('All Players Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.fetchAllPlayers(
              search: searchController.text.trim().isEmpty
                  ? null
                  : searchController.text.trim(),
              status: selectedStatus.value == 'ALL'
                  ? null
                  : selectedStatus.value,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filters
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: _onSearchChanged,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : Colors.black87,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search players by name, phone, or position...',
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey.shade500,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.primary),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: ['ALL', 'ACTIVE', 'BLOCKED'].map((status) {
                      return Obx(() {
                        final isSelected = selectedStatus.value == status;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(
                              status,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? AppColors.textPrimaryDark
                                        : Colors.black87),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            backgroundColor: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark
                                        ? AppColors.darkBorder
                                        : const Color(0xFFE2E8F0)),
                              ),
                            ),
                            onSelected: (_) => _onStatusFilter(status),
                          ),
                        );
                      });
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Player List Body
            Expanded(
              child: Obx(() {
                if (controller.isActionLoading.value &&
                    controller.playersList.isEmpty) {
                  return const AppLoader(message: 'Fetching player directory...');
                }

                if (controller.playersList.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No Players Found',
                    subtitle: 'No player accounts match the given criteria.',
                    icon: Icons.people_outline_rounded,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchAllPlayers(
                    search: searchController.text.trim().isEmpty
                        ? null
                        : searchController.text.trim(),
                    status: selectedStatus.value == 'ALL'
                        ? null
                        : selectedStatus.value,
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: controller.playersList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final player = controller.playersList[index];
                      return _buildPlayerCard(context, player);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCard(
      BuildContext context, Map<String, dynamic> player) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String playerId = (player['id'] ?? player['userId'] ?? '').toString();
    final String name = (player['name'] ?? 'Player').toString();
    final String phone = (player['phone'] ?? player['email'] ?? '').toString();
    final String position = (player['position'] ?? 'ST').toString();
    final int elo = int.tryParse(player['elo']?.toString() ?? '750') ?? 750;
    final bool isBlocked =
        (player['status']?.toString().toUpperCase() == 'BLOCKED') ||
            (player['status']?.toString().toUpperCase() == 'SUSPENDED') ||
            (player['isBlocked'] == true);
    final String? avatarUrl = player['avatarUrl']?.toString() ??
        player['profileImageUrl']?.toString();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isBlocked
              ? Colors.redAccent.withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE)),
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: avatarUrl,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _defaultAvatar(name),
                      )
                    : _defaultAvatar(name),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isBlocked
                                ? Colors.redAccent.withValues(alpha: 0.15)
                                : Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isBlocked
                                  ? Colors.redAccent
                                  : Colors.green,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            isBlocked ? 'BLOCKED' : 'ACTIVE',
                            style: TextStyle(
                              color: isBlocked
                                  ? Colors.redAccent
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$phone • Pos: $position • ELO: $elo',
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
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isBlocked) ...[
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                  ),
                  onPressed: () => _confirmUnblock(context, playerId, name),
                  icon: const Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 16),
                  label: const Text('Unblock Player',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ] else ...[
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                  ),
                  onPressed: () => _showBlockModal(context, playerId, name),
                  icon: const Icon(Icons.block_rounded,
                      color: Colors.redAccent, size: 16),
                  label: const Text('Block Player',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar(String name) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'P',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  void _showBlockModal(BuildContext context, String playerId, String name) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Block Player: $name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Restricting player access will prevent them from joining matches at this turf.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Enter reason for blocking player...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Get.back();
              await controller.blockPlayer(
                  playerId, reasonController.text.trim());
            },
            child: const Text('Confirm Block',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmUnblock(BuildContext context, String playerId, String name) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Unblock Player: $name'),
        content: Text(
          'Are you sure you want to restore match access for $name?',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Get.back();
              await controller.unblockPlayer(playerId);
            },
            child: const Text('Confirm Unblock',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

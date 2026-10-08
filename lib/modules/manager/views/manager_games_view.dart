import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/manager_games_controller.dart';
import '../../../data/models/game_model.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../app/theme/app_colors.dart';

class ManagerGamesView extends GetView<ManagerGamesController> {
  const ManagerGamesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Club Matches & CCTV Control',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.fetchClubGames,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search Bar & Filter Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: searchController,
                    onChanged: (val) => controller.searchQuery.value = val,
                    style: TextStyle(
                      color:
                          isDark ? AppColors.textPrimaryDark : Colors.black87,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search by match title, court, format...',
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey.shade500,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.primary),
                      suffixIcon: Obx(() {
                        return controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  searchController.clear();
                                  controller.searchQuery.value = '';
                                },
                              )
                            : const SizedBox.shrink();
                      }),
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

                  // Date & Status Filter Chips Horizontal Scroll
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Obx(() {
                      final selected = controller.selectedFilter.value;
                      final customDate = controller.customSelectedDate.value;

                      final filters = [
                        {'key': 'ALL', 'label': 'ALL'},
                        {'key': 'TODAY', 'label': 'TODAY'},
                        {'key': 'TOMORROW', 'label': 'TOMORROW'},
                        {
                          'key': 'SELECT DATE',
                          'label': customDate != null
                              ? AppDateUtils.formatDate(customDate,
                                  format: 'dd MMM')
                              : 'SELECT DATE'
                        },
                        {'key': 'ONGOING', 'label': 'ONGOING'},
                        {'key': 'COMPLETED', 'label': 'COMPLETED'},
                        {'key': 'CANCELLED', 'label': 'CANCELLED'},
                      ];

                      return Row(
                        children: filters.map((f) {
                          final key = f['key'] as String;
                          final label = f['label'] as String;
                          final isSelected = selected == key;

                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: ChoiceChip(
                              avatar: key == 'SELECT DATE'
                                  ? Icon(Icons.calendar_month_rounded,
                                      size: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.primary)
                                  : null,
                              label: Text(
                                label,
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
                              onSelected: (_) async {
                                if (key == 'SELECT DATE') {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: customDate ?? DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 365)),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                  );
                                  if (picked != null) {
                                    controller.setCustomDate(picked);
                                  }
                                } else {
                                  controller.setFilter(key);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // 📋 Matches List Body
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.games.isEmpty) {
                  return const AppLoader(message: 'Loading club matches...');
                }

                final displayList = controller.filteredGames;

                if (displayList.isEmpty) {
                  return EmptyStateWidget(
                    title: 'No Matches Found',
                    subtitle: controller.searchQuery.value.isNotEmpty ||
                            controller.selectedFilter.value != 'ALL'
                        ? 'No matches match your active search or filter.'
                        : 'No matches scheduled for your assigned club.',
                    icon: Icons.sports_soccer_rounded,
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchClubGames,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    itemCount: displayList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final game = displayList[index];
                      return _buildCompactMatchCard(context, game);
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

  /// ⚽ Compact & Responsive Match Card matching Screenshot 3 design
  Widget _buildCompactMatchCard(BuildContext context, GameModel game) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusUpper = game.status.toUpperCase();
    final isOngoing = statusUpper == 'ONGOING' || statusUpper == 'STARTED';
    final isCompleted = statusUpper == 'COMPLETED';
    final isCancelled = statusUpper == 'CANCELLED';

    final slotsLeft = (game.maxPlayers - game.currentPlayers).clamp(0, game.maxPlayers);

    Color statusColor;
    String statusLabel = statusUpper;
    switch (statusUpper) {
      case 'STARTED':
      case 'ONGOING':
        statusColor = Colors.orange;
        statusLabel = 'ONGOING';
        break;
      case 'COMPLETED':
        statusColor = Colors.green;
        statusLabel = 'COMPLETED';
        break;
      case 'CANCELLED':
        statusColor = Colors.redAccent;
        statusLabel = 'CANCELLED';
        break;
      default:
        statusColor = Colors.amber.shade800;
        statusLabel = 'SCHEDULED';
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Left Time/Status Box + Right Info Box
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Box: Time & Status Badge
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkInputBg : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      game.startTime.length >= 5
                          ? game.startTime.substring(0, 5)
                          : game.startTime,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textPrimaryDark : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Right Section: Badges, Title, Date, Court, Roster
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Badges Row: Format, Open Slots, Privacy
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: Colors.blue.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            game.format,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: Colors.green.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            'OPEN ($slotsLeft SLOTS LEFT)',
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            game.privacy,
                            style: TextStyle(
                                color: Colors.amber.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Title
                    Text(
                      game.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Date & Time
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 13, color: Colors.amber),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${game.matchDate} (${game.startTime}-${game.endTime})',
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : Colors.grey.shade700,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Location / Court
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${game.courtName} (${game.format})',
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : Colors.grey.shade700,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Roster Count & Fee
                    Row(
                      children: [
                        const Icon(Icons.people_outline_rounded,
                            size: 13, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          '${game.currentPlayers}/${game.maxPlayers} Players',
                          style: TextStyle(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '₹${game.perPlayerFee.toStringAsFixed(0)}/player',
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Divider(color: isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE), height: 18),

          // Bottom Action Buttons Bar matching Screenshot 3
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                // View Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    controller.selectedGame.value = game;
                    Get.toNamed('/manager/games/details');
                  },
                  icon: const Icon(Icons.visibility_outlined,
                      color: AppColors.primary, size: 14),
                  label: const Text('View',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                ),
                const SizedBox(width: 6),

                // Start Match Button (if not completed/cancelled)
                if (!isCompleted && !isCancelled) ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOngoing ? Colors.orange : AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      controller.selectedGame.value = game;
                      if (!isOngoing) {
                        controller.startGame(game.id);
                      } else {
                        Get.toNamed('/manager/games/details');
                      }
                    },
                    icon: Icon(
                        isOngoing
                            ? Icons.play_circle_fill_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 14),
                    label: Text(
                        isOngoing ? 'Live Score' : 'Start Match',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11)),
                  ),
                  const SizedBox(width: 6),
                ],

                // Edit Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    controller.selectedGame.value = game;
                    Get.toNamed('/manager/games/details');
                  },
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColors.primary, size: 14),
                  label: const Text('Edit',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                ),
                const SizedBox(width: 6),

                // Remove / Cancel Button
                if (!isCancelled) ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => _confirmCancelMatch(context, game),
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: Colors.white, size: 14),
                    label: const Text('Remove',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCancelMatch(BuildContext context, GameModel game) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel Match: ${game.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cancelling will trigger automatic full refunds to all joined player wallets.',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Enter reason for match cancellation...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.back();
              controller.cancelMatchWithRefunds(
                  game.id, reasonController.text.trim());
            },
            child: const Text('Cancel & Issue Refunds',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

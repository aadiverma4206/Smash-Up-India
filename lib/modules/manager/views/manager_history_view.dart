import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/manager_games_controller.dart';
import '../../../data/models/game_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/app_date_utils.dart';

class ManagerHistoryView extends StatefulWidget {
  const ManagerHistoryView({super.key});

  @override
  State<ManagerHistoryView> createState() => _ManagerHistoryViewState();
}

class _ManagerHistoryViewState extends State<ManagerHistoryView> {
  late final ManagerGamesController controller;
  final TextEditingController searchController = TextEditingController();
  final RxString activeFilter = 'ALL'.obs; // ALL, COMPLETED, CANCELLED

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ManagerGamesController>()) {
      controller = Get.find<ManagerGamesController>();
    } else {
      controller = Get.put(ManagerGamesController());
    }
    controller.fetchClubGames();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<GameModel> get historyGames {
    final query = searchController.text.trim().toLowerCase();
    final filter = activeFilter.value;

    return controller.games.where((game) {
      final statusUpper = game.status.toUpperCase();
      final isHistory = statusUpper == 'COMPLETED' || statusUpper == 'CANCELLED';
      if (!isHistory) return false;

      if (filter == 'COMPLETED' && statusUpper != 'COMPLETED') return false;
      if (filter == 'CANCELLED' && statusUpper != 'CANCELLED') return false;

      if (query.isNotEmpty) {
        final titleMatches = game.title.toLowerCase().contains(query);
        final courtMatches = game.courtName.toLowerCase().contains(query);
        final formatMatches = game.format.toLowerCase().contains(query);
        if (!titleMatches && !courtMatches && !formatMatches) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Match History & Records',
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
            // 🔍 Search Bar & Filter Chips
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : Colors.black87,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search completed or cancelled matches...',
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey.shade500,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(Icons.history_rounded,
                          color: AppColors.primary),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                searchController.clear();
                                setState(() {});
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

                  // Filter Chips
                  Row(
                    children: ['ALL', 'COMPLETED', 'CANCELLED'].map((filter) {
                      return Obx(() {
                        final isSelected = activeFilter.value == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(
                              filter,
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
                            onSelected: (_) {
                              activeFilter.value = filter;
                              setState(() {});
                            },
                          ),
                        );
                      });
                    }).toList(),
                  ),
                ],
              ),
            ),

            // History List Body
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.games.isEmpty) {
                  return const AppLoader(message: 'Loading match history...');
                }

                final displayList = historyGames;

                if (displayList.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No Match History',
                    subtitle: 'No completed or cancelled matches recorded yet.',
                    icon: Icons.history_rounded,
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchClubGames,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: displayList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final game = displayList[index];
                      return _buildHistoryCard(context, game);
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

  Widget _buildHistoryCard(BuildContext context, GameModel game) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = game.status.toUpperCase() == 'COMPLETED';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withValues(alpha: 0.4)
              : Colors.redAccent.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.selectedGame.value = game;
            Get.toNamed('/games/details');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        game.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (isCompleted ? Colors.green : Colors.redAccent)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: isCompleted ? Colors.green : Colors.redAccent),
                      ),
                      child: Text(
                        game.status.toUpperCase(),
                        style: TextStyle(
                          color: isCompleted ? Colors.green : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        game.courtName,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        game.format,
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${AppDateUtils.formatDate(game.matchDate, format: "EEE, dd MMM yyyy")} (${AppDateUtils.formatTimeRange(game.startTime, game.endTime)})',
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
                if (isCompleted) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Final Score: Team A ${game.teamAScore} - ${game.teamBScore} Team B',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

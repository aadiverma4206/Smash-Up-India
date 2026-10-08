import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_matches_controller.dart';
import '../../../data/models/game_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/app_date_utils.dart';

class MyMatchesView extends StatelessWidget {
  const MyMatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyMatchesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Matches',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // 5 Tabs Bar
          _buildTabBar(context, controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const AppLoader(message: 'Loading your matches...');
              }
              if (controller.matchesList.isEmpty) {
                return EmptyStateWidget(
                  title: 'No Matches Found',
                  subtitle:
                      'No ${controller.selectedTab.value.toLowerCase()} matches found.',
                );
              }
              return RefreshIndicator(
                onRefresh: () =>
                    controller.fetchMyMatches(controller.selectedTab.value),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.matchesList.length,
                  itemBuilder: (context, index) {
                    final game = controller.matchesList[index];
                    return _buildMyMatchCard(
                        context, game, controller.selectedTab.value);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, MyMatchesController controller) {
    return Container(
      color: context.cardColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: controller.tabs.map((tab) {
            return Obx(() {
              final isSelected = controller.selectedTab.value == tab;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(tab,
                      style: TextStyle(
                          color:
                              isSelected ? Colors.white : context.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: context.cardColor,
                  onSelected: (selected) {
                    if (selected) controller.fetchMyMatches(tab);
                  },
                ),
              );
            });
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMyMatchCard(BuildContext context, GameModel game, String tab) {
    Color statusColor = AppColors.primary;
    if (tab == 'ONGOING') statusColor = Colors.orange;
    if (tab == 'COMPLETED') statusColor = AppColors.secondary;
    if (tab == 'CANCELLED') statusColor = Colors.redAccent;
    if (tab == 'WAITLISTED') statusColor = Colors.purpleAccent;

    return Card(
      color: context.cardColor,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor.withValues(alpha: 0.4), width: 1.5),
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/games/details', arguments: game.id),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tab == 'WAITLISTED'
                          ? 'RESERVE #${game.waitlistPosition ?? 1}'
                          : game.status,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    game.format,
                    style: TextStyle(
                        color: context.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                game.title,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                '${game.clubName} • ${game.courtName}',
                style: TextStyle(color: context.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                      '${AppDateUtils.formatDate(game.matchDate)} • ${AppDateUtils.formatTimeRange(game.startTime, game.endTime)}',
                      style: TextStyle(
                          color: context.textSecondary, fontSize: 12)),
                ],
              ),
              if (game.userTeam != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: game.userTeam == 'TEAM_A'
                            ? Colors.blue
                            : Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Your Side: ${game.userTeam}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (game.userPosition != null) ...[
                      const SizedBox(width: 8),
                      Text('Pos: ${game.userPosition}',
                          style: TextStyle(
                              color: context.textSecondary, fontSize: 12)),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

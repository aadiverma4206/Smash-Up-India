import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/games_controller.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../app/theme/app_colors.dart';

class GamesListView extends GetView<GamesController> {
  const GamesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Games'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.games.isEmpty) {
          return const AppLoader(message: 'Loading pickup games...');
        }

        if (controller.games.isEmpty) {
          return EmptyStateWidget(
            title: 'No Games Found',
            subtitle: 'No active games in ${controller.selectedCity.value}',
            icon: Icons.sports_soccer,
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchGames(isRefresh: true),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.games.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final game = controller.games[index];
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    controller.fetchGameDetails(game.id);
                    Get.toNamed('/games/details',
                        arguments: {'gameId': game.id});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '📍 ${game.clubName} • ${game.courtName}',
                          style: TextStyle(
                              color: context.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '📅 ${AppDateUtils.formatDate(game.matchDate)} (${AppDateUtils.formatTimeRange(game.startTime, game.endTime)})',
                          style: TextStyle(
                              color: context.textSecondary, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${game.currentPlayers}/${game.maxPlayers} Players',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '₹${game.perPlayerFee.toStringAsFixed(0)} / player',
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

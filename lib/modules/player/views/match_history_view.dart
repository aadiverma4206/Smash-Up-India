import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/match_history_controller.dart';
import '../../../data/models/game_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/app_date_utils.dart';

class MatchHistoryView extends StatelessWidget {
  const MatchHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MatchHistoryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match History',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.fetchHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          _buildFilterBar(context, controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const AppLoader(message: 'Loading match history...');
              }
              if (controller.filteredHistoryList.isEmpty) {
                return const EmptyStateWidget(
                  title: 'No Match History',
                  subtitle: 'You have not completed any matches yet.',
                );
              }
              return RefreshIndicator(
                onRefresh: controller.fetchHistory,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredHistoryList.length,
                  itemBuilder: (context, index) {
                    final game = controller.filteredHistoryList[index];
                    return _buildHistoryCard(context, game);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(
      BuildContext context, MatchHistoryController controller) {
    return Container(
      color: context.cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Result Filter Chips
          Obx(
            () => Row(
              children: controller.resultFilters.map((res) {
                final isSelected = controller.selectedResultFilter.value == res;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(res,
                        style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : context.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                    selected: isSelected,
                    selectedColor: res == 'WIN'
                        ? Colors.green
                        : (res == 'LOSS' ? Colors.red : AppColors.primary),
                    backgroundColor: context.cardColor,
                    onSelected: (selected) {
                      if (selected) controller.setResultFilter(res);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, GameModel game) {
    final result = game.winnerTeam ?? 'DRAW';
    Color resultColor = AppColors.primary;
    if (result == 'WIN') resultColor = Colors.green;
    if (result == 'LOSS') resultColor = Colors.redAccent;
    if (result == 'DRAW') resultColor = Colors.amber;

    return Card(
      color: context.cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: resultColor.withValues(alpha: 0.4), width: 1.5),
      ),
      child: ListTile(
        onTap: () => Get.toNamed('/games/details', arguments: game.id),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: resultColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            result.substring(0, 1),
            style: TextStyle(
                color: resultColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        title: Text(game.title,
            style: TextStyle(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
                '${game.clubName} • ${AppDateUtils.formatDate(game.matchDate)}',
                style: TextStyle(color: context.textSecondary, fontSize: 12)),
            const SizedBox(height: 2),
            Text(
                'Score: ${game.teamAScore} - ${game.teamBScore}  (${game.format})',
                style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            size: 14, color: context.textSecondary),
      ),
    );
  }
}

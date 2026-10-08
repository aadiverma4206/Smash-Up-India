import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard Rankings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Raipur Ranking'),
              Tab(text: 'India Ranking'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLeaderboardList('Raipur'),
            _buildLeaderboardList('India'),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardList(String scope) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      index == 0 ? AppColors.secondary : AppColors.primary,
                  child: Text(
                    '#${index + 1}',
                    style: TextStyle(
                      color: index == 0 ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Player ${index + 1}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: context.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Scope: $scope • OVR: ${88 - index * 2}',
                        style: TextStyle(
                            color: context.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${20 - index} Wins',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

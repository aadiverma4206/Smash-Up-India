import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arena Community Feed')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Footballer ${index + 1}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: context.textPrimary),
                            ),
                            Text(
                              '2 hours ago',
                              style: TextStyle(
                                  fontSize: 12, color: context.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Looking for 2 players for a 5v5 pickup game tonight at 8 PM! DM or join via match code.',
                    style: TextStyle(height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 20,
                    runSpacing: 8,
                    children: const [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.thumb_up_alt_outlined,
                              size: 18, color: AppColors.primary),
                          SizedBox(width: 6),
                          Text('12 Likes', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.comment_outlined,
                              size: 18, color: AppColors.accent),
                          SizedBox(width: 6),
                          Text('5 Comments', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

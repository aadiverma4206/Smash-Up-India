import 'package:flutter/material.dart';
import '../../../core/widgets/empty_state.dart';

class TournamentsListView extends StatelessWidget {
  const TournamentsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournaments & Brackets')),
      body: const EmptyStateWidget(
        title: 'Tournaments Arena',
        subtitle: 'No active knockout tournaments at the moment.',
        icon: Icons.emoji_events,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class NetworkBanner extends StatelessWidget {
  final bool isConnected;

  const NetworkBanner({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    if (isConnected) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: AppColors.error,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: const Text(
        'Offline Mode - No Internet Connection',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

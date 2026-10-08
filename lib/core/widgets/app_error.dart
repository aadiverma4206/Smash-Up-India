import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lowerMsg = message.toLowerCase();

    IconData iconData = Icons.error_outline_rounded;
    String title = 'Something went wrong';

    if (lowerMsg.contains('internet') ||
        lowerMsg.contains('connection') ||
        lowerMsg.contains('offline') ||
        lowerMsg.contains('wifi') ||
        lowerMsg.contains('timed out')) {
      iconData = Icons.wifi_off_rounded;
      title = 'No Internet Connection';
    } else if (lowerMsg.contains('server') ||
        lowerMsg.contains('500') ||
        lowerMsg.contains('502') ||
        lowerMsg.contains('503') ||
        lowerMsg.contains('gateway')) {
      iconData = Icons.dns_rounded;
      title = 'Server Unavailable';
    } else if (lowerMsg.contains('session') ||
        lowerMsg.contains('unauthorized') ||
        lowerMsg.contains('permission') ||
        lowerMsg.contains('forbidden')) {
      iconData = Icons.lock_outline_rounded;
      title = 'Access Denied';
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, size: 48, color: AppColors.error),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.isNotEmpty
                  ? message
                  : 'An unexpected error occurred. Please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded,
                    size: 20, color: Colors.white),
                label: const Text(
                  'Try Again',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

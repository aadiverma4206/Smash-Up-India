import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final double? imageSize;
  final double? imageWidth;
  final String? darkImagePath;
  final String? lightImagePath;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.imageSize,
    this.imageWidth,
    this.darkImagePath,
    this.lightImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String imageAssetPath = isDark
        ? (darkImagePath ?? 'assets/images/No_data/dark.png')
        : (lightImagePath ?? 'assets/images/No_data/light.png');

    final screenWidth = MediaQuery.of(context).size.width;
    final double targetWidth =
        imageWidth ?? imageSize ?? (screenWidth * 0.65).clamp(220.0, 360.0);

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: targetWidth,
              child: Image.asset(
                imageAssetPath,
                width: targetWidth,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    icon ?? Icons.inbox_rounded,
                    size: 64,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

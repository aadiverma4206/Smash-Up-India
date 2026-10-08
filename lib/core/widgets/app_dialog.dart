import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AppDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              height: 1.4,
            ),
          ),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (cancelText != null)
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (onCancel != null) onCancel();
                  },
                  child: Text(cancelText),
                ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (onConfirm != null) onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(confirmText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

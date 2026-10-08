import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  final String? message;

  const AppLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: TextStyle(color: context.textSecondary),
            ),
          ]
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class PaymentProcessingOverlay extends StatelessWidget {
  final bool isVisible;
  final String statusText;

  const PaymentProcessingOverlay({
    super.key,
    required this.isVisible,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          // Glassmorphism background blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: (isDark ? Colors.black : Colors.white).withValues(
                alpha: 0.6,
              ),
            ),
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(28),
              constraints: const BoxConstraints(maxWidth: 380),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Smooth loading pulse with primary green color & shield icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 76,
                        width: 76,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Status Text
                  Text(
                    statusText.isEmpty ? 'Processing Payment...' : statusText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Security Sub-text
                  Text(
                    "Please don't close the app or press back.",
                    style: TextStyle(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Visual Progress Step Dots
                  _buildProgressSteps(context, statusText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSteps(BuildContext context, String currentStatus) {
    final steps = [
      'Creating Order...',
      'Connecting Payment...',
      'Opening Razorpay...',
      'Waiting for Payment...',
      'Verifying Payment...',
      'Finalizing Game Creation...',
    ];

    int currentIndex = steps.indexOf(currentStatus);
    if (currentIndex == -1) currentIndex = 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (index) {
        final isCompleted = index < currentIndex;
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 4,
          width: isActive ? 24 : 16,
          decoration: BoxDecoration(
            color: isCompleted || isActive
                ? AppColors.primary
                : context.borderColor,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

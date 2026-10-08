import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_button.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class PaymentResultView extends StatelessWidget {
  const PaymentResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map args = Get.arguments ?? {};
    final bool isSuccess = args['success'] == true;
    final String? amount = args['amount'];
    final String? gameTitle = args['gameTitle'];
    final String? gameId = args['gameId'];
    final String? error = args['error'];

    final isGamePayment = gameTitle != null || gameId != null;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success / Failure Icon with subtle green container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: (isSuccess ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess
                        ? Icons.check_circle_rounded
                        : Icons.error_rounded,
                    size: 80,
                    color: isSuccess ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  isSuccess
                      ? (isGamePayment
                          ? 'Match Created & Paid!'
                          : 'Payment Successful!')
                      : 'Payment Failed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Text(
                  isSuccess
                      ? (isGamePayment
                          ? '₹${amount ?? "200"} Paid • Your 11v11 match "${gameTitle ?? "Football Showdown"}" is now live on SMASH UP INDIA lobby!'
                          : '₹${amount ?? "1000"} added to your SMASH UP INDIA wallet.')
                      : (error ??
                          'Payment could not be completed. Please try again.'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 36),

                if (isGamePayment && isSuccess && gameId != null) ...[
                  AppButton(
                    text: 'View Match Details',
                    showArrow: true,
                    onPressed: () {
                      Get.offAllNamed(Routes.home);
                      Get.toNamed(Routes.gameDetails,
                          arguments: {'gameId': gameId});
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: BorderSide(color: context.borderColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Get.offAllNamed(Routes.home),
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                          color: context.textPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ] else ...[
                  AppButton(
                    text: isGamePayment ? 'Back to Home' : 'Back to Wallet',
                    showArrow: true,
                    onPressed: () {
                      if (isGamePayment) {
                        Get.offAllNamed(Routes.home);
                      } else {
                        Get.offAllNamed(Routes.home);
                        Get.toNamed('/wallet');
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

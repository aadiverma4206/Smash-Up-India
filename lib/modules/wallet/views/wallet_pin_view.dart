import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallet_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class WalletPinView extends GetView<WalletController> {
  WalletPinView({super.key});

  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.home);
              Get.toNamed(Routes.wallet);
            }
          },
        ),
        title: const Text('Set Up Wallet PIN'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set 6-Digit Security PIN',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Your 6-digit PIN is required for joining paid matches and court bookings.',
              style: TextStyle(color: context.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'New 6-Digit PIN',
              hint: '123456',
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.lock_outline_rounded,
                  color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Confirm PIN',
              hint: '123456',
              controller: confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.lock_outline_rounded,
                  color: AppColors.primary),
            ),
            const SizedBox(height: 28),
            Obx(
              () => AppButton(
                text: 'Save Security PIN',
                showArrow: true,
                isLoading: controller.isLoading.value,
                onPressed: () {
                  if (pinController.text.trim() !=
                      confirmPinController.text.trim()) {
                    Get.snackbar(
                      'PIN Mismatch',
                      'PINs do not match. Please re-enter.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.error,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  controller.setupWalletPin(pinController.text.trim());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

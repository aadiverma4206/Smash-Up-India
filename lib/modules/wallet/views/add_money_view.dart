import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallet_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/responsive/responsive_builder.dart';

class AddMoneyView extends GetView<WalletController> {
  AddMoneyView({super.key});

  final TextEditingController amountController =
      TextEditingController(text: '1000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        title: const Text('Add Money to Wallet'),
      ),
      body: ResponsiveBuilder(
        builder: (context, deviceType) {
          final isTabletOrDesktop = deviceType == DeviceType.desktop ||
              deviceType == DeviceType.tablet;
          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;
          final maxContainerWidth =
              (isTabletOrDesktop || isLandscape) ? 600.0 : double.infinity;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContainerWidth),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Top-up Amount',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Maximum single top-up is ₹50,000',
                      style: TextStyle(color: context.textSecondary),
                    ),
                    const SizedBox(height: 20),

                    AppTextField(
                      label: 'Amount (₹)',
                      hint: 'Enter Amount',
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.currency_rupee,
                          color: AppColors.primary),
                    ),
                    const SizedBox(height: 20),

                    // Quick Preset Chips
                    Text(
                      'Quick Add Options',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['500', '1000', '2000', '5000'].map((preset) {
                        return ActionChip(
                          label: Text('₹$preset'),
                          onPressed: () {
                            amountController.text = preset;
                            controller.selectedTopupAmount.value = preset;
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 36),

                    Obx(
                      () => AppButton(
                        text: 'Proceed to Pay with Razorpay',
                        showArrow: true,
                        isLoading: controller.isLoading.value,
                        onPressed: () {
                          final amt =
                              double.tryParse(amountController.text.trim()) ??
                                  0.0;
                          controller.initiateTopup(amt);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

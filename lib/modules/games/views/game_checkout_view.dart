import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_game_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/payment_processing_overlay.dart';
import '../../../core/utils/app_date_utils.dart';

class GameCheckoutView extends GetView<CreateGameController> {
  const GameCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final feeStr = controller.entryFeeController.text.trim().isEmpty
        ? '200'
        : controller.entryFeeController.text.trim();
    final fee = double.tryParse(feeStr) ?? 200.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Match Payment & Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⚽ Section 1: Match Summary
                Text(
                  'Match Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                _buildMatchSummaryCard(context),
                const SizedBox(height: 20),

                // 💳 Section 2: Pricing Breakdown
                Text(
                  'Payment Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                _buildPricingSummaryCard(context, fee),
                const SizedBox(height: 20),

                // 🏦 Section 3: Select Payment Option
                Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                _buildPaymentMethodsCard(context, fee),
                const SizedBox(height: 20),

                // ⚡ Test Mode Info Notice
                _buildTestModeNoticeCard(context),
                const SizedBox(height: 24),

                // 🚀 Primary Host Match Button
                Obx(
                  () => AppButton(
                    text: 'Host Match & Open Player Slots',
                    isLoading: controller.isProcessing.value,
                    onPressed: controller.executePaymentAndCreateGame,
                  ),
                ),
                const SizedBox(height: 12),

                // Instant Test Payment Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.bolt_rounded, color: Colors.amber),
                  label: const Text(
                    '⚡ Quick Test Payment (Instant Success)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  onPressed: controller.isProcessing.value
                      ? null
                      : controller.processTestModePayment,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // Glassmorphism Overlay during active payment
          Obx(
            () => PaymentProcessingOverlay(
              isVisible: controller.isProcessing.value,
              statusText: controller.paymentStatus.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchSummaryCard(BuildContext context) {
    final title = controller.titleController.text.trim().isEmpty
        ? '11v11 Football Showdown'
        : controller.titleController.text.trim();
    final courtName = controller.selectedCourt.value?.name ?? 'Court 1';
    final reserves = controller.reservePlayersController.text.trim().isEmpty
        ? '0'
        : controller.reservePlayersController.text.trim();
    final dateFormatted = controller.selectedDate.value != null
        ? AppDateUtils.formatDate(controller.selectedDate.value!,
            format: 'EEEE, dd MMM yyyy')
        : 'Tomorrow';
    final timeRange =
        (controller.startTime.value != null && controller.endTime.value != null)
            ? AppDateUtils.formatTimeRange(
                controller.startTime.value!, controller.endTime.value!)
            : '6:00 PM - 7:30 PM';
    final skillText = controller.skillRequirement.value ?? 'INTERMEDIATE';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.sports_soccer_rounded,
                    color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'All Stars Arena • $courtName',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(color: context.borderColor, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(dateFormatted,
                      style:
                          TextStyle(fontSize: 12, color: context.textPrimary)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(timeRange,
                      style:
                          TextStyle(fontSize: 12, color: context.textPrimary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '11v11 (22 Main + $reserves Subs)',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  skillText,
                  style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSummaryCard(BuildContext context, double fee) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Host Entry Fee',
                  style: TextStyle(color: context.textSecondary, fontSize: 13)),
              Text('₹${fee.toStringAsFixed(0)}',
                  style: TextStyle(
                      color: context.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Arena Platform Fee',
                  style: TextStyle(color: context.textSecondary, fontSize: 13)),
              const Text('₹0 (Included)',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
          Divider(color: context.borderColor, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount Payable',
                  style: TextStyle(
                      color: context.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              Text('₹${fee.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard(BuildContext context, double fee) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Obx(() {
        final selected = controller.selectedPaymentMethod.value;

        return Column(
          children: [
            // Option 1: Razorpay
            InkWell(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              onTap: () => controller.selectedPaymentMethod.value = 'RAZORPAY',
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(
                      selected == 'RAZORPAY'
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: selected == 'RAZORPAY'
                          ? AppColors.primary
                          : context.textSecondary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.payment_rounded,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Razorpay Gateway (UPI, Cards)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: context.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Supports GooglePay, PhonePe, Cards & Test Mode',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Divider(color: context.borderColor, height: 1),

            // Option 2: Wallet
            InkWell(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
              onTap: () => controller.selectedPaymentMethod.value = 'WALLET',
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(
                      selected == 'WALLET'
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: selected == 'WALLET'
                          ? AppColors.primary
                          : context.textSecondary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.account_balance_wallet_rounded,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'SMASH UP INDIA Wallet',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: context.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Available Balance: ₹${controller.walletBalance.value.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: controller.walletBalance.value >= fee
                                  ? AppColors.primary
                                  : AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTestModeNoticeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Razorpay Test Mode Active. You can make test payments or click Quick Test Payment for instant verification.',
              style: TextStyle(fontSize: 11, color: context.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

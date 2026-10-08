import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_history_controller.dart';
import '../../../data/models/wallet_models.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../app/routes/app_routes.dart';

class PlayerPaymentHistoryView extends StatelessWidget {
  const PlayerPaymentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlayerPaymentHistoryController());

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
        title: const Text('Payment Ledger History',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.fetchTransactions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          _buildFilterBar(context, controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const AppLoader(message: 'Loading ledger history...');
              }
              if (controller.filteredTransactions.isEmpty) {
                return const EmptyStateWidget(
                  title: 'No Payments Found',
                  subtitle: 'No payment transaction records found.',
                );
              }
              return RefreshIndicator(
                onRefresh: controller.fetchTransactions,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = controller.filteredTransactions[index];
                    return _buildTransactionCard(context, tx);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(
      BuildContext context, PlayerPaymentHistoryController controller) {
    return Container(
      color: context.cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: controller.typeFilters.map((type) {
          return Obx(() {
            final isSelected = controller.selectedTypeFilter.value == type;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(type,
                    style: TextStyle(
                        color:
                            isSelected ? Colors.white : context.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: context.cardColor,
                onSelected: (selected) {
                  if (selected) controller.setTypeFilter(type);
                },
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionCard(
      BuildContext context, WalletTransactionModel tx) {
    final isTopup =
        tx.transactionType == 'TOPUP' || tx.transactionType == 'REFUND';
    final amountColor = isTopup ? Colors.green : Colors.redAccent;

    return Card(
      color: context.cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isTopup
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tx.transactionType,
                    style: TextStyle(
                        color: amountColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '${isTopup ? "+" : "-"} ₹${tx.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: amountColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tx.description,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Balance After: ₹${tx.balanceAfter.toStringAsFixed(2)}',
              style: TextStyle(color: context.textSecondary, fontSize: 12),
            ),
            if (tx.providerPaymentId != null &&
                tx.providerPaymentId!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Razorpay Ref: ${tx.providerPaymentId}',
                style: const TextStyle(
                    color: Colors.amber, fontSize: 11, fontFamily: 'monospace'),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              'TX ID: ${tx.id} • ${AppDateUtils.formatDateTime(tx.createdAt)}',
              style: TextStyle(color: context.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

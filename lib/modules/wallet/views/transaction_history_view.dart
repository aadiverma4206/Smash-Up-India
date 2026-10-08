import 'package:all_stars_arena/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallet_controller.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../app/routes/app_routes.dart';

class TransactionHistoryView extends GetView<WalletController> {
  const TransactionHistoryView({super.key});

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
        title: const Text('Transaction History'),
      ),
      body: Obx(() {
        if (controller.transactions.isEmpty) {
          return const EmptyStateWidget(
            title: 'No Transactions',
            subtitle: 'Your wallet transaction statement is empty.',
            icon: Icons.receipt_long_outlined,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.transactions.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final tx = controller.transactions[index];
            final isCredit =
                tx.transactionType == 'TOPUP' || tx.transactionType == 'REFUND';

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isCredit
                    ? Colors.green.withValues(alpha: 0.12)
                    : Colors.red.withValues(alpha: 0.12),
                child: Icon(
                  isCredit ? Icons.add_circle : Icons.remove_circle,
                  color: isCredit ? Colors.green : Colors.red,
                ),
              ),
              title: Text(
                tx.description,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: context.textPrimary),
                softWrap: true,
              ),
              subtitle: Text(
                'ID: ${tx.id} • ${AppDateUtils.formatDateTime(tx.createdAt)}',
                style: TextStyle(color: context.textSecondary, fontSize: 12),
              ),
              trailing: Text(
                '${isCredit ? "+" : "-"}₹${tx.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isCredit ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

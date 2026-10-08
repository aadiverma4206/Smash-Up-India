import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallet_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_shimmer.dart';
import '../../../core/errors/error_handler.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../app/routes/app_routes.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  void _showSetupPinDialog(BuildContext context) {
    final pinController = TextEditingController();
    final confirmPinController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: context.borderColor),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield_rounded,
                          color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set Up Wallet PIN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          Text(
                            'Create a secret 6-digit PIN',
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
                const SizedBox(height: 18),
                AppTextField(
                  label: 'New 6-Digit PIN',
                  controller: pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Confirm 6-Digit PIN',
                  controller: confirmPinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  prefixIcon: const Icon(Icons.lock_clock_outlined,
                      color: AppColors.primary),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Cancel',
                          style: TextStyle(color: context.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        final pin = pinController.text.trim();
                        final confirm = confirmPinController.text.trim();

                        if (pin.length != 6 ||
                            !RegExp(r'^\d{6}$').hasMatch(pin)) {
                          ErrorHandler.showErrorSnackBar('Invalid PIN',
                              'Wallet PIN must be exactly 6 numeric digits');
                          return;
                        }

                        if (pin != confirm) {
                          ErrorHandler.showErrorSnackBar('PIN Mismatch',
                              'PIN and confirmation PIN do not match');
                          return;
                        }

                        controller.setupWalletPin(pin);
                      },
                      child: const Text('Set Up PIN',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangePinDialog(BuildContext context) {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmNewPinController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: context.borderColor),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.published_with_changes_rounded,
                          color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Change Wallet PIN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          Text(
                            'Update your 6-digit security PIN',
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
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Current 6-Digit PIN',
                  controller: oldPinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  prefixIcon: const Icon(Icons.lock_open_outlined,
                      color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'New 6-Digit PIN',
                  controller: newPinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Confirm New 6-Digit PIN',
                  controller: confirmNewPinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  prefixIcon: const Icon(Icons.lock_clock_outlined,
                      color: AppColors.primary),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Cancel',
                          style: TextStyle(color: context.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        final oldPin = oldPinController.text.trim();
                        final newPin = newPinController.text.trim();
                        final confirmNew = confirmNewPinController.text.trim();

                        if (oldPin.length != 6 ||
                            !RegExp(r'^\d{6}$').hasMatch(oldPin)) {
                          ErrorHandler.showErrorSnackBar('Invalid Current PIN',
                              'Current PIN must be 6 numeric digits');
                          return;
                        }

                        if (newPin.length != 6 ||
                            !RegExp(r'^\d{6}$').hasMatch(newPin)) {
                          ErrorHandler.showErrorSnackBar('Invalid New PIN',
                              'New PIN must be 6 numeric digits');
                          return;
                        }

                        if (newPin != confirmNew) {
                          ErrorHandler.showErrorSnackBar('PIN Mismatch',
                              'New PIN and confirmation PIN do not match');
                          return;
                        }

                        controller.changeWalletPin(oldPin, newPin);
                      },
                      child: const Text('Update PIN',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 3D Blink Loading Skeleton View (AppShimmer)
  Widget _buildWalletSkeletonView(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Total Balance Card Skeleton
          const AppShimmer(
            width: double.infinity,
            height: 150,
            borderRadius: 22,
          ),
          const SizedBox(height: 16),

          // 2. PIN Alert Banner Skeleton
          const AppShimmer(
            width: double.infinity,
            height: 72,
            borderRadius: 16,
          ),
          const SizedBox(height: 16),

          // 3. Add Money Button Skeleton
          const AppShimmer(
            width: double.infinity,
            height: 52,
            borderRadius: 30,
          ),
          const SizedBox(height: 28),

          // 4. Recent Transactions Header Skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AppShimmer(width: 160, height: 22, borderRadius: 8),
              AppShimmer(width: 60, height: 18, borderRadius: 6),
            ],
          ),
          const SizedBox(height: 16),

          // 5. Transaction Item Skeletons
          ...List.generate(
            3,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: AppShimmer(
                width: double.infinity,
                height: 64,
                borderRadius: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 6. Bottom Security Card Skeleton
          const AppShimmer(
            width: double.infinity,
            height: 80,
            borderRadius: 18,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return PopScope(
        canPop: canPop,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Get.offAllNamed(Routes.home);
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Get.back();
                } else {
                  Get.offAllNamed(Routes.home);
                }
              },
            ),
            title: const Text('Player Wallet',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: ResponsiveBuilder(
            builder: (context, deviceType) {
              final isTabletOrDesktop = deviceType == DeviceType.desktop ||
                  deviceType == DeviceType.tablet;
              final isLandscape =
                  MediaQuery.of(context).orientation == Orientation.landscape;
              final maxContainerWidth =
                  (isTabletOrDesktop || isLandscape) ? 680.0 : double.infinity;

              return Obx(() {
                if (controller.isLoading.value &&
                    controller.wallet.value == null) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContainerWidth),
                      child: _buildWalletSkeletonView(context),
                    ),
                  );
                }

                final w = controller.wallet.value;
                final hasPin = w?.hasPin == true;

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.fetchWalletDetails,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContainerWidth),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Total Balance Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: hasPin
                                      ? [
                                          AppColors.primary,
                                          const Color(0xFF15803D)
                                        ]
                                      : [
                                          const Color(0xFF1E293B),
                                          const Color(0xFF0F172A)
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: hasPin
                                        ? AppColors.primary
                                            .withValues(alpha: 0.25)
                                        : Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Balance',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 13),
                                  ),
                                  const SizedBox(height: 6),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '₹${w?.balance.toStringAsFixed(2) ?? "0.00"}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: hasPin
                                          ? Colors.white.withValues(alpha: 0.15)
                                          : Colors.amber.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: hasPin
                                            ? Colors.white
                                                .withValues(alpha: 0.3)
                                            : Colors.amber
                                                .withValues(alpha: 0.5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          hasPin
                                              ? Icons.verified_user_rounded
                                              : Icons.security_rounded,
                                          color: hasPin
                                              ? Colors.white
                                              : Colors.amber,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          hasPin
                                              ? '6-Digit PIN Active & Secured'
                                              : 'PIN Setup Required',
                                          style: TextStyle(
                                            color: hasPin
                                                ? Colors.white
                                                : Colors.amber,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // PIN Setup Alert Banner (Displayed at top when PIN is not set)
                            if (!hasPin) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color:
                                          Colors.amber.withValues(alpha: 0.4)),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final isNarrow = constraints.maxWidth < 380;
                                    if (isNarrow) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber
                                                      .withValues(alpha: 0.2),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                    Icons.lock_reset_rounded,
                                                    color: Colors.amber,
                                                    size: 24),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Set Up Wallet 6-Digit PIN',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      'Create a 6-digit PIN to secure your wallet balance and authorize match payments.',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: context
                                                            .textSecondary,
                                                        height: 1.3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.amber,
                                                foregroundColor: Colors.black,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () =>
                                                  _showSetupPinDialog(context),
                                              child: const Text('Set Up PIN',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    return Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.amber
                                                .withValues(alpha: 0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                              Icons.lock_reset_rounded,
                                              color: Colors.amber,
                                              size: 24),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Set Up Wallet 6-Digit PIN',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Create a 6-digit PIN to secure your wallet balance and authorize match payments.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: context.textSecondary,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber,
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () =>
                                              _showSetupPinDialog(context),
                                          child: const Text('Set Up PIN',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Add Money (Razorpay) Button - Always opens Add Money directly
                            AppButton(
                              text: '+ Add Money (Razorpay)',
                              showArrow: true,
                              onPressed: () => Get.toNamed('/wallet/add-money'),
                            ),

                            const SizedBox(height: 28),

                            // Transactions Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Transactions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: context.textPrimary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed('/wallet/transactions'),
                                  child: const Text('View All'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Transactions List
                            Obx(() {
                              if (controller.transactions.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: EmptyStateWidget(
                                    title: 'No Transactions Yet',
                                    subtitle:
                                        'Your wallet topup and refund transactions will appear here.',
                                    imageSize: 140,
                                  ),
                                );
                              }

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    controller.transactions.take(5).length,
                                separatorBuilder: (_, __) =>
                                    Divider(color: context.borderColor),
                                itemBuilder: (context, index) {
                                  final tx = controller.transactions[index];
                                  final isCredit =
                                      tx.transactionType == 'TOPUP' ||
                                          tx.transactionType == 'REFUND';

                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: isCredit
                                          ? Colors.green.withValues(alpha: 0.12)
                                          : Colors.red.withValues(alpha: 0.12),
                                      child: Icon(
                                        isCredit
                                            ? Icons.add_circle_outline_rounded
                                            : Icons
                                                .remove_circle_outline_rounded,
                                        color: isCredit
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    title: Text(
                                      tx.description,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: context.textPrimary),
                                      softWrap: true,
                                    ),
                                    subtitle: Text(
                                      AppDateUtils.formatRelativeTime(
                                          tx.createdAt),
                                      style: TextStyle(
                                          color: context.textSecondary,
                                          fontSize: 12),
                                    ),
                                    trailing: Text(
                                      '${isCredit ? "+" : "-"}₹${tx.amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: isCredit
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),

                            const SizedBox(height: 32),

                            // Bottom Wallet Security & PIN Management Section
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: context.borderColor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.security_rounded,
                                          color: AppColors.primary, size: 22),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Wallet Security',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: context.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final isNarrow =
                                          constraints.maxWidth < 380;
                                      if (isNarrow) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              hasPin
                                                  ? 'Change Wallet 6-Digit PIN'
                                                  : 'Set Up Wallet 6-Digit PIN',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: context.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              hasPin
                                                  ? 'Update your existing 6-digit security PIN'
                                                  : 'Create a 6-digit PIN to secure transactions',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: context.textSecondary,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            SizedBox(
                                              width: double.infinity,
                                              child: OutlinedButton.icon(
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                      color: AppColors.primary),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 14,
                                                      vertical: 10),
                                                ),
                                                onPressed: () {
                                                  if (hasPin) {
                                                    _showChangePinDialog(
                                                        context);
                                                  } else {
                                                    _showSetupPinDialog(
                                                        context);
                                                  }
                                                },
                                                icon: Icon(
                                                  hasPin
                                                      ? Icons.edit_rounded
                                                      : Icons
                                                          .add_circle_outline_rounded,
                                                  size: 16,
                                                  color: AppColors.primary,
                                                ),
                                                label: Text(
                                                  hasPin
                                                      ? 'Change PIN'
                                                      : 'Set Up PIN',
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  hasPin
                                                      ? 'Change Wallet 6-Digit PIN'
                                                      : 'Set Up Wallet 6-Digit PIN',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: context.textPrimary,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  hasPin
                                                      ? 'Update your existing 6-digit security PIN'
                                                      : 'Create a 6-digit PIN to secure transactions',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        context.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          OutlinedButton.icon(
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: AppColors.primary),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 10),
                                            ),
                                            onPressed: () {
                                              if (hasPin) {
                                                _showChangePinDialog(context);
                                              } else {
                                                _showSetupPinDialog(context);
                                              }
                                            },
                                            icon: Icon(
                                              hasPin
                                                  ? Icons.edit_rounded
                                                  : Icons
                                                      .add_circle_outline_rounded,
                                              size: 16,
                                              color: AppColors.primary,
                                            ),
                                            label: Text(
                                              hasPin
                                                  ? 'Change PIN'
                                                  : 'Set Up PIN',
                                              style: const TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_details_controller.dart';
import '../../../data/models/game_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/payment_processing_overlay.dart';
import '../../../core/utils/app_date_utils.dart';

class GameDetailsView extends StatelessWidget {
  const GameDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GameDetailsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.loadGameDetails,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppLoader(message: 'Loading match pitch...');
        }
        final game = controller.game.value;
        if (game == null) {
          return const Center(
              child: Text('Match not found',
                  style: TextStyle(color: Colors.white)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scoreboard & Header Banner
              _buildScoreboard(context, game),
              const SizedBox(height: 16),

              // Match Info Card
              _buildMatchInfoCard(context, game),
              const SizedBox(height: 20),

              // Pitch & Team Rosters Visuals (Team A vs Team B)
              _buildPitchRosters(context, controller, game),
              const SizedBox(height: 20),

              // Action Buttons (Join / Switch Team / Leave / Waitlist)
              _buildMatchActions(context, controller, game),
              const SizedBox(height: 10),

              // Host Cancel Match Card (If current user is host)
              _buildHostCancelCard(context, controller, game),
              const SizedBox(height: 20),

              // CCTV Match Recordings Section
              _buildVideoSection(context, controller, game),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildScoreboard(BuildContext context, GameModel game) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5), width: 1.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  game.format,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (game.status == 'ONGOING' || game.status == 'STARTED')
                      ? Colors.orange
                      : (game.status == 'FULL'
                          ? Colors.purple
                          : AppColors.secondary),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  game.status,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Score Display: Team A vs Team B
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Team A
              Column(
                children: [
                  const Icon(Icons.shield_rounded,
                      color: Colors.blue, size: 36),
                  const SizedBox(height: 4),
                  const Text('TEAM A',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  Text('${game.teamAScore}',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: context.textPrimary)),
                ],
              ),
              Text('VS',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.textSecondary)),
              // Team B
              Column(
                children: [
                  const Icon(Icons.shield_rounded, color: Colors.red, size: 36),
                  const SizedBox(height: 4),
                  const Text('TEAM B',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  Text('${game.teamBScore}',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: context.textPrimary)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchInfoCard(BuildContext context, GameModel game) {
    return Card(
      color: context.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(game.title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.stadium_rounded,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('${game.clubName} (${game.courtName})',
                      style: TextStyle(color: context.textSecondary)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      '${AppDateUtils.formatDate(game.matchDate)} • ${AppDateUtils.formatTimeRange(game.startTime, game.endTime)}',
                      style: TextStyle(color: context.textSecondary)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.currency_rupee_rounded,
                    color: Colors.amber, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      'Entry Fee: ₹${game.perPlayerFee.toStringAsFixed(0)} / player',
                      style: const TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (game.description != null && game.description!.isNotEmpty) ...[
              Divider(color: context.borderColor, height: 20),
              Text('Rules / Notes: ${game.description}',
                  style: TextStyle(color: context.textSecondary, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPitchRosters(
      BuildContext context, GameDetailsController controller, GameModel game) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pitch Roster',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary)),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Team A Column
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('TEAM A',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.blue),
                    if (controller.teamARoster.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('No players yet',
                            style: TextStyle(
                                color: context.textSecondary, fontSize: 12)),
                      )
                    else
                      ...controller.teamARoster.map((p) =>
                          _buildPlayerTile(context, p, Colors.blue, game)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Team B Column
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('TEAM B',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.red),
                    if (controller.teamBRoster.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('No players yet',
                            style: TextStyle(
                                color: context.textSecondary, fontSize: 12)),
                      )
                    else
                      ...controller.teamBRoster.map((p) =>
                          _buildPlayerTile(context, p, Colors.red, game)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerTile(BuildContext context, GameRosterPlayerModel player,
      Color teamColor, GameModel game) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: teamColor,
            child: Text(
              player.position,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.textPrimary, fontSize: 12),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Paid ₹${game.perPlayerFee.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchActions(
      BuildContext context, GameDetailsController controller, GameModel game) {
    if (game.status == 'COMPLETED' || game.status == 'CANCELLED') {
      return const SizedBox();
    }

    final isJoined = controller.isUserInGame;

    if (isJoined) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: controller.switchTeam,
              icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
              label: const Text('Switch Team Side',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent)),
              onPressed: controller.leaveMatch,
              icon: const Icon(Icons.exit_to_app_rounded,
                  color: Colors.redAccent),
              label: const Text('Leave Match',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    }

    // Position Selection Dropdown
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Position to Play:',
            style: TextStyle(color: context.textSecondary, fontSize: 13)),
        const SizedBox(height: 6),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary),
            ),
            child: DropdownButton<String>(
              value: controller.selectedPosition.value,
              isExpanded: true,
              underline: const SizedBox(),
              dropdownColor: context.cardColor,
              style: TextStyle(color: context.textPrimary),
              items: [
                'GK',
                'CB',
                'LB',
                'RB',
                'CDM',
                'CM',
                'CAM',
                'ST',
                'LW',
                'RW'
              ].map((pos) {
                return DropdownMenuItem<String>(
                  value: pos,
                  child: Text('Position: $pos'),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) controller.selectedPosition.value = val;
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (game.status == 'FULL') ...[
          // Waitlist / Reserve Join
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent),
              onPressed: controller.joinWaitlist,
              icon: const Icon(Icons.queue_rounded, color: Colors.white),
              label: const Text('Match Full - Join Reserve Waitlist',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ] else ...[
          // Join Game Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.all(14)),
              onPressed: () {
                controller.requestJoinMatch(context, () {
                  _showJoinPaymentBottomSheet(context, controller, game);
                });
              },
              icon:
                  const Icon(Icons.sports_soccer_rounded, color: Colors.white),
              label: Text(
                  'Join Match (₹${game.perPlayerFee.toStringAsFixed(0)})',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),
        ],
      ],
    );
  }

  void _showJoinPaymentBottomSheet(
      BuildContext context, GameDetailsController controller, GameModel game) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Join Match & Pay Entry Fee',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Match Summary Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(game.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: context.textPrimary,
                                fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(
                          'Position: ${controller.selectedPosition.value} • ${game.clubName} (${game.courtName})',
                          style: TextStyle(
                              color: context.textSecondary, fontSize: 12),
                        ),
                        Divider(color: context.borderColor, height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Entry Fee Payable:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: context.textPrimary)),
                            Text('₹${game.perPlayerFee.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                    fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Select Payment Option
                  Text(
                    'Select Payment Method',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary),
                  ),
                  const SizedBox(height: 8),

                  Obx(() {
                    final selected = controller.selectedJoinPaymentMethod.value;
                    return Container(
                      decoration: BoxDecoration(
                        color: context.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            onTap: () => controller
                                .selectedJoinPaymentMethod.value = 'RAZORPAY',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    selected == 'RAZORPAY'
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: selected == 'RAZORPAY'
                                        ? AppColors.primary
                                        : context.textSecondary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text('Razorpay Gateway (UPI, Cards)',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 2),
                                        Text(
                                            'Supports GooglePay, PhonePe, Cards & Test Mode',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(color: context.borderColor, height: 1),
                          InkWell(
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(12)),
                            onTap: () => controller
                                .selectedJoinPaymentMethod.value = 'WALLET',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    selected == 'WALLET'
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: selected == 'WALLET'
                                        ? AppColors.primary
                                        : context.textSecondary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('SMASH UP INDIA Wallet',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Available Balance: ₹${controller.walletBalance.value.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: controller
                                                        .walletBalance.value >=
                                                    game.perPlayerFee
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
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  // Pay Action Button
                  Obx(
                    () => AppButton(
                      text:
                          'Pay ₹${game.perPlayerFee.toStringAsFixed(0)} & Join Roster',
                      isLoading: controller.isProcessingPayment.value,
                      onPressed: controller.executeJoinPaymentAndJoinGame,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Instant Test Payment Button
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      side: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.bolt_rounded, color: Colors.amber),
                    label: const Text(
                      '⚡ Quick Test Payment (Instant Success)',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                    onPressed: controller.isProcessingPayment.value
                        ? null
                        : controller.processTestModeJoinPayment,
                  ),
                ],
              ),
            ),

            // Payment Processing Overlay
            Obx(
              () => PaymentProcessingOverlay(
                isVisible: controller.isProcessingPayment.value,
                statusText: controller.paymentStatus.value,
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildHostCancelCard(
      BuildContext context, GameDetailsController controller, GameModel game) {
    if (!controller.isHost) return const SizedBox();

    final canCancel = controller.canHostCancel;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: canCancel
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canCancel
              ? Colors.redAccent.withValues(alpha: 0.5)
              : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                canCancel ? Icons.stars_rounded : Icons.lock_clock_rounded,
                color: canCancel ? Colors.redAccent : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                'Host Controls',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            canCancel
                ? 'You are the host of this match. You can cancel this match before match start time.'
                : 'Match start time has arrived/passed. As host, you can no longer cancel this match.',
            style: TextStyle(fontSize: 12.5, color: context.textSecondary),
          ),
          if (canCancel) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: () => _showHostCancelDialog(context, controller),
                icon: const Icon(Icons.cancel_rounded, color: Colors.white),
                label: const Text(
                  'Cancel Match (Host)',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showHostCancelDialog(
      BuildContext context, GameDetailsController controller) {
    final reasonController = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel Hosted Match?',
            style: TextStyle(
                color: context.textPrimary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel this match? Joined players will be notified and entry fees refunded.',
              style: TextStyle(color: context.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: reasonController,
              style: TextStyle(color: context.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Reason for Cancellation (Optional)',
                hintText: 'e.g. Schedule conflict',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Keep Match',
                style: TextStyle(color: context.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.back();
              controller.cancelMatchByHost(reasonController.text.trim());
            },
            child: const Text('Confirm Cancel',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection(
      BuildContext context, GameDetailsController controller, GameModel game) {
    final videoUrl = game.videoPlaybackUrl ??
        (controller.matchVideos.isNotEmpty
            ? controller.matchVideos.first.playbackUrl
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.videocam_rounded,
                color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              'CCTV Recorded Match Footage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (videoUrl != null && videoUrl.isNotEmpty) ...[
          Container(
            width: double.infinity,
            height: 190,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_circle_fill_rounded,
                      size: 60, color: AppColors.primary),
                  onPressed: () {
                    Get.toNamed('/videos/player', arguments: {
                      'videoUrl': videoUrl,
                      'title': game.title,
                    });
                  },
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${game.courtName} • Auto-recorded CCTV Video',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.borderColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'CCTV recording is processed automatically during the match and saved upon completion.',
                    style:
                        TextStyle(color: context.textSecondary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

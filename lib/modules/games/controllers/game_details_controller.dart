import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../repositories/games_repository.dart';
import '../../wallet/repositories/wallet_repository.dart';
import '../../wallet/datasources/wallet_remote_datasource.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/video_model.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../app/theme/app_colors.dart';

class GameDetailsController extends GetxController {
  final GamesRepository repository = Get.find<GamesRepository>();

  WalletRepository get _walletRepo {
    if (Get.isRegistered<WalletRepository>()) {
      return Get.find<WalletRepository>();
    } else {
      final dio = Get.find<DioClient>();
      final ds = WalletRemoteDataSource(dioClient: dio);
      return WalletRepository(remoteDataSource: ds);
    }
  }

  late Razorpay _razorpay;

  final Rxn<GameModel> game = Rxn<GameModel>();
  final RxList<GameRosterPlayerModel> teamARoster =
      <GameRosterPlayerModel>[].obs;
  final RxList<GameRosterPlayerModel> teamBRoster =
      <GameRosterPlayerModel>[].obs;
  final RxList<VideoModel> matchVideos = <VideoModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isJoining = false.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxString paymentStatus = ''.obs;

  final RxString selectedPosition = 'ST'.obs;
  final RxString selectedJoinPaymentMethod =
      'RAZORPAY'.obs; // 'RAZORPAY' or 'WALLET'
  final RxDouble walletBalance = 0.0.obs;

  String get gameId {
    final paramId = Get.parameters['id'];
    if (paramId != null && paramId.isNotEmpty) return paramId;

    final args = Get.arguments;
    if (args is String && args.isNotEmpty) return args;
    if (args is Map) {
      if (args['gameId'] != null) return args['gameId'].toString();
      if (args['id'] != null) return args['id'].toString();
    }
    return '';
  }

  @override
  void onInit() {
    super.onInit();
    _initRazorpay();
    if (gameId.isNotEmpty) {
      loadGameDetails();
    }
    fetchWalletBalance();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> fetchWalletBalance() async {
    try {
      final w = await _walletRepo.getWallet();
      walletBalance.value = w.balance;
    } catch (_) {
      walletBalance.value = 0.0;
    }
  }

  Future<void> loadGameDetails() async {
    if (gameId.isEmpty) return;
    isLoading.value = true;
    try {
      final g = await repository.getGameById(gameId);
      game.value = g;

      if (g.roster != null) {
        teamARoster.value = g.roster!.where((p) => p.team == 'TEAM_A').toList();
        teamBRoster.value = g.roster!.where((p) => p.team == 'TEAM_B').toList();
      }

      // Fetch CCTV recordings if available
      try {
        final vids = await repository.getGameVideos(gameId);
        matchVideos.value = vids;
      } catch (_) {}
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  bool get isUserInGame {
    final uid = AuthService.to.currentUser.value?.id;
    if (uid == null || game.value?.roster == null) return false;
    return game.value!.roster!.any((p) => p.userId == uid);
  }

  String? get userTeam {
    final uid = AuthService.to.currentUser.value?.id;
    if (uid == null || game.value?.roster == null) return null;
    final match = game.value!.roster!.firstWhereOrNull((p) => p.userId == uid);
    return match?.team;
  }

  bool get isManagerOrAdmin {
    final role = AuthService.to.currentUser.value?.roleId;
    return role == 1 || role == 2;
  }

  /// Trigger Join Match Action
  void requestJoinMatch(BuildContext context, VoidCallback showSheetCallback) {
    final fee = game.value?.perPlayerFee ?? 200.0;

    if (fee <= 0 || isManagerOrAdmin) {
      // Free match or Manager/Admin -> Join directly
      _executeJoinGameOnServer(position: selectedPosition.value);
    } else {
      // Player -> Show Payment Checkout Sheet
      showSheetCallback();
    }
  }

  /// Execute Join Payment via Razorpay or Wallet
  Future<void> executeJoinPaymentAndJoinGame() async {
    final fee = game.value?.perPlayerFee ?? 200.0;

    if (selectedJoinPaymentMethod.value == 'WALLET') {
      try {
        final w = await _walletRepo.getWallet();
        if (!w.hasPin) {
          ErrorHandler.showErrorSnackBar(
            'PIN Setup Required',
            'Wallet 6-digit PIN setup is required before making payments. Please set up your PIN in Player Wallet.',
          );
          return;
        }
      } catch (_) {}

      if (walletBalance.value < fee) {
        ErrorHandler.showErrorSnackBar(
          'Insufficient Wallet Balance',
          'Your wallet balance is ₹${walletBalance.value.toStringAsFixed(0)}. Please choose Razorpay.',
        );
        return;
      }

      _promptPinAndAuthorizeWalletPayment(fee: fee);
      return;
    }

    // Razorpay Online Payment Gateway
    isProcessingPayment.value = true;
    paymentStatus.value = 'Creating Order...';

    try {
      final idempotencyKey =
          'join_pay_${DateTime.now().millisecondsSinceEpoch}';
      final order = await _walletRepo.createTopupOrder(fee, idempotencyKey);

      final user = AuthService.to.currentUser.value;
      final contact =
          (user != null && user.phone.isNotEmpty) ? user.phone : '9876543210';
      final email = (user != null && user.email.isNotEmpty)
          ? user.email
          : 'player@allstarsarena.com';

      final key =
          order.keyId.isNotEmpty ? order.keyId : ApiConstants.razorpayKey;

      final options = {
        'key': key,
        'amount':
            order.amountPaisa > 0 ? order.amountPaisa : (fee * 100).toInt(),
        'name': 'SMASH UP INDIA',
        'description':
            'Player Entry Fee - ${game.value?.title ?? "Football Match"}',
        'order_id': order.orderId,
        'retry': {'enabled': true, 'max_count': 1},
        'prefill': {
          'contact': contact,
          'email': email,
        },
        'theme': {'color': '#2EA44F'},
      };

      paymentStatus.value = 'Waiting for Payment...';
      _razorpay.open(options);
    } catch (e) {
      isProcessingPayment.value = false;
      ErrorHandler.showErrorSnackBar('Payment Error', e);
    }
  }

  void _promptPinAndAuthorizeWalletPayment({required double fee}) {
    final pinController = TextEditingController();

    Get.dialog(
      Builder(
        builder: (context) {
          return AlertDialog(
            backgroundColor: context.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: context.borderColor),
            ),
            title: Row(
              children: [
                const Icon(Icons.shield_rounded,
                    color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text('Authorize Payment',
                    style: TextStyle(color: context.textPrimary, fontSize: 18)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your 6-digit Wallet PIN to authorize payment of ₹${fee.toStringAsFixed(0)}.',
                  style: TextStyle(color: context.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: TextStyle(
                      color: context.textPrimary, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Enter 6-digit PIN',
                    hintStyle:
                        TextStyle(color: context.textSecondary, fontSize: 13),
                    counterText: '',
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: AppColors.primary),
                    filled: true,
                    fillColor: context.backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.borderColor),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancel',
                    style: TextStyle(color: context.textSecondary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  final pin = pinController.text.trim();
                  if (pin.length != 6) {
                    ErrorHandler.showErrorSnackBar(
                        'Invalid PIN', 'Please enter a 6-digit PIN');
                    return;
                  }

                  try {
                    Get.back();
                    isProcessingPayment.value = true;
                    paymentStatus.value = 'Authorizing & Joining Match...';
                    await _executeJoinGameOnServer(
                      position: selectedPosition.value,
                      paymentMethod: 'WALLET',
                      walletPin: pin,
                    );
                  } catch (e) {
                    isProcessingPayment.value = false;
                    ErrorHandler.showErrorSnackBar('Authorization Failed', e);
                  }
                },
                child: const Text('Authorize & Pay',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Instant Test Mode Payment Execution
  Future<void> processTestModeJoinPayment() async {
    isProcessingPayment.value = true;
    paymentStatus.value = 'Opening Razorpay (Test Mode)...';
    await Future.delayed(const Duration(milliseconds: 600));

    paymentStatus.value = 'Verifying Payment...';
    await Future.delayed(const Duration(milliseconds: 600));

    paymentStatus.value = 'Finalizing Match Roster...';
    await Future.delayed(const Duration(milliseconds: 500));

    await _executeJoinGameOnServer(
      position: selectedPosition.value,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    paymentStatus.value = 'Verifying Payment & Finalizing Roster...';

    try {
      if (response.orderId != null && response.orderId!.isNotEmpty) {
        try {
          await _walletRepo.verifyTopupPayment(
            razorpayOrderId: response.orderId!,
            razorpayPaymentId: response.paymentId ?? '',
            razorpaySignature: response.signature ?? '',
          );
        } catch (_) {}
      }

      await _executeJoinGameOnServer(
        position: selectedPosition.value,
        paymentMethod: 'RAZORPAY',
        razorpayOrderId: response.orderId,
        razorpayPaymentId: response.paymentId,
        razorpaySignature: response.signature,
      );
    } catch (e) {
      isProcessingPayment.value = false;
      ErrorHandler.showErrorSnackBar('Join Payment Failed', e);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isProcessingPayment.value = false;
    AppLogger.error(
        '❌ Razorpay Payment Error: ${response.code} - ${response.message}');
    ErrorHandler.showErrorSnackBar(
      'Payment Failed',
      response.message ?? 'Payment was cancelled or failed.',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    AppLogger.info('External wallet selected: ${response.walletName}');
  }

  Future<void> _executeJoinGameOnServer({
    required String position,
    String? paymentMethod,
    String? walletPin,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    String? razorpaySignature,
  }) async {
    try {
      await repository.joinGame(
        gameId,
        position,
        paymentMethod: paymentMethod ?? 'WALLET',
        walletPin: walletPin,
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      );
      await loadGameDetails();
      await fetchWalletBalance();

      isProcessingPayment.value = false;
      if (Get.isBottomSheetOpen == true) Get.back();

      ErrorHandler.showSuccessSnackBar(
        'Match Joined!',
        'You have successfully joined in position $position!',
      );
    } catch (e) {
      isProcessingPayment.value = false;
      ErrorHandler.showErrorSnackBar('Join Error', e);
    }
  }

  Future<void> switchTeam() async {
    isJoining.value = true;
    try {
      await repository.switchTeam(gameId);
      await loadGameDetails();
      ErrorHandler.showSuccessSnackBar(
        'Team Switched',
        'You have successfully switched sides!',
      );
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Switch Error', e);
    } finally {
      isJoining.value = false;
    }
  }

  Future<void> leaveMatch() async {
    isJoining.value = true;
    try {
      await repository.leaveGame(gameId);
      await loadGameDetails();
      await fetchWalletBalance();
      ErrorHandler.showSuccessSnackBar(
        'Left Match',
        'You have left the match roster.',
      );
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Leave Error', e);
    } finally {
      isJoining.value = false;
    }
  }

  Future<void> joinWaitlist() async {
    isJoining.value = true;
    try {
      final res = await repository.joinWaitlist(gameId, selectedPosition.value);
      await loadGameDetails();
      final pos = res['queuePosition'] ?? res['position'] ?? '1';
      ErrorHandler.showSuccessSnackBar(
        'Joined Waitlist',
        'You are currently #$pos on the reserve waitlist.',
      );
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Waitlist Error', e);
    } finally {
      isJoining.value = false;
    }
  }

  Future<void> leaveWaitlist() async {
    isJoining.value = true;
    try {
      await repository.leaveWaitlist(gameId);
      await loadGameDetails();
      ErrorHandler.showSuccessSnackBar(
        'Left Waitlist',
        'You have been removed from the reserve waitlist.',
      );
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isJoining.value = false;
    }
  }

  bool get isHost {
    final uid = AuthService.to.currentUser.value?.id;
    if (uid == null || game.value == null) return false;
    return game.value!.creatorId == uid;
  }

  bool get canHostCancel {
    final g = game.value;
    if (g == null || !isHost) return false;
    if (g.status == 'CANCELLED' ||
        g.status == 'COMPLETED' ||
        g.status == 'ONGOING' ||
        g.status == 'STARTED') {
      return false;
    }
    return AppDateUtils.isMatchInFuture(g.matchDate, g.startTime);
  }

  Future<void> cancelMatchByHost(String reason) async {
    isJoining.value = true;
    try {
      await repository.cancelPlayerGame(gameId, reason);
      await loadGameDetails();
      await fetchWalletBalance();
      ErrorHandler.showSuccessSnackBar(
        'Match Cancelled',
        'Your hosted match has been cancelled and entry fees refunded.',
      );
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Cancellation Error', e);
    } finally {
      isJoining.value = false;
    }
  }
}

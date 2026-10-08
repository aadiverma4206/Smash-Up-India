import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../repositories/wallet_repository.dart';
import '../../../data/models/wallet_models.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/utils/app_logger.dart';

class WalletController extends GetxController {
  final WalletRepository repository = Get.find<WalletRepository>();

  late Razorpay _razorpay;

  final Rxn<WalletBalanceModel> wallet = Rxn<WalletBalanceModel>();
  final RxList<WalletTransactionModel> transactions =
      <WalletTransactionModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString selectedTopupAmount = '1000'.obs;
  final RxnString currentPaymentOrderId = RxnString();
  final RxnString currentRazorpayOrderId = RxnString();

  @override
  void onInit() {
    super.onInit();
    _initRazorpay();
    fetchWalletDetails();
    fetchTransactions();
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

  Future<void> fetchWalletDetails() async {
    isLoading.value = true;
    try {
      final w = await repository.getWallet();
      wallet.value = w;
    } catch (e) {
      AppLogger.warning('Failed to fetch wallet balance: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactions() async {
    try {
      final list = await repository.getTransactions();
      transactions.assignAll(list);
    } catch (e) {
      AppLogger.warning('Failed to fetch wallet transactions: $e');
    }
  }

  /// Top-up Flow Step 1: Create Order on Backend (No PIN required)
  Future<void> initiateTopup(double amountRupees) async {
    if (amountRupees <= 0 || amountRupees > 50000) {
      ErrorHandler.showErrorSnackBar(
          'Invalid Amount', 'Top-up amount must be between ₹1 and ₹50,000');
      return;
    }

    selectedTopupAmount.value = amountRupees.toStringAsFixed(0);
    isLoading.value = true;

    try {
      final idempotencyKey = 'topup_${DateTime.now().millisecondsSinceEpoch}';
      final order =
          await repository.createTopupOrder(amountRupees, idempotencyKey);

      currentPaymentOrderId.value = order.paymentOrderId;
      currentRazorpayOrderId.value = order.orderId;

      final keyToUse =
          order.keyId.isNotEmpty ? order.keyId : 'rzp_test_Sb44esbmpGlzBd';

      final options = {
        'key': keyToUse,
        'amount': order.amountPaisa > 0
            ? order.amountPaisa
            : (amountRupees * 100).toInt(),
        'name': 'SMASH UP INDIA',
        'description': 'Player Wallet Topup',
        'order_id': order.orderId,
        'prefill': {
          'contact': '+919876543210',
          'email': 'player@allstarsarena.com',
        },
        'theme': {'color': '#2EA44F'},
      };

      _razorpay.open(options);
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Top-up Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Razorpay Payment Success Callback -> Sends signatures to Backend for Verification
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    isLoading.value = true;
    Get.toNamed('/payment/processing');

    try {
      final razorpayOrderIdToUse =
          (response.orderId != null && response.orderId!.isNotEmpty)
              ? response.orderId!
              : (currentRazorpayOrderId.value ?? '');

      final updatedWallet = await repository.verifyTopupPayment(
        razorpayOrderId: razorpayOrderIdToUse,
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
        paymentOrderId: currentPaymentOrderId.value,
      );

      wallet.value = updatedWallet;
      await fetchWalletDetails();
      await fetchTransactions();
      Get.offNamed('/payment/result',
          arguments: {'success': true, 'amount': selectedTopupAmount.value});
    } catch (e) {
      Get.offNamed('/payment/result', arguments: {
        'success': false,
        'error': ErrorHandler.getErrorMessage(e)
      });
    } finally {
      isLoading.value = false;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    AppLogger.error(
        '❌ Razorpay Payment Error: ${response.code} - ${response.message}');
    Get.offNamed('/payment/result', arguments: {
      'success': false,
      'error': response.message ?? 'Payment failed'
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    AppLogger.info('External wallet selected: ${response.walletName}');
  }

  Future<void> setupWalletPin(String pin) async {
    if (pin.length != 6) {
      ErrorHandler.showErrorSnackBar(
          'Invalid PIN', 'Wallet PIN must be exactly 6 digits');
      return;
    }

    isLoading.value = true;
    try {
      await repository.setupPin(pin);
      await fetchWalletDetails();
      if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
        Get.back();
      }
      ErrorHandler.showSuccessSnackBar(
          'PIN Setup', 'Wallet 6-digit PIN created successfully!');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('PIN Setup Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeWalletPin(String oldPin, String newPin) async {
    if (oldPin.length != 6 || newPin.length != 6) {
      ErrorHandler.showErrorSnackBar(
          'Invalid PIN', 'Old and New PINs must both be exactly 6 digits');
      return;
    }

    if (oldPin == newPin) {
      ErrorHandler.showErrorSnackBar(
          'Invalid New PIN', 'New PIN must be different from current PIN');
      return;
    }

    isLoading.value = true;
    try {
      await repository.changePin(oldPin, newPin);
      await fetchWalletDetails();
      if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
        Get.back();
      }
      ErrorHandler.showSuccessSnackBar(
          'PIN Updated', 'Wallet 6-digit PIN changed successfully!');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('PIN Change Error', e);
    } finally {
      isLoading.value = false;
    }
  }
}

import '../../../core/network/dio_client.dart';
import '../../../core/storage/local_database_helper.dart';
import '../../../data/models/wallet_models.dart';

class WalletRemoteDataSource {
  final DioClient dioClient;
  final LocalDatabaseHelper _db = LocalDatabaseHelper.instance;

  WalletRemoteDataSource({required this.dioClient});

  Future<WalletBalanceModel> getWallet() async {
    final balance = await _db.getWalletBalance();
    return WalletBalanceModel(
      balance: balance,
      hasPin: true,
    );
  }

  Future<List<WalletTransactionModel>> getTransactions(
      {int page = 1, int limit = 50}) async {
    final list = await _db.getTransactions();
    if (list.isEmpty) {
      return [
        WalletTransactionModel(
          id: 'tx_1',
          transactionType: 'TOPUP',
          amount: 5000.0,
          balanceAfter: 5000.0,
          description: 'SMASH UP INDIA Welcome Bonus',
          status: 'SUCCESS',
          createdAt: DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
        ),
      ];
    }
    return list
        .map((m) => WalletTransactionModel(
              id: m['id'].toString(),
              transactionType: 'TOPUP',
              amount: double.tryParse(m['amount'].toString()) ?? 0.0,
              balanceAfter: double.tryParse(m['amount'].toString()) ?? 0.0,
              description: m['title'].toString(),
              status: m['status'].toString(),
              createdAt: m['date'].toString(),
            ))
        .toList();
  }

  Future<RazorpayOrderModel> createTopupOrder(
      double amount, String idempotencyKey) async {
    return RazorpayOrderModel(
      paymentOrderId: 'pay_order_${DateTime.now().millisecondsSinceEpoch}',
      orderId: 'order_smash_${DateTime.now().millisecondsSinceEpoch}',
      amountPaisa: (amount * 100).toInt(),
      currency: 'INR',
      keyId: 'rzp_test_SmashUpIndia',
    );
  }

  Future<WalletBalanceModel> verifyTopupPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    String? paymentOrderId,
  }) async {
    final current = await _db.getWalletBalance();
    const topupAmount = 1000.0;
    final newBalance = current + topupAmount;
    await _db.setWalletBalance(newBalance);

    await _db.addTransaction({
      'id': 'tx_${DateTime.now().millisecondsSinceEpoch}',
      'title': 'Wallet Top-up via Razorpay',
      'amount': topupAmount,
      'type': 'CREDIT',
      'date': DateTime.now().toIso8601String(),
      'status': 'SUCCESS',
    });

    return WalletBalanceModel(
      balance: newBalance,
      hasPin: true,
    );
  }

  Future<void> setupPin(String pin) async {}
  Future<void> changePin(String oldPin, String newPin) async {}
}

import '../datasources/wallet_remote_datasource.dart';
import '../../../data/models/wallet_models.dart';

class WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepository({required this.remoteDataSource});

  Future<WalletBalanceModel> getWallet() async {
    return await remoteDataSource.getWallet();
  }

  Future<List<WalletTransactionModel>> getTransactions(
      {int page = 1, int limit = 50}) async {
    return await remoteDataSource.getTransactions(page: page, limit: limit);
  }

  Future<RazorpayOrderModel> createTopupOrder(
      double amount, String idempotencyKey) async {
    return await remoteDataSource.createTopupOrder(amount, idempotencyKey);
  }

  Future<WalletBalanceModel> verifyTopupPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    String? paymentOrderId,
  }) async {
    return await remoteDataSource.verifyTopupPayment(
      razorpayPaymentId: razorpayPaymentId,
      razorpayOrderId: razorpayOrderId,
      razorpaySignature: razorpaySignature,
      paymentOrderId: paymentOrderId,
    );
  }

  Future<void> setupPin(String pin) async {
    return await remoteDataSource.setupPin(pin);
  }

  Future<void> changePin(String oldPin, String newPin) async {
    return await remoteDataSource.changePin(oldPin, newPin);
  }
}

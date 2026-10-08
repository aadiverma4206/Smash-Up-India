import 'package:flutter_test/flutter_test.dart';
import 'package:all_stars_arena/data/models/wallet_models.dart';

void main() {
  group('ALL STARS ARENA Wallet & Razorpay Module Unit Tests', () {
    test('WalletBalanceModel deserializes backend balance correctly', () {
      final json = {
        'balance': 2500.50,
        'hasPin': true,
        'status': 'ACTIVE',
        'maxBalanceLimit': 200000.0,
        'maxSingleTopup': 50000.0,
      };

      final wallet = WalletBalanceModel.fromJson(json);
      expect(wallet.balance, 2500.50);
      expect(wallet.hasPin, isTrue);
      expect(wallet.maxSingleTopup, 50000.0);
    });

    test('RazorpayOrderModel parses backend Razorpay order payload', () {
      final json = {
        'orderId': 'order_M101XYZ',
        'amountPaisa': 100000,
        'currency': 'INR',
        'keyId': 'rzp_test_key_123456',
      };

      final order = RazorpayOrderModel.fromJson(json);
      expect(order.orderId, 'order_M101XYZ');
      expect(order.amountPaisa, 100000);
      expect(order.currency, 'INR');
    });

    test('WalletTransactionModel deserializes topup and debit records', () {
      final json = {
        'id': 'tx_901',
        'transactionType': 'TOPUP',
        'amount': 1000.0,
        'balanceAfter': 2500.50,
        'description': 'Razorpay Wallet Topup',
        'status': 'SUCCESS',
        'createdAt': '2026-09-28T18:30:00Z',
      };

      final tx = WalletTransactionModel.fromJson(json);
      expect(tx.id, 'tx_901');
      expect(tx.transactionType, 'TOPUP');
      expect(tx.amount, 1000.0);
      expect(tx.status, 'SUCCESS');
    });
  });
}

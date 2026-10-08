import 'package:json_annotation/json_annotation.dart';

part 'wallet_models.g.dart';

@JsonSerializable(createFactory: false)
class WalletBalanceModel {
  final double balance;
  final bool hasPin;
  final String status;
  final double maxBalanceLimit;
  final double maxSingleTopup;

  WalletBalanceModel({
    required this.balance,
    required this.hasPin,
    this.status = 'ACTIVE',
    this.maxBalanceLimit = 200000.0,
    this.maxSingleTopup = 50000.0,
  });

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
      balance:
          (json['walletBalance'] ?? json['balance'] as num?)?.toDouble() ?? 0.0,
      hasPin:
          (json['isPinSet'] ?? json['hasPin'] ?? json['is_pin_set'] ?? false) ==
              true,
      status: (json['status'] ?? 'ACTIVE') as String,
      maxBalanceLimit:
          (json['maxWalletBalance'] ?? json['maxBalanceLimit'] as num?)
                  ?.toDouble() ??
              200000.0,
      maxSingleTopup: (json['maxSingleTopup'] as num?)?.toDouble() ?? 50000.0,
    );
  }

  Map<String, dynamic> toJson() => _$WalletBalanceModelToJson(this);
}

@JsonSerializable(createFactory: false)
class RazorpayOrderModel {
  final String paymentOrderId;
  final String orderId;
  final int amountPaisa;
  final String currency;
  final String keyId;

  RazorpayOrderModel({
    this.paymentOrderId = '',
    required this.orderId,
    required this.amountPaisa,
    this.currency = 'INR',
    required this.keyId,
  });

  factory RazorpayOrderModel.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderModel(
      paymentOrderId: (json['paymentOrderId'] ??
          json['payment_order_id'] ??
          json['id'] ??
          '') as String,
      orderId: (json['razorpayOrderId'] ??
          json['orderId'] ??
          json['order_id'] ??
          '') as String,
      amountPaisa: (json['amountPaise'] ??
                  json['amountPaisa'] ??
                  json['amount_paise'] ??
                  json['amount_paisa'] as num?)
              ?.toInt() ??
          0,
      currency: (json['currency'] ?? 'INR') as String,
      keyId: (json['razorpayKeyId'] ?? json['keyId'] ?? json['key_id'] ?? '')
          as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'paymentOrderId': paymentOrderId,
        'orderId': orderId,
        'amountPaisa': amountPaisa,
        'currency': currency,
        'keyId': keyId,
      };
}

@JsonSerializable(createFactory: false)
class WalletTransactionModel {
  final String id;
  final String transactionType; // TOPUP, DEBIT, REFUND, CASHBACK
  final double amount;
  final double balanceAfter;
  final String description;
  final String status; // SUCCESS, FAILED, PENDING
  final String? referenceId;
  final String? providerPaymentId;
  final String createdAt;

  WalletTransactionModel({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.balanceAfter,
    required this.description,
    required this.status,
    this.referenceId,
    this.providerPaymentId,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: (json['id'] ?? json['transaction_id'] ?? '') as String,
      transactionType: (json['transactionType'] ??
          json['transaction_type'] ??
          'TOPUP') as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      balanceAfter:
          (json['balanceAfter'] ?? json['balance_after'] as num?)?.toDouble() ??
              0.0,
      description: (json['description'] ?? 'Wallet transaction') as String,
      status: (json['status'] ?? 'SUCCESS') as String,
      referenceId: (json['referenceId'] ?? json['reference_id']) as String?,
      providerPaymentId: (json['providerPaymentId'] ??
          json['provider_payment_id'] ??
          json['razorpay_payment_id']) as String?,
      createdAt: (json['createdAt'] ?? json['created_at'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => _$WalletTransactionModelToJson(this);
}

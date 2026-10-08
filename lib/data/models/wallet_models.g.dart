// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletBalanceModel _$WalletBalanceModelFromJson(Map<String, dynamic> json) =>
    WalletBalanceModel(
      balance: (json['balance'] as num).toDouble(),
      hasPin: json['hasPin'] as bool,
      status: json['status'] as String? ?? 'ACTIVE',
      maxBalanceLimit:
          (json['maxBalanceLimit'] as num?)?.toDouble() ?? 200000.0,
      maxSingleTopup: (json['maxSingleTopup'] as num?)?.toDouble() ?? 50000.0,
    );

Map<String, dynamic> _$WalletBalanceModelToJson(WalletBalanceModel instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'hasPin': instance.hasPin,
      'status': instance.status,
      'maxBalanceLimit': instance.maxBalanceLimit,
      'maxSingleTopup': instance.maxSingleTopup,
    };

RazorpayOrderModel _$RazorpayOrderModelFromJson(Map<String, dynamic> json) =>
    RazorpayOrderModel(
      orderId: json['orderId'] as String,
      amountPaisa: (json['amountPaisa'] as num).toInt(),
      currency: json['currency'] as String? ?? 'INR',
      keyId: json['keyId'] as String,
    );

Map<String, dynamic> _$RazorpayOrderModelToJson(RazorpayOrderModel instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'amountPaisa': instance.amountPaisa,
      'currency': instance.currency,
      'keyId': instance.keyId,
    };

WalletTransactionModel _$WalletTransactionModelFromJson(
        Map<String, dynamic> json) =>
    WalletTransactionModel(
      id: json['id'] as String,
      transactionType: json['transactionType'] as String,
      amount: (json['amount'] as num).toDouble(),
      balanceAfter: (json['balanceAfter'] as num).toDouble(),
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$WalletTransactionModelToJson(
        WalletTransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionType': instance.transactionType,
      'amount': instance.amount,
      'balanceAfter': instance.balanceAfter,
      'description': instance.description,
      'status': instance.status,
      'createdAt': instance.createdAt,
    };

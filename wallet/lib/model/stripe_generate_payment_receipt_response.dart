import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/query_helper.dart';

class StripeGeneratePaymentReceiptResponse {
  final bool success;
  final String purchaseID;
  final String processorName;
  final String payerAddr;
  final String amount;
  final String productID;
  final String signature;

  StripeGeneratePaymentReceiptResponse(
      {this.purchaseID = '',
      this.processorName = '',
      this.payerAddr = '',
      this.amount = '',
      this.productID = '',
      this.signature = '',
      this.success = false});

  factory StripeGeneratePaymentReceiptResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeGeneratePaymentReceiptResponse(
          productID: ret.value?.entries
              .firstWhere((entry) => entry.key == kProductID,
                  orElse: () => const MapEntry(kProductID, ''))
              .value as String,
          payerAddr: ret.value?.entries
              .firstWhere((entry) => entry.key == kPayerAddr,
                  orElse: () => const MapEntry(kPayerAddr, ''))
              .value as String,
          amount: ret.value?.entries
              .firstWhere((entry) => entry.key == kAmount,
                  orElse: () => const MapEntry(kAmount, ''))
              .value as String,
          signature: ret.value?.entries
              .firstWhere((entry) => entry.key == kSignature,
                  orElse: () => const MapEntry(kSignature, ''))
              .value as String,
          purchaseID: ret.value?.entries
              .firstWhere((entry) => entry.key == kPurchaseID,
                  orElse: () => const MapEntry(kPurchaseID, ''))
              .value as String,
          processorName: ret.value?.entries
              .firstWhere((entry) => entry.key == kProcessorName,
                  orElse: () => const MapEntry(kProcessorName, ''))
              .value as String,
          success: true);
    }
    return StripeGeneratePaymentReceiptResponse();
  }

  Map<String, dynamic> toJson() => {
        kPurchaseIdKey: purchaseID,
        kProcessorNameKey: processorName,
        kPayerAddrKey: payerAddr,
        kAmount: amount,
        kProductIdKey: productID,
        kSignature: signature
      };
}

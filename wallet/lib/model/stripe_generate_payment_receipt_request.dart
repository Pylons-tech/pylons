import 'package:pylons_wallet/utils/constants.dart';

class StripeGeneratePaymentReceiptRequest {
  final String paymentIntentID;
  final String clientSecret;

  StripeGeneratePaymentReceiptRequest({required this.paymentIntentID, required this.clientSecret});

  StripeGeneratePaymentReceiptRequest.fromJson(Map<String, dynamic> json)
      : paymentIntentID = json[kPaymentIntentId] as String,
        clientSecret = json[kClientSecret] as String;

  Map<String, dynamic> toJson() => {kPaymentIntentId: paymentIntentID, kClientSecret: clientSecret};
}

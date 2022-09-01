class StripeGeneratePaymentReceiptRequest {
  final String paymentIntentID;
  final String clientSecret;

  StripeGeneratePaymentReceiptRequest({required this.paymentIntentID, required this.clientSecret});

  StripeGeneratePaymentReceiptRequest.fromJson(Map<String, dynamic> json)
      : paymentIntentID = json['payment_intent_id'] as String,
        clientSecret = json['clientSecret'] as String;

  Map<String, dynamic> toJson() => {'payment_intent_id': paymentIntentID, 'client_secret': clientSecret};
}

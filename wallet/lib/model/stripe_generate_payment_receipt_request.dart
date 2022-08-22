class StripeGeneratePaymentReceiptRequest {
  final String paymentIntentID;
  final String clientSecret;

  StripeGeneratePaymentReceiptRequest(
      {required this.paymentIntentID, required this.clientSecret});

  Map<String, dynamic> toJson() =>
      {'payment_intent_id': paymentIntentID, 'client_secret': clientSecret};
}

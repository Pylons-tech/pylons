class StripeCreatePaymentIntentRequest {
  final String address;
  final String productID;
  final int coinInputIndex;

  StripeCreatePaymentIntentRequest(
      {required this.address,
      required this.productID,
      required this.coinInputIndex});

  Map<String, dynamic> toJson() => {
        'address': address,
        'productID': productID,
        'coin_inputs_index': coinInputIndex
      };
}

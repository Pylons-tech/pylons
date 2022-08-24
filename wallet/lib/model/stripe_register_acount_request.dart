class StripeRegisterAccountRequest {
  final String Address;
  final String Token;
  final String Signature;

  StripeRegisterAccountRequest(
      {required this.Address, required this.Token, required this.Signature});

  Map<String, dynamic> toJson() =>
      {'address': Address, 'token': Token, 'signature': Signature};
}

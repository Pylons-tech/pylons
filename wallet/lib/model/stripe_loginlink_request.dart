class StripeLoginLinkRequest {
  final String Account;
  final String Signature;

  StripeLoginLinkRequest({required this.Account, required this.Signature});

  Map<String, dynamic> toJson() => {'account': Account, 'signature': Signature};
}

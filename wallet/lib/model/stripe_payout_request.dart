import 'package:fixnum/fixnum.dart';

class StripePayoutRequest {
  final String address;
  final String token;
  final String signature;
  final Int64 amount;

  StripePayoutRequest(
      {this.address = '',
      this.token = '',
      this.signature = '',
      this.amount = Int64.ZERO});

  Map<String, dynamic> toJson() => {
        'address': address,
        'token': token,
        'signature': signature,
        'amount': amount.toInt()
      };
}

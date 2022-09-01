import 'package:fixnum/fixnum.dart';

class StripePayoutRequest {
  final String address;
  final String token;
  final String signature;
  final Int64 amount;

  StripePayoutRequest({this.address = '', this.token = '', this.signature = '', this.amount = Int64.ZERO});

  StripePayoutRequest.fromJson(Map<String, dynamic> json)
      : address = json['address'] as String,
        token = json['token'] as String,
        signature = json['signature'] as String,
        amount = json['amount'] as Int64;

  Map<String, dynamic> toJson() => {'address': address, 'token': token, 'signature': signature, 'amount': amount.toInt()};
}

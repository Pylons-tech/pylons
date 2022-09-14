import 'package:fixnum/fixnum.dart';
import 'package:pylons_wallet/utils/constants.dart';

class StripePayoutRequest {
  final String address;
  final String token;
  final String signature;
  final Int64 amount;

  StripePayoutRequest({this.address = '', this.token = '', this.signature = '', this.amount = Int64.ZERO});

  StripePayoutRequest.fromJson(Map<String, dynamic> json)
      : address = json[kAddressKey] as String,
        token = json[kTokenKey] as String,
        signature = json[kSignature] as String,
        amount = json[kAmount] as Int64;

  Map<String, dynamic> toJson() => {kAddressKey: address, kTokenKey: token, kSignature: signature, kAmount: amount.toInt()};
}

import 'package:fixnum/fixnum.dart';

class StripeGeneratePayoutTokenRequest {
  final String address;
  final Int64 amount;

  StripeGeneratePayoutTokenRequest(
      {required this.address, required this.amount});
}

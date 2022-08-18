import 'package:fixnum/fixnum.dart';
import 'package:pylons_wallet/utils/query_helper.dart';

class StripeGeneratePayoutTokenResponse {
  final String token;
  final Int64 RedeemAmount;
  final bool success;

  StripeGeneratePayoutTokenResponse({
    this.token = '',
    this.RedeemAmount = Int64.ZERO,
    this.success = false,
  });

  factory StripeGeneratePayoutTokenResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeGeneratePayoutTokenResponse(
          token: ret.value?.entries
              .firstWhere((entry) => entry.key == 'token',
                  orElse: () => const MapEntry('token', ''))
              .value as String,
          RedeemAmount: Int64.parseInt((ret.value?.entries
                  .firstWhere((entry) => entry.key == 'RedeemAmount',
                      orElse: () => const MapEntry('RedeemAmount', 0))
                  .value as int)
              .toString()),
          success: true);
    }
    return StripeGeneratePayoutTokenResponse();
  }
}

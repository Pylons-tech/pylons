import 'package:pylons_wallet/utils/query_helper.dart';

class StripeCreatePaymentIntentResponse {
  final bool success;
  final String clientsecret;

  StripeCreatePaymentIntentResponse(
      {this.clientsecret = '', this.success = false});

  factory StripeCreatePaymentIntentResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeCreatePaymentIntentResponse(
          clientsecret: ret.value?.entries
              .firstWhere((entry) => entry.key == 'clientSecret',
                  orElse: () => const MapEntry('clientSecret', ''))
              .value as String,
          success: true);
    }
    return StripeCreatePaymentIntentResponse();
  }
}

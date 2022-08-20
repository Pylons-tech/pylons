import 'package:pylons_wallet/utils/query_helper.dart';

class StripeGenerateRegistrationTokenResponse {
  final bool success;
  final String token;

  StripeGenerateRegistrationTokenResponse(
      {this.token = '', this.success = false});

  factory StripeGenerateRegistrationTokenResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeGenerateRegistrationTokenResponse(
          token: ret.value?.entries
              .firstWhere((entry) => entry.key == 'token',
                  orElse: () => const MapEntry('token', ''))
              .value as String,
          success: true);
    }
    return StripeGenerateRegistrationTokenResponse();
  }

  factory StripeGenerateRegistrationTokenResponse.fromJson(
      Map<String, dynamic> ret) {
    return StripeGenerateRegistrationTokenResponse(
        token: ret.entries
            .firstWhere((entry) => entry.key == 'token',
                orElse: () => const MapEntry('token', ''))
            .value as String,
        success: true);
  }
}

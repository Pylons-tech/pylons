import 'package:pylons_wallet/utils/query_helper.dart';

class StripeGenerateUpdateTokenResponse {
  final String token;
  final bool success;

  StripeGenerateUpdateTokenResponse({
    this.token = '',
    this.success = false,
  });

  factory StripeGenerateUpdateTokenResponse.from(RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeGenerateUpdateTokenResponse(token: ret.value?.entries.firstWhere((entry) => entry.key == 'token', orElse: () => const MapEntry('token', '')).value as String, success: true);
    }
    return StripeGenerateUpdateTokenResponse();
  }

  factory StripeGenerateUpdateTokenResponse.fromJson(Map<String, dynamic> ret) {
    return StripeGenerateUpdateTokenResponse(token: ret.entries.firstWhere((entry) => entry.key == 'token', orElse: () => const MapEntry('token', '')).value as String, success: true);
  }
}

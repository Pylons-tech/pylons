import 'package:pylons_wallet/utils/query_helper.dart';

class StripeLoginLinkResponse {
  final String accountlink;
  final String account;
  final bool success;

  StripeLoginLinkResponse(
      {this.accountlink = '', this.account = '', this.success = false});

  factory StripeLoginLinkResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeLoginLinkResponse(
          accountlink: ret.value?.entries
              .firstWhere((entry) => entry.key == 'accountlink',
                  orElse: () => const MapEntry('accountlink', ''))
              .value as String,
          account: ret.value?.entries
              .firstWhere((entry) => entry.key == 'account',
                  orElse: () => const MapEntry('account', ''))
              .value as String,
          success: true);
    }
    return StripeLoginLinkResponse();
  }
}

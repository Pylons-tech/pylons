import 'package:pylons_wallet/utils/query_helper.dart';

class StripeAccountLinkResponse {
  final String accountlink;
  final String account;
  final bool success;

  StripeAccountLinkResponse(
      {this.accountlink = '', this.account = '', this.success = false});

  factory StripeAccountLinkResponse.from(
      RequestResult<Map<String, dynamic>> ret) {
    if (ret.isSuccessful && ret.value != null) {
      return StripeAccountLinkResponse(
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
    return StripeAccountLinkResponse();
  }
}
